//
//  UserInfoCommonCell.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoCommonCell.h"

@interface UserInfoCommonCell(){
    UIImageView *_imageView;
    UILabel *_nameLabel;
    NSArray *nameArr;
}
@end

@implementation UserInfoCommonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        nameArr = @[@"充值中心",@"话费余额查询",@"签到送话费",@"关于我信通"];
        
        CGFloat xOffset = 14;
        UIImage *image = [UIImage imageNamed:@"RechargeSign.png"];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(xOffset, (UserInfoCommonCellHeight-image.size.height-5)/2, image.size.width, image.size.height+5);
        [_imageView setImage:image];
        [self.contentView addSubview:_imageView];
        
        xOffset += image.size.width+10;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 20;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, (UserInfoCommonCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXTFont(14.0)];
        [_nameLabel setTextColor:WXColorWithInteger(0x5a5a5a)];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)load{
    
}

-(void)loadUserInfoBaseData:(NSInteger)row{
    if(row < 0){
        return;
    }
    [self setBaseImage:(row==0 ? WXT_UserInfo_Recharge : (row==1?WXT_UserInfo_Balance:(row==2?WXT_UserInfo_Sign:WXT_UserInfo_About)))];
    [self setBaseLabelText:(row==0 ? WXT_UserInfo_Recharge : (row==1?WXT_UserInfo_Balance:(row==2?WXT_UserInfo_Sign:WXT_UserInfo_About)))];
}

-(void)setBaseImage:(WXT_UserInfo)type{
    switch (type) {
        case WXT_UserInfo_Recharge:
        {
            [_imageView setImage:[UIImage imageNamed:@"RechargeSign.png"]];
        }
            break;
        case WXT_UserInfo_Balance:
        {
            [_imageView setImage:[UIImage imageNamed:@"Wallet.png"]];
        }
            break;
        case WXT_UserInfo_Sign:
        {
            [_imageView setImage:[UIImage imageNamed:@"Sign.png"]];
        }
            break;
        case WXT_UserInfo_About:{
            [_imageView setImage:[UIImage imageNamed:@"AboutWXTVersion.png"]];
        }
            break;
        default:
            break;
    }
}

-(void)setBaseLabelText:(WXT_UserInfo)type{
    switch (type) {
        case WXT_UserInfo_Recharge:
        {
            [_nameLabel setText:nameArr[WXT_UserInfo_Recharge]];
        }
            break;
        case WXT_UserInfo_Balance:
        {
            [_nameLabel setText:nameArr[WXT_UserInfo_Balance]];
        }
            break;
        case WXT_UserInfo_Sign:
        {
            [_nameLabel setText:nameArr[WXT_UserInfo_Sign]];
        }
            break;
        case WXT_UserInfo_About:
        {
            [_nameLabel setText:nameArr[WXT_UserInfo_About]];
        }
            break;
        default:
            break;
    }
}

@end
