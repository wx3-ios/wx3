//
//  RightGoodsSelNumCell.m
//  RKWXT
//
//  Created by SHB on 15/6/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RightGoodsSelNumCell.h"

@interface RightGoodsSelNumCell(){
    WXUILabel *_numberLabel;
    NSInteger number;
}
@end

@implementation RightGoodsSelNumCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 30;
        CGFloat labelWidth = 45;
        CGFloat labelHeight = 25;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(xOffset, (RightGoodsSelNumCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"数量"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:WXFont(16.0)];
        [self.contentView addSubview:label];
        
        xOffset += labelWidth;
        CGFloat markWidth = 25;
        CGFloat markHeight = 26;
        WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(xOffset, (RightGoodsSelNumCellHeight-markHeight)/2, markWidth, markHeight);
        [plusBtn setBackgroundColor:[UIColor whiteColor]];
        [plusBtn setBorderRadian:1.0 width:0.4 color:[UIColor blackColor]];
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:plusBtn];
        
        xOffset += markWidth+5;
        CGFloat numBtnWidth = 27;
        _numberLabel = [[WXUILabel alloc] init];
        _numberLabel.frame = CGRectMake(xOffset, (RightGoodsSelNumCellHeight-markHeight)/2, numBtnWidth, markWidth);
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setTextColor:[UIColor blackColor]];
        [_numberLabel setText:@"1"];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_numberLabel];
        
        xOffset += numBtnWidth+5;
        WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        minusBtn.frame = CGRectMake(xOffset, (RightGoodsSelNumCellHeight-markHeight)/2, markWidth, markHeight);
        [minusBtn setBackgroundColor:[UIColor whiteColor]];
        [minusBtn setBorderRadian:1.0 width:0.4 color:[UIColor blackColor]];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:minusBtn];
    }
    return self;
}

-(void)load{
    
}

-(void)plusBtnClick{
    number ++;
    [_numberLabel setText:[NSString stringWithFormat:@"%ld",(long)number]];
    if(_delegte && [_delegte respondsToSelector:@selector(setGoodsSelNumber:)]){
        [_delegte setGoodsSelNumber:number];
    }
}

-(void)minusBtnClick{
    if(number==1){
        return;
    }
    number --;
    [_numberLabel setText:[NSString stringWithFormat:@"%ld",(long)number]];
    if(_delegte && [_delegte respondsToSelector:@selector(setGoodsSelNumber:)]){
        [_delegte setGoodsSelNumber:number];
    }
}

@end
