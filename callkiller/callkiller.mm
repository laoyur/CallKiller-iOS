#line 1 "/Volumes/data/projects/callkiller/callkiller/callkiller.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>

#import "TUCall.h"
#import "TUCallCenter.h"
#import "TUCallSoundPlayer.h"
#import "CTCallCenter.h"
#import "CXCall.h"
#import "TUProxyCall.h"
#import "TUHandle.h"

#import "statics.h"
#define SQLITE_OPEN_READONLY 0x00000001

static FMDatabase *db = nil;
static TUProxyCall *pendingIncomingTUCall = nil;

static void Log(const char *fmt, ...) {
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
    
    
    NSString *path = @"/var/mobile/callkiller.log";
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

static BOOL isCallInBlackList(TUCall *call) {
    
    if (call.isBlocked)
        return YES;
   
    
    
    
    if (call.contactIdentifier)
        return NO;
    
    
    if (!db)
        return NO;
    
    NSString *phonenumber = call.handle.value;
    if ([phonenumber hasPrefix:@"+86"]) {
        
        phonenumber = [phonenumber substringFromIndex:3];
    }
    
    NSString *number2Query = nil;
    if (phonenumber.length == 11 && 
        ([phonenumber hasPrefix:@"13"] ||
         [phonenumber hasPrefix:@"15"] ||
         [phonenumber hasPrefix:@"17"] ||
         [phonenumber hasPrefix:@"18"] ||
         [phonenumber hasPrefix:@"19"]
    )) {
        
        number2Query = [NSString stringWithFormat:@"86%@", phonenumber];
    } else {
        if ([phonenumber hasPrefix:@"0"]) {
            
            phonenumber = [phonenumber substringFromIndex:1];
        }
        if (phonenumber.length < 9) {
            
            number2Query = phonenumber;
        } else {
            number2Query = [NSString stringWithFormat:@"86%@", phonenumber];
        }
    }
    
    
    
    NSString *label = nil;
    FMResultSet *rs = [db executeQuery:@"select localized_label from\
                       (select * from\
                        (select id from PhoneNumber where number = ?) as A\
                        left join PhoneNumberIdentificationEntry  as B on A.id = B.phone_number_id) as C\
                       left join Label as L where L.id = C.label_id", number2Query];
    if ([rs next]) {
        label = [rs stringForColumnIndex:0];
    }
    [rs close];
    Log("==== label found: %@", label);   
    
    if ([label containsString:@"推销"] ||
        [label containsString:@"广告"] ||
        [label containsString:@"房产"] ||
        [label containsString:@"中介"] ||
        [label containsString:@"骚扰"] ||
        [label containsString:@"诈骗"] ||
        [label containsString:@"保险"] ||
        [label containsString:@"理财"]
        ) {
        return YES;
    }
    return NO;
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SpringBoard; @class SBTelephonyManager; 
static void (*_logos_orig$_ungrouped$SBTelephonyManager$callEventHandler$)(_LOGOS_SELF_TYPE_NORMAL SBTelephonyManager* _LOGOS_SELF_CONST, SEL, NSNotification*); static void _logos_method$_ungrouped$SBTelephonyManager$callEventHandler$(_LOGOS_SELF_TYPE_NORMAL SBTelephonyManager* _LOGOS_SELF_CONST, SEL, NSNotification*); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); 

#line 118 "/Volumes/data/projects/callkiller/callkiller/callkiller.xm"

static void _logos_method$_ungrouped$SBTelephonyManager$callEventHandler$(_LOGOS_SELF_TYPE_NORMAL SBTelephonyManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification* arg1) {
    TUProxyCall *call = arg1.object;
    Log("call status: %d", call.callStatus);
    if (pendingIncomingTUCall) {
        if (call == pendingIncomingTUCall) {
            







            if (call.callStatus == 1 ||     
                call.callStatus == 6) {     
                pendingIncomingTUCall = nil;
                Log("==== pendingIncomingTUCall set nil");
            }
        } else {
            
        }
    } else {
        if (call.isIncoming && call.callStatus == 4) {  
            
            Log("==== pendingIncomingTUCall: %@, contact: %@, label: %@", call.handle.value, call.contactIdentifier, call.localizedLabel);
            pendingIncomingTUCall = call;
            
            if (isCallInBlackList(call)) {
                Log("==== call blocked");
                [[TUCallCenter sharedInstance] disconnectCall:call];
                return; 
            }
        }
    }
    _logos_orig$_ungrouped$SBTelephonyManager$callEventHandler$(self, _cmd, arg1);
}




static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
    NSString *path = @"/var/mobile/callkiller.log";
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSData data] writeToFile:path atomically:YES];
    }
    NSString *callDB = @"/var/mobile/Library/CallDirectory/CallDirectory.db";
    if ([[NSFileManager defaultManager] fileExistsAtPath:callDB]) {
        db = [FMDatabase databaseWithPath:callDB];
        db.crashOnErrors = NO;
        db.logsErrors = NO;
        [db openWithFlags:SQLITE_OPEN_READONLY];    
    }
}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBTelephonyManager = objc_getClass("SBTelephonyManager"); MSHookMessageEx(_logos_class$_ungrouped$SBTelephonyManager, @selector(callEventHandler:), (IMP)&_logos_method$_ungrouped$SBTelephonyManager$callEventHandler$, (IMP*)&_logos_orig$_ungrouped$SBTelephonyManager$callEventHandler$);Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} }
#line 176 "/Volumes/data/projects/callkiller/callkiller/callkiller.xm"
