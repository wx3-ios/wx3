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
#import "MerchantID.h"
#import "TimeShopData.h"
#import "UIViewAdditions.h"

#import "GoodsListInfo.h"
#import "NewGoodsInfoVC.h"
#import "GoodsAttentionModel.h"
@interface CollectionListVC ()<UITableViewDataSource,UITableViewDelegate,GoodsListModerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *goodsID;
@property (nonatomic,strong)GoodsListModer *moder;
@end

@implementation CollectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"收藏列表"];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
 
   }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     GoodsListModer *moder = [[GoodsListModer alloc]init];
     [moder requestNotWork:2];
     moder.delegate  = self;
   // [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsID.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionListCell *cell = [CollectionListCell collectionCreatCell:tableView];
    cell.height = [CollectionListCell cellHeight];
    cell.chartID = self.goodsID[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CollectionListCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MerchantID *chantID = self.goodsID[indexPath.row];
    NewGoodsInfoVC *newGoods = [[NewGoodsInfoVC alloc]init];

    NSUInteger count = [chantID.scare_buying_id integerValue];
    if (count <= 0) {
         newGoods.goodsId = [chantID.goods_id integerValue];
    }else{
        TimeShopData *info = chantID.dataArray[0];
        newGoods.lEntity = info;
        newGoods.goodsInfo_type = GoodsInfo_LimitGoods;
    }
    
    [self.wxNavigationController pushViewController:newGoods];
    
}


#pragma mark  -- ------------------- 代理方法
- (void)requestNotWorkSuccessful:(NSMutableArray *)goodsID{
    self.goodsID = goodsID;
    
    [self.tableview reloadData];
}



- (void)requestNotWorkFailure:(NSString *)error{
    [self unShowWaitView];
    if(!error){
        error = @"加载数据失败";
    }
   // [UtilTool showAlertView:error];

}






@end
