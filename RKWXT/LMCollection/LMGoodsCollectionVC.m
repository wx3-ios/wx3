//
//  LMGoodsCollectionVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsCollectionVC.h"
#import "LMGoodsCollectionCell.h"
#import "LMDataCollectionModel.h"
#import "LMGoodsCollectionEntity.h"

#define Size self.bounds.size

@interface LMGoodsCollectionVC()<UITableViewDataSource,UITableViewDelegate,LMGoodsCollectionCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    LMDataCollectionModel *_model;
}
@end

@implementation LMGoodsCollectionVC

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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault integerForKey:LMGoodsCollectionDataChange] && _tableView){
        listArr = [self changeGoodsCollectionData:[userDefault integerForKey:LMGoodsCollectionDataChange]];
        [_tableView reloadData];
    }
}

-(NSArray*)changeGoodsCollectionData:(NSInteger)goodsID{
    NSMutableArray *comArr = [NSMutableArray arrayWithArray:listArr];
    for(LMGoodsCollectionEntity *entity in comArr){
        if(entity.goodsID == goodsID){
            [comArr removeObject:entity];
        }
    }
    return comArr;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
    [_model lmCollectionData:0 goods:0 type:LMCollection_Type_Goods dataType:CollectionData_Type_Search];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGoodsCollectionSucced) name:K_Notification_Name_LoadGoodsCollectionListSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGoodsCollectionFailed:) name:K_Notification_Name_LoadGoodsCollectionListFailed object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count]/2+([listArr count]%2>0?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMGoodsCollectionCellheight;
}

-(WXUITableViewCell *)lmGoodsCollectionCell:(NSInteger)row{
    static NSString *identfier = @"goodsCell";
    LMGoodsCollectionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMGoodsCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*2;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*2; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self lmGoodsCollectionCell:row];
    return cell;
}

-(void)loadGoodsCollectionSucced{
    [self unShowWaitView];
    listArr = _model.goodsCollectionArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadGoodsCollectionFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark
-(void)lmGoodsCollectionCellBtnClicked:(id)sender{
    LMGoodsCollectionEntity *entity = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:LMGoodsCollectionJump object:entity];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
