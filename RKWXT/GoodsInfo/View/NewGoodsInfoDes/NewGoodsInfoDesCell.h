//
//  NewGoodsInfoDesCell.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@class TimeShopData;
@interface NewGoodsInfoDesCell : WXUITableViewCell
@property (nonatomic,assign) BOOL isLucky;
@property (nonatomic,strong) TimeShopData *lEntity;

@end
