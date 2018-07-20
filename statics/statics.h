//
//  statics.h
//  statics
//
//  Created by mac on 2018/7/16.
//

#import <Foundation/Foundation.h>

#import "GCDObjC/GCDObjC.h"
#import "fmdb/FMDB.h"

@protocol MutableDeepCopying <NSObject>
-(id) mutableDeepCopy;
@end

@interface NSDictionary (MutableDeepCopy) <MutableDeepCopying>
@end

@interface NSArray (MutableDeepCopy) <MutableDeepCopying>
@end

