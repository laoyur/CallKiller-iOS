//
//  CTCallCenter.h
//  callkiller
//
//  Created by mac on 2018/7/12.
//

#ifndef CTCallCenter_h
#define CTCallCenter_h

@class NSSet, CXCallObserver, NSString, CXCall;

@interface CTCallCenter : NSObject// <CXCallObserverDelegate> {
    
//    queue* _queue;
//    queue* clientQueue;
//    NSSet* _currentCalls;
//    /*^block*/id _callEventHandler;
//    CXCallObserver* _callKitObserver;
//    
//}

//@property (assign) CXCallObserver * callKitObserver;                //@synthesize callKitObserver=_callKitObserver - In the implementation block
@property (retain) NSSet * currentCalls; 
@property (nonatomic,copy) id callEventHandler; 
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(BOOL)calculateCallStateChanges_sync:(id)arg1 ;
//-(CXCallObserver *)callKitObserver;
-(BOOL)getCurrentCallSetFromServer_sync:(id)arg1 ;
-(id)callEventHandler;
-(void)handleCallStatusChange_sync:(CXCall*)arg1 ;
-(void)broadcastCallStateChangesIfNeededWithFailureLogMessage:(id)arg1 ;
//-(void)setCallKitObserver:(CXCallObserver *)arg1 ;
-(id)init;
-(void)dealloc;
-(void)initialize;
-(NSString *)description;
//-(id)initWithQueue:(dispatch_queue_sRef)arg1 ;
-(void)setCallEventHandler:(id)arg1 ;
-(NSSet *)currentCalls;
-(void)setCurrentCalls:(NSSet *)arg1 ;
-(void)callObserver:(id)arg1 callChanged:(id)arg2 ;
@end

#endif /* CTCallCenter_h */
