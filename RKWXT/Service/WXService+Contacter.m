//
//  WXService+Contacter.m
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXService.h"

@implementation WXService (Contacter)

- (NSInteger)updateContacter:(NSInteger)recordID name:(NSString*)name phone:(NSString*)phone
                 createTime:(NSInteger)createTime modifyTime:(NSInteger)modifyTime{
    NSString *recordIDStr = [NSString stringWithFormat:@"%d",(int)recordID];
    return IT_UpdateFriend([recordIDStr cStringUsingEncoding:NSUTF8StringEncoding], [name cStringUsingEncoding:NSUTF8StringEncoding], [phone cStringUsingEncoding:NSUTF8StringEncoding], (SS_UINT32)createTime, (SS_UINT32)modifyTime);
}

- (NSInteger)loadWXContacterFromDB{
    return IT_LoadWoXinFriend();
}

- (NSString*)wxContacterIcon:(NSUInteger)rID{
    const char *iconStr = IT_GetFriendIconEx((SS_UINT32)rID);
    if(iconStr){
        return [NSString stringWithFormat:@"%s",iconStr];
    }
    return nil;
}

- (NSInteger)deleteWXContacter:(NSUInteger)rID{
    return IT_DeleteFriend((SS_UINT32)rID);
}

- (NSInteger)updateNickName:(NSString*)nickName rID:(NSUInteger)rID{
    return IT_UpdateFriendRemarkName((SS_UINT32)rID, [nickName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSInteger)updateWXIcon:(NSString*)iconPath{
    return IT_UploadMyIcon([iconPath cStringUsingEncoding:NSUTF8StringEncoding]);
}

//- (NSInteger)uploadDeviceInfo{
//    SS_USHORT sysType = 2;
//    NSString *sysVersion;
//    NSString *deviceName;
//#warning 版本和设备名字没有初始化~
//    return IT_UploadPhoneInfo(sysType, [sysVersion cStringUsingEncoding:NSUTF8StringEncoding],
//                      [deviceName cStringUsingEncoding:NSUTF8StringEncoding]);
//}
@end