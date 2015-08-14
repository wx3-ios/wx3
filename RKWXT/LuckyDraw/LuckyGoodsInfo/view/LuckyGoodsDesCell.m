//
//  LuckyGoodsDesCell.m
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsDesCell.h"

#define LabelWidth (110)

@interface LuckyGoodsDesCell(){
    WXUILabel *_newPrice;
    WXUILabel *_descLabel;
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
        [_newPrice setTextColor:[UIColor redColor]];
        [_newPrice setFont:[UIFont systemFontOfSize:12.0]];
        [self.contentView addSubview:_newPrice];
    }
    return self;
}

-(void)load{
    [_descLabel setText:@""];
    [_newPrice setText:[NSString stringWithFormat:@"￥%.2f",100.00]];
}

@end
