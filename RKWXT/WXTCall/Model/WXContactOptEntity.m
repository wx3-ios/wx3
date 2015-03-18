//
//  WXContactOptEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContactOptEntity.h"

@implementation WXContactOptEntity

- (void)dealloc{
//    [super dealloc];
}

+ (WXContactOptEntity*)optEntityWithName:(NSString*)name icon:(UIImage*)icon numberRight:(NSInteger)numberRight{
    WXContactOptEntity *entity = [[WXContactOptEntity alloc] init] ;
    [entity setName:name];
    [entity setIcon:icon];
    [entity setNumberRight:numberRight];
    return entity;
}

- (NSString*)nameShow{
    return _name;
}

- (UIImage*)iconShow{
    return _icon;
}

- (E_ContactRightView)rightViewType{
    E_ContactRightView type = E_ContactRightView_None;
    if(_numberRight > 0){
        type = E_ContactRightView_HasNewFriend;
    }
    return type;
}

@end
