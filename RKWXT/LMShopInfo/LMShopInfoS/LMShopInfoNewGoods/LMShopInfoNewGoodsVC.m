//
//  LMShopInfoNewGoodsVC.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoNewGoodsVC.h"
#import "LMShopInfoNewGoodsCell.h"
#import "LMShopInfoNewGoodsView.h"
#import "LMShopInfoListModel.h"
#import "MJRefresh.h"

#define Size self.bounds.size
#define EveryItmeLoadData (10)

@interface LMShopInfoNewGoodsVC()<UITableViewDataSource,UITableViewDelegate,LMShopInfoListModelDelegate,LMShopInfoNewGoodsCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    LMShopInfoListModel *_model;
}
@end

@implementation LMShopInfoNewGoodsVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMShopInfoListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"推荐"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setupRefresh];
    
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_ComGoods and:_sshop_id andStartItem:0 andLenth:EveryItmeLoadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count]/2+([listArr count]%2>0?1:0);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMShopInfoNewGoodsViewHeight;
}

-(WXUITableViewCell*)shopInfoComGoodsListCell:(NSInteger)section{
    static NSString *identifier = @"comGoodsCell";
    LMShopInfoNewGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoNewGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (section+1)*2;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = section*2; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self shopInfoComGoodsListCell:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark data
-(void)footerRefreshing{
    [_model loadShopInfoListDataWith:LMShopInfo_DataType_ComGoods and:_sshop_id andStartItem:[listArr count] andLenth:EveryItmeLoadData];
     [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadShopListDataSucced{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    listArr = _model.data;
    [_tableView reloadData];
}

-(void)loadShopListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)lmShopInfoNewGoodsBtnClicked:(id)sender{
    
}

@end
