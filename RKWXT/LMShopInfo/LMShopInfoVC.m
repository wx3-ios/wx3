//
//  LMShopInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoVC.h"
#import "LMShopInfoDef.h"

@interface LMShopInfoVC()<UITableViewDataSource,UITableViewDelegate,CDSideBarControllerDelegate,LMShopInfoModelDelegate,ShopInfAllGoodsCellDelegate,ShopInfoHotGoodsCellDelegate,LMShopInfoBaseFunctionCellDelegate,LMShopInfoTopImgCellDelegate,UIActionSheetDelegate>{
    UITableView *_tableView;
    CDSideBarController *sideBar;
    WXUIButton *collectionBtn;
    
    LMShopInfoModel *_shopModel;
    LMDataCollectionModel *collectionModel;
    BOOL collection;
    NSString *shopPhone;
    
    NSArray *shopInfoArr;
    NSArray *allGoodsArr;
    NSArray *comGoodsArr;
}
@end

@implementation LMShopInfoVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.bounds.size.width-35, 66-35)];
    
    collectionBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(self.bounds.size.width-35-45, 64-35, 25, 25);
    [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(userCollectionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionBtn];
}

-(id)init{
    self = [super init];
    if(self){
        _shopModel = [[LMShopInfoModel alloc] init];
        [_shopModel setDelegate:self];
        
        collectionModel = [[LMDataCollectionModel alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"店铺详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self addOBS];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //初始化分享
    [self initDropList];
    [_shopModel loadLMShopInfoData:_sshop_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(userCollectionShopSucceed) name:K_Notification_Name_ShopAddCollectionSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(userCancelCollectionShopSucceed) name:K_Notification_Name_ShopCancelCollectionSucceed object:nil];
}

-(void)initDropList{
    NSArray *imageList = @[[UIImage imageNamed:@"ShareQqImg.png"], [UIImage imageNamed:@"ShareQzoneImg.png"], [UIImage imageNamed:@"ShareWxFriendImg.png"], [UIImage imageNamed:@"ShareWxCircleImg.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
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
    return LMShopInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case LMShopInfo_Section_TopImg:
        case LMShopInfo_Section_BaseFunction:
            row = 1;
            break;
        case LMShopInfo_Section_Activity:
            row = 0;
            break;
        case LMShopInfo_Section_HotGoods:
            row = [comGoodsArr count]/2+([comGoodsArr count]%2>0?1:0);
            break;
        case LMShopInfo_Section_AllGoods:
            row = [allGoodsArr count]/2+([allGoodsArr count]%2>0?1:0);
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch (indexPath.section) {
        case LMShopInfo_Section_TopImg:
            height = LMShopInfoTopImgHeight;
            break;
        case LMShopInfo_Section_BaseFunction:
            height = LMShopInfoBaseFunctionHeight;
            break;
        case LMShopInfo_Section_Activity:
//            height = LMShopInfoActivityHeight;
            height = 0;
            break;
        case LMShopInfo_Section_HotGoods:
            height = LMShopInfoHotGoodsHeight;
            break;
        case LMShopInfo_Section_AllGoods:
            height = LMShopInfoHotGoodsHeight;
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case LMShopInfo_Section_HotGoods:
        case LMShopInfo_Section_AllGoods:
            height = LMShopInfoSectionTitleHeight;
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
        case LMShopInfo_Section_HotGoods:
            title = @"热销商品";
            height = LMShopInfoSectionTitleHeight;
            break;
        case LMShopInfo_Section_AllGoods:
            title = @"所有商品";
            height = LMShopInfoSectionTitleHeight;
            break;
        default:
            break;
    }
    
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 0, Size.width, 0.5);
    [lineLabel setBackgroundColor:WXColorWithInteger(0x969696)];
    [titleView addSubview:lineLabel];
    
    CGFloat labelHeight = 18;
    CGFloat labelWidth = 100;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(10, (height-labelHeight)/2, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor whiteColor]];
    [textLabel setText:title];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(15.0)];
    [titleView addSubview:textLabel];
    
    titleView.frame = CGRectMake(0, 0, Size.width, height);
    return titleView;
}

//顶部大图
-(WXUITableViewCell*)shopInfoTopImgView{
    static NSString *identifier = @"topImgCell";
    LMShopInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([shopInfoArr count] > 0){
        [cell setCellInfo:[shopInfoArr objectAtIndex:0]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//基本模块
-(WXUITableViewCell*)shopInfoBaseFunctionCell{
    static NSString *identifier = @"baseFunctionCell";
    LMShopInfoBaseFunctionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoBaseFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([shopInfoArr count] > 0){
        [cell setCellInfo:[shopInfoArr objectAtIndex:0]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//活动图片
-(WXUITableViewCell*)shopInfoActivityCell{
    static NSString *identifier = @"activityCell";
    LMShopInfoActivityCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)shopInfoHotGoodsListCell:(NSInteger)row{
    static NSString *identifier = @"hotGoodsCell";
    ShopInfoHotGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopInfoHotGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*2;
    NSInteger count = [comGoodsArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*2; i < max; i++){
        [rowArray addObject:[comGoodsArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(WXUITableViewCell*)shopInfoAllGoodsListCell:(NSInteger)row{
    static NSString *identifier = @"allGoodsCell";
    ShopInfAllGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopInfAllGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*2;
    NSInteger count = [allGoodsArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*2; i < max; i++){
        [rowArray addObject:[allGoodsArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

////评价
//-(WXUITableViewCell*)shopInfoEvaluateTitleCell{
//    static NSString *identifier = @"EvaluateTitleCell";
//    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell){
//        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.textLabel.text = @"评价";
//    [cell.textLabel setFont:WXFont(14.0)];
//    return cell;
//}
//
//-(WXUITableViewCell*)shopInfoMoreEvaluateCell{
//    static NSString *identifier = @"MoreEvaluateCell";
//    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell){
//        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
//    cell.textLabel.text = @"查看更多评价";
//    [cell.textLabel setFont:WXFont(14.0)];
//    return cell;
//}

//-(WXUITableViewCell*)shopInfoEvaluateListCell{
//    static NSString *identifier = @"evaluateListCell";
//    ShopInfoEvaluateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
//    if(!cell){
//        cell = [[ShopInfoEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    [cell load];
//    return cell;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case LMShopInfo_Section_TopImg:
            cell = [self shopInfoTopImgView];
            break;
        case LMShopInfo_Section_BaseFunction:
            cell = [self shopInfoBaseFunctionCell];
            break;
        case LMShopInfo_Section_Activity:
            cell = [self shopInfoActivityCell];
            break;
        case LMShopInfo_Section_HotGoods:
            cell = [self shopInfoHotGoodsListCell:row];
            break;
        case LMShopInfo_Section_AllGoods:
            cell = [self shopInfoAllGoodsListCell:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark data
-(void)loadLMShopinfoDataSucceed{
    [self unShowWaitView];
    shopInfoArr = _shopModel.shopInfoArr;
    allGoodsArr = _shopModel.allGoodsArr;
    comGoodsArr = _shopModel.comGoodsArr;
    [_tableView reloadData];
    
    if([shopInfoArr count] > 0){
        LMShopInfoEntity *entity = [shopInfoArr objectAtIndex:0];
        collection = entity.collection;
        if(collection){
            [collectionBtn setImage:[UIImage imageNamed:@"LMGoodsAttention.png"] forState:UIControlStateNormal];
        }else{
            [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)loadLMShopinfoDataFailed:(NSString *)errormsg{
    [self unShowWaitView];
    if(!errormsg){
        errormsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errormsg];
}

#pragma mark collection
-(void)userCollectionBtnClicked{
    if(!collection){
        [collectionModel lmCollectionData:_sshop_id goods:0 type:LMCollection_Type_Shop dataType:CollectionData_Type_Add];
    }else{
        [collectionModel lmCollectionData:_sshop_id goods:0 type:LMCollection_Type_Shop dataType:CollectionData_Type_Deleate];
    }
}

-(void)userCollectionShopSucceed{
    collection = YES;
    [collectionBtn setImage:[UIImage imageNamed:@"LMGoodsAttention.png"] forState:UIControlStateNormal];
    [UtilTool showTipView:@"收藏成功"];
}

-(void)userCancelCollectionShopSucceed{
    collection = NO;
    [collectionBtn setImage:[UIImage imageNamed:@"T_Attention.png"] forState:UIControlStateNormal];
    [UtilTool showTipView:@"取消收藏"];
}

#pragma mark 分享
-(void)menuButtonClicked:(int)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if([_shopModel.shopInfoArr count] > 0){
        LMShopInfoEntity *entity = [_shopModel.shopInfoArr objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:entity.homeImg];
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
    if([shopInfoArr count] > 0){
        LMShopInfoEntity *entity = [shopInfoArr objectAtIndex:0];
        title = entity.shopName;
    }
    return title;
}

-(NSString*)sharedGoodsInfoDescription{
    NSString *description = [NSString stringWithFormat:@"我发现一个很不错的店铺，赶快来看看。"];
    return description;
}

-(NSString*)sharedGoodsInfoUrlString{
    NSString *strB = [[self sharedGoodsInfoTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *urlString = [NSString stringWithFormat:@"%@wx_html/index.php/Shop/index?sid=%ld&shop_id=%ld&go=su_shop&title=%@&sshop_id=%ld&woxin_id=%ld",WXTWebBaseUrl,(long)kMerchantID,(long)kSubShopID,strB,(long)_sshop_id,(long)userDefault.wxtID];
    return urlString;
}

#pragma mark baseFunctionBtn
-(void)lmShopInfoBaseFunctionBtnClicked:(NSInteger)index{
    switch (index) {
        case 0:
        {
            LMShopInfoAllGoodsVC *allGoodsVC = [[LMShopInfoAllGoodsVC alloc] init];
            allGoodsVC.sshop_id = _sshop_id;
            [self.wxNavigationController pushViewController:allGoodsVC];
        }
            break;
        case 1:
        {
            LMShopInfoNewGoodsVC *newGoodsVC = [[LMShopInfoNewGoodsVC alloc] init];
            newGoodsVC.sshop_id = _sshop_id;
            [self.wxNavigationController pushViewController:newGoodsVC];
        }
            break;
        case 3:
        {
            LMShopInfoTrendsVC *trendsVC = [[LMShopInfoTrendsVC alloc] init];
            trendsVC.sshop_id = _sshop_id;
            [self.wxNavigationController pushViewController:trendsVC];
        }
            break;
        default:
            break;
    }
}

#pragma mark goodsBtnClicked
-(void)shopInfoAllGoodsCellBtnClicked:(id)sender{
    LMShopInfoEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:entity.all_goodsID animated:YES];
}

-(void)shopInfoHotGoodsCellBtnClicked:(id)sender{
    LMShopInfoEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:entity.com_goodsID animated:YES];
}

-(void)shopCallBtnClicked:(NSString *)phone{
    NSString *phoneStr = [self phoneWithoutNumber:phone];
    shopPhone = phoneStr;
    [self showAlertView:shopPhone];
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:[NSString stringWithFormat:@"使用%@",kMerchantName]
                                  otherButtonTitles:@"系统", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex > 2){
        return;
    }
    if(shopPhone.length == 0){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = kMerchantName;
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
