//
//  TUCallCenter.h
//  callkiller
//
//  Created by mac on 2018/7/11.
//

#ifndef TUCallCenter_h
#define TUCallCenter_h

@class TUCall;
@interface TUCallCenter //: NSObject <TUCallContainer> {
    
//}

//@property (nonatomic,retain) NSObject*<OS_dispatch_queue> queue;                                     //@synthesize queue=_queue - In the implementation block
//@property (nonatomic,retain) TUCallServicesInterface * callServicesInterface;                        //@synthesize callServicesInterface=_callServicesInterface - In the implementation block
//@property (nonatomic,retain) TUAudioDeviceController * audioDeviceController;                        //@synthesize audioDeviceController=_audioDeviceController - In the implementation block
//@property (nonatomic,retain) TUVideoDeviceController * videoDeviceController;                        //@synthesize videoDeviceController=_videoDeviceController - In the implementation block
//@property (nonatomic,retain) CNContactStore * contactStore;                                          //@synthesize contactStore=_contactStore - In the implementation block
//@property (nonatomic,retain) TUCallProviderManager * providerManager;                                //@synthesize providerManager=_providerManager - In the implementation block
//@property (nonatomic,retain) TUConversationManager * conversationManager;                            //@synthesize conversationManager=_conversationManager - In the implementation block
@property (assign,nonatomic) CGSize localLandscapeAspectRatio;                                       //@synthesize localLandscapeAspectRatio=_localLandscapeAspectRatio - In the implementation block
@property (assign,nonatomic) CGSize localPortraitAspectRatio;                                        //@synthesize localPortraitAspectRatio=_localPortraitAspectRatio - In the implementation block
@property (nonatomic,copy) id disconnectCallPreflight;                                               //@synthesize disconnectCallPreflight=_disconnectCallPreflight - In the implementation block
//@property (nonatomic,readonly) id<TUCallContainerPrivate> callContainer; 
@property (nonatomic,readonly) BOOL canMergeCalls; 
@property (getter=isAddCallAllowed,nonatomic,readonly) BOOL addCallAllowed; 
@property (getter=isAmbiguous,nonatomic,readonly) BOOL ambiguous; 
@property (getter=isEndAndAnswerAllowed,nonatomic,readonly) BOOL endAndAnswerAllowed; 
@property (getter=isHoldAndAnswerAllowed,nonatomic,readonly) BOOL holdAndAnswerAllowed; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
@property (nonatomic,copy,readonly) NSArray * currentCalls; 
@property (nonatomic,copy,readonly) NSArray * currentVideoCalls; 
@property (nonatomic,copy,readonly) NSArray * currentAudioAndVideoCalls; 
@property (nonatomic,copy,readonly) NSArray * incomingCalls; 
@property (nonatomic,copy,readonly) NSArray * displayedCalls; 
@property (nonatomic,copy,readonly) NSArray * conferenceParticipantCalls; 
@property (nonatomic,copy,readonly) NSArray * callsHostedElsewhere; 
@property (nonatomic,copy,readonly) NSArray * callsWithAnEndpointElsewhere; 
@property (nonatomic,copy,readonly) NSArray * callsHostedOrAnEndpointElsewhere; 
@property (nonatomic,copy,readonly) NSArray * callsOnDefaultPairedDevice; 
@property (nonatomic,readonly) TUCall * incomingCall; 
@property (nonatomic,readonly) TUCall * incomingVideoCall; 
@property (nonatomic,readonly) TUCall * activeVideoCall; 
@property (nonatomic,readonly) TUCall * currentVideoCall; 
@property (nonatomic,readonly) unsigned long long currentCallCount; 
@property (nonatomic,readonly) unsigned long long currentVideoCallCount; 
@property (nonatomic,readonly) unsigned long long currentAudioAndVideoCallCount; 
@property (nonatomic,readonly) unsigned long long callCountOnDefaultPairedDevice; 
@property (nonatomic,readonly) BOOL hasCurrentCalls; 
@property (nonatomic,readonly) BOOL hasCurrentAudioCalls; 
@property (nonatomic,readonly) BOOL hasCurrentVideoCalls; 
@property (nonatomic,readonly) BOOL anyCallIsHostedOnCurrentDevice; 
@property (nonatomic,readonly) BOOL anyCallIsEndpointOnCurrentDevice; 
@property (nonatomic,copy,readonly) NSArray * currentCallGroups; 
@property (nonatomic,copy,readonly) NSArray * callGroupsOnDefaultPairedDevice; 
+(id)sharedInstance;
+(BOOL)isInCallServiceProcess;
+(const void*)sharedAddressBook;
+(id)sharedInstanceWithQueue:(id)arg1 daemonDelegate:(id)arg2 shouldRegister:(BOOL)arg3 ;
+(id)callCenterWithQueue:(id)arg1 daemonDelegate:(id)arg2 shouldRegister:(BOOL)arg3 ;
+(id)callCenterWithQueue:(id)arg1 ;
+(id)sharedContactStore;
-(id)init;
-(void)dealloc;
-(NSString *)debugDescription;
-(id)initWithQueue:(id)arg1 ;
//-(NSObject*<OS_dispatch_queue>)queue;
-(NSArray *)currentCalls;
//-(void)setQueue:(NSObject*<OS_dispatch_queue>)arg1 ;
-(BOOL)isAmbiguous;
-(void)launchAppForDialRequest:(id)arg1 completion:(/*^block*/id)arg2 ;
//-(id<TUCallContainerPrivate>)callContainer;
-(id)frontmostCall;
-(TUCall *)currentVideoCall;
-(id)callsPassingTest:(/*^block*/id)arg1 ;
-(id)conferenceCall;
-(id)callPassingTest:(/*^block*/id)arg1 ;
-(TUCall *)incomingVideoCall;
-(TUCall *)activeVideoCall;
-(NSArray *)currentVideoCalls;
-(id)callPassingTest:(/*^block*/id)arg1 sortedUsingComparator:(/*^block*/id)arg2 ;
-(unsigned long long)currentCallCount;
-(TUCall *)incomingCall;
-(id)callWithStatus:(int)arg1 ;
-(id)audioOrVideoCallWithStatus:(int)arg1 ;
-(unsigned long long)countOfCallsPassingTest:(/*^block*/id)arg1 ;
-(BOOL)anyCallPassesTest:(/*^block*/id)arg1 ;
-(BOOL)allCallsPassTest:(/*^block*/id)arg1 ;
-(NSArray *)currentAudioAndVideoCalls;
-(NSArray *)callsOnDefaultPairedDevice;
-(NSArray *)conferenceParticipantCalls;
-(id)callsWithStatus:(int)arg1 ;
-(id)audioAndVideoCallsWithStatus:(int)arg1 ;
-(id)callsWithGroupUUID:(id)arg1 ;
-(id)videoCallWithStatus:(int)arg1 ;
-(id)callWithUniqueProxyIdentifier:(id)arg1 ;
-(id)callWithCallUUID:(id)arg1 ;
-(id)displayedCallFromCalls:(id)arg1 ;
-(BOOL)allCallsAreOfService:(int)arg1 ;
-(NSArray *)incomingCalls;
-(NSArray *)displayedCalls;
-(NSArray *)callsHostedElsewhere;
-(NSArray *)callsWithAnEndpointElsewhere;
-(NSArray *)callsHostedOrAnEndpointElsewhere;
-(unsigned long long)currentVideoCallCount;
-(unsigned long long)callCountOnDefaultPairedDevice;
-(BOOL)hasCurrentCalls;
-(BOOL)hasCurrentAudioCalls;
-(BOOL)hasCurrentVideoCalls;
-(BOOL)anyCallIsHostedOnCurrentDevice;
-(BOOL)anyCallIsEndpointOnCurrentDevice;
-(NSArray *)currentCallGroups;
-(NSArray *)callGroupsOnDefaultPairedDevice;
-(id)_allCalls;
-(id)displayedCall;
-(id)frontmostAudioOrVideoCall;
-(BOOL)existingCallsHaveMultipleProviders;
-(CGSize)localLandscapeAspectRatio;
-(void)setLocalLandscapeAspectRatio:(CGSize)arg1 ;
//-(void)setCallServicesInterface:(TUCallServicesInterface *)arg1 ;
-(id)callServicesClientCapabilities;
-(void)joinConversationWithRequest:(id)arg1 ;
-(void)swapCalls;
-(void)disconnectCurrentCallAndActivateHeld;
-(void)disconnectAllCalls;
-(void)pullRelayingCallsFromClient;
-(void)pushRelayingCallsToHostWithSourceIdentifier:(id)arg1 ;
-(void)pushHostedCallsToPairedClientDevice;
-(void)pullHostedCallsFromPairedHostDevice;
-(void)willEnterBackgroundForAllCalls;
-(void)enteredBackgroundForAllCalls;
-(void)dialWithRequest:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)pullCallFromClientUsingHandoffActivityUserInfo:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)registerWithCompletionHandler:(/*^block*/id)arg1 ;
-(void)answerWithRequest:(id)arg1 ;
//-(TUCallProviderManager *)providerManager;
//-(TUCallServicesInterface *)callServicesInterface;
-(void)holdCall:(id)arg1 ;
-(void)unholdCall:(id)arg1 ;
//-(TUAudioDeviceController *)audioDeviceController;
-(BOOL)isRelayCallingSupportedForProvider:(id)arg1 isVideo:(BOOL)arg2 ;
-(BOOL)_shouldPreferRelayOverDirectSecondaryCallingForRelayingCallingAvailability:(int)arg1 isRelayCallingSupported:(BOOL)arg2 ;
-(BOOL)_existingCallsAllowDialRequest:(id)arg1 allowVoiceWithData:(BOOL)arg2 ;
-(BOOL)isDirectCallingCurrentlyAvailableForProvider:(id)arg1 isVideo:(BOOL)arg2 ;
-(BOOL)_isCallingAvailableOnSecondaryDeviceWithRelayCallingAvailability:(int)arg1 isProviderAvailable:(BOOL)arg2 isRelayAllowed:(BOOL)arg3 isEmergency:(BOOL)arg4 supportsBasebandCalling:(BOOL)arg5 shouldUseRelay:(BOOL*)arg6 ;
-(BOOL)_canDialWithRequest:(id)arg1 shouldUseRelay:(BOOL*)arg2 ;
-(id)_dialWithRequest:(id)arg1 completion:(/*^block*/id)arg2 ;
-(id)dial:(id)arg1 callID:(int)arg2 service:(int)arg3 ;
-(id)_dial:(id)arg1 callID:(int)arg2 service:(int)arg3 sourceIdentifier:(id)arg4 dialType:(long long)arg5 ;
-(id)dialEmergency:(id)arg1 sourceIdentifier:(id)arg2 ;
-(id)_dial:(id)arg1 callID:(int)arg2 provider:(id)arg3 video:(BOOL)arg4 sourceIdentifier:(id)arg5 dialType:(long long)arg6 ;
-(id)dialWithRequest:(id)arg1 ;
-(void)answerCall:(id)arg1 withSourceIdentifier:(id)arg2 wantsHoldMusic:(BOOL)arg3 ;
-(void)endActiveAndAnswerCall:(id)arg1 ;
-(void)endHeldAndAnswerCall:(id)arg1 ;
-(void)disconnectCall:(id)arg1 withReason:(int)arg2 ;
-(void)updateCall:(id)arg1 withAnswerRequest:(id)arg2 ;
-(void)_preflightDisconnectForCalls:(id)arg1 withCompletion:(/*^block*/id)arg2 ;
-(id)disconnectCallPreflight;
-(BOOL)isHoldAndAnswerAllowed;
-(BOOL)isEndAndAnswerAllowed;
-(BOOL)isMergeable;
-(unsigned long long)_callGroupCountForCall:(id)arg1 withCall:(id)arg2 ;
//-(TUVideoDeviceController *)videoDeviceController;
//-(TUConversationManager *)conversationManager;
-(BOOL)shouldPreferRelayOverDirectSecondaryCallingForProvider:(id)arg1 isVideo:(BOOL)arg2 ;
-(BOOL)canDialWithRequest:(id)arg1 ;
-(id)dial:(id)arg1 service:(int)arg2 ;
-(id)dialEmergency:(id)arg1 ;
-(void)sendFieldModeDigits:(id)arg1 forProvider:(id)arg2 ;
-(void)answerCall:(id)arg1 ;
-(void)answerCall:(id)arg1 withSourceIdentifier:(id)arg2 ;
-(void)answerCallWithHoldMusic:(id)arg1 ;
-(void)holdActiveAndAnswerCall:(id)arg1 ;
-(void)endActiveOrHeldAndAnswerCall:(id)arg1 ;
-(void)reportLocalPreviewStoppedForCall:(id)arg1 ;
-(void)resumeCall:(id)arg1 ;
-(void)groupCall:(id)arg1 withOtherCall:(id)arg2 ;
-(void)ungroupCall:(id)arg1 ;
-(void)disconnectCall:(id)arg1 ;
-(void)handleActionForWiredHeadsetMiddleButtonPress;
-(void)handleActionForWiredHeadsetMiddleButtonLongPress;
-(void)setTTYType:(int)arg1 forCall:(id)arg2 ;
-(void)pushRelayingCallsToHost;
-(void)enteredForegroundForCall:(id)arg1 ;
-(BOOL)isSwappable;
-(BOOL)isHoldAllowed;
-(BOOL)isTakingCallsPrivateAllowed;
-(BOOL)isHardPauseAvailable;
-(BOOL)isSendToVoicemailAllowed;
-(BOOL)canMergeCalls;
-(BOOL)isAddCallAllowed;
-(BOOL)canGroupCall:(id)arg1 withCall:(id)arg2 ;
//-(void)setAudioDeviceController:(TUAudioDeviceController *)arg1 ;
//-(void)setVideoDeviceController:(TUVideoDeviceController *)arg1 ;
//-(void)setProviderManager:(TUCallProviderManager *)arg1 ;
//-(void)setConversationManager:(TUConversationManager *)arg1 ;
-(void)setDisconnectCallPreflight:(id)arg1 ;
//-(CNContactStore *)contactStore;
-(void)setLocalPortraitAspectRatio:(CGSize)arg1 ;
-(CGSize)localPortraitAspectRatio;
//-(void)setContactStore:(CNContactStore *)arg1 ;
-(unsigned long long)currentAudioAndVideoCallCount;
@end

#endif /* TUCallCenter_h */
