//
//  StoreListInfoCell.m
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "StoreListInfoCell.h"
#import "UIViewAdditions.h"
#import "UIColor+XBCategory.h"
#import "PhotoView.h"
#import "NSString+XBCategory.h"

#import "StoreListData.h"
@interface StoreListInfoCell ()
@property (nonatomic,strong)UIView *addView;

@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)UILabel *storeName;
@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic,strong)UILabel *nowShop;
@property (nonatomic,strong)UILabel *discount;
@end

@implementation StoreListInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self.addView removeFromSuperview];
        
        self.addView = [[UIView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:self.addView];
        
        
        
        self.width = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView *iconImage = [[UIImageView alloc]init];
        [self.addView addSubview:iconImage];
        self.iconImage = iconImage;
        
        UILabel *storeName= [[UILabel alloc]init];
        storeName.font = [UIFont systemFontOfSize:14];
        [self.addView addSubview:storeName];
        self.storeName = storeName;
        
        UILabel *name= [[UILabel alloc]init];
        name.font = [UIFont systemFontOfSize:10];
        name.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        [self.addView addSubview:name];
        self.name = name;
        
        PhotoView *photoView = [[PhotoView alloc]init];
        [self.addView addSubview:photoView];
        self.photoView = photoView;
        
        UIImageView *bgImage = [[UIImageView alloc]init];
        [self.addView addSubview:bgImage];
        UIImage *bg = [UIImage imageNamed:@"discountBack"];
        bgImage.image = bg;
        self.bgImage = bgImage;
        
        UILabel *nowShop= [[UILabel alloc]init];
        nowShop.font = [UIFont systemFontOfSize:12];
        nowShop.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.bgImage addSubview:nowShop];
        self.nowShop = nowShop;
        
        
        UILabel *discount= [[UILabel alloc]init];
        [self.addView addSubview:discount];
        self.discount = discount;
        discount.numberOfLines = 2;
        self.discount.backgroundColor = [UIColor redColor];
        
        
    }
    return self;
}



-(void)setData:(StoreListData *)data{
    _data = data;
    
    [self setContentCreate];
    
    [self setContent];
    
    [self setcontentFrame];
}

- (void)setContentCreate{
 
    
    
    
}


- (void)setContent{
    self.name.text = self.data.name;
    self.storeName.text = self.data.storeName;
    self.iconImage.image = [UIImage imageNamed:self.data.icon];
    self.photoView.photoCount = self.data.content;
    self.discount.text = @"这是一个悲伤的\n\n故事";
    
    
 
}

- (void)setcontentFrame{
    
    self.width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat icomW = 30;
    CGFloat icomH = 30;
    CGFloat iconY = 10;
    CGFloat iconX = 10;
    self.iconImage.frame = CGRectMake(iconX, iconY, icomW, icomH);
    
    CGFloat storeW = self.width - icomW - 15;
    CGSize size = [NSString sizeWithString:self.storeName.text font:[UIFont systemFontOfSize:14] maxW:storeW];
    self.storeName.frame = CGRectMake(self.width - storeW , iconY, storeW, size.height);
    
    CGFloat nameY = self.storeName.bottom;
    CGSize size1 = [NSString sizeWithString:self.name.text font:[UIFont systemFontOfSize:10] maxW:storeW];
    self.name.frame = CGRectMake(self.width - storeW , nameY, storeW, size1.height);
    
    CGFloat photoY = self.name.bottom + 13;
    self.photoView.frame = CGRectMake(0, photoY, self.width, 93);
    
    CGFloat bgimageY = self.photoView.bottom + 13;
    self.bgImage.frame = CGRectMake(iconX, bgimageY, 50, 38);
    
    self.nowShop.frame = CGRectMake(5, 5,self.bgImage.width - 10, self.bgImage.height - 10);
    self.nowShop.backgroundColor = [UIColor orangeColor];
    self.nowShop.textAlignment = NSTextAlignmentCenter;
    
    CGFloat discountX = self.nowShop.right + 15;
    self.discount.frame = CGRectMake(discountX, bgimageY, self.width - discountX, 40);
    
}





+ (CGFloat)cellHeightForRow{
    return 220;
   
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}





@end
