//
//  statics.h
//  statics
//
//  Created by mac on 2018/7/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GCDObjC/GCDObjC.h"
#import "fmdb/FMDB.h"

#define kMPHistoryFileName @"callkiller-history.txt"
#define kMPHistoryAddedNotification "com.laoyur.callkiller.mp-block-history-added"
#define kMPHistoryFileChangedNotification "com.laoyur.callkiller.mp-history-file-changed"
#define kCallKillerPrefUpdatedNotification "com.laoyur.callkiller.preference-updated"

#ifdef __cplusplus
extern "C" {
#endif
    
typedef enum : NSUInteger {
    ReasonNotBlocked = 0,
    ReasonBlockedAsUnknownNumber = 1,
    ReasonBlockedAsLandline = 2,
    ReasonBlockedAsMobile = 3,
    ReasonBlockedAsBlacklist = 4,
    ReasonBlockedAsKeywords = 5,
    ReasonBlockedAsSystemBlacklist = 99,
} BlockReason;
    
void Log(const char *fmt, ...);
#ifdef __cplusplus
}
#endif

@protocol MutableDeepCopying <NSObject>
-(id) mutableDeepCopy;
@end

@interface NSDictionary (MutableDeepCopy) <MutableDeepCopying>
@end

@interface NSArray (MutableDeepCopy) <MutableDeepCopying>
@end

@interface NSString (CKAdditional)
- (NSString *)trimming;
- (BOOL) isVersionStringGE:(NSString *)version;
@end

@interface UIColor (Hex)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
