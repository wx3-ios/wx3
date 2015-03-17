//
//  ViewController.m
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
//#import "LeftMenuViewController.h"
//#import "MainViewController.h"
#import "HttpNetUtils.h"
#import "MBProgressHUD.h"
#import "Constants.h"
//#import "YRSideViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];	NSLog(@"%s",__func__);
//    [self rootPager];
//    [HttpNetUtils loginHttpActionWith:@"15338891547" andPasswd:@"123456" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"token:%@\tuser_id:%@",obj[@"token"],obj[@"user_id"]);
//            [USER_DEFAULT setObject:obj[@"token"] forKey:@"token"];
//            [USER_DEFAULT setObject:obj[@"user_id"] forKey:@"userId"];
//        }
//    }];
    
//    [HttpNetUtils getBalanceWith:@"1003468" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"balance:%@\texpireddate:%@",obj[@"balance"],obj[@"expireddate"]);
//            NSLog(@"state:%@",obj[@"state"]);
//        }
//    }];
    
//    [HttpNetUtils dailyAttendanceWith:@"1003468" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"balance:%@\texpireddate:%@",obj[@"balance"],obj[@"expireddate"]);
//            NSLog(@"state:%@",obj[@"state"]);
//        }else if([obj[@"success"] intValue] == 0){
//    
//        }
//    }];

//    [HttpNetUtils officialPayWith:@"1003468" andPhoneNo:@"15338891547" andCardSN:@"11111" andCardPS:@"22222" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"成功");
//        }else if([obj[@"success"] intValue] == 0){
//            NSLog(@"msg:%@",obj[@"msg"]);
//        }
//    }];
    // 没有注册接口
//    [HttpNetUtils registerHttpActionWith:@"17093436556" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"成功");
//        }else if([obj[@"success"] intValue] == 0){
//            NSLog(@"msg:%@",obj[@"msg"]);
//        }
//    }];
    // 没有忘记密码接口
//    [HttpNetUtils forgetPasswdWith:@"15338891547" andCallback:^(id obj){
//        if([obj[@"success"] intValue] == 1){
//            NSLog(@"成功");
//        }else if([obj[@"success"] intValue] == 0){
//            NSLog(@"msg:%@",obj[@"msg"]);
//        }
//    }];
//    NSLocalizedString(<#key#>, <#comment#>)
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)userLogin:(id)sender{
    NSLog(@"%s",__func__);
    NSLog(@"Hello");
    [self checkUserInfoWith:self.phoneTextField.text andPasswd:self.pwdTextField.text];
}

-(IBAction)userRegister:(id)sender{
    NSLog(@"%s",__func__);
    NSLog(@"Hello");
}

-(void)checkUserInfoWith:(NSString *)userName andPasswd:(NSString *)passwd{
    if ([userName length] == 0) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"用户不能为空");
    }else if([passwd length] == 0){
        NSLog(@"密码不能为空");
    }else{
        [HttpNetUtils loginHttpActionWith:self.phoneTextField.text andPasswd:self.pwdTextField.text andCallback:^(id obj){
            if([obj[@"success"] intValue] == 1){
                NSLog(@"token:%@\tuser_id:%@",obj[@"token"],obj[@"user_id"]);
                [USER_DEFAULT setObject:obj[@"token"] forKey:@"token"];
                [USER_DEFAULT setObject:obj[@"user_id"] forKey:@"userId"];
//                [self rootPager];
            }
        }];
    }
}


@end
