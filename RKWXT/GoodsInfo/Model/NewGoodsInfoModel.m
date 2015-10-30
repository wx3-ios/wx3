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
    BOOL use_red;
    BOOL use_cut;
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
        entity.customNameArr = [self storeStringNameAttrArrayWithArr:attrArr];
        entity.customInfoArr = [self storeStringInfoAttrArrayWithArr:attrArr];
        entity.imgArr = [self goodsInfoTopImgArrWithImgString:entity.bigImg];
        [_dataList addObject:entity];
        if(entity.use_cut){
            use_cut = YES;
        }
        if(entity.use_red){
            use_red = YES;
        }
    }
    if(use_cut || use_red){
        for(GoodsInfoEntity *ent in _dataList){
            ent.use_red = use_red;
            ent.use_cut = use_cut;
        }
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

-(NSArray*)storeStringNameAttrArrayWithArr:(id)oldArr{
    if(!oldArr){
        return nil;
    }
    if([oldArr isKindOfClass:[NSNull class]]){
        return nil;
    }
    
    NSMutableArray *attrArr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in oldArr){
        NSString *name = [dic objectForKey:@"attr_name"];
//        NSString *allNameStr = [name stringByAppendingString:[NSString stringWithFormat:@":%@",[dic objectForKey:@"attr_value"]]];
        [attrArr addObject:name];
    }
    return attrArr;
}

-(NSArray*)storeStringInfoAttrArrayWithArr:(NSArray*)oldArr{
    if(!oldArr){
        return nil;
    }
    if([oldArr isKindOfClass:[NSNull class]]){
        return nil;
    }
    NSMutableArray *attrArr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in oldArr){
        NSString *name = [dic objectForKey:@"attr_value"];
        [attrArr addObject:name];
    }
    return attrArr;
}

-(void)loadGoodsInfo:(NSInteger)goods_id{
//	if (![self shouldDataReload]){
//		KFLog(YES, YES, @"不需要重复加载数据");
//		return;
//    }
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)goods_id], @"goods_id",nil];
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
