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
        CGFloat imgWidth = 12;
        CGFloat imgHeight = imgWidth;
        UIImage *img = [UIImage imageNamed:@"OrderInfoState.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+8;
        CGFloat labelWidth = 45;
        CGFloat labelHeight = 10;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:@"订单状态:"];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:WXFont(10.0)];
        [self.contentView addSubview:label];
        
        xOffset += labelWidth+4;
        CGFloat stateWidth = 100;
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.frame = CGRectMake(xOffset, (OrderInfoStateCellHeight-labelHeight)/2, stateWidth, labelHeight);
        [_stateLabel setBackgroundColor:[UIColor clearColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentLeft];
        [_stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_stateLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:_stateLabel];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    if(entity.order_status == Order_Status_Cancel){
        [_stateLabel setText:@"订单已关闭"];
        return;
    }
    if(entity.order_status == Order_Status_Complete){
        [_stateLabel setText:@"订单已完成"];
        return;
    }
    if(entity.pay_status == Pay_Status_WaitPay){
        [_stateLabel setText:@"等待付款"];
        return;
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_WaitSend){
        [_stateLabel setText:@"买家已付款"];
        return;
    }
    if(entity.pay_status == Pay_Status_HasPay && entity.goods_status == Goods_Status_HasSend){
        [_stateLabel setText:@"卖家已发货"];
        return;
    }
}

@end
