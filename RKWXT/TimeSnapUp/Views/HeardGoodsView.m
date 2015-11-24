//
//  HeardGoodsView.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HeardGoodsView.h"
#import "TimeShopData.h"
#import "ToSnapUp.h"

#define priceH (45)

@interface HeardGoodsView ()
@property (nonatomic,strong)WXRemotionImgBtn *iconimage;
@property (nonatomic,strong)UILabel *orgina_price;
@property (nonatomic,strong)UILabel *buying_price;




@property (nonatomic,strong)UIView *drawview;
@end

@implementation HeardGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        WXRemotionImgBtn *iconimage = [[WXRemotionImgBtn alloc]init];
        [self addSubview:iconimage];
        self.iconimage = iconimage;
        
        UILabel *buying_price = [[UILabel alloc]init];
        buying_price.font = [UIFont systemFontOfSize:14];
        buying_price.textAlignment = NSTextAlignmentCenter;
        buying_price.textColor = [UIColor colorWithHexString:@"#dd2726"];
        [self addSubview:buying_price];
        self.buying_price = buying_price;
        
        UILabel *orgina_price = [[UILabel alloc]init];
        orgina_price.font = [UIFont systemFontOfSize:10];
        orgina_price.textAlignment = NSTextAlignmentCenter;
        orgina_price.textColor = [UIColor colorWithHexString:@"#909090"];
        [self addSubview:orgina_price];
        self.orgina_price = orgina_price;
        
        UIView *drawview = [[UIView alloc]init];
        drawview.backgroundColor = [UIColor colorWithHexString:@"#909091"];
        [self.orgina_price addSubview:drawview];
         self.drawview = drawview;
       
        //即将开始
        UIImageView *beg_image = [[UIImageView alloc]init];
        beg_image.hidden = self.isImageHidden == YES;
        [self.iconimage addSubview:beg_image];
        self.beg_image = beg_image;

        UILabel *beg_time = [[UILabel alloc]init];
        beg_time.textAlignment = NSTextAlignmentCenter;
        beg_time.textColor = [UIColor whiteColor];
        beg_time.font = [UIFont systemFontOfSize:10];
        [self.beg_image addSubview:beg_time];
        self.beg_time = beg_time;
        
        UILabel *beg_open = [[UILabel alloc]init];
        beg_open.textAlignment = NSTextAlignmentCenter;
        beg_open.textColor = [UIColor whiteColor];
        beg_open.font = [UIFont systemFontOfSize:10];
        [self.beg_image addSubview:beg_open];
        self.beg_open = beg_open;
        
        //开始
        UILabel *timeDown = [[UILabel alloc]init];
        timeDown.backgroundColor = [UIColor grayColor];
        timeDown.textColor = [UIColor whiteColor];
        timeDown.font = [UIFont systemFontOfSize:12];
        timeDown.hidden = self.isDownHidden == NO;
        [self.iconimage addSubview:timeDown];
        self.timeDown =  timeDown;
        
        //结束
        UIImageView *over_image = [[UIImageView alloc]init];
        over_image.hidden = self.isOver_Image_Hidden == NO;
        [self.iconimage addSubview:over_image];
        self.over_image = over_image;
        
        UILabel *over_label = [[UILabel alloc]init];
        over_label.textAlignment = NSTextAlignmentCenter;
        over_label.textColor = [UIColor whiteColor];
        over_label.font = [UIFont systemFontOfSize:15];
        [self.over_image addSubview:over_label];
        self.over_label = over_label;
        
        
        
        
        
    }
    return self;
}





- (void)setData:(TimeShopData *)data{
    _data = data;
    
    
    
    self.beg_image.hidden = data.isImageHidden;
    self.timeDown.hidden = data.isDownHidden;
    self.over_image.hidden = data.isEnd_Image_Hidden;
    [self setContentView];
    [self setConuntViewFrame];
    
  
    
}


- (void)setContentView{
    
    [self.iconimage setCpxViewInfo:self.data.add_goods_home_img];
    [self.iconimage load];
    
    self.orgina_price.text = [NSString stringWithFormat:@"￥%@",self.data.goods_price];
    self.buying_price.text = [NSString stringWithFormat:@"￥%@",self.data.scare_buying_price];
    
    
      //即将开始
    NSDate *beg_date = [NSDate dateWithTimeIntervalSince1970:[self.data.begin_time longLongValue]];
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"HH:mm"];
    NSString *str = [matter stringFromDate:beg_date];
    
    UIImage *image = [UIImage imageNamed:@"beg_time"];
    self.beg_image.image = image;
    self.beg_time.text = str;
    self.beg_open.text = @" 即将开抢";
    
    //开始
    self.timeDown.text = self.data.top_time_countdown;
    
     //结束
    UIImage *end_image = [UIImage imageNamed:@"end"];
    self.over_image.image = end_image;
    self.over_label.text = @"已抢光";
   
    
}

- (void)setConuntViewFrame{
    CGFloat imageW = self.width;
    CGFloat imageH = imageW;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    self.iconimage.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat buyingW = self.width;
    CGFloat buyingH = priceH/2;
    CGFloat buyingX = 0;
    CGFloat buyingY = self.iconimage.bottom;
    self.buying_price.frame = CGRectMake(buyingX, buyingY, buyingW, buyingH);
    
    CGFloat oringW = self.width;
    CGFloat oringH = priceH/2;
    CGFloat oringX = 0;
    CGFloat oringY = self.buying_price.bottom;
    self.orgina_price.frame = CGRectMake(oringX, oringY, oringW, oringH);
    
    CGSize size = [NSString sizeWithString:self.buying_price.text font:[UIFont systemFontOfSize:10]];
    CGFloat maskW = size.width;
    CGFloat maskH = 0.5;
    CGFloat maskX = (self.width - size.width) / 2;
    CGFloat maskY = buyingH /2;
    self.drawview.frame = CGRectMake(maskX, maskY, maskW, maskH);

    
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    //即将开始
    CGFloat begW = imageW / 2;
    CGFloat begH = imageH - 60;
    self.beg_image.frame = CGRectMake(timeX, timeY, begW, begH);
    
    CGFloat beg_timeW = begW;
    CGFloat beg_timeH = begH / 3;
    self.beg_time.frame = CGRectMake(timeX, timeY, beg_timeW, beg_timeH);
    
    CGFloat beg_LY = beg_timeH;
    CGSize size_beg = [NSString sizeWithString:self.beg_open.text font:[UIFont systemFontOfSize:10]];
    self.beg_open.frame = (CGRect){{timeX,beg_LY},size_beg};
    
    //开始
    CGSize sizeT = [NSString sizeWithString:self.timeDown.text font:[UIFont systemFontOfSize:12]];
    self.timeDown.frame = (CGRect){{0,0},sizeT};
    
    //结束
    CGFloat overX = 5;
    CGFloat overY = 5;
    CGFloat overW = imageW - overX * 2;
    CGFloat overH = imageH - overY * 2;
    self.over_image.frame = CGRectMake(overX, overY, overW, overH);
    CGSize over = [NSString sizeWithString:self.over_label.text font:[UIFont systemFontOfSize:15]];
    CGFloat overLX = ( overW - over.width ) / 2;
    CGFloat overLY = ( overH - over.height ) / 2;
    self.over_label.frame = (CGRect){{overLX,overLY},over};
    
    }


@end
