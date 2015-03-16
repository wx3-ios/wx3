//
//  BaseVC.h
//  RKWXT
//
//  Created by SHB on 15/3/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Helper.h"

typedef enum {
    //不阻塞界面
    E_WaiteView_Mode_Unblock1,
    //阻塞baseView
    E_WaiteView_Mode_BaseViewBlock1,
    //阻塞全频
    E_WaiteView_Mode_FullScreenBlock1,
}E_WaiteView_Mode1;


@interface BaseVC : UIViewController

- (void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString*)tip;
- (void)showWaitView:(UIView*)onView;
- (void)unShowWaitView;

@end
