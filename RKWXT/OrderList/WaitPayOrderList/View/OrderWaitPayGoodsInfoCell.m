//
//  OrderWaitPayGoodsInfoCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderWaitPayGoodsInfoCell.h"
#import "WXRemotionImgBtn.h"

@interface OrderWaitPayGoodsInfoCell(){
    WXRemotionImgBtn *_goodsImg;
    UILabel *_goodsInfo;
}
@end

@implementation OrderWaitPayGoodsInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 65;
        CGFloat imgHeight = imgWidth;
        _goodsImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderWaitPayGoodsInfoCellHeight-imgHeight)/2, imgWidth, imgHeight)];
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
    [_goodsImg setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140929/20140929111809_9365271.jpeg"];
    [_goodsImg load];
    [_goodsInfo setText:@"卡西欧(CASIO)手表EF系列男表三眼时尚运动钢带石英男士手表EF-539D-1A"];
}

@end
