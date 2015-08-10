//
//  RechargeTypeCell.m
//  RKWXT
//
//  Created by SHB on 15/8/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeTypeCell.h"

@interface RechargeTypeCell(){
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_infoLabel;
}
@end

@implementation RechargeTypeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 35;
        CGFloat imgHeight = 21;
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(xOffset, (RechargeTypeCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 12;
        CGFloat labelWidth = 160;
        CGFloat labelHeight = 20;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setFont:WXFont(15.0)];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_titleLabel];
        
        yOffset += labelHeight+5;
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setFont:WXFont(12.0)];
        [_infoLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

-(void)load{
    NSInteger row = [self.cellInfo integerValue];
    if(row == 0){
        [_imgView setImage:[UIImage imageNamed:@"wxtRecharge.png"]];
        [_titleLabel setText:@"充值卡"];
        [_infoLabel setText:@"充值卡适用于所有手机用户"];
    }else{
        [_imgView setImage:[UIImage imageNamed:@"wxtRecharge.png"]];
        [_titleLabel setText:@"充值话费"];
        [_infoLabel setText:@"支付宝安全支付"];
    }
}

@end
