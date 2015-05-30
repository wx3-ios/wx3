//
//  T_TopicalCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol TopicalCellDeleagte;
@interface T_TopicalCell : WXMiltiViewCell
@property (nonatomic,assign)id<TopicalCellDeleagte>delegate;
@end

@protocol TopicalCellDeleagte <NSObject>
-(void)topicalCellClicked:(id)entity;
@end
