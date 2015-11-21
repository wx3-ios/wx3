//
//  HeardView.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HeardView.h"

#import "ToSnapUp.h"

@interface HeardView ()
@property (nonatomic,strong)HeardTopView *top;
@property (nonatomic,strong)HeardGoodsView *goods;
@end

@implementation HeardView


-(instancetype)initWithFrame:(CGRect)frame goodsArray:(NSArray*)goodsArray{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        HeardTopView *top = [[HeardTopView alloc]initWithFrame:CGRectMake(TopMargin, 0, self.width - (TopMargin * 2), T_Height)];
        [self addSubview:top];
        self.top = top;
        
        CGFloat widch = (self.width - ( TopMargin * 2 ) - (T_GoodsMaegin * 2) ) / goodsArray.count;
        CGFloat height = self.height  - self.top.height;
        
        
        for (int i = 0; i < goodsArray.count; i++) {
            HeardGoodsView *goods = [[HeardGoodsView alloc]init];
            CGFloat goodsX = TopMargin + (T_GoodsMaegin + widch) * i;
            goods.frame = CGRectMake(goodsX, self.top.height, widch, height);
            goods.data = goodsArray[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTouch)];
            [goods addGestureRecognizer:tap];
            [self addSubview:goods];
            self.goods = goods;
        }
        
        
        
        
    }
    return self;
}

//传递数据
- (void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;
   

}

- (void)clickTouch{
    if ([self.delegate respondsToSelector:@selector(heardViewTouch:)]) {
        [self.delegate heardViewTouch:self];
    }
}


@end
