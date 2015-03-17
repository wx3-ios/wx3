//
//  WXUINavigationController+SubVCPosition.m
//  Woxin2.0
//
//  Created by le ting on 8/15/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUINavigationController.h"

@implementation WXUINavigationController (SubVCPosition)

- (E_VC_Position)positionOfClass:(Class)vcClass{
    E_VC_Position ret = E_VC_Position_None;
    NSArray *children = [self childViewControllers];
    
    UIViewController *topVC = [children lastObject];
    if([topVC isKindOfClass:vcClass]){
        ret = E_VC_Position_Top;
    }else{
        for(UIViewController *vc in children){
            if([vc isKindOfClass:vcClass]){
                ret = E_VC_Position_In;
                break;
            }
        }
    }
    return ret;
}

- (UIViewController*)lastViewControllerOfClass:(Class)vcClass{
    NSArray *children = [self childViewControllers];
    for(UIViewController *vc in children){
        if([vc isKindOfClass:vcClass]){
            return vc;
        }
    }
    return nil;
}
@end
