//
//  AllAreaDataModel.m
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "AllAreaDataModel.h"
#import "LoadAreaModel.h"
#import "WXTURLFeedOBJ+NewData.h"

@interface AllAreaDataModel(){
    LoadAreaModel *_model;
}
@end

@implementation AllAreaDataModel

-(id)init{
    self = [super init];
    if(self){
        _model = [[LoadAreaModel alloc] init];
    }
    return self;
}

+(AllAreaDataModel*)shareAllAreaData{
    static dispatch_once_t onceToken;
    static AllAreaDataModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[AllAreaDataModel alloc] init];
    });
    return sharedInstance;
}

-(void)checkAllAreaVersion{
//    [_model loadAllAreaData];
//    return;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [UtilTool currentVersion], @"ver", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.wxtID, @"woxin_id", [NSNumber numberWithInt:(int)kMerchantID], @"sid", [NSNumber numberWithInt:(int)kSubShopID], @"shop_id", nil];
    __block AllAreaDataModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_CheckAreaVersion httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
        }else{
            NSString *newVersion = [NSString stringWithFormat:@"%ld",(long)[[retData.data objectForKey:@"data"] objectForKey:@"area_version"]];
            [blockSelf compareLocalAreaVersionToServiceAreaVersion:newVersion];
        }
    }];
}

-(void)compareLocalAreaVersionToServiceAreaVersion:(NSString*)newVersion{
    if(![newVersion isEqualToString:[[self class] lastCheckDate]]){
        [self removeAreaPlist];
        
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newVersion forKey:CheckAreaVersion];
}

-(void)removeAreaPlist{
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:ServiceAreaPlist];
    if(![manager fileExistsAtPath:ServiceAreaPlist]){
        [_model loadAllAreaData];
        NSLog(@"没有areaPlist文件");
        return;
    }
    if ([manager removeItemAtPath:filepath error:nil]) {
        [_model loadAllAreaData];
        NSLog(@"areaPlist文件删除成功");
    }
}

+(NSString*)lastCheckDate{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:CheckAreaVersion];
}

@end
