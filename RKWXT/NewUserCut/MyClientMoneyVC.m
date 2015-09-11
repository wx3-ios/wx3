//
//  MyClientMoneyVC.m
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyClientMoneyVC.h"
#import "MyClientMoneyCell.h"
#import "MyClientInfoModel.h"

#define size self.bounds.size

@interface MyClientMoneyVC()<UITableViewDataSource,UITableViewDelegate,MyClientInfoModelDelegate>{
    UITableView *_tableView;
    
    MyClientInfoModel *_model;
    NSArray *clientInfoArr;
}
@end

@implementation MyClientMoneyVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"分成记录"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _model = [[MyClientInfoModel alloc] init];
    [_model setDelegate:self];
    [_model loadMyClientInfoWithWxID:_clientID];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [clientInfoArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 10;
    if(section == 0){
        height = 0;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyClientMoneyCellHeight;
}

-(WXUITableViewCell*)tableViewForClientMoneyCellAtSection:(NSInteger)section{
    static NSString *identifier = @"clientMoneyCell";
    MyClientMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MyClientMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setUserInteractionEnabled:NO];
    if([clientInfoArr count] > 0){
        [cell setCellInfo:clientInfoArr[section]];
        [cell setUserIcon:_iconImgUrl];
        [cell setUserName:_clientName];
        [cell setClientID:_clientID];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self tableViewForClientMoneyCellAtSection:section];
    return cell;
}

#pragma mark clientDelegate
-(void)loadMyClientInfoSucceed{
    [self unShowWaitView];
    clientInfoArr = _model.myClientInfoArr;
    [_tableView reloadData];
}

-(void)loadMyClientInfoFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
