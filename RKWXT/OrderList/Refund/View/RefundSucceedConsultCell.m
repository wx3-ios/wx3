//
//  RefundSucceedConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/7/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundSucceedConsultCell.h"
#import "RefundStateEntity.h"

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
    RefundStateEntity *entity = self.cellInfo;
    [_infoLabel setText:[self refundStateWithType:entity.refund_type]];
    [_moneyLabel setText:[NSString stringWithFormat:@"应退款:%@元",entity.refund_total_money]];
}

-(NSString *)refundStateWithType:(Refund_Type)type{
    NSString *str = nil;
    switch (type) {
        case Refund_Type_Normal:
            str = @"待处理";
            break;
        case Refund_Type_Agree:
            str = @"退款中";
            break;
        case Refund_Type_Refuse:
            str = @"已拒绝";
            break;
        default:
            break;
    }
    return str;
}

@end
