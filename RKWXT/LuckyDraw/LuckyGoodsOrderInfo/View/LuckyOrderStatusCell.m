//
//  LuckyOrderStatusCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderStatusCell.h"
#import "LuckyOrderEntity.h"

@interface LuckyOrderStatusCell(){
    UILabel *_stateLabel;
}
@end

@implementation LuckyOrderStatusCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 6;
        CGFloat imgWidth = 14;
        CGFloat imgHeight = imgWidth;
        UIImage *img = [UIImage imageNamed:@"OrderInfoState.png"];
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (LuckyOrderStatusCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+8;
        CGFloat labelWidth = 52;
        CGFloat labelHeight = 10;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (LuckyOrderStatusCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:@"订单状态:"];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:WXFont(12.0)];
        [self.contentView addSubview:label];
        
        xOffset += labelWidth+4;
        CGFloat stateWidth = 100;
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.frame = CGRectMake(xOffset, (LuckyOrderStatusCellHeight-labelHeight)/2, stateWidth, labelHeight);
        [_stateLabel setBackgroundColor:[UIColor clearColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentLeft];
        [_stateLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_stateLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_stateLabel];
    }
    return self;
}

-(void)load{
    LuckyOrderEntity *entity = self.cellInfo;
    
    NSString *type = [self orderTypeWith:entity.pay_status withSendStatus:entity.send_status WithOrderStatus:entity.order_status];
    [_stateLabel setText:type];
}

-(NSString*)orderTypeWith:(LuckyOrder_Pay)payStatus withSendStatus:(LuckyOrder_Send)sendStatus WithOrderStatus:(LuckyOrder_Status)orderStatus{
    NSString *str = nil;
    if(orderStatus == LuckyOrder_Status_Done){
        return @"订单已完成";
    }
    if(orderStatus == LuckyOrder_Status_Close){
        return @"订单已关闭";
    }
    if(payStatus == LuckyOrder_Pay_Wait){
        return @"订单未付款";
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Wait){
        return @"订单未发货";
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Done){
        return @"订单已发货";
    }
    
    return str;
}

@end
