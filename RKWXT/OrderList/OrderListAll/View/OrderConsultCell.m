//
//  OrderConsultCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderConsultCell.h"

@interface OrderConsultCell(){
    UILabel *_goodsNum;
    UILabel *_consult;
}
@end

@implementation OrderConsultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 200;
        CGFloat height = 16;
        CGFloat numWidth = 67;
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, numWidth, height);
        [_goodsNum setBackgroundColor:[UIColor clearColor]];
        [_goodsNum setTextAlignment:NSTextAlignmentLeft];
        [_goodsNum setTextColor:WXColorWithInteger(0x646464)];
        [_goodsNum setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsNum];
        
        xOffset -= (numWidth+6);
        CGFloat textWidth = 38;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, textWidth, height);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x646464)];
        [textLabel setFont:WXTFont(16.0)];
        [textLabel setText:@"实付:"];
        [self.contentView addSubview:textLabel];
        
        xOffset -= textWidth;
        _consult = [[UILabel alloc] init];
        _consult.frame = CGRectMake(size.width-xOffset, (OrderConsultCellHeight-height)/2, size.width-xOffset, height);
        [_consult setBackgroundColor:[UIColor clearColor]];
        [_consult setTextAlignment:NSTextAlignmentLeft];
        [_consult setTextColor:WXColorWithInteger(0x000000)];
        [_consult setFont:WXTFont(16.0)];
        [self.contentView addSubview:_consult];
    }
    return self;
}

-(void)load{
    [_goodsNum setText:@"共1件商品"];
    [_consult setText:@"￥29.00元"];
}

@end
