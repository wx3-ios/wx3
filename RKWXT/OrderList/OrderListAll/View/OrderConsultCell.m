//
//  OrderConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderConsultCell.h"
#import "OrderListEntity.h"

@interface OrderConsultCell(){
    UILabel *_goodsNum;
    UILabel *_consult;
    
    NSInteger number;
    CGFloat price;
}
@end

@implementation OrderConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 210;
        CGFloat height = 16;
        CGFloat numWidth = 75;
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, numWidth, height);
        [_goodsNum setBackgroundColor:[UIColor clearColor]];
        [_goodsNum setTextAlignment:NSTextAlignmentLeft];
        [_goodsNum setTextColor:WXColorWithInteger(0x646464)];
        [_goodsNum setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsNum];
        
        xOffset -= (numWidth+6);
        CGFloat textWidth = 38;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, textWidth, height);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x646464)];
        [textLabel setFont:WXTFont(16.0)];
        [textLabel setText:@"实付:"];
        [self.contentView addSubview:textLabel];
        
        xOffset -= textWidth;
        _consult = [[UILabel alloc] init];
        _consult.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, size.width-xOffset, height);
        [_consult setBackgroundColor:[UIColor clearColor]];
        [_consult setTextAlignment:NSTextAlignmentLeft];
        [_consult setTextColor:WXColorWithInteger(0x000000)];
        [_consult setFont:WXTFont(16.0)];
        [self.contentView addSubview:_consult];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    for(OrderListEntity *ent in entity.goodsArr){
        number += ent.sales_num;
        price += ent.factPayMoney;
    }
    price += entity.postage;
    [_goodsNum setText:[NSString stringWithFormat:@"共%ld件商品",(long)number]];
    [_consult setText:[NSString stringWithFormat:@"￥%.2f",price]];
    number = 0;
    price = 0;
}

@end
