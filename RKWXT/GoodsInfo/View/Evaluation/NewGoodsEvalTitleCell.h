//
//  NewGoodsEvalTitleCell.h
//  RKWXT
//
//  Created by app on 16/4/25.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@interface NewGoodsEvalTitleCell : WXUITableViewCell
+ (instancetype)goodsEvalTitleCellWithTableView:(UITableView*)tableView;
- (void)isShowGoodsEvaluation:(BOOL)IsShow;
@end
