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
    return @"userHeadIcon";
}

- (NSString*)iconDir{
    NSString *documentPath = [UtilTool documentPath];
    return [documentPath stringByAppendingPathComponent:@"icon"];
}

- (NSString*)userIconPath{
    NSString *dir = [self iconDir];
    return [dir stringByAppendingPathComponent:[self userIconName]];
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
    [imgData writeToFile:iconTempPath atomically:YES];
    return YES;
}

@end
