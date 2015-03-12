//
//  LoginModel.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate;
@interface LoginModel : NSObject
@property (nonatomic,assign) id<LoginDelegate>delegate;
-(void)loginWithUser:(NSString*)userStr andPwd:(NSString*)pwdStr;
@end

@protocol LoginDelegate <NSObject>
-(void)loginSucceed;
-(void)loginFailed:(NSString*)errrorMsg;

@end
