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
    [AlertUtil showQuery:NSLocalizedString(@"del-all-blacklist-prompt", nil) message:nil isDanger:YES onConfirm:^{
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *blacklist = pref[kKeyBlacklist];
        [blacklist removeAllObjects];
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
        self.trashButton.enabled = NO;
    }];
}
- (IBAction)onAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"add-blacklist", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle * messagePS = [NSMutableParagraphStyle new];
    messagePS.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *msgAS = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"blacklist-example", nil) attributes:@{NSParagraphStyleAttributeName:messagePS, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [alert setValue:msgAS forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *number = alert.textFields[0].text;
        if (number.length) {
            number = [number stringByReplacingOccurrencesOfString:@"**" withString:@"*"];
            number = [number stringByReplacingOccurrencesOfString:@"*?" withString:@"*"];
            number = [number stringByReplacingOccurrencesOfString:@"?*" withString:@"*"];
            if ([number containsString:@"**"] || [number containsString:@"*?"] ||[number containsString:@"?*"]) {
                [AlertUtil showInfo:NSLocalizedString(@"format-not-supported", nil) message:nil];
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
                    [AlertUtil showInfo:NSLocalizedString(@"duplicated-entry", nil) message:nil];
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
        textField.placeholder = NSLocalizedString(@"enter-number", nil);
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.delegate = self;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"comment-optional", nil);
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
    
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"comment", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *blacklist = pref[kKeyBlacklist];
        NSMutableArray *item = [blacklist[indexPath.row] mutableCopy];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"edit-comment", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = item[2];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
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
