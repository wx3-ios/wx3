//
//  ShopUnionScrollView.m
//  RKWXT
//
//  Created by SHB on 15/11/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopUnionScrollView.h"
#import "math.h"

@interface ShopUnionScrollView (){
    UIScrollView *_scrollView;
    CGFloat _gap;
    NSArray *_subScrollViews;
    BOOL _pagingEnabled;
}
@end

@implementation ShopUnionScrollView
@synthesize dataSource = _dataSource;
@synthesize scrollDelegate = _scrollDelegate;
@synthesize gap = _gap;
@synthesize subScrollViews = _subScrollViews;
@synthesize pagingEnabled = _pagingEnabled;


-(id)init{
    if(self = [super init]){
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect bounds = self.bounds;
        _scrollView = [[UIScrollView alloc] initWithFrame:bounds];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_scrollView setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated{
    CGSize size = _scrollView.frame.size;
    [_scrollView setContentOffset:CGPointMake(page*size.width, 0) animated:animated];
}

-(void)setScrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate{
    [_scrollView setDelegate:scrollDelegate];
}

-(void)setGap:(CGFloat)gap{
    _gap = gap;
}

-(void)setPagingEnabled:(BOOL)pagingEnabled{
    _pagingEnabled = pagingEnabled;
    [_scrollView setPagingEnabled:pagingEnabled];
}

-(void)setSubScrollViews:(NSArray *)subScrollViews{
    NSArray *subViews = [_scrollView subviews];
    for(UIView *subView in subViews){
        [subView removeFromSuperview];
    }
    _subScrollViews = subScrollViews;
    for(UIView *subView in _subScrollViews){
        [_scrollView addSubview:subView];
    }
}

-(NSInteger)numberOfPage{
    if(_dataSource && [_dataSource respondsToSelector:@selector(numberOfPage)]){
        return [_dataSource numberOfPage];
    }else{
        return [_subScrollViews count];
    }
}

-(void)reload{
    CGFloat xOffset = 0;
    for(UIView *subView in _subScrollViews){
        CGRect rect = [subView frame];
        rect.origin.x = xOffset;
        rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect))*0.5;
        [subView setFrame:rect];
        
        xOffset += CGRectGetWidth(rect);
        xOffset += _gap;
    }
    UIView *lastSubView = [_subScrollViews lastObject];
    CGRect lastSubViewRect = lastSubView.frame;
    CGFloat contentWidth = lastSubViewRect.origin.x + lastSubViewRect.size.width;
    
    //设置contentSize
    if(_pagingEnabled){
        CGFloat width = CGRectGetWidth(self.bounds);
        NSInteger page = [self numberOfPage];
        contentWidth = page * width;
    }
    [_scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.bounds))];
}

- (void)removeAllSubView{
    for(UIView *subView in _subScrollViews){
        [subView removeFromSuperview];
    }
    [self setSubScrollViews:nil];
}

@end
