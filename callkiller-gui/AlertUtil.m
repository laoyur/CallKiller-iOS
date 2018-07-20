//
//  AlertUtil.m
//  callkiller-gui
//
//  Created by mac on 2018/7/19.
//

#import <UIKit/UIKit.h>
#import "AlertUtil.h"
#import "MBProgressHUD.h"

static MBProgressHUD *hud = nil;

@implementation AlertUtil

+ (void) showInfo:(NSString *)title message:(NSString *)msg {
    [AlertUtil showInfo:title message:msg onConfirm:nil];
}

+ (void) showInfo:(NSString *)title message:(NSString *)msg onConfirm:(void(^)(void))cb {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cb)
            cb();
    }]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
        //
    }];
}

+ (void) showQuery:(NSString *)title message:(NSString *)msg isDanger:(BOOL)danger onConfirm:(void(^)(void))cb {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:danger ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cb)
            cb();
    }]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
        //
    }];
}

+ (void) showWaitingHud {
    [AlertUtil hideWaitingHud];
    hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow.rootViewController.view animated:YES];
    hud.bezelView.color = [UIColor lightGrayColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabel.textColor = [UIColor darkGrayColor];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:17];
    hud.detailsLabel.text = @"Loading...";
    hud.userInteractionEnabled = YES;
}

+ (void) hideWaitingHud {
    if (hud) {
        [hud hideAnimated:NO];
        hud = nil;
    }
}

@end
