//
//  ForgetModel.h
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgetResetPwdDelegate;
@interface ForgetModel : NSObject
@property (nonatomic,assign) id<ForgetResetPwdDelegate>delegate;

-(void)forgetPwdWithUserPhone:(NSString*)phone;
@end

@protocol ForgetResetPwdDelegate <NSObject>
-(void)forgetPwdSucceed;
-(void)forgetPwdFailed:(NSString*)errorMsg;

@end
