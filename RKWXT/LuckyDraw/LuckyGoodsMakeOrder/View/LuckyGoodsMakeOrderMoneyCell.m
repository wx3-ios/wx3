//
//  LuckyGoodsMakeOrderMoneyCell.m
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsMakeOrderMoneyCell.h"
#import "GoodsInfoEntity.h"

@interface LuckyGoodsMakeOrderMoneyCell(){
    WXUILabel *_moneyLabel;
}
@end

@implementation LuckyGoodsMakeOrderMoneyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 15;
        CGFloat yOffset = 15;
        CGFloat width = 65;
        CGFloat height = 20;
        WXUILabel *text1Label = [[WXUILabel alloc] init];
        text1Label.frame = CGRectMake(xOffset, yOffset, width, height);
        [text1Label setBackgroundColor:[UIColor clearColor]];
        [text1Label setTextAlignment:NSTextAlignmentLeft];
        [text1Label setTextColor:WXColorWithInteger(0x646464)];
        [text1Label setFont:WXFont(15.0)];
        [text1Label setText:@"商品总额"];
        [self.contentView addSubview:text1Label];
        
        yOffset += height;
        WXUILabel *text2label = [[WXUILabel alloc] init];
        text2label.frame = CGRectMake(xOffset, yOffset, width, height);
        [text2label setBackgroundColor:[UIColor clearColor]];
        [text2label setTextAlignment:NSTextAlignmentLeft];
        [text2label setTextColor:WXColorWithInteger(0x646464)];
        [text2label setFont:WXFont(12.0)];
        [text2label setText:@"+运费"];
        [self.contentView addSubview:text2label];
        
        yOffset -= height;
        WXUILabel *text3label = [[WXUILabel alloc] init];
        text3label.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-width, yOffset, width, height);
        [text3label setBackgroundColor:[UIColor clearColor]];
        [text3label setTextAlignment:NSTextAlignmentRight];
        [text3label setTextColor:WXColorWithInteger(0xdd2726)];
        [text3label setFont:WXFont(13.0)];
        [text3label setText:@"￥0.00"];
        [self.contentView addSubview:text3label];
        
        yOffset += height;
        _moneyLabel = [[WXUILabel alloc] init];
        _moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-width, yOffset, width, height);
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [_moneyLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    NSString *money = self.cellInfo;
    [_moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",[money floatValue]]];
}

@end
