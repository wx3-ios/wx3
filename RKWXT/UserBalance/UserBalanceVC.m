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
    NSArray *_nameArr;
    UILabel *_infoLabel;
}
@end

@implementation UserBalanceVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[BalanceModel alloc] init];
        [_model setDelegate:self];
        _nameArr = @[@"帐号",@"金额",@"状态",@"有限日期"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setTitle:@"查询余额"];
    
    UIScrollView *_scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setShowsHorizontalScrollIndicator:NO];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentOffset:CGPointMake(Size.width, Size.height+10)];
    [self.view addSubview:_scrollerView];
    
    [_scrollerView addSubview:[self showBaseView]];
    [_scrollerView addSubview:[self showRechargeBtn]];
    
    [_model loadUserBalance];
}

-(UIView *)showBaseView{
    CGFloat xOffset = 20;
    CGFloat yOffset = 25;
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, EveryCellHeight*WXT_Balance_Invalid);
    [baseView setBorderRadian:5.0 width:0.5 color:[UIColor grayColor]];
    [baseView setBackgroundColor:[UIColor clearColor]];
    
    xOffset = 8;
    yOffset = 8;
    CGFloat lineyGap = 0;
    CGFloat nameLabelWidth = 55;
    CGFloat namelabelHeight = 20;
    
    //显示内容
    CGFloat xGap = 75;
    CGFloat infoLabelWidth = 170;
    
    for(int i = 0; i < WXT_Balance_Invalid; i++){
        yOffset += (i>0?(22+namelabelHeight):0);
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:[UIColor grayColor]];
        [nameLabel setFont:WXTFont(13.0)];
        [nameLabel setText:_nameArr[i]];
        [baseView addSubview:nameLabel];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTag:i];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setFont:WXTFont(15.0)];
        [_infoLabel setTextColor:[UIColor grayColor]];
        if(i == WXT_Balance_Money){
            [_infoLabel setTextColor:[UIColor purpleColor]];
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
    UIView *btnView = [[UIView alloc] init];
    
    
    CGFloat xOffset = 22;
    CGFloat btnHeight = 30;
    CGFloat yOffset = (1+WXT_Balance_Invalid*EveryCellHeight)+100;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, btnHeight);
//    [btn setBackgroundColor:WXColorWithInteger(0x000000)];
    [btn setTitle:@"立即充值" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(gotoRecharge) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn];
    
    [btnView setFrame:btn.frame];
    return btnView;
}

-(void)gotoRecharge{
    
}

-(void)loadUserBalanceSucceed{
    
}

-(void)loadUserBalanceFailed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取余额信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
