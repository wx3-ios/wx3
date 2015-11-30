//
//  NewGoodsInfoVC.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NLMainViewController.h"

@class TimeShopData,NewGoodsInfoVC;
typedef enum{
    GoodsInfo_Normal = 0,
    GoodsInfo_LuckyGoods,
    GoodsInfo_LimitGoods,
}GoodsInfo_Type;

@protocol NewGoodsInfoVCDelegate <NSObject>

- (void)cancelGoodsCollection:(NewGoodsInfoVC*)infoVC data:(TimeShopData*)data goodsID:(NSInteger)goodsID;
- (void)addGoodsCollection:(NewGoodsInfoVC*)infoVC data:(TimeShopData*)data;

@end

@interface NewGoodsInfoVC : NLMainViewController
@property (nonatomic,assign) GoodsInfo_Type  goodsInfo_type;
@property (nonatomic,assign) NSInteger goodsId;
@property (nonatomic,weak)id<NewGoodsInfoVCDelegate> delegate;
//限时购
@property (nonatomic,strong) TimeShopData *lEntity;

@end
