//
//  MakeOrderAllGoodsMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderAllGoodsMoneyCell.h"
#import "GoodsInfoEntity.h"
#import "ShopActivityEntity.h"

@interface MakeOrderAllGoodsMoneyCell(){
    UILabel *_money;
    UILabel *_dateLabel;
}
@end

@implementation MakeOrderAllGoodsMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xGap = 140;
        CGFloat yOffset = 12;
        CGFloat upHeight = 20;
        CGFloat labelWidth = 55;
        UILabel *uptextLabel = [[UILabel alloc] init];
        uptextLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, labelWidth, upHeight);
        [uptextLabel setBackgroundColor:[UIColor clearColor]];
        [uptextLabel setTextAlignment:NSTextAlignmentLeft];
        [uptextLabel setText:@"实付款:"];
        [uptextLabel setTextColor:WXColorWithInteger(0x000000)];
        [uptextLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:uptextLabel];
        
        xGap -= labelWidth;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, IPHONE_SCREEN_WIDTH-xGap, upHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setFont:WXFont(15.0)];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_money];
        
        yOffset += upHeight+8;
        CGFloat xOffset = 180;
        CGFloat dateWidth = 50;
        CGFloat dateHeight = 15;
        UILabel *datelabel = [[UILabel alloc] init];
        datelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, dateWidth, dateHeight);
        [datelabel setBackgroundColor:[UIColor clearColor]];
        [datelabel setTextAlignment:NSTextAlignmentLeft];
        [datelabel setTextColor:WXColorWithInteger(0x787978)];
        [datelabel setFont:WXFont(11.0)];
        [datelabel setText:@"下单时间:"];
        [self.contentView addSubview:datelabel];
        
        xOffset -= dateWidth;
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset, dateHeight);
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setTextColor:WXColorWithInteger(0x787978)];
        [_dateLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void)load{
    CGFloat price = 0.0;
    NSArray *listArr = self.cellInfo;
    for(GoodsInfoEntity *entity in listArr){
        price += entity.buyNumber*entity.stockPrice;
    }
    
    NSString *moneyStr = nil;
     if ([ShopActivityEntity shareShopActionEntity].type == ShopActivityType_IsPosgate) { //包邮
         
         if (price >= [ShopActivityEntity shareShopActionEntity].postage) { //总价 >= 包邮价格
             moneyStr = [NSString stringWithFormat:@"￥%.2f",price];
         }else{
             moneyStr = [NSString stringWithFormat:@"￥%.2f",price + _carriageMoney];
         }
         
     }else if ([ShopActivityEntity shareShopActionEntity].type == ShopActivityType_Reduction){ //满减
         
         if (price >= [ShopActivityEntity shareShopActionEntity].full) {
             moneyStr = [NSString stringWithFormat:@"￥%.2f",price - [ShopActivityEntity shareShopActionEntity].action + _carriageMoney];
         }else{
             moneyStr = [NSString stringWithFormat:@"￥%.2f",price + _carriageMoney];
         }
     }else{
         price -= _bonusMoney;
         moneyStr = [NSString stringWithFormat:@"￥%.2f",price + _carriageMoney];
     }
         
   
    [_money setText:moneyStr];
    
    NSInteger time = [UtilTool timeChange];
    [_dateLabel setText:[UtilTool getDateTimeFor:time type:1]];
}

@end
