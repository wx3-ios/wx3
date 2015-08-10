//
//  RechargeListCell.m
//  RKWXT
//
//  Created by SHB on 15/8/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeListCell.h"

@interface RechargeListCell(){
    UILabel *_titleLabel;
    UILabel *_infoLabel;
}
@end

@implementation RechargeListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat yOffset = 12;
        CGFloat labelWidth = 200;
        CGFloat labelHeight = 20;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setFont:WXFont(15.0)];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_titleLabel];
        
        yOffset += labelHeight;
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
    [_titleLabel setText:_title];
    [_infoLabel setText:_info];
}

@end
