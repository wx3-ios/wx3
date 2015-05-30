//
//  T_ChangeTitleCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/17.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol changeTitleCellDelegate;

@interface T_ChangeTitleCell : WXUITableViewCell
@property (nonatomic,assign) id<changeTitleCellDelegate>delegate;
@end

@protocol changeTitleCellDelegate <NSObject>
-(void)changeOtherBtnClicked;

@end
