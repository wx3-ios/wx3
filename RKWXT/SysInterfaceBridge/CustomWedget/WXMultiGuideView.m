//
//  WXMultiGuideView.m
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXMultiGuideView.h"

@interface WXMultiGuideView()<UIScrollViewDelegate>
{
    WXUIScrollView  *_scrollView;
    WXUIPageControl *_pageControl;
}

@property (nonatomic,retain)NSArray *guideArray;
@end


@implementation WXMultiGuideView
@synthesize guideArray = _guideArray;
@synthesize delegate = _delegate;

- (void)dealloc{
    RELEASE_SAFELY(_pageControl);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_guideArray);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame guideArray:(NSArray*)guideArray{
    if(self = [super initWithFrame:frame]){
        [self setGuideArray:guideArray];
        
        CGSize size = frame.size;
        NSInteger pageCount = [guideArray count];
        _scrollView = [[WXUIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        [_scrollView setContentSize:CGSizeMake(size.width*pageCount + 10, size.height)];
        [self addSubview:_scrollView];
        
        CGFloat xOffset = 0;
        for(UIView *guideV in guideArray){
            CGSize guideVSize = guideV.frame.size;
            CGRect guideVRect = CGRectMake(xOffset+(size.width -guideVSize.width)*0.5, (size.height -guideVSize.height)*0.5, guideVSize.width, guideVSize.height);
            [guideV setFrame:guideVRect];
            [_scrollView addSubview:guideV];
            xOffset += size.width;
        }
        
        CGFloat pageControlHeight = 50.0;
        _pageControl = [[WXUIPageControl alloc] initWithFrame:CGRectMake(0, size.height - pageControlHeight, size.width, pageControlHeight)];
        [_pageControl setNumberOfPages:pageCount];
        [_pageControl setUserInteractionEnabled:NO];
        [self addSubview:_pageControl];
    }
    return self;
}

- (NSInteger)pageCount{
    return [_guideArray count];
}

#pragma mark UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat xOffset = scrollView.contentOffset.x;
    if(xOffset > _scrollView.bounds.size.width*([self pageCount]-1)){
        if(_delegate && [_delegate respondsToSelector:@selector(guideDidScrollToEnd)]){
            [_delegate guideDidScrollToEnd];
        }
        return;
    }
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((xOffset + pageWidth/2)/pageWidth);
    [_pageControl setCurrentPage:page];
}
@end
