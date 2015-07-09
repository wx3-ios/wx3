//
//  RefundStateEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundStateEntity : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *address;

+(RefundStateEntity*)initRefundStateWithDic:(NSDictionary*)dic;

@end
