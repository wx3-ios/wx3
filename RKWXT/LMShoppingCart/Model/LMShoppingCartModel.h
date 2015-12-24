//
//  LMShoppingCartModel.h
//  RKWXT
//
//  Created by SHB on 15/12/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LMSHoppingCart_Type_Add = 1,  //增加
    LMSHoppingCart_Type_Search,   //app查询
    LMSHoppingCart_Type_Change,  //修改
    LMSHoppingCart_Type_Delete,   //删除
    LMSHoppingCart_Type_LoadLMData, //查询商家联盟购物车
}LMSHoppingCart_Type;

@protocol LMShoppingCartModelDelegate;

@interface LMShoppingCartModel : NSObject
@property (nonatomic,assign) id<LMShoppingCartModelDelegate>delegate;
@property (nonatomic,strong) NSArray *shoppingCartArr;

//添加到购物车
-(void)addLMShoppingCartType:(LMSHoppingCart_Type)type goodsID:(NSInteger)goodsID stockID:(NSInteger)stockID stockName:(NSString*)stockName goodsName:(NSString*)goodsName goodsImg:(NSString*)goodsImg goodsPrice:(CGFloat)goodsPrice goodsNum:(NSInteger)goodsNumber shopID:(NSInteger)shopID;
//删除购物车,主键ID
-(void)deleteLMShoppingCartGoods:(NSInteger)typeID;
//查询
-(void)searchLMShoppingCartData;
@end

@protocol LMShoppingCartModelDelegate <NSObject>
@optional
-(void)loadLMShoppingCartSucceed;
-(void)loadLMShoppingCartFailed:(NSString*)errorMsg;

-(void)addLMShoppingCartSucceed;
-(void)addLMShoppingCartFailed:(NSString*)errorMsg;

-(void)deleteLMShoppingCartGoodsSucceed;
-(void)deleteLMShoppingCartGoodsFailed:(NSString*)errorMsg;
@end
