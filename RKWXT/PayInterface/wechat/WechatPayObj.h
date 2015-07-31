//
//  WechatPayObj.h
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WechatEntity;

@interface WechatPayObj : NSObject

-(void)wechatPayWith:(WechatEntity*)entity;

@end
