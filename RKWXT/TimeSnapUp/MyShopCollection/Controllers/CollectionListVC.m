//
//  CollectionListVC.m
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CollectionListVC.h"
#import "CollectionListCell.h"
#import "GoodsListModer.h"

#import "GoodsListInfo.h"
#import "NewGoodsInfoVC.h"

@interface CollectionListVC ()<UITableViewDataSource,UITableViewDelegate,GoodsListModerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *goodsInfo;
@end

@implementation CollectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"收藏列表"];
    
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    
    GoodsListModer *moder = [[GoodsListModer alloc]init];
    moder.delegate  = self;
    [moder requestNotWork:2];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionListCell *cell = [CollectionListCell collectionCreatCell:tableView];
    cell.info = self.goodsInfo[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CollectionListCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    GoodsListInfo *info = self.goodsInfo[indexPath.row];
//    NewGoodsInfoVC *newGoods = [[NewGoodsInfoVC alloc]init];
//    newGoods.lEntity = info;
//    newGoods.goodsInfo_type = GoodsInfo_LimitGoods;
//    [self.wxNavigationController pushViewController:newGoods];
}


#pragma mark  -- ------------------- 代理方法
- (void)requestNotWorkSuccessful:(NSMutableArray *)goodsInfo{
    self.goodsInfo = goodsInfo;
    
    [self.tableview reloadData];
}



- (void)requestNotWorkFailure:(NSString *)error{
    [self unShowWaitView];
    if(!error){
        error = @"加载数据失败";
    }
    [UtilTool showAlertView:error];

}






@end
