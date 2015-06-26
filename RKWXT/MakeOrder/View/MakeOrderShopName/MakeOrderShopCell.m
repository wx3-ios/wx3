//
//  MakeOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/6/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderShopCell.h"
#import "MakeOrderDef.h"
#import "NSString+Encrypt.h"

@implementation MakeOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat imgWidth = 15;
        CGFloat imgHeight = 15;
        CGFloat xOffset = 12;
        UIImage *img = [UIImage imageNamed:@"Icon-Small.png"];
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-imgHeight)/2, imgWidth, imgHeight);;
        [iconImgView setImage:img];
        [self.contentView addSubview:iconImgView];
        
        xOffset += imgWidth+2;
        UIFont *font = WXFont(14.0);
        CGSize labelSize = [self sizeOfString:kMerchantName font:font];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-labelSize.height)/2, labelSize.width, labelSize.height);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x202020)];
        [nameLabel setFont:font];
        [nameLabel setText:kMerchantName];
        [self.contentView addSubview:nameLabel];
        
        xOffset +=labelSize.width+2;
        UIImage *arrowImg = [UIImage imageNamed:@"MakeOrderNextPageImg.png"];
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (Order_Section_Height_ShopName-imgHeight)/2, imgWidth-3, imgHeight);
        [arrowImgView setImage:arrowImg];
        [self.contentView addSubview:arrowImgView];
    }
    return self;
}

-(void)load{

}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

@end
