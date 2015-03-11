//
//  UIViewController+Helper.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-11.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ToastPostion)
{
    ToastPostionTop,
    ToastPostionCetner,
    ToastPostionBottom,
};

@interface UIViewController (Helper)


- (void)makeToast:(NSString *)msg;

- (void)makeToast:(NSString *)msg postion:(NSInteger)postion;

- (void)callPhone:(NSString *)phone;

- (void)showProgressHUDWithLabel:(NSString *)label;

- (void)showProgressHUD;

- (void)hideProgressHUD;

- (void)showHUDText:(NSString *)text;

@end
