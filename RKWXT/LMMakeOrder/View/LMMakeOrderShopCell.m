//
//  LMMakeOrderShopCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMakeOrderShopCell.h"
#import "LMMakeOrderDef.h"
#import "NSString+Encrypt.h"
#import "WXRemotionImgBtn.h"
#import "LMGoodsInfoEntity.h"

@interface LMMakeOrderShopCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUIImageView *arrowImgView;
}
@end

@implementation LMMakeOrderShopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat imgWidth = 30;
        CGFloat imgHeight = imgWidth;
        CGFloat xOffset = 12;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMMakeOrderShopNameCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat labelWidth = 50;
        CGFloat labelHeight = 18;
        UIFont *font = WXFont(14.0);
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (LMMakeOrderShopNameCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x202020)];
        [nameLabel setFont:font];
        [self.contentView addSubview:nameLabel];
        
        xOffset += labelWidth+5;
        CGFloat arrowWidth = 9;
        CGFloat arrowHeight = 12;
        UIImage *arrowImg = [UIImage imageNamed:@"MakeOrderNextPageImg.png"];
        arrowImgView = [[WXUIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, (LMMakeOrderShopNameCellHeight-arrowWidth)/2, arrowWidth, arrowHeight);
        [arrowImgView setImage:arrowImg];
        [self.contentView addSubview:arrowImgView];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.homeImg];
    [nameLabel setText:entity.sellerName];

    CGFloat width = [NSString widthForString:entity.sellerName fontSize:14.0 andHeight:18];
    CGRect rect = nameLabel.frame;
    rect.size.width = width;
    [nameLabel setFrame:rect];
    
    CGRect rect1 = arrowImgView.frame;
    rect.origin.x = nameLabel.frame.origin.x+width+2;
    [arrowImgView setFrame:rect1];
}

@end
