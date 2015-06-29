//
//  MakeOrderGoodsMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderGoodsMoneyCell.h"
#import "MakeOrderDef.h"
#import "GoodsInfoEntity.h"

@interface MakeOrderGoodsMoneyCell(){
    UILabel *_money;
    UILabel *_bonus;
}
@end

@implementation MakeOrderGoodsMoneyCell

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
        UILabel *textLabel2 = [[UILabel alloc] init];
        textLabel2.frame = CGRectMake(xOffset, yOffset, width, height);
        [textLabel2 setBackgroundColor:[UIColor clearColor]];
        [textLabel2 setTextAlignment:NSTextAlignmentLeft];
        [textLabel2 setFont:WXFont(11.0)];
        [textLabel2 setText:@"+红包抵用:"];
        [textLabel2 setTextColor:WXColorWithInteger(0x6a6c6b)];
        [self.contentView addSubview:textLabel2];
        
        _bonus = [[UILabel alloc] init];
        _bonus.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-width, yOffset, width, height);
        [_bonus setBackgroundColor:[UIColor clearColor]];
        [_bonus setTextAlignment:NSTextAlignmentRight];
        [_bonus setFont:WXFont(11.0)];
        [_bonus setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_bonus];
    }
    return self;
}

-(void)load{
    CGFloat price = 0.0;
    NSArray *listArr = self.cellInfo;
    for(GoodsInfoEntity *entity in listArr){
        price += entity.buyNumber*entity.stockPrice;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.2f",price];
    [_money setText:str];
    
    NSString *bonusStr = [NSString stringWithFormat:@"-%ld",(long)_bonusMoney];
    [_bonus setText:bonusStr];
}

@end
