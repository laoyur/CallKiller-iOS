//
//  TUCallNotificationManager.h
//  callkiller
//
//  Created by mac on 2018/7/11.
//

#ifndef TUCallNotificationManager_h
#define TUCallNotificationManager_h

@interface TUCallNotificationManager : NSObject {
    
    NSMutableArray* _deferredNotificationBlocks;
    
}

@property (nonatomic,retain) NSMutableArray * deferredNotificationBlocks;              //@synthesize deferredNotificationBlocks=_deferredNotificationBlocks - In the implementation block
-(void)_postNotificationName:(id)arg1 object:(id)arg2 ;
-(void)_postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 ;
-(void)postNotificationsForCall:(id)arg1 usingComparisonCall:(id)arg2 afterUpdatesInBlock:(/*^block*/id)arg3 ;
-(void)deferNotificationsUntilAfterPerformingBlock:(/*^block*/id)arg1 ;
-(void)postNotificationsForCallContainer:(id)arg1 afterUpdatesInBlock:(/*^block*/id)arg2 ;
-(void)postNotificationsForCall:(id)arg1 afterUpdatesInBlock:(/*^block*/id)arg2 ;
-(void)statusChangedForCall:(id)arg1 ;
-(void)connectingChangedForCall:(id)arg1 ;
-(void)connectedChangedForCall:(id)arg1 ;
-(void)wantsHoldMusicChangedForCall:(id)arg1 ;
-(void)endpointOnCurrentDeviceChangedForCall:(id)arg1 ;
-(void)shouldSuppressRingtoneChangedForCall:(id)arg1 ;
-(void)faceTimeIDStatusChangedForCall:(id)arg1 ;
-(void)hardPauseDigitsStateChangedForCall:(id)arg1 ;
-(void)needsManualInCallSoundsChangedForCall:(id)arg1 ;
-(void)hasSentInvitationChangedForCall:(id)arg1 ;
-(void)isUsingBasebandChangedForCall:(id)arg1 ;
-(void)isOnHoldChangedForCall:(id)arg1 ;
-(void)isUplinkMutedChangedForCall:(id)arg1 ;
-(void)isSendingAudioChangedForCall:(id)arg1 ;
-(void)isThirdPartyVideoChangedForCall:(id)arg1 ;
-(void)mediaStalledChangedForCall:(id)arg1 ;
-(void)videoDegradedChangedForCall:(id)arg1 ;
-(void)videoPausedChangedForCall:(id)arg1 ;
-(void)destinationIDChangedForCall:(id)arg1 ;
-(void)displayContextChangedForCall:(id)arg1 ;
-(void)isEmergencyChangedForCall:(id)arg1 ;
-(void)audioPropertiesChangedForCall:(id)arg1 ;
-(void)hasUpdatedAudioChangedForCall:(id)arg1 ;
-(void)ttyTypeChangedForCall:(id)arg1 ;
-(void)supportsTTYWithVoiceChangedForCall:(id)arg1 ;
-(void)cameraTypeChangedForCall:(id)arg1 ;
-(void)remoteScreenOrientationChangedForCall:(id)arg1 ;
-(void)remoteScreenAspectRatioChangedForCall:(id)arg1 ;
-(void)prefersExclusiveAccessToCellularNetworkChangedForCall:(id)arg1 ;
-(void)remoteUplinkMutedChangedForCall:(id)arg1 ;
-(void)modelChangedForCall:(id)arg1 ;
-(void)remoteAspectRatioChangedForCall:(id)arg1 ;
-(void)remoteVideoContentRectChangedForCall:(id)arg1 ;
-(void)remoteCameraOrientationChangedForCall:(id)arg1 ;
-(void)mediaPropertiesChangedForCall:(id)arg1 remoteAspectRatioDidChange:(BOOL)arg2 remoteCameraOrientationDidChange:(BOOL)arg3 ;
-(NSMutableArray *)deferredNotificationBlocks;
-(void)conferenceParticipantCallsChangedForCallContainer:(id)arg1 conferenceParticipantCalls:(id)arg2 ;
-(void)setDeferredNotificationBlocks:(NSMutableArray *)arg1 ;
-(void)postNotificationsForCall:(id)arg1 usingComparisonCall:(id)arg2 ;
@end

#endif /* TUCallNotificationManager_h */
