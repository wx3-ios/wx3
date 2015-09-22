//
//  WXButton.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXButton.h"
#define kTitleLabelFontSize (10.0)
#define kGapMax (2)
@interface WXButton()
{
    WXUILabel *_titleLabel;
    WXUIImageView *_iconImageView;
    WXUIImageView *_backgroundImageView;
    
    WXButtonType _buttonType;
}
@property (nonatomic,retain)UIColor *normalTitleColor;
@property (nonatomic,retain)UIColor *selectedTitleColor;
@property (nonatomic,retain)UIColor *disableTitleColor;

@property (nonatomic,retain)UIImage *normalImage;
@property (nonatomic,retain)UIImage *selectedImage;
@property (nonatomic,retain)UIImage *disableImage;

@property (nonatomic,retain)UIImage *normalBgImage;
@property (nonatomic,retain)UIImage *selectedBgImage;
@property (nonatomic,retain)UIImage *disableBgImage;
@end

@implementation WXButton
@synthesize titleLabel = _titleLabel;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize iconImageView = _iconImageView;

- (void)dealloc{
//    [super dealloc];
}

+ (id)buttonWithType:(WXButtonType)type{
    return [[self alloc] initWithType1:type];
}

- (id)initWithType1:(WXButtonType)type{
    if(self = [super init]){
		_buttonType = type;
		_backgroundImageView = [[WXUIImageView alloc] init];
		[self addSubview:_backgroundImageView];
		_iconImageView = [[WXUIImageView alloc] init];
		[self addSubview:_iconImageView];
		
		_titleLabel = [[WXUILabel alloc] init];
		[_titleLabel setFrame:self.bounds];
		[_titleLabel setFont:[UIFont systemFontOfSize:kTitleLabelFontSize]];
		[self addSubview:_titleLabel];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect{
//    [self showControlState:[self currentState]];
//}

- (void)setTitleSize:(CGFloat)titleSize{
    [_titleLabel setFont:WXFont(titleSize)];
	[self showControlState:[self currentState]];
}

- (void)setTitle:(NSString *)title forState:(WXButtonControlState)state{
    switch (state) {
        case WXButtonControlState_Normal:
            if(title == _normalTitle){
                return;
            }
            [self setNormalTitle:title];
            break;
        case WXButtonControlState_Selected:
            if(title == _selectedTitle){
                return;
            }
            [self setSelectedTitle:title];
            break;
        case WXButtonControlState_Disable:
            if(title == _disableTitle){
                return;
            }
            [self setDisableTitle:title];
            break;
        default:
            break;
    }
	[self showControlState:[self currentState]];
}

- (void)setTitleColor:(UIColor *)color forState:(WXButtonControlState)state{
    switch (state) {
        case WXButtonControlState_Normal:
            if(color == _normalTitleColor){
                return;
            }
            [self setNormalTitleColor:color];
            break;
        case WXButtonControlState_Selected:
            if(color == _selectedTitleColor){
                return;
            }
            [self setSelectedTitleColor:color];
            break;
        case WXButtonControlState_Disable:
            if(color == _disableTitleColor){
                return;
            }
            [self setDisableTitleColor:color];
            break;
        default:
            break;
    }
	[self showControlState:[self currentState]];
}
- (void)setImage:(UIImage *)image forState:(WXButtonControlState)state{
    switch (state) {
        case WXButtonControlState_Normal:
            if(image == _normalImage){
                return;
            }
            [self setNormalImage:image];
            break;
        case WXButtonControlState_Selected:
            if(image == _selectedImage){
                return;
            }
            [self setSelectedImage:image];
            break;
        case WXButtonControlState_Disable:
            if(image == _disableImage){
                return;
            }
            [self setDisableImage:image];
            break;
        default:
            break;
    }
	[self showControlState:[self currentState]];
}
- (void)setBackgroundImage:(UIImage *)image forState:(WXButtonControlState)state{
    switch (state) {
        case WXButtonControlState_Normal:
            if(image == _normalBgImage){
                return;
            }
            [self setNormalBgImage:image];
            break;
        case WXButtonControlState_Selected:
            if(image == _selectedBgImage){
                return;
            }
            [self setSelectedBgImage:image];
            break;
        case WXButtonControlState_Disable:
            if(image == _disableBgImage){
                return;
            }
            [self setDisableBgImage:image];
            break;
        default:
            break;
    }
	[self showControlState:[self currentState]];
}

- (WXButtonControlState)currentState{
    if(!self.enabled){
        return WXButtonControlState_Disable;
    }else{
        if(self.selected){
            return WXButtonControlState_Selected;
        }
    }
    return WXButtonControlState_Normal;
}

- (BOOL)needDisplayWhenSetState:(WXButtonControlState)state{
    return [self currentState] == state;
}

- (void)showControlState:(WXButtonControlState)state{
    NSString *title = nil;
    UIImage *bgImg = nil;
    UIImage *iconImage = nil;
    UIColor *color = nil;
    switch (state) {
        case WXButtonControlState_Normal:
            title = _normalTitle;
            bgImg = _normalBgImage;
            iconImage = _normalImage;
            color = _normalTitleColor;
            break;
        case WXButtonControlState_Selected:
            title = _selectedTitle;
            bgImg = _selectedBgImage;
            iconImage = _selectedImage;
            color = _selectedTitleColor;
            break;
        case WXButtonControlState_Disable:
            title = _disableTitle;
            bgImg = _disableBgImage;
            iconImage = _disableImage;
            color = _disableTitleColor;
            break;
        default:
            break;
    }
    if(!title){
        title = _normalTitle;
    }
    if(!bgImg){
        bgImg = _normalBgImage;
    }
    if(!iconImage){
        iconImage = _normalImage;
    }
    if(!color){
        color = _normalTitleColor;
    }
    if(!color){
        color = [UIColor whiteColor];
    }
    [_titleLabel setText:title];
    [_titleLabel setTextColor:color];
    [_backgroundImageView setImage:bgImg];
    [_iconImageView setImage:iconImage];
    [_backgroundImageView setFrame:self.bounds];
    
    CGSize titleSize = [title sizeWithFont:_titleLabel.font];
    CGSize iconSize = iconImage.size;
    CGSize size = self.bounds.size;
    if(iconSize.width > size.width){
        iconSize.width = size.width;
    }
    if(iconSize.height > size.height){
        iconSize.height = size.height;
    }
    if(titleSize.width > size.width){
        titleSize.width = size.width;
    }
    
    CGRect titleRect = CGRectMake(0, 0, titleSize.width, titleSize.height);
    CGRect iconRect = CGRectMake(0, 0, iconSize.width, iconSize.height);
    switch (_buttonType) {
        case WXButton_horizontal:
            if(titleSize.width + iconSize.width + kGapMax > size.width){
                iconRect.origin.x = (size.width - iconRect.size.width)*0.5;
                titleRect.origin.x = (size.width - titleRect.size.width)*0.5;
            }else{
                CGFloat xOffset = (size.width - iconSize.width - titleSize.width - kGapMax)*0.5;
                iconRect.origin.x = xOffset;
                xOffset += iconRect.size.width + kGapMax;
                titleRect.origin.x = xOffset;
            }
            titleRect.origin.y = (size.height - titleRect.size.height)*0.5;
            iconRect.origin.y = (size.height - iconRect.size.height)*0.5;
            break;
        case WXButton_Vertical:
            if(titleSize.height + iconSize.height + kGapMax > size.height){
                iconRect.origin.y = (size.height - iconRect.size.height)*0.5;
                titleRect.origin.y = (size.height - titleRect.size.height)*0.5;
            }else{
                CGFloat yOffset = (size.height - iconSize.height - titleSize.height - kGapMax)*0.5;
                iconRect.origin.y = yOffset;
                yOffset += iconRect.size.height + kGapMax;
                titleRect.origin.y = yOffset-3;
            }
            titleRect.origin.x = (size.width - titleRect.size.width)*0.5;
            iconRect.origin.x = (size.width - iconRect.size.width)*0.5;
            break;
        default:
            break;
    }
    [_iconImageView setFrame:iconRect];
    [_titleLabel setFrame:titleRect];
}
@end
