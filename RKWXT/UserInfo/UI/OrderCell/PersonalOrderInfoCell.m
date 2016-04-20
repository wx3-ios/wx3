//
//  PersonalOrderInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonalOrderInfoCell.h"

@implementation PersonalOrderInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat btnWidth = 68;
        CGFloat btnHeight = 50;
        CGFloat xOffset = (IPHONE_SCREEN_WIDTH-4*btnWidth)/5;
        WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cartBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [cartBtn setImage:[UIImage imageNamed:@"ShoppingCartImg.png"] forState:UIControlStateNormal];
        [cartBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 30, btnHeight/2, 0))];
        [cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
        [cartBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [cartBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [cartBtn.titleLabel setFont:WXFont(13.0)];
        [cartBtn addTarget:self action:@selector(toMyShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cartBtn];
        
        CGFloat xGap = xOffset+btnWidth;
        WXUIButton *waitPayBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitPayBtn.frame = CGRectMake(xGap, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [waitPayBtn setImage:[UIImage imageNamed:@"WaitingPayImg.png"] forState:UIControlStateNormal];
        [waitPayBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 35, btnHeight/2, 0))];
        [waitPayBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [waitPayBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitPayBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitPayBtn.titleLabel setFont:WXFont(13.0)];
        [waitPayBtn addTarget:self action:@selector(waitPay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitPayBtn];
        
        xGap += btnWidth+xOffset;
        WXUIButton *waitRecBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitRecBtn.frame = CGRectMake(xGap, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [waitRecBtn setImage:[UIImage imageNamed:@"WaitGainGoods.png"] forState:UIControlStateNormal];
        [waitRecBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 32, btnHeight/2, 0))];
        [waitRecBtn setTitle:@"待收货" forState:UIControlStateNormal];
        [waitRecBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitRecBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitRecBtn.titleLabel setFont:WXFont(13.0)];
        [waitRecBtn addTarget:self action:@selector(waitReceive) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitRecBtn];
        
        xGap += btnWidth+xOffset;
        WXUIButton *waitEvlBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitEvlBtn.frame = CGRectMake(xGap, (PersonalOrderInfoCellHeight-btnHeight)/2+3, btnWidth, btnHeight);
        [waitEvlBtn setImage:[UIImage imageNamed:@"WaitEvaluateImgOrder.png"] forState:UIControlStateNormal];
        [waitEvlBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 32, btnHeight/2, 0))];
        [waitEvlBtn setTitle:@"待评价" forState:UIControlStateNormal];
        [waitEvlBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitEvlBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitEvlBtn.titleLabel setFont:WXFont(13.0)];
        [waitEvlBtn addTarget:self action:@selector(waitEvaluate) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitEvlBtn];
    }
    return self;
}

-(void)load{

}

-(void)toMyShoppingCart{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToShoppingCart)]){
        [_delegate personalInfoToShoppingCart];
    }
}

-(void)waitPay{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToWaitPayOrderList)]){
        [_delegate personalInfoToWaitPayOrderList];
    }
}

-(void)waitReceive{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToWaitReceiveOrderList)]){
        [_delegate personalInfoToWaitReceiveOrderList];
    }
}

-(void)waitEvaluate{
    if(_delegate && [_delegate respondsToSelector:@selector(personalInfoToWaitEvaluateOrderList)]){
        [_delegate personalInfoToWaitEvaluateOrderList];
    }
}

@end
