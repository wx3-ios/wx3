//
//  VersionEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionEntity : NSObject
@property (nonatomic,strong) NSString *updateMsg;
@property (nonatomic,strong) NSString *appUrl;
@property (nonatomic,assign) NSInteger updateType;

+(VersionEntity*)versionWithDictionary:(NSDictionary*)dic;

@end
