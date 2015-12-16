//
//  LMOrderInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderInfoVC.h"
#import "LMOrderInfoOrderStateCell.h"
#import "LMOrderInfoUserAddressCell.h"
#import "LMOrderInfoShopCell.h"
#import "LMOrderInfoGoodsListCell.h"
#import "LMOrderInfoMoneyCell.h"
#import "LMOrderInfoContactShopCell.h"
#import "LMOrderInfoOrderTimeCell.h"

#define Size self.bounds.size

enum{
    LMOrderInfo_Section_OrderState = 0,
    LMOrderInfo_Section_UserAddress,
    LMOrderInfo_Section_ShopName,
    LMOrderInfo_Section_GoodsList,
    LMOrderInfo_Section_GoodsMoney,
    LMOrderInfo_Section_ContactShop,
    LMOrderInfo_Section_OrderTime,
    
    LMOrderInfo_Section_Invalid,
};

@interface LMOrderInfoVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation LMOrderInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return LMOrderInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if(section == LMOrderInfo_Section_GoodsList){
        row = 2;
    }else{
        row = 1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMOrderInfo_Section_OrderState:
            height = LMOrderInfoOrderStateCellHeight;
            break;
        case LMOrderInfo_Section_UserAddress:
            height = [LMOrderInfoUserAddressCell cellHeightOfInfo:nil];
            break;
        case LMOrderInfo_Section_ShopName:
            height = LMOrderInfoContactShopCellHeight;
            break;
        case LMOrderInfo_Section_GoodsList:
            height = LMOrderInfoGoodsListCellHeight;
            break;
        case LMOrderInfo_Section_GoodsMoney:
            height = [LMOrderInfoMoneyCell cellHeightOfInfo:nil];
            break;
        case LMOrderInfo_Section_ContactShop:
            height = LMOrderInfoContactShopCellHeight;
            break;
        case LMOrderInfo_Section_OrderTime:
            height = LMOrderInfoOrderTimeCellHieght;
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

@end
