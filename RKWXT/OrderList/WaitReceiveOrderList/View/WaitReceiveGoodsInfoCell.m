//
//  WaitReceiveGoodsInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WaitReceiveGoodsInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "OrderListEntity.h"

@interface WaitReceiveGoodsInfoCell(){
    WXRemotionImgBtn *_goodsImg;
    UILabel *_goodsInfo;
}
@end

@implementation WaitReceiveGoodsInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 65;
        CGFloat imgHeight = imgWidth;
        _goodsImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (WaitReceiveGoodsInfoCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_goodsImg setUserInteractionEnabled:NO];
        [self.contentView addSubview:_goodsImg];
        
        xOffset += imgWidth+12;
        CGFloat yOffset = 25;
        CGFloat infoHeight = 40;
        _goodsInfo = [[UILabel alloc] init];
        _goodsInfo.frame = CGRectMake(xOffset, yOffset, size.width-xOffset-10, infoHeight);
        [_goodsInfo setBackgroundColor:[UIColor clearColor]];
        [_goodsInfo setTextAlignment:NSTextAlignmentLeft];
        [_goodsInfo setTextColor:WXColorWithInteger(0x6d6d6d)];
        [_goodsInfo setFont:WXTFont(13.0)];
        [_goodsInfo setNumberOfLines:2];
        [self.contentView addSubview:_goodsInfo];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    [_goodsImg setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goods_img]];
    [_goodsImg load];
    [_goodsInfo setText:entity.goods_name];
}

@end
