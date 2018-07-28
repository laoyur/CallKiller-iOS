//
//  Preference.m
//  statics
//
//  Created by mac on 2018/7/18.
//

#import "Preference.h"
#import "statics.h"
#import <notify.h>

#if TARGET_OS_SIMULATOR
#define kCallKillerPreferenceFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller"]
#define kCallKillerPreferenceFilePathLegacy [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller-pref.json"]
#define kCallKillerPreferenceFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller/callkiller-pref.json"]
#else
#define kCallKillerPreferenceFolder @"/var/mobile/callkiller"
#define kCallKillerPreferenceFilePathLegacy @"/var/mobile/callkiller-pref.json"
#define kCallKillerPreferenceFilePath @"/var/mobile/callkiller/callkiller-pref.json"
#endif

static BOOL didMigrate = NO;

@implementation Preference

+(instancetype)sharedInstance {
    static Preference *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [[NSFileManager defaultManager] createDirectoryAtPath:kCallKillerPreferenceFolder 
                                  withIntermediateDirectories:YES 
                                                   attributes:nil 
                                                        error:nil];
        instance->_pref = [[Preference load] mutableDeepCopy];
    });
    return instance;
}

-(NSMutableDictionary*)pref {
    return _pref;
}

-(void)save {
    _pref[kKeyPrefVersion] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:_pref options:kNilOptions error:nil];
    if (data) {
        [data writeToFile:kCallKillerPreferenceFilePath atomically:YES];
        notify_post("com.laoyur.callkiller.preference-updated");
    }
}

-(void)saveOnly {
    _pref[kKeyPrefVersion] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:_pref options:kNilOptions error:nil];
    if (data) {
        [data writeToFile:kCallKillerPreferenceFilePath atomically:YES];
    }
}

+(NSDictionary*)load {
    [Preference migrate];
    NSData *data = [NSData dataWithContentsOfFile:kCallKillerPreferenceFilePath];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (dict)
            return dict;
    }
    return @{
             kKeyBypassContacts: @(YES),
             kKeyBlockUnknown: @(YES),
             kKeyBlackKeywords: @[
                     @"响一声",
                     @"广告",
                     @"推销",
                     @"骚扰",
                     @"诈骗",
                     @"保险",
                     @"理财",
                     @"房产中介",
                     ]
             };
}

/**
 /var/mobile/callkiller-pref.json --> /var/mobile/callkiller/callkiller-pref.json
 */
+(void)migrate {
    if (didMigrate) // do migrate only once for sb/app lifetime
        return;
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:kCallKillerPreferenceFilePath] && [mgr fileExistsAtPath:kCallKillerPreferenceFilePathLegacy]) {
        [mgr createDirectoryAtPath:kCallKillerPreferenceFolder withIntermediateDirectories:YES attributes:nil error:nil];
        [mgr moveItemAtPath:kCallKillerPreferenceFilePathLegacy toPath:kCallKillerPreferenceFilePath error:nil];
    }
    didMigrate = YES;
}

@end
