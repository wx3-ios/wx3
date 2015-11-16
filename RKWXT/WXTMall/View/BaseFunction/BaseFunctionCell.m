//
//  BaseFunctionCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "BaseFunctionCell.h"
#import "NewHomePageCommonDef.h"
#define OneFunctionWidth (60)
#define OneFunctionHeight (30)

@interface BaseFunctionCell(){
    WXUIButton *_button;
}
@end

@implementation BaseFunctionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        NSArray *textArr = @[@"抽奖",@"签到",@"红包",@"订单",@"充值",@"余额",@"提成",@"联盟"];
        NSArray *imgArr = @[@"HomePageShark.png",@"HomePageSign.png",@"HomePageWallet.png",@"HomePageOrderList.png",@"HomePageRecharge.png",@"HomePageBalance.png",@"HomePageCut.png",@"HomePageUnion.png"];
        CGFloat xgap = (IPHONE_SCREEN_WIDTH-4*OneFunctionWidth)/5;
        CGFloat yOffset = 6;
        NSInteger count = 0;
        for(int j = 0; j < 2; j++){
            for(int i = 0; i < 4; i++){
                count = (j==1?i+4:i);
                _button = [WXUIButton buttonWithType:UIButtonTypeCustom];
                _button.frame = CGRectMake(xgap+(xgap+OneFunctionWidth)*i, yOffset+(j==1?(5+OneFunctionHeight):0), OneFunctionWidth, OneFunctionHeight);
                _button.tag = count+1;
                [_button setBackgroundColor:[UIColor clearColor]];
                [_button setImage:[UIImage imageNamed:imgArr[count]] forState:UIControlStateNormal];
                [_button setImage:[UIImage imageNamed:imgArr[count]] forState:UIControlStateSelected];
                [_button setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
                [_button setTitle:textArr[count] forState:UIControlStateNormal];
                [_button setTitle:textArr[count] forState:UIControlStateSelected];
                [_button.titleLabel setFont:[UIFont systemFontOfSize:BigTextFont]];
                [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                [_button setTitleColor:WXColorWithInteger(BigTextColor) forState:UIControlStateNormal];
                [_button setTitleColor:WXColorWithInteger(BigTextColor) forState:UIControlStateSelected];
                [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_button];
            }
        }
    }
    return self;
}

-(void)buttonClicked:(id)sender{
    WXUIButton *btn = (WXUIButton*)sender;
    NSInteger tag = btn.tag;
    T_BaseFunction t_baseFunction = T_BaseFunction_Init;
    switch (tag) {
        case 1:
            t_baseFunction = T_BaseFunction_Shark;
            break;
        case 2:
            t_baseFunction = T_BaseFunction_Sign;
            break;
        case 3:
            t_baseFunction = T_BaseFunction_Wallet;
            break;
        case 4:
            t_baseFunction = T_BaseFunction_Order;
            break;
        case 5:
            t_baseFunction = T_BaseFunction_Recharge;
            break;
        case 6:
            t_baseFunction = T_BaseFunction_Balance;
            break;
        case 7:
            t_baseFunction = T_BaseFunction_Cut;
            break;
        case 8:
            t_baseFunction = T_BaseFunction_Union;
            break;
        default:
            break;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(baseFunctionBtnClickedAtIndex:)]){
        [_delegate baseFunctionBtnClickedAtIndex:t_baseFunction];
    }
}

@end
