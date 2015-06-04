//
//  WaitReceiveConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveConsultCell.h"

@interface WaitReceiveConsultCell(){
    UILabel *_consult;
    WXUIButton *_payBtn;
}
@end

@implementation WaitReceiveConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 12;
        CGFloat textHeight = 16;
        CGFloat textWidth = 45;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (WaitReceiveConsultCellHeight-textHeight)/2, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x6d6d6d)];
        [textLabel setFont:WXTFont(12.0)];
        [textLabel setText:@"实付款:"];
        [self.contentView addSubview:textLabel];
        
        xOffset += textWidth;
        CGFloat priceWidth = 100;
        CGFloat priceheight = 20;
        _consult = [[UILabel alloc] init];
        _consult.frame = CGRectMake(xOffset, (WaitReceiveConsultCellHeight-priceheight)/2, priceWidth, priceheight);
        [_consult setBackgroundColor:[UIColor clearColor]];
        [_consult setTextAlignment:NSTextAlignmentLeft];
        [_consult setTextColor:WXColorWithInteger(0x000000)];
        [_consult setFont:WXTFont(15.0)];
        [self.contentView addSubview:_consult];
        
        CGFloat xGap = 10;
        CGFloat btnHeight = 28;
        CGFloat btnWidth = 100;
        _payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(size.width-xGap-btnWidth, (WaitReceiveConsultCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_payBtn setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_payBtn addTarget:self action:@selector(receiveGoods) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.contentView addSubview:_payBtn];
    }
    return self;
}

-(void)load{
    [_consult setText:@"￥148.00"];
}

-(void)receiveGoods{
    
}

@end
