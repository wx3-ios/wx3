//
//  BaseFunctionCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"
#define BaseFunctionCellHeight (30)

typedef enum{
    T_BaseFunction_Init = -1,
    T_BaseFunction_Shark,
    T_BaseFunction_Sign,
    T_BaseFunction_Wallet,
    T_BaseFunction_Order,
    T_BaseFunction_Recharge,
    T_BaseFunction_Balance,
    T_BaseFunction_Cut,
    T_BaseFunction_Union,
    
    T_BaseFunction_Invalid,
}T_BaseFunction;

@protocol BaseFunctionCellBtnClicked;

@interface BaseFunctionCell : WXUITableViewCell
@property (nonatomic,assign) id<BaseFunctionCellBtnClicked>delegate;
@end

@protocol BaseFunctionCellBtnClicked <NSObject>
-(void)baseFunctionBtnClickedAtIndex:(T_BaseFunction)index;

@end
