//
//  Preference.h
//  statics
//
//  Created by mac on 2018/7/18.
//

#import <Foundation/Foundation.h>

#define kKeyEnabled @"enabled"
#define kKeyBlockUnknown @"block-unknown-enabled"
#define kKeyBypassContacts @"bypass-contacts-enabled"
#define kKeyBlockedGroups @"blocked-groups" // 按省拦截
#define kKeyBlockedCities @"blocked-cities" // 按市拦截
#define kKeyBlockedCitiesFlattened @"blocked-cities-flattened" // for springboard
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
