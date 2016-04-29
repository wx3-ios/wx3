//
//  FindTopImgModel.m
//  RKWXT
//
//  Created by SHB on 16/4/12.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "FindTopImgModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "HomePageTopEntity.h"

@interface FindTopImgModel(){
    NSMutableArray *_imgArr;
}
@end

@implementation FindTopImgModel
@synthesize imgArr = _imgArr;

-(id)init{
    self = [super init];
    if(self){
        _imgArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)toInit{
    [super toInit];
    [_imgArr removeAllObjects];
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
    if(!jsonDicData){
        return;
    }
    [_imgArr removeAllObjects];
    NSArray *datalist = [jsonDicData objectForKey:@"data"];
    for(NSDictionary *dic in datalist){
        HomePageTopEntity *entity = [HomePageTopEntity homePageTopEntityWithDictionary:dic];
        entity.topImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.topImg];
        if(entity.showPosition == 5){
            [_imgArr addObject:entity];
        }
    }
}

-(void)loadFindTopImgData{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userObj.sellerID, @"seller_user_id", @"iOS", @"pid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block FindTopImgModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_NewMall_TopImg httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedFailed:)]){
                [_delegate findTopImgLoadedFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            [blockSelf fillDataWithJsonData:retData.data];
            if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedSucceed)]){
                [_delegate findTopImgLoadedSucceed];
            }
        }
    }];
}

-(void)loadCacheDataSucceed{
    if (_delegate && [_delegate respondsToSelector:@selector(findTopImgLoadedSucceed)]){
        [_delegate findTopImgLoadedSucceed];
    }
}

@end
