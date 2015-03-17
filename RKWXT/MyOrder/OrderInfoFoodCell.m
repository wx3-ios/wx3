//
//  OrderInfoFoodCell.m
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "OrderInfoFoodCell.h"
#import "OrderListEntity.h"

@interface OrderInfoFoodCell (){
    WXUILabel *_name;
    WXUILabel *_number;
    WXUILabel *_multi;
    WXUILabel *_money;
}

@end

@implementation OrderInfoFoodCell

-(void)dealloc{
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_number);
    RELEASE_SAFELY(_multi);
    RELEASE_SAFELY(_money);
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xOffset = 8;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 16;
        _name = [[WXUILabel alloc] init];
        _name.frame = CGRectMake(xOffset, (OrderInfoFoodCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_name setBackgroundColor:[UIColor clearColor]];
        [_name setTextAlignment:NSTextAlignmentLeft];
        [_name setFont:[UIFont systemFontOfSize:15.0]];
        [_name setTextColor:WXColorWithInteger(0x323232)];
        [self.contentView addSubview:_name];
        
        xOffset += nameWidth;
        CGFloat numWidth = 25;
        CGFloat numHeight = 15;
        _number = [[WXUILabel alloc] init];
        _number.frame = CGRectMake(xOffset, (OrderInfoFoodCellHeight-numHeight)/2, numWidth, numHeight);
        [_number setBackgroundColor:[UIColor clearColor]];
        [_number setTextAlignment:NSTextAlignmentCenter];
        [_number setFont:[UIFont systemFontOfSize:15.0]];
        [_number setTextColor:WXColorWithInteger(0x969696)];
        [self.contentView addSubview:_number];
        
        xOffset += numWidth;
        CGFloat multiWidth = 15;
        CGFloat multiHeight = 15;
        _multi = [[WXUILabel alloc] init];
        _multi.frame = CGRectMake(xOffset, (OrderInfoFoodCellHeight-multiHeight)/2, multiWidth, multiHeight);
        [_multi setBackgroundColor:[UIColor clearColor]];
        [_multi setTextAlignment:NSTextAlignmentCenter];
        [_multi setFont:[UIFont systemFontOfSize:13.0]];
        [self.contentView addSubview:_multi];
        
        xOffset += multiWidth;
        CGFloat moneyWidth = 110;
        CGFloat moneyHeight = 15;
        _money = [[WXUILabel alloc] init];
        _money.frame = CGRectMake(xOffset, (OrderInfoFoodCellHeight-moneyHeight)/2, moneyWidth, moneyHeight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setFont:[UIFont systemFontOfSize:15.0]];
        [_money setTextColor:[UIColor redColor]];
        [_money setTextColor:WXColorWithInteger(0xFF5566)];
        [self.contentView addSubview:_money];
    }
    return self;
}

-(void)load{
    NSDictionary *dic = self.cellInfo;
    [_name setText:[dic objectForKey:@"name"]];
    [_number setText:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"num"] integerValue]]];
    [_multi setText:@"X"];
    float price = [[dic objectForKey:@"price"] floatValue];
    NSString *name = [dic objectForKey:@"meterage_name"];
    NSString *allName = [self meterageNameWithOrderList:price withName:name];
    [_money setText:allName];
}

-(NSString *)meterageNameWithOrderList:(float)price withName:(NSString*)name{
	NSString *priceString = [NSString stringWithFormat:@"%@",[UtilTool convertFloatToString:price]];
	NSString *desc = [NSString stringWithFormat:@"￥%@",priceString];
    if (name.length > 0){
        desc = [NSString stringWithFormat:@"%@/%@",desc,name];
    }
    return desc;
}

-(void)buttonImageClicked:(id)sender{
    
}

@end
