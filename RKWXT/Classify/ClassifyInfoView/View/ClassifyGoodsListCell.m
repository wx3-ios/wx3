//
//  ClassifyGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "ClassiftGoodsEntity.h"

@interface ClassifyGoodsListCell(){
    WXRemotionImgBtn *_imgView;
    WXUILabel *_nameLabel;
    WXUILabel *_moneyLabel;
}

@end

@implementation ClassifyGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat imgWidth = 98;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (ClassifyGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+14;
        CGFloat yOffset = 16;
        CGFloat labelHeight = 35;
        _nameLabel = [[WXUILabel alloc] init];
        _nameLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset-12, labelHeight);
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_nameLabel setNumberOfLines:2];
        [_nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

-(void)load{
    ClassiftGoodsEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.goodsImg];
    [_imgView load];
    [_nameLabel setText:entity.goodsName];
}

@end
