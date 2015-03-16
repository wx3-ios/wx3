//
//  RechargeCell.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeCell.h"

@interface RechargeCell(){
    UIImageView *_imageView;
    UILabel *_nameLabel;
}
@end

@implementation RechargeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 14;
        UIImage *image = [UIImage imageNamed:@"wxtRecharge.png"];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(xOffset, (RechargeCellHeight-image.size.height)/2, image.size.width, image.size.height);
        [_imageView setImage:image];
        [self.contentView addSubview:_imageView];
        
        xOffset += image.size.width+10;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 20;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, (RechargeCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXTFont(14.0)];
        [_nameLabel setTextColor:WXColorWithInteger(0x646464)];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)load{
    [_imageView setImage:[UIImage imageNamed:@"wxtRecharge.png"]];
    [_nameLabel setText:@"我信充值卡充值"];
}

@end
