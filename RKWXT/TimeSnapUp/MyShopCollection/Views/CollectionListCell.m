//
//  CollectionListCell.m
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CollectionListCell.h"
#import "GoodsListInfo.h"
#import "WXRemotionImgBtn.h"
#import "UIColor+XBCategory.h"
#import "NSString+XBCategory.h"
#import "UIViewAdditions.h"

#define leftMargin (10)
#define topMargin (20)
#define  nameTopMargin (18)
#define spacing (7.5)

#define nameFont  [UIFont systemFontOfSize:14]

@interface CollectionListCell ()
@property (nonatomic,strong)WXRemotionImgBtn *iconImage;
@property (nonatomic,strong)UIImageView *timeLimit;
@property (nonatomic,strong)UILabel *goodsName;
@property (nonatomic,strong)UILabel *price;
@end


@implementation CollectionListCell
+ (instancetype)collectionCreatCell:(UITableView*)tableview{
    static NSString *cellName = @"GoodsLiset";
    CollectionListCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[CollectionListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        
        WXRemotionImgBtn *iconimage = [[WXRemotionImgBtn alloc]init];
        [self.contentView addSubview:iconimage];
        self.iconImage = iconimage;
        
        UIImage *image = [UIImage imageNamed:@"TimeLimt.png"];
        UIImageView *timeLimit = [[UIImageView alloc]initWithImage:image];
        [self.iconImage addSubview:timeLimit];
        self.timeLimit = timeLimit;
        
        UILabel *goodsName = [[UILabel alloc]init];
        goodsName.font = nameFont;
        goodsName.textColor = [UIColor blackColor];
        goodsName.numberOfLines = 2;
        [self.contentView addSubview:goodsName];
        self.goodsName = goodsName;
        
        UILabel *price = [[UILabel alloc]init];
        price.font = [UIFont systemFontOfSize:15];
        price.textColor = [UIColor colorWithHexString:@"#dd2726"];
        [self.contentView addSubview:price];
        self.price = price;
        
    }
    return self;
}

-(void)setInfo:(GoodsListInfo *)info{
    _info = info;
    
    [self.iconImage setCpxViewInfo:info.add_goods_home_img];
    [self.iconImage setButtonEnable:NO];
    [self.iconImage load];
    

    
    if (info.scare_buying_id == nil || info.scare_buying_id.length == 0) {
        self.price.text = info.goods_price;
        self.timeLimit.hidden = YES;
    }else{
        self.timeLimit.hidden = NO;
        self.price.text = info.scare_buying_price;
    }
    self.goodsName.text = info.goods_name;
   
   
    [self setContentFrame];
}


- (void)setContentFrame{
    self.width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat imageW = 98;
    CGFloat imageH = imageW;
    self.iconImage.frame = CGRectMake(leftMargin, topMargin, imageW, imageH);
    
    CGFloat Left = self.iconImage.right + spacing;
    NSString *str = @" /n ";
    CGSize size = [NSString sizeWithString:str font:nameFont];
    CGFloat nameW = self.width - (leftMargin * 2) - imageW - spacing;
    self.goodsName.frame = CGRectMake(Left, nameTopMargin, nameW, size.height);
    
    CGFloat priceY = self.goodsName.bottom + 30;
    self.price.frame = CGRectMake(Left,priceY,nameW, size.height );
    
    self.timeLimit.frame = CGRectMake(0, 0, 40, 40);
  
}


+ (CGFloat)cellHeight{
    return 100;
}



@end
