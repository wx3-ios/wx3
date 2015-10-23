//
//  ClassifyModel.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "CLassifyEntity.h"

@interface ClassifyModel(){
    NSMutableArray *_classifyDataArr;
}
@end

@implementation ClassifyModel
@synthesize classifyDataArr = _classifyDataArr;

-(id)init{
    self = [super init];
    if(self){
        _classifyDataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

+(ClassifyModel*)shareClassifyNodel{
    static dispatch_once_t onceToken;
    static ClassifyModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[ClassifyModel alloc] init];
    });
    return sharedInstance;
}

-(void)parseClassifyDataWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    [_classifyDataArr removeAllObjects];
    for(NSDictionary *dic in arr){
        CLassifyEntity *entity = [CLassifyEntity initClassifyEntityWith:dic];
        [_classifyDataArr addObject:entity];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadClassifyData_Succeed object:nil];
}

-(void)loadAllClassifyData{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block ClassifyModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadClassifyData httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_LoadClassifyData_Failed object:retData.errorDesc];
        }else{
            [blockSelf parseClassifyDataWith:[retData.data objectForKey:@"data"]];
        }
    }];
}

@end
