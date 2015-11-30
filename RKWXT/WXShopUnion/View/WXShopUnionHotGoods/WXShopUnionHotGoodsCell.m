//
//  WXShopUnionHotGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionHotGoodsCell.h"
#import "WXShopUnionDef.h"
#import "WXRemotionImgBtn.h"

@interface WXShopUnionHotGoodsCell(){
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *moneyLabel;
    WXUILabel *otherlabel;
}
@end

@implementation WXShopUnionHotGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 98;
        CGFloat imgHieght = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (ShopUnionHotGoodsListHeight-imgHieght)/2, imgWidth, imgHieght)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat nameWidth = IPHONE_SCREEN_WIDTH-xOffset-10;
        CGFloat nameHeight = 35;
        CGFloat yOffset = 15;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setNumberOfLines:0];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameHeight+15;
        CGFloat moneyLabelWidth = 100;
        CGFloat moneyLabelHeight = 20;
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake(xOffset, yOffset, moneyLabelWidth, moneyLabelHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextAlignment:NSTextAlignmentLeft];
        [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
        [moneyLabel setFont:WXFont(17.0)];
        [self.contentView addSubview:moneyLabel];
        
        yOffset += moneyLabelHeight+12;
        CGFloat otherLabelWidth = 95;
        CGFloat otherLabelHieght = 15;
        otherlabel = [[WXUILabel alloc] init];
        otherlabel.frame = CGRectMake(xOffset, yOffset, otherLabelWidth, otherLabelHieght);
        [otherlabel setBackgroundColor:[UIColor clearColor]];
        [otherlabel setTextAlignment:NSTextAlignmentLeft];
        [otherlabel setTextColor:WXColorWithInteger(0x8c8c8c)];
        [otherlabel setFont:WXFont(12.0)];
        [self.contentView addSubview:otherlabel];
    }
    return self;
}

-(void)load{
    [imgView setCpxViewInfo:@"http://oldyun.67call.com/wx3/Public/Uploads/20151118/20151118141759_471740.jpeg"];
    [imgView load];
    [nameLabel setText:@"中华人民共和国万岁!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
    [moneyLabel setText:@"￥50.00"];
    [otherlabel setText:@"还不知道"];
}

@end
