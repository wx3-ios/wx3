//
//  LMOrderInfoMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoMoneyCell.h"
#import "LMOrderListEntity.h"

@interface LMOrderInfoMoneyCell(){
    WXUILabel *carriageLabel;
    WXUILabel *moneyLabel;
    WXUILabel *activityLabel;
}
@end

@implementation LMOrderInfoMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat yOffset = 8;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 18;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [nameLabel setFont:WXFont(13.0)];
        [nameLabel setText:@"运费"];
        [self.contentView addSubview:nameLabel];
        
        carriageLabel = [[WXUILabel alloc] init];
        carriageLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-100, yOffset, 100, labelHeight);
        [carriageLabel setBackgroundColor:[UIColor clearColor]];
        [carriageLabel setTextAlignment:NSTextAlignmentRight];
        [carriageLabel setFont:WXFont(13.0)];
        [carriageLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:carriageLabel];
        
        yOffset += labelHeight+8;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [textLabel setFont:WXFont(13.0)];
        [textLabel setText:@"实付款(含运费)"];
        [self.contentView addSubview:textLabel];
        
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-100, yOffset, 100, labelHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextAlignment:NSTextAlignmentRight];
        [moneyLabel setFont:WXFont(13.0)];
        [moneyLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:moneyLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [carriageLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.carriageMoney]];
    [moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",entity.payMoney]];
}

@end
