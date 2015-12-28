//
//  LMShopInfoModel.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMShopInfoEntity.h"

@interface LMShopInfoModel(){
    NSMutableArray *_shopInfoArr;
    NSMutableArray *_allGoodsArr;
    NSMutableArray *_comGoodsArr;
}
@end

@implementation LMShopInfoModel
@synthesize shopInfoArr = _shopInfoArr;
@synthesize allGoodsArr = _allGoodsArr;
@synthesize comGoodsArr = _comGoodsArr;

-(id)init{
    self = [super init];
    if(self){
        _shopInfoArr = [[NSMutableArray alloc] init];
        _allGoodsArr = [[NSMutableArray alloc] init];
        _comGoodsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseShopInfoData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_shopInfoArr removeAllObjects];
    [_allGoodsArr removeAllObjects];
    [_comGoodsArr removeAllObjects];
    
    LMShopInfoEntity *shopEntity = [LMShopInfoEntity initShopInfoEntity:[dic objectForKey:@"shop"]];
    shopEntity.topImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,shopEntity.topImg];
    shopEntity.homeImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,shopEntity.homeImg];
    [_shopInfoArr addObject:shopEntity];
    
    for(NSDictionary *allGoodsDic in [dic objectForKey:@"all_goods"]){
        LMShopInfoEntity *allGoodsEntity = [LMShopInfoEntity initAllGoodsEntity:allGoodsDic];
        allGoodsEntity.all_goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,allGoodsEntity.all_goodsImg];
        [_allGoodsArr addObject:allGoodsEntity];
    }
    
    for(NSDictionary *comGoodsDic in [dic objectForKey:@"commend_goods"]){
        LMShopInfoEntity *comGoodsEntity = [LMShopInfoEntity initComGoodsEntity:comGoodsDic];
        comGoodsEntity.com_goodsImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,comGoodsEntity.com_goodsImg];
        [_comGoodsArr addObject:comGoodsEntity];
    }
}

-(void)loadLMShopInfoData:(NSInteger)sshop_id{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:sshop_id], @"sshop_id", nil];
    __block LMShopInfoModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMShopInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMShopinfoDataFailed:)]){
                [_delegate loadLMShopinfoDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseShopInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadLMShopinfoDataSucceed)]){
                [_delegate loadLMShopinfoDataSucceed];
            }
        }
    }];
}

@end
