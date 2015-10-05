//
//  MyClientInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientInfoVC.h"
#import "MyClientInfoCell.h"
#import "MyClientMoneyVC.h"
#import "MyClientEntity.h"

#define size self.bounds.size

@interface MyClientInfoVC()<UITableViewDataSource,UITableViewDelegate,MyClientPersonModelDelegate>{
    UITableView *_tableView;
    
    MyClientPersonModel *_model;
    NSArray *clientArr;
}
@end

@implementation MyClientInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    if(!_titleName){
        _titleName = @"我的客户";
    }
    [self setCSTTitle:_titleName];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if(_client_grade > MyClient_Grade_Invalid){
    }else{
        _model = [[MyClientPersonModel alloc] init];
        [_model setDelegate:self];
        [_model loadMyClientPersonList:_client_grade];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
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
    return [clientArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 10;
    if(section == 0){
        height = 0;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyClientInfoCellHeight;
}

-(WXUITableViewCell *)tableViewForMyClientInfoCellAtSection:(NSInteger)section{
    static NSString *identifier = @"myClientCell";
    MyClientInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MyClientInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    if([clientArr count] > 0){
        [cell setCellInfo:[clientArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self tableViewForMyClientInfoCellAtSection:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    MyClientEntity *entity = [clientArr objectAtIndex:section];
    MyClientMoneyVC *moneyVC = [[MyClientMoneyVC alloc] init];
    [moneyVC setClientID:[NSString stringWithFormat:@"%ld",(long)entity.userID]];
    [moneyVC setIconImgUrl:entity.userIconImg];
    [moneyVC setClientName:entity.nickName];
    [self.wxNavigationController pushViewController:moneyVC];
}


#pragma mark clientDelegate
-(void)loadMyClientPersonListSucceed{
    [self unShowWaitView];
    clientArr = _model.clientList;
    [_tableView reloadData];
}

-(void)loadMyClientPersonListFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
