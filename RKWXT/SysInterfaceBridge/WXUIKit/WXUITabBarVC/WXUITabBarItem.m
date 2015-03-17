//
//  WXUITabBarItem.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUITabBarItem.h"

@interface WXUITabBarItem()
{
    E_TabBarStatus _status;
}
@property (nonatomic,retain)NSString *selectedBarItemTitle;
@property (nonatomic,retain)UIColor *selectedBarItemTitleColor;
@property (nonatomic,retain)UIImage *selectedBarItemImage;
@property (nonatomic,retain)UIImage *selectedBarItemBgImage;
@end

@implementation WXUITabBarItem
@synthesize status = _status;

- (void)dealloc{
    RELEASE_SAFELY(_repeatSelectedTitle);
    RELEASE_SAFELY(_repeatSelectedTitleColor);
    RELEASE_SAFELY(_repeatSelectedImage);
    RELEASE_SAFELY(_repeatSelectedBgImage);
    RELEASE_SAFELY(_selectedBarItemTitle);
    RELEASE_SAFELY(_selectedBarItemTitleColor);
    RELEASE_SAFELY(_selectedBarItemImage);
    RELEASE_SAFELY(_selectedBarItemBgImage);
    [super dealloc];
}

+ (WXUITabBarItem*)tabBarItem{
    WXUITabBarItem *tabBarItem = [WXUITabBarItem buttonWithType:WXButton_Vertical];
    return tabBarItem;
}

- (void)setTabBarItemTitle:(NSString *)title forState:(WXButtonControlState)state{
    [self setTitle:title forState:state];
    if(state == WXButtonControlState_Selected){
        [self setSelectedBarItemTitle:title];
    }
}

- (void)setTabBarItemTitleColor:(UIColor *)color forState:(WXButtonControlState)state{
    [self setTitleColor:color forState:state];
    if(state == WXButtonControlState_Selected){
        [self setSelectedBarItemTitleColor:color];
    }
}
- (void)setTabBarItemImage:(UIImage *)image forState:(WXButtonControlState)state{
    [self setImage:image forState:state];
    if(state == WXButtonControlState_Selected){
        [self setSelectedBarItemImage:image];
    }
}
- (void)setTabBarItemBackgroundImage:(UIImage *)image forState:(WXButtonControlState)state{
    [self setBackgroundImage:image forState:state];
    if(state == WXButtonControlState_Selected){
        [self setSelectedBarItemBgImage:image];
    }
}

- (void)setSingleSelectedPram{
    //如果被重置了 则重置回来~
    if(_repeatSelectedTitle){
        [self setTitle:_selectedBarItemTitle forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedTitleColor){
        [self setTitleColor:_selectedBarItemTitleColor forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedImage){
        [self setImage:_selectedBarItemImage forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedBgImage){
        [self setBackgroundImage:_selectedBarItemBgImage forState:WXButtonControlState_Selected];
    }
}

- (void)setDoubleSelectedPram{
    if(_repeatSelectedTitle){
        [self setTitle:_repeatSelectedTitle forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedTitleColor){
        [self setTitleColor:_repeatSelectedTitleColor forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedImage){
        [self setImage:_repeatSelectedImage forState:WXButtonControlState_Selected];
    }
    if(_repeatSelectedBgImage){
        [self setBackgroundImage:_repeatSelectedBgImage forState:WXButtonControlState_Selected];
    }
}

- (void)setStatus:(E_TabBarStatus)status{
    _status = status;
    switch (status) {
        case E_TabBarStatus_Normal:
            [self setSingleSelectedPram];
            break;
        case E_TabBarStatus_SingleSelected:
            [self setSingleSelectedPram];
            break;
        case E_TabBarStatus_DoubleSelected:
            [self setDoubleSelectedPram];
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        if(_status == E_TabBarStatus_Normal){
            _status = E_TabBarStatus_SingleSelected;
        }
    }else{
        _status = E_TabBarStatus_Normal;
        [self setSingleSelectedPram];
    }
}

- (void)repeatClick{
    if(self.status == E_TabBarStatus_SingleSelected){
        [self setDoubleSelectedPram];
        [self setStatus:E_TabBarStatus_DoubleSelected];
    }else{
        [self setSingleSelectedPram];
        [self setStatus:E_TabBarStatus_SingleSelected];
    }
}

- (BOOL)UIShouldChangedWhenTouchDown{
    return NO;
}

@end
