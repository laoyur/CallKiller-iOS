//
//  MobileRegionDetector.m
//  statics
//
//  Created by mac on 2018/7/26.
//

#import "MobileRegionDetector.h"
#include "phonedata.h"

#if TARGET_OS_SIMULATOR
#define kCallKillerPreferenceFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller"]
#else
#define kCallKillerPreferenceFolder @"/var/mobile/callkiller"
#endif

@interface MobileRegionDetector() {
    PhoneData *phonedata;
}
@end

@implementation MobileRegionDetector

+(instancetype)sharedInstance {
    static MobileRegionDetector *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        NSDirectoryEnumerator *iter = [[NSFileManager defaultManager] enumeratorAtPath:kCallKillerPreferenceFolder];
        [iter skipDescendants];
        NSString *pname;
        NSString *datFilePath = nil;
        while (pname = [iter nextObject]) {
            if ([pname hasPrefix:@"phone-"] && [pname hasSuffix:@".dat"]) {
                datFilePath = [kCallKillerPreferenceFolder stringByAppendingPathComponent:pname];
                break;
            }
        }
        if (datFilePath.length > 0)
            instance->phonedata = new PhoneData([datFilePath UTF8String]);
    });
    return instance;
}
-(NSString*)dbVersion {
    return [NSString stringWithUTF8String:phonedata->version().c_str()];
}
-(NSString*)detectRegionCode:(NSString*)mobileNumber {
    std::string phone = [mobileNumber UTF8String];
    const PhoneInfo& info = phonedata->lookUp(phone);
    return [NSString stringWithUTF8String:info.areaCode.c_str()];
}

@end
