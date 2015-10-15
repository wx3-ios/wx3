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

#define LabelWidth (110)

@interface NewGoodsInfoDesCell(){
    WXUILabel *_oldPrice;
    WXUILabel *_lineLabel;
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
    WXUIButton *_attentionBtn;
    WXUILabel *_redPacket;
    WXUILabel *_cutLabel;
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
        
        CGFloat width = 60;
        WXUILabel *label = [[WXUILabel alloc] init];
        label.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset-width)/2, yOffset+9+(T_GoodsInfoDescHeight-yOffset-btnHeight)/2, width, btnHeight-8);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"分享"];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setTextColor:WXColorWithInteger(0xcacaca)];
//        [self.contentView addSubview:label];
        
        _redPacket = [[WXUILabel alloc] init];
        _redPacket.frame = CGRectMake(12, _oldPrice.frame.origin.y+btnHeight, 100, btnHeight);
        [_redPacket setBackgroundColor:[UIColor clearColor]];
        [_redPacket setText:@"该商品可使用红包"];
        [_redPacket setTextAlignment:NSTextAlignmentLeft];
        [_redPacket setTextColor:WXColorWithInteger(0xdd2726)];
        [_redPacket setFont:WXFont(12.0)];
        [_redPacket setHidden:YES];
        [self.contentView addSubview:_redPacket];
        
        _cutLabel = [[WXUILabel alloc] init];
        _cutLabel.frame = CGRectMake(12, _oldPrice.frame.origin.y+btnHeight, 100, btnHeight);
        [_cutLabel setBackgroundColor:[UIColor clearColor]];
        [_cutLabel setText:@"该商品有提成"];
        [_cutLabel setTextAlignment:NSTextAlignmentLeft];
        [_cutLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_cutLabel setFont:WXFont(12.0)];
        [_cutLabel setHidden:YES];
        [self.contentView addSubview:_cutLabel];
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
    if(entity.use_red){
        [_redPacket setHidden:NO];
    }
    
    if(entity.use_cut){
        [_cutLabel setHidden:NO];
        if(entity.use_red){
            CGRect rect = _cutLabel.frame;
            rect.origin.y += 25;
            [_cutLabel setFrame:rect];
        }
    }
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    GoodsInfoEntity *entity = cellInfo;
    if(entity){
        if(entity.use_red && entity.use_cut){
            return T_GoodsInfoDescHeight+50;
        }
        if(entity.use_red || entity.use_cut){
            return T_GoodsInfoDescHeight+30;
        }
    }
    return T_GoodsInfoDescHeight;
}

@end
