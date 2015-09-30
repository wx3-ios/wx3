//
//  WithdrawalsRecordEntity.h
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    AliMoney_Type_Submit = 0,
    AliMoney_Type_Complete,
    AliMoney_Type_Failed,
}AliMoney_Type;

@interface WithdrawalsRecordEntity : NSObject
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,assign) AliMoney_Type ali_type;
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,assign) NSInteger completeTime;
@property (nonatomic,assign) CGFloat money;

+(WithdrawalsRecordEntity*)initAliRecordListWithDic:(NSDictionary*)dic;

@end
