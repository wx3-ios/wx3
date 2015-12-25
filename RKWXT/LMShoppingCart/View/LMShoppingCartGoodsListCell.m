//
//  LMShoppingCartGoodsListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartGoodsListCell.h"
#import "WXRemotionImgBtn.h"
#import "LMShoppingCartEntity.h"

@interface LMShoppingCartGoodsListCell(){
    WXUIButton *selBtn;
    WXRemotionImgBtn *imgView;
    WXUILabel *desLabel;
    WXUILabel *stockLabel;
    WXUILabel *priceLaebl;
    WXUILabel *numberLabel;
    
    WXUIView *baseView;
    WXUILabel *buyNumber;
    WXUIButton *delBtn;
}
@end

@implementation LMShoppingCartGoodsListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat selBtnWidth = 15;
        CGFloat selBtnHeight = selBtnWidth;
        selBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(xOffset, (LMShoppingCartGoodsListCellHeight-selBtnHeight)/2, selBtnWidth, selBtnHeight);
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(circleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selBtn];
        
        xOffset += selBtnWidth+8;
        CGFloat imgWidth = 90;
        CGFloat imgHieght = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (LMShoppingCartGoodsListCellHeight-imgHieght)/2, imgWidth, imgHieght)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+8;
        CGFloat yOffset = 12;
        CGFloat desLabelWidth = IPHONE_SCREEN_WIDTH-xOffset-8;
        CGFloat desLabelHeight = 36;
        desLabel = [[WXUILabel alloc] init];
        desLabel.frame = CGRectMake(xOffset, yOffset, desLabelWidth, desLabelHeight);
        [desLabel setBackgroundColor:[UIColor clearColor]];
        [desLabel setTextAlignment:NSTextAlignmentLeft];
        [desLabel setFont:WXFont(14.0)];
        [desLabel setNumberOfLines:2];
        [desLabel setTextColor:WXColorWithInteger(0x000000)];
        [self.contentView addSubview:desLabel];
        
        yOffset += desLabelHeight;
        CGFloat stockLabelWidth = 140;
        CGFloat stockLabelHeight = 16;
        stockLabel = [[WXUILabel alloc] init];
        stockLabel.frame = CGRectMake(xOffset, yOffset, stockLabelWidth, stockLabelHeight);
        [stockLabel setBackgroundColor:[UIColor clearColor]];
        [stockLabel setTextAlignment:NSTextAlignmentLeft];
        [stockLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [stockLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:stockLabel];
        
        priceLaebl = [[WXUILabel alloc] init];
        priceLaebl.frame = CGRectMake(xOffset, yOffset+stockLabelHeight+4, stockLabelWidth, stockLabelHeight);
        [priceLaebl setBackgroundColor:[UIColor clearColor]];
        [priceLaebl setTextAlignment:NSTextAlignmentLeft];
        [priceLaebl setFont:WXFont(14.0)];
        [priceLaebl setTextColor:WXColorWithInteger(0xdd2726)];
        [self.contentView addSubview:priceLaebl];
        
        CGFloat buyNumWidth = 40;
        CGFloat buyNumHeight = stockLabelHeight;
        buyNumber = [[WXUILabel alloc] init];
        buyNumber.frame = CGRectMake(IPHONE_SCREEN_WIDTH-buyNumWidth-8, yOffset+stockLabelHeight, buyNumWidth, buyNumHeight);
        [buyNumber setBackgroundColor:[UIColor clearColor]];
        [buyNumber setTextAlignment:NSTextAlignmentCenter];
        [buyNumber setTextColor:WXColorWithInteger(0x43433e)];
        [buyNumber setFont:WXFont(14.0)];
        [self.contentView addSubview:buyNumber];
        
        
        baseView = [[WXUIView alloc] init];
        baseView.frame = CGRectMake(xOffset, yOffset, stockLabelWidth, 2*stockLabelHeight+5);
        [baseView setBackgroundColor:[UIColor whiteColor]];
        [baseView setHidden:YES];
        [self.contentView addSubview:baseView];
        
        CGFloat xGap = 2;
        CGFloat plusBtnHeight = 20;
        CGFloat plusBtnWidth = plusBtnHeight;
        WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        minusBtn.frame = CGRectMake(xGap, (2*stockLabelHeight-plusBtnHeight)/2, plusBtnWidth, plusBtnHeight);
        [minusBtn setBackgroundColor:[UIColor clearColor]];
        [minusBtn setBorderRadian:1.0 width:0.6 color:WXColorWithInteger(0x9b9b9b)];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:minusBtn];
        
        CGFloat numLabelWidth = 40;
        CGFloat numLabelHeight = 20;
        numberLabel = [[WXUILabel alloc] init];
        numberLabel.frame = CGRectMake(xGap+plusBtnWidth, minusBtn.frame.origin.y, numLabelWidth, numLabelHeight);
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0x9b9b9b)];
        [numberLabel setTextColor:WXColorWithInteger(0x000000)];
        [numberLabel setText:@"1"];
        [numberLabel setFont:WXFont(12.0)];
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [baseView addSubview:numberLabel];
        
        WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(xGap+plusBtnWidth+numLabelWidth, minusBtn.frame.origin.y, plusBtnWidth, plusBtnHeight);
        [plusBtn setBackgroundColor:[UIColor clearColor]];
        [plusBtn setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0x9b9b9b)];
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:plusBtn];
        
        delBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-50, 0, 50, LMShoppingCartGoodsListCellHeight);
        [delBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setHidden:YES];
        [delBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
    }
    return self;
}

-(void)load{
    LMShoppingCartEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:[NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl]];
    [imgView load];
    
    [desLabel setText:entity.goodsName];
    [stockLabel setText:entity.stockName];
    [priceLaebl setText:[NSString stringWithFormat:@"￥%.2f",entity.goodsPrice]];
    [buyNumber setText:[NSString stringWithFormat:@"X%ld",(long)entity.buyNumber]];
    
    if(entity.selected){
        [selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }
    
    if(entity.edit){
        [delBtn setHidden:NO];
        [baseView setHidden:NO];
        [numberLabel setText:[NSString stringWithFormat:@"%ld",(long)entity.buyNumber]];
        
        [stockLabel setHidden:YES];
        [priceLaebl setHidden:YES];
        [buyNumber setHidden:YES];
    }
    if(!entity.edit){
        [delBtn setHidden:YES];
        [baseView setHidden:YES];
        
        [stockLabel setHidden:NO];
        [priceLaebl setHidden:NO];
        [buyNumber setHidden:NO];
    }
}

-(void)circleBtnClicked{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(entity.selected){
        entity.selected = NO;
        [selBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }else{
        entity.selected = YES;
        [selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(goodsCircleSellect:)]){
        [_delegate goodsCircleSellect:entity];
    }
}

-(void)plusBtnClick{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(entity.buyNumber >= entity.stockNumber){
        return;
    }
    entity.buyNumber++;
    [numberLabel setText:[NSString stringWithFormat:@"%ld",(long)entity.buyNumber]];
    
    if(_delegate && [_delegate respondsToSelector:@selector(goodsPlusBtnClicked:)]){
        [_delegate goodsPlusBtnClicked:entity];
    }
}

-(void)minusBtnClick{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(entity.buyNumber == 1){
        return;
    }
    entity.buyNumber--;
    [numberLabel setText:[NSString stringWithFormat:@"%ld",(long)entity.buyNumber]];
    
    if(_delegate && [_delegate respondsToSelector:@selector(goodsMinusBtnClicked:)]){
        [_delegate goodsMinusBtnClicked:entity];
    }
}

-(void)delBtnClicked{
    LMShoppingCartEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(goodsDelBtnClicked:)]){
        [_delegate goodsDelBtnClicked:entity];
    }
}

@end
