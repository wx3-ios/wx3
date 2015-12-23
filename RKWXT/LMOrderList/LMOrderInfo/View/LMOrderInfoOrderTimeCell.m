//
//  LMOrderInfoOrderTimeCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoOrderTimeCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoOrderTimeCell(){
    WXUILabel *orderLabel;
    WXUILabel *createTime;
    WXUILabel *carriageName;
    WXUILabel *carriageNum;
}
@end

@implementation LMOrderInfoOrderTimeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH;
        CGFloat labelHeight = 15;
        CGFloat yGap = (LMOrderInfoOrderTimeCellHieght-4*labelHeight)/5;
        CGFloat yOffset = yGap;
        orderLabel = [[WXUILabel alloc] init];
        orderLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [orderLabel setBackgroundColor:[UIColor clearColor]];
        [orderLabel setTextAlignment:NSTextAlignmentLeft];
        [orderLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [orderLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:orderLabel];
        
        yOffset += labelHeight+yGap;
        createTime = [[WXUILabel alloc] init];
        createTime.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [createTime setBackgroundColor:[UIColor clearColor]];
        [createTime setTextAlignment:NSTextAlignmentLeft];
        [createTime setTextColor:WXColorWithInteger(0x9b9b9b)];
        [createTime setFont:WXFont(11.0)];
        [self.contentView addSubview:createTime];
        
        yOffset += labelHeight+yGap;
        carriageName = [[WXUILabel alloc] init];
        carriageName.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [carriageName setBackgroundColor:[UIColor clearColor]];
        [carriageName setTextAlignment:NSTextAlignmentLeft];
        [carriageName setTextColor:WXColorWithInteger(0x9b9b9b)];
        [carriageName setFont:WXFont(11.0)];
        [self.contentView addSubview:carriageName];
        
        yOffset += labelHeight+yGap;
        carriageNum = [[WXUILabel alloc] init];
        carriageNum.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [carriageNum setBackgroundColor:[UIColor clearColor]];
        [carriageNum setTextAlignment:NSTextAlignmentLeft];
        [carriageNum setTextColor:WXColorWithInteger(0x9b9b9b)];
        [carriageNum setFont:WXFont(11.0)];
        [self.contentView addSubview:carriageNum];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [orderLabel setText:[NSString stringWithFormat:@"订单编号 %ld",(long)entity.orderId]];
    [createTime setText:[NSString stringWithFormat:@"下单时间 %@",[UtilTool getDateTimeFor:entity.addTime type:2]]];
    [carriageName setText:[NSString stringWithFormat:@"快递公司 %@",entity.sendName]];
    [carriageNum setText:[NSString stringWithFormat:@"快递单号 %@",entity.sendNumber]];
}

@end
