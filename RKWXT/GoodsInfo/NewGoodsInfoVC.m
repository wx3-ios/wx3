//
//  NewGoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewGoodsInfoVC.h"
#import "GoodsInfoDef.h"
#import "NewGoodsInfoModel.h"
#import "NewGoodsInfoRightView.h"
#import "T_InsertData.h"
#import "T_MenuVC.h"
#import "GoodsInfoEntity.h"
#import "WXTMallListWebVC.h"
#import "ShoppingCartModel.h"
#import "SCartListModel.h"
#import "ShoppingCartEntity.h"
#import "WXWeiXinOBJ.h"
#import "DownSheet.h"
#import <TencentOpenAPI/QQApiInterface.h>

#define DownViewHeight (46)
#define RightViewXGap (50)

@interface NewGoodsInfoVC()<UITableViewDataSource,UITableViewDelegate,PayAttentionToGoodsDelegate,NewGoodsInfoModelDelegate,AddGoodsToShoppingCartDelegate,DownSheetDelegate>{
    UITableView *_tableView;
    NewGoodsInfoRightView *rightView;
    BOOL _isOpen;
    BOOL _showUpview;
    
    NewGoodsInfoModel *_model;
    ShoppingCartModel *_shopModel;
    
    WXUIButton *buyNowBtn;
    
    NSArray *menuList;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation NewGoodsInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[NewGoodsInfoModel alloc] init];
        [_model setDelegate:self];
        _isOpen = NO;
        _shopModel = [[ShoppingCartModel alloc] init];
        [_shopModel setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _model.goodID = _goodsId;
    [_model loadGoodsInfo:_model.goodID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height-DownViewHeight);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    if(isIOS7){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 2, 0, 2)];
        [_tableView setSeparatorColor:WXColorWithInteger(0xEBEBEB)];
    }
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self downViewShow]];
    
    WXUIButton *btn = [self createNavBackBtn];
    [_tableView addSubview:btn];
    
    //侧拉
    _showUpview = YES;
    rightView = [self createRightViewWith:buyNowBtn];
    [rightView unshow:NO];
    [self.view addSubview:rightView];
    
    [self addNotification];
    [self initDropList];
}

-(void)initDropList{
    DownSheetModel *model_1 = [[DownSheetModel alloc] init];
    model_1.icon = @"ShareQqImg.png";
    model_1.icon_on = @"ShareQqImg.png";
    model_1.title = @"分享到qq好友";
    
    DownSheetModel *model_2 = [[DownSheetModel alloc] init];
    model_2.icon = @"ShareQzoneImg.png";
    model_2.icon_on = @"ShareQzoneImg.png";
    model_2.title = @"分享到qq空间";
    
    DownSheetModel *model_3 = [[DownSheetModel alloc] init];
    model_3.icon = @"ShareWxFriendImg.png";
    model_3.icon_on = @"ShareWxFriendImg.png";
    model_3.title = @"分享到微信好友";
    
    DownSheetModel *model_4 = [[DownSheetModel alloc] init];
    model_4.icon = @"ShareWxCircleImg.png";
    model_4.icon_on = @"ShareWxCircleImg.png";
    model_4.title = @"分享到朋友圈";
    
    DownSheetModel *model_5 = [[DownSheetModel alloc] init];
    model_5.icon = @"Icon.png";
    model_5.icon_on = @"Icon.png";
    model_5.title = @"取消";
    
    menuList = @[model_1,model_2,model_3,model_4,model_5];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMakeOrder) name:K_Notification_GoodsInfo_CommitGoods object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NewGoodsInfoRightView*)createRightViewWith:(WXUIButton*)btn{
    CGFloat width = self.bounds.size.width-RightViewXGap;
    CGFloat height = self.view.bounds.size.height;
    CGRect rect = CGRectMake(RightViewXGap, 0, width, height);
    rightView = [[NewGoodsInfoRightView alloc] initWithFrame:self.bounds menuButton:btn dropListFrame:rect];
    return rightView;
}

-(WXUIButton*)createNavBackBtn{
    CGFloat xOffset = 20;
    CGFloat yOffset = 30;
    CGFloat btnWidth = 30;
    CGFloat btnHeight = btnWidth;
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHeight);
    [backBtn setImage:[UIImage imageNamed:@"T_Back.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    return backBtn;
}

-(WXUIView *)downViewShow{
    WXUIView *footView = [[WXUIView alloc] init];
    
    CGFloat xOffset = 0;
    CGFloat btnWidth = 75;
    CGFloat btnHeight = DownViewHeight;
    WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(xOffset, 0, btnWidth, btnHeight);
    [cartBtn setBackgroundColor:[UIColor grayColor]];
    [cartBtn setImage:[UIImage imageNamed:@"T_ShoppingCart.png"] forState:UIControlStateNormal];
    [cartBtn setImageEdgeInsets:(UIEdgeInsetsMake(5, 20, DownViewHeight/2, 0))];
    [cartBtn setTitle:@"购物车" forState:UIControlStateNormal];
    [cartBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [cartBtn.titleLabel setFont:WXFont(9.0)];
    [cartBtn setTitleEdgeInsets:(UIEdgeInsetsMake(DownViewHeight/2, 0, 0, 21))];
    [cartBtn addTarget:self action:@selector(cartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:cartBtn];
    
    xOffset += btnWidth;
    CGFloat buyBtnWidth = 122;
    buyNowBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyNowBtn.frame = CGRectMake(xOffset, 0, buyBtnWidth, btnHeight);
    [buyNowBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowBtn addTarget:self action:@selector(buyNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:buyNowBtn];
    
    xOffset += buyBtnWidth;
    CGFloat cartWidth = 123;
    WXUIButton *insertCartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    insertCartBtn.frame = CGRectMake(xOffset, 0, cartWidth, btnHeight);
    [insertCartBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [insertCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [insertCartBtn addTarget:self action:@selector(insertMyShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:insertCartBtn];
    
    CGRect rect = CGRectMake(0, self.bounds.size.height-DownViewHeight+7, self.bounds.size.width, DownViewHeight);
    [footView setFrame:rect];
    return footView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_GoodsInfo_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case T_GoodsInfo_TopImg:
        case T_GoodsInfo_Description:
        case T_GoodsInfo_WebShow:
            row = 1;
            break;
        case T_GoodsInfo_BaseData:
        {
            if(_isOpen){
                if(_selectedIndexPath.section == section){
                    if([_model.data count] > 0){
                        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
                        return [entity.customNameArr count]+1;
                    }else{
                        return 1;
                    }
                }
            }else{
                return 1;
            }
        }
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
        case T_GoodsInfo_TopImg:
            height = T_GoodsInfoTopImgHeight;
            break;
        case T_GoodsInfo_Description:
            height = T_GoodsInfoDescHeight;
            break;
        case T_GoodsInfo_WebShow:
            height = T_GoodsInfoWebCellHeight;
            break;
        case T_GoodsInfo_BaseData:
        {
            if(indexPath.row == 0){
                height = T_GoodsInfoOldBDCellHeight;
                }else{
                height = [NewGoodsInfoDownCell cellHeightOfInfo:nil];
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == T_GoodsInfo_WebShow){
        height = 10.0;
    }
    return height;
}

//顶部大图
-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    MerchantImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MerchantImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = nil;
    if([_model.data count] > 0){
        entity = [_model.data objectAtIndex:0];
    }
    for(int i = 0; i< [entity.imgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, T_GoodsInfoTopImgHeight)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[entity.imgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[MerchantImageCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell load];
    return cell;
}

//商品描述
-(WXUITableViewCell*)tableViewForGoodsInfoDescCell{
    static NSString *identifier = @"descCell";
    NewGoodsInfoDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    if([_model.data count] > 0){
        [cell setCellInfo:[_model.data objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

//图文详情
-(WXUITableViewCell*)tableViewWebShowCell{
    static NSString *identifier = @"webShowCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
    [cell.textLabel setText:@"图文详情"];
    return cell;
}

//产品参数
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsInfo.png"]];
    [cell.textLabel setText:@"产品参数"];
    [cell changeArrowWithDown:_isOpen];
    return cell;
}

-(WXUITableViewCell*)tabelViewForDownCellAtRow:(NSInteger)row{
    static NSString *identifier = @"textCell";
    NewGoodsInfoDownCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.data count] > 0){
        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
//        [cell setCellInfo:[entity.customNameArr objectAtIndex:row]];
        [cell setName:[entity.customNameArr objectAtIndex:row-1]];
        [cell setInfo:[entity.customInfoArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isOpen && indexPath.section == T_GoodsInfo_BaseData){
        static NSString *identifier = @"goodsInfoBDCell";
        NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row > 0){
            cell = (NewGoodsInfoBDCell*)[self tabelViewForDownCellAtRow:indexPath.row];
        }
        if(indexPath.row == 0){
            [cell changeArrowWithDown:_isOpen];
            [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsInfo.png"]];
            [cell.textLabel setText:@"产品参数"];
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        switch (section) {
            case T_GoodsInfo_TopImg:
                cell = [self tableViewForTopImgCell];
                break;
            case T_GoodsInfo_Description:
                cell = [self tableViewForGoodsInfoDescCell];
                break;
            case T_GoodsInfo_WebShow:
                cell = [self tableViewWebShowCell];
                break;
            case T_GoodsInfo_BaseData:
                cell = [self tableViewForBaseDataCell:indexPath];
                break;
            default:
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == T_GoodsInfo_WebShow){
        [self gotoWebView];
    }
    if(section == T_GoodsInfo_BaseData){
        if(indexPath.row == 0){
            if([indexPath isEqual:_selectedIndexPath]){
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                _selectedIndexPath = nil;
            }else{
                if(!_selectedIndexPath){
                    [self setSelectedIndexPath:indexPath];
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                }else{
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
        }
    }
}

#pragma mark cell下拉
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    _isOpen = firstDoInsert;
    NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell changeArrowWithDown:firstDoInsert];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_GoodsInfo_BaseData] withRowAnimation:UITableViewRowAnimationFade];
    if(_isOpen){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:T_GoodsInfo_BaseData] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark delegate
-(void)payAttentionToSomeGoods:(WXUIButton *)btn{
    DownSheet *sheet = [[DownSheet alloc] initWithlist:menuList height:0];
    sheet.delegate = self;
    [sheet showInView:nil];
}

-(void)didSelectIndex:(NSInteger)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if(index == Share_Friends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:@"测试" description:[UtilTool sharedString] linkURL:[UtilTool sharedURL] thumbImage:image];
    }
    if(index == Share_Clrcle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:@"测试" description:[UtilTool sharedString] linkURL:[UtilTool sharedURL] thumbImage:image];
    }
    if(index == Share_Qq){
        NSString *url = @"www.67call.com";
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:@"我信" description:@"生活是一种态度" previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Qzone){
        NSString *url = @"www.67call.com";
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:@"我信" description:@"生活是一种态度" previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
    if(index == Share_Invalid){
        NSLog(@"取消");
    }
}

-(void)goodsInfoModelLoadedSucceed{
    [self unShowWaitView];
    [_tableView reloadData];
    rightView.dataArr = _model.data;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_GoodsInfo_LoadSucceed object:nil];
    [_model setDelegate:nil];
}

-(void)goodsInfoModelLoadedFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

-(void)gotoWebView{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    WXTMallListWebVC *webViewVC = [[WXTMallListWebVC alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_goodsId], @"goods_id",[NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", nil];
    id ret = [webViewVC initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
    NSLog(@"ret = %@",ret);
    [self.wxNavigationController pushViewController:webViewVC];
}

#pragma mark downBtnClicked
-(void)cartBtnClicked:(id)sender{
    T_MenuVC *meunVC = [[T_MenuVC alloc] init];
    [self.wxNavigationController pushViewController:meunVC];
}

-(void)buyNowBtnClicked:(id)sender{
    if(_showUpview){
        _showUpview = NO;
    }else{
        _showUpview = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
//    [_shopModel setDelegate:nil];
    [rightView removeNotification];
}

#pragma mark 购物车
-(void)insertMyShoppingCart:(id)sender{
    if([_model.data count] > 0){
        if(!rightView.stockID || !rightView.stockName){
            [rightView showDropListUpView];
            [UtilTool showAlertView:@"请选择商品属性后再加入购物车"];
            return;
        }
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
        NSInteger length = AllImgPrefixUrlString.length;
        NSString *smallImgStr = [entity.smallImg substringFromIndex:length];
        
        [_shopModel loadGoodsInfoWithGoodsID:entity.goods_id withGoodsImg:smallImgStr withGoodsNum:(rightView.goodsNum>0?rightView.goodsNum:1) withGoodsName:entity.intro withGoodsPrice:entity.shop_price withStockName:rightView.stockName withStockID:rightView.stockID];
    }else{
        [UtilTool showAlertView:@"获取数据为空"];
    }
}

-(BOOL)localHasStoreThisGoods:(NSInteger)cartID{
    for(ShoppingCartEntity *entity in [SCartListModel shareShoppingCartModel].shoppingCartListArr){
        if(entity.goods_id == _goodsId){
            [UtilTool showAlertView:@"购物车已经存在该商品了"];
            return YES;
        }
    }
    return NO;
}

-(void)addGoodsToShoppingCartSucceed:(NSInteger)cartID{
    [self unShowWaitView];
    [UtilTool showAlertView:@"添加购物车成功"];
    GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
    NSString *cartIDStr = [NSString stringWithFormat:@"%ld",(long)cartID];
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)entity.goods_id];
    NSString *goodsPriceStr = [NSString stringWithFormat:@"%f",entity.shop_price];
    NSInteger length = AllImgPrefixUrlString.length;
    NSString *smallImgStr = [entity.smallImg substringFromIndex:length-1];
    NSString *stockIDStr = [NSString stringWithFormat:@"%ld",(long)rightView.stockID];
    NSString *goodsNumStr = [NSString stringWithFormat:@"%ld",(long)(rightView.goodsNum>0?rightView.goodsNum:1)];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         cartIDStr, @"cart_id",
                         goodsIDStr, @"goods_id",
                         entity.intro, @"goods_name",
                         smallImgStr, @"goods_img",
                         goodsPriceStr, @"goods_price",
                         goodsNumStr, @"goods_number",
                         stockIDStr, @"goods_stock_id",
                         rightView.stockName, @"goods_stock_name",
                         nil];
    [[SCartListModel shareShoppingCartModel] insertOneGoodsInShoppingCartList:dic];
    [[SCartListModel shareShoppingCartModel] toInit];
}

-(void)addGoodsToShoppingCartFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

-(void)toMakeOrder{
    if(rightView.stockID<=0){
        [UtilTool showAlertView:@"请先选择套餐"];
        return;
    }
    NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = [self priceForStock:rightView.stockID];
    if(entity.stockNumber==0){
        [UtilTool showAlertView:@"该套餐已售完"];
        return;
    }
    entity.buyNumber = (rightView.goodsNum<=0?1:rightView.goodsNum);
    [goodsArr addObject:entity];
    [[CoordinateController sharedCoordinateController] toMakeOrderVC:self orderInfo:goodsArr animated:YES];
}

-(GoodsInfoEntity*)priceForStock:(NSInteger)stockID{
    GoodsInfoEntity *ent = nil;
    for(GoodsInfoEntity *entity in _model.data){
        if(entity.stockID == stockID){
            ent = entity;
        }
    }
    return ent;
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

@end
