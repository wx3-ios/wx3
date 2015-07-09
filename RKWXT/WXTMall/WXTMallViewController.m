//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,WXHomeTopGoodCellDelegate,BaseFunctionCellBtnClicked,wxIntructionCellDelegate,forMeCellDeleagte,TopicalCellDeleagte,changeTitleCellDelegate,ChangeCellDelegate,WXSysMsgUnreadVDelegate,HomePageTopDelegate,HomePageThemeDelegate,HomePageRecDelegate,HomeNavModelDelegate,HomePageSurpDelegate>{
    PullingRefreshTableView *_tableView;
    WXSysMsgUnreadV * _unreadView;
    NewHomePageModel *_model;
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation WXTMallViewController

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_model);
    [_model setDelegate:nil];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[NewHomePageModel alloc] init];
        [_model setDelegate:self];
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
    
    [self createTopBtn];
    [_model loadData];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 6, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
    
    _unreadView = [[WXSysMsgUnreadV alloc] initWithFrame:CGRectMake(0, 0, kDefaultNavigationBarButtonSize.width, kDefaultNavigationBarButtonSize.height)];
    [_unreadView setDelegate:self];
    [_unreadView showSysPushMsgUnread];
    [self setRightNavigationItem:_unreadView];
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
            row = [_model.navModel.data count]/WxIntructionShow+[_model.navModel.data count]%WxIntructionShow;
            break;
        case T_HomePage_ForMeInfo:
            row = [_model.recommend.data count]/ForMeShow;
            break;
        case T_HomePage_TopicalInfo:
            row = [_model.theme.data count]/TopicalShow+[_model.theme.data count]%TopicalShow;
            break;
        case T_HomePage_ChangeInfo:
            row = [_model.surprise.data count]/ChangeInfoShow+[_model.surprise.data count]%ChangeInfoShow;
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

///顶部导航
-(WXUITableViewCell*)headImgCellAtRow:(NSInteger)row{
    static NSString *identifier = @"headImg";
    WXHomeTopGoodCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    [cell setCellInfo:_model.top.data];
    [cell load];
    return cell;
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
    NSInteger count = [_model.navModel.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ForMeShow; i < max; i++){
        [rowArray addObject:[_model.navModel.data objectAtIndex:i]];
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
    NSInteger count = [_model.recommend.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ForMeShow; i < max; i++){
        [rowArray addObject:[_model.recommend.data objectAtIndex:i]];
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
    NSInteger count = [_model.theme.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*TopicalShow; i < max; i++){
        [rowArray addObject:[_model.theme.data objectAtIndex:i]];
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
    NSInteger count = [_model.surprise.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ChangeInfoShow; i < max; i++){
        [rowArray addObject:[_model.surprise.data objectAtIndex:i]];
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

#pragma mark HomePageTopDelegate
-(void)homePageTopLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopImg] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageTopLoadedFailed:(NSString *)error{
    [UtilTool showAlertView:error];
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
    if(index > HomePageJump_Type_Invalid){
        return;
    }
    HomePageTopEntity *entity = [_model.top.data objectAtIndex:index];
    switch (index) {
        case HomePageJump_Type_GoodsInfo:
        {
            [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:[entity.linkAddress integerValue] animated:YES];
        }
            break;
        case HomePageJump_Type_UserBonus:
        {
            [[CoordinateController sharedCoordinateController] toUserBonusVC:self animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark HomePageTheme
-(void)homePageThemeLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopicalInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageThemeLoadedFailed:(NSString *)errorMsg{
    [UtilTool showAlertView:errorMsg];
}

-(void)topicalCellClicked:(id)entity{
    NSLog(@"主题馆");
}

#pragma mark HomePageRecommond
-(void)homePageRecLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_ForMeInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageRecLoadedFailed:(NSString *)errorMsg{
    [UtilTool showAlertView:errorMsg];
}

-(void)forMeCellClicked:(id)entity{
    NSLog(@"为我推荐");
}

#pragma mark HomePageNav
-(void)homeNavigationLoadSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_WXIntroduce] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homeNavigationLoadFailed:(NSString *)errorMsg{
    [UtilTool showAlertView:errorMsg];
}

-(void)intructionClicked:(id)entity{
    NSLog(@"我信介绍");
}

#pragma mark HomePageSurprise
-(void)homePageSurpLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_ChangeInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageSurpLoadedFailed:(NSString *)errorMsg{
    [UtilTool showAlertView:errorMsg];
}

-(void)changeCellClicked:(id)entity{
    NSLog(@"更多惊喜");
}

#pragma mark LeftBtn
-(void)homePageToCategaryView{
    WXTMallListWebVC *webViewVC = [[[WXTMallListWebVC alloc] init] autorelease];
    [webViewVC setCstTitle:@"分类列表"];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:kSubShopID], @"shop_id",[NSNumber numberWithInteger:kMerchantID],@"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd],@"pwd", nil];
    [webViewVC initWithFeedType:WXT_UrlFeed_Type_NewMall_CatagaryList paramDictionary:dic];
    [self.wxNavigationController pushViewController:webViewVC];
}

#pragma mark 消息推送
- (void)toSysPushMsgView{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"功能开发中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//    [alertView show];
    JPushMessageCenterVC *jpushVC = [[[JPushMessageCenterVC alloc] init] autorelease];
    [self.wxNavigationController pushViewController:jpushVC];
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
            break;
        case T_BaseFunction_Wallet:
        {
            [[CoordinateController sharedCoordinateController] toUserBonusVC:self animated:YES];
        }
            break;
        case T_BaseFunction_Order:
        {
            [[CoordinateController sharedCoordinateController] toOrderList:self selectedShow:0 animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)changeOtherBtnClicked{
    [_model.surprise toInit];
    [_model.surprise loadData];
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
        if([self isNeed]){
            [_model loadData];
        }
        [_tableView tableViewDidFinishedLoadingWithMessage:@"刷新完成"];
    }else{
    }
}

-(BOOL)isNeed{
    return [_model isSomeDataNeedReload];
}

#pragma mark --scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}

@end