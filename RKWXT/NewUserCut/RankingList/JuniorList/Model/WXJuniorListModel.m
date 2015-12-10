//
//  WXJuniorListModel.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXJuniorListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "JuniorListEntity.h"

@interface WXJuniorListModel(){
    NSMutableArray *_juniorArr;
}
@end

@implementation WXJuniorListModel
@synthesize juniorArr = _juniorArr;

-(id)init{
    self = [super init];
    if(self){
        _juniorArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseJuniorListDataWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_juniorArr removeAllObjects];
    NSInteger count = 0;
    for(NSDictionary *dic in arr){
        count++;
        
        JuniorListEntity *entity = [JuniorListEntity initJuniorListEntity:dic];
        if(![entity.imgUrl isEqualToString:@""] && entity.imgUrl){
            entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
        }
        entity.rankingNum = count;
        [_juniorArr addObject:entity];
    }
}

-(void)loadWXJuniorListData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:kSubShopID], @"shop_id", nil];
    __block WXJuniorListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_JuniorList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadWXJuniorListDataFailed:)]){
                [_delegate loadWXJuniorListDataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseJuniorListDataWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadWXJuniorListDataSucceed)]){
                [_delegate loadWXJuniorListDataSucceed];
            }
        }
    }];
}

@end
