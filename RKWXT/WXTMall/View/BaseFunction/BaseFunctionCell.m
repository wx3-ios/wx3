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
        NSArray *textArr = @[@"签到",@"充值",@"钱包",@"订单"];
        NSArray *imgArr = @[@"HomePageSign.png",@"HomePageRecharge.png",@"HomePageWallet.png",@"HomePageOrderList.png"];
        CGFloat xgap = (IPHONE_SCREEN_WIDTH-4*OneFunctionWidth)/5;
        CGFloat yOffset = 3;
        for(int i = 0; i < 4; i++){
            _button = [WXUIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(xgap+(xgap+OneFunctionWidth)*i, yOffset, OneFunctionWidth, OneFunctionHeight);
            _button.tag = i+1;
            [_button setBackgroundColor:[UIColor clearColor]];
            [_button setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateSelected];
            [_button setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
            [_button setTitle:textArr[i] forState:UIControlStateNormal];
            [_button setTitle:textArr[i] forState:UIControlStateSelected];
            [_button.titleLabel setFont:[UIFont systemFontOfSize:BigTextFont]];
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [_button setTitleColor:WXColorWithInteger(BigTextColor) forState:UIControlStateNormal];
            [_button setTitleColor:WXColorWithInteger(BigTextColor) forState:UIControlStateSelected];
            [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_button];
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
            t_baseFunction = T_BaseFunction_Sign;
            break;
        case 2:
            t_baseFunction = T_BaseFunction_Recharge;
            break;
        case 3:
            t_baseFunction = T_BaseFunction_Wallet;
            break;
        case 4:
            t_baseFunction = T_BaseFunction_Order;
            break;
        default:
            break;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(baseFunctionBtnClickedAtIndex:)]){
        [_delegate baseFunctionBtnClickedAtIndex:t_baseFunction];
    }
}

@end
