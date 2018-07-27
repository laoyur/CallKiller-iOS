//
//  MobileRegionDetector.h
//  statics
//
//  Created by mac on 2018/7/26.
//

#import <Foundation/Foundation.h>

@interface MobileRegionDetector : NSObject

+(instancetype)sharedInstance;
-(NSString*)dbVersion;
-(NSString*)detectRegionCode:(NSString*)mobileNumber;

@end
