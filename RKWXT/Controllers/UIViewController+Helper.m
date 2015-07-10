//
//  UIViewController+Helper.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-11.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "UIViewController+Helper.h"
//#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "MZLoadingCircle.h"
#import "NSString+Helper.h"
#import "Tools.h"
#import "RegexKitLite.h"

@implementation UIViewController (Helper)


- (void)makeToast:(NSString *)msg
{
    [self makeToast:msg postion:ToastPostionCetner];
}


- (void)makeToast:(NSString *)msg postion:(NSInteger)postion
{
//    [self.view makeToast:msg duration:2 position:postions[postion]];
}

- (void)callPhone:(NSString *)phone
{
    NSString *finalNumber = phone;
    if (![phone isMobileNumber] && ![phone isTelephoneNumber]) {
        NSRange range = [phone rangeOfRegex:@"^1[34578]"];
        BOOL isZeroPrefix = [phone hasPrefix:@"0"];
        if (range.length == 0 && !isZeroPrefix) {
            finalNumber = [NSString stringWithFormat:@"%@%@", [USER_DEFAULT stringForKey:kUserAgentLocation], phone];
        }
    }
    
    
    BOOL sipCall = [USER_DEFAULT boolForKey:kUserAgentSipCall];
    if (sipCall) {
        [self callSIPhone:finalNumber];
    }
    else{
        [self callNormalPhone:finalNumber];
    }
}


- (void)callNormalPhone:(NSString *)phone
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    [controller setValue:[NSString stringWithFormat:@"%@", phone] forKey:@"callPhone"];
    [self presentViewController:controller animated:YES completion:nil ];
}


- (void)callSIPhone:(NSString *)phone
{
    NetworkStatus1 status = [Tools currentNetWorkStatus];
    if (status == NetworkStatusWifi || status == NetworkStatus3G || status == NetworkStatus4G) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
        [controller setValue:phone forKey:@"callPhone"];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        [self makeToast:@"你当前的网络不支持直拨"];
    }
}

- (void)showProgressHUDWithLabel:(NSString *)label
{
    MZLoadingCircle *loadingCircle = [[MZLoadingCircle alloc]initWithNibName:nil bundle:nil];
    loadingCircle.view.backgroundColor = [UIColor clearColor];
    
    //Colors for layers
//    loadingCircle.colorCustomLayer = THEME_COLOR;// [UIColor colorWithRed:0 green:0.65 blue:0.38 alpha:1];
//    loadingCircle.colorCustomLayer2 = THEME_COLOR; //[UIColor colorWithRed:0 green:0.65 blue:0.38 alpha:0.65];
//    loadingCircle.colorCustomLayer3 = THEME_COLOR;// [UIColor colorWithRed:0 green:0.65 blue:0.38 alpha:0.4];
    
    loadingCircle.colorCustomLayer = [UIColor colorWithRed:16.0/255.0 green:205.0/255.0 blue:245.0/255.0 alpha:1];
    loadingCircle.colorCustomLayer2 = [UIColor colorWithRed:16.0/255.0 green:205.0/255.0 blue:245.0/255.0 alpha:1];
    loadingCircle.colorCustomLayer3 = [UIColor colorWithRed:16.0/255.0 green:205.0/255.0 blue:245.0/255.0 alpha:1];
    
    int size = 100;
    
    CGRect frame = loadingCircle.view.frame;
    frame.size.width = size ;
    frame.size.height = size;
    loadingCircle.view.frame = frame;
    loadingCircle.view.layer.zPosition = MAXFLOAT;
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    //    hud.dimBackground = YES;
    hud.square = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = loadingCircle.view;
    hud.labelText = label;
}

- (void)showProgressHUD
{
    [self showProgressHUDWithLabel:nil];
}


- (void)hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showHUDText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}




@end
