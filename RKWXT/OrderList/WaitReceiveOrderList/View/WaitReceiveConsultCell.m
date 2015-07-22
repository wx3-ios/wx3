//
//  WaitReceiveConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveConsultCell.h"
#import "OrderListEntity.h"

@interface WaitReceiveConsultCell(){
    UILabel *_consult;
    WXUIButton *_payBtn;
    WXUIButton *_button2;
    
    NSInteger number;
    CGFloat price;
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
        CGFloat btnWidth = 80;
        _payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(size.width-xGap-btnWidth, (WaitReceiveConsultCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_payBtn setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_payBtn addTarget:self action:@selector(receiveGoods) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn.titleLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_payBtn];
        
        _button2 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(size.width-xGap-2*btnWidth-10, (WaitReceiveConsultCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_button2 setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_button2 setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_button2 setHidden:YES];
        [_button2.titleLabel setFont:WXFont(12.0)];
        [_button2 addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button2];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    for(OrderListEntity *ent in entity.goodsArr){
        number += ent.sales_num;
        price += ent.factPayMoney;
    }
    [_consult setText:[NSString stringWithFormat:@"￥%.2f",price]];
    number = 0;
    price = 0;
    
    [self showNameInBtnWith:entity];
}

-(void)showNameInBtnWith:(OrderListEntity*)entity{
    if(entity.pay_status == Pay_Status_HasPay && entity.order_status == Order_Status_Normal && entity.goods_status == Goods_Status_HasSend){
        [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_button2 setHidden:NO];
        [_button2 setTitle:@"退款" forState:UIControlStateNormal];
        
        NSInteger num = 0;
        for(OrderListEntity *ent in entity.goodsArr){
            if(ent.refund_status != Refund_Status_Normal){
                num++;
            }
        }
        if(num == [entity.goodsArr count]){
            [_payBtn setHidden:YES];
            [_button2 setHidden:YES];
        }
    }
}

-(void)receiveGoods{
    OrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(receiveOrderBtnClicked:)]){
        [_delegate receiveOrderBtnClicked:entity];
    }
}

-(void)button2Clicked{
    OrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(refundOrderBtnClicked:)]){
        [_delegate refundOrderBtnClicked:entity];
    }
}

@end
