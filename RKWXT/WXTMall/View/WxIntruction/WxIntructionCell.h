//
//  WxIntructionCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol wxIntructionCellDelegate;
@interface WxIntructionCell : WXMiltiViewCell
@property (nonatomic,assign)id<wxIntructionCellDelegate>delegate;
@end

@protocol wxIntructionCellDelegate <NSObject>
-(void)intructionClicked:(id)entity;

@end
