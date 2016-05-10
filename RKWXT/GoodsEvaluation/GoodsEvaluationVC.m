//
//  GoodsEvaluationVC.m
//  RKWXT
//
//  Created by app on 16/4/27.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsEvaluationVC.h"
#import "GoodsEvaluationModel.h"
#import "MJRefresh.h"
#import "NewGEvalutionInfoCell.h"
#import "MJRefresh.h"


@interface GoodsEvaluationVC ()<UITableViewDataSource,UITableViewDelegate,GoodsEvaluationModelDelegate>
{
    UITableView *_tableView;
    GoodsEvaluationModel *_model;
}

@end

@implementation GoodsEvaluationVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[GoodsEvaluationModel alloc]init];
        _model.delegate = self;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商品评价"];
    
    [self loadSubTableView];
    
    [self requestNetWork];
    
    [self setupRefresh];
}

- (void)loadSubTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView =  [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_tableView];
}

- (void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(clickLoadEvaluation)];
    
    // 2.下拉加载更多(进入刷新状态就会调用self的heardRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(requestNetWork)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

- (void)requestNetWork{
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
    [_model lookGoodsEvaluationGoodsID:self.goodsID start:0 length:10];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}


-(void)viewDidLayoutSubviews {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.goAtionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [NewGEvalutionInfoCell cellHeightOfInfo:_model.goAtionArr[indexPath.row]];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    NewGEvalutionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NewGEvalutionInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    [cell setCellInfo:_model.goAtionArr[indexPath.row]];
    [cell load];
    return cell;
}

- (void)clickLoadEvaluation{
    [_model lookGoodsEvaluationGoodsID:self.goodsID start:[_model.goAtionArr count] length:10];
}


#pragma mark --- evaluationModel Delegate
-(void)loadGoodsEvaluationSucceed{
     [self unShowWaitView];
    [_tableView footerEndRefreshing];
    [_tableView headerEndRefreshing];
    
    [_tableView reloadData];
}

-(void)loadGoodsEvaluationFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    [_tableView headerEndRefreshing];
    
    
    [UtilTool showRoundView:errorMsg];
}

- (void)loadGoodsNoEvaluation{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    
    _tableView.footerPullToRefreshText = @"无更多";
    _tableView.footerReleaseToRefreshText = @"无更多";
    _tableView.footerRefreshingText = @"无更多";
}


@end
