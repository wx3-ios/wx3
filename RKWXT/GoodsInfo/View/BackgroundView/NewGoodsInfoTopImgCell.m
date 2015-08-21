//
//  NewGoodsInfoTopImgCell.m
//  RKWXT
//
//  Created by SHB on 15/8/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoTopImgCell.h"
#import "WXRemotionImgBtn.h"
#import "CSTScrollBrowser.h"

@interface NewGoodsInfoTopImgCell()<UIScrollViewDelegate,WXRemotionImgBtnDelegate>{
    CSTScrollBrowser *_browser;
    UIPageControl *_pageControl;
}
@property (nonatomic,retain) NSArray *subPageViews;
@end

@implementation NewGoodsInfoTopImgCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier imgNameArray:(NSArray *)imgNameArray{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor blackColor]];
        _browser = [[CSTScrollBrowser alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH)];
        [_browser setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [_browser setScrollDelegate:self];
        [_browser setSubScrollViews:imgNameArray];
        [_browser setAlpha:1.0];
        [self setSubPageViews:imgNameArray];
        [self.contentView addSubview:_browser];
        
        CGFloat yOffset = _browser.frame.origin.y+_browser.frame.size.height+30;
        CGFloat height = 20;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, height)];
        [self.contentView addSubview:_pageControl];
        
        for(WXRemotionImgBtn *btn in imgNameArray){
            [btn setDelegate:self];
        }
    }
    return self;
}

-(void)load{
    NSInteger pageCount = [_subPageViews count];
    if(pageCount){
        [_browser setPagingEnabled:YES];
        [_pageControl setNumberOfPages:pageCount];
        [_pageControl setHidden:NO];
    }else{
        [_pageControl setHidden:YES];
    }
    
    for(WXRemotionImgBtn *imgView in _subPageViews){
        [imgView load];
    }
    
    [_browser setPagingEnabled:pageCount > 1];
    [_pageControl setHidden:pageCount <= 1];
    [_pageControl setNumberOfPages:pageCount];
    [_browser reload];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x + pageWidth/2)/pageWidth);
    [_pageControl setCurrentPage:page];
}

- (void)buttonImageClicked:(id)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(clickTopImgView)]){
        [_delegate clickTopImgView];
    }
}

@end
