//
//  VersionModel.h
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckVersionDelegate;
@interface VersionModel : NSObject
@property (nonatomic,assign) id<CheckVersionDelegate>delegate;
@property (nonatomic,strong) NSArray *updateArr;
-(void)checkVersion:(NSString*)currentVersion;
@end

@protocol CheckVersionDelegate <NSObject>
-(void)checkVersionSucceed;
-(void)checkVersionFailed:(NSString*)errorMsg;

@end
