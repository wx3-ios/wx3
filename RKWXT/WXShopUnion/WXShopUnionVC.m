//
//  WXShopUnionVC.m
//  RKWXT
//
//  Created by SHB on 15/11/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionVC.h"
#import "WXShopUnionDef.h"

#define ShopUnionDownVieHeight (45)

@interface WXShopUnionVC()<ShopUnionDropListViewDelegate,UITableViewDataSource,UITableViewDelegate,WXShopUnionActivityCell,WXShopUnionHotShopTitleCellDelegate,WXShopUnionHotShopCellDelegate,WXShopUnionModelDelegate,ShopUnionClassifyCellDelegate>{
    WXShopUnionAreaView *_areaListView;
    BOOL showAreaview;
    WXUIButton *rightBtn;
    WXTUITextField *_textField;
    
    UITableView *_tableView;
    
    NSArray *hotGoodsArr;
    NSArray *hotShopArr;
    
    WXShopUnionModel *_model;
}
@end

@implementation WXShopUnionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    showAreaview = YES;
    if(rightBtn){
        [self changeCity];
    }
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[WXShopUnionModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家联盟"];
    [self createRightNavBtn];
    [self createTopSearchView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-ShopUnionDownVieHeight);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self createUnionDownView]];
    
    //下拉区域列表
    showAreaview = YES;
    _areaListView = [self createAreaDropListViewWith:rightBtn];
    [_areaListView unshow:NO];
    [self addSubview:_areaListView];
    [[LocalAreaModel shareLocalArea] loadLocalAreaData];
    
    [self setupRefresh];
}

-(void)createTopSearchView{
    CGFloat xOffset = 60;
    CGFloat width = Size.width-xOffset-10-80;
    CGFloat height = 27;
    _textField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xOffset, 66-height-10, width, height)];
    [_textField setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_textField setBorderRadian:5.0 width:1.0 color:[UIColor whiteColor]];
//    [_textField addTarget:self action:@selector(textfiledStartInput) forControlEvents:UIControlEventEditingDidBegin];
    [_textField setTextColor:WXColorWithInteger(0xda7c7b)];
    [_textField setTintColor:WXColorWithInteger(0xdd2726)];
    [_textField setEnabled:NO];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassifySearchImg.png"]];
    [_textField setLeftView:imgView leftGap:10 rightGap:0];
    [_textField setLeftViewMode:UITextFieldViewModeUnlessEditing];
    [_textField setPlaceholder:@"搜索商家或商品"];
    [_textField setFont:WXFont(12.0)];
    [self.view addSubview:_textField];
    
    WXUIButton *clearBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = _textField.frame;
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn addTarget:self action:@selector(textfiledStartInput) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

-(void)createRightNavBtn{
    CGFloat btnWidth = 85;
    CGFloat btnHeight = 25;
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Size.width-btnWidth-5, 66-btnHeight-10, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:userObj.userCurrentCity forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, btnWidth-15, 0, 0)];
    [rightBtn addTarget:self action:@selector(showAreaView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

-(WXShopUnionAreaView*)createAreaDropListViewWith:(WXUIButton*)btn{
    CGFloat width = self.bounds.size.width;
    CGFloat height = 300;
    CGRect rect = CGRectMake(0, 0, width, height);
    _areaListView = [[WXShopUnionAreaView alloc] initWithFrame:self.bounds menuButton:btn dropListFrame:rect];
    [_areaListView setDelegate:self];
    return _areaListView;
}

-(WXUIView*)createUnionDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(0, Size.height-ShopUnionDownVieHeight, Size.width, ShopUnionDownVieHeight);
    [downView setBackgroundColor:WXColorWithInteger(0xffffff)];

    CGFloat btnWidth = Size.width/3;
    CGFloat btnHeight = 40;
    for(NSInteger i = 0; i < 3; i++){
        WXUIButton *userOrderBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        userOrderBtn.frame = CGRectMake(i*btnWidth, (ShopUnionDownVieHeight-btnHeight)/2, btnWidth, btnHeight);
        [userOrderBtn setBackgroundColor:[UIColor clearColor]];
        [userOrderBtn setBackgroundImageOfColor:[UIColor colorWithRed:0.975 green:0.936 blue:0.920 alpha:1.000] controlState:UIControlStateHighlighted];
        [userOrderBtn.titleLabel setFont:WXFont(15.0)];
        [userOrderBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
        if(i == ShopUnionDownView_UserOrder){
            [userOrderBtn setTitle:@"订单" forState:UIControlStateNormal];
        }
        if(i == ShopUnionDownView_UserStore){
            [userOrderBtn setImage:[UIImage imageNamed:@"T_AttentionSel.png"] forState:UIControlStateNormal];
        }
        if(i == ShopUnionDownView_UserShoppingCar){
            [userOrderBtn setTitle:@"购物车" forState:UIControlStateNormal];
        }
        userOrderBtn.tag = i;
        [userOrderBtn addTarget:self action:@selector(shopUnionDownViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:userOrderBtn];
    }
    return downView;
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(gotoCityListVC) name:K_Notification_Name_ShopUnionAreaViewCityChoose object:nil];
    [defaultCenter addObserver:self selector:@selector(maskViewClicked) name:K_Notification_Name_MaskviewClicked object:nil];
}

#pragma mark tableview
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
    return ShopUnion_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    switch (section) {
        case ShopUnion_Section_HotShop:
            row = 2;
            break;
        case ShopUnion_Section_HotGoods:
            row = 1+[hotGoodsArr count];
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case ShopUnion_Section_Classify:
            height = ShopUnionClassifyRowHeight;
            break;
        case ShopUnion_Section_Activity:
            height = ShopUnionActivityRowHeight;
            break;
        case ShopUnion_Section_HotShop:
        {
            if(row == 0){
                return ShopUnionHotShopTextHeight;
            }else{
                return ShopUnionHotShopListHeight;
            }
        }
            break;
        case ShopUnion_Section_HotGoods:
        {
            if(row == 0){
                return ShopUnionHotGoodsTextHeight;
            }else{
                return ShopUnionHotGoodsListHeight;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case ShopUnion_Section_Activity:
            height = 5;
            break;
        case ShopUnion_Section_HotShop:
            height = 10;
            break;
        case ShopUnion_Section_HotGoods:
            height = 10;
            break;
        default:
            break;
    }
    return height;
}

//分类
-(WXUITableViewCell*)shopUnionClassifyCell{
    static NSString *identifier = @"classifyCell";
    ShopUnionClassifyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopUnionClassifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.classifyShopArr count] > 0){
        [cell setCellInfo:_model.classifyShopArr];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//活动
-(WXUITableViewCell*)shopUnionActivityCell{
    static NSString *identifier = @"activityCell";
    WXShopUnionActivityCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//推荐商家title
-(WXUITableViewCell*)shopUnionHotShopTitleCell{
    static NSString *identifier = @"hotShopTitleCell";
    WXShopUnionHotShopTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionHotShopTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//推荐商家
-(WXUITableViewCell*)shopUnionHotShopCell:(NSInteger)row{
    static NSString *identifier = @"hotShopCell";
    WXShopUnionHotShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionHotShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = row*3;
    NSInteger count = [hotShopArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = (row-1)*3; i < max; i++){
        [rowArray addObject:[hotShopArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//推荐商品标题
-(WXUITableViewCell*)shopUnionHotGoodsTitleCell{
    static NSString *identifier = @"hotGoodsTitleCell";
    WXShopUnionHotGoodsTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionHotGoodsTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//推荐商品
-(WXUITableViewCell*)shopUnionHotGoodsCell:(NSInteger)row{
    static NSString *identifier = @"hotGoodsCell";
    WXShopUnionHotGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXShopUnionHotGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([hotGoodsArr count] > 0){
        [cell setCellInfo:[hotGoodsArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case ShopUnion_Section_Classify:
            cell = [self shopUnionClassifyCell];
            break;
        case ShopUnion_Section_Activity:
            cell = [self shopUnionActivityCell];
            break;
        case ShopUnion_Section_HotShop:
        {
            if(row == 0){
                cell = [self shopUnionHotShopTitleCell];
            }else{
                cell = [self shopUnionHotShopCell:row];
            }
        }
            break;
        case ShopUnion_Section_HotGoods:
        {
            if(row == 0){
                cell = [self shopUnionHotGoodsTitleCell];
            }else{
                cell = [self shopUnionHotGoodsCell:row];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == ShopUnion_Section_HotGoods){
        ShopUnionHotGoodsEntity *entity = [hotGoodsArr objectAtIndex:row-1];
        LMGoodsInfoVC *goodsInfoVC = [[LMGoodsInfoVC alloc] init];
        goodsInfoVC.goodsId = entity.goodsID;
        [self.wxNavigationController pushViewController:goodsInfoVC];
    }
}

-(void)showAreaView{
    if(showAreaview){
        showAreaview = NO;
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
    }else{
        showAreaview = YES;
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    }
}

#pragma mark dataDelegate
-(void)loadShopUnionDataSucceed{
    hotGoodsArr = _model.hotGoodsArr;
    hotShopArr = _model.hotShopArr;
    [_tableView headerEndRefreshing];
    [_tableView reloadData];
}

-(void)loadShopUnionDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView headerEndRefreshing];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark 刷新
-(void)headerRefreshing{
    [_model loadShopUnionData:0];
}

-(void)loadMoreGoods{
}

-(void)footerRefreshing{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
//        [self loadMoreGoods];
    });
}

#pragma mark cityAreaDelegate
-(void)changeCityArea:(id)entity{
    NSString *name = entity;
    [rightBtn setTitle:name forState:UIControlStateNormal];
    [self showAreaView];
}

-(void)changeCity{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [rightBtn setTitle:userObj.userCurrentCity forState:UIControlStateNormal];
    [_tableView headerBeginRefreshing];
}

#pragma mark tocityList
-(void)gotoCityListVC{
    [_areaListView unshow:YES];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    WXShopCityListVC *cityListVC = [[WXShopCityListVC alloc] init];
    [self presentViewController:cityListVC animated:YES completion:^{
    }];
}

#pragma mark classifyDelegate
-(void)clickClassifyBtnAtIndex:(NSInteger)index{
    NSLog(@"行业ID = %ld",(long)index);
    for(ShopUnionClassifyEntity *entity in _model.classifyShopArr){
        if(entity.industryID == index){
            WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
            [userDefault setObject:entity.industryName forKey:@"industryName"];
            break;
        }
    }
    
    LMSellerClassifyVC *sellerClassifyVC = [[LMSellerClassifyVC alloc] init];
    sellerClassifyVC.industryID = index;
    sellerClassifyVC.sellerClassifyArr = _model.classifyShopArr;
    [self.wxNavigationController pushViewController:sellerClassifyVC];
}

#pragma mark shopActivityDelegate
-(void)wxShopUnionActivityCellClicked{
    NSLog(@"商家联盟活动");
}

#pragma mark hotShopTitleDelegate
-(void)shopUnionHotShopTitleClicked{
    NSLog(@"查看更多商家");
    LMSellerListVC *sellerVC = [[LMSellerListVC alloc] init];
    [self.wxNavigationController pushViewController:sellerVC];
}

#pragma mark hotShopDelegate
-(void)shopUnionHotShopCellBtnClicked:(id)sender{
    NSLog(@"推荐商家");
}

#pragma mark maskViewDelegate
-(void)maskViewClicked{
    [self showAreaView];
}

#pragma mark downViewDelegate
-(void)shopUnionDownViewBtnClicked:(id)sender{
    WXUIButton *btn = sender;
    if(btn.tag == ShopUnionDownView_UserStore){
        LMCollectionVC *collectionVC = [[LMCollectionVC alloc] init];
        [self.wxNavigationController pushViewController:collectionVC];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_textField.inputView setHidden:YES];
}

-(void)textfiledStartInput{
    LMSearchListVC *searchListVC = [[LMSearchListVC alloc] init];
    [self.wxNavigationController pushViewController:searchListVC];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
