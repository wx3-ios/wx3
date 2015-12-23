//
//  LMOrderInfoContactShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoContactShopCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoContactShopCell(){
    WXUIButton *refundBtn;
}
@end

@implementation LMOrderInfoContactShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat btnWidth = (IPHONE_SCREEN_WIDTH-3*xOffset)/2;
        CGFloat btnHeight = 35;
        refundBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        refundBtn.frame = CGRectMake(xOffset, (LMOrderInfoContactShopCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [refundBtn setBackgroundColor:[UIColor whiteColor]];
        [refundBtn setBorderRadian:3.0 width:1.0 color:[UIColor grayColor]];
        [refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [refundBtn setTitleColor:WXColorWithInteger(0x43433e) forState:UIControlStateNormal];
        [refundBtn setHidden:YES];
        [refundBtn addTarget:self action:@selector(refundBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:refundBtn];
        
        WXUIButton *callBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth-xOffset, (LMOrderInfoContactShopCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [callBtn setBackgroundColor:[UIColor whiteColor]];
        [callBtn setBorderRadian:3.0 width:1.0 color:[UIColor grayColor]];
        [callBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [callBtn setTitleColor:WXColorWithInteger(0x43433e) forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:callBtn];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [self setRefundBtnState:entity];
}

-(void)setRefundBtnState:(LMOrderListEntity*)entity{
    if(entity.payType == LMorder_PayType_HasPay && entity.orderState == LMorder_State_Normal){
        for(LMOrderListEntity *ent in entity.goodsListArr){
            if(ent.refundState == LMRefund_State_Normal){
                [refundBtn setHidden:NO];
                break;
            }
        }
    }
}

-(void)callBtnClicked{
    LMOrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(contactSellerWith:)]){
        [_delegate contactSellerWith:entity.shopPhone];
    }
}

-(void)refundBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(userRefundBtnClicked)]){
        [_delegate userRefundBtnClicked];
    }
}

@end
