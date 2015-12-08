//
//  ShopUnionClassifyCell.m
//  RKWXT
//
//  Created by SHB on 15/11/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopUnionClassifyCell.h"
#import "ShopUnionScrollView.h"
#import "WXShopUnionDef.h"
#import "ShopUnionClassifyEntity.h"

#define kTimerInterval (5.0)
#define kOneCellShowNumber (5)
@interface ShopUnionClassifyCell ()<UIScrollViewDelegate>{
    UIScrollView *_browser;
    UIPageControl *_pageControl;
    NSInteger _currentPage;
    
//    NSArray *classifyNameArr;
    NSArray *classifyArr;
    
    WXUIView *leftView;
    WXUIView *rightView;
    
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
        
        leftView = [[WXUIView alloc] init];
        leftView.frame = CGRectMake(0, 0, Size.width, ShopUnionClassifyRowHeight);
        [leftView setBackgroundColor:WXColorWithInteger(0xffffff)];
        [_browser addSubview:leftView];
        
        rightView = [[WXUIView alloc] init];
        rightView.frame = CGRectMake(Size.width, 0, Size.width, ShopUnionClassifyRowHeight);
        [rightView setBackgroundColor:WXColorWithInteger(0xffffff)];
        [_browser addSubview:rightView];
        
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

-(void)initClassifyImg{
//    classifyNameArr = @[@"热门", @"服装", @"美食茶酒", @"家具建材", @"生活服务", @"美容护肤", @"医房药品", @"汽车配件", @"灯饰照明", @"其他", @"更多", @"更多1", @"更多2", @"更多3", @"生活服务", @"美容护肤", @"更多4", @"汽车配件", @"灯饰照明", @"更多5"];
//    classifyImgArr = @[@"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png", @"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png", @"ShopUnionFoodImg.png", @"ShopUnionHotImg.png", @"ShopUnionDressImg.png"];
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
    CGFloat yOffset = 0;
    CGFloat xOffset = 0;
    CGFloat yGap = 18;
    for(NSInteger j = 0; j < 2; j++){
        for(NSInteger i = 0; i < kOneCellShowNumber; i++){
            ShopUnionClassifyEntity *entity = [classifyArr objectAtIndex:i+(j==1?kOneCellShowNumber:0)];
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [commonBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
            [commonBtn setBackgroundImageOfColor:[UIColor colorWithRed:0.951 green:0.886 blue:0.793 alpha:1.000] controlState:UIControlStateHighlighted];
            commonBtn.frame = CGRectMake(xOffset+i*(btnWidth+xOffset), yOffset+j*(yOffset+btnHeight), btnWidth, btnHeight);
            [commonBtn setImage:[UIImage imageNamed:entity.industryImg] forState:UIControlStateNormal];
            [commonBtn setTitle:entity.industryName forState:UIControlStateNormal];
            [commonBtn setTitleColor:WXColorWithInteger(0x969696) forState:UIControlStateNormal];
            [commonBtn.titleLabel setFont:WXFont(10.0)];
            commonBtn.tag = entity.industryID;
            [commonBtn addTarget:self action:@selector(buttonImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            [leftView addSubview:commonBtn];
            [_merchantImgViewArray addObject:_browser];
            
            CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
            CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
            CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
            CGPoint startImageViewCenter = commonBtn.imageView.center;
            CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
            CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
            CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            commonBtn.imageEdgeInsets = UIEdgeInsetsMake((j==1?(yGap-15):yGap), imageEdgeInsetsLeft, (j==1?40:25), imageEdgeInsetsRight);
            CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
            CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
            commonBtn.titleEdgeInsets = UIEdgeInsetsMake(btnHeight-(j==1?40:25), titleEdgeInsetsLeft-8, (j==1?25:10), titleEdgeInsetsRight-8);
        }
    }
    
    //rightView
    if([classifyArr count] > 10){
        for(int j = 0; j < 2; j++){
            for(int i = 0; i < kOneCellShowNumber; i++){
                if(10+(j==1?i+1+5:i+1) > [classifyArr count]){
                    break;
                }
                ShopUnionClassifyEntity *entity = [classifyArr objectAtIndex:i+(j==1?kOneCellShowNumber:0)+10];
                WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
                [commonBtn setBackgroundColor:WXColorWithInteger(0xffffff)];
                [commonBtn setBackgroundImageOfColor:[UIColor colorWithRed:0.951 green:0.886 blue:0.793 alpha:1.000] controlState:UIControlStateHighlighted];
                commonBtn.frame = CGRectMake(xOffset+i*(btnWidth+xOffset), yOffset+j*(yOffset+btnHeight), btnWidth, btnHeight);
                [commonBtn setImage:[UIImage imageNamed:entity.industryImg] forState:UIControlStateNormal];
                [commonBtn setTitle:entity.industryName forState:UIControlStateNormal];
                [commonBtn setTitleColor:WXColorWithInteger(0x969696) forState:UIControlStateNormal];
                [commonBtn.titleLabel setFont:WXFont(10.0)];
                commonBtn.tag = entity.industryID;
                [commonBtn addTarget:self action:@selector(buttonImageClicked:) forControlEvents:UIControlEventTouchUpInside];
                [rightView addSubview:commonBtn];
                [_merchantImgViewArray addObject:_browser];
                
                CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
                CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
                CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
                CGPoint startImageViewCenter = commonBtn.imageView.center;
                CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
                CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
                CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
                commonBtn.imageEdgeInsets = UIEdgeInsetsMake((j==1?(yGap-15):yGap), imageEdgeInsetsLeft, (j==1?40:25), imageEdgeInsetsRight);
                CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
                CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
                commonBtn.titleEdgeInsets = UIEdgeInsetsMake(btnHeight-(j==1?40:25), titleEdgeInsetsLeft-8, (j==1?25:10), titleEdgeInsetsRight-8);
            }
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
    if([_merchantImgViewArray count] > 10){
        xOffset += Size.width;
        contentWidth = Size.width*2;
    }
    
    //设置contentSize
    if(xOffset>0){
        CGFloat width = CGRectGetWidth(self.bounds);
        contentWidth = 2 * width;
    }
    [_browser setContentSize:CGSizeMake(contentWidth, ShopUnionClassifyRowHeight)];
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
