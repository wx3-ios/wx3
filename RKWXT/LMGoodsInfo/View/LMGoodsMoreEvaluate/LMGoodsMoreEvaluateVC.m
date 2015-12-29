//
//  LMGoodsMoreEvaluateVC.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsMoreEvaluateVC.h"
#import "LMGoodsMoreEvaluateCell.h"
#import "LMGoodsEvaluateModel.h"
#import "MJRefresh.h"

#define Size self.bounds.size
#define EveryTimeLoad (5)

@interface LMGoodsMoreEvaluateVC()<UITableViewDataSource,UITableViewDelegate,LMGoodsEvaluateModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    
    LMGoodsEvaluateModel *_model;
}
@end

@implementation LMGoodsMoreEvaluateVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMGoodsEvaluateModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"评价"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
    [self setupRefresh];
    
    [_model loadLmGoodsMoreEvaluateDat:_goodsID startItem:0 length:EveryTimeLoad];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

//集成刷新控件
-(void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    return [LMGoodsMoreEvaluateCell cellHeightOfInfo:[listArr objectAtIndex:row]];
}

-(WXUITableViewCell*)moreEvaluateCell:(NSInteger)row{
    static NSString *identifier =  @"moreEvaluateCell";
    LMGoodsMoreEvaluateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsMoreEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self moreEvaluateCell:row];
    return cell;
}

#pragma mark moreEvaluate
//上拉加载
-(void)footerRefreshing{
    [_model loadLmGoodsMoreEvaluateDat:_goodsID startItem:[listArr count] length:EveryTimeLoad];
}

-(void)loadLmGoodsMoreEvaluateDataSucceed{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    listArr = _model.evaluateArr;
    [_tableView reloadData];
}

-(void)loadLmGoodsMoreEvaluateDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
