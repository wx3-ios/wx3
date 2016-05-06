//
//  GoodsInfoActiviCell.m
//  RKWXT
//
//  Created by app on 16/4/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//



#import "GoodsInfoActiviCell.h"
#import "GoodsInfoEntity.h"
#import "ShopActivityEntity.h"

@interface GoodsInfoActiviCell(){
    WXUIImageView *imgView1;
    WXUIImageView *imgView2;
    WXUILabel *label1;
    WXUILabel *label2;
}
@end

@implementation GoodsInfoActiviCell
+ (instancetype)GoodsInfoActiviCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"NewGEvalutionInfoCell";
    GoodsInfoActiviCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsInfoActiviCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 10;
        CGFloat imgWidth = 14;
        CGFloat imgHeight = 14;
        imgView1 = [[WXUIImageView alloc] init];
        imgView1.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView1 setImage:[UIImage imageNamed:@"GoodsInfoRedImg.png"]];
        [self.contentView addSubview:imgView1];
        
        xOffset += imgWidth+3;
        CGFloat labelWidth = 65;
        CGFloat labelHeight = 18;
        label1 = [[WXUILabel alloc] init];
        label1.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setTextAlignment:NSTextAlignmentLeft];
//        [label1 setText:@"使用红包"];
        [label1 setTextColor:WXColorWithInteger(0x000000)];
        [label1 setFont:WXFont(9.0)];
        [self.contentView addSubview:label1];
        
        xOffset += labelWidth+8;
        imgView2 = [[WXUIImageView alloc] init];
        imgView2.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView2 setImage:[UIImage imageNamed:@"GoodsInfoCutImg.png"]];
        [self.contentView addSubview:imgView2];
        
        xOffset += imgWidth+3;
        label2 = [[WXUILabel alloc] init];
        label2.frame = CGRectMake(xOffset, (GoodsInfoPacketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextAlignment:NSTextAlignmentLeft];
        [label2 setText:@"提成"];
        [label2 setTextColor:WXColorWithInteger(0x000000)];
        [label2 setFont:WXFont(9.0)];
        [self.contentView addSubview:label2];
        
        CGFloat btnWidth = 30;
        CGFloat btnHeight = 12;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-5-btnWidth, (GoodsInfoPacketCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"GoodsInfoDownImg.png"] forState:UIControlStateNormal];
        [btn setEnabled:NO];
        [self.contentView addSubview:btn];
    }
    return self;
}

- (void)goodsInfoPackIsAccording:(NSInteger)type{
    if (type == 1) {
        [imgView1 setImage:[UIImage imageNamed:@"GoodsFull.png"]];
        label1.text = [NSString stringWithFormat:@"满%.f元包邮",[ShopActivityEntity shareShopActionEntity].postage];
    }else if (type == 2){
        [imgView1 setImage:[UIImage imageNamed:@"GoodsFull.png"]];
        label1.text = [NSString stringWithFormat:@"满%.f元减%.f元活动",[ShopActivityEntity shareShopActionEntity].full,[ShopActivityEntity shareShopActionEntity].action];
    }else{
        [imgView1 setImage:[UIImage imageNamed:@"GoodsInfoRedImg.png"]];
    }
}

- (void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    if(entity.use_cut){
        [imgView2 setHidden:NO];
        [label2 setHidden:NO];
    }else{
        [imgView2 setHidden:YES];
        [label2 setHidden:YES];
    }
      
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
