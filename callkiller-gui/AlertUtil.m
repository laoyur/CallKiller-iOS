//
//  AlertUtil.m
//  callkiller-gui
//
//  Created by mac on 2018/7/19.
//

#import <UIKit/UIKit.h>
#import "AlertUtil.h"
#import "JGProgressHUD.h"

static JGProgressHUD *sharedHud = nil;

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

+ (void) hideHud {
    if (sharedHud) {
        [sharedHud dismissAnimated:NO];
    }
    sharedHud = nil;
}

+ (void) showWaitingHud:(NSString *)text {
    [AlertUtil hideHud];
    sharedHud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    sharedHud.indicatorView = [JGProgressHUDIndeterminateIndicatorView new];
    if (text)
        sharedHud.textLabel.text = text;
    [sharedHud showInView:UIApplication.sharedApplication.keyWindow.rootViewController.view animated:NO];
}

+ (void) updateHudText:(NSString *)text {
    if (sharedHud) {
        sharedHud.textLabel.text = text;
    }
}

+ (void) showProgressHud:(NSString *)text {
    [AlertUtil hideHud];
    sharedHud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    sharedHud.indicatorView = [JGProgressHUDPieIndicatorView new];
    if (text)
        sharedHud.textLabel.text = text;
    [sharedHud showInView:UIApplication.sharedApplication.keyWindow.rootViewController.view animated:NO];
}

+ (void) updateHudProgress:(float)ratio {
    if (sharedHud) {
        [sharedHud setProgress:ratio animated:NO];
    }
}

@end
