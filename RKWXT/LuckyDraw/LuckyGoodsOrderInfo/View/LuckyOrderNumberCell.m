//
//  LuckyOrderNumberCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderNumberCell.h"

@interface LuckyOrderNumberCell(){
    WXUILabel *_orderIDLabel;
    WXUILabel *_orderType;
    WXUILabel *_numberLabel;
}
@end

@implementation LuckyOrderNumberCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH/2;
        CGFloat labelHeight = 18;
        _orderIDLabel = [[WXUILabel alloc] init];
        _orderIDLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_orderIDLabel setBackgroundColor:[UIColor clearColor]];
        [_orderIDLabel setTextAlignment:NSTextAlignmentLeft];
        [_orderIDLabel setTextColor:WXColorWithInteger(0x848484)];
        [_orderIDLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:_orderIDLabel];
        
        yOffset += labelHeight;
        _orderType = [[WXUILabel alloc] init];
        _orderType.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_orderType setBackgroundColor:[UIColor clearColor]];
        [_orderType setTextAlignment:NSTextAlignmentLeft];
        [_orderType setTextColor:WXColorWithInteger(0x848484)];
        [_orderType setFont:WXFont(11.0)];
        [self.contentView addSubview:_orderType];
        
        yOffset += labelHeight;
        _numberLabel = [[WXUILabel alloc] init];
        _numberLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setTextAlignment:NSTextAlignmentLeft];
        [_numberLabel setTextColor:WXColorWithInteger(0x848484)];
        [_numberLabel setFont:WXFont(11.0)];
        [self.contentView addSubview:_numberLabel];
    }
    return self;
}

-(void)load{
    
}

@end
