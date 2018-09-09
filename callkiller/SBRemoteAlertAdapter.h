//
//  SBRemoteAlertAdapter.h
//  callkiller
//
//  Created by mac on 2018/8/3.
//

#ifndef SBRemoteAlertAdapter_h
#define SBRemoteAlertAdapter_h

@interface SBRemoteAlertAdapter// : SBAlertAdapter <_SBRemoteAlertHostViewControllerDelegate, SBRemoteAlert> {
    
//    NSString* _serviceIdentifier;
//    _SBRemoteAlertHostViewController* _remoteAlertHostViewController;
//    id<SBRemoteAlertAdapterDelegate> _adapterDelegate;
//    id<SBRemoteAlertDelegate> _remoteAlertDelegate;
//    NSString* _impersonatedApplicationBundleID;
//    BOOL _dismissWithHomeButton;
//    BOOL _userRequestedHomeButtonDismissal;
//    unsigned long long _desiredButtonEvents;
//    BOOL _wantsWallpaperTunnel;
//    BOOL _hasTranslucentBackground;
//    long long _requestedBackgroundStyle;
//    BOOL _allowsAlertStacking;
//    long long _dismissalAnimationStyle;
//    long long _swipeDismissalStyle;
//    BOOL _disableFadeInAnimation;
//    NSMutableSet* _idleTimerDisabledReasons;
//    double _requestedAutoLockTime;
//    BOOL _hasCustomStatusBarStyle;
//    long long _customStatusBarStyle;
//    int _statusBarStyleOverridesToCancel;
//    BOOL _suppressesSiri;
//    BOOL _activatedForSiri;
//    BOOL _shouldPendAlertItems;
//    BOOL _dismissOnUILock;
//    long long _desiredLaunchingInterfaceOrientation;
//    /*^block*/id _clientActivationHandler;
//    /*^block*/id _clientDeactivationHandler;
//    long long _whitePointAdaptivityStyle;
//    BOOL _forCarPlay;
//    BOOL _isActive;
//    NSMapTable* _scheduledWatchdogsToReasonsMap;
//    BOOL _beingPresentedObscured;
//    id<SBRemoteAlertAdapterStyleObserver> _adapterObserver;
//    
//}

//@property (assign,nonatomic) long long requestedBackgroundStyle;                                        //@synthesize requestedBackgroundStyle=_requestedBackgroundStyle - In the implementation block
//@property (assign,nonatomic) BOOL activatedForSiri;                                                     //@synthesize activatedForSiri=_activatedForSiri - In the implementation block
//@property (getter=_isForCarPlay,nonatomic,readonly) BOOL forCarPlay;                                    //@synthesize forCarPlay=_forCarPlay - In the implementation block
//@property (assign,nonatomic,__weak) id<SBRemoteAlertAdapterDelegate> adapterDelegate;                   //@synthesize adapterDelegate=_adapterDelegate - In the implementation block
//@property (assign,nonatomic,__weak) id<SBRemoteAlertAdapterStyleObserver> adapterObserver;              //@synthesize adapterObserver=_adapterObserver - In the implementation block
//@property (nonatomic,readonly) long long dismissalAnimationStyle;                                       //@synthesize dismissalAnimationStyle=_dismissalAnimationStyle - In the implementation block
//@property (nonatomic,readonly) BOOL userRequestedHomeButtonDismissal;                                   //@synthesize userRequestedHomeButtonDismissal=_userRequestedHomeButtonDismissal - In the implementation block
//@property (nonatomic,readonly) BOOL wantsWallpaperTunnel;                                               //@synthesize wantsWallpaperTunnel=_wantsWallpaperTunnel - In the implementation block
//@property (nonatomic,readonly) BOOL disablesFadeInAnimation;                                            //@synthesize disableFadeInAnimation=_disableFadeInAnimation - In the implementation block
@property (nonatomic,weak,readonly) NSString * serviceBundleIdentifier; 
//@property (assign,getter=isBeingPresentedObscured,nonatomic) BOOL beingPresentedObscured;               //@synthesize beingPresentedObscured=_beingPresentedObscured - In the implementation block
//@property (readonly) unsigned long long hash; 
//@property (readonly) Class superclass; 
//@property (copy,readonly) NSString * description; 
//@property (copy,readonly) NSString * debugDescription; 
//@property (nonatomic,__weak,readonly) id<SBRemoteAlertDelegate> remoteAlertDelegate;                    //@synthesize remoteAlertDelegate=_remoteAlertDelegate - In the implementation block
//+(void)requestRemoteViewService:(id)arg1 options:(id)arg2 completion:(/*^block*/id)arg3 ;
//+(void)_requestWithServiceName:(id)arg1 serviceClass:(id)arg2 context:(id)arg3 options:(id)arg4 completion:(/*^block*/id)arg5 ;
//+(void)requestWithDefinition:(id)arg1 context:(id)arg2 delegate:(id)arg3 completion:(/*^block*/id)arg4 ;
//-(id)coordinatorRequestedIdleTimerDescriptor:(id)arg1 ;
//-(BOOL)handleHeadsetButtonPress:(BOOL)arg1 ;
//-(BOOL)handleHomeButtonPress;
//-(id)_impersonatesApplicationWithBundleID;
//-(void)setActivationHandler:(/*^block*/id)arg1 deactivationHandler:(/*^block*/id)arg2 ;
//-(void)setBeingPresentedObscured:(BOOL)arg1 ;
//-(BOOL)matchesRemoteAlertService:(id)arg1 options:(id)arg2 ;
//-(long long)dismissalAnimationStyle;
//-(BOOL)userRequestedHomeButtonDismissal;
//-(double)autoLockTime;
//-(BOOL)_shouldDismissSwitcherOnActivation;
//-(BOOL)handleLockButtonPress;
//-(long long)swipeDismissalStyle;
//-(id)_displayLayoutElementIdentifier;
//-(int)statusBarStyleOverridesToCancel;
//-(BOOL)suppressesControlCenter;
//-(BOOL)handleVolumeUpButtonPress;
//-(BOOL)handleVolumeDownButtonPress;
//-(BOOL)allowsStackingOfAlert:(id)arg1 ;
//-(BOOL)shouldPendAlertItemsWhileActive;
//-(BOOL)suppressesSiri;
//-(BOOL)activatedForSiri;
//-(BOOL)shouldDismissOnUILock;
//-(long long)requestedBackgroundStyle;
//-(void)setAdapterObserver:(id<SBRemoteAlertAdapterStyleObserver>)arg1 ;
//-(BOOL)isBeingPresentedObscured;
//-(BOOL)disablesFadeInAnimation;
//-(BOOL)wantsWallpaperTunnel;
//-(int)_serviceProcessIdentifier;
//-(void)setAdapterDelegate:(id<SBRemoteAlertAdapterDelegate>)arg1 ;
//-(BOOL)_isForCarPlay;
//-(void)remoteAlertWantsToAllowBanners:(BOOL)arg1 ;
//-(void)remoteAlertWantsToAllowAlertItems:(BOOL)arg1 ;
//-(void)remoteAlertDidRequestDismissal;
//-(void)remoteAlertWantsToUpdateAllowedHardwareButtonEvents:(unsigned long long)arg1 ;
//-(void)remoteAlertWantsWallpaperTunnelActive:(BOOL)arg1 ;
//-(void)remoteAlertWantsToSetWallpaperStyle:(long long)arg1 withDuration:(double)arg2 ;
//-(void)remoteAlertWantsMenuButtonDismissal:(BOOL)arg1 ;
//-(void)remoteAlertWantsToAllowAlertStacking:(BOOL)arg1 ;
//-(void)remoteAlertWantsToSetDismissalAnimationStyle:(long long)arg1 ;
//-(void)remoteAlertWantsToSetSwipeDismissalStyle:(long long)arg1 ;
//-(void)remoteAlertWantsToSetBackgroundMaterialDescriptor:(id)arg1 ;
//-(void)remoteAlertWantsToSetBackgroundWeighting:(double)arg1 animationSettings:(id)arg2 ;
//-(void)remoteAlertWantsToSetStatusBarStyleOverridesToCancel:(int)arg1 ;
//-(void)remoteAlertWantsToSetIdleTimerDisabled:(BOOL)arg1 forReason:(id)arg2 ;
//-(void)remoteAlertWantsToSetAutoLockDuration:(double)arg1 ;
//-(void)remoteAlertWantsToDismissOnUILock:(BOOL)arg1 ;
//-(void)remoteAlertWantsToDisableFadeInAnimation:(BOOL)arg1 ;
//-(void)remoteAlertWantsToSetLaunchingInterfaceOrientation:(long long)arg1 ;
//-(void)remoteAlertWantsToSetOrientationChangedEventsEnabled:(BOOL)arg1 ;
//-(void)remoteAlertWantsToSetWhitePointAdaptivityStyle:(long long)arg1 ;
//-(void)remoteAlertDidTerminateWithError:(id)arg1 ;
//-(id)_initWithRemoteAlertHostViewController:(id)arg1 ;
//-(void)_cleanupIdleTimerDisabledReasons;
//-(void)_setImpersonatedApplicationBundleID:(id)arg1 ;
//-(void)_setDismissWithHomeButton:(BOOL)arg1 ;
//-(void)_setDismissalAnimationStyle:(long long)arg1 ;
//-(void)_setSwipeDismissalStyle:(long long)arg1 ;
//-(void)_setLaunchingInterfaceOrientation:(long long)arg1 ;
//-(void)setRequestedBackgroundStyle:(long long)arg1 ;
//-(void)_setHasTranslucentBackground:(BOOL)arg1 ;
//-(void)_setSuppressesSiri:(BOOL)arg1 ;
//-(void)_setShouldPendAlertItems:(BOOL)arg1 ;
//-(void)setActivatedForSiri:(BOOL)arg1 ;
//-(void)_setCustomStatusBarStyle:(long long)arg1 ;
//-(void)_setShouldDisableFadeInAnimation:(BOOL)arg1 ;
//-(void)_sendWithDebugDescription:(id)arg1 watchdogTimeout:(double)arg2 errorHandler:(/*^block*/id)arg3 operation:(/*^block*/id)arg4 ;
//-(void)_sendWithDebugDescription:(id)arg1 operation:(/*^block*/id)arg2 ;
//-(BOOL)_dismissalAnimationMimicsApp;
//-(id<SBRemoteAlertAdapterStyleObserver>)adapterObserver;
//-(BOOL)_isWhitelistedForSwipeDismissalStyle:(long long)arg1 ;
//-(void)_didTerminateWithError:(id)arg1 ;
//-(void)_setBackgroundMaterialDescriptor:(id)arg1 ;
//-(void)_setBackgroundWeighting:(double)arg1 animationSettings:(id)arg2 ;
//-(id<SBRemoteAlertAdapterDelegate>)adapterDelegate;
//-(void)dealloc;
//-(BOOL)isRemote;
//-(long long)preferredWhitePointAdaptivityStyle;
//-(long long)preferredStatusBarStyle;
//-(int)_preferredStatusBarVisibility;
//-(void)deactivate;
//-(BOOL)canBecomeFirstResponder;
//-(long long)preferredInterfaceOrientationForPresentation;
//-(void)viewWillAppear:(BOOL)arg1 ;
//-(void)viewDidAppear:(BOOL)arg1 ;
//-(void)viewWillDisappear:(BOOL)arg1 ;
//-(void)viewDidDisappear:(BOOL)arg1 ;
//-(id)childViewControllerForStatusBarStyle;
//-(id)childViewControllerForStatusBarHidden;
//-(id)childViewControllerForScreenEdgesDeferringSystemGestures;
//-(id)childViewControllerForHomeIndicatorAutoHidden;
//-(void)_disconnect;
//-(void)activate;
//-(id)initWithViewController:(id)arg1 ;
//-(id)legibilitySettings;
//-(void)synchronizeAnimationsInActions:(/*^block*/id)arg1 ;
//-(NSString *)serviceBundleIdentifier;
//-(void)prepareForActivationWithContext:(id)arg1 completion:(/*^block*/id)arg2 ;
//-(BOOL)handleButtonActions:(id)arg1 ;
//-(void)handleDoubleHeightStatusBarTap;
//-(void)noteActivatedForActivityContinuationWithIdentifier:(id)arg1 ;
//-(BOOL)hasTranslucentBackground;
//-(BOOL)wantsHomeButtonPress;
//-(id<SBRemoteAlertDelegate>)remoteAlertDelegate;
//-(void)setFluidDismissalState:(id)arg1 ;
//-(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
//-(id)succinctDescriptionBuilder;
@end

#endif /* SBRemoteAlertAdapter_h */
