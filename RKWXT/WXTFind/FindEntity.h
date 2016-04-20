//
//  FindEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindEntity : NSObject
@property (nonatomic,strong) NSString *webUrl;
@property (nonatomic,strong) NSString *icon_url;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) NSInteger classifyID;
@property (nonatomic,assign) NSInteger sortID;

+(FindEntity*)initFindEntityWith:(NSDictionary*)dic;

@end
