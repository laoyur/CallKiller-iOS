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

#define kDonationAlipayAccount @"PLACEHOLDER"

@interface RootVC ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blockingUnknownSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *contactBypassSwitch;
@property (weak, nonatomic) IBOutlet UILabel *citiesBlockedCount;
@property (weak, nonatomic) IBOutlet UILabel *blackListCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *blackKeywordsCount;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *pref = [[Preference sharedInstance] pref];
    self.statusLabel.text = [pref[kKeyEnabled] boolValue] ? @"已启用" : @"未启用";
    [self.enableSwitch setOn:[pref[kKeyEnabled] boolValue] animated:NO];
    [self.blockingUnknownSwitch setOn:[pref[kKeyBlockUnknown] boolValue] animated:NO];
    [self.contactBypassSwitch setOn:[pref[kKeyBypassContacts] boolValue] animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *citiesBlocked = pref[kKeyBlockedCitiesFlattened];
    if (citiesBlocked.count > 0) {
        self.citiesBlockedCount.text = [NSString stringWithFormat:@"%ld 个城市", citiesBlocked.count];
    } else {
        self.citiesBlockedCount.text = @"未配置";
    }
    
    NSArray *blacklist = pref[kKeyBlacklist];
    if (blacklist.count > 0) {
        self.blackListCountLabel.text = [NSString stringWithFormat:@"%ld 条记录", blacklist.count];
    } else {
        self.blackListCountLabel.text = @"未配置";
    }
    
    NSArray *keywords = pref[kKeyBlackKeywords];
    if (keywords.count > 0) {
        self.blackKeywordsCount.text = [NSString stringWithFormat:@"%ld 条记录", keywords.count];
    } else {
        self.blackKeywordsCount.text = @"未配置";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSwitchChanged:(id)sender {
    if (sender == self.enableSwitch) {
        [[Preference sharedInstance] pref][kKeyEnabled] = @(self.enableSwitch.isOn);
        [[Preference sharedInstance] save];
        self.statusLabel.text = self.enableSwitch.isOn ? @"已启用" : @"未启用";
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
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.blacklist"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.blacklist"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.keywords"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sb.blackkeywords"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.donationlist"]) {
        [AlertUtil showWaitingHud];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AFHTTPSessionManager *http = [AFHTTPSessionManager manager];
        http.requestSerializer = [AFHTTPRequestSerializer serializer];
        http.requestSerializer.timeoutInterval = 10;
        [http GET:@"https://donation.laoyur.com/?app=callkiller" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [AlertUtil hideWaitingHud];
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
                [content appendString:@"尚未有人捐赠"];
            }

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"捐赠名单" message:content preferredStyle:UIAlertControllerStyleAlert];
            
            // message居左
            if (list && list.count) {
                NSMutableParagraphStyle * messagePS = [NSMutableParagraphStyle new];
                messagePS.alignment = NSTextAlignmentLeft;
                NSMutableAttributedString *msgAS = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:messagePS, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                [alert setValue:msgAS forKey:@"attributedMessage"];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:@"支付宝捐赠" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self donate];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                //
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [AlertUtil hideWaitingHud];
            [AlertUtil showInfo:@"出错了" message:@"服务器无响应"];
        }];
    } else if ([cell.reuseIdentifier isEqualToString:@"cell.donation"]) {
        [self donate];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)donate {
    [UIPasteboard generalPasteboard].string = kDonationAlipayAccount;
    NSURL *alipayURL = [NSURL URLWithString:@"alipay://"];
    BOOL alipayInstalled = [[UIApplication sharedApplication] canOpenURL:alipayURL];
    NSString *message = [NSString stringWithFormat:@"感谢您的支持！\n%@", alipayInstalled ? @"即将跳转到支付宝，请在转账备注中留下您的昵称，以便显示在「捐赠名单」中。" : @""];
    [AlertUtil showInfo:@"支付宝账号已拷贝" message:message onConfirm:^{
        [[UIApplication sharedApplication] openURL:alipayURL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
}

@end
