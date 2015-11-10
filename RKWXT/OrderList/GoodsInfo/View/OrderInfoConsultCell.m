//
//  OrderInfoConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderInfoConsultCell.h"
#import "OrderListEntity.h"

@interface OrderInfoConsultCell(){
    UILabel *_money;
    UILabel *_bonus;
    UILabel *_carriage;
}
@end

@implementation OrderInfoConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat yOffset = 12;
        CGFloat width = 90;
        CGFloat height = 15;
        UILabel *textLabel1 = [[UILabel alloc] init];
        textLabel1.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel1 setBackgroundColor:[UIColor clearColor]];
        [textLabel1 setTextAlignment:NSTextAlignmentLeft];
        [textLabel1 setFont:WXFont(14.0)];
        [textLabel1 setText:@"商品总额"];
        [textLabel1 setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:textLabel1];
        
        CGFloat xGap = 12;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentRight];
        [_money setFont:WXFont(14.0)];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_money];
        
        yOffset += height+8;
        UILabel *textLabel2 = [[UILabel alloc] init];
        textLabel2.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel2 setBackgroundColor:[UIColor clearColor]];
        [textLabel2 setTextAlignment:NSTextAlignmentLeft];
        [textLabel2 setFont:WXFont(12.0)];
        [textLabel2 setText:@"+红包抵用:"];
        [textLabel2 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel2];
        
        _bonus = [[UILabel alloc] init];
        _bonus.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_bonus setBackgroundColor:[UIColor clearColor]];
        [_bonus setTextAlignment:NSTextAlignmentRight];
        [_bonus setFont:WXFont(12.0)];
        [_bonus setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_bonus];
        
        yOffset += height+8;
        UILabel *textLabel3 = [[UILabel alloc] init];
        textLabel3.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel3 setBackgroundColor:[UIColor clearColor]];
        [textLabel3 setTextAlignment:NSTextAlignmentLeft];
        [textLabel3 setFont:WXFont(12.0)];
        [textLabel3 setText:@"+运费:"];
        [textLabel3 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel3];
        
        _carriage = [[UILabel alloc] init];
        _carriage.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_carriage setBackgroundColor:[UIColor clearColor]];
        [_carriage setTextAlignment:NSTextAlignmentRight];
        [_carriage setFont:WXFont(12.0)];
        [_carriage setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_carriage];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    CGFloat price = 0.0;
    for(OrderListEntity *ent in entity.goodsArr){
        price += ent.sales_num*ent.sales_price;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.2f",price];
    [_money setText:str];
    
    NSString *bonusStr = [NSString stringWithFormat:@"-%ld",(long)entity.red_packet];
    [_bonus setText:bonusStr];
    
    NSString *carriage = [NSString stringWithFormat:@"+%.2f",entity.postage];
    [_carriage setText:carriage];
}

@end
