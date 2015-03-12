//
//  UserBalanceVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserBalanceVC.h"
#import "UIView+Render.h"
#import "BalanceEntity.h"
#import "BalanceModel.h"

#define Size self.view.bounds.size
#define EveryCellHeight (36)

enum{
    WXT_Balance_Account = 0,
    WXT_Balance_Money,
    WXT_Balance_Status,
    WXT_Balance_Date,
    
    WXT_Balance_Invalid,
};

@interface UserBalanceVC()<UIScrollViewDelegate,LoadUserBalanceDelegate>{
    BalanceModel *_model;
    BalanceEntity *_entity;
    NSArray *_nameArr;
    UIScrollView *_scrollerView;
}
@end

@implementation UserBalanceVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[BalanceModel alloc] init];
        [_model setDelegate:self];
        _nameArr = @[@"帐号:",@"金额:",@"状态:",@"有限日期:"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setTitle:@"查询余额"];
    
     _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height+10)];
    [self.view addSubview:_scrollerView];
    [_scrollerView addSubview:[self showRechargeBtn]];
    
    [_model loadUserBalance];
}

-(UIView *)showBaseView{
    CGFloat xOffset = 20;
    CGFloat yOffset = 100;
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, EveryCellHeight*WXT_Balance_Invalid);
    [baseView setBorderRadian:5.0 width:0.5 color:[UIColor grayColor]];
    [baseView setBackgroundColor:[UIColor clearColor]];
    
    xOffset = 8;
    yOffset = 8;
    CGFloat lineyGap = 0;
    CGFloat nameLabelWidth = 60;
    CGFloat namelabelHeight = 20;
    
    //显示内容
    CGFloat xGap = 75;
    CGFloat infoLabelWidth = 170;
    
    for(int i = 0; i < WXT_Balance_Invalid; i++){
        yOffset += (i>0?(16+namelabelHeight):0);
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:[UIColor grayColor]];
        [nameLabel setFont:WXTFont(13.0)];
        [nameLabel setText:_nameArr[i]];
        [baseView addSubview:nameLabel];
        
        UILabel *_infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTag:i];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setFont:WXTFont(15.0)];
        [_infoLabel setTextColor:[UIColor grayColor]];
        
        NSString *infoStr = nil;
        switch (i) {
            case WXT_Balance_Account:
                infoStr = @"18613213051";
                break;
            case WXT_Balance_Money:
                infoStr = [NSString stringWithFormat:@"%.2f",_entity.money];
                break;
            case WXT_Balance_Status:
                infoStr = _entity.status;
                break;
            case WXT_Balance_Date:
                infoStr = _entity.date;
                break;
            default:
                break;
        }
        [_infoLabel setText:infoStr];
        if(i == WXT_Balance_Money){
            [_infoLabel setTextColor:[UIColor redColor]];
        }
        [baseView addSubview:_infoLabel];
        
        if(i == WXT_Balance_Invalid-1){
            break;
        }
        
        lineyGap += EveryCellHeight;
        UILabel *line = [[UILabel alloc] init];
        line.frame = CGRectMake(0, lineyGap, Size.width-2*xOffset, 0.5);
        [line setBackgroundColor:[UIColor grayColor]];
        [baseView addSubview:line];
    }
    return baseView;
}

-(UIView*)showRechargeBtn{
    CGFloat xOffset = 22;
    CGFloat btnHeight = 30;
    CGFloat yOffset = WXT_Balance_Invalid*EveryCellHeight;
    WXTUIButton *btn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(xOffset, 2.3*yOffset, Size.width-2*xOffset, btnHeight);
//    [btn setBackgroundColor:WXColorWithInteger(0x000000)];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn setBackgroundImageOfColor:[UIColor redColor] controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:[UIColor grayColor] controlState:UIControlStateSelected];
    [btn setTitle:@"立即充值" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(gotoRecharge) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)gotoRecharge{
    
}

-(void)loadUserBalanceSucceed{
    if([_model.dataList count] > 0){
        _entity = [_model.dataList objectAtIndex:0];
        [_scrollerView addSubview:[self showBaseView]];
    }
}

-(void)loadUserBalanceFailed:(NSString *)errorMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
