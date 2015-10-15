//
//  RightGoodsStoreCell.m
//  RKWXT
//
//  Created by SHB on 15/6/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RightGoodsStoreCell.h"
#import "GoodsInfoEntity.h"

@interface RightGoodsStoreCell(){
    UILabel *_money;
    UILabel *_storeNum;
}
@end

@implementation RightGoodsStoreCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 30;
        CGFloat yOffset = 5;
        CGFloat labelWidth = 170;
        CGFloat labelheight = 25;
        _money = [[UILabel alloc] init];
        _money.frame = CGRectMake(xOffset, yOffset, labelWidth, labelheight);
        [_money setBackgroundColor:[UIColor clearColor]];
        [_money setTextAlignment:NSTextAlignmentLeft];
        [_money setTextColor:[UIColor blackColor]];
        [_money setFont:WXFont(15.0)];
        [self.contentView addSubview:_money];
        
        yOffset += labelheight+2;
        _storeNum = [[UILabel alloc] init];
        _storeNum.frame = CGRectMake(xOffset, yOffset, labelWidth, labelheight);
        [_storeNum setBackgroundColor:[UIColor clearColor]];
        [_storeNum setTextAlignment:NSTextAlignmentLeft];
        [_storeNum setTextColor:[UIColor redColor]];
        [_storeNum setFont:WXFont(15.0)];
        [self.contentView addSubview:_storeNum];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    [_money setText:[NSString stringWithFormat:@"商品总计: ￥%.2f",entity.stockPrice]];
    [_storeNum setText:[NSString stringWithFormat:@"库存剩余: %ld",(long)entity.stockNumber]];
    
    if(_number > 1){
        [_money setText:[NSString stringWithFormat:@"商品总计: ￥%.2f",entity.stockPrice*_number]];
    }
}

@end
