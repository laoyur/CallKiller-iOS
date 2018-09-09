//
//  MPRecentsTableViewController.h
//  callkiller
//
//  Created by mac on 2018/8/1.
//

#ifndef MPRecentsTableViewController_h
#define MPRecentsTableViewController_h

@interface MPRecentsTableViewController //: PhoneViewController <CNAvatarCardControllerDelegate, CNContactViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
//{
//    _Bool _dataSourceNeedsReload;
//    _Bool _tableViewNeedsReload;
//    _Bool _contentUnavailable;
//    NSMutableArray *_recentCalls;
//    MPRecentsController *_recentsController;
//    TUMetadataCache *_metadataCache;
//    CNAvatarCardController *_avatarCardController;
//    UIBarButtonItem *_clearButtonItem;
//    _UIContentUnavailableView *_contentUnavailableView;
//    NSString *_contentUnavailableViewTitle;
//    UISegmentedControl *_tableViewDisplayModeSegmentedControl;
//    UITableView *_tableView;
//    NSArray *_indexPathsForMissedCalls;
//    NSArray *_indexPathsForNormalCalls;
//    long long _tableViewDisplayMode;
//}

+ (id)tabBarIconName;
+ (long long)tabBarSystemItem;
+ (int)tabViewType;
+ (_Bool)requiresNavigationControllerContainer;
+ (void)initialize;
//+ (CDStruct_5ec447a9)badge;
@property(nonatomic) long long tableViewDisplayMode; // @synthesize tableViewDisplayMode=_tableViewDisplayMode;
@property(retain, nonatomic) NSArray *indexPathsForNormalCalls; // @synthesize indexPathsForNormalCalls=_indexPathsForNormalCalls;
@property(retain, nonatomic) NSArray *indexPathsForMissedCalls; // @synthesize indexPathsForMissedCalls=_indexPathsForMissedCalls;
@property(retain, nonatomic) UITableView *tableView; // @synthesize tableView=_tableView;
@property(retain, nonatomic) UISegmentedControl *tableViewDisplayModeSegmentedControl; // @synthesize tableViewDisplayModeSegmentedControl=_tableViewDisplayModeSegmentedControl;
@property(copy, nonatomic) NSString *contentUnavailableViewTitle; // @synthesize contentUnavailableViewTitle=_contentUnavailableViewTitle;
//@property(retain, nonatomic) _UIContentUnavailableView *contentUnavailableView; // @synthesize contentUnavailableView=_contentUnavailableView;
@property(nonatomic) _Bool contentUnavailable; // @synthesize contentUnavailable=_contentUnavailable;
@property(retain, nonatomic) UIBarButtonItem *clearButtonItem; // @synthesize clearButtonItem=_clearButtonItem;
//@property(retain, nonatomic) CNAvatarCardController *avatarCardController; // @synthesize avatarCardController=_avatarCardController;
@property(nonatomic) _Bool tableViewNeedsReload; // @synthesize tableViewNeedsReload=_tableViewNeedsReload;
@property(nonatomic) _Bool dataSourceNeedsReload; // @synthesize dataSourceNeedsReload=_dataSourceNeedsReload;
//@property(retain, nonatomic) TUMetadataCache *metadataCache; // @synthesize metadataCache=_metadataCache;
//@property(retain, nonatomic) MPRecentsController *recentsController; // @synthesize recentsController=_recentsController;
@property(retain, nonatomic) NSMutableArray *recentCalls; // @synthesize recentCalls=_recentCalls;
//- (void).cxx_destruct;
- (void)showRecentCallDetailsViewControllerForRecentCall:(id)arg1 animated:(_Bool)arg2;
- (void)setNavigationItemsForEditing:(_Bool)arg1 animated:(_Bool)arg2;
- (void)refreshView;
- (void)reloadTableView;
- (void)refreshTabBarItemBadge;
- (void)reloadDataSource;
- (void)makeUIForDefaultPNG;
- (double)tableView:(id)arg1 estimatedHeightForRowAtIndexPath:(id)arg2;
- (void)contactViewController:(id)arg1 didCompleteWithContact:(id)arg2;
- (id)presentingViewControllerForAvatarCardController:(id)arg1;
- (long long)avatarCardController:(id)arg1 presentationResultForLocation:(struct CGPoint)arg2;
- (id)contactViewControllerForRecentCall:(id)arg1 contact:(id)arg2;
- (id)contactViewControllerForRecentCall:(id)arg1;
- (void)removeRecentCallsAtIndexPaths:(id)arg1;
- (void)removeAllRecentCalls;
- (void)selectedSegmentDidChangeForSender:(id)arg1;
- (void)clearButtonAction:(id)arg1;
- (void)contentSizeCategoryDidChange;
- (void)handleCurrentLocaleDidChangeNotification:(id)arg1;
- (void)phoneApplicationDidChangeTabBarSelection:(id)arg1;
- (void)applicationDidEnterBackground:(id)arg1;
- (void)metadataCacheDidFinishUpdating:(id)arg1;
- (void)handleCallHistoryControllerUnreadCallCountDidChangeNotification:(id)arg1;
- (void)handleCallHistoryControllerRecentCallsDidChangeNotification:(id)arg1;
- (void)tableView:(id)arg1 commitEditingStyle:(long long)arg2 forRowAtIndexPath:(id)arg3;
- (void)tableView:(id)arg1 accessoryButtonTappedForRowWithIndexPath:(id)arg2;
- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
- (long long)numberOfSectionsInTableView:(id)arg1;
- (long long)tableView:(id)arg1 numberOfRowsInSection:(long long)arg2;
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (id)recentCallAtTableViewIndex:(long long)arg1;
- (long long)rowCountForCurrentTableMode;
- (id)_indexPathsForCallsWithStatus:(unsigned int)arg1 includeUnknown:(_Bool)arg2;
- (id)indexPathsForRecentCalls;
- (_Bool)shouldSnapshot;
- (void)savePreferences;
- (void)setContentUnavailable:(_Bool)arg1 animated:(_Bool)arg2;
- (void)setEditing:(_Bool)arg1 animated:(_Bool)arg2;
- (void)viewDidDisappear:(_Bool)arg1;
- (void)viewWillDisappear:(_Bool)arg1;
- (void)viewDidAppear:(_Bool)arg1;
- (void)viewWillAppear:(_Bool)arg1;
- (void)viewDidLoad;
- (void)loadView;
- (void)didReceiveMemoryWarning;
- (void)dealloc;
- (void)commonInit;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

#endif /* MPRecentsTableViewController_h */
