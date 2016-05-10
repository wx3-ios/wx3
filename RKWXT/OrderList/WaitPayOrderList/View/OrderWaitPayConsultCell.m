//
//  OrderWaitPayConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderWaitPayConsultCell.h"
#import "OrderListEntity.h"

@interface OrderWaitPayConsultCell(){
    UILabel *_consult;
    WXUIButton *_payBtn;
    WXUIButton *_button2;
    
    NSInteger number;
    CGFloat price;
}
@end

@implementation OrderWaitPayConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 12;
        CGFloat textHeight = 16;
        CGFloat textWidth = 50;
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (OrderWaitPayConsultCellHeight-textHeight)/2, textWidth, textHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x6d6d6d)];
        [textLabel setFont:WXTFont(14.0)];
        [textLabel setText:@"待付款:"];
        [self.contentView addSubview:textLabel];
        
        xOffset += textWidth;
        CGFloat priceWidth = 100;
        CGFloat priceheight = 20;
        _consult = [[UILabel alloc] init];
        _consult.frame = CGRectMake(xOffset, (OrderWaitPayConsultCellHeight-priceheight)/2, priceWidth, priceheight);
        [_consult setBackgroundColor:[UIColor clearColor]];
        [_consult setTextAlignment:NSTextAlignmentLeft];
        [_consult setTextColor:WXColorWithInteger(0x000000)];
        [_consult setFont:WXTFont(14.0)];
        [self.contentView addSubview:_consult];
        
        CGFloat xGap = 10;
        CGFloat btnHeight = 28;
        CGFloat btnWidth = 70;
        _payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(size.width-xGap-btnWidth, (OrderWaitPayConsultCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_payBtn setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_payBtn.titleLabel setFont:WXFont(15.0)];
        [_payBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_payBtn];
        
        _button2 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(size.width-xGap-2*btnWidth-10, (OrderWaitPayConsultCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_button2 setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_button2 setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_button2 setHidden:YES];
        [_button2.titleLabel setFont:WXFont(15.0)];
        [_button2 addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button2];
    }
    return self;
}



-(void)load{
    CGFloat payMonery = 0.0;
    CGFloat fact = 0.0f;
    OrderListEntity *entity = self.cellInfo;
    for(OrderListEntity *ent in entity.goodsArr){
        number += ent.sales_num;
        payMonery += ent.shouPayMonery;
        fact += ent.factRedPacket;
    }
    price = payMonery - fact;
    price += entity.postage;
    
    [_consult setText:[NSString stringWithFormat:@"￥%.2f",price]];
    number = 0;
    price = 0;
    
    [self showNameInBtnWith:entity];
}

-(void)showNameInBtnWith:(OrderListEntity*)entity{
    if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){   //去支付和取消订单共存
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_button2 setHidden:NO];
        [_button2 setTitle:@"取消订单" forState:UIControlStateNormal];
    }
}

-(void)payOrder{
    OrderListEntity *entity = self.cellInfo;
    if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userPayBtnClicked:)]){
            [_delegate userPayBtnClicked:entity];
        }
    }
}

-(void)button2Clicked{
    OrderListEntity *entity = self.cellInfo;
    if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userCancelBtnClicked:)]){
            [_delegate userCancelBtnClicked:entity];
        }
    }
}

@end
