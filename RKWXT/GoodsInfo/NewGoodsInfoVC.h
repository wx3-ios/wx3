//
//  NewGoodsInfoVC.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NLMainViewController.h"

@class TimeShopData;
typedef enum{
    GoodsInfo_Normal = 0,
    GoodsInfo_LuckyGoods,
    GoodsInfo_LimitGoods,
}GoodsInfo_Type;

@interface NewGoodsInfoVC : NLMainViewController
@property (nonatomic,assign) GoodsInfo_Type  goodsInfo_type;
@property (nonatomic,assign) NSInteger goodsId;

//限时购
@property (nonatomic,strong) TimeShopData *lEntity;

@end
