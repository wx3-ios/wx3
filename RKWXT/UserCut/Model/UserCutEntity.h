//
//  UserCutEntity.h
//  RKWXT
//
//  Created by SHB on 15/8/6.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCutEntity : NSObject
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,assign) NSInteger userID;
@property (nonatomic,assign) NSInteger date;

+(UserCutEntity*)initUserCutEntityWithDic:(NSDictionary*)dic;

@end
