//
//  Preference.h
//  statics
//
//  Created by mac on 2018/7/18.
//

#import <Foundation/Foundation.h>

#define kKeyPrefVersion @"version"  // added in 1.3.1
#define kKeyEnabled @"enabled"
#define kKeyBlockUnknown @"block-unknown-enabled"
#define kKeyBypassContacts @"bypass-contacts-enabled"
#define kKeyBlockedGroups @"blocked-groups" // 座机按省拦截
#define kKeyBlockedCities @"blocked-cities" // 座机按市拦截
#define kKeyBlockedCitiesFlattened @"blocked-cities-flattened" // for springboard
#define kKeyMobileBlockedGroups @"mobile-blocked-groups" // 手机号按省拦截
#define kKeyMobileBlockedCities @"mobile-blocked-cities" // 手机号按市拦截
#define kKeyMobileBlockedCitiesFlattened @"mobile-blocked-cities-flattened" // for springboard
#define kKeyBlacklist @"blacklist"
#define kKeyBlackKeywords @"keywords"

@interface Preference : NSObject {
    NSMutableDictionary *_pref;
}

+(instancetype)sharedInstance;
+(NSDictionary*)load;

-(NSMutableDictionary*)pref;
-(void)save;
-(void)saveOnly;

@end
