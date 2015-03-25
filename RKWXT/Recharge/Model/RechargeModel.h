//
//  RechargeModel.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RechargeDelegate;
@interface RechargeModel : NSObject
@property (nonatomic,assign) id<RechargeDelegate>delegate;
-(void)rechargeWithCardNum:(NSString*)num andPwd:(NSString*)pwd withRechargePhone:(NSString*)rechargePhone;

@end

@protocol RechargeDelegate <NSObject>
-(void)rechargeSucceed;
-(void)rechargeFailed:(NSString*)errorMsg;

@end
