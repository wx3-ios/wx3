//
//  OrderGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/6/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderGoodsCell.h"
#import "WXRemotionImgBtn.h"
#import "OrderListEntity.h"

@interface OrderGoodsCell()<WXRemotionImgBtnDelegate>{
    WXRemotionImgBtn *_goodsImg;
    UILabel *_goodsInfo;
    UILabel *_goodsPrice;
    UILabel *_goodsNum;
    
    WXUIButton *_infoLabel;
}
@end

@implementation OrderGoodsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGSize size = self.bounds.size;
        CGFloat xOffset = 10;
        CGFloat imgWidth = 65;
        CGFloat imgHeight = imgWidth;
        _goodsImg = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (OrderGoodsCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_goodsImg setDelegate:self];
        [self.contentView addSubview:_goodsImg];
        
        xOffset += imgWidth+12;
        CGFloat yOffset = 16;
        CGFloat infoWidth = 160;
        CGFloat infoHeight = 40;
        _goodsInfo = [[UILabel alloc] init];
        _goodsInfo.frame = CGRectMake(xOffset, yOffset, infoWidth, infoHeight);
        [_goodsInfo setBackgroundColor:[UIColor clearColor]];
        [_goodsInfo setTextAlignment:NSTextAlignmentLeft];
        [_goodsInfo setTextColor:WXColorWithInteger(0x000000)];
        [_goodsInfo setFont:WXTFont(15.0)];
        [_goodsInfo setNumberOfLines:0];
        [self.contentView addSubview:_goodsInfo];
        
        _infoLabel = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _infoLabel.frame = CGRectMake(xOffset, yOffset+infoHeight, 75, 25);
        [_infoLabel setBackgroundColor:[UIColor grayColor]];
        [_infoLabel setHidden:YES];
        [_infoLabel.titleLabel setFont:WXFont(10.0)];
        [_infoLabel addTarget:self action:@selector(searchRefundstate) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_infoLabel];
        
        CGFloat xGap = 15;
        CGFloat priceWidth = 60;
        CGFloat priceHeight = 20;
        _goodsPrice = [[UILabel alloc] init];
        _goodsPrice.frame = CGRectMake(size.width-xGap-priceWidth, yOffset, priceWidth, priceHeight);
        [_goodsPrice setBackgroundColor:[UIColor clearColor]];
        [_goodsPrice setTextAlignment:NSTextAlignmentRight];
        [_goodsPrice setTextColor:WXColorWithInteger(0x000000)];
        [_goodsPrice setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsPrice];
        
        yOffset += priceHeight+2;
        _goodsNum = [[UILabel alloc] init];
        _goodsNum.frame = CGRectMake(size.width-xGap-priceWidth, yOffset, priceWidth, priceHeight);
        [_goodsNum setBackgroundColor:[UIColor clearColor]];
        [_goodsNum setTextAlignment:NSTextAlignmentRight];
        [_goodsNum setTextColor:WXColorWithInteger(0x646464)];
        [_goodsNum setFont:WXTFont(14.0)];
        [self.contentView addSubview:_goodsNum];
    }
    return self;
}

-(void)load{
    OrderListEntity *entity = self.cellInfo;
    [_goodsImg setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.goods_img]];
    [_goodsImg load];
    [_goodsInfo setText:entity.goods_name];
    [_goodsPrice setText:[NSString stringWithFormat:@"￥%.2f",entity.sales_price]];
    [_goodsNum setText:[NSString stringWithFormat:@"×%ld",(long)entity.sales_num]];
    [self setInfoBtnWith:entity];
}

-(void)setInfoBtnWith:(OrderListEntity*)entity{
    if(!entity){
        return;
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Agree){
        [_infoLabel setHidden:NO];
        [_infoLabel setBackgroundColor:[UIColor grayColor]];
        [_infoLabel setTitle:@"退款中" forState:UIControlStateNormal];
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Normal){
        [_infoLabel setHidden:NO];
        [_infoLabel setEnabled:NO];
        [_infoLabel setBackgroundColor:[UIColor grayColor]];
        [_infoLabel setTitle:@"已申请退款" forState:UIControlStateNormal];
    }
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Normal){
        [_infoLabel setHidden:NO];
        [_infoLabel setEnabled:NO];
        [_infoLabel setBackgroundColor:[UIColor grayColor]];
        [_infoLabel setTitle:@"已退款" forState:UIControlStateNormal];
    }
}

-(void)searchRefundstate{
    OrderListEntity *entity = self.cellInfo;
    if(entity.refund_status == Refund_Status_Being && entity.shopDeal_status == ShopDeal_Refund_Agree){
        if(_delegate && [_delegate respondsToSelector:@selector(toOrderRefundSucceed:)]){
            [_delegate toOrderRefundSucceed:entity];
        }
    }
}

-(void)buttonImageClicked:(id)sender{
    OrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(toGoodsInfoWithGoodsID:)]){
        [_delegate toGoodsInfoWithGoodsID:entity.goods_id];
    }
}

@end
