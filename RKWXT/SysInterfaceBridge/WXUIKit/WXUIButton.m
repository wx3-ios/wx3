//
//  WXUIButton.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIButton.h"
#import "UIImage+Render.h"

@interface WXUIButton()
@end

@implementation WXUIButton

- (void)dealloc{
	RELEASE_SAFELY(_buttonInfo);
	[super dealloc];
}

+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                              NorImg:(UIImage*)normalImg selImg:(UIImage*)selectImage disableImg:(UIImage*)disableImg
                            norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg
                               title:(NSString*)title
                    normalTitleColor:(UIColor*)normalColor selTitleColor:(UIColor*)selColor
                   disableTitleColor:(UIColor*)disableColor{
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if(target && selector){
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    if(normalImg){
        [button setImage:normalImg forState:UIControlStateNormal];
    }
    if(selectImage){
        [button setImage:selectImage forState:UIControlStateSelected];
        [button setImage:selectImage forState:UIControlStateHighlighted];
    }
    if(disableImg){
        [button setImage:disableImg forState:UIControlStateDisabled];
    }
    if(norBgImg){
        [button setBackgroundImage:norBgImg forState:UIControlStateNormal];
    }
    if(selBgImg){
        [button setBackgroundImage:selBgImg forState:UIControlStateSelected];
        [button setBackgroundImage:selBgImg forState:UIControlStateHighlighted];
    }
    if(disableBgImg){
        [button setBackgroundImage:disableBgImg forState:UIControlStateDisabled];
    }
    if(title){
        [button setTitle:title forState:UIControlStateNormal];
    }
    if(normalColor){
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if(selColor){
        [button setTitleColor:selColor forState:UIControlStateHighlighted];
        [button setTitleColor:selColor forState:UIControlStateSelected];
    }
    if(disableColor){
        [button setTitleColor:disableColor forState:UIControlStateDisabled];
    }
    return button;
}

+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                            norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg
                               title:(NSString*)title titleColor:(UIColor*)titleColor{
    return [self buttonWithFrame:frame Target:target selector:selector NorImg:nil selImg:nil disableImg:nil norBgImg:norBgImg selBgImg:selBgImg disableBgImg:disableBgImg title:title normalTitleColor:titleColor selTitleColor:nil disableTitleColor:nil];
}

+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                      norBgImg:(UIImage*)norBgImg selBgImg:(UIImage*)selBgImg disableBgImg:(UIImage*)disableBgImg{
    return [self buttonWithFrame:frame Target:target selector:selector norBgImg:norBgImg selBgImg:selBgImg disableBgImg:disableBgImg title:nil titleColor:nil];
}

+ (WXUIButton*)normalButtonWithFrame:(CGRect)frame title:(NSString*)title{
    UIEdgeInsets edgeInsets =  UIEdgeInsetsMake(20, 20, 20, 20);
    UIImage *normalImg = [[UIImage imageNamed:@"btnNormal.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *selectImg = [[UIImage imageNamed:@"btnSelected.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *disableImg = [[UIImage imageNamed:@"btnDisable.png"] resizableImageWithCapInsets:edgeInsets];
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normalImg forState:UIControlStateNormal];
    [button setBackgroundImage:selectImg forState:UIControlStateSelected];
    [button setBackgroundImage:selectImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:disableImg forState:UIControlStateDisabled];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (WXUIButton*)warningButtonWithFrame:(CGRect)frame title:(NSString*)title{
    UIEdgeInsets edgeInsets =  UIEdgeInsetsMake(20, 20, 20, 20);
    UIImage *normalImg = [[UIImage imageNamed:@"redBtnNormal.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *selectImg = [[UIImage imageNamed:@"redBtnSelect.png"] resizableImageWithCapInsets:edgeInsets];
    UIImage *disableImg = [[UIImage imageNamed:@"commonBtnDisable.png"] resizableImageWithCapInsets:edgeInsets];
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normalImg forState:UIControlStateNormal];
    [button setBackgroundImage:selectImg forState:UIControlStateSelected];
    [button setBackgroundImage:selectImg forState:UIControlStateHighlighted];
    [button setBackgroundImage:disableImg forState:UIControlStateDisabled];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (WXUIButton*)buttonWithFrame:(CGRect)frame Target:(id)target selector:(SEL)selector
                         title:(NSString*)title normalTitleColor:(UIColor*)normalColor selTitleColor:(UIColor*)selColor
             disableTitleColor:(UIColor*)disableColor{
    return [self buttonWithFrame:frame Target:target selector:selector NorImg:nil selImg:nil disableImg:nil norBgImg:nil selBgImg:nil disableBgImg:nil title:title normalTitleColor:normalColor selTitleColor:selColor disableTitleColor:disableColor];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(_showLineOnButtom){
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIColor *color = self.titleLabel.textColor;
        CGFloat r,g,b,alpha;
        [color getRed:&r green:&g blue:&b alpha:&alpha];
        
        CGSize fontSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
        CGContextSetRGBStrokeColor(ctx, r, g, b, alpha);
        CGContextSetLineWidth(ctx, 1.0f);
        float fontLeft = self.titleLabel.center.x - fontSize.width/2.0;
        float fontRight = self.titleLabel.center.x + fontSize.width/2.0;
        CGFloat y = self.bounds.size.height*0.5 +  fontSize.height*0.5- 1;
        CGContextMoveToPoint(ctx, fontLeft, y);
        CGContextAddLineToPoint(ctx, fontRight, y);
        CGContextStrokePath(ctx);
    }
}

- (void)setButtonTitleAlignment:(E_Button_Title_Alignment)alilgnment{
    UIControlContentHorizontalAlignment align;
    switch (alilgnment) {
        case E_Button_Title_Alignment_Left:
            align = UIControlContentHorizontalAlignmentLeft;
            break;
        case E_Button_Title_Alignment_Center:
            align = UIControlContentHorizontalAlignmentCenter;
            break;
        case E_Button_Title_Alignment_Right:
            align = UIControlContentHorizontalAlignmentRight;
            break;
        default:
            break;
    }
    [self setContentHorizontalAlignment:align];
}

- (void)setBackgroundImageOfColor:(UIColor*)color controlState:(UIControlState)state{
    UIImage *img = [UIImage imageFromColor:color];
    [self setBackgroundImage:img forState:state];
}

@end
