//
//  WXUITabBar.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

//
//  WXUITabBar.m
//  WXServer
//
//  Created by le ting on 7/19/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUITabBar.h"

#define kInvalidSelectedIndex (-1)

@interface WXUITabBar()
{
    NSMutableArray *_tabBarItemArray;
    NSInteger _selectedIndex;
}
@end

@implementation WXUITabBar
@synthesize tabBarItemArray = _tabBarItemArray;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tabBarItemArray = [[NSMutableArray alloc] init];
        _selectedIndex = kInvalidSelectedIndex;
    }
    return self;
}

- (id)initWithTabBarHeight:(CGFloat)height{
    if(self = [self initWithFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT-height, IPHONE_SCREEN_WIDTH, height)]){
    }
    return self;
}

- (id)init{
    if(self = [self initWithTabBarHeight:TAB_NAVIGATION_BAR_HEGITH]){
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    if(_selectedIndex == kInvalidSelectedIndex){
        _selectedIndex = 0;
    }
    [self drawSelectedAtIndex:_selectedIndex];
}

- (void)setTabBarItems:(NSArray*)tabBarItems{
    NSInteger count = [tabBarItems count];
    NSAssert(count > 1, @"tabbar items 至少要有两个");
    
    CGSize size = self.bounds.size;
    CGFloat xOffset = 0.0;
    for(UIView *subView in _tabBarItemArray){
        [subView removeFromSuperview];
    }
    [_tabBarItemArray removeAllObjects];
    
    for(WXUITabBarItem *tabBarItem in tabBarItems){
        NSAssert([tabBarItem isKindOfClass:[WXUITabBarItem class]], @"is not a WXUITabBarItem");
        CGSize itemSize = tabBarItem.bounds.size;
        CGRect rect = CGRectMake(xOffset, (size.height - itemSize.height)*0.5, itemSize.width, itemSize.height);
        [tabBarItem setFrame:rect];
        [self addSubview:tabBarItem];
        xOffset += itemSize.width;
        
        [tabBarItem addtarget:self action:@selector(tabBarItemClicked:) forControlEvent:UITouchControl_UpInside];
    }
    [_tabBarItemArray addObjectsFromArray:tabBarItems];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self setNeedsDisplay];
}

- (void)drawSelectedAtIndex:(NSInteger)index{
    if(index == kInvalidSelectedIndex){
        index = 0;
    }
    NSInteger count = [_tabBarItemArray count];
    for(NSInteger i = 0; i < count; i++){
        WXUITabBarItem *item = [_tabBarItemArray objectAtIndex:i];
        if(i == index){
            [item setSelected:YES];
        }else{
            [item setSelected:NO];
        }
    }
}

- (void)tabBarItemClicked:(id)sender{
    NSInteger index = [_tabBarItemArray indexOfObject:sender];
    if(index == NSNotFound){
        KFLog_Normal(YES, @"selected invalid tabBarItem");
        return;
    }
    if(index == _selectedIndex){
        if(_delegate && [_delegate respondsToSelector:@selector(repeatSelectedAtIndex:)]){
            WXUITabBarItem *item = sender;
            [item repeatClick];
            [_delegate repeatSelectedAtIndex:index];
        }
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(selectedAtIndex:)]){
            [_delegate selectedAtIndex:index];
        }
    }
    _selectedIndex = index;
    [self drawSelectedAtIndex:_selectedIndex];
}
@end
