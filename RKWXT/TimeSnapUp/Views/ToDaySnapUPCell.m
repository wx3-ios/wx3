//
//  ToDaySnapUPCell.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ToDaySnapUPCell.h"
#import "TimeShopData.h"
#import "ToSnapUp.h"
#import "NSDate+Time.h"

#define buyingBtnW (100)

@interface ToDaySnapUPCell ()
/** 头像  */
@property (nonatomic,strong)WXRemotionImgBtn *iconimage ;
/** 商品名 */
@property (nonatomic,strong)UILabel *nameLable;
/** 下划线 */
@property (nonatomic,strong)UIView *drawview;
/** 销售价 */
@property (nonatomic,strong)UILabel *buying_price;
/** 原价 */
@property (nonatomic,strong)UILabel *orgin_price;
/** 抢购按钮 */
@property (nonatomic,strong)UIButton *buyingBtn;
/** 抢购数量 */
@property (nonatomic,strong)UILabel *buyingNumber;

/** 距离倒计时 */
@property (nonatomic,strong)UIImageView *beg_image;

@property (nonatomic,strong)UILabel *beg_time;
@property (nonatomic,strong)UILabel *beg_open;
/** 结束 */
@property (nonatomic,strong)UIImageView *over_image;

@property (nonatomic,strong)UILabel *over_label;




@end

@implementation ToDaySnapUPCell

+ (instancetype)toDaySnapTopCell:(UITableView *)tableview{
    NSString *cellIndef = @"toDaySnapTopCell";
    ToDaySnapUPCell *cell = [tableview dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[ToDaySnapUPCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef ];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.width = [UIScreen mainScreen].bounds.size.width;
        
        
        CGFloat imageW = C_ImageW;
        CGFloat imageH = C_ImageW;
        CGFloat imageX = C_Margin;
        CGFloat imageY = C_Margin;
        
        WXRemotionImgBtn *iconimage = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(imageX, imageY , imageW, imageH)];
        [self.contentView addSubview:iconimage];
        self.iconimage = iconimage;
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = [UIFont systemFontOfSize:14];
        namelabel.numberOfLines = 2;
        [self.contentView addSubview:namelabel];
        self.nameLable = namelabel;
        
        UILabel *buyingNumber = [[UILabel alloc]init];
        buyingNumber.font = [UIFont systemFontOfSize:12];
        buyingNumber.textAlignment = NSTextAlignmentLeft;
        buyingNumber.textColor = [UIColor grayColor];
        [self.contentView addSubview:buyingNumber];
        self.buyingNumber = buyingNumber;
        
        UILabel *buying_price = [[UILabel alloc]init];
        buying_price.font = [UIFont systemFontOfSize:14];
        buying_price.textAlignment = NSTextAlignmentLeft;
        buying_price.textColor = [UIColor colorWithHexString:@"#dd2726"];
        [self.contentView addSubview:buying_price];
        self.buying_price = buying_price;
        
        UILabel *orgin_price = [[UILabel alloc]init];
        orgin_price.font = [UIFont systemFontOfSize:10];
        orgin_price.textAlignment = NSTextAlignmentLeft;
        orgin_price.textColor = [UIColor colorWithHexString:@"#909090"];
        [self.contentView addSubview:orgin_price];
        self.orgin_price = orgin_price;
        
        UIButton *buyingBtn = [[UIButton alloc]init];
        buyingBtn.backgroundColor = [UIColor colorWithHexString:@"dd2726"];
        buyingBtn.layer.cornerRadius = 4;
        [buyingBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
        [buyingBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self.contentView addSubview:buyingBtn];
        self.buyingBtn = buyingBtn;
        
        
        UIView *drawview = [[UIView alloc]init];
        drawview.backgroundColor = [UIColor colorWithHexString:@"#909091"];
        [self.orgin_price addSubview:drawview];
        self.drawview = drawview;
        
        
        //即将开始
        UIImageView *beg_image = [[UIImageView alloc]init];
        self.over_image.alpha = 0.7;
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
        timeDown.alpha = 0.8;
        timeDown.textColor = [UIColor whiteColor];
        timeDown.font = [UIFont systemFontOfSize:12];
        timeDown.textAlignment = NSTextAlignmentCenter;
        [self.iconimage addSubview:timeDown];
        self.timeDown =  timeDown;
        
        //结束
        UIImageView *over_image = [[UIImageView alloc]init];
        over_image.alpha = 0.7;
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





//设置内容
-(void)setData:(TimeShopData *)data{
    _data = data;
    
    [self setContent:data];
    
    
    [self setCountFrame];
    
}

//计算内容
- (void)setContent:(TimeShopData*)data{
    [self.iconimage setButtonEnable:NO];
    [self.iconimage setCpxViewInfo:data.add_goods_home_img];
    [self.iconimage load];
    self.nameLable.text = data.goods_name;
    self.orgin_price.text = [NSString stringWithFormat:@"￥%@",data.goods_price];
    self.buying_price.text = [NSString stringWithFormat:@"￥%@",data.scare_buying_price];
    
    if ([data.user_scare_buying_number isEqualToString:@"0"]) {
        NSString *str1 = @"不限";
        NSString *str = [NSString stringWithFormat:@"限购数量:%@",str1];
        
        self.buyingNumber.attributedText = [NSString changeFontAddColor:str sonStr:str1 fontColor:[UIColor colorWithHexString:@"#dd2726"]];
        
    }else{
        
        NSString *str = [NSString stringWithFormat:@"限购数量:%@",data.user_scare_buying_number];
        self.buyingNumber.attributedText = [NSString changeFontAddColor:str sonStr:data.user_scare_buying_number fontColor:[UIColor colorWithHexString:@"#dd2726"]];
        
    }
    
    
    //即将开始
    NSDate *beg_date = [NSDate dateWithTimeIntervalSince1970:[self.data.begin_time longLongValue]];
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"HH:mm:ss"];
    NSString *str = nil;
    if ([NSDate isCurrentDay:beg_date]) {
        str = [matter stringFromDate:beg_date];
    }else{
        [matter setDateFormat:@"MM - dd"];
        str = [matter stringFromDate:beg_date];
        
    }
    
    UIImage *image = [UIImage imageNamed:@"beg_time"];
    self.beg_image.image = image;
    self.beg_open.text = @" 即将开抢";
    self.beg_time.text = str;
    //开始
    self.timeDown.text = data.time_countdown;
    
    //结束
    UIImage *end_image = [UIImage imageNamed:@"end"];
    self.over_image.image = end_image;
    self.over_label.text = @"已抢光";
    
    
    self.beg_image.hidden = data.isImageHidden == YES;
    self.timeDown.hidden = data.isDownHidden == YES;
    self.over_image.hidden = data.isEnd_Image_Hidden == YES;
    
    if (!self.timeDown.hidden) {
        self.buyingBtn.backgroundColor = [UIColor redColor];
        self.buyingBtn.enabled = NO;
    }else{
        self.buyingBtn.backgroundColor = [UIColor grayColor];
        self.buyingBtn.enabled = YES;
    }
}





//  计算位置
- (void)setCountFrame{
    CGFloat widch = self.contentView.width;
    
    
    CGFloat imageW = C_ImageW;
    CGFloat imageH = C_ImageW;
    CGFloat imageX = C_Margin;
    CGFloat imageY = C_Margin;
    self.iconimage.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    
    NSString *str = @" \n ";
    CGFloat nameW =  widch - (C_Spcing * 2 ) - imageW - imageX ;
    CGSize size = [NSString sizeWithString:str font:[UIFont systemFontOfSize:14] maxW:nameW];
    //CGFloat labelH = (self.height - 25 - 18 - 35 * 0.5 - 6) / 4;
    
    CGFloat nameX = self.iconimage.right + C_Spcing;
    CGFloat nameY = C_N_Spcing;
    self.nameLable.frame = (CGRect){{nameX,nameY},{nameW,size.height}};
    
    CGFloat numberY = self.nameLable.bottom ;
    self.buyingNumber.frame = CGRectMake(nameX, numberY, nameW, size.height / 2);
    
    
    
    CGFloat buyingX = nameX;
    CGFloat buyingY = self.buyingNumber.bottom + 4;
    CGFloat buyingW = nameW  - buyingBtnW;
    CGFloat buyingH = size.height / 2;
    self.buying_price.frame = CGRectMake(buyingX, buyingY, buyingW, buyingH);
    
    CGFloat oringX = nameX;
    CGFloat oringY = self.buying_price.bottom + 2;
    CGFloat oringW = nameW  - buyingW;
    CGFloat oringH = size.height / 2;
    self.orgin_price.frame = CGRectMake(oringX, oringY, oringW, oringH);
    
    CGSize size1 = [NSString sizeWithString:self.orgin_price.text font:[UIFont systemFontOfSize:10]];
    CGFloat drawH = 0.5;
    CGFloat draewX = 0;
    CGFloat draewY = self.orgin_price.height / 2;
    self.drawview.frame = CGRectMake(draewX, draewY, size1.width, drawH);
    
    
    CGFloat btnW = buyingBtnW;
    CGFloat btnH = 32;
    CGFloat btnX = self.width - 15 - buyingBtnW;
    CGFloat btnY =C_ImageW + C_Margin + C_Margin - btnH - 15;
    self.buyingBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    
    
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
    CGSize sizeT = [NSString sizeWithString:[NSString stringWithFormat:@"  %@",self.timeDown.text] font:[UIFont systemFontOfSize:12]];
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


+ (CGFloat)cellHeight{
    return C_ImageW + C_Margin + C_Margin;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

- (void)clickBtn{
    
    return;
    
}

@end
