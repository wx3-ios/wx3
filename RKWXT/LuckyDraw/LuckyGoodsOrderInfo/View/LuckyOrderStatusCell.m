//
//  LuckyOrderStatusCell.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyOrderStatusCell.h"

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
    [_stateLabel setText:@"买家未付款"];
}

@end
