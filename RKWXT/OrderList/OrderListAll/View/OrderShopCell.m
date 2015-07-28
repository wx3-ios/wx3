//
//  OrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderShopCell.h"
#import "WXRemotionImgBtn.h"
#import "OrderListEntity.h"

@interface OrderShopCell(){
    WXRemotionImgBtn *_shopLogoImg;
    UILabel *_shopNameLabel;
    UIImageView *_nextImg;
    UILabel *_orderPayStatus;
}
@end

@implementation OrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        _shopLogoImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_shopLogoImg setUserInteractionEnabled:NO];
        [_shopLogoImg setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:_shopLogoImg];
        
        xOffset += imgWidth+6;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 15;
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.frame = CGRectMake(xOffset, (OrderShopCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [_shopNameLabel setBackgroundColor:[UIColor clearColor]];
        [_shopNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_shopNameLabel setTextColor:WXColorWithInteger(0x202020)];
        [_shopNameLabel setFont:WXTFont(14.0)];
        [self.contentView addSubview:_shopNameLabel];
        
        xOffset += nameWidth+5;
        CGFloat arrowWidth = 8;
        CGFloat arrowHeight = 6;
        _nextImg = [[UIImageView alloc] init];
        _nextImg.frame = CGRectMake(xOffset, (OrderShopCellHeight-arrowHeight)/2, arrowWidth, arrowHeight);
        [_nextImg setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
//        [self.contentView addSubview:_nextImg];
        
        CGFloat xgap = 15;
        CGFloat statusWidth = 100;
        CGFloat statusHeight = 20;
        _orderPayStatus = [[UILabel alloc] init];
        _orderPayStatus.frame = CGRectMake(size.width-xgap-statusWidth, (OrderShopCellHeight-statusHeight)/2, statusWidth, statusHeight);
        [_orderPayStatus setBackgroundColor:[UIColor clearColor]];
        [_orderPayStatus setTextAlignment:NSTextAlignmentRight];
        [_orderPayStatus setTextColor:WXColorWithInteger(0xdd2726)];
        [_orderPayStatus setFont:WXTFont(11.0)];
        [self.contentView addSubview:_orderPayStatus];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    [_shopNameLabel setText:[NSString stringWithFormat:@"查看订单详情"]];
//    NSString *str = (entity.pay_status == Pay_Status_WaitPay?@"待付款":@"已付款");
    [_orderPayStatus setText:[self orderStatusWith:entity]];
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
