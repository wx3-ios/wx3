//
//  WXUITextViewCell.h
//  CallTesting
//
//  Created by le ting on 5/16/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUITableViewCell.h"
#define kTextViewGap (10.0)


@protocol WXUITextViewCellDelegate;
@interface WXUITextViewCell : WXUITableViewCell
@property (nonatomic,assign)CGFloat textLabelWidth;
@property (nonatomic,readonly)WXUITextView *textView;
@property (nonatomic,assign)id<WXUITextViewCellDelegate>delegate;

@end

@protocol WXUITextViewCellDelegate <NSObject>
@optional
- (void)textViewCellValueDidChanged:(WXUITextViewCell*)cell;
@end
