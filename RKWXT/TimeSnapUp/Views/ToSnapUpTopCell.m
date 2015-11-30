//
//  ToSnapUpTopCell.m
//  RKWXT
//
//  Created by app on 15/11/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ToSnapUpTopCell.h"
#import "HeardGoodsView.h"
#import "ToSnapUp.h"

#define priceH (45)


@interface ToSnapUpTopCell ()

@end

@implementation ToSnapUpTopCell

- (NSMutableArray*)childArray{
    if (!_childArray) {
        _childArray = [[NSMutableArray alloc]init];
    }
    return _childArray;
}


+ (instancetype)toSnapTopCellCreate:(UITableView *)tableview  goodsArray:(NSArray*)goodsArray{
    NSString *cellIndef = @"toSnapTopCell";
    ToSnapUpTopCell *cell = [tableview dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[ToSnapUpTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef  goodsArray:goodsArray];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  goodsArray:(NSArray*)goodsArray{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat widch = (self.width - ( TopMargin * 2 ) - (T_GoodsMaegin * 2) ) / goodsArray.count;
        
        for (int i = 0; i < goodsArray.count; i++) {
            HeardGoodsView *goods = [[HeardGoodsView alloc]init];
            CGFloat goodsX = TopMargin + (T_GoodsMaegin + widch) * i;
            goods.frame = CGRectMake(goodsX, 0, widch, self.height);
            goods.data = goodsArray[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTouch:)];
            [goods addGestureRecognizer:tap];
            tap.view.tag = i;
            [self.contentView addSubview:goods];
            self.goods = goods;
            [self.childArray addObject:goods];
        }
        
    }
    return self;
}


-(void)setGoodsArray:(NSArray *)goodsArray{
    _goodsArray = goodsArray;
    
    
    
    
}

- (void)clickTouch:(UITapGestureRecognizer*)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toSnapUpToCellWithTouch:index:)]) {
        [self.delegate toSnapUpToCellWithTouch:self index:tap.view.tag];
    }
}





+ (CGFloat)cellHeight{
    return 140;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}





@end
