//
//  ButtonWithTitleView.m
//  CallUITest
//
//  Created by Elty.Le on 12/19/13.
//  Copyright (c) 2013 Elty.Le. All rights reserved.
//

#import "PingponeButton.h"

@interface PingponeButton()
{
    UIButton *_button;
    UILabel *_label;
    
    UIColor *_titleNormalColor;
    UIColor *_titleSelectColor;
    UIColor *_titleDisableColor;
}
@end

@implementation PingponeButton
@synthesize delegate = mDelegate;
@synthesize bPingpongButton = mbPingpongButton;
@synthesize buttonInfo = _buttonInfo;

- (void)dealloc{
    self.delegate = nil;
//    [_button release]; _button = nil;
//    [_label release]; _label = nil;
//    [_buttonInfo release]; _buttonInfo = nil;
//    [_titleNormalColor release]; _titleNormalColor = nil;
//    [_titleSelectColor release]; _titleSelectColor = nil;
//    [_titleDisableColor release]; _titleDisableColor = nil;
//    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [self addSubview:_button];
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_label];
        
        [_button addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(buttonDragOutSide) forControlEvents:UIControlEventTouchDragOutside];
        [_button addTarget:self action:@selector(buttonDragInside) forControlEvents:UIControlEventTouchDragInside];
        [_button addTarget:self action:@selector(buttonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonTouchCancel) forControlEvents:UIControlEventTouchCancel];
    }
    return self;
}

- (void)setNormalImage:(UIImage*)normalImage selectImage:(UIImage*)selectImage disableImage:(UIImage*)disableImage{
    NSAssert(normalImage != nil, @"normalImage can't be nil");
    
    if(normalImage){
        [_button setImage:normalImage forState:UIControlStateNormal];
    }
    if(selectImage){
        [_button setImage:selectImage forState:UIControlStateHighlighted];
        [_button setImage:selectImage forState:UIControlStateSelected];
    }
    if(disableImage){
        [_button setImage:disableImage forState:UIControlStateDisabled];
    }
    CGSize size = [self bounds].size;
    
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    [_button setFrame:CGRectMake(xOffset, yOffset, size.width, size.height)];
}

- (void)setNormalImage:(UIImage*)normalImage selectImage:(UIImage*)selectImage disableImage:(UIImage*)disableImage
                 title:(NSString*)title font:(UIFont*)font
           normalColor:(UIColor*)normalColor selectColor:(UIColor*)selectColor disableColor:(UIColor*)disableColor{
    
    NSAssert(normalImage != nil, @"normalImage can't be nil");
    CGSize btnSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    
    _titleNormalColor = normalColor;
    [_label setTextColor:normalColor];
    btnSize = normalImage.size;
    
    if(selectColor){
        _titleSelectColor = selectColor;
        
    }
    if(disableColor){
        _titleDisableColor = disableColor;
    }
    [_label setText:title];
    UIFont *titleFont = [UIFont systemFontOfSize:14.0];
    if(font){
        titleFont = font;
    }
    [_label setFont:titleFont];
    
    if(normalImage){
        [_button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    if(selectImage){
        [_button setBackgroundImage:selectImage forState:UIControlStateHighlighted];
        [_button setBackgroundImage:selectImage forState:UIControlStateSelected];
    }
    if(disableImage){
        [_button setBackgroundImage:disableImage forState:UIControlStateDisabled];
    }
    
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        titleSize = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
#endif
    }else{
        titleSize = [title sizeWithFont:titleFont];
    }
    
    CGSize size = [self bounds].size;
    
    CGFloat xOffset = 0.0;
    CGFloat yOffset = 0.0;
    
    xOffset = (size.width - btnSize.width)*0.5;
    yOffset = (size.height - btnSize.height - titleSize.height)*0.5;
    [_button setFrame:CGRectMake(xOffset, yOffset, btnSize.width, btnSize.height)];
    
//    xOffset = 0.0;
    yOffset += btnSize.height;
    [_label setFrame:CGRectMake(0, yOffset, size.width, titleSize.height)];
}

- (void)setLabelColorToNormal{
    if(_titleNormalColor){
        [_label setTextColor:_titleNormalColor];
    }
}

- (void)setLabelColorToGray{
    [_label setTextColor:[UIColor grayColor]];
}

- (void)setLabelColorToHighlight{
    if(_titleSelectColor){
        [_label setTextColor:_titleSelectColor];
    }else{
        [self setLabelColorToNormal];
    }
}

- (void)setLabelColorToDisabled{
    if(_titleDisableColor){
        [_label setTextColor:_titleDisableColor];
    }else{
        [self setLabelColorToNormal];
    }
}

- (BOOL)isSelected{
    return [_button isSelected];
}
- (void)setSelected:(BOOL)selected{
    [_button setSelected:selected];
    if(selected){
       [self setLabelColorToHighlight];
    }else{
        [self setLabelColorToNormal];
    }
}

- (void)setEnable:(BOOL)enable{
    [_button setEnabled:enable];
}

- (void)buttonTouchDown{
    if(_button.selected){
        [self setLabelColorToGray];
    }else{
        [self setLabelColorToHighlight];
    }
}
- (void)buttonDragOutSide{
    if(_button.selected){
        [self setLabelColorToHighlight];
    }else{
        [self setLabelColorToNormal];
    }
}
- (void)buttonDragInside{
    if(_button.selected){
        [self setLabelColorToGray];
    }else{
        [self setLabelColorToHighlight];
    }
}
- (void)buttonTouchUpInside{
    if(mbPingpongButton){
        BOOL bSelect = [_button isSelected];
        bSelect = !bSelect;
        [_button setSelected:bSelect];
        if(bSelect){
            [self setLabelColorToHighlight];
        }else{
            [self setLabelColorToNormal];
        }
    }else{
        [self setLabelColorToNormal];
    }
    if(mDelegate && [mDelegate respondsToSelector:@selector(touchUpInside:)]){
        [mDelegate touchUpInside:self];
    }
}

- (void)buttonTouchCancel{
    if(_button.selected){
        [self setLabelColorToHighlight];
    }else{
        [self setLabelColorToNormal];
    }
}
@end
