//
//  RefundSucceedConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/7/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundSucceedConsultCell.h"
#import "OrderListEntity.h"

@interface RefundSucceedConsultCell(){
    UILabel *_infoLabel;
    UILabel *_moneyLabel;
}
@end

@implementation RefundSucceedConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat infoWidth = 120;
        CGFloat infoHeight = 25;
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xOffset, (RefundSucceedConsultCellHeight-infoHeight)/2, infoWidth, infoHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setTextColor:WXColorWithInteger(0x000000)];
        [_infoLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_infoLabel];
        
        CGFloat moneyWidth = 150;
        CGFloat moneyHeight = 25;
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-moneyWidth, (RefundSucceedConsultCellHeight-moneyHeight)/2, moneyWidth, moneyHeight);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneyLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    [_infoLabel setText:[self refundStateWithType:entity]];
    [_moneyLabel setText:[NSString stringWithFormat:@"应退款:%.2f元",entity.refundTotalMoney]];
}

-(NSString *)refundStateWithType:(OrderListEntity*)entity{
    NSString *str = nil;
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Normal){
        str = @"已申请退款";
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Agree){
        str = @"退款中";
    }
    if(entity.refund_status == Refund_Status_HasDone){
        str = @"已退款";
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Refuse){
        str = @"拒绝退款";
    }
    return str;
}

@end
