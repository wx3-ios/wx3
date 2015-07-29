//
//  OrderInfoStateCell.m
//  RKWXT
//
//  Created by SHB on 15/7/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderInfoStateCell.h"
#import "OrderListEntity.h"

@interface OrderInfoStateCell(){
    UILabel *_stateLabel;
}
@end

@implementation OrderInfoStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 6;
        CGFloat imgWidth = 14;
        CGFloat imgHeight = imgWidth;
        UIImage *img = [UIImage imageNamed:@"OrderInfoState.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+8;
        CGFloat labelWidth = 52;
        CGFloat labelHeight = 10;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:@"订单状态:"];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:WXFont(12.0)];
        [self.contentView addSubview:label];
        
        xOffset += labelWidth+4;
        CGFloat stateWidth = 100;
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-labelHeight)/2, stateWidth, labelHeight);
        [_stateLabel setBackgroundColor:[UIColor clearColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentLeft];
        [_stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_stateLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_stateLabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    [_stateLabel setText:[self orderStatusWith:entity]];
}

-(NSString*)orderStatusWith:(OrderListEntity*)entity{
    NSString *status = nil;
    
    if(entity.order_status == Order_Status_Complete){
        return @"订单已完成";
    }
    if(entity.order_status == Order_Status_Cancel){
        return @"订单已关闭";
    }
    if(entity.order_status == Order_Status_None){
        return @"订单交易中";
    }
    if(entity.pay_status == Pay_Status_WaitPay){
        return @"订单未付款";
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_WaitSend){
        return @"订单未发货";
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend){
        return @"订单已发货";
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Normal){
        return @"已申请退款";
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Agree){
        return @"已同意退款";
    }
    if(entity.refund_status == Refund_Status_Being && entity.refund_status == ShopDeal_Refund_Refuse){
        return @"已拒绝退款";
    }
    if(entity.refund_status == Refund_Status_HasDone){
        return @"订单已退款";
    }
    
    return status;
}

@end
