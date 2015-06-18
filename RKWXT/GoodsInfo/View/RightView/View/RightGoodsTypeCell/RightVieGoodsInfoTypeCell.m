//
//  RightVieGoodsInfoTypeCell.m
//  RKWXT
//
//  Created by SHB on 15/6/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RightVieGoodsInfoTypeCell.h"
#import "GoodsInfoEntity.h"

@interface RightVieGoodsInfoTypeCell(){
    WXUIButton *selBtn;
    WXUIImageView *bgImgView;
}
@end

@implementation RightVieGoodsInfoTypeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 30;
        CGFloat btnWidth = self.bounds.size.width-50-xOffset;
        CGFloat btnHeight = 25;
        bgImgView = [[WXUIImageView alloc] initWithImage:[UIImage imageNamed:@"citySelectedImg.png"]];
        bgImgView.frame = CGRectMake(xOffset-4, (RightVieGoodsInfoTypeCellHeight-btnHeight)/2-4, btnWidth-2*xOffset+8, btnHeight+8);
        
        selBtn = [[WXUIButton alloc] initWithFrame:CGRectMake(xOffset, (RightVieGoodsInfoTypeCellHeight-btnHeight)/2, btnWidth-2*xOffset, btnHeight)];
        [selBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateNormal];
        [selBtn setBackgroundImageOfColor:[UIColor grayColor] controlState:UIControlStateSelected];
        [selBtn setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0xCBCBCB)];
        [selBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [selBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(buttonImageClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [bgImgView removeFromSuperview];
    [selBtn setTitle:entity.stockName forState:UIControlStateNormal];
    if([_goodsEntity.stockName isEqualToString:entity.stockName]){
        [self addSubview:bgImgView];
    }
    [self addSubview:selBtn];
}

-(void)buttonImageClicked{
    GoodsInfoEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(selectGoodsType:)]){
        [_delegate selectGoodsType:entity];
    }
}

@end
