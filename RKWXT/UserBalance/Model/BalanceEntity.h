//
//  BalanceEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceEntity : NSObject
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *date;

+(BalanceEntity*)initUserBalanceWithDic:(NSDictionary*)dic;

@end
