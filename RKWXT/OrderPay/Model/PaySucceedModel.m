//
//  PaySucceedModel.m
//  RKWXT
//
//  Created by SHB on 15/7/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PaySucceedModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation PaySucceedModel

+(PaySucceedModel*)sharePaySucceed{
    static dispatch_once_t onceToken;
    static PaySucceedModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[PaySucceedModel alloc] init];
    });
    return sharedInstance;
}

-(void)updataPayOrder:(Pay_Type)type withOrderID:(NSInteger)orderID{
    [self setStatus:E_ModelDataStatus_Loading];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)type], @"type", [NSNumber numberWithInt:(int)orderID], @"order_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UpdapaOrderID httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
    }];
}

@end
