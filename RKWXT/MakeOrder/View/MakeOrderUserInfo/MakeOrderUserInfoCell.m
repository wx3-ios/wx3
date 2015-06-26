//
//  MakeOrderUserInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderUserInfoCell.h"
#import "MakeOrderDef.h"
#import "UserAddressModel.h"
#import "AddressEntity.h"

@interface MakeOrderUserInfoCell(){
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addLabel;
}
@end

@implementation MakeOrderUserInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat yOffset = 12;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, Order_Section_Height_UserInfo-2*yOffset);
        [bgView setBackgroundColor:[UIColor brownColor]];
        [self.contentView addSubview:bgView];
        
        UIImage *upImg = [UIImage imageNamed:@"MakeOrderLinImg.png"];
        UIImageView *upImgView = [[UIImageView alloc] init];
        upImgView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 2);
        [upImgView setImage:upImg];
        [bgView addSubview:upImgView];
        
        CGFloat yGap = 21;
        CGFloat xGap = 12;
        CGFloat xOffset = xGap;
        CGFloat imgWidth = 14;
        CGFloat imgHeight = 20;
        UIImage *userImg = [UIImage imageNamed:@"MakeOrderUserNameImg.png"];
        UIImageView *userImgView = [[UIImageView alloc] init];
        userImgView.frame = CGRectMake(xGap, yGap, imgWidth, imgHeight);
        [userImgView setImage:userImg];
        [bgView addSubview:userImgView];
        
        xGap += imgWidth+2;
        CGFloat nameWidth = 80;
        CGFloat nameHeight = imgHeight;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(xGap, yGap, nameWidth, nameHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setFont:WXFont(16.0)];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [bgView addSubview:_nameLabel];
        
        xGap += nameWidth+10;
        UIImage *phoneImg = [UIImage imageNamed:@"MakeOrderUserPhoneImg.png"];
        UIImageView *phoneImgView = [[UIImageView alloc] init];
        phoneImgView.frame = CGRectMake(xGap, yGap, imgWidth, imgHeight);
        [phoneImgView setImage:phoneImg];
        [bgView addSubview:phoneImgView];
        
        xGap += imgWidth+2;
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.frame = CGRectMake(xGap, yGap, IPHONE_SCREEN_WIDTH-xGap, nameHeight);
        [_phoneLabel setBackgroundColor:[UIColor clearColor]];
        [_phoneLabel setTextAlignment:NSTextAlignmentLeft];
        [_phoneLabel setTextColor:WXColorWithInteger(0x000000)];
        [_phoneLabel setFont:WXFont(16.0)];
        [bgView addSubview:_phoneLabel];
        
        yGap += imgHeight+10;
        _addLabel = [[UILabel alloc] init];
        _addLabel.frame = CGRectMake(xOffset, yGap, IPHONE_SCREEN_WIDTH-2*xOffset, 18);
        [_addLabel setBackgroundColor:[UIColor clearColor]];
        [_addLabel setTextAlignment:NSTextAlignmentLeft];
        [_addLabel setFont:WXFont(12.0)];
        [_addLabel setTextColor:WXColorWithInteger(0x42433e)];
        [bgView addSubview:_addLabel];
        
        UIImageView *downImgView = [[UIImageView alloc] init];
        downImgView.frame = CGRectMake(0, Order_Section_Height_UserInfo-2*yOffset-2, IPHONE_SCREEN_WIDTH, 2);
        [downImgView setImage:upImg];
        [bgView addSubview:downImgView];
    }
    return self;
}

-(void)load{
    for(AddressEntity *entity in [UserAddressModel shareUserAddress].userAddressArr){
        if(entity.normalID == 1){
            [_nameLabel setText:entity.userName];
            [_phoneLabel setText:entity.userPhone];
            [_addLabel setText:entity.address];
        }
    }
}

@end
