//
//  UserCutSourceModel.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserCutSourceEntity.h"

@interface UserCutSourceModel(){
    NSMutableArray *_sourceArr;
}
@end

@implementation UserCutSourceModel
@synthesize sourceArr = _sourceArr;

-(id)init{
    self = [super init];
    if(self){
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserCutSourceData:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_sourceArr removeAllObjects];
    NSInteger count = 0;
    NSArray *keys = [dic allKeys];
    for(NSString *name in keys){
        for(NSDictionary *dic1 in [dic objectForKey:name]){
            UserCutSourceEntity *entity = [UserCutSourceEntity initUserCutSourceEntityWith:dic1];
            if(![entity.imgUrl isEqualToString:@""]){
                entity.imgUrl = [NSString stringWithFormat:@"http://wx3.67call.com/wx3/Public/Uploads/%@",entity.imgUrl];
            }
            NSString *key = [keys objectAtIndex:count];
            if([key isEqualToString:@"p1"]){
                entity.grade = @"一级";
            }
            if([key isEqualToString:@"p2"]){
                entity.grade = @"二级";
            }
            if([key isEqualToString:@"p3"]){
                entity.grade = @"三级";
            }
            [_sourceArr addObject:entity];
        }
        count ++;
    }
}

-(void)loadUserCutSource{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInteger:kMerchantID], @"sid", [NSNumber numberWithInt:kSubShopID], @"shop_id", nil];
    __block UserCutSourceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserCutSource httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCutSourceFailed:)]){
                [_delegate loadUserCutSourceFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserCutSourceData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCutSourceSucceed)]){
                [_delegate loadUserCutSourceSucceed];
            }
        }
    }];
}

@end
