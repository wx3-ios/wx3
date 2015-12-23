//
//  LMApplyRefundStateCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMApplyRefundStateCell.h"
#import "LMOrderListEntity.h"

@interface LMApplyRefundStateCell(){
    UILabel *_infoLabel;
    UILabel *_moneyLabel;
}
@end

@implementation LMApplyRefundStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat infoWidth = 120;
        CGFloat infoHeight = 25;
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xOffset, (LMApplyRefundStateCellHeight-infoHeight)/2, infoWidth, infoHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setTextColor:WXColorWithInteger(0x000000)];
        [_infoLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_infoLabel];
        
        CGFloat moneyWidth = 150;
        CGFloat moneyHeight = 25;
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-moneyWidth, (LMApplyRefundStateCellHeight-moneyHeight)/2, moneyWidth, moneyHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneyLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [_infoLabel setText:[self refundStateWithType:entity]];
    [_moneyLabel setText:[NSString stringWithFormat:@"应退款:%.2f元",entity.refundMoney]];
}

-(NSString *)refundStateWithType:(LMOrderListEntity*)entity{
    NSString *str = nil;
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Normal){
        str = @"已申请退款";
    }
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Agree){
        str = @"退款中";
    }
    if(entity.refundState == LMRefund_State_HasDone){
        str = @"已退款";
    }
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Refuse){
        str = @"拒绝退款";
    }
    return str;
}

@end
