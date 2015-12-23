//
//  LMRefundOrderGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMRefundOrderGoodsListCell.h"
#import "WXRemotionImgBtn.h"

@interface LMRefundOrderGoodsListCell(){
    WXUIButton *_circleBtn;
    WXRemotionImgBtn *_imgView;
    WXUILabel *_namelabel;
    WXUIButton *_infoLabel;
    WXUILabel *_numberLabel;
    WXUILabel *_newPrice;
    
    BOOL selected;
}
@end

@implementation LMRefundOrderGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat xGap = 10;
        UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
        CGSize size = circleImg.size;
        size.width += 3.0;
        size.height += 3.0;
        _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(xGap, (RefundGoodsListCellHeight-size.height)/2, size.width, size.height);
        [_circleBtn setBackgroundColor:[UIColor clearColor]];
        [_circleBtn setImage:circleImg forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_circleBtn];
        
        CGFloat xOffset = 7+xGap+size.width;
        CGFloat imgWidth = 58;
        CGFloat imgHeight = 58;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (RefundGoodsListCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+12;
        CGFloat yOffset = 19;
        CGFloat nameWidth = 125;
        CGFloat nameHeight = 40;
        _namelabel = [[WXUILabel alloc] init];
        _namelabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_namelabel setBackgroundColor:[UIColor clearColor]];
        [_namelabel setTextAlignment:NSTextAlignmentLeft];
        [_namelabel setTextColor:WXColorWithInteger(0x000000)];
        [_namelabel setFont:WXFont(15.0)];
        [_namelabel setNumberOfLines:0];
        [self.contentView addSubview:_namelabel];
        
        CGFloat priceWidth = 52;
        CGFloat priceXgap = IPHONE_SCREEN_WIDTH-10-priceWidth;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(priceXgap, yOffset, priceWidth, nameHeight/2);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentRight];
        [_newPrice setTextColor:WXColorWithInteger(0x000000)];
        [_newPrice setFont:WXFont(14.0)];
        [self.contentView addSubview:_newPrice];
        
        _numberLabel = [[WXUILabel alloc] init];
        _numberLabel.frame = CGRectMake(priceXgap, yOffset+nameHeight/2, priceWidth, nameHeight/2);
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setTextAlignment:NSTextAlignmentRight];
        [_numberLabel setFont:WXFont(14.0)];
        [_numberLabel setTextColor:WXColorWithInteger(0x6c6a6d)];
        [self.contentView addSubview:_numberLabel];
        
        
        yOffset += nameHeight;
        _infoLabel = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _infoLabel.frame = CGRectMake(xOffset, yOffset, 75, 25);
        [_infoLabel setBackgroundColor:[UIColor grayColor]];
        [_infoLabel setHidden:YES];
        [_infoLabel.titleLabel setFont:WXFont(10.0)];
        [_infoLabel addTarget:self action:@selector(searchRefundstate) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

-(void)load{
    LMOrderListEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@",entity.goodsImg]];
    [_imgView load];
    [_namelabel setText:entity.goodsName];
    
    NSString *newPrice = [NSString stringWithFormat:@"￥%.2f",entity.stockPrice];
    [_newPrice setText:newPrice];
    
    NSString *number = [NSString stringWithFormat:@"X%ld",(long)entity.buyNumber];
    [_numberLabel setText:number];
    
    if(entity.refundState != LMRefund_State_Normal){
        [_circleBtn setHidden:YES];
    }
    
    [self setCircleBtnImgWith:entity.selected];
    
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Normal){
        [_infoLabel setTitle:@"已申请退款" forState:UIControlStateNormal];
        [_infoLabel setHidden:NO];
    }
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Agree){
        [_infoLabel setTitle:@"退款中" forState:UIControlStateNormal];
        [_infoLabel setHidden:YES];
    }
    if(entity.refundState == LMRefund_State_Being && entity.shopDealType == LMShopDeal_Refund_Refuse){
        [_infoLabel setTitle:@"商家拒绝退款" forState:UIControlStateNormal];
        [_infoLabel setHidden:NO];
    }
    if(entity.refundState == LMRefund_State_HasDone){
        [_infoLabel setTitle:@"已退款" forState:UIControlStateNormal];
        [_infoLabel setHidden:YES];
    }
}

//选择按钮点击
-(void)circleBtnClick{
    LMOrderListEntity *entity = self.cellInfo;
    if(!selected){
        selected = YES;
        entity.selected = YES;
    }else{
        selected = NO;
        entity.selected = NO;
    }
    
    NSInteger number = 0;
    for(LMOrderListEntity *ent in _allEntity.goodsListArr){
        if(ent.refundState == LMRefund_State_Normal && ent.selected){
            number++;
        }
    }
    if(number == [_allEntity.goodsListArr count]){
        _allEntity.selectAll = YES;
    }
    if(number != [_allEntity.goodsListArr count]){
        _allEntity.selectAll = NO;
    }
    
    if(entity.refundState == LMRefund_State_Normal){
        if(_delegate && [_delegate respondsToSelector:@selector(selectGoods)]){
            [_delegate selectGoods];
        }
    }
    
    [self setCircleBtnImgWith:selected];
}

-(void)setCircleBtnImgWith:(BOOL)select{
    if(select){
        [_circleBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [_circleBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }
}

-(void)searchRefundstate{
    LMOrderListEntity *entity = self.cellInfo;
    if((entity.refundState == LMRefund_State_Being && entity.shopDealType == entity.shopDealType == LMShopDeal_Refund_Agree) || entity.refundState == LMRefund_State_HasDone){
        if(_delegate && [_delegate respondsToSelector:@selector(searchRefundStatus:)]){
            [_delegate searchRefundStatus:entity];
        }
    }
}

@end
