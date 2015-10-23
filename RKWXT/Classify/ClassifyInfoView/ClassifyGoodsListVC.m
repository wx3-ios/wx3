//
//  ClassifyGoodsListVC.m
//  RKWXT
//
//  Created by SHB on 15/10/23.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyGoodsListVC.h"
#import "ClassifyGoodsListCell.h"
#import "ClassifyGoodsModel.h"

#define Size self.bounds.size

@interface ClassifyGoodsListVC()<UITableViewDataSource,UITableViewDelegate,ClassifyGoodsModelDelegate>{
    UITableView *_tabelView;
    NSArray *listArr;
    
    ClassifyGoodsModel *_model;
}
@end

@implementation ClassifyGoodsListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[ClassifyGoodsModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:_titleName];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tabelView = [[UITableView alloc] init];
    _tabelView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tabelView setBackgroundColor:[UIColor whiteColor]];
    [_tabelView setDelegate:self];
    [_tabelView setDataSource:self];
    [self addSubview:_tabelView];
    [_tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_model loadClassifyGoodsListData:_cat_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ClassifyGoodsListCellHeight;
}

-(WXUITableViewCell*)tableViewForGoodsListCellAt:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    ClassifyGoodsListCell *cell = [_tabelView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:listArr[row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForGoodsListCellAt:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tabelView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark modelDelegate
-(void)loadClassifyGoodsListDataSucceed{
    [self unShowWaitView];
    listArr = _model.goodsListArr;
    [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadClassifyGoodsListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商品列表失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
