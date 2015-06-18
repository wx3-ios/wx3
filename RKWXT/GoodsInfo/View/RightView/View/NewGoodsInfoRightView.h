//
//  NewGoodsInfoRightView.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define MaskViewClicked @"MaskViewClicked"
#define K_Notification_GoodsInfo_LoadSucceed @"K_Notification_GoodsInfo_LoadSucceed"

@interface NewGoodsInfoRightView : WXUIView
//@property (nonatomic,assign) NSInteger goodsNum;
@property (nonatomic,strong) NSArray *dataArr;

//frame外部调用只能设置一次frame
-(id)initWithFrame:(CGRect)frame menuButton:(UIButton *)menuButton dropListFrame:(CGRect)dropListFrame;
-(void)unshow:(BOOL)animated;

-(void)showDropListUpView;

-(void)removeNotification;

@end
