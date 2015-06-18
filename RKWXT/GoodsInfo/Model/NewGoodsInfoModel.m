//
//  NewGoodsInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsInfoEntity.h"

@interface NewGoodsInfoModel(){
    NSMutableArray *_dataList;
}
@end

@implementation NewGoodsInfoModel
@synthesize data = _dataList;

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(id)init{
    self = [super init];
    if(self){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

//{"error":0,"data":{"stock":[{"goods_stock_id":"1","goods_id":"1","goods_stock_name":"ddqw","goods_number":"11","goods_price":"11.00"},{"goods_stock_id":"2","goods_id":"1","goods_stock_name":"gre","goods_number":"22","goods_price":"22.00"}],"attr":[{"goods_id":"1","attr_name":"\u5c4f\u5e55\u5c3a\u5bf8","attr_value":"4.5\u5bf8"},{"goods_id":"1","attr_name":"\u7f51\u7edc\u5236\u5f0f","attr_value":"\u7535\u4fe1"},{"goods_id":"1","attr_name":"CPU","attr_value":"8\u6838"},{"goods_id":"1","attr_name":"\u5916\u89c2\u6837\u5f0f","attr_value":"\u7ffb\u76d6\u624b\u673a|\u6ed1\u76d6\u624b\u673a"},{"goods_id":"1","attr_name":"\u673a\u8eab\u5b58\u50a8","attr_value":"fewfew"},{"goods_id":"1","attr_name":"\u5c4f\u5e55\u5206\u8fa8\u7387","attr_value":"200*200"}],"goods":{"goods_id":"1","goods_name":"few","goods_home_img":"20150618\/20150618112743_350229.jpeg","goods_icarousel_img":"20150618\/20150618112723_704894.jpeg,20150618\/20150618112754_774523.jpeg,20150618\/20150618112803_703050.jpeg,","meterage_name":"\u4e2a","shop_price":"11.00","market_price":"11.00"}}}

-(void)parseGoodInfoDetail:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_dataList removeAllObjects];
    NSDictionary *allDic = [dic objectForKey:@"data"];   //所有数据
    NSArray *stockArr = [allDic objectForKey:@"stock"];   //库存
    NSArray *attrArr = [allDic objectForKey:@"attr"];    //行业基础属性
    NSDictionary *baseDic = [allDic objectForKey:@"goods"];   //商品基础属性
    
    for(NSDictionary *dic in stockArr){
        GoodsInfoEntity *entity = [GoodsInfoEntity goodsInfoEntityWithBaseDic:baseDic withStockDic:dic];
        entity.customArr = [self storeStringInAttrArrayWithArr:attrArr];
        entity.imgArr = [self goodsInfoTopImgArrWithImgString:entity.bigImg];
        [_dataList addObject:entity];
    }
}

-(NSArray*)goodsInfoTopImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

-(NSArray*)storeStringInAttrArrayWithArr:(NSArray*)oldArr{
    if(!oldArr){
        return nil;
    }
    NSMutableArray *attrArr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in oldArr){
        NSString *name = [dic objectForKey:@"attr_name"];
        NSString *allNameStr = [name stringByAppendingString:[NSString stringWithFormat:@":%@",[dic objectForKey:@"attr_value"]]];
        [attrArr addObject:allNameStr];
    }
    return attrArr;
}

-(void)loadGoodsInfo{
//	if (![self shouldDataReload]){
//		KFLog(YES, YES, @"不需要重复加载数据");
//		return;
//    }
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", @"18613213051", @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:@"123456"], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", @"1", @"goods_id",nil];
    __block NewGoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_GoodsInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(goodsInfoModelLoadedFailed:)]){
                [_delegate goodsInfoModelLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf parseGoodInfoDetail:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(goodsInfoModelLoadedSucceed)]){
                [_delegate goodsInfoModelLoadedSucceed];
            }
        }
    }];
}

@end
