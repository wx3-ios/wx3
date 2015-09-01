//
//  UserHeaderImgModel.m
//  RKWXT
//
//  Created by SHB on 15/7/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserHeaderImgModel.h"

#define kMaxIconLength (180*1000)

@implementation UserHeaderImgModel

+(UserHeaderImgModel*)shareUserHeaderImgModel{
    static dispatch_once_t onceToken;
    static UserHeaderImgModel *sharedInstance = nil;
    dispatch_once(&onceToken,^{
        sharedInstance = [[UserHeaderImgModel alloc] init];
    });
    return sharedInstance;
}

- (NSString*)userIconName{
    return @"userIcon";
}

- (NSString*)iconDir{
    NSString *documentPath = [UtilTool documentPath];
    NSString *path = [NSString stringWithFormat:@"%@/userIcon.png",documentPath];
    return path;
}

- (NSString*)userIconPath{
    NSString *dir = [self iconDir];
    return dir;
}

-(BOOL)uploadUserHeaderImgWith:(NSData *)imgData{
    NSInteger length = [imgData length];
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
    BOOL succeed = [imgData writeToFile:iconTempPath atomically:YES];
    if(succeed){
        KFLog_Normal(YES, @"头像保存成功");
    }else{
        KFLog_Normal(YES, @"头像保存失败");
        return NO;
    }
    
    return YES;
}

@end
