//
//  WXTFindModel.m
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTFindModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "FindEntity.h"

@interface WXTFindModel(){
    NSMutableArray *_findDataArr;
}
@end

@implementation WXTFindModel
@synthesize findDataArr = _findDataArr;

-(id)init{
    if(self = [super init]){
        _findDataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseClassifyData:(NSArray*)dataArr{
    if(![dataArr count]){
        return;
    }
    for(NSDictionary *dic in dataArr){
        FindEntity *entity = [FindEntity initFindEntityWith:dic];
        entity.icon_url = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.icon_url];
        [_findDataArr addObject:entity];
    }
    _findDataArr = [NSMutableArray arrayWithArray:[self findDataClassifyTypeUpSort]];
}

//升序排序
-(NSArray*)findDataClassifyTypeUpSort{
    NSArray *sortArray = [_findDataArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        FindEntity *entity_0 = obj1;
        FindEntity *entity_1 = obj2;
        
        if (entity_0.sortID > entity_1.sortID){
            return NSOrderedDescending;
        }else if (entity_0.sortID < entity_1.sortID){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

-(void)loadFindData:(FindData_Type)type{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UtilTool currentVersion], @"ver", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:kMerchantID], @"sid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:type], @"type", nil];
    __block WXTFindModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_FindData httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataFailed:)]){
                [_findDelegate initFinddataFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseClassifyData:[retData.data objectForKey:@"data"]];
            if (_findDelegate && [_findDelegate respondsToSelector:@selector(initFinddataSucceed)]){
                [_findDelegate initFinddataSucceed];
            }
        }
    }];
}

-(void)upLoadUserClickFindData:(NSInteger)discover_id{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UtilTool currentVersion], @"ver", @"ios", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInt:kMerchantID], @"sid", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:2], @"type", [NSNumber numberWithInt:discover_id], @"discover_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_FindData httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
    }];
}

@end
