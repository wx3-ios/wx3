//
//  CollectionListCell.h
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsListInfo;
@interface CollectionListCell : UITableViewCell
@property (nonatomic,strong)GoodsListInfo *info;
+ (instancetype)collectionCreatCell:(UITableView*)tableview;
+ (CGFloat)cellHeight;
@end
