//
//  HistoryVC.m
//  callkiller-gui
//
//  Created by mac on 2018/8/1.
//

#import "HistoryVC.h"
#import "statics.h"
#import "AlertUtil.h"
#import <notify.h>

@interface LSBundleProxy
@property (nonatomic, readonly) NSURL *dataContainerURL;
+ (id)bundleProxyForIdentifier:(id)arg1;
@end

@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *reason;

@end

@implementation HistoryCell
@end

@interface HistoryVC ()<UITableViewDelegate, UITableViewDataSource> {
    int _notifyToken;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) id notificationHandler;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dateFormatter = [NSDateFormatter new];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.notificationHandler = [[NSNotificationCenter defaultCenter] addObserverForName:@"mp-history-added" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableview reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    notify_cancel(_notifyToken);
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrash:(id)sender {
    [AlertUtil showQuery:NSLocalizedString(@"trash-history-alert-title", nil) message:NSLocalizedString(@"trash-history-alert-content", nil) isDanger:YES onConfirm:^{
        [self.history removeAllObjects];
        [self syncMPHistoryFile];
        [self.tableview reloadData];
        self.tableview.userInteractionEnabled = NO;
        [[GCDQueue mainQueue] queueBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } afterDelay:0.4];
    }];
}

- (void) syncMPHistoryFile {
    LSBundleProxy *mobilephone = [LSBundleProxy bundleProxyForIdentifier:@"com.apple.mobilephone"];
    NSString *mpHistoryFilePath = [NSString stringWithFormat:@"%@/Documents/%@", mobilephone.dataContainerURL.path, kMPHistoryFileName];
    NSMutableString *content = [NSMutableString new];
    
    for (int i=(int)self.history.count - 1; i>=0; i--) {
        NSDictionary *record = self.history[i];
        NSData *data = [NSJSONSerialization dataWithJSONObject:record options:kNilOptions error:nil];
        [content appendFormat:@"%@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }
    
    [content writeToFile:mpHistoryFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    notify_post(kMPHistoryFileChangedNotification);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mp-history-deleted-by-user" object:nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.history.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *record = self.history[indexPath.row];
    cell.phone.text = record[@"p"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[record[@"d"] longValue]];
    cell.date.text = [self.dateFormatter stringFromDate:date];
    switch ([record[@"r"] intValue]) {
        case ReasonBlockedAsUnknownNumber: {
            cell.reason.text = NSLocalizedString(@"block-reason-unknown-number", nil);
            break;
        }
        case ReasonBlockedAsLandline: {
            cell.reason.text = NSLocalizedString(@"block-reason-landline", nil);
            break;
        }
        case ReasonBlockedAsMobile: {
            cell.reason.text = NSLocalizedString(@"block-reason-mobile", nil);
            break;
        }
        case ReasonBlockedAsBlacklist: {
            cell.reason.text = NSLocalizedString(@"block-reason-blacklist", nil);
            break;
        }
        case ReasonBlockedAsKeywords: {
            cell.reason.text = record[@"rd"];
            break;
        }
        case ReasonBlockedAsSystemBlacklist: {
            cell.reason.text = NSLocalizedString(@"block-reason-system", nil);
            break;
        }
        default:
            cell.reason.text = NSLocalizedString(@"block-reason-unknown", nil);
            break;
    }
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *actions = [NSMutableArray new];
    [actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        [self.history removeObjectAtIndex:indexPath.row];
        [self syncMPHistoryFile];
        [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }]];
    return actions;
}

@end
