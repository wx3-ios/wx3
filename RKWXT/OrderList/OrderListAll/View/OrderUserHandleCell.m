//
//  OrderUserHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderUserHandleCell.h"
#import "OrderListEntity.h"

@interface OrderUserHandleCell(){
    WXUIButton *_button1;
    WXUIButton *_button2;
}
@end

@implementation OrderUserHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 88;
        CGFloat btnWidth = 75;
        CGFloat btnHeight = 30;
        _button1 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _button1.frame = CGRectMake(size.width-xOffset, (OrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [_button1 setBorderRadian:4.0 width:0.5 color:[UIColor clearColor]];
        [_button1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [_button1.titleLabel setFont:WXFont(15.0)];
        [_button1 addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button1];
        
        _button2 = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _button2.frame = CGRectMake(size.width-xOffset-btnWidth-10, (OrderHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
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
    OrderListEntity *entity = self.cellInfo;
    [self showNameInBtnWith:entity];
}

-(void)showNameInBtnWith:(OrderListEntity*)entity{
    if(entity.order_status == Order_Status_Cancel){
        [_button1 setHidden:NO];
        [_button2 setHidden:YES];
        [_button1 setTitle:@"已关闭" forState:UIControlStateNormal];
        [_button1 setEnabled:NO];
        [_button1 setBackgroundColor:WXColorWithInteger(0xa5a3a3)];
        return;
    }
    if(entity.order_status == Order_Status_Complete){
        [_button1 setHidden:NO];
        [_button2 setHidden:YES];
        [_button1 setTitle:@"已完成" forState:UIControlStateNormal];
        [_button1 setEnabled:NO];
        [_button1 setBackgroundColor:WXColorWithInteger(0xa5a3a3)];
        return;
    }
    if(entity.order_status == Order_Status_None){
        [_button1 setHidden:NO];
        [_button2 setHidden:YES];
        [_button1 setBackgroundColor:WXColorWithInteger(0xa5a3a3)];
        [_button1 setTitle:@"交易中" forState:UIControlStateNormal];
        return;
    }
    
    NSString *str1 = nil;
    NSString *str2 = nil;
    [_button1 setEnabled:YES];
    [_button2 setEnabled:YES];
    NSInteger num = 0;
    for(OrderListEntity *ent in entity.goodsArr){
        if(ent.refund_status != Refund_Status_Normal){
            num++;
        }
    }
    [_button1 setEnabled:YES];
    if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){   //去支付和取消订单共存
        [_button1 setHidden:NO];
        [_button2 setHidden:NO];
        str1 = @"去支付";
        str2 = @"取消订单";
    }
    
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_WaitSend && entity.order_status == Order_Status_Normal){
        [_button1 setHidden:NO];
        [_button2 setHidden:YES];
        str1 = @"退款";
        
        if(num == [entity.goodsArr count]){
            [_button1 setHidden:YES];
            [_button2 setHidden:YES];
        }
    }
    
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend && entity.order_status == Order_Status_Normal){
        [_button1 setHidden:NO];
        [_button2 setHidden:NO];
        str1 = @"确认收货";
        str2 = @"退款";
        
        if(num == [entity.goodsArr count]){
            [_button2 setHidden:YES];
        }
    }
    
    [_button1 setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [_button1 setTitle:str1 forState:UIControlStateNormal];
    [_button2 setTitle:str2 forState:UIControlStateNormal];
}

-(void)button1Clicked{
    OrderListEntity *entity = self.cellInfo;
    if(entity.pay_status == Pay_Status_WaitPay && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userPayBtnClicked:)]){
            [_delegate userPayBtnClicked:entity];
        }
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_WaitSend && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userRefundBtnClicked:)]){
            [_delegate userRefundBtnClicked:entity];
        }
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userCompleteBtnClicked:)]){
            [_delegate userCompleteBtnClicked:entity];
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
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_WaitSend && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userRefundBtnClicked:)]){
            [_delegate userRefundBtnClicked:entity];
        }
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend && entity.order_status == Order_Status_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userRefundBtnClicked:)]){
            [_delegate userRefundBtnClicked:entity];
        }
    }
}

@end
