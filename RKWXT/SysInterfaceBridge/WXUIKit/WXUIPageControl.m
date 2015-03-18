//
//  WXUIPageControl.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIPageControl.h"

@interface WXUIPageControl()
{
    UIImage *_activeImage;
    UIImage *_inactiveImage;
}
@end

@implementation WXUIPageControl

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _inactiveImage = [UIImage imagePathed:@"uiPageControlNormal.png"];
        _activeImage = [UIImage imagePathed:@"uiPageControlSelect.png"] ;
    }
    return self;
}

- (void)updateDots
{
    NSInteger count = [self.subviews count];
    for(int i = 0; i< count; i++) {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        if([dotView isKindOfClass:[UIImageView class]]){
            dot = (UIImageView*)dotView;
        }else{
            for (UIView* subview in dotView.subviews)
            {
                if ([subview isKindOfClass:[UIImageView class]])
                {
                    dot = (UIImageView*)subview;
                    break;
                }
            }
        }
        
        if(!dot){
            dot = [[UIImageView alloc] initWithFrame:dotView.bounds] ;
            [dotView addSubview:dot];
            
        }
        
        if(i == self.currentPage){
            dot.image= _activeImage;
        }
        else{
            dot.image= _inactiveImage;
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
