//
//  LMShoppingCartModel.m
//  RKWXT
//
//  Created by SHB on 15/12/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMShoppingCartEntity.h"

@interface LMShoppingCartModel(){
    NSMutableArray *_shoppingCartArr;
}
@end

@implementation LMShoppingCartModel
@synthesize shoppingCartArr = _shoppingCartArr;

-(id)init{
    self = [super init];
    if(self){
        _shoppingCartArr = [[NSMutableArray alloc] init];
    }
    return self;
}

//添加
-(void)addLMShoppingCartType:(LMSHoppingCart_Type)tyoe goodsID:(NSInteger)goodsID stockID:(NSInteger)stockID stockName:(NSString *)stockName goodsName:(NSString *)goodsName goodsImg:(NSString *)goodsImg goodsPrice:(CGFloat)goodsPrice goodsNum:(NSInteger)goodsNumber shopID:(NSInteger)shopID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:shopID], @"shop_id", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:tyoe], @"type", [NSNumber numberWithInteger:goodsID], @"goods_id", [NSNumber numberWithInteger:stockID], @"goods_stock_id", stockName, @"goods_stock_name", goodsName, @"goods_name", goodsImg, @"goods_img", [NSNumber numberWithFloat:goodsPrice], @"goods_price", [NSNumber numberWithInteger:goodsNumber], @"goods_number", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(addLMShoppingCartFailed:)]){
                [_delegate addLMShoppingCartFailed:retData.errorDesc];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(addLMShoppingCartSucceed)]){
                [_delegate addLMShoppingCartSucceed];
            }
        }
    }];
}

//查询
-(void)searchLMShoppingCartData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:5], @"type",  nil];
    __block LMShoppingCartModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(loadLMShoppingCartFailed:)]){
                [_delegate loadLMShoppingCartFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLMShoppingCartData:[retData.data objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(loadLMShoppingCartSucceed)]){
                [_delegate loadLMShoppingCartSucceed];
            }
        }
    }];
}

-(void)parseLMShoppingCartData:(NSArray*)arr{
    if([arr count] == 0){
        return;
    }
    [_shoppingCartArr removeAllObjects];
    NSMutableArray *shopIDArr = [[NSMutableArray alloc] init];   //店铺id临时数组
    [shopIDArr addObject:@"0"];
    NSMutableArray *comArr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in arr){
        LMShoppingCartEntity *entity = [LMShoppingCartEntity initLMShoppCartEntity:dic];
        entity.shopImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.shopImg];
        [comArr addObject:entity];
        NSInteger number = 0 ;
        for(NSString *shopIDStr in shopIDArr){
            if([shopIDStr integerValue] != entity.shopID){
                number++;
            }
            if(number == [shopIDArr count]){
                [shopIDArr addObject:[NSString stringWithFormat:@"%ld",(long)entity.shopID]];
            }
        }
    }
    
    for(NSString *shopIDStr in shopIDArr){
        NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
        for(LMShoppingCartEntity *ent in comArr){
            if([shopIDStr integerValue] == ent.shopID){
                [goodsArr addObject:ent];
            }
        }
        if([goodsArr count]>0){
            [_shoppingCartArr addObject:goodsArr];
        }
    }
}

//删除
-(void)deleteLMShoppingCartGoods:(NSInteger)typeID{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", userObj.user, @"phone", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:4], @"type", [NSNumber numberWithInteger:typeID], @"cart_id", nil];
//    __block LMShoppingCartModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_ShoppingCart httpMethod:WXT_HttpMethod_Post timeoutIntervcal:10 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            if (_delegate && [_delegate respondsToSelector:@selector(deleteLMShoppingCartGoodsFailed:)]){
                [_delegate deleteLMShoppingCartGoodsFailed:retData.errorDesc];
            }
        }else{
//            [blockSelf parseDeleteSucceedResult:typeID];
            if (_delegate && [_delegate respondsToSelector:@selector(deleteLMShoppingCartGoodsSucceed)]){
                [_delegate deleteLMShoppingCartGoodsSucceed];
            }
        }
    }];
}

-(void)parseDeleteSucceedResult:(NSInteger)typeID{
    NSArray *comArr = _shoppingCartArr;
    for(NSArray *listArr in comArr){
        NSMutableArray *arr = [NSMutableArray arrayWithArray:listArr];
        for(LMShoppingCartEntity *entity in arr){
            if(entity.cartID == typeID){
                [_shoppingCartArr removeObject:listArr];
                [arr removeObject:entity];
                [_shoppingCartArr addObject:arr];
                break;
            }
        }
    }
}

@end
