//
//  WithdrawadsRecordListModel.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WithdrawadsRecordListModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "WithdrawalsRecordEntity.h"

@interface WithdrawadsRecordListModel(){
    NSMutableArray *_recordListArr;
}
@end

@implementation WithdrawadsRecordListModel
@synthesize recordListArr = _recordListArr;

-(id)init{
    self = [super init];
    if(self){
        _recordListArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseLuckyGoodsWith:(NSArray*)arr{
    if(!arr){
        return;
    }
    if(_type == AliMoney_RecordList_Normal || _type == AliMoney_RecordList_Refresh){
        [_recordListArr removeAllObjects];
    }
    
    for(NSDictionary *dic in arr){
        WithdrawalsRecordEntity *entity = [WithdrawalsRecordEntity initAliRecordListWithDic:dic];
        [_recordListArr addObject:entity];
    }
}

-(void)loadUserWithdrawadlsRecordList:(NSInteger)startItem With:(NSInteger)length{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithFloat:(int)startItem], @"start_item", [NSNumber numberWithInt:(int)length], @"length", nil];
    __block WithdrawadsRecordListModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadAliRecordList httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserWithdrawadlsRecordListFailed:)]){
                [_delegate loadUserWithdrawadlsRecordListFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseLuckyGoodsWith:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadUserWithdrawadlsRecordListSucceed)]){
                [_delegate loadUserWithdrawadlsRecordListSucceed];
            }
        }
    }];
}

@end
