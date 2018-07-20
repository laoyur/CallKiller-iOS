//
//  AlertUtil.h
//  callkiller-gui
//
//  Created by mac on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface AlertUtil : NSObject

+ (void) showInfo:(NSString *)title message:(NSString *)msg;
+ (void) showInfo:(NSString *)title message:(NSString *)msg onConfirm:(void(^)(void))cb;
+ (void) showQuery:(NSString *)title message:(NSString *)msg isDanger:(BOOL)danger onConfirm:(void(^)(void))cb;
+ (void) showWaitingHud;
+ (void) hideWaitingHud;

@end
