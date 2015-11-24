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

#import "TimeShopData.h"

#define LabelWidth (110)

@interface NewGoodsInfoDesCell(){
    WXUILabel *_oldPrice;
    WXUILabel *_lineLabel;
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
    WXUIButton *_attentionBtn;
    
    WXUILabel *postageLabel;
}
@end

@implementation NewGoodsInfoDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 8;
        CGFloat oldLabelHeight = 12;
        _oldPrice  = [[WXUILabel alloc] init];
        _oldPrice.frame = CGRectMake(xOffset, yOffset+14+30, LabelWidth, oldLabelHeight);
        [_oldPrice setTextAlignment:NSTextAlignmentLeft];
        [_oldPrice setTextColor:WXColorWithInteger(midTextColor)];
        [_oldPrice setFont:[UIFont systemFontOfSize:18.0]];
        [_oldPrice setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_oldPrice];
        
        xOffset += LabelWidth+5;
        CGFloat textWidth = 42;
        CGFloat newLabelHeight = 14;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset+14+30, textWidth, newLabelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentRight];
        [textLabel setText:@"市场价:"];
        [textLabel setTextColor:[UIColor grayColor]];
        [textLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:textLabel];
        
        xOffset += textWidth;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(xOffset, yOffset+14+30, textWidth+25+10, newLabelHeight);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentLeft];
        [_newPrice setTextColor:WXColorWithInteger(midTextColor)];
        [_newPrice setTextColor:[UIColor grayColor]];
        [_newPrice setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_newPrice];
        
        postageLabel = [[WXUILabel alloc] init];
        postageLabel.frame = CGRectMake(14, _newPrice.frame.origin.y+_newPrice.frame.size.height+12, textWidth, newLabelHeight);
        [postageLabel setBackgroundColor:[UIColor clearColor]];
        [postageLabel setTextAlignment:NSTextAlignmentLeft];
        [postageLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [postageLabel setText:@"包邮"];
        [postageLabel setFont:WXFont(14.0)];
        [postageLabel setHidden:YES];
        [self.contentView addSubview:postageLabel];
        
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.frame = CGRectMake(xOffset-textWidth, yOffset+14+30+newLabelHeight/2, 2*textWidth, 0.5);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:lineLabel];

        
        yOffset += newLabelHeight + 5;
        CGFloat descLabelHeight = 36;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(12, yOffset-newLabelHeight-5, IPHONE_SCREEN_WIDTH-2*12-100, descLabelHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setTextColor:WXColorWithInteger(bigTextColor)];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setNumberOfLines:0];
        [self.contentView addSubview:_descLabel];
        
        
        xOffset = IPHONE_SCREEN_WIDTH-62;
        yOffset = 10;
        WXUILabel *line = [[WXUILabel alloc] init];
        line.frame = CGRectMake(xOffset, yOffset, 0.5, T_GoodsInfoDescHeight-2*yOffset);
        [line setBackgroundColor:WXColorWithInteger(0xcacaca)];
//        [self.contentView addSubview:line];
        
        CGFloat btnWidth = 27;
        CGFloat btnHeight = 25;
        _attentionBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _attentionBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-btnWidth)/2, yOffset+(T_GoodsInfoDescHeight-yOffset-btnHeight-25)/2, btnWidth, btnHeight);
        [_attentionBtn setImage:[UIImage imageNamed:@"T_ShareGoods.png"] forState:UIControlStateNormal];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:smallTextFont]];
        [_attentionBtn setTitleColor:WXColorWithInteger(smallTextColor) forState:UIControlStateNormal];
//        [_attentionBtn addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_attentionBtn];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_oldPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.shop_price]];
    [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.market_price]];
    [_descLabel setText:entity.intro];
//    if(entity.concernID != 0){
//        [_attentionBtn setImage:[UIImage imageNamed:@"T_AttentionSel.png"] forState:UIControlStateNormal];
//    }
    
    if(entity.postage == Goods_Postage_None && !_isLucky){
        [postageLabel setHidden:NO];
    }
    
    if(_lEntity){
        TimeShopData *limitEntity = _lEntity;
        [_oldPrice setText:[NSString stringWithFormat:@"￥%.2f",[limitEntity.goods_price floatValue]]];
        [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",[limitEntity.scare_buying_price floatValue]]];
    }
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    GoodsInfoEntity *entity = cellInfo;
    if(entity.postage == Goods_Postage_None){
        return T_GoodsInfoDescHeight+25;
    }
    return T_GoodsInfoDescHeight;
}

@end
