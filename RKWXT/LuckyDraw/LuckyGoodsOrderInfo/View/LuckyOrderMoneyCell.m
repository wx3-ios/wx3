//
//  LuckyOrderMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderMoneyCell.h"

@interface LuckyOrderMoneyCell(){
    UILabel *_moneyLabel;
    UILabel *_totalMoney;
}
@end

@implementation LuckyOrderMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat freLabelWidth = 60;
        CGFloat freLabelHeight = 20;
        UILabel *frelabel = [[UILabel alloc] init];
        frelabel.frame = CGRectMake(xOffset, yOffset, freLabelWidth, freLabelHeight);
        [frelabel setBackgroundColor:[UIColor clearColor]];
        [frelabel setText:@"运费"];
        [frelabel setTextAlignment:NSTextAlignmentLeft];
        [frelabel setTextColor:WXColorWithInteger(0x848484)];
        [frelabel setFont:WXFont(12)];
        [self.contentView addSubview:frelabel];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-freLabelWidth, yOffset, freLabelWidth, freLabelHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_moneyLabel setTextColor:WXColorWithInteger(0x000000)];
        [_moneyLabel setFont:WXFont(12)];
        [self.contentView addSubview:_moneyLabel];
        
        yOffset += freLabelHeight;
        CGFloat labelWidth = 70;
        UILabel *totallabel = [[UILabel alloc] init];
        totallabel.frame = CGRectMake(xOffset, yOffset, labelWidth, freLabelHeight);
        [totallabel setBackgroundColor:[UIColor clearColor]];
        [totallabel setText:@"实付款"];
        [totallabel setTextAlignment:NSTextAlignmentLeft];
        [totallabel setTextColor:WXColorWithInteger(0x848484)];
        [totallabel setFont:WXFont(12)];
        [self.contentView addSubview:totallabel];
        
        _totalMoney = [[UILabel alloc] init];
        _totalMoney.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-freLabelWidth, yOffset, labelWidth, freLabelHeight);
        [_totalMoney setBackgroundColor:[UIColor clearColor]];
        [_totalMoney setTextAlignment:NSTextAlignmentRight];
        [_totalMoney setTextColor:WXColorWithInteger(0xdd2726)];
        [_totalMoney setFont:WXFont(12)];
        [self.contentView addSubview:_totalMoney];
    }
    return self;
}

-(void)load{
    
}

@end
