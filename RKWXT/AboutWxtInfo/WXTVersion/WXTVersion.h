//
//  WXTVersion.h
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    WXT_Version_Advance = 0,
    WXT_Version_Force,
    
    WXT_Version_Invalid,
}WXT_Version_Type;

typedef enum{
    Version_CheckType_User,
    Version_CheckType_System,
    
    Version_CheckType_Invalid,
}Version_CheckType;

@interface WXTVersion : NSObject
@property (nonatomic,assign) Version_CheckType checkType;
+(WXTVersion*)sharedVersion;

-(void)checkVersion;
-(NSString*)showCurrentVersion;
-(NSString*)currentVersion;

@end
