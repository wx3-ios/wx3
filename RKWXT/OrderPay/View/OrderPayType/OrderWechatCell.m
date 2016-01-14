//
//  OrderWechatCell.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderWechatCell.h"

@implementation OrderWechatCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 12;
        CGFloat imgWidth = 35;
        CGFloat imgHeight = 35;
        UIImage *img = [UIImage imageNamed:@"OrderWechatImg.png"];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (OrderWechatCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:img];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 15;
        CGFloat labelWidth = 155;
        CGFloat labelHeight = 20;
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setText:@"微信支付"];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += labelHeight;
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight-3);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentLeft];
        [desLabel setTextColor:WXColorWithInteger(0x989898)];
        [desLabel setFont:WXFont(12.0)];
        [desLabel setText:@"微信安全支付"];
        [self.contentView addSubview:desLabel];
    }
    return self;
}

-(void)load{
    
}

@end
