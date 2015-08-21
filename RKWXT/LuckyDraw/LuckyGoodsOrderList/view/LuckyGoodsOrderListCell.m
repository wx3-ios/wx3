//
//  LuckyGoodsOrderListCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderListCell.h"
#import "LuckyOrderEntity.h"
#import "WXRemotionImgBtn.h"

@interface LuckyGoodsOrderListCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_deslabel;
    WXUILabel *_dateLabel;
    WXUILabel *_typeLabel;
}
@end

@implementation LuckyGoodsOrderListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 41;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LuckyGoodsOrderListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+5;
        CGFloat yOffset = 12;
        CGFloat dateLabelWidth = 65;
        CGFloat nameLabelWidth = IPHONE_SCREEN_WIDTH-xOffset-dateLabelWidth-10;
        CGFloat namelabelHeight = 20;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:_nameLabel];
        
        yOffset += namelabelHeight+2;
        CGFloat desLabelHeight = 17;
        _deslabel = [[WXUILabel alloc] init];
        _deslabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, desLabelHeight);
        [_deslabel setBackgroundColor:[UIColor clearColor]];
        [_deslabel setTextAlignment:NSTextAlignmentLeft];
        [_deslabel setTextColor:WXColorWithInteger(0x8e8e8e)];
        [_deslabel setFont:WXFont(12.0)];
        [self.contentView addSubview:_deslabel];
        
        CGFloat xGap = 12;
        CGFloat yGap = 12;
        CGFloat dateLabelHeight = 15;
        _dateLabel = [[WXUILabel alloc] init];
        _dateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-dateLabelWidth, yGap, dateLabelWidth, dateLabelHeight);
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setFont:WXFont(10.0)];
        [_dateLabel setTextColor:WXColorWithInteger(0x8e8e8e)];
        [self.contentView addSubview:_dateLabel];
        
        yGap += dateLabelHeight+5;
        _typeLabel = [[WXUILabel alloc] init];
        _typeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xGap-dateLabelWidth, yGap, dateLabelWidth, dateLabelHeight);
        [_typeLabel setBackgroundColor:[UIColor clearColor]];
        [_typeLabel setTextAlignment:NSTextAlignmentRight];
        [_typeLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_typeLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_typeLabel];
    }
    return self;
}

-(void)load{
    LuckyOrderEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.goods_img];
    [_imgView load];
    
    [_nameLabel setText:entity.goods_name];
    [_deslabel setText:entity.stockName];
    
    NSString *timeStr = [UtilTool getDateTimeFor:entity.makeOrderTime type:2];
    [_dateLabel setText:timeStr];
    
    NSString *type = [self orderTypeWith:entity.pay_status withSendStatus:entity.send_status WithOrderStatus:entity.order_status];
    [_typeLabel setText:type];
}

-(NSString*)orderTypeWith:(LuckyOrder_Pay)payStatus withSendStatus:(LuckyOrder_Send)sendStatus WithOrderStatus:(LuckyOrder_Status)orderStatus{
    NSString *str = nil;
    if(orderStatus == LuckyOrder_Status_Done){
        return @"已完成";
    }
    if(orderStatus == LuckyOrder_Status_Close){
        return @"已关闭";
    }
    if(payStatus == LuckyOrder_Pay_Wait){
        return @"待付款";
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Wait){
        return @"待发货";
    }
    if(payStatus == LuckyOrder_Pay_Done && sendStatus == LuckyOrder_Send_Done){
        return @"待收货";
    }
    
    return str;
}

@end
