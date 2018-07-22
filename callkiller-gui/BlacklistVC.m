//
//  BlacklistVC.m
//  callkiller-gui
//
//  Created by mac on 2018/7/19.
//

#import "BlacklistVC.h"
#import "Preference.h"
#import "AlertUtil.h"

@interface BlacklistVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UIAlertAction *alertAction;
@end

@implementation BlacklistVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *blacklist = pref[kKeyBlacklist];
    self.trashButton.enabled = blacklist.count > 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTrash:(id)sender {
    [AlertUtil showQuery:@"确定清空黑名单？" message:nil isDanger:YES onConfirm:^{
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *blacklist = pref[kKeyBlacklist];
        [blacklist removeAllObjects];
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
        self.trashButton.enabled = NO;
    }];
}
- (IBAction)onAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"增加黑名单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle * messagePS = [NSMutableParagraphStyle new];
    messagePS.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *msgAS = [[NSMutableAttributedString alloc] initWithString:@"支持通配符（?、*）\n? 代表单个数字，\n* 代表0个或任意个数字。\n\n示例1：指定号码，10086\n示例2：指定号段，05128286*\n示例3：固定位数，1381234????\n\n请勿添加86前缀" attributes:@{NSParagraphStyleAttributeName:messagePS, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [alert setValue:msgAS forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *number = alert.textFields[0].text;
        if (number.length) {
            number = [number stringByReplacingOccurrencesOfString:@"**" withString:@"*"];
            number = [number stringByReplacingOccurrencesOfString:@"*?" withString:@"*"];
            number = [number stringByReplacingOccurrencesOfString:@"?*" withString:@"*"];
            if ([number containsString:@"**"] || [number containsString:@"*?"] ||[number containsString:@"?*"]) {
                [AlertUtil showInfo:@"不支持的格式！" message:nil];
                return;
            }
            NSString *pattern = [number stringByReplacingOccurrencesOfString:@"*" withString:@"\\d*"];
            pattern = [pattern stringByReplacingOccurrencesOfString:@"?" withString:@"\\d"];
            pattern = [NSString stringWithFormat:@"^%@$", pattern];
            
            NSMutableDictionary *pref = [[Preference sharedInstance] pref];
            NSMutableArray *blacklist = pref[kKeyBlacklist];
            if (!blacklist) {
                blacklist = [NSMutableArray new];
                pref[kKeyBlacklist] = blacklist;
            }
            for (NSArray *item in blacklist) {
                if ([item[0] isEqualToString:number]) {
                    [AlertUtil showInfo:@"已经存在，请勿重复添加！" message:nil];
                    return;
                }
            }
            [blacklist addObject:@[number, pattern, [alert.textFields[1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
            [[Preference sharedInstance] save];
            [self.tableview reloadData];
        }
    }];
    confirm.enabled = NO;
    self.alertAction = confirm;
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入号码";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.delegate = self;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"备注（可选）";
    }];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
        //
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *blacklist = pref[kKeyBlacklist];
    return blacklist.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *blacklist = pref[kKeyBlacklist];
    cell.textLabel.text = blacklist[indexPath.row][0];
    cell.detailTextLabel.text = blacklist[indexPath.row][2];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *actions = [NSMutableArray new];
    
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *blacklist = pref[kKeyBlacklist];
        NSMutableArray *item = [blacklist[indexPath.row] mutableCopy];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改备注" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = item[2];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            item[2] = [alert.textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            blacklist[indexPath.row] = item;
            [[Preference sharedInstance] saveOnly]; // 无需通知SpringBoard
            [self.tableview reloadData];
        }]];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        [tableView setEditing:NO animated:NO];
        
        if (blacklist.count == 0) {
            self.trashButton.enabled = NO;
        }
    }]];
    
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *blacklist = pref[kKeyBlacklist];
        [blacklist removeObjectAtIndex:indexPath.row];
        [[Preference sharedInstance] save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView setEditing:NO animated:NO];
        
        if (blacklist.count == 0) {
            self.trashButton.enabled = NO;
        }
    }]];
    return actions;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789?*"] invertedSet];
    NSString *filteredstring = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL allow = [string isEqualToString:filteredstring];
    if (allow) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.alertAction.enabled = newText.length > 0;
    }
    return allow;
}

@end
