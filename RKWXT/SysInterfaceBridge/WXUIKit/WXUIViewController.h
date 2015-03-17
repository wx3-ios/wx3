//
//  WXUIViewController.h
//  WoXin
//
//  Created by  ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//
typedef enum {
    //不阻塞界面
    E_WaiteView_Mode_Unblock,
    //阻塞baseView
    E_WaiteView_Mode_BaseViewBlock,
    //阻塞全频
    E_WaiteView_Mode_FullScreenBlock,
}E_WaiteView_Mode;

typedef enum {
    E_Slide_Dexterity_High = 0, //灵敏度高~
    E_Slide_Dexterity_Normal,  //灵敏度适中~
    E_Slide_Dexterity_Low,    //灵敏度低~
    
    E_Slide_Dexterity_None,//不支持侧滑
}E_Slide_Dexterity;

#import <UIKit/UIKit.h>

@class WXUIButton;
@class CSTWXNavigationView;
@class WXUINavigationController;
@interface WXUIViewController : UIViewController
@property (nonatomic,assign)E_Slide_Dexterity dexterity;
@property (nonatomic,assign,readonly)CSTWXNavigationView *cstNavigationView;
@property (nonatomic,assign,readonly)UIView *baseView;
@property (nonatomic,assign)BOOL openKeyboardNotification;
@property (nonatomic, readonly)WXUINavigationController *wxNavigationController;

- (CGFloat)currentLimitXVelocity;//滑动的灵敏度
- (void)setBackgroundColor:(UIColor*)color;
- (CGRect)bounds;
- (void)addSubview:(UIView*)subView;
- (void)addSubview:(UIView*)subView autoresizingMask:(UIViewAutoresizing)mask;
//设置背景图片
- (void)setBackgroundImage:(UIImage*)image;

//title在block的模式下有用
- (void)showWaitViewMode:(E_WaiteView_Mode)mode tip:(NSString*)tip;
- (void)showWaitViewMode:(E_WaiteView_Mode)mode title:(NSString*)title;
- (void)unShowWaitView;

//设置导航栏按钮～
- (void)setLeftNavigationItem:(UIView*)btn;
- (void)setRightNavigationItem:(UIView*)btn;
//设置导航栏标题
- (void)setCSTTitle:(NSString*)title;
- (void)setCSTTitleFont:(UIFont*)font;
- (void)setCSTTitleColor:(UIColor*)color;
//隐藏导航栏
//这个函数必须要在所有view加载之前调用～
- (void)setCSTNavigationViewHidden:(BOOL)hidden animated:(BOOL)animated;

#pragma mark 后退的默认按钮
- (void)setBackNavigationBarItem;
- (void)back;
#pragma mark 虚函数
- (void)showKeyBoardDur:(CGFloat)dur height:(CGFloat)height;
- (void)hideKeyBoardDur:(CGFloat)dur;
@end
