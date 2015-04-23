//
//  CSTWXNavigationView.m
//  CallTesting
//
//  Created by le ting on 4/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "CSTWXNavigationView.h"
#import "WXColorConfig.h"

#define kNavigationSideGap 10.0

@interface CSTWXNavigationView()
{
    WXUILabel *_titleLable;
}
@property (nonatomic,retain)UIView*_leftNavigationItem;
@property (nonatomic,retain)UIView *_rightNavigationItem;
@end

@implementation CSTWXNavigationView
@synthesize _leftNavigationItem,_rightNavigationItem,titleLable = _titleLable;

- (void)dealloc{
    RELEASE_SAFELY(_leftNavigationItem);
    RELEASE_SAFELY(_rightNavigationItem);
    RELEASE_SAFELY(_titleLable);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//		[self setBackgroundColor:kOtherColor(E_App_Other_Color_NavBar)];
        [self setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
        CGFloat width = 200;
        CGRect titleRect = CGRectMake((frame.size.width-width)*0.5, 0, width, frame.size.height);
        if(isIOS7){
            titleRect.origin.y += IPHONE_STATUS_BAR_HEIGHT;
            titleRect.size.height -= IPHONE_STATUS_BAR_HEIGHT;
        }
        _titleLable =[[WXUILabel alloc] initWithFrame:titleRect];
        [_titleLable setTextColor:[UIColor whiteColor]];
        [_titleLable setFont:[UIFont systemFontOfSize:18.0]];
        [_titleLable setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLable];
    }
    return self;
}

+ (id)cstWXNavigationView{
    CGRect rect = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, NAVIGATION_BAR_HEGITH);
    if(isIOS7){
        rect.size.height += IPHONE_STATUS_BAR_HEIGHT;
    }
    return [[self alloc] initWithFrame:rect] ;
}

- (void)setLeftNavigationItem:(UIView*)btn{
    if(self._leftNavigationItem){
        [self._leftNavigationItem removeFromSuperview];
    }
    self._leftNavigationItem = btn;
    if(btn){
        CGRect rect = btn.frame;
        if([btn isKindOfClass:[UIButton class]]){
            rect.size.width = (kDefaultNavigationBarButtonSize.height/rect.size.height)*rect.size.width;
            rect.size.height = kDefaultNavigationBarButtonSize.height;
        }else{
            rect.origin.x = kNavigationSideGap;
        }
        rect.origin.y = (self.frame.size.height - rect.size.height)*0.5;
        if(isIOS7){
            rect.origin.y += IPHONE_STATUS_BAR_HEIGHT*0.5;
        }
        [btn setFrame:rect];
        [self addSubview:btn];
    }
}

- (void)setRightNavigationItem:(UIView*)btn{
    if(self._rightNavigationItem){
        [self._rightNavigationItem removeFromSuperview];
    }
    if(btn){
		self._rightNavigationItem = btn;
        CGRect rect = btn.frame;
        if([btn isKindOfClass:[UIButton class]]){
            rect.size.width = (kDefaultNavigationBarButtonSize.height/rect.size.height)*rect.size.width;
            rect.size.height = kDefaultNavigationBarButtonSize.height;
            rect.origin.x = self.frame.size.width - rect.size.width;
        }else{
            rect.origin.x = self.frame.size.width - rect.size.width - kNavigationSideGap;
        }
        rect.origin.y = (self.frame.size.height - rect.size.height)*0.5;
        if(isIOS7){
            rect.origin.y += IPHONE_STATUS_BAR_HEIGHT*0.5;
        }
        [btn setFrame:rect];
        [self addSubview:btn];
	}else {
		[self._rightNavigationItem removeFromSuperview];
	}
}

- (void)setTitle:(NSString*)title{
    [_titleLable setText:title];
}

- (void)setTitleFont:(UIFont*)font{
    [_titleLable setFont:font];
}
- (void)setTitleColor:(UIColor*)color{
    [_titleLable setTextColor:color];
}

@end
