//
//  MPRecentsTableViewCell.h
//  callkiller
//
//  Created by mac on 2018/8/1.
//

#ifndef MPRecentsTableViewCell_h
#define MPRecentsTableViewCell_h

@interface MPRecentsTableViewCell : UITableViewCell
//{
//    NSDictionary *_allViewsDictionary;
//    long long _buildConstraintsOnceToken;
//    NSLayoutConstraint *_topConstraint;
//    NSLayoutConstraint *_bottomConstraint;
//    NSLayoutConstraint *_dateConstraint;
//    NSLayoutConstraint *_dateYConstraint;
//    NSLayoutConstraint *_labelConstraint;
//    CHRecentCall *_call;
//    UILabel *_callerCountLabel;
//    UIDateLabel *_callerDateLabel;
//    UILabel *_callerLabelLabel;
//    UILabel *_callerNameLabel;
//    UIImageView *_callTypeIconView;
//}

+ (id)allMetrics;
+ (double)minimumRowHeight;
+ (double)marginWidth;
+ (double)editingMarginWidth;
+ (id)_sharedTTYRelayImage;
+ (id)_sharedTTYDirectImage;
+ (id)_sharedOutgoingFaceTimeImage;
+ (id)_sharedOutgoingCallImage;
@property(retain, nonatomic) UIImageView *callTypeIconView; // @synthesize callTypeIconView=_callTypeIconView;
@property(retain, nonatomic) UILabel *callerNameLabel; // @synthesize callerNameLabel=_callerNameLabel;
@property(retain, nonatomic) UILabel *callerLabelLabel; // @synthesize callerLabelLabel=_callerLabelLabel;
//@property(retain, nonatomic) UIDateLabel *callerDateLabel; // @synthesize callerDateLabel=_callerDateLabel;
@property(retain, nonatomic) UILabel *callerCountLabel; // @synthesize callerCountLabel=_callerCountLabel;
//@property(retain, nonatomic) CHRecentCall *call; // @synthesize call=_call;
//- (void).cxx_destruct;
- (void)_updateFonts;
- (void)_handleContentSizeDidChange:(id)arg1;
- (void)_updateConstraints;
- (void)_buildConstraints;
- (void)setEditing:(_Bool)arg1 animated:(_Bool)arg2;
@property(readonly) NSDictionary *allMetrics; // @dynamic allMetrics;
@property(readonly) NSDictionary *allViews; // @dynamic allViews;
@property(readonly) long long count; // @dynamic count;
- (void)dealloc;
- (void)commonInit;
- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)initWithCoder:(id)arg1;
- (id)init;

@end

#endif /* MPRecentsTableViewCell_h */
