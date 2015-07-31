//
//  WechatEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/31.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatEntity : NSObject
@property (nonatomic,strong) NSString *noncestr;
@property (nonatomic,strong) NSString *prepayid;
@property (nonatomic,assign) NSInteger timestamp;
@property (nonatomic,strong) NSString *sign;

+(WechatEntity*)initWechatEntityWithDic:(NSDictionary*)dic;

@end
