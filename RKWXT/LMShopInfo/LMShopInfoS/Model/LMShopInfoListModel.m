//
//  LMShopInfoListModel.m
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "LMShopInfoAllGoodsEntity.h"

@interface LMShopInfoListModel(){
    NSMutableArray *_data;
    NSInteger _startItem;
}
@property (nonatomic,assign) LMShopInfo_DataType dataType;
@end

@implementation LMShopInfoListModel
@synthesize data = _data;

-(id)init{
    self = [super init];
    if(self){
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseShopInfoData:(NSArray*)arr{
    if([arr count] == 0){
        return;
    }
    if(_startItem == 0){
        [_data removeAllObjects];
    }
    if(_dataType == LMShopInfo_DataType_AllGoods || _dataType == LMShopInfo_DataType_ComGoods || _dataType == LMShopInfo_DataType_Active){
        for(NSDictionary *dic in arr){
            LMShopInfoAllGoodsEntity *entity = [LMShopInfoAllGoodsEntity initLMShopInfoAllGoodsListEntity:dic];
            entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
            [_data addObject:entity];
        }
    }
}

-(void)loadShopInfoListDataWith:(LMShopInfo_DataType)dataTpe and:(NSInteger)sshop_id andStartItem:(NSInteger)startItem andLenth:(NSInteger)length{
    _dataType = dataTpe;
    _startItem = startItem;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInteger:sshop_id], @"sshop_id", [NSNumber numberWithInteger:dataTpe], @"type", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", nil];
    __block LMShopInfoListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_Home_LMShopInfoList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadShopListDataFailed:)]){
                [_delegate loadShopListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseShopInfoData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadShopListDataSucced)]){
                [_delegate loadShopListDataSucced];
            }
        }
    }];
}

@end
