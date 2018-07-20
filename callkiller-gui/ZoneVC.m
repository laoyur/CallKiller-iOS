//
//  ZoneVC.m
//  callkiller-gui
//
//  Created by mac on 2018/7/18.
//

#import "ZoneVC.h"
#import "Preference.h"

@interface ZoneProvinceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *enabled;
@property (copy, nonatomic) NSString *group;
@end

@implementation ZoneProvinceCell

- (IBAction)onSwitchChanged:(UISwitch*)sender {
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    if (sender.isOn) {
        if (!pref[kKeyBlockedGroups])
            pref[kKeyBlockedGroups] = [NSMutableArray new];
        if (![pref[kKeyBlockedGroups] containsObject:self.group]) {
            [pref[kKeyBlockedGroups] addObject:self.group];
        }
    } else {
        if ([pref[kKeyBlockedGroups] containsObject:self.group]) {
            [pref[kKeyBlockedGroups] removeObject:self.group];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"group-blocking-changed"
                                                        object:nil
                                                      userInfo:@{ @"group": self.group,
                                                                  @"enabled": @(sender.isOn)
                                                                  }];
}

@end

@interface ZoneCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *enabled;
@property (copy, nonatomic) NSString *groupKey;
@property (copy, nonatomic) NSString *cityKey;
@end

@implementation ZoneCityCell

- (IBAction)onSwitchChanged:(UISwitch*)sender {
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    if (sender.isOn) {
        if (!pref[kKeyBlockedCities])
            pref[kKeyBlockedCities] = [NSMutableDictionary new];
        if (!pref[kKeyBlockedCities][self.groupKey])
            pref[kKeyBlockedCities][self.groupKey] = [NSMutableArray new];
        if (![pref[kKeyBlockedCities][self.groupKey] containsObject:self.cityKey]) {
            [pref[kKeyBlockedCities][self.groupKey] addObject:self.cityKey];
        }
        if (!pref[kKeyBlockedCitiesFlattened])
            pref[kKeyBlockedCitiesFlattened] = [NSMutableArray new];
        if (![pref[kKeyBlockedCitiesFlattened] containsObject:self.cityKey]) {
            [pref[kKeyBlockedCitiesFlattened] addObject:self.cityKey];
        }
    } else {
        if ([pref[kKeyBlockedCities][self.groupKey] containsObject:self.cityKey]) {
            [pref[kKeyBlockedCities][self.groupKey] removeObject:self.cityKey];
        }
        if ([pref[kKeyBlockedCitiesFlattened] containsObject:self.cityKey]) {
            [pref[kKeyBlockedCitiesFlattened] removeObject:self.cityKey];
        }
    }
    [[Preference sharedInstance] save];
}

@end

@interface ZoneVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (copy, nonatomic) NSArray *cityGroups;

@end

@implementation ZoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    NSArray *groups = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:kNilOptions error:nil];
    
    // 初始化每个分组的allCityKeys
    NSMutableArray *finalGroups = [NSMutableArray new];
    for (NSDictionary *group in groups) {
        NSMutableDictionary *finalGroup = [group mutableCopy];
        finalGroup[@"allCityKeys"] = [[group[@"cities"] allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 compare:key2];
        }];
        [finalGroups addObject:finalGroup];
    }
    self.cityGroups = finalGroups;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"group-blocking-changed" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSDictionary *info = note.userInfo;
        for (NSDictionary *g in self.cityGroups) {
            if ([g[@"group"] isEqualToString:info[@"group"]]) {
                if ([info[@"enabled"] boolValue]) {
                    // 启用按省拦截
                    if (!pref[kKeyBlockedCitiesFlattened])
                        pref[kKeyBlockedCitiesFlattened] = [NSMutableArray new];
                    for (NSString *cityKey in g[@"allCityKeys"]) {
                        if (![pref[kKeyBlockedCitiesFlattened] containsObject:cityKey]) {
                            [pref[kKeyBlockedCitiesFlattened] addObject:cityKey];
                        }
                    }
                } else {
                    // 禁用按省拦截
                    for (NSString *cityKey in g[@"allCityKeys"]) {
                        if (![pref[kKeyBlockedCities][g[@"group"]] containsObject:cityKey]) {
                            [pref[kKeyBlockedCitiesFlattened] removeObject:cityKey];
                        }
                    }
                }
                break;
            }
        }
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroups.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.cityGroups[section][@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cityGroups[section][@"cities"] allKeys].count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *group = self.cityGroups[indexPath.section];
    NSString *groupKey = group[@"group"];
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    
    if (indexPath.row == 0) {
        ZoneProvinceCell *provinceCell = [tableView dequeueReusableCellWithIdentifier:@"cell.province"];
        provinceCell.group = groupKey;
        [provinceCell.enabled setOn:[pref[kKeyBlockedGroups] containsObject:groupKey]];
        return provinceCell;
    }
    ZoneCityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:@"cell.city"];
    
    NSString *cityKey = group[@"allCityKeys"][indexPath.row - 1];
    cityCell.name.text = [NSString stringWithFormat:@"%@ %@", cityKey, group[@"cities"][cityKey]];
    cityCell.groupKey = groupKey;
    cityCell.cityKey = cityKey;
    
    // switch状态
    [cityCell.enabled setOn:[pref[kKeyBlockedCities][groupKey] containsObject:cityKey]];
    
    // 此城市是否已被按省拦截
    cityCell.enabled.enabled = ![pref[kKeyBlockedGroups] containsObject:groupKey];
    
    return cityCell;
}

@end
