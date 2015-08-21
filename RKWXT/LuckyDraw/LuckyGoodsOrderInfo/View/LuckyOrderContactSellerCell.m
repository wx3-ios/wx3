//
//  LuckyOrderContactSellerCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderContactSellerCell.h"
#import "LuckyOrderEntity.h"

@interface LuckyOrderContactSellerCell(){
    WXUIButton *rightBtn;
}
@end

@implementation LuckyOrderContactSellerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-3*xOffset)/2;
        CGFloat btnHeight = 34;
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(xOffset, (LuckyOrderContactSellerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [leftBtn setBackgroundColor:WXColorWithInteger(0x848484)];
        [leftBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [leftBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:leftBtn];
        
        rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, (LuckyOrderContactSellerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [rightBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
    }
    return self;
}

-(void)load{
    LuckyOrderEntity *entity = self.cellInfo;
    [self orderTypeWith:entity.pay_status withSendStatus:entity.send_status WithOrderStatus:entity.order_status];
}

-(void)orderTypeWith:(LuckyOrder_Pay)payStatus withSendStatus:(LuckyOrder_Send)sendStatus WithOrderStatus:(LuckyOrder_Status)orderStatus{
    NSString *str = nil;
    if(orderStatus == LuckyOrder_Status_Done){
        str = @"已完成";
        [rightBtn setTitle:str forState:UIControlStateNormal];
        [rightBtn setEnabled:NO];
        [rightBtn setBackgroundColor:WXColorWithInteger(0x848484)];
        return;
    }
    if(orderStatus == LuckyOrder_Status_Close){
        str = @"已关闭";
        [rightBtn setTitle:str forState:UIControlStateNormal];
        [rightBtn setEnabled:NO];
        [rightBtn setBackgroundColor:WXColorWithInteger(0x848484)];
        return;
    }
    if(payStatus == LuckyOrder_Pay_Wait){
        str = @"去支付";
        [rightBtn setTitle:str forState:UIControlStateNormal];
        [rightBtn setEnabled:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        return;
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Wait){
        str = @"待发货";
        [rightBtn setTitle:str forState:UIControlStateNormal];
        [rightBtn setEnabled:NO];
        [rightBtn setBackgroundColor:WXColorWithInteger(0x848484)];
        return;
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Done){
        str = @"确认收货";
        [rightBtn setTitle:str forState:UIControlStateNormal];
        [rightBtn setEnabled:YES];
        [rightBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        return;
    }
}

-(void)leftBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(luckyOrderLeftBtnClicked)]){
        [_delegate luckyOrderLeftBtnClicked];
    }
}

-(void)rightBtnClicked{
    LuckyOrderEntity *entity = self.cellInfo;
    if(entity.pay_status == LuckyOrder_Pay_Wait){
        if(_delegate && [_delegate respondsToSelector:@selector(luckyOrderPayBtnClicked)]){
            [_delegate luckyOrderPayBtnClicked];
        }
    }
    if(entity.pay_status == LuckyOrder_Pay_Done && entity.send_status == LuckyOrder_Send_Done){
        if(_delegate && [_delegate respondsToSelector:@selector(luckyOrderCompleteBtnClicked)]){
            [_delegate luckyOrderCompleteBtnClicked];
        }
    }
}

@end
