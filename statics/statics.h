//
//  statics.h
//  statics
//
//  Created by mac on 2018/7/16.
//

#import <Foundation/Foundation.h>

#import "GCDObjC/GCDObjC.h"
#import "fmdb/FMDB.h"

#ifdef __cplusplus
extern "C" {
#endif
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
