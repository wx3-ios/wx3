//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,WXHomeTopGoodCellDelegate,BaseFunctionCellBtnClicked,wxIntructionCellDelegate,forMeCellDeleagte,TopicalCellDeleagte,changeTitleCellDelegate,ChangeCellDelegate,WXSysMsgUnreadVDelegate,HomePageTopDelegate,HomePageThemeDelegate,HomePageRecDelegate,HomeNavModelDelegate,HomePageSurpDelegate,HomeLimitBuyCellDelegate,HomeLimitBuyModelDelegate>{
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
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_tableView setAllowsSelection:NO];
    [self addSubview:_tableView];
    
    [self createTopBtn];
    [_model loadData];
    //定位
    UserLocation *userLocation = [[UserLocation alloc] init];
    [userLocation startLocation];
    
    [self pullingTableViewDidStartRefreshing:_tableView];
}

- (void)clickNavRightBar{
    WXToSnapUpController *tosnap = [[WXToSnapUpController alloc]init];
    [self.wxNavigationController pushViewController:tosnap];
}

-(void)createTopBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 6, 60, 40);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"分类" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:WXFont(10.0)];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftNavigationItem:leftBtn];
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint startImageViewCenter = leftBtn.imageView.center;
    CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
    
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
        case T_HomePage_Topical:
        case T_HomePage_ForMe:
        case T_HomePage_Change:
            row = 1;
            break;
        case T_HomePage_LimitBuy:
        case T_HomePage_LimitBuyInfo:
        {
            if([_model.limitModel.data count] == 0){
                row = 0;
            }else{
                row = 1;
            }
        }
            break;
        case T_HomePage_WXIntroduce:
            row = [_model.navModel.data count]/WxIntructionShow+[_model.navModel.data count]%WxIntructionShow;
            break;
        case T_HomePage_ForMeInfo:
            row = [_model.recommend.data count]/ForMeShow+([_model.recommend.data count]%ForMeShow>0?1:0);
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
            height = Size.width/3;
            break;
        case T_HomePage_BaseFunction:
            height = T_HomePageBaseFunctionHeight*2;
            break;
        case T_HomePage_WXIntroduce:
            height = T_HomePageWXIntructionHeight;
            break;
        case T_HomePage_ForMe:
        case T_HomePage_Topical:
        case T_HomePage_Change:
            height = T_HomePageTextSectionHeight;
            break;
        case T_HomePage_LimitBuy:
        {
            if([_model.limitModel.data count] == 0){
                height = 0;
            }else{
                height = T_HomePageTextSectionHeight;
            }
        }
            break;
        case T_HomePage_LimitBuyInfo:
        {
            if([_model.limitModel.data count] == 0){
                return 0;
            }else{
                height = T_HomePageLimitBuyHeight;
            }
        }
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

//导航
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
    for(NSInteger i = row*WxIntructionShow; i < max; i++){
        [rowArray addObject:[_model.navModel.data objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//限时购
-(WXUITableViewCell*)tableViewForLimitBuyTitleCell{
    static NSString *identfier = @"limitBuyTitleCell";
    HomeLimitBuyTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[HomeLimitBuyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForLimitBuy:(NSInteger)row{
    static NSString *identifier = @"limitBuyCell";
    HomeLimitBuyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[HomeLimitBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*LimitBuyShow;
    NSInteger count = [_model.limitModel.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*LimitBuyShow; i < max; i++){
        [rowArray addObject:[_model.limitModel.data objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//为我推荐
-(WXUITableViewCell*)tableViewForMeCell{
    static NSString *identifier = @"forMeCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"为我推荐"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"主题馆"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        case T_HomePage_LimitBuy:
            cell = [self tableViewForLimitBuyTitleCell];
            break;
        case T_HomePage_LimitBuyInfo:
            cell = [self tableViewForLimitBuy:row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_LimitBuy:
        {
            if(indexPath.row == 0){
                WXToSnapUpController *tosnap = [[WXToSnapUpController alloc] init];
                [self.wxNavigationController pushViewController:tosnap];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark HomePageTopDelegate
-(void)homePageTopLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopImg] withRowAnimation:UITableViewRowAnimationFade];
//    [_model.top toInit];
}

-(void)homePageTopLoadedFailed:(NSString *)error{
    [UtilTool showAlertView:error];
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
    if(index > HomePageJump_Type_Invalid){
        return;
    }
    HomePageTopEntity *entity = [_model.top.data objectAtIndex:index];
    switch (entity.topType) {
        case HomePageJump_Type_GoodsInfo:
        {
            [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.linkID animated:YES];
        }
            break;
        case HomePageJump_Type_Catagary:
        {
            [self toCatagaryListVC:entity.linkID];
        }
            break;
        case HomePageJump_Type_MessageCenter:
        {
            [self toSysPushMsgView];
        }
            break;
        case HomePageJump_Type_MessageInfo:
        {
            [[CoordinateController sharedCoordinateController] toJPushMessageInfoVC:self messageID:entity.linkID animated:YES];
        }
            break;
        case HomePageJump_Type_UserBonus:
        {
            [[CoordinateController sharedCoordinateController] toUserBonusVC:self animated:YES];
        }
            break;
        case HomePageJump_Type_BusinessAlliance:
        {
            [[CoordinateController sharedCoordinateController] toWebVC:self url:@"http://wx3.67call.com/wx_html/index.php/Public/alliance_merchant" title:@"商家联盟" animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark limitBuy
-(void)homeLimitBuyLoadSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_LimitBuyInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homeLimitBuyLoadFailed:(NSString *)errorMsg{
}

-(void)HomeLimitBuyCellBtnClicked:(id)entity{
    TimeShopData *entit = entity;
    NewGoodsInfoVC *goodsInfoVC = [[NewGoodsInfoVC alloc] init];
    goodsInfoVC.lEntity = entit;
    goodsInfoVC.goodsInfo_type = GoodsInfo_LimitGoods;
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

#pragma mark HomePageTheme
-(void)homePageThemeLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopicalInfo] withRowAnimation:UITableViewRowAnimationFade];
//    [_model.theme toInit];
}

-(void)homePageThemeLoadedFailed:(NSString *)errorMsg{
//    [UtilTool showAlertView:errorMsg];
}

-(void)topicalCellClicked:(id)entity{
    HomePageThmEntity *ent = entity;
    [self toCatagaryListVC:ent.cat_id];
}

#pragma mark HomePageRecommond
-(void)homePageRecLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_ForMeInfo] withRowAnimation:UITableViewRowAnimationFade];
//    [_model.recommend toInit];
}

-(void)homePageRecLoadedFailed:(NSString *)errorMsg{
//    [UtilTool showAlertView:errorMsg];
}

-(void)forMeCellClicked:(id)entity{
    HomePageRecEntity *ent = entity;
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:ent.goods_id animated:YES];
}

#pragma mark HomePageNav
-(void)homeNavigationLoadSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_WXIntroduce] withRowAnimation:UITableViewRowAnimationFade];
//    [_model.navModel toInit];
}

-(void)homeNavigationLoadFailed:(NSString *)errorMsg{
//    [UtilTool showAlertView:errorMsg];
}

-(void)intructionClicked:(id)entity{
    if(!entity){
        return;
    }
    HomeNavENtity *navi = entity;
    switch (navi.type) {
        case HomePageJump_Type_GoodsInfo:
        {
            [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:navi.navID animated:YES];
        }
            break;
        case HomePageJump_Type_Catagary:
        {
            [self toCatagaryListVC:navi.navID];
        }
            break;
        case HomePageJump_Type_MessageCenter:
        {
            [self toSysPushMsgView];
        }
            break;
        case HomePageJump_Type_MessageInfo:
        {
            [[CoordinateController sharedCoordinateController] toJPushMessageInfoVC:self messageID:navi.navID animated:YES];
        }
            break;
        case HomePageJump_Type_UserBonus:
        {
            [[CoordinateController sharedCoordinateController] toUserBonusVC:self animated:YES];
        }
            break;
        case HomePageJump_Type_BusinessAlliance:
        {
            [[CoordinateController sharedCoordinateController] toWebVC:self url:@"http://wx3.67call.com/wx_html/index.php/Public/alliance_merchant" title:@"商家联盟" animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark HomePageSurprise
-(void)homePageSurpLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_ChangeInfo] withRowAnimation:UITableViewRowAnimationFade];
//    [_model.surprise toInit];
}

-(void)homePageSurpLoadedFailed:(NSString *)errorMsg{
//    [UtilTool showAlertView:errorMsg];
}

-(void)changeCellClicked:(id)entity{
    HomePageSurpEntity *ent = entity;
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:ent.goods_id animated:YES];
}

#pragma mark LeftBtn
-(void)homePageToCategaryView{
    [self toCatagaryListVC:0];
}

-(void)toCatagaryListVC:(NSInteger)catID{
//    WXTMallListWebVC *webViewVC = [[[WXTMallListWebVC alloc] init] autorelease];
//    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:kSubShopID], @"shop_id", [NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", [NSNumber numberWithInteger:catID], @"cat_id", nil];
//    [webViewVC initWithFeedType:WXT_UrlFeed_Type_NewMall_CatagaryList paramDictionary:dic];
//    [self.wxNavigationController pushViewController:webViewVC];
    ClassifyListVC *webViewVC = [[[ClassifyListVC alloc] init] autorelease];
    webViewVC.cat_id = catID;
    [self.wxNavigationController pushViewController:webViewVC];
}

#pragma mark 消息推送
- (void)toSysPushMsgView{
    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

#pragma mark BaseFunction
-(void)baseFunctionBtnClickedAtIndex:(T_BaseFunction)index{
    if(index < 0){
        return;
    }
    switch (index) {
        case T_BaseFunction_Shark:
        {
            LuckyShakeVC *webViewVC = [[[LuckyShakeVC alloc] init] autorelease];
            [self.wxNavigationController pushViewController:webViewVC];
        }
            break;
        case T_BaseFunction_Sign:
        {
            [[CoordinateController sharedCoordinateController] toSignVC:self animated:YES];
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
        case T_BaseFunction_Recharge:
        {
            [[CoordinateController sharedCoordinateController] toRechargeVC:self animated:YES];
        }
            break;
        case T_BaseFunction_Balance:
        {
            UserBalanceVC *balanceVC = [[UserBalanceVC alloc] init];
            [self.wxNavigationController pushViewController:balanceVC];
        }
            break;
        case T_BaseFunction_Cut:
        {
            NewUserCutVC *userCutVC = [[NewUserCutVC alloc] init];
            [self.wxNavigationController pushViewController:userCutVC];
        }
            break;
        case T_BaseFunction_Union:
        {
            [[CoordinateController sharedCoordinateController] toWebVC:self url:@"http://wx3.67call.com/wx_html/index.php/Public/alliance_merchant" title:@"商家联盟" animated:YES];
//            WXShopUnionVC *unionVC = [[WXShopUnionVC alloc] init];
//            [self.wxNavigationController pushViewController:unionVC];
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