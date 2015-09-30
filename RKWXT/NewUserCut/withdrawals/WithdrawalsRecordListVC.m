//
//  WithdrawalsRecordListVC.m
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WithdrawalsRecordListVC.h"
#import "WithdrawadsRecordListModel.h"
#import "AliRecordListCell.h"
#import "OrderListTableView.h"

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

#define size self.bounds.size
#define EveryTimeLoadDataNumber 10

@interface WithdrawalsRecordListVC()<UITableViewDataSource,UITableViewDelegate,WithdrawadsRecordListModelDelegate,PullingRefreshTableViewDelegate>{
    OrderListTableView *_tableView;
    
    WithdrawadsRecordListModel *_model;
    NSInteger listCount;
    NSArray *listArr;
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation WithdrawalsRecordListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[WithdrawadsRecordListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"提现记录"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[OrderListTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setPullingDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    [_model loadUserWithdrawadlsRecordList:0 With:EveryTimeLoadDataNumber];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AliRecordListCellHeight;
}

-(WXUITableViewCell *)tableViewForRecordListCell:(NSInteger)row{
    static NSString *identifier = @"recordListCell";
    AliRecordListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AliRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForRecordListCell:row];
    return cell;
}

-(void)loadUserWithdrawadlsRecordListSucceed{
    [self unShowWaitView];
    if(listCount == [_model.recordListArr count] && self.e_cellRefreshing != E_CellRefreshing_Finish){
        _tableView.reachedTheEnd = YES;
    }
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    listArr = _model.recordListArr;
    listCount = [listArr count];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadUserWithdrawadlsRecordListFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商品失败";
    }
    [UtilTool showAlertView:errorMsg];
    _tableView.reachedTheEnd = YES;
}

#pragma mark pullingDelegate
-(void)pullingTableViewDidStartRefreshing:(OrderListTableView *)tableView{
    self.e_cellRefreshing = E_CellRefreshing_UnderWay;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(NSDate*)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [UtilTool getCurDateTime:1];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

-(void)pullingTableViewDidStartLoading:(OrderListTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData{
    if(self.e_cellRefreshing == E_CellRefreshing_UnderWay){
        self.e_cellRefreshing = E_CellRefreshing_Finish;
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_tableView tableViewDidFinishedLoadingWithMessage:@"刷新完成"];
        [_model setType:AliMoney_RecordList_Refresh];
        [_model loadUserWithdrawadlsRecordList:0 With:[listArr count]];
    }else{
        if(_tableView.reachedTheEnd){
            return;
        }
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_model setType:AliMoney_RecordList_Loading];
        [_model loadUserWithdrawadlsRecordList:[listArr count] With:EveryTimeLoadDataNumber];
    }
    if(!_tableView.reachedTheEnd){
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd = NO;
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}

@end
