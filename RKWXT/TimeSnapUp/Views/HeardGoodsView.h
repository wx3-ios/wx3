//
//  HeardGoodsView.h
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeShopData;
@interface HeardGoodsView : UIView
/** 倒计时 */
@property (nonatomic,strong)UILabel *timeDown;
@property (nonatomic,assign,getter=isDownHidden)BOOL downHidden; //是否显示
/** 距离倒计时 */
@property (nonatomic,strong)UIImageView *beg_image;
@property (nonatomic,assign,getter=isImageHidden)BOOL imageHidden; //是否显示
@property (nonatomic,strong)UILabel *beg_time;
@property (nonatomic,strong)UILabel *beg_open;
/** 结束 */
@property (nonatomic,strong)UIImageView *over_image;
@property (nonatomic,assign,getter=isOver_Image_Hidden)BOOL over_Image_Hidden;
@property (nonatomic,strong)UILabel *over_label;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)TimeShopData *data;
@end
