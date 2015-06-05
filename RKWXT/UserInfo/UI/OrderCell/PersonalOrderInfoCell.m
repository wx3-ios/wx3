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
        CGFloat xOffset = 30;
        CGFloat btnWidth = 68;
        CGFloat btnHeight = 50;
        WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        cartBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [cartBtn setImage:[UIImage imageNamed:@"ShoppingCartImg.png"] forState:UIControlStateNormal];
        [cartBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 28, btnHeight/2, 0))];
        [cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
        [cartBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [cartBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [cartBtn.titleLabel setFont:WXFont(15.0)];
        [cartBtn addTarget:self action:@selector(toMyShoppingCart) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cartBtn];
        
        
        xOffset += btnWidth+xOffset;
        WXUIButton *waitPayBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitPayBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [waitPayBtn setImage:[UIImage imageNamed:@"WaitingPayImg.png"] forState:UIControlStateNormal];
        [waitPayBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 28, btnHeight/2, 0))];
        [waitPayBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [waitPayBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitPayBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitPayBtn.titleLabel setFont:WXFont(15.0)];
        [waitPayBtn addTarget:self action:@selector(waitPay) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitPayBtn];
        
        xOffset += btnWidth+30;
        WXUIButton *waitRecBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        waitRecBtn.frame = CGRectMake(xOffset, (PersonalOrderInfoCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [waitRecBtn setImage:[UIImage imageNamed:@"WaitGainGoods.png"] forState:UIControlStateNormal];
        [waitRecBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, 32, btnHeight/2, 0))];
        [waitRecBtn setTitle:@"待收货" forState:UIControlStateNormal];
        [waitRecBtn setTitleEdgeInsets:(UIEdgeInsetsMake(20, 0, 0, 0))];
        [waitRecBtn setTitleColor:WXColorWithInteger(0x707070) forState:UIControlStateNormal];
        [waitRecBtn.titleLabel setFont:WXFont(15.0)];
        [waitRecBtn addTarget:self action:@selector(waitReceive) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:waitRecBtn];
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

@end
