//
//  NewGoodsInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+Data.h"
#import "GoodsInfoEntity.h"

@interface NewGoodsInfoModel(){
    
}
@end

@implementation NewGoodsInfoModel

-(void)toInit{
    [super toInit];
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)parseGoodInfoDetail:(NSDictionary*)dic{
//    if(!dic){
//        return;
//    }
    _entity = [[GoodsInfoEntity alloc] init];
    _baseDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                @"1",@"goods_alloy",
                @"2",@"goods_guarantee",
                @"3",@"goods_material",
                @"4",@"goods_package",
                @"5",@"goods_size",
                @"6",@"goods_style",
                @"7",@"goods_weight",
                @"8",@"producing_area",
                @"9",@"suit_crowd",
                nil];
}

-(void)loadGoodsInfo{
    NewGoodsInfoModel *blockSelf1 = self;
    [blockSelf1 setStatus:E_ModelDataStatus_LoadSucceed];
    [blockSelf1 parseGoodInfoDetail:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(goodsInfoModelLoadedSucceed)]){
        [_delegate goodsInfoModelLoadedSucceed];
    }
    return;
    
    
//	if (![self shouldDataReload]){
//		KFLog(YES, YES, @"不需要重复加载数据");
//		return;
//    }
    
    NSString *woxinID = [WXUserOBJ sharedUserOBJ].woxinID;
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:woxinID,@"woxin_id",[NSNumber numberWithInteger:_goodID],@"goods_id",nil];
    __block NewGoodsInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchDataFromFeedType:WXT_UrlFeed_Type_ResetPwd httpMethod:WXT_HttpMethod_Get timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != WXT_URLFeedData_Succeed){
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
