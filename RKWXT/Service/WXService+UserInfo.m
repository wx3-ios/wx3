//
//  WXService+UserInfo.m
//  Woxin2.0
//
//  Created by le ting on 7/30/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#define kMaxIconLength (180*1000)

#import "WXService.h"
//#import "PersonalInfo.h"


@implementation WXService (UserInfo)

- (UIImage*)getFriendIcon:(NSInteger)rID{
    const char *iconPath = IT_GetFriendIconEx((SS_UINT32)rID);
    if(iconPath){
        return [UIImage imageNamed:[NSString stringWithFormat:@"%s",iconPath]];
    }
    return nil;
}
- (NSString*)userIconName{
    return @"userIcon";
}

- (NSString*)iconDir{
    NSString *documentPath = [UtilTool documentPath];
    return [documentPath stringByAppendingPathComponent:@"icon"];
}

- (NSString*)userIconPath{
    NSString *dir = [self iconDir];
    return [dir stringByAppendingPathComponent:[self userIconName]];
}

- (BOOL)uploadIcon:(NSData*)imageData{
    NSInteger length = [imageData length];
    if(length == 0){
        return NO;
    }
    if(length > kMaxIconLength){
        KFLog_Normal(YES, @"图片太大，请重新上传~")
    }
    NSString *iconTempPath = [self userIconPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:iconTempPath]){
        [fileManager removeItemAtPath:iconTempPath error:nil];
    }
    [imageData writeToFile:iconTempPath atomically:YES];
    SS_UINT32 ret = IT_UploadMyIcon([iconTempPath cStringUsingEncoding:NSUTF8StringEncoding]);
    if(ret != 0){
        KFLog_Normal(YES, @"上传个人图像失败= %d",ret);
        return NO;
    }
    return YES;
}

//- (BOOL)updateUserInfo:(PersonalInfo*)entity{
//    return [self updateUserInfo:entity.nickName realName:entity.realName bindNumber:entity.bindNumber sex:entity.sex birth:entity.birthString qq:entity.qq signature:entity.signature address:entity.address area:entity.area];
//}

- (BOOL)updateUserInfo:(NSString*)nickName realName:(NSString*)realName bindNumber:(NSString*)bindNumber
                   sex:(E_Sex)sex birth:(NSString*)birth qq:(NSString*)qq signature:(NSString*)signature
               address:(NSString*)address area:(NSString*)area{
    const char *cNickName = "";
    if(nickName){
        cNickName = [nickName cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cRealName = "";
    if(realName){
        cRealName = [realName cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cBindNumber = "";
    if(bindNumber){
        cBindNumber = [bindNumber cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cBirth = "";
    if(birth){
        cBirth = [birth cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cQQ = "";
    if(qq){
        cQQ = [qq cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cSignature = "";
    if(signature){
        cSignature = [signature cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cAddress = "";
    if(address){
        cAddress = [address cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    const char *cArea = "";
    if(area){
        cArea = [area cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    SS_UINT32 ret = IT_UpdateUserinfo(cNickName, cRealName, cBindNumber, sex, cBirth, cQQ, cSignature, cAddress, cArea);
    if(ret != 0){
        KFLog_Normal(YES, @"更新用户信息失败 = %d",(int)ret);
        return NO;
    }
    return YES;
}
@end
