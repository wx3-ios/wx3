//
//  AboutShopModel.m
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutShopModel.h"
#import "AboutShopEntity.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface AboutShopModel(){
    NSMutableArray *_shopInfoArr;
}
@end

@implementation AboutShopModel

+(AboutShopModel*)shareShopModel{
    static dispatch_once_t onceToken;
    static AboutShopModel *shareShopModel = nil;
    dispatch_once(&onceToken,^{
        shareShopModel = [[AboutShopModel alloc] init];
    });
    return shareShopModel;
}

-(id)init{
    self = [super init];
    if(self){
        _shopInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseShopInfoWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    AboutShopEntity *entity = [AboutShopEntity shopInfoEntityWithDic:dic];
    entity.imgArr = [self shopInfoImgArrWithImgString:[dic objectForKey:@"seller_carousel_img"]];
    [_shopInfoArr addObject:entity];
}

-(NSArray*)shopInfoImgArrWithImgString:(NSString*)imgStr{
    if(!imgStr){
        return nil;
    }
    NSInteger length = imgStr.length;
    NSString *c = [imgStr substringFromIndex:length-1];
    if([c isEqualToString:@","]){
        imgStr = [imgStr substringToIndex:length-1];
    }
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSArray *array = [imgStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        NSString *str1 = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,str];
        [imgArr addObject:str1];
    }
    return imgArr;
}

-(void)loadShopInfo{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)kMerchantID], @"sid", userObj.user, @"phone", nil];
    __block AboutShopModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_AboutShop httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadShopInfoFailed object:retData.errorDesc];
        }else{
            [blockSelf parseShopInfoWithDic:[retData.data objectForKey:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_LoadShopInfoSucceed object:nil];
        }
    }];
}

@end
