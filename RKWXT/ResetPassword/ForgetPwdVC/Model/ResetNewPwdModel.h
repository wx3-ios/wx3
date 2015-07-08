//
//  ResetNewPwdModel.h
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResetNewPwdDelegate;
@interface ResetNewPwdModel : NSObject
@property (nonatomic,assign) id<ResetNewPwdDelegate>delegate;

-(void)resetNewPwdWithUserPhone:(NSString*)phone withCode:(NSInteger)code withNewPwd:(NSString*)newPwd;
@end

@protocol ResetNewPwdDelegate <NSObject>
-(void)resetNewPwdSucceed;
-(void)resetNewPwdFailed:(NSString*)errorMsg;

@end
