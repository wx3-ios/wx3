//
//  NewGoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseModel.h"
#import "T_HPSubBaseModel.h"
@class GoodsInfoEntity;

@protocol NewGoodsInfoModelDelegate;
@interface NewGoodsInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) id<NewGoodsInfoModelDelegate>delegate;
@property (nonatomic,assign) NSInteger goodID;
@property (nonatomic,strong) GoodsInfoEntity *entity;

-(void)loadGoodsInfo:(NSInteger)goods_id;  //普通商品
-(void)loadGoodsInfo:(NSInteger)goods_id withLimitGoodsID:(NSInteger)limitGoodsID;
-(BOOL)shouldDataReload;

@end

@protocol NewGoodsInfoModelDelegate <NSObject>
-(void)goodsInfoModelLoadedSucceed;
-(void)goodsInfoModelLoadedFailed:(NSString*)errorMsg;
@end
