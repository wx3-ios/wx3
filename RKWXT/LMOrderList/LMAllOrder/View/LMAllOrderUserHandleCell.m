//
//  LMAllOrderUserHandleCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMAllOrderUserHandleCell.h"
#import "LMOrderListEntity.h"

@interface LMAllOrderUserHandleCell(){
    WXUILabel *pricelabel;
    WXUIButton *leftBtn;
    WXUIButton *rightBtn;
}
@end

@implementation LMAllOrderUserHandleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelHeight = 18;
        CGFloat labelWidth = 50;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (LMAllOrderUserHandleCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setText:@"实付款"];
        [self.contentView addSubview:textLabel];
        
        CGFloat priceLabelWidth = 90;
        pricelabel = [[WXUILabel alloc] init];
        pricelabel.frame = CGRectMake(xOffset+labelWidth, (LMAllOrderUserHandleCellHeight-labelHeight)/2, priceLabelWidth, labelHeight);
        [pricelabel setBackgroundColor:[UIColor clearColor]];
        [pricelabel setTextAlignment:NSTextAlignmentLeft];
        [pricelabel setTextColor:WXColorWithInteger(0x000000)];
        [pricelabel setFont:WXFont(14.0)];
        [self.contentView addSubview:pricelabel];
        
        CGFloat btnWidth = 56;
        CGFloat btnHeight = 24;
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (LMAllOrderUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setHidden:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn.titleLabel setFont:WXFont(10.0)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        
        leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-2*(xOffset+btnWidth), (LMAllOrderUserHandleCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [leftBtn setHidden:YES];
        [leftBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
        [leftBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:leftBtn];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [pricelabel setText:[NSString stringWithFormat:@"￥%.2f",entity.orderMoney+entity.carriageMoney]];
    
    [self userHandleBtnState];
}

-(void)userHandleBtnState{
    LMOrderListEntity *entity = self.cellInfo;
    if(entity.orderState == LMorder_State_Cancel){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
        return;
    }
    if(entity.orderState == LMorder_State_Complete){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
        if(entity.evaluate == LMOrder_Evaluate_None){
            [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
            [rightBtn setHidden:NO];
        }
        return;
    }
    if(entity.orderState == LMorder_State_None){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
        return;
    }
    if(entity.payType == LMorder_PayType_WaitPay && entity.orderState == LMorder_State_Normal){
        [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [leftBtn setHidden:NO];
        [rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
    if(entity.payType == LMorder_PayType_HasPay && entity.sendType == LMorder_SendType_WaitSend){
        [leftBtn setHidden:YES];
        [rightBtn setHidden:YES];
    }
    if(entity.payType == LMorder_PayType_HasPay && entity.orderState == LMorder_State_Normal && entity.sendType == LMorder_SendType_HasSend){
        [leftBtn setHidden:YES];
        [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [rightBtn setHidden:NO];
    }
}

-(void)rightBtnClicked{
    LMOrderListEntity *entity = self.cellInfo;
    if(entity.payType == LMorder_PayType_WaitPay && entity.orderState == LMorder_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userPayOrder:)]){
            [_delegate userPayOrder:entity];
        }
    }
    if(entity.payType == LMorder_PayType_HasPay && entity.orderState == LMorder_State_Normal && entity.sendType == LMorder_SendType_HasSend){
        if(_delegate && [_delegate respondsToSelector:@selector(userCompleteOrder:)]){
            [_delegate userCompleteOrder:entity];
        }
    }
    if(entity.orderState == LMorder_State_Complete && entity.evaluate == LMOrder_Evaluate_None){
        if(_delegate && [_delegate respondsToSelector:@selector(userEvaluateOrder:)]){
            [_delegate userEvaluateOrder:entity];
        }
    }
}

-(void)leftBtnClicked{
    LMOrderListEntity *entity = self.cellInfo;
    if(entity.payType == LMorder_PayType_WaitPay && entity.orderState == LMorder_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(userCancelOrder:)]){
            [_delegate userCancelOrder:entity];
        }
    }
}

@end
