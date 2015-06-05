//
//  NewGoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseModel.h"
@class GoodsInfoEntity;

@protocol NewGoodsInfoModelDelegate;
@interface NewGoodsInfoModel : BaseModel
@property (nonatomic,assign) id<NewGoodsInfoModelDelegate>delegate;
@property (nonatomic,assign) NSInteger goodID;
@property (nonatomic,strong) GoodsInfoEntity *entity;
@property (nonatomic,strong) NSDictionary *baseDic;

-(void)loadGoodsInfo;
-(BOOL)shouldDataReload;

@end

@protocol NewGoodsInfoModelDelegate <NSObject>
-(void)goodsInfoModelLoadedSucceed;
-(void)goodsInfoModelLoadedFailed:(NSString*)errorMsg;
@end
