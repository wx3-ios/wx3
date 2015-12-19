//
//  LMMakeOrderGoodsMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderGoodsMoneyCell.h"
#import "LMMakeOrderDef.h"
#import "LMGoodsInfoEntity.h"

@interface LMMakeOrderGoodsMoneyCell(){
    UILabel *_money;
    UILabel *_carriage;
}
@end

@implementation LMMakeOrderGoodsMoneyCell

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
        [textLabel1 setFont:WXFont(12.0)];
        [textLabel1 setText:@"商品总额"];
        [textLabel1 setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:textLabel1];
        
        CGFloat xGap = 12;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentRight];
        [_money setFont:WXFont(12.0)];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_money];
        
        yOffset += height+8;
        UILabel *textLabel3 = [[UILabel alloc] init];
        textLabel3.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel3 setBackgroundColor:[UIColor clearColor]];
        [textLabel3 setTextAlignment:NSTextAlignmentLeft];
        [textLabel3 setFont:WXFont(11.0)];
        [textLabel3 setText:@"+运费:"];
        [textLabel3 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel3];
        
        _carriage = [[UILabel alloc] init];
        _carriage.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_carriage setBackgroundColor:[UIColor clearColor]];
        [_carriage setTextAlignment:NSTextAlignmentRight];
        [_carriage setFont:WXFont(11.0)];
        [_carriage setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_carriage];
    }
    return self;
}

-(void)load{
    CGFloat price = 0.0;
    NSArray *listArr = self.cellInfo;
    for(LMGoodsInfoEntity *entity in listArr){
        price += entity.stockPrice;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.2f",price];
    [_money setText:str];
    
    NSString *carriageStr = [NSString stringWithFormat:@"+%.2f",_carriageMoney];
    [_carriage setText:carriageStr];
}

@end
