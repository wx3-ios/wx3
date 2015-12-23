//
//  LMShopCollectionVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionVC.h"
//#import "LMShopCollectionCell.h"
#import "LMShopCollectionTitleCell.h"
#import "LMDataCollectionModel.h"
#import "LMShopCollectionEntity.h"

#define Size self.bounds.size

@interface LMShopCollectionVC()<UITableViewDataSource,UITableViewDelegate/*,LMShopCollectionCellDelegate*/>{
    UITableView *_tableView;
    NSArray *listArr;
    LMDataCollectionModel *_model;
}
@end

@implementation LMShopCollectionVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMDataCollectionModel alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
    [_model lmCollectionData:0 goods:0 type:LMCollection_Type_Shop dataType:CollectionData_Type_Search];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShopCollectionSucced) name:K_Notification_Name_LoadShopCollectionListSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShopCollectionFailed:) name:K_Notification_Name_LoadShopCollectionListFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCancelCollectionSucceed) name:K_Notification_Name_ShopCancelCollectionSucceed object:nil];
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
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  LMShopCollectionTitleCellHeight;
}

-(WXUITableViewCell*)shopCollectionTitleCell:(NSInteger)section{
    static NSString *identfier = @"shopTitleCell";
    LMShopCollectionTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMShopCollectionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//-(WXUITableViewCell *)lmShopCollectionCell:(NSInteger)row{
//    static NSString *identfier = @"shopCell";
//    LMShopCollectionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
//    if(!cell){
//        cell = [[LMShopCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSMutableArray *rowArray = [NSMutableArray array];
//    NSInteger max = row*3;
//    NSInteger count = [listArr count];
//    if(max > count){
//        max = count;
//    }
//    for(NSInteger i = (row-1)*3; i < max; i++){
//        [rowArray addObject:[listArr objectAtIndex:i]];
//    }
//    [cell setDelegate:self];
//    [cell loadCpxViewInfos:rowArray];
//    return cell;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self shopCollectionTitleCell:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    LMShopCollectionEntity *entity = [listArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:LMShopCollectionJump object:entity];
}

#pragma mark collectionData
-(void)loadShopCollectionSucced{
    [self unShowWaitView];
    listArr = _model.shopCollectionArr;
    [_tableView reloadData];
}

-(void)loadShopCollectionFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)shopCancelCollectionSucceed{
    [_model lmCollectionData:0 goods:0 type:LMCollection_Type_Shop dataType:CollectionData_Type_Search];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)lmShopCollectionCellBtnClicked:(id)sender{
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
