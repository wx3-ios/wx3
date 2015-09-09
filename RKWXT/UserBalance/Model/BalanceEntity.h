//
//  BalanceEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    UserBalance_Type_Normal,
    UserBalance_Type_Month,
}UserBalance_Type;

@interface BalanceEntity : NSObject
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,assign) UserBalance_Type type;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,assign) NSInteger normalDate;

+(BalanceEntity*)initUserBalanceWithDic:(NSDictionary*)dic;

@end
