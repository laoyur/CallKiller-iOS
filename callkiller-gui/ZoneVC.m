//
//  ZoneVC.m
//  callkiller-gui
//
//  Created by mac on 2018/7/18.
//

#import "ZoneVC.h"
#import "Preference.h"
#import "statics.h"

@interface ZoneProvinceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *enabled;
@property (copy, nonatomic) NSString *group;
@property (nonatomic) BOOL forMobile;
@end

@implementation ZoneProvinceCell

- (IBAction)onSwitchChanged:(UISwitch*)sender {
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    if (sender.isOn) {
        if (self.forMobile) {
            if (!pref[kKeyMobileBlockedGroups])
                pref[kKeyMobileBlockedGroups] = [NSMutableArray new];
            if (![pref[kKeyMobileBlockedGroups] containsObject:self.group]) {
                [pref[kKeyMobileBlockedGroups] addObject:self.group];
            }
        } else {
            if (!pref[kKeyBlockedGroups])
                pref[kKeyBlockedGroups] = [NSMutableArray new];
            if (![pref[kKeyBlockedGroups] containsObject:self.group]) {
                [pref[kKeyBlockedGroups] addObject:self.group];
            }
        }
    } else {
        if (self.forMobile) {
            if ([pref[kKeyMobileBlockedGroups] containsObject:self.group]) {
                [pref[kKeyMobileBlockedGroups] removeObject:self.group];
            }
        } else {
            if ([pref[kKeyBlockedGroups] containsObject:self.group]) {
                [pref[kKeyBlockedGroups] removeObject:self.group];
            }
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
@property (nonatomic) BOOL forMobile;
@end

@implementation ZoneCityCell

- (IBAction)onSwitchChanged:(UISwitch*)sender {
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    if (sender.isOn) {
        if (self.forMobile) {
            if (!pref[kKeyMobileBlockedCities])
                pref[kKeyMobileBlockedCities] = [NSMutableDictionary new];
            if (!pref[kKeyMobileBlockedCities][self.groupKey])
                pref[kKeyMobileBlockedCities][self.groupKey] = [NSMutableArray new];
            if (![pref[kKeyMobileBlockedCities][self.groupKey] containsObject:self.cityKey]) {
                [pref[kKeyMobileBlockedCities][self.groupKey] addObject:self.cityKey];
            }
            if (!pref[kKeyMobileBlockedCitiesFlattened])
                pref[kKeyMobileBlockedCitiesFlattened] = [NSMutableArray new];
            if (![pref[kKeyMobileBlockedCitiesFlattened] containsObject:self.cityKey]) {
                [pref[kKeyMobileBlockedCitiesFlattened] addObject:self.cityKey];
            }
        } else {
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
        }
    } else {
        if (self.forMobile) {
            if ([pref[kKeyMobileBlockedCities][self.groupKey] containsObject:self.cityKey]) {
                [pref[kKeyMobileBlockedCities][self.groupKey] removeObject:self.cityKey];
            }
            if ([pref[kKeyMobileBlockedCitiesFlattened] containsObject:self.cityKey]) {
                [pref[kKeyMobileBlockedCitiesFlattened] removeObject:self.cityKey];
            }
        } else {
            if ([pref[kKeyBlockedCities][self.groupKey] containsObject:self.cityKey]) {
                [pref[kKeyBlockedCities][self.groupKey] removeObject:self.cityKey];
            }
            if ([pref[kKeyBlockedCitiesFlattened] containsObject:self.cityKey]) {
                [pref[kKeyBlockedCitiesFlattened] removeObject:self.cityKey];
            }
        }
    }
    [[Preference sharedInstance] save];
}

@end

@interface ZoneVC ()


@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkAllButton;
@property (weak, nonatomic) IBOutlet UISearchBar *filter;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewBottom;

@property (copy, nonatomic) NSArray *cityGroups;
@property (strong, nonatomic) NSMutableArray *filteredCityGroups;
@property (strong, nonatomic) NSMutableArray *notificationObservers;
@end

@implementation ZoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationObservers = [NSMutableArray new];
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
    self.filteredCityGroups = [finalGroups mutableDeepCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *keyInfo = [note userInfo];
        CGRect keyboardFrame = [[keyInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.tableviewBottom.constant = keyboardFrame.size.height;
        if (self.tableview.contentOffset.y < 0) {
            self.tableview.contentOffset = CGPointMake(self.tableview.contentOffset.x, self.tableview.contentOffset.y -keyboardFrame.size.height);
        }
    }];
    [self.notificationObservers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.tableviewBottom.constant = 0;
    }];
    [self.notificationObservers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"group-blocking-changed" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSDictionary *info = note.userInfo;
        for (NSDictionary *g in self.cityGroups) {
            if ([g[@"group"] isEqualToString:info[@"group"]]) {
                if ([info[@"enabled"] boolValue]) {
                    // 启用按省拦截
                    if (self.forMobile) {
                        if (!pref[kKeyMobileBlockedCitiesFlattened])
                            pref[kKeyMobileBlockedCitiesFlattened] = [NSMutableArray new];
                        for (NSString *cityKey in g[@"allCityKeys"]) {
                            if (![pref[kKeyMobileBlockedCitiesFlattened] containsObject:cityKey]) {
                                [pref[kKeyMobileBlockedCitiesFlattened] addObject:cityKey];
                            }
                        }
                    } else {
                        if (!pref[kKeyBlockedCitiesFlattened])
                            pref[kKeyBlockedCitiesFlattened] = [NSMutableArray new];
                        for (NSString *cityKey in g[@"allCityKeys"]) {
                            if (![pref[kKeyBlockedCitiesFlattened] containsObject:cityKey]) {
                                [pref[kKeyBlockedCitiesFlattened] addObject:cityKey];
                            }
                        }
                    }
                } else {
                    // 禁用按省拦截
                    if (self.forMobile) {
                        for (NSString *cityKey in g[@"allCityKeys"]) {
                            if (![pref[kKeyMobileBlockedCities][g[@"group"]] containsObject:cityKey]) {
                                [pref[kKeyMobileBlockedCitiesFlattened] removeObject:cityKey];
                            }
                        }
                    } else {
                        for (NSString *cityKey in g[@"allCityKeys"]) {
                            if (![pref[kKeyBlockedCities][g[@"group"]] containsObject:cityKey]) {
                                [pref[kKeyBlockedCitiesFlattened] removeObject:cityKey];
                            }
                        }
                    }
                }
                break;
            }
        }
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
    }];
    [self.notificationObservers addObject:observer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (id observer in self.notificationObservers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    [self.notificationObservers removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCheckAll:(id)sender {
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    if (self.forMobile) {
        if (!pref[kKeyMobileBlockedCitiesFlattened])
            pref[kKeyMobileBlockedCitiesFlattened] = [NSMutableArray new];
        if (!pref[kKeyMobileBlockedGroups])
            pref[kKeyMobileBlockedGroups] = [NSMutableArray new];
        for (NSDictionary *g in self.filteredCityGroups) {
            if (![pref[kKeyMobileBlockedGroups] containsObject:g[@"group"]]) {
                [pref[kKeyMobileBlockedGroups] addObject:g[@"group"]];
            }
            for (NSString *cityKey in g[@"allCityKeys"]) {
                if (![pref[kKeyMobileBlockedCitiesFlattened] containsObject:cityKey]) {
                    [pref[kKeyMobileBlockedCitiesFlattened] addObject:cityKey];
                }
            }
        }
    } else {
        if (!pref[kKeyBlockedCitiesFlattened])
            pref[kKeyBlockedCitiesFlattened] = [NSMutableArray new];
        if (!pref[kKeyBlockedGroups])
            pref[kKeyBlockedGroups] = [NSMutableArray new];
        for (NSDictionary *g in self.filteredCityGroups) {
            if (![pref[kKeyBlockedGroups] containsObject:g[@"group"]]) {
                [pref[kKeyBlockedGroups] addObject:g[@"group"]];
            }
            for (NSString *cityKey in g[@"allCityKeys"]) {
                if (![pref[kKeyBlockedCitiesFlattened] containsObject:cityKey]) {
                    [pref[kKeyBlockedCitiesFlattened] addObject:cityKey];
                }
            }
        }
    }

    [[Preference sharedInstance] save];
    [self.tableview reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filteredCityGroups.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.filteredCityGroups[section][@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredCityGroups[section][@"allCityKeys"] count] + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *group = self.filteredCityGroups[indexPath.section];
    NSString *groupKey = group[@"group"];
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    
    if (indexPath.row == 0) {
        ZoneProvinceCell *provinceCell = [tableView dequeueReusableCellWithIdentifier:@"cell.province"];
        provinceCell.forMobile = self.forMobile;
        provinceCell.group = groupKey;
        [provinceCell.enabled setOn:[pref[self.forMobile ? kKeyMobileBlockedGroups : kKeyBlockedGroups] containsObject:groupKey]];
        return provinceCell;
    }
    ZoneCityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:@"cell.city"];
    cityCell.forMobile = self.forMobile;
    
    NSString *cityKey = group[@"allCityKeys"][indexPath.row - 1];
    cityCell.name.text = [NSString stringWithFormat:@"%@ %@", cityKey, group[@"cities"][cityKey]];
    cityCell.groupKey = groupKey;
    cityCell.cityKey = cityKey;
    
    // switch状态
    [cityCell.enabled setOn:[pref[self.forMobile ? kKeyMobileBlockedCities : kKeyBlockedCities][groupKey] containsObject:cityKey]];
    
    // 此城市是否已被按省拦截
    cityCell.enabled.enabled = ![pref[self.forMobile ? kKeyMobileBlockedGroups : kKeyBlockedGroups] containsObject:groupKey];
    
    return cityCell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *keyword = searchBar.text;
    if ([keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        self.filteredCityGroups = [self.cityGroups mutableCopy];
        self.checkAllButton.enabled = YES;
    } else {
        self.checkAllButton.enabled = NO;
        [self.filteredCityGroups removeAllObjects];
        for (NSDictionary *group in self.cityGroups) {
            if ([group[@"name"] containsString:keyword]) {
                [self.filteredCityGroups addObject:group];
            } else {
                NSMutableDictionary *filteredGroup = [group mutableDeepCopy];
                for (NSString *cityKey in group[@"allCityKeys"]) {
                    NSString *cityName = group[@"cities"][cityKey];
                    if (![cityKey containsString:keyword] &&
                        ![cityName containsString:keyword]) {
                        [filteredGroup[@"allCityKeys"] removeObject:cityKey];
                    }
                }
                if ([filteredGroup[@"allCityKeys"] count] > 0) {
                    [self.filteredCityGroups addObject:filteredGroup];
                }
            }
        }
    }
    [self.tableview reloadData];
    [self.tableview scrollsToTop];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
