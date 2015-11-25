//
//  ToDaySnapUPCell.h
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeShopData,ToDaySnapUPCell;

@protocol ToDaySnapUPCellDelegate <NSObject>

- (void)toDaySnapUpCell:(ToDaySnapUPCell*)cell;

@end


@interface ToDaySnapUPCell : WXUITableViewCell
/** 倒计时 */
@property (nonatomic,strong)UILabel *timeDown;
@property (nonatomic,strong)TimeShopData *data;
@property (nonatomic,strong)id <ToDaySnapUPCellDelegate> delegate;
+ (CGFloat)cellHeight;
+ (instancetype)toDaySnapTopCell:(UITableView*)tableview;

@end
