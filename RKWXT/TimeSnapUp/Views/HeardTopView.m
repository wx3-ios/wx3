//
//  HeardTopView.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HeardTopView.h"
#import "ToSnapUp.h"

@interface HeardTopView ()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *hourLabel;
@property (nonatomic,strong)UILabel *mainuteLabel;
@property (nonatomic,strong)UILabel *secodeLabel;
@end

@implementation HeardTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat widch = self.frame.size.width / 2 ;
        CGFloat heifht = self.frame.size.height;
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, widch, heifht)];
        titlelabel.font = [UIFont systemFontOfSize:15];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        titlelabel.text = @"提前抢";
        
        [self addSubview:titlelabel];
        
    }
    return self;
}




@end
