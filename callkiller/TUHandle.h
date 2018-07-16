//
//  TUHandle.h
//  callkiller
//
//  Created by mac on 2018/7/12.
//

#ifndef TUHandle_h
#define TUHandle_h

@interface TUHandle : NSObject <NSCopying, NSSecureCoding> {
    
    long long _type;
    NSString* _value;
    
}

@property (nonatomic,copy,readonly) NSDictionary * dictionaryRepresentation; 
@property (assign,nonatomic) long long type;                                              //@synthesize type=_type - In the implementation block
@property (nonatomic,copy) NSString * value;                                              //@synthesize value=_value - In the implementation block
+(BOOL)supportsSecureCoding;
+(id)stringForType:(long long)arg1 ;
+(id)handleWithDestinationID:(id)arg1 ;
+(id)handleWithDictionaryRepresentation:(id)arg1 ;
+(id)handleWithPersonHandle:(id)arg1 ;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(void)setType:(long long)arg1 ;
-(long long)type;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setValue:(NSString *)arg1 ;
-(NSString *)value;
-(NSDictionary *)dictionaryRepresentation;
-(id)personHandle;
-(BOOL)isEqualToHandle:(id)arg1 ;
-(BOOL)isCanonicallyEqualToHandle:(id)arg1 isoCountryCode:(id)arg2 ;
-(id)initWithDestinationID:(id)arg1 ;
-(id)canonicalHandleForISOCountryCode:(id)arg1 ;
-(id)initWithType:(long long)arg1 value:(id)arg2 ;
@end

#endif /* TUHandle_h */
