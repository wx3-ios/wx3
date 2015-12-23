//
//  LMWaitReceiveOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMWaitReceiveOrderShopCell.h"
#import "LMOrderListEntity.h"

@interface LMWaitReceiveOrderShopCell(){
    WXUILabel *nameLabel;
    WXUIImageView *arrowImgView;
    WXUILabel *stateLabel;
}
@end

@implementation LMWaitReceiveOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 15;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LMWaitReceiveOrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"LMSellerIcon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat nameLabelWidth = 150;
        CGFloat nameLabelheight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMWaitReceiveOrderShopCellHeight-nameLabelheight)/2, nameLabelWidth, nameLabelheight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameLabelWidth+10;
        CGFloat width = 8;
        CGFloat height = 12;
        arrowImgView = [[WXUIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (LMWaitReceiveOrderShopCellHeight-height)/2, width, height);
        [arrowImgView setBackgroundColor:[UIColor clearColor]];
        [arrowImgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:arrowImgView];
        
        CGFloat stateLabelWidth = 100;
        CGFloat statelabelHeight = 20;
        stateLabel = [[WXUILabel alloc] init];
        stateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-stateLabelWidth, (LMWaitReceiveOrderShopCellHeight-statelabelHeight)/2, stateLabelWidth, statelabelHeight);
        [stateLabel setBackgroundColor:[UIColor clearColor]];
        [stateLabel setTextAlignment:NSTextAlignmentRight];
        [stateLabel setFont:WXFont(10.0)];
        [stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:stateLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    
    [nameLabel setText:entity.shopName];
    
    CGRect rect = nameLabel.frame;
    rect.size.width = [NSString widthForString:entity.shopName fontSize:15.0 andHeight:20];
    [nameLabel setFrame:rect];
    
    CGRect rect1 = arrowImgView.frame;
    rect1.origin.x = rect.size.width+rect.origin.x+10;
    [arrowImgView setFrame:rect1];
    
    [stateLabel setText:[self orderState:entity]];
}

-(NSString*)orderState:(LMOrderListEntity*)entity{
    NSString *orderState = nil;
    if(entity.orderState == LMorder_State_Cancel){
        return @"订单已关闭";
    }
    if(entity.orderState == LMorder_State_Complete){
        return @"订单已完成";
    }
    if(entity.orderState == LMorder_State_None){
        return @"订单交易中";
    }
    //订单可操作，未付款
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_WaitPay){
        return @"订单未支付";
    }
    //订单已付款，可操作，未发货
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_HasPay && entity.sendType == LMorder_SendType_WaitSend){
        NSInteger count = 0;
        for(LMOrderListEntity *ent in entity.goodsListArr){
            if(ent.refundState == LMRefund_State_Being){
                count++;
            }
            //全部申请退款
            if(count==entity.goodsListArr.count){
                return @"订单退款中";
            }
        }
        return @"订单待发货";
    }
    //订单已付款，可操作，已发货
    if(entity.orderState == LMorder_State_Normal && entity.payType == LMorder_PayType_HasPay && entity.sendType == LMorder_SendType_HasSend){
        NSInteger number1 = 0;
        NSInteger number2 = 0;
        NSInteger number3 = 0;
        NSInteger number4 = 0;
        for(LMOrderListEntity *ent in entity.goodsListArr){
            if(ent.refundState == LMRefund_State_Being && ent.shopDealType == LMShopDeal_Refund_Normal){
                number1++;
            }
            if(number1==entity.goodsListArr.count){
                return @"订单已申请退款";
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
                return @"订单已退款";
            }
            if(ent.refundState == LMRefund_State_Being && ent.shopDealType == LMShopDeal_Refund_Agree){
                number4++;
            }
            if(number4==entity.goodsListArr.count){
                return @"订单退款中";
            }
        }
        return @"订单已发货";
    }
    
    return orderState;
}

@end
