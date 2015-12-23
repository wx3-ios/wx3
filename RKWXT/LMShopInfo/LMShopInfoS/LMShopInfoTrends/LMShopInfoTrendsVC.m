//
//  LMShopInfoTrendsVC.m
//  RKWXT
//
//  Created by SHB on 15/12/4.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoTrendsVC.h"
#import "LMShopInfoTrendsCell.h"
#import "LMShopInfoListModel.h"
#import "MJRefresh.h"
#import "LMShopInfoAllGoodsEntity.h"

#define Size self.bounds.size
#define EveryItmeLoadData (10)

@interface LMShopInfoTrendsVC ()<UITableViewDataSource,UITableViewDelegate,LMShopInfoListModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    LMShopInfoListModel *_model;
}

@end

@implementation LMShopInfoTrendsVC

-(id)init{
    self = [super init];
    if(self){
        _model =[[LMShopInfoListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"店铺动态"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setupRefresh];
    
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_Active and:_sshop_id andStartItem:0 andLenth:EveryItmeLoadData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMShopInfoTrendsCellHeight;
}

-(WXUITableViewCell*)shopInfoTrendsCell:(NSInteger)section{
    static NSString *identifier = @"trendsCell";
    LMShopInfoTrendsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoTrendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self shopInfoTrendsCell:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    LMShopInfoAllGoodsEntity *entity = [listArr objectAtIndex:section];
    [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:entity.goodsID animated:YES];
}

-(void)footerRefreshing{
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_Active and:_sshop_id andStartItem:[listArr count] andLenth:EveryItmeLoadData];
}

-(void)loadShopListDataSucced{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    listArr = [self goodsAdTimeDownSort];
    [_tableView reloadData];
}

//降序排序
-(NSArray*)goodsAdTimeDownSort{
    NSArray *sortArray = [_model.data sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        LMShopInfoAllGoodsEntity *entity_0 = obj1;
        LMShopInfoAllGoodsEntity *entity_1 = obj2;
        
        if (entity_0.addTime < entity_1.addTime){
            return NSOrderedDescending;
        }else if (entity_0.addTime > entity_1.addTime){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

-(void)loadShopListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
