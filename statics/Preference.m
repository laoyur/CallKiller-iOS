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
#define kCallKillerPreferenceFilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller-pref.json"]
#else
#define kCallKillerPreferenceFilePath @"/var/mobile/callkiller-pref.json"
#endif


@implementation Preference

+(instancetype)sharedInstance {
    static Preference *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_pref = [[Preference load] mutableDeepCopy];
    });
    return instance;
}

-(NSMutableDictionary*)pref {
    return _pref;
}

-(void)save {
    NSData *data = [NSJSONSerialization dataWithJSONObject:_pref options:kNilOptions error:nil];
    if (data) {
        [data writeToFile:kCallKillerPreferenceFilePath atomically:YES];
        notify_post("com.laoyur.callkiller.preference-updated");
    }
}

+(NSDictionary*)load {
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

@end
