//
//  PersonNicknameVC.h
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

@protocol PersonNickNameDelegate ;
@interface PersonNicknameVC : WXUIViewController
@property (nonatomic,assign) id<PersonNickNameDelegate>delegate;

@end

@protocol PersonNickNameDelegate <NSObject>
-(void)didSetPersonNickname:(NSString*)nickName;

@end
