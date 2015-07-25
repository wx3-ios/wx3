//
//  NewGoodsInfoDesCell.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoDesCell.h"
#import "GoodsInfoDef.h"
#import "GoodsInfoEntity.h"

#define LabelWidth (120)

@interface NewGoodsInfoDesCell(){
    WXUILabel *_oldPrice;
    WXUILabel *_lineLabel;
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
    WXUIButton *_attentionBtn;
}
@end

@implementation NewGoodsInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 15;
        CGFloat oldLabelHeight = 12;
        _oldPrice  = [[WXUILabel alloc] init];
        _oldPrice.frame = CGRectMake(xOffset, yOffset+14+28, LabelWidth, oldLabelHeight);
        [_oldPrice setTextAlignment:NSTextAlignmentLeft];
        [_oldPrice setTextColor:WXColorWithInteger(smallTextColor)];
        [_oldPrice setFont:[UIFont systemFontOfSize:smallTextFont]];
        [_oldPrice setBackgroundColor:[UIColor clearColor]]; 
        [self.contentView addSubview:_oldPrice];
        
        xOffset += LabelWidth+35;
        CGFloat textWidth = 50;
        CGFloat newLabelHeight = 14;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset, textWidth, newLabelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setText:@"分销价:"];
        [textLabel setTextColor:WXColorWithInteger(midTextColor)];
        [textLabel setFont:[UIFont systemFontOfSize:midTextFont]];
//        [self.contentView addSubview:textLabel];
        
        xOffset += textWidth;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(xOffset, yOffset, textWidth+10, newLabelHeight);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentLeft];
        [_newPrice setTextColor:WXColorWithInteger(midTextColor)];
        [_newPrice setTextColor:[UIColor redColor]];
        [_newPrice setFont:[UIFont systemFontOfSize:midTextFont]];
        [self.contentView addSubview:_newPrice];
        
        yOffset += newLabelHeight + 5;
        CGFloat descLabelHeight = 36;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(12, yOffset-newLabelHeight-5, IPHONE_SCREEN_WIDTH-2*12-100, descLabelHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setTextColor:WXColorWithInteger(bigTextColor)];
        [_descLabel setFont:[UIFont systemFontOfSize:bigTextFont]];
        [_descLabel setNumberOfLines:0];
        [self.contentView addSubview:_descLabel];
        
        
        xOffset = IPHONE_SCREEN_WIDTH-62;
        yOffset = 10;
        WXUILabel *line = [[WXUILabel alloc] init];
        line.frame = CGRectMake(xOffset, yOffset, 0.5, T_GoodsInfoDescHeight-2*yOffset);
        [line setBackgroundColor:WXColorWithInteger(smallTextColor)];
        [self.contentView addSubview:line];
        
        CGFloat btnWidth = 27;
        CGFloat btnHeight = 25;
        _attentionBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-btnWidth)/2, yOffset+(T_GoodsInfoDescHeight-yOffset-btnHeight-25)/2, btnWidth, btnHeight);
        [_attentionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:smallTextFont]];
        [_attentionBtn setTitleColor:WXColorWithInteger(smallTextColor) forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        
        CGFloat width = 60;
        WXUILabel *label = [[WXUILabel alloc] init];
        label.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-width)/2, yOffset+9+(T_GoodsInfoDescHeight-yOffset-btnHeight)/2, width, btnHeight-8);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"分享"];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:label];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_oldPrice setText:[NSString stringWithFormat:@"原价 ￥%.2f",entity.market_price]];
//    [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shop_price]];
    [_descLabel setText:entity.intro];
    if(entity.concernID != 0){
        [_attentionBtn setImage:[UIImage imageNamed:@"T_AttentionSel.png"] forState:UIControlStateNormal];
    }
}

-(void)payAttention:(WXUIButton*)btn{
//    GoodsInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(payAttentionToSomeGoods:)]){
        [_delegate payAttentionToSomeGoods:btn];
    }
}

@end
