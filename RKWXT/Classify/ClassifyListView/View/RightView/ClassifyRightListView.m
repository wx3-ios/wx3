//
//  ClassifyRightListView.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyRightListView.h"
#import "ClassifyRightCell.h"
#import "ClassifyRightDef.h"
#import "ClassifyModel.h"
#import "CLassifyEntity.h"

#define size self.bounds.size

@interface ClassifyRightListView ()<UITableViewDataSource,UITableViewDelegate,ClassifyRightCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    NSInteger selectRow;
    
    CLassifyEntity *classifyEntity;
}

@end

@implementation ClassifyRightListView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAllowsSelection:NO];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addNotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadGoodsList:) name:@"userSelectRow" object:nil];
    [notificationCenter addObserver:self selector:@selector(loadCLassifyDataSucceed) name:D_Notification_Name_LoadClassifyData_Succeed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [classifyEntity.dataArr count]/showNumber+([classifyEntity.dataArr count]%showNumber>0?1:0);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return EveryCellHeight;
}

-(WXUITableViewCell *)tableViewForGoodsListAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    ClassifyRightCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(0xefeff4)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*showNumber;
    NSInteger count = [classifyEntity.dataArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*showNumber; i < max; i++){
        [rowArray addObject:[classifyEntity.dataArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForGoodsListAtRow:row];
    return cell;
}

-(void)loadCLassifyDataSucceed{
    classifyEntity = [ClassifyModel shareClassifyNodel].classifyDataArr[0];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)reloadGoodsList:(NSNotification*)notification{
    selectRow = [notification.object integerValue];
    classifyEntity = [ClassifyModel shareClassifyNodel].classifyDataArr[selectRow];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)goodsListCellClicked:(id)entity{
    NSDictionary *catDic = entity;
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_ClassifyGoodsClicked object:catDic];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
