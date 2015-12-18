//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"

@interface CDSideBarController(){
    UIView *shellView;
}
@end

@implementation CDSideBarController

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;

#pragma mark - 
#pragma mark Init
- (CDSideBarController*)initWithImages:(NSArray*)images{
    NSArray *nameArr = @[@"QQ好友", @"QQ空间", @"微信", @"朋友圈"];
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    [shellView setBackgroundColor:[UIColor blackColor]];
    [shellView setAlpha:0.0];
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(0, 0, 25, 25);
    [_menuButton setImage:[UIImage imageNamed:@"LMSharedImg.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    _labelList = [[NSMutableArray alloc] init];
    
    CGFloat xOffset = 20;
    CGFloat yOffset = 30;
    CGFloat width = 50;
    textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, yOffset, width, 15);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(14.0)];
    [textLabel setText:@"分享"];
    
    int index = 0;
    for (UIImage *image in [images copy]){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(xOffset, 50 + (80 * index), width, 50);
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        
        WXUILabel *label = [[WXUILabel alloc] init];
        label.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height, button.frame.size.width, 15);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:nameArr[index]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:WXColorWithInteger(0x000000)];
        [label setFont:WXFont(11.0)];
        [_labelList addObject:label];
        
        ++index;
    }
    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position{
    [view addSubview:shellView];
    
    _menuButton.frame = CGRectMake(position.x, position.y, _menuButton.frame.size.width, _menuButton.frame.size.height);
    [view addSubview:_menuButton];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [shellView addGestureRecognizer:singleTap];
    
    [_backgroundMenuView addSubview:textLabel];
    for (UIButton *button in _buttonList){
        [_backgroundMenuView addSubview:button];
    }
    for(WXUILabel *label in _labelList){
        [_backgroundMenuView addSubview:label];
    }

    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    [view addSubview:_backgroundMenuView];
}

#pragma mark - 
#pragma mark Menu button action
- (void)dismissMenuWithSelection:(UIButton*)button{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu{
    if (_isOpen){
        _isOpen = !_isOpen;
       [self performDismissAnimation];
    }
}

- (void)showMenu{
    if (!_isOpen){
        _isOpen = !_isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}

- (void)onMenuButtonClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations
- (void)performDismissAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _menuButton.alpha = 1.0f;
        [shellView setAlpha:0.0];
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

- (void)performOpenAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _menuButton.alpha = 0.0f;
            [shellView setAlpha:0.5];
            _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList){
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
    for (WXUILabel *label in _labelList){
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            label.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    label.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}

@end
