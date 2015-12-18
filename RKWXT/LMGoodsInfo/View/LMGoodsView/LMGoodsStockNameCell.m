//
//  LMGoodsStockNameCell.m
//  RKWXT
//
//  Created by SHB on 15/12/18.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsStockNameCell.h"
#import "LMGoodsInfoEntity.h"

@interface LMGoodsStockNameCell(){
    WXUIButton *stockBtn;
}
@end

@implementation LMGoodsStockNameCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat btnWidth = 200;
        CGFloat btnHeight = 30;
        stockBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        stockBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, (LMGoodsStockNameCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [stockBtn setBorderRadian:7.0 width:1.0 color:[UIColor clearColor]];
        [stockBtn setBackgroundColor:[UIColor grayColor]];
        [stockBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [stockBtn addTarget:self action:@selector(stockBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:stockBtn];
    }
    return self;
}

-(void)load{
    LMGoodsInfoEntity *entity = self.cellInfo;
    [stockBtn setTitle:entity.stockName forState:UIControlStateNormal];
    if(entity.selected){
        [stockBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    }else{
        [stockBtn setBackgroundColor:WXColorWithInteger(0x9b9b9b)];
    }
}

-(void)stockBtnClicked{
    LMGoodsInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(lmGoodsStockNameBtnClicked:)]){
        [_delegate lmGoodsStockNameBtnClicked:entity];
    }
}

@end
