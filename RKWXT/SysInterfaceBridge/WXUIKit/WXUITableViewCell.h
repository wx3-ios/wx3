//
//  WXUITableViewCell.h
//  CallTesting
//
//  Created by le ting on 4/22/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    E_CellDefaultAccessoryViewType_HasNext,    //有下一级页面
    E_CellDefaultAccessoryViewType_Switch,    //带switch开关的~
    E_CellDefaultAccessoryViewType_Detail,   //点击进入详情
    
    E_CellDefaultAccessoryViewType_None,
}E_CellDefaultAccessoryViewType;

#define kDefaultCellTxtSize (12.0)
@protocol WXUITableViewCellMark <NSObject>
@optional
//虚函数
- (void)load;
- (void)unload;
@end

@protocol WXUITableViewCellDelegate;
@interface WXUITableViewCell : UITableViewCell<WXUITableViewCellMark>
@property (nonatomic,retain)id cellInfo;
@property (nonatomic,assign)id<WXUITableViewCellDelegate>baseDelegate;

- (void)setDefaultAccessoryView:(E_CellDefaultAccessoryViewType)type;
- (void)disableTouchDelay;

+ (CGFloat)cellHeightOfInfo:(id)cellInfo;
@end

@protocol WXUITableViewCellDelegate <NSObject>
@optional
- (void)switchValueChanged:(id)sender;
- (void)toDetail:(id)sender;
- (void)clickButtonToDetail:(id)sender;
@end