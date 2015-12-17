//
//  LMSellerListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerListVC.h"
#import "MJRefresh.h"
#import "LMSellerListCell.h"
#import "LMSellerListModel.h"
#import "LMSellerInfoVC.h"
#import "LMSellerListEntity.h"

#define Size self.bounds.size

@interface LMSellerListVC ()<UITableViewDataSource,UITableViewDelegate,LMSellerListModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    LMSellerListModel *_model;
}

@end

@implementation LMSellerListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMSellerListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"商家列表"];
    [self setBackgroundColor:[UIColor whiteColor]];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_model loadAllSellerListData:0];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
//    [self setupRefresh];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMSellerListCellHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"listCell";
    LMSellerListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:indexPath.row]];
    }
    [cell load];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    LMSellerListEntity *entity = [_model.sellerListArr objectAtIndex:row];
    LMSellerInfoVC *sellerInfoVC = [[LMSellerInfoVC alloc] init];
    sellerInfoVC.ssid = entity.sellerId;
    [self.wxNavigationController pushViewController:sellerInfoVC];
}

#pragma mark mjrefresh
-(void)headerRefreshing{

}

-(void)footerRefreshing{
    
}

#pragma mark model
-(void)loadLmSellerListDataSucceed{
    [self unShowWaitView];
    listArr = _model.sellerListArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadLmSellerListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
