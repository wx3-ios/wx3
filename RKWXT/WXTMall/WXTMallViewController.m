//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

#define Size self.bounds.size

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,WXHomeTopGoodCellDelegate,BaseFunctionCellBtnClicked,wxIntructionCellDelegate,forMeCellDeleagte,TopicalCellDeleagte,changeTitleCellDelegate,ChangeCellDelegate>{
    PullingRefreshTableView *_tableView;
    WXHomeTopGoodCell *_topCell;
    
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation WXTMallViewController

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_topCell);
    [_topCell setDelegate:nil];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:kMerchantName];
    
    _tableView = [[PullingRefreshTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setPullingDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAllowsSelection:NO];
    [self addSubview:_tableView];
    
    _topCell = [[self createTopCell] retain];
    [self reloadHomeTopGoodCell];
    
    [self createTopBtn];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 6, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    switch (section) {
        case T_HomePage_TopImg:
        case T_HomePage_BaseFunction:
        case T_HomePage_ForMe:
        case T_HomePage_Topical:
        case T_HomePage_Change:
            row = 1;
            break;
        case T_HomePage_WXIntroduce:
            break;
        case T_HomePage_ForMeInfo:
            //            row =
            break;
        case T_HomePage_TopicalInfo:
            row = 4;
            break;
        case T_HomePage_ChangeInfo:
            row = 3;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_TopImg:
            height = T_HomePageTopImgHeight;
            break;
        case T_HomePage_BaseFunction:
            height = T_HomePageBaseFunctionHeight;
            break;
        case T_HomePage_WXIntroduce:
            height = T_HomePageWXIntructionHeight;
            break;
        case T_HomePage_ForMe:
        case T_HomePage_Topical:
        case T_HomePage_Change:
            height = T_HomePageTextSectionHeight;
            break;
        case T_HomePage_ForMeInfo:
            height = T_HomePageForMeHeight;
            break;
        case T_HomePage_TopicalInfo:
            height = T_HomePageTopicalHeight;
            break;
        case T_HomePage_ChangeInfo:
            height = T_HomePageChangeInfoHeight;
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_HomePage_Invalid;
}

-(WXHomeTopGoodCell*)createTopCell{
    static NSString *identifier = @"headImg";
    _topCell = [[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [_topCell setBackgroundColor:[UIColor clearColor]];
    [_topCell setDelegate:self];
    return [_topCell autorelease];
}

-(void)reloadHomeTopGoodCell{
    //    [_topCell setCellInfo:_mo]
    [_topCell load];
}

//
-(WXUITableViewCell*)headImgCellAtRow:(NSInteger)row{
    return _topCell;
}

//基本功能入口
-(WXUITableViewCell*)tableViewForBaseFunctionCell{
    static NSString *identifier = @"baseFunctionCell";
    BaseFunctionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[BaseFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell load];
    [cell setDelegate:self];
    return cell;
}

//我信介绍
-(WXUITableViewCell*)tableViewForWxIntructionCellAtRow:(NSInteger)row{
    static NSString *identifier = @"wxIntructionCell";
    WxIntructionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WxIntructionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*WxIntructionShow;
    NSInteger count = 2;
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*WxIntructionShow;i < max;i++){
        [rowArray addObject:@""];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//为我推荐
-(WXUITableViewCell*)tableViewForMeCell{
    static NSString *identifier = @"forMeCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"为我推荐"];
    return cell;
}

-(WXUITableViewCell *)tableViewForMeCellAtRow:(NSInteger)row{
    static NSString *identifier = @"forMeInfoCell";
    T_ForMeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[T_ForMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*ForMeShow;
    NSInteger count = 3;
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ForMeShow;i < max; i++){
        [rowArray addObject:@""];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//主题馆
-(WXUITableViewCell*)tableViewForTopicalCell{
    static NSString *identifier = @"topicalCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"主题馆"];
    return cell;
}

-(WXUITableViewCell*)tableViewForTopicalCellAtRow:(NSInteger)row{
    static NSString *identifier = @"topicalInfoCell";
    T_TopicalCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[T_TopicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*TopicalShow;
    NSInteger count = 8;
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*TopicalShow; i < max; i++){
        [rowArray addObject:@""];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//更多惊喜
-(WXUITableViewCell*)tableViewForChangeCell{
    static NSString *identifier = @"changeCell";
    T_ChangeTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[T_ChangeTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    return cell;
}

-(WXUITableViewCell*)tableViewForChangeInfoAtRow:(NSInteger)row{
    static NSString *identifier = @"changeInfoCell";
    T_ChangeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[T_ChangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*ChangeInfoShow;
    NSInteger count = 6;
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ChangeInfoShow; i < max; i++){
        [rowArray addObject:@""];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case T_HomePage_TopImg:
            cell = [self headImgCellAtRow:row];
            break;
        case T_HomePage_BaseFunction:
            cell = [self tableViewForBaseFunctionCell];
            break;
        case T_HomePage_WXIntroduce:
            cell = [self tableViewForWxIntructionCellAtRow:row];
            break;
        case T_HomePage_ForMe:
            cell = [self tableViewForMeCell];
            break;
        case T_HomePage_ForMeInfo:
            cell = [self tableViewForMeCellAtRow:row];
            break;
        case T_HomePage_Topical:
            cell = [self tableViewForTopicalCell];
            break;
        case T_HomePage_TopicalInfo:
            cell = [self tableViewForTopicalCellAtRow:row];
            break;
        case T_HomePage_Change:
            cell = [self tableViewForChangeCell];
            break;
        case T_HomePage_ChangeInfo:
            cell = [self tableViewForChangeInfoAtRow:row];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark TopImg
-(void)clickTopGoodAtIndex:(NSInteger)index{
    NSLog(@"顶部导航==%ld",(long)index);
}

#pragma mark LeftBtn
-(void)homePageToCategaryView{
    NSLog(@"左边按钮");
}

#pragma mark BaseFunction
-(void)baseFunctionBtnClickedAtIndex:(T_BaseFunction)index{
    if(index < 0){
        return;
    }
    switch (index) {
        case T_BaseFunction_Sign:
        {
            [[CoordinateController sharedCoordinateController] toSignVC:self animated:YES];
        }
            break;
        case T_BaseFunction_Recharge:
        {
            [[CoordinateController sharedCoordinateController] toRechargeVC:self animated:YES];
        }
        default:
            break;
    }
}

-(void)changeCellClicked:(id)entity{
    NSLog(@"更多惊喜");
}

-(void)changeOtherBtnClicked{
    NSLog(@"换一批");
}

-(void)forMeCellClicked:(id)entity{
    NSLog(@"为我推荐");
}

-(void)topicalCellClicked:(id)entity{
    NSLog(@"主题馆");
}

#pragma mark tableViewPull
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.e_cellRefreshing = E_CellRefreshing_UnderWay;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
}

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
}

-(void)loadData{
    if(self.e_cellRefreshing == E_CellRefreshing_UnderWay){
        self.e_cellRefreshing = E_CellRefreshing_Finish;
//        if([self isNeed]){
//            []
//        }
        [_tableView tableViewDidFinishedLoadingWithMessage:@"刷新完成"];
    }else{
    }
}

@end