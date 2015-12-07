//
//  StoreHeardView.m
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "StoreHeardView.h"
#import "UIViewAdditions.h"
#import "UIColor+XBCategory.h"

#define phoneW  50


@interface StoreHeardView ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollew;
@property (nonatomic,strong)UIImageView *carousel;
@property (nonatomic,strong)UIView *storeInfo;
@property (nonatomic,strong)UILabel *indexL;
@property (nonatomic,strong)UIPageControl *page;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation StoreHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        _scrollew = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollew.delegate = self;
        [self addSubview:_scrollew];
        
        CGFloat imageW = _scrollew.width;
        CGFloat imageH = 120;
        for (int i  = 0; i < 3; i++) {
            UIImageView *carousel = [[UIImageView alloc]init];
            int row = i * imageW;
            carousel.backgroundColor = [UIColor orangeColor];
            carousel.frame = CGRectMake(row, 0, imageW, imageH);
            carousel.userInteractionEnabled = YES;
            [_scrollew addSubview:carousel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTouch:)];
            [carousel addGestureRecognizer:tap];
            tap.view.tag = i;
            
            
            
            UIView *storeInfo = [[UIView alloc]init];
            storeInfo.backgroundColor = [UIColor grayColor];
            storeInfo.frame = CGRectMake(row, imageH, imageW, 80);
            [_scrollew addSubview:storeInfo];
            self.storeInfo = storeInfo;
            
            UILabel *name = [[UILabel alloc]initWithFrame:(CGRect){{10,10},{200,30}}];
            name.backgroundColor = [UIColor blackColor];
            name.font = [UIFont systemFontOfSize:15];
            [storeInfo addSubview:name];
            
            UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(10, name.bottom + 5, self.width - phoneW - 5, 25)];
            info.backgroundColor = [UIColor blueColor];
            info.font = [UIFont systemFontOfSize:14];
            info.numberOfLines = 2;
            info.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
            [storeInfo addSubview:info];
            
            UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 30 - 10,20, 30, 30)];
            UIImage *image = [UIImage imageNamed:@"phone"];
            phoneBtn.backgroundColor = [UIColor orangeColor];
            [phoneBtn setBackgroundImage:image forState:UIControlStateNormal];
            [phoneBtn addTarget:self action:@selector(clickPhontBtn) forControlEvents:UIControlEventTouchDown];
            [storeInfo addSubview:phoneBtn];
            
            UIImage *divider = [UIImage imageNamed:@"divider"];
            UIImageView *dividerImage = [[UIImageView alloc]initWithFrame:CGRectMake(info.right + 1,20, 1, 40)];
            dividerImage.image = divider;
            [storeInfo addSubview:dividerImage];
            
            
        }
        
        
        _scrollew.contentSize = CGSizeMake(self.width * 3, 0);
        _scrollew.pagingEnabled = YES;
        _scrollew.showsHorizontalScrollIndicator = NO;
        _scrollew.bounces = NO;
        
        UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(10, 10, 320, 10)];
        [self addSubview:page];
        page.hidden = YES;
        page.numberOfPages = 3;
        self.page = page;
        
        UIImage *bg = [UIImage imageNamed:@"bg"];
        CGFloat backgW = 30;
        CGFloat backgH = 30;
        UIImageView *backG = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - backgW - 10, imageH - backgH - 10, backgW, backgH)];
        backG.userInteractionEnabled = YES;
        backG.image = bg;
        [self addSubview:backG];
        
        UILabel *label = [[UILabel alloc]initWithFrame:backG.bounds];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text =[NSString stringWithFormat:@"1/%d",self.page.numberOfPages];
        [backG addSubview:label];
        self.indexL = label;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(photoTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    return self;
}

- (void)photoTimer{
    int index = self.page.currentPage;
    if (index >= self.page.numberOfPages - 1) {
        index = 0;
    }else{
        index++;
    }
    self.page.currentPage = index;
    self.scrollew.contentOffset = CGPointMake(self.page.currentPage * self.scrollew.width , 0);
    

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewW =  scrollView.frame.size.width;
         CGFloat x = scrollView.contentOffset.x;
         int page = (x + scrollviewW / 2) /  scrollviewW;
         self.page.currentPage = page;
    self.indexL.text = [NSString stringWithFormat:@"%d/%d",page + 1,self.page.numberOfPages];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(photoTimer) userInfo:nil repeats:YES];
   
}

- (void)clickPhontBtn{
    if (_delegate && [_delegate respondsToSelector:@selector(storeHeardViewWihthPhone:)]) {
        [self.delegate storeHeardViewWihthPhone:self];
    }
}

- (void)clickTouch:(UITapGestureRecognizer*)tap{
    NSLog(@">>>>>>>>>");
    if (_delegate && [_delegate respondsToSelector:@selector(storeHeardView:index:)]) {
        [self.delegate storeHeardView:self index:tap.view.tag];
    }
}

@end
