//
//  MerchantImageCell.m
//  Woxin2.0
//
//  Created by qq on 14-7-28.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXHomeTopGoodCell.h"
#import "WXRemotionImgBtn.h"
#import "CSTScrollBrowser.h"
#import "WXRemotionImgBtn.h"
#import "HomePageTopEntity.h"
#import "NewHomePageCommonDef.h"

#define kTimerInterval (5.0)
@interface WXHomeTopGoodCell ()<UIScrollViewDelegate,WXRemotionImgBtnDelegate>{
	CSTScrollBrowser *_browser;
	UIPageControl *_pageControl;
	
	NSMutableArray *_merchantImgViewArray;
	NSInteger _currentPage;
}
@property (nonatomic,retain) NSArray *subPageViews;

@end

@implementation WXHomeTopGoodCell

-(void)dealloc{
	_delegate = nil;
	RELEASE_SAFELY(_browser);
	RELEASE_SAFELY(_pageControl);
	RELEASE_SAFELY(_subPageViews);
	RELEASE_SAFELY(_merchantImgViewArray);
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGRect rect = [self bounds];
        rect.size.height = rect.size.width/3-yGap;
        _browser = [[CSTScrollBrowser alloc] initWithFrame:rect];
        [_browser setScrollDelegate:self];
        [_browser setGap:0.0];
        [self.contentView addSubview:_browser];
        
        CGFloat height = 20;
        CGFloat xOffset = 260;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(xOffset, rect.size.height - height, rect.size.width-xOffset, height)];
        [self.contentView addSubview:_pageControl];
        
        _merchantImgViewArray = [[NSMutableArray alloc] init];
        [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)toInit{
	[_merchantImgViewArray removeAllObjects];
	_currentPage = 0;
	[_pageControl setCurrentPage:0];
	[_browser scrollToPage:0 animated:NO];
}

-(void)load{
    NSArray *goodEntityArray = self.cellInfo;
    [self toInit];
    CGRect rect = [self bounds];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(HomePageTopEntity *topADVEntity in goodEntityArray){
        WXRemotionImgBtn *imgView = [[[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, rect.size.width/3-yGap)] autorelease];
        [imgView setCpxViewInfo:topADVEntity.topImg];
        [imgView load];
        [imgView setDelegate:self];
        [_merchantImgViewArray addObject:imgView];
    }
    [pool drain];
    
    [_browser setSubScrollViews:_merchantImgViewArray];
    [self setSubPageViews:_merchantImgViewArray];
    
    
    NSInteger pageCount = [_subPageViews count];
    if(pageCount){
        [_browser setPagingEnabled:YES];
        [_pageControl setNumberOfPages:pageCount];
        [_pageControl setHidden:NO];
    }else{
        [_pageControl setHidden:NO];
    }
    
    [_browser setPagingEnabled:pageCount > 1];
    [_pageControl setHidden:pageCount <= 1];
    [_pageControl setNumberOfPages:pageCount];
    [_browser reload];
}

- (void)autoScroll{
	NSInteger page = _pageControl.currentPage;
	page += 1;
	NSInteger count = [_subPageViews count];
	if (page >= count){
		page = 0;
	}
	[_browser scrollToPage:page animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	// 在滚动超过页面宽度的50%的时候，切换到新的页面
	int page = floor((scrollView.contentOffset.x + pageWidth/2)/pageWidth) ;
	[_pageControl setCurrentPage:page];
	if (_currentPage != page){
		NSInteger pageCount = [_merchantImgViewArray count];
		if (pageCount <= _currentPage){
			return;
		}
		WXRemotionImgBtn *imgView = (WXRemotionImgBtn*)[_merchantImgViewArray objectAtIndex:_currentPage];
		[imgView load];
	}
	_currentPage = page;
}

- (void)buttonImageClicked:(id)sender{
	WXRemotionImgBtn *btn = sender;
	NSInteger index = [_subPageViews indexOfObject:btn];
	if(index == NSNotFound){
		return;
	}
	if(_delegate && [_delegate respondsToSelector:@selector(clickTopGoodAtIndex:)]){
		[_delegate clickTopGoodAtIndex:index];
	}
}

@end
