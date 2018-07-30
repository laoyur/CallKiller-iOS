// See http://iphonedevwiki.net/index.php/Logos

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <UIKit/UIKit.h>
#import <notify.h>
#import <dlfcn.h>

#import "TUCall.h"
#import "TUCallCenter.h"
#import "TUCallSoundPlayer.h"
#import "CTCallCenter.h"
#import "CXCall.h"
#import "TUProxyCall.h"
#import "TUHandle.h"
#import "CHRecentCall.h"

#import "statics.h"
#import "Preference.h"
#import "MobileRegionDetector.h"

#define SQLITE_OPEN_READONLY 0x00000001
#define kCallDbPath @"/var/mobile/Library/CallDirectory/CallDirectory.db"

typedef int (*DSYSTEM)(const char *);
static DSYSTEM dsystem = 0;
static FMDatabase *db = nil;
static TUProxyCall *pendingIncomingTUCall = nil;
static BOOL pendingIncomingTUCallBlocked = NO;
static NSDictionary *pref = nil;

static BOOL isCallInBlackList(TUCall *call) {
    // ?? 不确定isBlocked这个属性有没有作用
    if (call.isBlocked)
        return YES;
   
    // 联系人数据库位置
    // /var/mobile/Library/AddressBook/AddressBook.sqlitedb -- ABPersonFullTextSearch_content -- c16Phone
    if (call.contactIdentifier && [pref[kKeyBypassContacts] boolValue])
        return NO;
    
    NSString *phonenumber = call.handle.value;
    
    if (phonenumber.length == 0 && [pref[kKeyBlockUnknown] boolValue]) {
        // 未知号码 ？
        return YES;
    }
    
    if ([phonenumber hasPrefix:@"+86"]) {
        // 去掉+86
        phonenumber = [phonenumber substringFromIndex:3];
    }
    
    if ([phonenumber hasPrefix:@"0"]) {
        // 固话，按区号拦截规则
        for (NSString *phonePrefix in pref[kKeyBlockedCitiesFlattened]) {
            if ([phonenumber hasPrefix:phonePrefix]) {
                return YES;
            }
        }
    } else if (phonenumber.length == 11 && 
               ([phonenumber hasPrefix:@"13"] ||
                [phonenumber hasPrefix:@"15"] ||
                [phonenumber hasPrefix:@"17"] ||
                [phonenumber hasPrefix:@"18"] ||
                [phonenumber hasPrefix:@"19"] )) 
        {
        // 手机号，按归属地拦截规则
        NSString *regionCode = [[MobileRegionDetector sharedInstance] detectRegionCode:phonenumber];
        if (regionCode.length > 0 && [pref[kKeyMobileBlockedCitiesFlattened] containsObject:regionCode]) {
            return YES;
        }
    }

    // 黑名单拦截
    NSArray *blacklist = pref[kKeyBlacklist];
    for (NSArray *item in blacklist) {
        NSString *pattern = item[1];    // 0 - user_input; 1 - pattern; 2 - comment
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        if (regex && [regex firstMatchInString:phonenumber options:0 range: NSMakeRange(0, [phonenumber length])]) {
            return YES;
        }
    }
    
    if (!db) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:kCallDbPath]) {
            db = [FMDatabase databaseWithPath:kCallDbPath];
            db.crashOnErrors = NO;
            db.logsErrors = NO;
            [db openWithFlags:SQLITE_OPEN_READONLY];    // 只读方式打开
        } else {
            return NO;
        }
    }
   
    // 关键字拦截
    NSString *number2Query = nil;
    if (phonenumber.length == 11 && 
        ([phonenumber hasPrefix:@"13"] ||
         [phonenumber hasPrefix:@"15"] ||
         [phonenumber hasPrefix:@"17"] ||
         [phonenumber hasPrefix:@"18"] ||
         [phonenumber hasPrefix:@"19"]
    )) {
        // 手机号
        number2Query = [NSString stringWithFormat:@"86%@", phonenumber];
    } else {
        if ([phonenumber hasPrefix:@"0"]) {
            // 0开头，表示是区号，去掉0
            phonenumber = [phonenumber substringFromIndex:1];
        }
        if (phonenumber.length < 9) {
            // 认为是短号，无需加86前缀
            number2Query = phonenumber;
        } else {
            number2Query = [NSString stringWithFormat:@"86%@", phonenumber];
        }
    }
    
    // 说明：CallDirectory.PhoneNumber.number是整型，而非字符串，这也是上面区号的情况，需要去掉前导0的原因
    
    NSString *label = nil;
    FMResultSet *rs = [db executeQuery:@"select localized_label from\
                       (select * from\
                        (select id from PhoneNumber where number = ?) as A\
                        left join PhoneNumberIdentificationEntry as B on A.id = B.phone_number_id) as C\
                       left join Label as L where L.id = C.label_id", number2Query];
    if ([rs next]) {
        label = [rs stringForColumnIndex:0];
    }
    [rs close];
    Log("== label found in db: %@", label);   // label可能是nil
    
    NSArray *keywords = pref[kKeyBlackKeywords];
    for (NSString *kwd in keywords) {
        if ([label containsString:kwd]) {
            return YES;
        }
    }
    return NO;
}

%hook SBTelephonyManager
-(void)callEventHandler:(NSNotification*)arg1 {
    if (![pref[kKeyEnabled] boolValue]) {
        %orig;
        return;
    }
    TUProxyCall *call = arg1.object;
    if (pendingIncomingTUCall) {
        if (call == pendingIncomingTUCall) {
            /**
             call.status:
             1 - call established
             3 - outgoing connecting
             4 - incoming ringing
             5 - disconnecting
             6 - disconnected
             // 以上是我根据调试结果推断的
             */
            if (call.status == 1) {
                // 用户手动接通
                pendingIncomingTUCall = nil;
                pendingIncomingTUCallBlocked = NO;  // just in case
            } else if (call.status == 6) { 
                // 电话被挂断
                pendingIncomingTUCall = nil;
                if (pendingIncomingTUCallBlocked) {
                    pendingIncomingTUCallBlocked = NO;
                    return; // 不调用 %orig
                } else {
                    pendingIncomingTUCallBlocked = NO;
                }
            } else {
                // 其他状态
                if (pendingIncomingTUCallBlocked) {
                    return; // 不调用 %orig，防止出现通话界面闪一下的情况
                }
            }
        } else {
            // 过程中来了第二通电话，不管它
        }
    } else {
        if (call.isIncoming && call.status == 4) {  // 4 ringing
            // new incoming call
            Log("== pendingIncomingTUCall: %@, contact: %@, label: %@, isBlocked: %@", call.handle.value, call.contactIdentifier, call.localizedLabel, call.isBlocked ? @"Y" : @"N");
            pendingIncomingTUCall = call;
            
            if (isCallInBlackList(call)) {
                Log("== call blocked");
                pendingIncomingTUCallBlocked = YES;
                
                // it will trigger callEventHandler immediatelly with call.status == 5
                [[TUCallCenter sharedInstance] disconnectCall:call];
                return; // 不调用 %orig，防止出现通话界面闪一下的情况
            }
        }
    }
    %orig;
}
%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
//    freopen("/var/mobile/callkiller/callkiller.log", "a+", stderr);
    
//    dsystem = (DSYSTEM)dlsym(RTLD_DEFAULT, "system");
//    dsystem("touch /var/mobile/callkiller/callkiller.log");
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:kCallDbPath]) {
        db = [FMDatabase databaseWithPath:kCallDbPath];
        db.crashOnErrors = NO;
        db.logsErrors = NO;
        [db openWithFlags:SQLITE_OPEN_READONLY];    // 只读方式打开
    }

    int token;
    notify_register_dispatch("com.laoyur.callkiller.preference-updated", &token, dispatch_get_main_queue(), ^(int token) {
        pref = [Preference load];
        // Log("== pref updated: %@", pref);
    });
    
    pref = [Preference load];
}

%end

/*
%hook MPRecentsTableViewController
- (void)viewDidLoad {
    %orig;
    Log("MPRecentsTableViewController viewDidLoad");
}
%end

%hook MPRecentsTableViewCell

- (void) setCall:(CHRecentCall*)call {
    %orig;
    Log("recent call: %@", call);
}

%end

%hook PHRecentCallsTableViewController
- (void)viewDidLoad {
    %orig;
    Log("PHRecentCallsTableViewController viewDidLoad");
}
%end
*/
