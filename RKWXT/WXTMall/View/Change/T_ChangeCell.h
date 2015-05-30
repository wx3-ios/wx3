//
//  T_ChangeCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol ChangeCellDelegate;
@interface T_ChangeCell : WXMiltiViewCell
@property (nonatomic,assign)id<ChangeCellDelegate>delegate;
@end

@protocol ChangeCellDelegate <NSObject>
-(void)changeCellClicked:(id)entity;
@end
