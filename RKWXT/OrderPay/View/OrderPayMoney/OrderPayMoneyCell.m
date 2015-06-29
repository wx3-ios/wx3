//
//  OrderPayMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderPayMoneyCell.h"

@interface OrderPayMoneyCell(){
    UILabel *_money;
}
@end

@implementation OrderPayMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 110;
        CGFloat labelHeight = 18;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (OrderPayMoneyCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x989898)];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setText:@"请选择支付方式"];
        [self.contentView addSubview:textLabel];
        
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, (OrderPayMoneyCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentRight];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [_money setFont:WXFont(15.0)];
        [self.contentView addSubview:_money];
    }
    return self;
}

-(void)load{
    CGFloat money = [self.cellInfo floatValue];
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",money];
    [_money setText:moneyStr];
}

@end
