//
//  OrderInfoFactMOneyCell.m
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderInfoFactMOneyCell.h"
#import "OrderListEntity.h"

@interface OrderInfoFactMOneyCell(){
    UILabel *_money;
    UILabel *_dateLabel;
}
@end

@implementation OrderInfoFactMOneyCell

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
        [uptextLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:uptextLabel];
        
        xGap -= labelWidth;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap, yOffset, IPHONE_SCREEN_WIDTH-xGap, upHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setFont:WXFont(14.0)];
        [_money setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:_money];
        
        yOffset += upHeight+8;
        CGFloat xOffset = 185;
        CGFloat dateWidth = 55;
        CGFloat dateHeight = 15;
        UILabel *datelabel = [[UILabel alloc] init];
        datelabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, dateWidth, dateHeight);
        [datelabel setBackgroundColor:[UIColor clearColor]];
        [datelabel setTextAlignment:NSTextAlignmentLeft];
        [datelabel setTextColor:WXColorWithInteger(0x787978)];
        [datelabel setFont:WXFont(12.0)];
        [datelabel setText:@"下单时间:"];
        [self.contentView addSubview:datelabel];
        
        xOffset -= dateWidth;
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset, dateHeight);
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
        [_dateLabel setTextColor:WXColorWithInteger(0x787978)];
        [_dateLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    CGFloat price = 0.0;
    for(OrderListEntity *ent in entity.goodsArr){
        price += ent.sales_price*ent.sales_num;
    }
    NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",entity.total_fee];
    [_money setText:moneyStr];
    
    [_dateLabel setText:[UtilTool getDateTimeFor:entity.add_time type:1]];
}

@end
