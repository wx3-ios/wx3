//
//  LMGoodsInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMGoodsInfoModelDelegate;

@interface LMGoodsInfoModel : NSObject
@property (nonatomic,assign) id<LMGoodsInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *goodsInfoArr; //商品详情
@property (nonatomic,strong) NSArray *evaluteArr;   //评价
@property (nonatomic,strong) NSArray *attrArr;      //属性
@property (nonatomic,strong) NSArray *stockArr;     //库存
@property (nonatomic,strong) NSArray *sellerArr;     //所属商家
@property (nonatomic,strong) NSArray *otherShopArr;  //推荐店铺

-(void)loadGoodsInfoData:(NSInteger)goodsID;
@end

@protocol LMGoodsInfoModelDelegate <NSObject>
-(void)loadGoodsInfoDataSucceed;
-(void)loadGoodsInfoDataFailed:(NSString*)errorMsg;

@end
