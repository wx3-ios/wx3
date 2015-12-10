//
//  ShopUnionClassifyCell.m
//  RKWXT
//
//  Created by SHB on 15/11/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopUnionClassifyCell.h"
#import "WXShopUnionDef.h"
#import "ShopUnionClassifyEntity.h"

#define kTimerInterval (5.0)
#define kOneCellShowNumber (5)
@interface ShopUnionClassifyCell ()<UIScrollViewDelegate>{
    UIScrollView *_browser;
    UIPageControl *_pageControl;
    NSInteger _currentPage;
    
    NSArray *classifyArr;
    WXUIView *baseView;
    
    NSMutableArray *_merchantImgViewArray;
}
@end

@implementation ShopUnionClassifyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGRect rect = [self bounds];
        rect.size.height = ShopUnionClassifyRowHeight;
        _browser = [[UIScrollView alloc] initWithFrame:rect];
        [_browser setDelegate:self];
        [_browser setShowsHorizontalScrollIndicator:NO];
        [self.contentView addSubview:_browser];
        
        baseView = [[WXUIView alloc] init];
        baseView.frame = CGRectMake(0, 0, Size.width, ShopUnionClassifyRowHeight);
        [baseView setBackgroundColor:WXColorWithInteger(0xffffff)];
        [_browser addSubview:baseView];
        
        
        CGFloat height = 20;
        CGFloat pageControlWidth = 60;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((rect.size.width-pageControlWidth)/2, rect.size.height - height, pageControlWidth, height)];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self.contentView addSubview:_pageControl];
        
        _merchantImgViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)toInit{
    [_merchantImgViewArray removeAllObjects];
    _currentPage = 0;
    [_pageControl setCurrentPage:0];
    [_browser scrollsToTop];
}

-(void)load{
    [_merchantImgViewArray removeAllObjects];
    [self toInit];
    
    classifyArr = self.cellInfo;
    
    //leftView
    CGRect rect = [self bounds];
    CGFloat btnWidth = rect.size.width/5;
    CGFloat btnHeight = ShopUnionClassifyRowHeight/2;
    CGFloat yGap = 18;
    NSInteger count = 0;
    for(NSInteger j = 0; j < ([classifyArr count]/kOneCellShowNumber+([classifyArr count]%5>0?1:0)); j++){
        for(NSInteger i = 0; i < kOneCellShowNumber; i++){
            if(count > [classifyArr count]-1){
                break;
            }
            ShopUnionClassifyEntity *entity = [classifyArr objectAtIndex:count];
            
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [commonBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
            [commonBtn setBackgroundImageOfColor:[UIColor colorWithRed:0.951 green:0.886 blue:0.793 alpha:1.000] controlState:UIControlStateHighlighted];
            commonBtn.frame = CGRectMake((count%5*btnWidth)+(count/(2*kOneCellShowNumber)*Size.width), j%2*(btnHeight), btnWidth, btnHeight);
            [commonBtn setImage:[UIImage imageNamed:entity.industryImg] forState:UIControlStateNormal];
            [commonBtn setTitle:entity.industryName forState:UIControlStateNormal];
            [commonBtn setTitleColor:WXColorWithInteger(0x969696) forState:UIControlStateNormal];
            [commonBtn.titleLabel setFont:WXFont(10.0)];
            commonBtn.tag = entity.industryID;
            [commonBtn addTarget:self action:@selector(buttonImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:commonBtn];
            [_merchantImgViewArray addObject:_browser];
            
            CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
            CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
            CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
            CGPoint startImageViewCenter = commonBtn.imageView.center;
            CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
            CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
            CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            commonBtn.imageEdgeInsets = UIEdgeInsetsMake((j%2==1?(yGap-15):yGap), imageEdgeInsetsLeft, (j%2==1?40:25), imageEdgeInsetsRight);
            CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
            CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
            commonBtn.titleEdgeInsets = UIEdgeInsetsMake(btnHeight-(j%2==1?40:25), titleEdgeInsetsLeft-8, (j%2==1?25:10), titleEdgeInsetsRight-8);
            
            count++;
        }
    }
    
    NSInteger pageCount = [_merchantImgViewArray count]/10+([_merchantImgViewArray count]%10>0?1:0);
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
    [self reload];
}

-(void)reload{
    CGFloat xOffset = 0;
    CGFloat contentWidth = 0;
    NSInteger pageCount = [_merchantImgViewArray count]/10+([_merchantImgViewArray count]%10>0?1:0);
    if(pageCount>1){
        xOffset += Size.width;
        contentWidth = Size.width*pageCount;
    }
    
    //设置contentSize
    if(xOffset>0){
        CGFloat width = CGRectGetWidth(self.bounds);
        contentWidth = pageCount * width;
    }
    [_browser setContentSize:CGSizeMake(contentWidth, ShopUnionClassifyRowHeight)];
    baseView.frame = CGRectMake(0, 0, contentWidth, ShopUnionClassifyRowHeight);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((scrollView.contentOffset.x + pageWidth/2)/pageWidth);
    [_pageControl setCurrentPage:page];
    if (_currentPage != page){
        NSInteger pageCount = [_merchantImgViewArray count]/10+([_merchantImgViewArray count]%10>0?1:0);
        if (pageCount <= _currentPage){
            return;
        }
    }
    _currentPage = page;
}

- (void)buttonImageClicked:(id)sender{
    WXUIButton *btn = sender;
    if(_delegate && [_delegate respondsToSelector:@selector(clickClassifyBtnAtIndex:)]){
        [_delegate clickClassifyBtnAtIndex:btn.tag];
    }
}

@end
