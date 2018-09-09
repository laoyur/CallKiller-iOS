//
//  AppDelegate.m
//  callkiller-gui
//
//  Created by mac on 2018/7/18.
//

#import "AppDelegate.h"
#import "Preference.h"
#import "GCDObjC.h"

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(id)arg1;
@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    /**
     callkiller://add_to_blacklist/?from=com.apple.mobilephone&number=NUMBER&label=COMMENT
     */
    if ([url.host isEqualToString:@"add_to_blacklist"]) {
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url 
                                                    resolvingAgainstBaseURL:NO];
        NSString *number = nil;
        NSString *label = @"";
        NSString *from = @"";
        for (NSURLQueryItem *item in urlComponents.queryItems) {
            if ([item.name isEqualToString:@"number"]) {
                number = item.value;
            } else if ([item.name isEqualToString:@"label"]) {
                label = item.value;
            } else if ([item.name isEqualToString:@"from"]) {
                from = item.value;
            }
        } 
        
        if (number.length) {
            NSMutableDictionary *pref = [[Preference sharedInstance] pref];
            NSMutableArray *blacklist = pref[kKeyBlacklist];
            if (!blacklist) {
                blacklist = [NSMutableArray new];
                pref[kKeyBlacklist] = blacklist;
            }
            BOOL shouldAdd = YES;
            for (NSArray *item in blacklist) {
                if ([item[0] isEqualToString:number]) {
                    shouldAdd = NO;
                    break;
                }
            }
            if (shouldAdd) {
                NSString *pattern = [number stringByReplacingOccurrencesOfString:@"*" withString:@"\\d*"];
                pattern = [pattern stringByReplacingOccurrencesOfString:@"?" withString:@"\\d"];
                pattern = [NSString stringWithFormat:@"^%@$", pattern];
                [blacklist addObject:@[number, pattern, label]];
                [[Preference sharedInstance] save];
            }
            
            [[GCDQueue mainQueue] queueBlock:^{
                if (from.length)
                    [[LSApplicationWorkspace defaultWorkspace] openApplicationWithBundleID:from];
            } afterDelay:0.6];
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
