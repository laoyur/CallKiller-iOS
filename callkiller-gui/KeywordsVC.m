//
//  KeywordsVC.m
//  callkiller-gui
//
//  Created by mac on 2018/7/19.
//

#import "KeywordsVC.h"
#import "Preference.h"
#import "AlertUtil.h"

@interface KeywordsVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UIAlertAction *alertAction;
@end

@implementation KeywordsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *keywords = pref[kKeyBlackKeywords];
    self.trashButton.enabled = keywords.count > 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTrash:(id)sender {
    [AlertUtil showQuery:NSLocalizedString(@"del-all-keywords-prompt", nil) message:nil isDanger:YES onConfirm:^{
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *keywords = pref[kKeyBlackKeywords];
        [keywords removeAllObjects];
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
        self.trashButton.enabled = NO;
    }];
}
- (IBAction)onAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"add-keyword-title", nil) message:NSLocalizedString(@"add-keyword-content", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *keyword = [alert.textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (keyword.length) {
            NSMutableDictionary *pref = [[Preference sharedInstance] pref];
            NSMutableArray *keywords = pref[kKeyBlackKeywords];
            if (!keywords) {
                keywords = [NSMutableArray new];
                pref[kKeyBlackKeywords] = keywords;
            }
            for (NSString *item in keywords) {
                if ([item isEqualToString:keyword]) {
                    [AlertUtil showInfo:NSLocalizedString(@"duplicated-entry", nil) message:nil];
                    return;
                }
            }
            [keywords addObject:keyword];
            [[Preference sharedInstance] save];
            [self.tableview reloadData];
            self.trashButton.enabled = YES;
        }
    }];
    confirm.enabled = NO;
    self.alertAction = confirm;
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"enter-keyword-prompt", nil);
        textField.delegate = self;
    }];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
        //
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *keywords = pref[kKeyBlackKeywords];
    return keywords.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *pref = [[Preference sharedInstance] pref];
    NSArray *keywords = pref[kKeyBlackKeywords];
    cell.textLabel.text = keywords[indexPath.row];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *actions = [NSMutableArray new];
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *keywords = pref[kKeyBlackKeywords];
        [keywords removeObjectAtIndex:indexPath.row];
        [[Preference sharedInstance] save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView setEditing:NO animated:NO];
        
        if (keywords.count == 0) {
            self.trashButton.enabled = NO;
        }
    }]];
    return actions;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.alertAction.enabled = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
    return YES;
}

@end
