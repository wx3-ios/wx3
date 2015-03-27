//
//  ResetPwdModel.h
//  RKWXT
//
//  Created by SHB on 15/3/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResetPwdDelegate;
@interface ResetPwdModel : NSObject
@property (nonatomic,assign) id<ResetPwdDelegate>delegate;
-(void)resetPwdWithNewPwd:(NSString*)newPwd;

@end

@protocol ResetPwdDelegate <NSObject>
-(void)resetPwdSucceed;
-(void)resetPwdFailed:(NSString*)errorMsg;

@end
