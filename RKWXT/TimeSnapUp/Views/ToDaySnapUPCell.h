//
//  ToDaySnapUPCell.h
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeShopData;
@interface ToDaySnapUPCell : UITableViewCell
/** 倒计时 */
@property (nonatomic,strong)UILabel *timeDown;


@property (nonatomic,strong)TimeShopData *data;
+ (CGFloat)cellHeight;
+ (instancetype)toDaySnapTopCell:(UITableView*)tableview;

@end
