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
#define K_Notification_GoodsInfo_CommitGoods @"K_Notification_GoodsInfo_CommitGoods" 

typedef enum{
    RightGoodsInfo_Normal = 0,
    RightGoodsInfo_LuckyGoods,
    RightGoodsInfo_LimitGoods,
}RightGoodsInfo_Type;

@interface NewGoodsInfoRightView : WXUIView
@property (nonatomic,assign) NSInteger goodsNum;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) RightGoodsInfo_Type type;

//frame外部调用只能设置一次frame
-(id)initWithFrame:(CGRect)frame menuButton:(UIButton *)menuButton dropListFrame:(CGRect)dropListFrame;
-(void)unshow:(BOOL)animated;

-(void)showDropListUpView;

-(void)removeNotification;

@end
