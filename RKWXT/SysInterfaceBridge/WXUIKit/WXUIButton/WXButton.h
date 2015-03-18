//
//  WXButton.h
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIBaseButton.h"

typedef enum {
    //水平的，默认值
    WXButton_horizontal = 0,
    WXButton_Vertical,
}WXButtonType;

@interface WXButton : WXUIBaseButton
@property (nonatomic,readonly)WXUILabel *titleLabel;
@property (nonatomic,readonly)WXUIImageView *backgroundImageView;
@property (nonatomic,readonly)WXUIImageView *iconImageView;

@property (nonatomic,copy)NSString *normalTitle;
@property (nonatomic,copy)NSString *selectedTitle;
@property (nonatomic,copy)NSString *disableTitle;

- (void)setTitle:(NSString *)title forState:(WXButtonControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(WXButtonControlState)state;
- (void)setImage:(UIImage *)image forState:(WXButtonControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(WXButtonControlState)state;

- (void)setTitleSize:(CGFloat)titleSize;

+ (id)buttonWithType:(WXButtonType)type;
@end
