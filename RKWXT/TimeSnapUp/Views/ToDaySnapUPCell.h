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

/** 距离倒计时 */
@property (nonatomic,strong)UIImageView *beg_image;

@property (nonatomic,strong)UILabel *beg_time;
@property (nonatomic,strong)UILabel *beg_open;
/** 结束 */
@property (nonatomic,strong)UIImageView *over_image;

@property (nonatomic,strong)UILabel *over_label;




@property (nonatomic,strong)TimeShopData *data;
+ (CGFloat)cellHeight;
@end
