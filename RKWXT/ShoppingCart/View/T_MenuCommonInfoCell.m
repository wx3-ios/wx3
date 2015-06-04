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
//#import "T_GoodInfoEntity.h"
#import "T_MenuEntity.h"

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
        UIImage *circleImg = [UIImage imageNamed:@"t_noneSelected.png"];
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
        
        xOffset += imgWidth+5;
        CGFloat yOffset = 10;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 16;
        _namelabel = [[WXUILabel alloc] init];
        _namelabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [_namelabel setBackgroundColor:[UIColor clearColor]];
        [_namelabel setTextAlignment:NSTextAlignmentLeft];
        [_namelabel setTextColor:WXColorWithInteger(NameColor)];
        [_namelabel setFont:[UIFont systemFontOfSize:NameFont]];
        [self.contentView addSubview:_namelabel];
        
        CGFloat priceXgap = xOffset+nameWidth+4;
        _newPrice = [[WXUILabel alloc] init];
        _newPrice.frame = CGRectMake(priceXgap, yOffset, IPHONE_SCREEN_WIDTH-priceXgap, nameHeight);
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
        [self.contentView addSubview:_infoLabel];
        
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
        [_oldPrice addSubview:lineLabel];
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
        UIImage *img = [UIImage imageNamed:@"t_delete.png"];
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
//    T_GoodInfoEntity *entity = self.cellInfo;
//    [_imgView setCpxViewInfo:entity.img];
//    [_imgView load];
//    [_namelabel setText:entity.name];
//    
//    NSString *newPrice = [NSString stringWithFormat:@"￥%.2f",entity.shop_price];
//    [_newPrice setText:newPrice];
//    
//    NSString *oldPrice = [NSString stringWithFormat:@"￥%.2f",entity.market_price];
//    [_oldPrice setText:oldPrice];
//    
//    [self setCircleBtnImgWith:entity.selested];
}

-(void)setGoodsInfo:(id)entity{
    T_MenuEntity *enti = entity;
    if(number == 0){
        number = [enti.number integerValue];
    }
    [_infoLabel setText:enti.colorType];
}

-(void)selectAllGoods:(BOOL)selectAll{
//    T_GoodInfoEntity *entity = self.cellInfo;
//    if(selectAll){
//        selected = YES;
//        entity.selested = YES;
//    }else{
//        selected = NO;
//        entity.selested = NO;
//    }
    [self setCircleBtnImgWith:selected];
}

//选择按钮点击
-(void)circleBtnClick{
//    T_GoodInfoEntity *entity = self.cellInfo;
//    if(!selected){
//        selected = YES;
//        entity.selested = YES;
//        if(_delegate && [_delegate respondsToSelector:@selector(selectGoods)]){
//            [_delegate selectGoods];
//        }
//    }else{
//        selected = NO;
//        entity.selested = NO;
//        if(_delegate && [_delegate respondsToSelector:@selector(cancelGoods)]){
//            [_delegate cancelGoods];
//        }
//    }
    [self setCircleBtnImgWith:selected];
}

-(void)plusBtnClick{
//    number++;
//    NSString *str = [NSString stringWithFormat:@"%d",number];
//    [_numberLabel setText:str];
//    T_GoodInfoEntity *entity = self.cellInfo;
//    entity.buyNumber = number;
//    if(_delegate && [_delegate respondsToSelector:@selector(plusBtnClicked)]){
//        [_delegate plusBtnClicked];
//    }
}

-(void)minusBtnClick{
//    number--;
//    NSString *str = nil;
//    str = [NSString stringWithFormat:@"%d",number];
//    if(number<=1){
//        number = 1;
//        str = [NSString stringWithFormat:@"%d",1];
//    }
//    [_numberLabel setText:str];
//    T_GoodInfoEntity *entity = self.cellInfo;
//    entity.buyNumber = number;
//    if(_delegate && [_delegate respondsToSelector:@selector(minusBtnClicked)]){
//        [_delegate minusBtnClicked];
//    }
}

-(void)deleteBtnClicked{
//    T_GoodInfoEntity *entity = self.cellInfo;
//    if(_delegate && [_delegate respondsToSelector:@selector(deleteGoods:)]){
//        [_delegate deleteGoods:entity.goods_id];
//    }
}

-(void)setCircleBtnImgWith:(BOOL)select{
    if(select){
        [_circleBtn setImage:[UIImage imageNamed:@"t_Selected.png"] forState:UIControlStateNormal];
    }else{
        [_circleBtn setImage:[UIImage imageNamed:@"t_noneSelected.png"] forState:UIControlStateNormal];
    }
}

@end
