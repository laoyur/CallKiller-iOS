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
    [AlertUtil showQuery:@"确定清空拦截关键词？" message:nil isDanger:YES onConfirm:^{
        NSMutableDictionary *pref = [[Preference sharedInstance] pref];
        NSMutableArray *keywords = pref[kKeyBlackKeywords];
        [keywords removeAllObjects];
        [[Preference sharedInstance] save];
        [self.tableview reloadData];
        self.trashButton.enabled = NO;
    }];
}
- (IBAction)onAdd:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"增加关键词" message:@"不支持通配符" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
                    [AlertUtil showInfo:@"已经存在，请勿重复添加！" message:nil];
                    return;
                }
            }
            [keywords addObject:keyword];
            [[Preference sharedInstance] save];
            [self.tableview reloadData];
        }
    }];
    confirm.enabled = NO;
    self.alertAction = confirm;
    [alert addAction:confirm];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入关键词";
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
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
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
