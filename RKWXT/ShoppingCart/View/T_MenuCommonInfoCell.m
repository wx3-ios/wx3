//
//  T_MenuCommonInfoCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/24.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_MenuCommonInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "T_MeunDef.h"
#import "ShoppingCartEntity.h"

@interface T_MenuCommonInfoCell(){
    WXUIButton *_circleBtn;
    WXRemotionImgBtn *_imgView;
    WXUILabel *_namelabel;
    WXUILabel *_infoLabel;
    WXUILabel *_numberLabel;
    WXUILabel *_oldPrice;
    WXUILabel *_newPrice;
    
    NSInteger number;
    BOOL selected;
}
@end

@implementation T_MenuCommonInfoCell

-(void)dealloc{
    RELEASE_SAFELY(_imgView);
    RELEASE_SAFELY(_namelabel);
    RELEASE_SAFELY(_infoLabel);
    RELEASE_SAFELY(_oldPrice);
    RELEASE_SAFELY(_newPrice);
    number = 0;
    _delegate = nil;
    selected = NO;
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
        _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(xGap, (T_MenuCommonCellHeight-circleImg.size.height)/2, circleImg.size.width, circleImg.size.height);
        [_circleBtn setBackgroundColor:[UIColor clearColor]];
        [_circleBtn setImage:circleImg forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_circleBtn];
        
        CGFloat xOffset = 5+xGap+circleImg.size.width;
        CGFloat imgWidth = 55;
        CGFloat imgHeight = 55;
        _imgView = [[WXRemotionImgBtn alloc] init];
        _imgView.frame = CGRectMake(xOffset, (T_MenuCommonCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:_imgView];
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 10;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 16;
        _namelabel = [[WXUILabel alloc] init];
        _namelabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight*2.4);
        [_namelabel setBackgroundColor:[UIColor clearColor]];
        [_namelabel setTextAlignment:NSTextAlignmentLeft];
        [_namelabel setTextColor:WXColorWithInteger(NameColor)];
        [_namelabel setFont:[UIFont systemFontOfSize:NameFont]];
        [_namelabel setNumberOfLines:0];
        [self.contentView addSubview:_namelabel];
        
        CGFloat priceXgap = xOffset+nameWidth+4;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(priceXgap, yOffset+10, IPHONE_SCREEN_WIDTH-priceXgap, nameHeight);
        [_newPrice setBackgroundColor:[UIColor clearColor]];
        [_newPrice setTextAlignment:NSTextAlignmentCenter];
        [_newPrice setTextColor:WXColorWithInteger(newPriceColor)];
        [_newPrice setFont:[UIFont systemFontOfSize:newPriceFont]];
        [self.contentView addSubview:_newPrice];
        
        yOffset += nameHeight+2;
        _infoLabel = [[WXUILabel alloc] init];
        _infoLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentLeft];
        [_infoLabel setTextColor:WXColorWithInteger(InfoColor)];
        [_infoLabel setFont:[UIFont systemFontOfSize:InfoFont]];
//        [self.contentView addSubview:_infoLabel];
        
        priceXgap += 5;
        _oldPrice = [[WXUILabel alloc] init];
        _oldPrice.frame = CGRectMake(priceXgap, yOffset, IPHONE_SCREEN_WIDTH-priceXgap, nameHeight);
        [_oldPrice setBackgroundColor:[UIColor clearColor]];
        [_oldPrice setTextAlignment:NSTextAlignmentCenter];
        [_oldPrice setTextColor:WXColorWithInteger(oldPriceColor)];
        [_oldPrice setFont:[UIFont systemFontOfSize:oldPriceFont]];
        [self.contentView addSubview:_oldPrice];
        
        WXUILabel *lineLabel = [[WXUILabel alloc] init];
        lineLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-priceXgap)/4, nameHeight/2, (IPHONE_SCREEN_WIDTH-priceXgap)/2, 1);
        [lineLabel setBackgroundColor:[UIColor grayColor]];
//        [_oldPrice addSubview:lineLabel];
        RELEASE_SAFELY(lineLabel);
        
        yOffset += nameHeight+4;
        CGFloat markWidth = 15;
        CGFloat markHeight = 16;
        WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(xOffset, yOffset, markWidth, markHeight);
        [plusBtn setBackgroundColor:WXColorWithInteger(T_MenuCommonCellColor)];
        [plusBtn setBorderRadian:1.0 width:0.4 color:WXColorWithInteger(markColor)];
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleColor:WXColorWithInteger(markColor) forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:plusBtn];
        
        xOffset += markWidth+5;
        CGFloat numBtnWidth = 27;
        _numberLabel = [[WXUILabel alloc] init];
        _numberLabel.frame = CGRectMake(xOffset, yOffset, numBtnWidth, markWidth);
        [_numberLabel setBackgroundColor:WXColorWithInteger(T_MenuCommonCellColor)];
        [_numberLabel setBorderRadian:1.0 width:0.4 color:WXColorWithInteger(markColor)];
        [_numberLabel setTextColor:WXColorWithInteger(markColor)];
        [_numberLabel setText:@"1"];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_numberLabel];
        
        xOffset += numBtnWidth+5;
        WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        minusBtn.frame = CGRectMake(xOffset, yOffset, markWidth, markHeight);
        [minusBtn setBackgroundColor:WXColorWithInteger(T_MenuCommonCellColor)];
        [minusBtn setBorderRadian:1.0 width:0.4 color:WXColorWithInteger(markColor)];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:WXColorWithInteger(markColor) forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:minusBtn];
        
        xOffset = 18;
        UIImage *img = [UIImage imageNamed:@"ShoppingCartDel.png"];
        WXUIButton *deleteBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-img.size.width, yOffset, img.size.width, img.size.height);
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        [deleteBtn setImage:img forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
    }
    return self;
}

-(void)load{
    ShoppingCartEntity *entity = self.cellInfo;
    [_imgView setCpxViewInfo:entity.smallImg];
    [_imgView load];
    [_namelabel setText:entity.goods_name];
    
    NSString *newPrice = [NSString stringWithFormat:@"￥%.2f",entity.goods_price];
    [_newPrice setText:newPrice];
    
//    NSString *oldPrice = [NSString stringWithFormat:@"￥%.2f",entity.market_price];
//    [_oldPrice setText:@"3000"];
    
    [self setCircleBtnImgWith:NO];
}

-(void)setGoodsInfo:(id)entity{
    ShoppingCartEntity *enti = entity;
    if(number == 0){
        number = enti.goods_Number;
    }
//    [_infoLabel setText:enti.colorType];
}

-(void)selectAllGoods:(BOOL)selectAll{
    ShoppingCartEntity *entity = self.cellInfo;
    if(selectAll){
        selected = YES;
        entity.selected = YES;
    }else{
        selected = NO;
        entity.selected = NO;
    }
    [self setCircleBtnImgWith:selected];
}

//选择按钮点击
-(void)circleBtnClick{
    ShoppingCartEntity *entity = self.cellInfo;
    if(!selected){
        selected = YES;
        entity.selected = YES;
        if(_delegate && [_delegate respondsToSelector:@selector(selectGoods)]){
            [_delegate selectGoods];
        }
    }else{
        selected = NO;
        entity.selected = NO;
        if(_delegate && [_delegate respondsToSelector:@selector(cancelGoods)]){
            [_delegate cancelGoods];
        }
    }
    [self setCircleBtnImgWith:selected];
}

-(void)plusBtnClick{
    number++;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
    [_numberLabel setText:str];
    ShoppingCartEntity *entity = self.cellInfo;
    entity.goods_Number = number;
    if(_delegate && [_delegate respondsToSelector:@selector(plusBtnClicked)]){
        [_delegate plusBtnClicked];
    }
}

-(void)minusBtnClick{
    number--;
    NSString *str = nil;
    str = [NSString stringWithFormat:@"%ld",(long)number];
    if(number<=1){
        number = 1;
        str = [NSString stringWithFormat:@"%d",1];
    }
    [_numberLabel setText:str];
    ShoppingCartEntity *entity = self.cellInfo;
    entity.goods_Number = number;
    if(_delegate && [_delegate respondsToSelector:@selector(minusBtnClicked)]){
        [_delegate minusBtnClicked];
    }
}

-(void)deleteBtnClicked{
    ShoppingCartEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(deleteGoods:)]){
        [_delegate deleteGoods:entity.cart_id];
    }
}

-(void)setCircleBtnImgWith:(BOOL)select{
    if(select){
        [_circleBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [_circleBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }
}

@end
