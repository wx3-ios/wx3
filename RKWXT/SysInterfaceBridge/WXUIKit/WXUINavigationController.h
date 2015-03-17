//
//  WXUINavigationController.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WXUINavigationControllerCompletionBlock)(void);

@interface WXUINavigationController : UIViewController
@property(nonatomic, retain) NSMutableArray *viewControllers;

- (id) initWithRootViewController:(UIViewController*)rootViewController;

- (void) pushViewController:(UIViewController *)viewController;
- (void) pushViewController:(UIViewController *)viewController completion:(WXUINavigationControllerCompletionBlock)handler;
- (void) popViewController;
- (void) popViewControllerWithCompletion:(WXUINavigationControllerCompletionBlock)handler;

@end
