//
//  CLassifySearchModel.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "CLassifySearchModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface CLassifySearchModel(){
    NSMutableArray *_searchResultArr;
}
@end

@implementation CLassifySearchModel
@synthesize searchResultArr = _searchResultArr;

-(id)init{
    self = [super init];
    if(self){
        _searchResultArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)classifySearchWith:(NSString *)searchStr{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", userObj.sellerID, @"seller_user_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block CLassifySearchModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyClientPerson httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
//            [blockSelf parseMyClientPersonListWith:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(classifySearchResultSucceed)]){
                [_delegate classifySearchResultSucceed];
            }
        }
    }];
}

@end
