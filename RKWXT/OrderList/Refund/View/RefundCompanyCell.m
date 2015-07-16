//
//  RefundCompanyCell.m
//  RKWXT
//
//  Created by SHB on 15/7/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RefundCompanyCell.h"

@implementation RefundCompanyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10.0;
        CGFloat imgWidth = 20;
        CGFloat imgHeight = imgWidth;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake(xOffset, (RefundCompanyCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"Icon.png"]];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+4;
        UIFont *font = WXFont(14.0);
        CGSize nameSize = [self sizeOfString:kMerchantName font:font];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (RefundCompanyCellHeight-nameSize.height)/2, nameSize.width, nameSize.height);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:kMerchantName];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:font];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameSize.width+4;
        CGFloat nextImgWidth = 8;
        CGFloat nextImgHeight = 12;
        UIImageView *nextImgView = [[UIImageView alloc] init];
        nextImgView.frame = CGRectMake(xOffset, (RefundCompanyCellHeight-nextImgHeight)/2, nextImgWidth, nextImgHeight);
        [nextImgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:nextImgView];
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
