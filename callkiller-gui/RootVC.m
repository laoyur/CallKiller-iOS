//
//  RootVC.m
//  callkiller-gui
//
//  Created by mac on 2018/7/18.
//

#import "RootVC.h"
#import "ZoneVC.h"
#import "statics.h"
#import "Preference.h"
#import "AlertUtil.h"
#import "AFNetworking.h"
#import "MobileRegionDetector.h"

#define kDonationAlipayAccount @"PLACEHOLER"

@interface RootVC ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blockingUnknownSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *contactBypassSwitch;
@property (weak, nonatomic) IBOutlet UILabel *citiesBlockedCount;
@property (weak, nonatomic) IBOutlet UILabel *mobileCitiesBlockedCount;
@property (weak, nonatomic) IBOutlet UILabel *blackListCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *blackKeywordsCount;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phonedatVersionLabel;
@property (copy, nonatomic) NSArray *cityGroups;
@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    self.cityGroups = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:kNilOptions error:nil];
    
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    
    
    // 修正1.3.0的一处bug
    // 重新同步拦截的城市
    if (!pref[kKeyPrefVersion]) {
        Log("== no version found in pref file, try to fix bugs for 1.3.0");
        // 固话
        NSMutableArray *flattenCities = [NSMutableArray new];
        for (NSString *group in pref[kKeyBlockedGroups]) {
            NSDictionary *groupDic = [self findCitiesGroupByGroup:group];
            [flattenCities addObjectsFromArray:[groupDic[@"cities"] allKeys]];
        }
        for (NSString *groupKey in pref[kKeyBlockedCities]) {
            NSArray *cities = pref[kKeyBlockedCities][groupKey];
            for (NSString *city in cities) {
                if (![flattenCities containsObject:city]) {
                    [flattenCities addObject:city];
                }
            }
        }
        pref[kKeyBlockedCitiesFlattened] = flattenCities;
        
        // 手机号
        NSMutableArray *mobileFlattenCities = [NSMutableArray new];
        for (NSString *group in pref[kKeyMobileBlockedGroups]) {
            NSDictionary *groupDic = [self findCitiesGroupByGroup:group];
            [mobileFlattenCities addObjectsFromArray:[groupDic[@"cities"] allKeys]];
        }
        for (NSString *groupKey in pref[kKeyMobileBlockedCities]) {
            NSArray *cities = pref[kKeyMobileBlockedCities][groupKey];
            for (NSString *city in cities) {
                if (![mobileFlattenCities containsObject:city]) {
                    [mobileFlattenCities addObject:city];
                }
            }
        }
        pref[kKeyMobileBlockedCitiesFlattened] = mobileFlattenCities;
        [[Preference sharedInstance] save];
    }
    
    self.versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#if !(TARGET_OS_SIMULATOR)
    self.phonedatVersionLabel.text = [[MobileRegionDetector sharedInstance] dbVersion];
#endif
    
    self.statusLabel.text = [pref[kKeyEnabled] boolValue] ? NSLocalizedString(@"enabled", nil) : NSLocalizedString(@"disabled", nil);
    [self.enableSwitch setOn:[pref[kKeyEnabled] boolValue] animated:NO];
    [self.blockingUnknownSwitch setOn:[pref[kKeyBlockUnknown] boolValue] animated:NO];
    [self.contactBypassSwitch setOn:[pref[kKeyBypassContacts] boolValue] animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *citiesBlocked = pref[kKeyBlockedCitiesFlattened];
    if (citiesBlocked.count > 0) {
        self.citiesBlockedCount.text = [NSString stringWithFormat:NSLocalizedString(@"city-block-count-fmt", nil), citiesBlocked.count];
    } else {
        self.citiesBlockedCount.text = NSLocalizedString(@"no-config", nil);
    }
    
    NSArray *mobileCitiesBlocked = pref[kKeyMobileBlockedCitiesFlattened];
    if (mobileCitiesBlocked.count > 0) {
        self.mobileCitiesBlockedCount.text = [NSString stringWithFormat:NSLocalizedString(@"city-block-count-fmt", nil), mobileCitiesBlocked.count];
    } else {
        self.mobileCitiesBlockedCount.text = NSLocalizedString(@"no-config", nil);
    }
    
    NSArray *blacklist = pref[kKeyBlacklist];
    if (blacklist.count > 0) {
        self.blackListCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"record-count-fmt", nil), blacklist.count];
    } else {
        self.blackListCountLabel.text = NSLocalizedString(@"no-config", nil);
    }
    
    NSArray *keywords = pref[kKeyBlackKeywords];
    if (keywords.count > 0) {
        self.blackKeywordsCount.text = [NSString stringWithFormat:NSLocalizedString(@"record-count-fmt", nil), keywords.count];
    } else {
        self.blackKeywordsCount.text = NSLocalizedString(@"no-config", nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)findCitiesGroupByGroup:(NSString *)group {
    for (NSDictionary *g in self.cityGroups) {
        if ([g[@"group"] isEqualToString:group]) {
            return g;
        }
    }
    return nil;
}

- (IBAction)onSwitchChanged:(id)sender {
    if (sender == self.enableSwitch) {
        [[Preference sharedInstance] pref][kKeyEnabled] = @(self.enableSwitch.isOn);
        [[Preference sharedInstance] save];
        self.statusLabel.text = self.enableSwitch.isOn ? NSLocalizedString(@"enabled", nil) : NSLocalizedString(@"disabled", nil);
    } else if (sender == self.blockingUnknownSwitch) {
        [[Preference sharedInstance] pref][kKeyBlockUnknown] = @(self.blockingUnknownSwitch.isOn);
        [[Preference sharedInstance] save];
    } else if (sender == self.contactBypassSwitch) {
        [[Preference sharedInstance] pref][kKeyBypassContacts] = @(self.contactBypassSwitch.isOn);
        [[Preference sharedInstance] save];
    }
}
- (IBAction)onExit:(id)sender {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[UIApplication sharedApplication] performSelector:NSSelectorFromString(@"suspend")];
    [[GCDQueue mainQueue] queueBlock:^{
        [[UIApplication sharedApplication] performSelector:NSSelectorFromString(@"terminateWithSuccess")];
    } afterDelay:0.3];
#pragma clang diagnostic pop
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"cell.zone"]) {
        ZoneVC *zone = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.zones"];
        [self.navigationController pushViewController:zone animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.mobilezone"]) {
        ZoneVC *zone = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.mobilezones"];
        zone.forMobile = YES;
        [self.navigationController pushViewController:zone animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.blacklist"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.blacklist"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.keywords"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.blackkeywords"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.donationlist"]) {
        [AlertUtil showWaitingHud:@"Loading..."];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AFHTTPSessionManager *http = [AFHTTPSessionManager manager];
        http.requestSerializer = [AFHTTPRequestSerializer serializer];
        http.requestSerializer.timeoutInterval = 10;
        [http GET:@"https://donation.laoyur.com/?app=callkiller" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [AlertUtil hideHud];
            NSArray *list = responseObject;
            NSMutableString *content = [NSMutableString new];
            
            NSDateFormatter *ios8601 = [NSDateFormatter new];
            ios8601.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            ios8601.locale = posix;
            NSDateFormatter *displayFormat = [NSDateFormatter new];
            displayFormat.dateFormat = @"yyyy-MM-dd";
            
            if (list && list.count) {
                for (NSDictionary *donation in list) {
                    [content appendFormat:@"%@（%@）￥%.2f\n", donation[@"name"], [displayFormat stringFromDate:[ios8601 dateFromString:donation[@"created_at"]]], [donation[@"amount"] floatValue]];
                }
            } else {
                [content appendString:NSLocalizedString(@"no-donation", nil)];
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"donation-list", nil) message:content preferredStyle:UIAlertControllerStyleAlert];
            
            // message居左
            if (list && list.count) {
                NSMutableParagraphStyle * messagePS = [NSMutableParagraphStyle new];
                messagePS.alignment = NSTextAlignmentLeft;
                NSMutableAttributedString *msgAS = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:messagePS, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                [alert setValue:msgAS forKey:@"attributedMessage"];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"donate-alipay", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self donate];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                //
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [AlertUtil hideHud];
            [AlertUtil showInfo:NSLocalizedString(@"error-title", nil) message:NSLocalizedString(@"error-content", nil)];
        }];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.donation"]) {
        [self donate];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.mobiletest"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"mobile-query-alert-title", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = NSLocalizedString(@"mobile-query-placeholer", nil);
        }];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *words = [alert.textFields[0].text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *phone = [words componentsJoinedByString:@""];
            if (phone.length != 11) {
                [AlertUtil showInfo:NSLocalizedString(@"invalid-mobile-format", nil) message:nil];
                return;
            }
            NSDate *start = [NSDate date];
            NSString *code = [[MobileRegionDetector sharedInstance] detectRegionCode:phone];
            NSDate *stop = [NSDate date];
            NSTimeInterval interval = [stop timeIntervalSinceDate:start];
            NSString *locationString = NSLocalizedString(@"unknown", nil);
            if (code.length > 0) {
                NSDictionary *info = [self findCityInfoWithCode:code];
                if (info) {
                    if ([info[@"zhixiashi"] boolValue])
                        locationString = info[@"city"];
                    else
                        locationString = [NSString stringWithFormat:@"%@ - %@", info[@"province"], info[@"city"]];
                }
            } else {
                code = NSLocalizedString(@"unknown", nil);
            }
            
            [AlertUtil showInfo:phone message:[NSString stringWithFormat:NSLocalizedString(@"mobile-query-location-fmt", nil), 
                                               interval * 1000, 
                                               locationString,
                                               code]];
        }]];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.eula"]) {
        [AlertUtil showInfo:NSLocalizedString(@"eula-content", nil) message:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.opensource"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.opensource"];
        [self.navigationController pushViewController:vc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } 
}

- (NSDictionary *)findCityInfoWithCode:(NSString *)code {
    for (NSDictionary *group in self.cityGroups) {
        for (NSString *c in group[@"cities"]) {
            if ([c isEqualToString:code]) {
                return @{
                         @"province": group[@"name"],
                         @"zhixiashi": @([group[@"group"] isEqualToString:@"zhixiashi"]),
                         @"city": group[@"cities"][c],
                         };
            }
        }
    }
    return nil;
}

- (void)donate {
    [UIPasteboard generalPasteboard].string = kDonationAlipayAccount;
    NSURL *alipayURL = [NSURL URLWithString:@"alipay://"];
    BOOL alipayInstalled = [[UIApplication sharedApplication] canOpenURL:alipayURL];
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"donate-alert-title-1", nil), alipayInstalled ? NSLocalizedString(@"donate-alert-title-2", nil) : @""];
    [AlertUtil showInfo:NSLocalizedString(@"donate-alipay-copied", nil) message:message onConfirm:^{
        [[UIApplication sharedApplication] openURL:alipayURL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
}

@end
