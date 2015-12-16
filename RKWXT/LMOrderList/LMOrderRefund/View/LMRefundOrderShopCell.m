//
//  LMRefundOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMRefundOrderShopCell.h"
#import "WXRemotionImgBtn.h"

@interface LMRefundOrderShopCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
}
@end

@implementation LMRefundOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10.0;
        CGFloat imgWidth = 20;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMRefundOrderShopCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+4;
        UIFont *font = WXFont(14.0);
        CGSize nameSize = [self sizeOfString:kMerchantName font:font];
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMRefundOrderShopCellHeight-nameSize.height)/2, nameSize.width, nameSize.height);
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
        nextImgView.frame = CGRectMake(xOffset, (LMRefundOrderShopCellHeight-nextImgHeight)/2, nextImgWidth, nextImgHeight);
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
