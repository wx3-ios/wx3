//
//  GoodsInfoActiviCell.h
//  RKWXT
//
//  Created by app on 16/4/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
#define GoodsInfoPacketCellHeight 44.0
@interface GoodsInfoActiviCell : WXUITableViewCell
+ (instancetype)GoodsInfoActiviCellWithTableView:(UITableView*)tableView;

- (void)goodsInfoPackIsAccording:(NSInteger)type;
@end
