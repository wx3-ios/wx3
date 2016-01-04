//
//  LMGoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsInfoVC.h"
#import "LMGoodsInfoDef.h"

@interface LMGoodsInfoVC ()<UITableViewDataSource,UITableViewDelegate,MerchantImageCellDelegate,LMGoodsInfoModelDelegate,LMGoodsDesCellDelegate,CDSideBarControllerDelegate,LMShoppingCartModelDelegate>{
    UITableView *_tableView;
    LMGoodsInfoModel *_model;
    BOOL userCut;
    LMGoods_Collection collection_type;
    LMDataCollectionModel *_collectionModel;
    
    CDSideBarController *sideBar;
    WXUIButton *collectionBtn;
    
    LMGoodsView *goodsView; //库存页面
    
    LMShoppingCartModel *cartModel;
}

@end

@implementation LMGoodsInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addOBS];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.bounds.size.width-35, TopNavigationViewHeight-35)];
    
    collectionBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(self.bounds.size.width-35-45, TopNavigationViewHeight-35, 25, 25);
    [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(userCollectionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionBtn];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMGoodsInfoModel alloc] init];
        [_model setDelegate:self];
        
        _collectionModel = [[LMDataCollectionModel alloc] init];
        
        cartModel = [[LMShoppingCartModel alloc] init];
        [cartModel setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self crateTopNavigationView];
    
    [self initWebView];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, TopNavigationViewHeight, Size.width, Size.height-TopNavigationViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [self.scrollView addSubview:_tableView];
    [self addSubview:[self baseDownView]];
    [self initDropList];
    
    [_model loadGoodsInfoData:_goodsId];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(userBuyBtnClicked) name:K_Notification_Name_UserBuyGoods object:nil];
    [notificationCenter addObserver:self selector:@selector(userAddShoppingCartBtnClicked) name:K_Notification_Name_UserAddShoppingCart object:nil];
    [notificationCenter addObserver:self selector:@selector(goodsCollectionSucceed) name:K_Notification_Name_GoodsAddCollectionSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(goodsCancelCollectionSucceed) name:K_Notification_Name_GoodsCancelCollectionSucceed object:nil];
}

-(void)initDropList{
    NSArray *imageList = @[[UIImage imageNamed:@"ShareQqImg.png"], [UIImage imageNamed:@"ShareQzoneImg.png"], [UIImage imageNamed:@"ShareWxFriendImg.png"], [UIImage imageNamed:@"ShareWxCircleImg.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
}

-(WXUIView*)baseDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    [downView setBackgroundColor:[UIColor whiteColor]];
    CGFloat btnWidth = IPHONE_SCREEN_WIDTH/3/2;
    CGFloat btnHeight = 28;
    
    CGFloat xOffset = 0;
    WXUIButton *sellerBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    sellerBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [sellerBtn setBackgroundColor:[UIColor clearColor]];
    [sellerBtn setImage:[UIImage imageNamed:@"LMGoodsInfoShopImg.png"] forState:UIControlStateNormal];
    [sellerBtn addTarget:self action:@selector(sellerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sellerBtn];
    
    xOffset += btnWidth;
    WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [cartBtn setBackgroundColor:[UIColor clearColor]];
    [cartBtn setImage:[UIImage imageNamed:@"LMGoodsInfoCartImg.png"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(cartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:cartBtn];
    
    xOffset += btnWidth;
    WXUIButton *buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, (IPHONE_SCREEN_WIDTH-xOffset)/2, btnHeight);
    [buyBtn setBackgroundColor:[UIColor clearColor]];
    [buyBtn setTag:1];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:buyBtn];
    
    WXUIButton *addBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset)/2, (DownViewHeight-btnHeight)/2, (IPHONE_SCREEN_WIDTH-xOffset)/2, btnHeight);
    [addBtn setTag:2];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:addBtn];
    
    downView.frame = CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight);
    return downView;
}

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, Size.width, TopNavigationViewHeight);
    [topView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self.view addSubview:topView];
    
    CGFloat xGap = 10;
    CGFloat yGap = 10;
    
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xGap, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 30;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((self.bounds.size.width-labelWidth)/2, TopNavigationViewHeight-yGap-labelHeight, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(15.0)];
    [titleLabel setText:@"商品详情"];
    [titleLabel setTextColor:WXColorWithInteger(0x000000)];
    [topView addSubview:titleLabel];
}

-(UIView*)tableFooterView{
    CGFloat height = 75;
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, Size.width, height);
    [footView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 25;
    WXUIButton *moreEvaluteBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    moreEvaluteBtn.frame = CGRectMake((Size.width-btnWidth)/2, (height-btnHeight)/2, btnWidth, btnHeight);
    [moreEvaluteBtn setBackgroundColor:[UIColor clearColor]];
    [moreEvaluteBtn setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xdd2726)];
    [moreEvaluteBtn setTitle:@"查看更多评价" forState:UIControlStateNormal];
    [moreEvaluteBtn.titleLabel setFont:WXFont(15.0)];
    [moreEvaluteBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [moreEvaluteBtn addTarget:self action:@selector(searchMoreEvaluateData) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreEvaluteBtn];
    
    return footView;
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return LMGoodsInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case LMGoodsInfo_Section_TopImg:
        case LMGoodsInfo_Section_GoodsDesc:
        case LMGoodsInfo_Section_SellerInfo:
            row = 1;
            break;
        case LMGoodsInfo_Section_GoodsInfo:
            row = [_model.attrArr count];
            break;
        case LMGoodsInfo_Section_OtherShop:
            row = [_model.otherShopArr count];
            break;
        case LMGoodsInfo_Section_Evaluate:
            row = [_model.evaluteArr count];
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMGoodsInfo_Section_TopImg:
            height = IPHONE_SCREEN_WIDTH;
            break;
        case LMGoodsInfo_Section_GoodsDesc:
        {
            height = LMGoodsDesCellHeight;
            if([_model.goodsInfoArr count] > 0){
                LMGoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
                if(entity.postage == LMGoods_Postage_None || userCut){
                    height += 40;
                }
            }
        }
            break;
        case LMGoodsInfo_Section_GoodsInfo:
            height = LMGoodsBaseInfoCellHeight;
            break;
        case LMGoodsInfo_Section_SellerInfo:
        case LMGoodsInfo_Section_OtherShop:
            height = LMGoodsSellerInfoCellHeight;
            break;
        case LMGoodsInfo_Section_Evaluate:
        {
            if([_model.evaluteArr count] > 0){
                height = [LMGoodsEvaluteCell cellHeightOfInfo:[_model.evaluteArr objectAtIndex:0]];
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
        case LMGoodsInfo_Section_GoodsInfo:
            height = LMGoodsInfoTitleHeaderViewHeight;
            break;
        case LMGoodsInfo_Section_SellerInfo:
        case LMGoodsInfo_Section_OtherShop:
        case LMGoodsInfo_Section_Evaluate:
            height = LMGoodsOtherHeaderViewHeight;
            break;
        default:
            break;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    NSString *title = nil;
    switch (section) {
        case LMGoodsInfo_Section_GoodsInfo:
            height = LMGoodsInfoTitleHeaderViewHeight;
            title = @"详细商品参数";
            break;
        case LMGoodsInfo_Section_SellerInfo:
            title = @"商家信息";
            height = LMGoodsOtherHeaderViewHeight;
            break;
        case LMGoodsInfo_Section_OtherShop:
            title = @"推荐店铺";
            height = LMGoodsOtherHeaderViewHeight;
            break;
        case LMGoodsInfo_Section_Evaluate:
            title = @"评论";
            height = LMGoodsOtherHeaderViewHeight;
            break;
        default:
            break;
    }
    
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    CGFloat labelHeight = 18;
    CGFloat labelWidth = [NSString widthForString:title fontSize:11.0 andHeight:labelHeight];
    
    CGFloat lineWidth = IPHONE_SCREEN_WIDTH/2;
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-lineWidth)/2, height/2, lineWidth, 0.5);
    [lineLabel setBackgroundColor:WXColorWithInteger(0xdbdbdb)];
    [titleView addSubview:lineLabel];
    
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-labelWidth)/2, (height-labelHeight)/2, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor whiteColor]];
    [textLabel setText:title];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(11.0)];
    [titleView addSubview:textLabel];
    
    titleView.frame = CGRectMake(0, 0, Size.width, height);
    return titleView;
}

-(void)initWebView{
    //初始化图文详情页面，方便上拉加载数据
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_goodsId], @"goods_id",[NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", nil];
    
    CGSize size = self.bounds.size;
    self.scrollView.contentSize = CGSizeMake(size.width, size.height);
    self.subViewController = [[NewGoodsInfoWebViewViewController alloc] initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
    self.subViewController.mainViewController = self;
}

//顶部大图
-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    MerchantImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MerchantImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    LMGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    for(int i = 0; i< [entity.goodsImgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[entity.goodsImgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[MerchantImageCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
    LMGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    
    NewImageZoomView *img = [[NewImageZoomView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];
    [img updateImageDate:entity.goodsImgArr selectIndex:index];
}

//商品介绍
-(WXUITableViewCell*)goodsDesCell{
    static NSString *identifier = @"desCell";
    LMGoodsDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    if([_model.goodsInfoArr count] > 0){
        [cell setCellInfo:[_model.goodsInfoArr objectAtIndex:0]];
        [cell setUserCut:userCut];
    }
    [cell load];
    return cell;
}

//商品详情
-(WXUITableViewCell*)goodsInfoCell:(NSInteger)row{
    static NSString *identifier = @"infoCell";
    LMGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.attrArr count] > 0){
        [cell setCellInfo:[_model.attrArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

//商家信息
-(WXUITableViewCell*)goodsSellerCell{
    static NSString *identifier = @"goodsSellerCell";
    LMGoodsSellerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsSellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([_model.sellerArr count] > 0){
        [cell setCellInfo:[_model.sellerArr objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

//其他商家推荐
-(WXUITableViewCell*)goodsOtherSellerCell:(NSInteger)row{
    static NSString *identifier = @"otherSellerCell";
    LMGoodsOtherSellerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsOtherSellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([_model.otherShopArr count] > 0){
        [cell setCellInfo:[_model.otherShopArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

//评论
-(WXUITableViewCell*)goodsEvaluteCell:(NSInteger)row{
    static NSString *identifier = @"evaluteCell";
    LMGoodsEvaluteCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsEvaluteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.evaluteArr count] > 0){
        [cell setCellInfo:[_model.evaluteArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case LMGoodsInfo_Section_TopImg:
            cell = [self tableViewForTopImgCell];
            break;
        case LMGoodsInfo_Section_GoodsDesc:
            cell = [self goodsDesCell];
            break;
        case LMGoodsInfo_Section_GoodsInfo:
            cell = [self goodsInfoCell:row];
            break;
        case LMGoodsInfo_Section_SellerInfo:
            cell = [self goodsSellerCell];
            break;
        case LMGoodsInfo_Section_OtherShop:
            cell = [self goodsOtherSellerCell:row];
            break;
        case LMGoodsInfo_Section_Evaluate:
            cell = [self goodsEvaluteCell:row];
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
    if(section == LMGoodsInfo_Section_SellerInfo){
        LMGoodsInfoEntity *entity = [_model.sellerArr objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toLMSellerInfopVC:self sellerID:entity.sellerID animated:YES];
    }
    if(section == LMGoodsInfo_Section_OtherShop){
        LMGoodsInfoEntity *entity = [_model.otherShopArr objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toLMShopInfoVC:self shopID:entity.shopID animated:YES];
    }
}

#pragma mark dataDelegate
-(void)loadGoodsInfoDataSucceed{
    [self unShowWaitView];
    if([_model.evaluteArr count] == 0){
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }else{
        [_tableView setTableFooterView:[self tableFooterView]];
    }
    
    if([_model.stockArr count] > 0){
        for(LMGoodsInfoEntity *entity in _model.stockArr){
            if(entity.userCut > 0){
                userCut = YES;
            }
        }
    }
    if([_model.goodsInfoArr count] > 0){
        for(LMGoodsInfoEntity *entity in _model.goodsInfoArr){
            collection_type = entity.collectionType;
            if(entity.collectionType == LMGoods_Collection_None){
                [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
            }else{
                [collectionBtn setImage:[UIImage imageNamed:@"LMGoodsAttention.png"] forState:UIControlStateNormal];
            }
        }
    }
    [_tableView reloadData];
}

-(void)loadGoodsInfoDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark downView
-(void)sellerBtnClick{
    if([_model.goodsInfoArr count] > 0){
        LMGoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
        [[CoordinateController sharedCoordinateController] toLMShopInfoVC:self shopID:entity.goodshop_id animated:YES];
    }
}

-(void)cartBtnClick{
    LMShoppingCartVC *shoppingVC = [[LMShoppingCartVC alloc] init];
    [self.wxNavigationController pushViewController:shoppingVC];
}

-(void)buyBtnClick:(id)sender{
    if([_model.goodsInfoArr count] == 0){
        [UtilTool showAlertView:@"数据加载失败"];
        return;
    }
    WXUIButton *btn = sender;
    goodsView = [[LMGoodsView alloc] init];
    if(btn.tag == 1){
        [goodsView setGoodsViewType:LMGoodsView_Type_Buy];
    }else{
        [goodsView setGoodsViewType:LMGoodsView_Type_ShoppingCart];
    }
    [goodsView loadGoodsStockInfo:_model.stockArr];
    [self.view addSubview:goodsView];
}

//查看更多评价
-(void)searchMoreEvaluateData{
    LMGoodsMoreEvaluateVC *evaluateVC = [[LMGoodsMoreEvaluateVC alloc] init];
    evaluateVC.goodsID = _goodsId;
    [self.wxNavigationController pushViewController:evaluateVC];
}

//购买
-(void)userBuyBtnClicked{
    LMMakeOrderVC *makeOrderVC = [[LMMakeOrderVC alloc] init];
    makeOrderVC.goodsArr = [self makeOrderInfoArr];
    [self.wxNavigationController pushViewController:makeOrderVC];
}

-(NSArray*)makeOrderInfoArr{
    NSMutableArray *goodsInfoArr = [[NSMutableArray alloc] init];
    LMGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    if(!entity){
        return nil;
    }
    entity.homeImg = @"";
    entity.goodsID = _goodsId;
    entity.stockID = goodsView.stockID;
    entity.stockName = goodsView.stockName;
    entity.stockPrice = goodsView.stockPrice;
    entity.stockNum = goodsView.buyNum;
    [goodsInfoArr addObject:entity];
    
    return goodsInfoArr;
}

//加入购物车
-(void)userAddShoppingCartBtnClicked{
    LMGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    [cartModel addLMShoppingCartType:LMSHoppingCart_Type_Add goodsID:_goodsId stockID:goodsView.stockID stockName:goodsView.stockName goodsName:entity.goodsName goodsImg:[self remoHomeImgPre:entity.homeImg] goodsPrice:goodsView.stockPrice/goodsView.buyNum goodsNum:goodsView.buyNum shopID:entity.goodshop_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(NSString*)remoHomeImgPre:(NSString*)homeImg{
    NSInteger length = AllImgPrefixUrlString.length;
    NSString *img = [homeImg substringWithRange:NSMakeRange(length, homeImg.length-length)];
    return img;
}

-(void)addLMShoppingCartSucceed{
    [self unShowWaitView];
    [UtilTool showTipView:@"加入购物车成功"];
}

-(void)addLMShoppingCartFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"未能加入购物车";
    }
    [UtilTool showTipView:errorMsg];
}

#pragma mark desCellDelegate
-(void)lmGoodsInfoDesCarriageBtnClicked{
    [UtilTool showTipView:@"该商品免运费"];
}

-(void)lmGoodsInfoDesCutBtnClicked{
    [UtilTool showTipView:@"该商品有分成"];
}

#pragma mark collection
-(void)userCollectionBtnClicked{
    LMGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    if(collection_type == LMGoods_Collection_None){
        [_collectionModel lmCollectionData:entity.goodshop_id goods:entity.goodsID type:LMCollection_Type_Goods dataType:CollectionData_Type_Add];
    }
    if(collection_type == LMGoods_Collection_Has){
        [_collectionModel lmCollectionData:entity.goodshop_id goods:entity.goodsID type:LMCollection_Type_Goods dataType:CollectionData_Type_Deleate];
    }
}

-(void)goodsCollectionSucceed{
    collection_type = LMGoods_Collection_Has;
    [collectionBtn setImage:[UIImage imageNamed:@"LMGoodsAttention.png"] forState:UIControlStateNormal];
    [UtilTool showTipView:@"收藏成功"];
}

-(void)goodsCancelCollectionSucceed{
    collection_type = LMGoods_Collection_None;
    [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
    [UtilTool showTipView:@"取消收藏"];
}

#pragma mark sharedDelegate
-(void)menuButtonClicked:(int)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if([_model.goodsInfoArr count] > 0){
        LMGoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:entity.goodsImg];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data){
            image = [UIImage imageWithData:data];
        }
    }
    if(index == Share_Friends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] linkURL:[self sharedGoodsInfoUrlString] thumbImage:image];
    }
    if(index == Share_Clrcle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] linkURL:[self sharedGoodsInfoUrlString] thumbImage:image];
    }
    if(index == Share_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self sharedGoodsInfoUrlString]] title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self sharedGoodsInfoUrlString]] title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
}

-(NSString*)sharedGoodsInfoTitle{
    NSString *title = @"";
    if([_model.goodsInfoArr count] > 0){
        LMGoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
        title = entity.goodsName;
    }
    return title;
}

-(NSString*)sharedGoodsInfoDescription{
    NSString *description = @"";
    description = [NSString stringWithFormat:@"我在%@发现一个不错的商品，赶快来看看吧。",kMerchantName];
    return description;
}

-(NSString*)sharedGoodsInfoUrlString{
    NSString *strB = [[self sharedGoodsInfoTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *urlString = [NSString stringWithFormat:@"%@wx_html/index.php/Shop/index?shop_id=%d&MerchantID=%d&go=good_detail&title=%@&goods_id=%ld&woxin_id=%@",WXTShareBaseUrl,kSubShopID,kMerchantID,strB,(long)_goodsId,userDefault.wxtID];
    return urlString;
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
