//
//  LMShoppingCartVC.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartVC.h"
#import "LMShoppingCartTitleCell.h"
#import "LMShoppingCartGoodsListCell.h"

#define Size self.bounds.size
#define DownViewHeight (42)

@interface LMShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    
    WXUILabel *moneyLabel;
}

@end

@implementation LMShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的购物车"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self downInfoView]];
}

-(WXUIView*)downInfoView{
    WXUIView *downView = [[WXUIView alloc] init];
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat xOffset = 10;
    CGFloat labelWidth = 40;
    CGFloat labelHeight = 15;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, (DownViewHeight-labelHeight)/2, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setText:@"合计:"];
    [textLabel setTextColor:WXColorWithInteger(0xfafafa)];
    [textLabel setFont:WXFont(12.0)];
    [downView addSubview:textLabel];
    
    xOffset += labelWidth;
    moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, (DownViewHeight-labelHeight)/2, labelWidth, 110);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [moneyLabel setFont:WXFont(11.0)];
    [downView addSubview:moneyLabel];
    
    CGFloat btnWidth = 80;
    WXUIButton *balanceBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    balanceBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth, 0, btnWidth, DownViewHeight);
    [balanceBtn setBackgroundColor:WXColorWithInteger(0xd2726)];
    [balanceBtn setTitle:@"结算" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(balanceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:balanceBtn];
    
    [downView setFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT-DownViewHeight, IPHONE_SCREEN_WIDTH, DownViewHeight)];
    return downView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger row = indexPath.row;
    if(row == 0){
        height = LMShoppingCartTitleCellHieght;
    }else{
        height= LMShoppingCartGoodsListCellHeight;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section > 0){
        height = 7;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark balance
-(void)balanceBtnClicked{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
