//
//  WXUINavigationController.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    E_VC_Position_Top, //在顶部
    E_VC_Position_In, //在中间
    E_VC_Position_None,//不在堆里~
}E_VC_Position;

typedef void (^WXUINavigationControllerCompletionBlock)(void);

@interface WXUINavigationController : UIViewController
@property(nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic,readonly)UIViewController *rootViewController;

- (id) initWithRootViewController:(UIViewController*)rootViewController;

- (void) pushViewController:(UIViewController *)viewController;
- (void) pushViewController:(UIViewController *)viewController completion:(WXUINavigationControllerCompletionBlock)handler;
- (void)popToRootViewControllerAnimated:(BOOL)animated Completion:(WXUINavigationControllerCompletionBlock)handler;
- (void)popToViewController:(UIViewController*)viewController animated:(BOOL)animated Completion:(WXUINavigationControllerCompletionBlock)handler;
- (void)popViewControllerAnimated:(BOOL)animated completion:(WXUINavigationControllerCompletionBlock)handler;
@end

@interface WXUINavigationController (SubVCPosition)
- (E_VC_Position)positionOfClass:(Class)vcClass;
- (UIViewController*)lastViewControllerOfClass:(Class)vcClass;
@end
