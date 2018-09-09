//
//  statics.m
//  statics
//
//  Created by mac on 2018/7/16.
//

#import "statics.h"

void Log(const char *fmt, ...) {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    
    va_list arg_ptr; 
    va_start(arg_ptr, fmt); 
    NSString *format = [[NSString stringWithUTF8String:fmt] stringByAppendingString:@"\n"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@ %@", now, format] arguments:arg_ptr]; 
    va_end(arg_ptr); 
    
    // append
    NSString *path = @"/var/mobile/callkiller.log";
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.mobilephone"]) {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/callkiller-log.txt"];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle seekToEndOfFile];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

@implementation NSDictionary (MutableDeepCopy)
- (NSMutableDictionary *) mutableDeepCopy {
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    NSArray * keys = [self allKeys];
    for(id key in keys) {
        id aValue = [self objectForKey:key];
        id theCopy = nil;
        if([aValue conformsToProtocol:@protocol(MutableDeepCopying)]) {
            theCopy = [aValue mutableDeepCopy];
        } else if([aValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            theCopy = [aValue mutableCopy];
        } else if([aValue conformsToProtocol:@protocol(NSCopying)]){
            theCopy = [aValue copy];
        } else {
            theCopy = aValue;
        }
        [returnDict setValue:theCopy forKey:key];
    }
    return returnDict;
}
@end

@implementation NSArray (MutableDeepCopy)
-(NSMutableArray *)mutableDeepCopy {
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id aValue in self) {
        id theCopy = nil;
        if([aValue conformsToProtocol:@protocol(MutableDeepCopying)]) {
            theCopy = [aValue mutableDeepCopy];
        } else if([aValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            theCopy = [aValue mutableCopy];
        } else if([aValue conformsToProtocol:@protocol(NSCopying)]){
            theCopy = [aValue copy];
        } else {
            theCopy = aValue;
        }
        [returnArray addObject:theCopy];
    }
    return returnArray;
}
@end

typedef NS_ENUM(NSInteger, SUCharacterType) {
    kNumberType,
    kStringType,
    kSeparatorType,
};

SUCharacterType typeOfCharacter(NSString *character) {
    if ([character isEqualToString:@"."]) {
        return kSeparatorType;
    } else if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[character characterAtIndex:0]]) {
        return kNumberType;
    } else if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[character characterAtIndex:0]]) {
        return kSeparatorType;
    } else if ([[NSCharacterSet punctuationCharacterSet] characterIsMember:[character characterAtIndex:0]]) {
        return kSeparatorType;
    } else {
        return kStringType;
    }
}

NSArray *splitVersionString(NSString *version) {
    NSString *character;
    NSMutableString *s;
    NSUInteger i, n;
    SUCharacterType oldType, newType;
    NSMutableArray *parts = [NSMutableArray array];
    if ([version length] == 0) {
        // Nothing to do here
        return parts;
    }
    s = [[version substringToIndex:1] mutableCopy];
    oldType = typeOfCharacter(s);
    n = [version length] - 1;
    for (i = 1; i <= n; ++i) {
        character = [version substringWithRange:NSMakeRange(i, 1)];
        newType = typeOfCharacter(character);
        if (oldType != newType || oldType == kSeparatorType) {
            // We've reached a new segment
            NSString *aPart = [[NSString alloc] initWithString:s];
            [parts addObject:aPart];
            [s setString:character];
        } else {
            // Add character to string and continue
            [s appendString:character];
        }
        oldType = newType;
    }
    
    // Add the last part onto the array
    [parts addObject:[NSString stringWithString:s]];
    return parts;
}

@implementation NSString (CKAdditional)

- (NSString *)trimming {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) isVersionStringGE:(NSString *)version {
    NSComparisonResult result = [self compareToVersion:version];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

- (NSComparisonResult) compareToVersion:(NSString *)version {
    NSArray *partsA = splitVersionString(self);
    NSArray *partsB = splitVersionString(version);
    
    NSString *partA, *partB;
    NSUInteger i, n;
    long long valueA, valueB;
    SUCharacterType typeA, typeB;
    
    n = MIN([partsA count], [partsB count]);
    for (i = 0; i < n; ++i) {
        partA = [partsA objectAtIndex:i];
        partB = [partsB objectAtIndex:i];
        
        typeA = typeOfCharacter(partA);
        typeB = typeOfCharacter(partB);
        
        // Compare types
        if (typeA == typeB) {
            // Same type; we can compare
            if (typeA == kNumberType) {
                valueA = [partA longLongValue];
                valueB = [partB longLongValue];
                if (valueA > valueB) {
                    return NSOrderedDescending;
                } else if (valueA < valueB) {
                    return NSOrderedAscending;
                }
            } else if (typeA == kStringType) {
                NSComparisonResult result = [partA compare:partB];
                if (result != NSOrderedSame) {
                    return result;
                }
            }
        } else {
            // Not the same type? Now we have to do some validity checking
            if (typeA != kStringType && typeB == kStringType) {
                // typeA wins
                return NSOrderedDescending;
            } else if (typeA == kStringType && typeB != kStringType) {
                // typeB wins
                return NSOrderedAscending;
            } else {
                // One is a number and the other is a period. The period is invalid
                if (typeA == kNumberType) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }
        }
    }
    // The versions are equal up to the point where they both still have parts
    // Lets check to see if one is larger than the other
    if ([partsA count] != [partsB count]) {
        // Yep. Lets get the next part of the larger
        // n holds the index of the part we want.
        NSString *missingPart;
        SUCharacterType missingType;
        NSComparisonResult shorterResult, largerResult;
        
        if ([partsA count] > [partsB count]) {
            missingPart = [partsA objectAtIndex:n];
            shorterResult = NSOrderedAscending;
            largerResult = NSOrderedDescending;
        } else {
            missingPart = [partsB objectAtIndex:n];
            shorterResult = NSOrderedDescending;
            largerResult = NSOrderedAscending;
        }
        
        missingType = typeOfCharacter(missingPart);
        // Check the type
        if (missingType == kStringType) {
            // It's a string. Shorter version wins
            return shorterResult;
        } else {
            // It's a number/period. Larger version wins
            return largerResult;
        }
    }
    
    // The 2 strings are identical
    return NSOrderedSame;
}
@end

@implementation UIColor (Hex)
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"#"])
            cString = [cString substringFromIndex:1];
            if ([cString length] != 6)
                return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];   
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
