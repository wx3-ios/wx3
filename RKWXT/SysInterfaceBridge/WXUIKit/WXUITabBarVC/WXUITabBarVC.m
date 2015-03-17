//
//  WXUITabBarVC.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUITabBarVC.h"

#define kInvalidSelectedIndex (-1)
@interface WXUITabBarVC ()
{
    NSArray *_controllers;
    WXUITabBar *_tabBar;
    
    NSInteger _preSelectedIndex;
    NSInteger _selectedIndex;
}
@end

@implementation WXUITabBarVC
@synthesize controllers = _controllers;
@synthesize tabBar = _tabBar;

- (void)dealloc{
    RELEASE_SAFELY(_controllers);
    RELEASE_SAFELY(_tabBar);
    [super dealloc];
}
- (id)initWithControllers:(NSArray*)controllers tabBar:(WXUITabBar*)tabBar{
    if(self = [super init]){
        NSInteger controllerCount = [controllers count];
        NSInteger tabBarItemCount = [[tabBar tabBarItemArray] count];
        NSAssert(controllerCount > 1 && controllerCount == tabBarItemCount, @"controller和tabbarItem的数目不对~");
        _controllers = [controllers retain];
        _tabBar = [tabBar retain];
        _preSelectedIndex = kInvalidSelectedIndex;
        _selectedIndex = kInvalidSelectedIndex;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    CGSize size = self.bounds.size;
    CGSize tabBarSize = _tabBar.bounds.size;
    WXUILabel *linLabel = [[WXUILabel alloc] init];
    linLabel.frame = CGRectMake(0, size.height-tabBarSize.height, tabBarSize.width, 0.5);
    [linLabel setBackgroundColor:WXColorWithInteger(0xdcdcdc)];
    [self addSubview:linLabel];
    RELEASE_SAFELY(linLabel);
    
    [_tabBar setFrame:CGRectMake(0, size.height-tabBarSize.height+0.5, tabBarSize.width, tabBarSize.height)];
    [self addSubview:_tabBar];
    [_tabBar.layer setZPosition:100.0];
    [_tabBar setDelegate:self];
    
    if(kInvalidSelectedIndex == _selectedIndex){
        _selectedIndex = 0;
    }
    [self showCurrentIndex:_selectedIndex preIndex:_preSelectedIndex];
    [self.tabBar setSelectedIndex:_selectedIndex];
}

- (CGRect)contentRect{
    CGSize size = self.bounds.size;
    return CGRectMake(0, 0, size.width, size.height - _tabBar.bounds.size.height);
}

- (void)repeatSelectedAtIndex:(NSInteger)index{
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _preSelectedIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    if([self.baseView superview]){
        [self showCurrentIndex:_selectedIndex preIndex:_preSelectedIndex];
        [_tabBar setSelectedIndex:_selectedIndex];
    }
}

- (WXUIViewController*)currentViewController{
    return [_controllers objectAtIndex:_selectedIndex];
}

- (void)showCurrentIndex:(NSInteger)currentIndex preIndex:(NSInteger)preIndex{
    WXUIViewController *vc = [_controllers objectAtIndex:currentIndex];
    if([self.childViewControllers indexOfObject:vc] == NSNotFound){
        [self addChildViewController:vc];
        [vc.view setFrame:[self contentRect]];
        [vc.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:vc.view];
    }else{
        [vc viewWillAppear:YES];
        [vc viewDidAppear:YES];
    }
    [self.baseView bringSubviewToFront:vc.view];
    if(preIndex != kInvalidSelectedIndex){
        WXUIViewController *preVC = [_controllers objectAtIndex:preIndex];
        [preVC viewWillDisappear:YES];
        [preVC viewDidDisappear:YES];
    }
}

- (void)selectedAtIndex:(NSInteger)index{
    _preSelectedIndex = _selectedIndex;
    _selectedIndex = index;
    [self showCurrentIndex:_selectedIndex preIndex:_preSelectedIndex];
}

- (void)setTabBarHidden:(BOOL)hidden aniamted:(BOOL)animated completion:(void (^)(void))completion{
    CGSize size = self.bounds.size;
    CGFloat tabBarHeight = _tabBar.bounds.size.height;
    
    CGRect viewRect = self.bounds;
    CGRect tabBarRect = _tabBar.bounds;
    if(hidden){
        tabBarRect.origin.y = size.height;
    }else{
        tabBarRect.origin.y = size.height - tabBarHeight;
        viewRect.size.height -= tabBarHeight;
    }
    if(animated){
        [UIView animateWithDuration:kWXUITabBarAnimatedDuration animations:^{
            for(UIViewController *vc in self.childViewControllers){
                [vc.view setFrame:viewRect];
            }
            [_tabBar setFrame:tabBarRect];
        } completion:^(BOOL finished) {
            completion();
        }];
    }else{
        for(UIViewController *vc in self.childViewControllers){
            [vc.view setFrame:viewRect];
        }
        [_tabBar setFrame:tabBarRect];
        completion();
    }
    
}

@end
