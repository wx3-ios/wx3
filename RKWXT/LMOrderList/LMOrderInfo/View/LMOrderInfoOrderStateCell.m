//
//  LMOrderInfoOrderStateCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoOrderStateCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoOrderStateCell(){
    WXUILabel *nameLabel;
}
@end

@implementation LMOrderInfoOrderStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 16;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"OrderInfoState.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+3;
        CGFloat labelWidth = 56;
        CGFloat labelHeight = 16;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x000000)];
        [textLabel setText:@"订单状态"];
        [textLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:textLabel];
        
        xOffset += labelWidth+5;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMOrderInfoOrderStateCellHeight-labelHeight)/2, 150, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:WXFont(13.0)];
        [nameLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [nameLabel setText:[self orderState:entity]];
}

-(NSString*)orderState:(LMOrderListEntity*)entity{
    NSString *orderState = nil;
    if(entity.orderState == LMorder_State_Cancel){
        return @"已关闭";
    }
    if(entity.orderState == LMorder_State_Complete){
        return @"已完成";
    }
    //订单可操作，未付款
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_WaitPay){
        return @"未支付";
    }
    //订单已付款，可操作，未发货
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_HasPay && entity.sendType == LMorder_SendType_WaitSend){
        return @"待发货";
    }
    //订单已付款，可操作，已发货
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_HasPay && entity.sendType == LMorder_SendType_HasSend){
        return @"已发货";
    }
    //订单不可操作、已付款、未发货
    if(entity.orderState == LMorder_State_None && entity.payType == LMorder_PayType_HasPay){
        NSInteger number1 = 0;
        NSInteger number2 = 0;
        NSInteger number3 = 0;
        NSInteger number4 = 0;
        for(LMOrderListEntity *ent in entity.goodsListArr){
            if(ent.refundState == LMRefund_State_Being && ent.shopDealType == LMShopDeal_Refund_Normal){
                number1++;
            }
            if(number1==entity.goodsListArr.count){
                return @"已申请退款";
            }
            if(ent.refundState == LMRefund_State_Being && ent.shopDealType == LMShopDeal_Refund_Refuse){
                number2++;
            }
            if(number2==entity.goodsListArr.count){
                return @"卖家拒绝退款";
            }
            if(ent.refundState == LMRefund_State_HasDone){
                number3++;
            }
            if(number3==entity.goodsListArr.count){
                return @"已退款";
            }
            if(ent.refundState == LMRefund_State_Being && ent.shopDealType == LMShopDeal_Refund_Agree){
                number4++;
            }
            if(number4==entity.goodsListArr.count){
                return @"退款中";
            }
        }
        return @"交易中";
    }
    
    return orderState;
}

@end
