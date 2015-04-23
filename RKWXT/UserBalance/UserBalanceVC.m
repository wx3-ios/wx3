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
#import "RechargeVC.h"

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
    
    UILabel *_money;
    UILabel *_status;
    UILabel *_date;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"余额"];
    
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height+10)];
    [self addSubview:_scrollerView];
    [_scrollerView addSubview:[self showRechargeBtn]];
    
    [_model loadUserBalance];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [self showBaseView];
}

-(void)showBaseView{
    CGFloat xOffset = 20;
    CGFloat yOffset = 20;
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
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    
    for(int i = 0; i < WXT_Balance_Invalid; i++){
        yOffset += (i>0?(16+namelabelHeight):0);
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x969696)];
        [nameLabel setFont:WXTFont(12.0)];
        [nameLabel setText:_nameArr[i]];
        [baseView addSubview:nameLabel];
        
        if(i != WXT_Balance_Invalid-1){
            lineyGap += EveryCellHeight;
            UILabel *line = [[UILabel alloc] init];
            line.frame = CGRectMake(0, lineyGap, Size.width-2*xOffset, 0.5);
            [line setBackgroundColor:[UIColor grayColor]];
            [baseView addSubview:line];
        }
    }
    yOffset = 8;
    UILabel *_infoLabel = [[UILabel alloc] init];
    _infoLabel.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
    [_infoLabel setBackgroundColor:[UIColor clearColor]];
    [_infoLabel setText:userDefault.user];
    [_infoLabel setTextAlignment:NSTextAlignmentCenter];
    [_infoLabel setFont:WXTFont(13.0)];
    [_infoLabel setTextColor:WXColorWithInteger(0x646464)];
    [baseView addSubview:_infoLabel];
    
    yOffset += 37;
    _money = [[UILabel alloc] init];
    _money.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
    [_money setBackgroundColor:[UIColor clearColor]];
    [_money setTextAlignment:NSTextAlignmentCenter];
    [_money setFont:WXTFont(13.0)];
    [_money setTextColor:WXColorWithInteger(0x0c8bdf)];
    [baseView addSubview:_money];
    
    yOffset += 37;
    _status = [[UILabel alloc] init];
    _status.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
    [_status setBackgroundColor:[UIColor clearColor]];
    [_status setTextAlignment:NSTextAlignmentCenter];
    [_status setFont:WXTFont(13.0)];
    [_status setTextColor:WXColorWithInteger(0x646464)];
    [baseView addSubview:_status];
    
    yOffset += 34;
    _date = [[UILabel alloc] init];
    _date.frame = CGRectMake(xGap, yOffset, infoLabelWidth, namelabelHeight);
    [_date setBackgroundColor:[UIColor clearColor]];
    [_date setTextAlignment:NSTextAlignmentCenter];
    [_date setFont:WXTFont(13.0)];
    [_date setTextColor:WXColorWithInteger(0x646464)];
    [baseView addSubview:_date];
    
    [_scrollerView addSubview:baseView];
}

-(UIView*)showRechargeBtn{
    CGFloat xOffset = 22;
    CGFloat btnHeight = 32;
    CGFloat yOffset = WXT_Balance_Invalid*EveryCellHeight;
    WXTUIButton *btn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(xOffset, 1.4*yOffset, Size.width-2*xOffset, btnHeight);
    [btn setBorderRadian:10.0 width:0.5 color:[UIColor clearColor]];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [btn setTitle:@"立即充值" forState:UIControlStateNormal];
    [btn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoRecharge) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)gotoRecharge{
    RechargeVC *rechargeVC = [[RechargeVC alloc] init];
    [self.wxNavigationController pushViewController:rechargeVC];
}

-(void)loadUserBalanceSucceed{
    [self unShowWaitView];
    if([_model.dataList count] > 0){
        _entity = [_model.dataList objectAtIndex:0];
        [_money setText:[NSString stringWithFormat:@"%.2f",_entity.money]];
        [_status setText:[NSString stringWithFormat:@"%@",_entity.status]];
        [_date setText:[NSString stringWithFormat:@"%@",_entity.date]];
    }
}

-(void)loadUserBalanceFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
}

@end
