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

#import "NewGoodsInfoVC.h"
#import "GoodsAttentionModel.h"
@interface CollectionListVC ()<UITableViewDataSource,UITableViewDelegate,GoodsListModerDelegate,NewGoodsInfoVCDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *goodsID;
@property (nonatomic,strong)GoodsListModer *moder;
@property (nonatomic,assign)NSInteger index;
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
    
    GoodsListModer *moder = [[GoodsListModer alloc]init];
    [moder requestNotWork:2];
    moder.delegate  = self;
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
   }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    newGoods.delegate = self;
    NSUInteger count = [chantID.scare_buying_id integerValue];
    if (count <= 0) {
         newGoods.goodsId = [chantID.goods_id integerValue];
    }else{
        TimeShopData *info = chantID.dataArray[0];
        newGoods.lEntity = info;
        newGoods.goodsInfo_type = GoodsInfo_LimitGoods;
    }
      self.index = indexPath.row;
    
    [self.wxNavigationController pushViewController:newGoods];
    
}


#pragma mark  -- ------------------- 代理方法
- (void)requestNotWorkSuccessful:(NSMutableArray *)goodsID{
     [self unShowWaitView];
    
     self.goodsID = goodsID;
    [self.tableview reloadData];
   
}



- (void)requestNotWorkFailure:(NSString *)error{
    [self unShowWaitView];
    if(!error){
        error = @"没有收藏商品";
    }
    
   [UtilTool showAlertView:error];

}


-(void)cancelGoodsCollection:(NewGoodsInfoVC *)infoVC data:(TimeShopData *)data goodsID:(NSInteger)goodsID{
    
    NSArray *array = [NSArray arrayWithArray:self.goodsID];
    if (data == nil) {
        for (MerchantID *chantID in array) {
            if ([chantID.goods_id integerValue] == goodsID) {
                [self.goodsID removeObject:chantID];
            }
        }
        
        
    }else{
        
        for (MerchantID *chantID in array) {
            for (TimeShopData *shopTime in chantID.dataArray) {
                
                if ([shopTime isEqual:data]) {
                    [self.goodsID removeObject:chantID];
                }
            }
        }
    }
    
    [self.tableview reloadData];
}

- (void)addGoodsCollection:(NewGoodsInfoVC *)infoVC data:(TimeShopData *)data{
    if (data) {
        MerchantID *chantID = [[MerchantID alloc]init];
        chantID.scare_buying_id = data.scare_buying_id;
        [chantID.dataArray addObject:data];
        [self.goodsID addObject:chantID];
    }else{
        GoodsListModer *moder = [[GoodsListModer alloc]init];
        [moder requestNotWork:2];
        moder.delegate  = self;
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        
    }
    [self.tableview reloadData];
}

@end
