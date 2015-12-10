//
//  WXJuniorListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXJuniorListVC.h"
#import "WXJuniorListCell.h"
#import "WXJuniorListModel.h"

#define Size self.bounds.size

@interface WXJuniorListVC ()<UITableViewDataSource,UITableViewDelegate,WXJuniorListModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    WXJuniorListModel *_model;
}

@end

@implementation WXJuniorListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[WXJuniorListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"排行榜"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_model loadWXJuniorListData];
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
    return WXJuniorListCellHeight;
}

-(WXUITableViewCell*)juniorPersonListCell:(NSInteger)row{
    static NSString *identifier = @"juniorPersonListCell";
    WXJuniorListCell *cell =  [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXJuniorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    cell = [self juniorPersonListCell:row];
    return cell;
}

#pragma mark juniorModel Delegate
-(void)loadWXJuniorListDataSucceed{
    [self unShowWaitView];
    listArr = _model.juniorArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadWXJuniorListDataFailed:(NSString *)errorMsg{
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
