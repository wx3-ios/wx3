//
//  LMGoodsView.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsView.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define xSide (12)
#define ViewWidth IPHONE_SCREEN_WIDTH-2*xSide
#define ViewHeight IPHONE_SCREEN_WIDTH
#define DownViewHeight (70)

@interface LMGoodsView()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    WXUIView *_maskShell;
    WXUIView *_baseView;
    
    WXUILabel *stockNumLabel;
    WXUILabel *pricelaebl;
    WXUILabel *buyNumLabel;
    WXUIButton *buyBtn;
}
@end

@implementation LMGoodsView

-(id)init{
    self = [super init];
    if(self){
        [self initBaseInfo];
    }
    return self;
}

-(void)initBaseInfo{
    _maskShell = [[WXUIView alloc] init];
    [_maskShell setFrame:self.bounds];
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
    
    [self downViewBtn];
    
    CGFloat yOffset = 90;
    _baseView = [[WXUIView alloc] init];
    _baseView.frame = CGRectMake(xSide, yOffset, ViewWidth, ViewHeight);
    [_baseView setBackgroundColor:[UIColor whiteColor]];
    [_baseView setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [self addSubview:_baseView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight-DownViewHeight);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_baseView addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableHeaderView]];
    [_tableView setTableFooterView:nil];
}

-(void)downViewBtn{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(0, ViewHeight-DownViewHeight, ViewWidth, DownViewHeight);
    [downView setBackgroundColor:[UIColor clearColor]];
    [_baseView addSubview:downView];
    
    CGFloat xOffset = 10;
    CGFloat btnHeight = 40;
    buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, ViewWidth-2*xOffset, btnHeight);
    [buyBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [buyBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [downView addSubview:buyBtn];
}

-(WXUIView*)tableHeaderView{
    WXUIView *headerView = [[WXUIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ViewWidth, 44);
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat titleLabelWidth = 80;
    CGFloat titlelabelHeight = 16;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((ViewWidth-titleLabelWidth)/2, (44-titlelabelHeight)/2, titleLabelWidth, titlelabelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"选择属性"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(10.0)];
    [titleLabel setTextColor:WXColorWithInteger(0xfafafa)];
    [headerView addSubview:titleLabel];
    return headerView;
}

-(WXUIView *)tableFootView{
    WXUIView *footView = [[WXUIView alloc] init];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    
    CGFloat yOffset = 1;
    WXUILabel *upLineLabel = [[WXUILabel alloc] init];
    upLineLabel.frame = CGRectMake(0, yOffset, ViewWidth, 0.5);
    [upLineLabel setBackgroundColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:upLineLabel];
    
    yOffset += 0.5;
    CGFloat yGap = 13;
    CGFloat xGap = 2;
    CGFloat labelWidth = ViewWidth/2-2*xGap;
    CGFloat labelHeight = 18;
    WXUILabel *stockName = [[WXUILabel alloc] init];
    stockName.frame = CGRectMake(xGap, yGap, labelWidth, labelHeight);
    [stockName setBackgroundColor:[UIColor clearColor]];
    [stockName setText:@"库存"];
    [stockName setTextAlignment:NSTextAlignmentCenter];
    [stockName setFont:WXFont(12.0)];
    [stockName setTextColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:stockName];
    
    yOffset += labelHeight+yGap+18;
    stockNumLabel = [[WXUILabel alloc] init];
    stockNumLabel.frame = CGRectMake(xGap, yOffset, labelWidth, labelHeight);
    [stockNumLabel setBackgroundColor:[UIColor clearColor]];
    [stockNumLabel setTextAlignment:NSTextAlignmentCenter];
    [stockNumLabel setTextColor:WXColorWithInteger(0x000000)];
    [stockNumLabel setFont:WXFont(12.0)];
    [footView addSubview:stockNumLabel];
    
    WXUILabel *plusLabel = [[WXUILabel alloc] init];
    plusLabel.frame = CGRectMake(ViewWidth/2+xGap, yGap, labelWidth, labelHeight);
    [plusLabel setBackgroundColor:[UIColor clearColor]];
    [plusLabel setText:@"合计"];
    [plusLabel setTextAlignment:NSTextAlignmentCenter];
    [plusLabel setFont:WXFont(12.0)];
    [plusLabel setTextColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:plusLabel];
    
    pricelaebl = [[WXUILabel alloc] init];
    pricelaebl.frame = CGRectMake(ViewWidth/2+xGap, yOffset, labelWidth, labelHeight);
    [pricelaebl setBackgroundColor:[UIColor clearColor]];
    [pricelaebl setTextAlignment:NSTextAlignmentCenter];
    [pricelaebl setTextColor:WXColorWithInteger(0xdd2726)];
    [pricelaebl setFont:WXFont(12.0)];
    [footView addSubview:pricelaebl];
    
    yOffset += labelHeight+15;
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(ViewWidth/2, 6, 0.5, (yOffset-2*6));
    [lineLabel setBackgroundColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:lineLabel];
    
    WXUILabel *downLine = [[WXUILabel alloc] init];
    downLine.frame = CGRectMake(0, yOffset, ViewWidth, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:downLine];
    
    CGFloat numLabelWidth = 50;
    yOffset += 12;
    CGFloat btnWidth = 25;
    CGFloat btnHeight = btnWidth;
    WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.frame = CGRectMake((ViewWidth/2-numLabelWidth/2-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [minusBtn setBackgroundColor:[UIColor clearColor]];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:WXColorWithInteger(0xfafafa) forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:minusBtn];
    
    buyNumLabel = [[WXUILabel alloc] init];
    buyNumLabel.frame = CGRectMake((ViewWidth-numLabelWidth)/2, yOffset, numLabelWidth, btnHeight);
    [buyNumLabel setBackgroundColor:[UIColor clearColor]];
    [buyNumLabel setTextAlignment:NSTextAlignmentCenter];
    [buyNumLabel setText:@"1"];
    [buyNumLabel setFont:WXFont(10.0)];
    [buyNumLabel setTextColor:WXColorWithInteger(0xfafafa)];
    [footView addSubview:buyNumLabel];
    
    WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(ViewWidth/2+(ViewWidth/2-numLabelWidth/2-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [plusBtn setBackgroundColor:[UIColor clearColor]];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:WXColorWithInteger(0xfafafa) forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:plusBtn];
    
    footView.frame = CGRectMake(0, 0, ViewWidth, 0);
    return footView;
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

#pragma mark changeBuyNumber
-(void)plusBtnClick{
    
}

-(void)minusBtnClicked{
    
}

@end
