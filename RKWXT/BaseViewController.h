//
//  BaseViewController.h
//  RKWXT
//
//  Created by Elty on 15/3/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Helper.h"

typedef enum {
    //不阻塞界面
    E_WaiteView_Mode_Unblock,
    //阻塞baseView
    E_WaiteView_Mode_BaseViewBlock,
    //阻塞全频
    E_WaiteView_Mode_FullScreenBlock,
}E_WaiteView_Mode;


@interface BaseViewController : UIViewController

- (void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString*)tip;
- (void)showWaitView;
- (void)unShowWaitView;

@end
