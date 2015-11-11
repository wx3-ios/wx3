//
//  LuckyGoodsDesCell.m
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsDesCell.h"
#import "GoodsInfoEntity.h"

#define LabelWidth (110)

@interface LuckyGoodsDesCell(){
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
    WXUILabel *_stockLabel;
    WXUILabel *_oldPrice;
}
@end

@implementation LuckyGoodsDesCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat desLabelWidth = 200;
        CGFloat desLabelHeight = 34;
        _descLabel = [[WXUILabel alloc] init];
        _descLabel.frame = CGRectMake(xOffset, yOffset, desLabelWidth, desLabelHeight);
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentLeft];
        [_descLabel setTextColor:WXColorWithInteger(0x000000)];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setNumberOfLines:0];
        [self.contentView addSubview:_descLabel];
        
        
        yOffset += desLabelHeight+5;
        CGFloat priceWidth = 100;
        CGFloat priceHeight = 18;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(xOffset, yOffset, priceWidth, priceHeight);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentLeft];
        [_newPrice setTextColor:WXColorWithInteger(0xdd2726)];
        [_newPrice setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_newPrice];
        
        xOffset += priceWidth+10;
        _oldPrice = [[WXUILabel alloc] init];
        _oldPrice.frame = CGRectMake(xOffset, yOffset, priceWidth, priceHeight);
        [_oldPrice setBackgroundColor:[UIColor clearColor]];
        [_oldPrice setTextAlignment:NSTextAlignmentCenter];
        [_oldPrice setTextColor:WXColorWithInteger(0xcacaca)];
        [_oldPrice setFont:WXFont(13.0)];
        [self.contentView addSubview:_oldPrice];
        
        WXUILabel *linLabel = [[WXUILabel alloc] init];
        linLabel.frame = CGRectMake(15, (_oldPrice.frame.size.height/2), _oldPrice.frame.size.width-30, 0.5);
        [linLabel setBackgroundColor:WXColorWithInteger(0xcacaca)];
        [_oldPrice addSubview:linLabel];
        
        xOffset = 10;
        yOffset = 10;
        CGFloat stockNameWidth = IPHONE_SCREEN_WIDTH-desLabelWidth-2*xOffset;
        CGFloat stockNameHeight = 28;
        _stockLabel = [[WXUILabel alloc] init];
        _stockLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-stockNameWidth, yOffset, stockNameWidth, stockNameHeight);
        [_stockLabel setBackgroundColor:[UIColor clearColor]];
        [_stockLabel setTextAlignment:NSTextAlignmentRight];
        [_stockLabel setFont:WXFont(13.0)];
        [_stockLabel setNumberOfLines:0];
        [_stockLabel setTextColor:WXColorWithInteger(0xcacaca)];
//        [self.contentView addSubview:_stockLabel];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_descLabel setText:entity.intro];
    [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",_newprice]];
    [_stockLabel setText:_name];
    [_oldPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.market_price]];
}

@end
