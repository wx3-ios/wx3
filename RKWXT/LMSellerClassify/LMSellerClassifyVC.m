//
//  LMSellerClassifyVC.m
//  RKWXT
//
//  Created by SHB on 15/12/14.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyVC.h"
#import "LMSellerClassifyTopCell.h"
#import "LMSellerClassifyTopView.h"
#import "ShopUnionClassifyEntity.h"
#import "SellerClassifyListCell.h"
#import "LMSellerListModel.h"
#import "LMSellerInfoVC.h"
#import "LMSellerListEntity.h"

#define Size self.bounds.size
#define ScrollViewHeight (44)

@interface LMSellerClassifyVC()<UITableViewDataSource,UITableViewDelegate,LMSellerListModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    LMSellerClassifyTopView *topView;
    
    LMSellerListModel *_model;
}
@end

@implementation LMSellerClassifyVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMSellerListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家分类"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, ScrollViewHeight+10, Size.width, Size.height-ScrollViewHeight-10);
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
    [self initTopTableView];
    
    [_model loadAllSellerListData:_industryID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(changeSellerClassifyList:) name:K_Notfication_Name_SellerClassifyBtnClicked object:nil];
    [defaultCenter addObserver:self selector:@selector(classifySellerDropListOpen) name:K_Notfication_Name_SellerClassifyDropListOpen object:nil];
    [defaultCenter addObserver:self selector:@selector(classifySellerDropListClose) name:K_Notfication_Name_SellerClassifyDropListClose object:nil];
}

-(void)initTopTableView{
    topView = [[LMSellerClassifyTopView alloc] initWithFrame:CGRectMake(0, 0, Size.width, 44)];
    [self addSubview:topView];
    [topView initClassifySellerArr:_sellerClassifyArr];
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
    return SellerClassifyListCellHeight;
}

-(WXUITableViewCell*)lmSellerClassifyTopCell{
    static NSString *identifier = @"topCell";
    LMSellerClassifyTopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSellerClassifyTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(WXUITableViewCell*)sellerListCell:(NSInteger)section{
    static NSString *identifier = @"sellerListCell";
    SellerClassifyListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SellerClassifyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self sellerListCell:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    LMSellerListEntity *entity = [listArr objectAtIndex:section];
    LMSellerInfoVC *sellerInfoVC = [[LMSellerInfoVC alloc] init];
    sellerInfoVC.ssid = entity.sellerId;
    [self.wxNavigationController pushViewController:sellerInfoVC];
}

#pragma mark model
-(void)loadLmSellerListDataSucceed{
    [self unShowWaitView];
    listArr = _model.sellerListArr;
    [_tableView reloadData];
}

-(void)loadLmSellerListDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商家列表失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark classify
-(void)changeSellerClassifyList:(NSNotification*)notification{
    NSString *name = notification.object;
    for(ShopUnionClassifyEntity *entity in _sellerClassifyArr){
        if([entity.industryName isEqualToString:name]){
            NSLog(@"行业 === %@",name);
            [_model loadAllSellerListData:entity.industryID];
            [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        }
    }
}

-(void)classifySellerDropListOpen{
//    [topView removeFromSuperview];
    topView.frame = CGRectMake(0, 0, Size.width, Size.height);
//    [self addSubview:topView];
}

-(void)classifySellerDropListClose{
//    [topView removeFromSuperview];
    topView.frame = CGRectMake(0, 0, Size.width, 44);
//    [self addSubview:topView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
