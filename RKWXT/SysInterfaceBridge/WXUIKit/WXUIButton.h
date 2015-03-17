//
//  WXUIButton.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

typedef enum {
    E_Button_Title_Alignment_Left = 0,
    E_Button_Title_Alignment_Center,
    E_Button_Title_Alignment_Right,
}E_Button_Title_Alignment;

#import <UIKit/UIKit.h>

@interface WXUIButton : UIButton
@property (nonatomic,assign)BOOL showLineOnButtom;
@property (nonatomic,retain)id buttonInfo;

+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                              NorImg:(UIImage*)normalImg selImg:(UIImage*)selectImage disableImg:(UIImage*)disableImg
                            norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg
                               title:(NSString*)title
                    normalTitleColor:(UIColor*)normalColor selTitleColor:(UIColor*)selColor
                   disableTitleColor:(UIColor*)disableColor;
+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                            norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg
                               title:(NSString*)title titleColor:(UIColor*)titleColor;
+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                      norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg;
+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                         title:(NSString*)title normalTitleColor:(UIColor*)normalColor selTitleColor:(UIColor*)selColor
             disableTitleColor:(UIColor*)disableColor;
//一般的按钮
+ (WXUIButton*)normalButtonWithFrame:(CGRect)frame title:(NSString*)title;
//带警告的按钮
+ (WXUIButton*)warningButtonWithFrame:(CGRect)frame title:(NSString*)title;

- (void)setButtonTitleAlignment:(E_Button_Title_Alignment)alilgnment;

//设置背景图片~
- (void)setBackgroundImageOfColor:(UIColor*)color controlState:(UIControlState)state;
@end
