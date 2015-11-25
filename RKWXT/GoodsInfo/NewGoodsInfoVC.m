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
#import <TencentOpenAPI/QQApiInterface.h>
#import "NewGoodsInfoTopImgView.h"

#import "NewImageZoomView.h"
#import "GoodsInfoImageZoomView.h"
#import "CDSideBarController.h"
#import "NewGoodsInfoWebViewViewController.h"

//底部
#import "GoodsInfoPacketCell.h"
#import "GoodsInfoDownView.h"

//限时购
#import "TimeShopData.h"
//收藏
#import "GoodsAttentionModel.h"

#define DownViewHeight (46)
#define RightViewXGap (50)
#define TopNavigationViewHeight (64)

@interface NewGoodsInfoVC()<UITableViewDataSource,UITableViewDelegate,NewGoodsInfoModelDelegate,AddGoodsToShoppingCartDelegate,MerchantImageCellDelegate,CDSideBarControllerDelegate,NewGoodsInfoDesCellDelegate>{
    UITableView *_tableView;
    NewGoodsInfoRightView *rightView;
    WXUIImageView *topImgView;
    BOOL _isOpen;
    BOOL _showUpview;
    BOOL _isBuy; // 是否为购买状态
    BOOL _isLucky;//是否为抽奖
    
    NewGoodsInfoModel *_model;
    ShoppingCartModel *_shopModel;
    
    WXUIButton *buyNowBtn;
    WXUIButton *insertCartBtn;
    WXUIButton *backBtn;
    
    NSArray *menuList;
    CDSideBarController *sideBar;
    
    //限时购
    TimeShopData *limitEntity;
    //收藏
    GoodsAttentionModel *attentionModel;
    BOOL isAttention;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation NewGoodsInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addNotification];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[NewGoodsInfoModel alloc] init];
        [_model setDelegate:self];
        _isOpen = NO;
        _shopModel = [[ShoppingCartModel alloc] init];
        [_shopModel setDelegate:self];
        
        attentionModel = [[GoodsAttentionModel alloc] init];
        isAttention = NO;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _model.goodID = _goodsId;
    if(_goodsInfo_type == GoodsInfo_LimitGoods){
        limitEntity  = _lEntity;
        [_model loadGoodsInfo:[limitEntity.goods_id integerValue] withLimitGoodsID:[limitEntity.scare_buying_id integerValue]];
        _model.goodID = [limitEntity.goods_id integerValue];
        _goodsId = [limitEntity.goods_id integerValue];
    }else{
        [_model loadGoodsInfo:_model.goodID];
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [self initWebView];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.scrollView addSubview:_tableView];
    if(isIOS7){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 2, 0, 2)];
        [_tableView setSeparatorColor:WXColorWithInteger(0xEBEBEB)];
    }
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if(_goodsInfo_type == GoodsInfo_Normal){
        [self.view addSubview:[self downViewShow]];
    }
    if(_goodsInfo_type == GoodsInfo_LuckyGoods){
        _isLucky = YES;
        _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    }
    if(_goodsInfo_type == GoodsInfo_LimitGoods){
        [self.view addSubview:[self createLimitBuyDownView]];
    }
    
    [self crateTopNavigationView];
    
    //侧拉
    _showUpview = YES;
    rightView = [self createRightViewWith:buyNowBtn];
    [rightView unshow:NO];
    [self.view addSubview:rightView];
    
    [self initDropList];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.bounds.size.width-35, TopNavigationViewHeight-35)];
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

-(void)addNotification{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(toMakeOrder) name:K_Notification_GoodsInfo_CommitGoods object:nil];
    [defaultCenter addObserver:self selector:@selector(searchGoodsAttentionSucceed:) name:K_Notification_Name_SearchGoodsAttentionSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(goodsPayAttentionSucceed:) name:K_Notification_Name_GoodsPayAttentionSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(goodsPayAttentionFailed:) name:K_Notification_Name_GoodsPayAttentionFailed object:nil];
    [defaultCenter addObserver:self selector:@selector(goodsCancelAttentionSucceed:) name:K_Notification_Name_GoodsCancelAttentionSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(goodsCancelAttentionFailed:) name:K_Notification_Name_GoodsCancelAttentionFailed object:nil];
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

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, self.bounds.size.width, TopNavigationViewHeight);
    [topView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:topView];
    
    CGFloat xGap = 10;
    CGFloat yGap = 10;
    topImgView = [[WXUIImageView alloc] init];
    topImgView.frame = topView.frame;
    [topImgView setBackgroundColor:[UIColor whiteColor]];
    [topImgView setAlpha:0.1];
    [topView addSubview:topImgView];
    
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
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
//    [topView addSubview:titleLabel];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat number = contentOffset.y/self.bounds.size.width;
    number = (number>=1.0?1.0:number);
    number = (number<0.1?0.1:number);
    [topImgView setAlpha:1.6*number];
    if(number >= 0.5){
        [UIView animateWithDuration:0.6 animations:^{
            [backBtn setImage:[UIImage imageNamed:@"GoodsInfoGaryBackImg.png"] forState:UIControlStateNormal];
        }];
    }else{
        [UIView animateWithDuration:0.6 animations:^{
            [backBtn setImage:[UIImage imageNamed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
        }];
    }
}

-(WXUIView*)createLimitBuyDownView{
    WXUIView *footView = [[WXUIView alloc] init];
    
    CGFloat btnHeight = DownViewHeight;
    buyNowBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyNowBtn.frame = CGRectMake(0, 0, self.bounds.size.width, btnHeight);
    [buyNowBtn setBackgroundColor:WXColorWithInteger(0xff9c00)];
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowBtn addTarget:self action:@selector(buyNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:buyNowBtn];
    if([limitEntity.scare_buying_number integerValue] == 0 || [limitEntity.end_time integerValue] < [UtilTool timeChange]){
        [buyNowBtn setEnabled:NO];
        [buyNowBtn setBackgroundColor:[UIColor grayColor]];
        [buyNowBtn setTitle:@"抢购结束" forState:UIControlStateNormal];
    }
    
    CGRect rect = CGRectMake(0, self.view.bounds.size.height-DownViewHeight, self.bounds.size.width, DownViewHeight);
    [footView setFrame:rect];
    return footView;
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
    insertCartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    insertCartBtn.frame = CGRectMake(xOffset, 0, cartWidth, btnHeight);
    [insertCartBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [insertCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [insertCartBtn addTarget:self action:@selector(insertMyShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:insertCartBtn];
    
    CGRect rect = CGRectMake(0, self.view.bounds.size.height-DownViewHeight, self.bounds.size.width, DownViewHeight);
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
        case T_GoodsInfo_DownView:
        {
            if([_model.data count] > 0){
                GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
                if(entity.use_cut || entity.use_red){
                    return 1;
                }else{
                    return 0;
                }
            }
        }
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
            height = [NewGoodsInfoDesCell cellHeightOfInfo:([_model.data count] > 0?[_model.data objectAtIndex:0]:nil)];
            if(_lEntity){
                if([limitEntity.scare_buying_number integerValue] != 0 && [limitEntity.end_time integerValue] > [UtilTool timeChange]){
                    height += 40;
                }
            }
            break;
        case T_GoodsInfo_DownView:
        {
            if([_model.data count] > 0){
                GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
                if(entity.use_cut || entity.use_red){
                    return GoodsInfoPacketCellHeight;
                }else{
                    return 0;
                }
            }
        }
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
    if(section == T_GoodsInfo_DownView){
        if([_model.data count] > 0){
            GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
            if(entity.use_cut || entity.use_red){
                return 10.0;
            }else{
                return 0;
            }
        }
    }
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
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
//    NewGoodsInfoTopImgView *topImgView1 = [[NewGoodsInfoTopImgView alloc] init];
    GoodsInfoEntity *entity = nil;
    if([_model.data count] > 0){
        entity = [_model.data objectAtIndex:0];
    }
//    [topImgView1 showTopImgViewWithRootView:self.view withTopImgArr:entity.imgArr];
    
    NewImageZoomView *img = [[NewImageZoomView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];
    [img updateImageDate:entity.imgArr selectIndex:index];
}

//商品描述
-(WXUITableViewCell*)tableViewForGoodsInfoDescCell{
    static NSString *identifier = @"descCell";
    NewGoodsInfoDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.data count] > 0){
        [cell setCellInfo:[_model.data objectAtIndex:0]];
    }
    if([limitEntity.scare_buying_number integerValue] != 0 && [limitEntity.end_time integerValue] > [UtilTool timeChange]){
        [cell setLEntity:limitEntity];
    }
    if(!_isLucky){
        [cell setIsAttention:isAttention];
        [cell setDelegate:self];
    }
    cell.isLucky = _isLucky;
    [cell load];
    return cell;
}

//红包和提成
-(WXUITableViewCell*)tableViewShowPacketAndCut{
    static NSString *identifier = @"userCutCell";
    GoodsInfoPacketCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsInfoPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsInfo.png"]];
    [cell.textLabel setText:@"图文详情"];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

//产品参数
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
    [cell.textLabel setText:@"产品参数"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(13.0)];
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
            [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
            [cell.textLabel setText:@"产品参数"];
            [cell.textLabel setFont:WXFont(13.0)];
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
            case T_GoodsInfo_DownView:
                cell = [self tableViewShowPacketAndCut];
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
    if(section == T_GoodsInfo_DownView){
        [self goodsInfoPacketCellBtnClicked];
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
-(void)menuButtonClicked:(int)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if([_model.data count] > 0){
        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:entity.smallImg];
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
    if([_model.data count] > 0){
        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
        title = entity.intro;
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

-(void)goodsInfoModelLoadedSucceed{
    [self unShowWaitView];
    [_tableView reloadData];
    rightView.dataArr = _model.data;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_GoodsInfo_LoadSucceed object:nil];
    [_model setDelegate:nil];
    
    //查询是否已收藏
    [attentionModel searchGoodsPayAttention:_goodsId];
}

-(void)refreshLessTime{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_GoodsInfo_Description] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark showDownView
-(void)goodsInfoPacketCellBtnClicked{
    CGFloat height = 0;
    GoodsInfoEntity *ent = [_model.data objectAtIndex:0];
    if(ent.use_red && ent.use_cut){
        height = 283;
    }else{
        height = 180;
    }
    GoodsInfoDownView *downView = [[GoodsInfoDownView alloc] init];
    [downView setDataArr:_model.data];
    [downView showDownView:height toDestview:self.view];
}

#pragma mark downBtnClicked
-(void)cartBtnClicked:(id)sender{
    T_MenuVC *meunVC = [[T_MenuVC alloc] init];
    [self.wxNavigationController pushViewController:meunVC];
}

-(void)buyNowBtnClicked:(id)sender{
    _isBuy = YES;
    if(_showUpview){
        _showUpview = NO;
    }else{
        _showUpview = YES;
    }
}

#pragma mark 购物车
-(void)insertMyShoppingCart:(id)sender{
    _isBuy = NO;
    if([_model.data count] > 0){
        if(!rightView.stockID || !rightView.stockName){
            [rightView showDropListUpView];
//            [UtilTool showAlertView:@"请选择商品属性后再加入购物车"];
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
    [insertCartBtn setTitle:@"已加入购物车" forState:UIControlStateNormal];
    [insertCartBtn setBackgroundColor:[UIColor grayColor]];
    [insertCartBtn setEnabled:NO];
    
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
    if(!_isBuy){
        if([_model.data count] > 0){
            if(!rightView.stockID || !rightView.stockName){
                [UtilTool showAlertView:@"请选择商品属性后再加入购物车"];
                return;
            }
        }
        [self insertMyShoppingCart:nil];
        return;
    }
    
    if(rightView.stockID<=0){
        [UtilTool showAlertView:@"请先选择属性"];
        return;
    }
    NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = [self priceForStock:rightView.stockID];
    if(entity.stockNumber==0){
        [UtilTool showAlertView:@"该属性已售完"];
        return;
    }
    if(entity.stockNumber < rightView.goodsNum){
        [UtilTool showAlertView:[NSString stringWithFormat:@"该属性库存不足%d件",rightView.goodsNum]];
        return;
    }
    if(limitEntity){
        if([limitEntity.scare_buying_number integerValue] < rightView.goodsNum){
            [UtilTool showAlertView:[NSString stringWithFormat:@"库存已不足%d件",rightView.goodsNum]];
            return;
        }
        if(rightView.goodsNum > [limitEntity.user_scare_buying_number integerValue] && [limitEntity.user_scare_buying_number integerValue] != 0){
            [UtilTool showAlertView:[NSString stringWithFormat:@"每人限购%ld件",(long)[limitEntity.user_scare_buying_number integerValue]]];
            return;
        }
    }
    entity.buyNumber = (rightView.goodsNum<=0?1:rightView.goodsNum);
    [goodsArr addObject:entity];
    if(_lEntity){
        MakeOrderVC *orderVC = [[MakeOrderVC alloc] init];
        orderVC.goodsList = goodsArr;
        orderVC.lEntity = _lEntity;
        [self.wxNavigationController pushViewController:orderVC];
    }else{
        [[CoordinateController sharedCoordinateController] toMakeOrderVC:self orderInfo:goodsArr animated:YES];
    }
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

#pragma mark attention
-(void)goodsInfoPayAttentionBtnClicked:(id)entity{
    if(!isAttention){
        [attentionModel goodsPayAttention:_goodsId and:rightView.stockID andLimitID:[limitEntity.scare_buying_id integerValue]];
    }else{
        [attentionModel cancelGoodsAttention:_goodsId];
    }
}

//查看商品是否收藏
-(void)searchGoodsAttentionSucceed:(NSNotification*)notification{
    isAttention = YES;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_GoodsInfo_Description] withRowAnimation:UITableViewRowAnimationFade];
}

//添加收藏
-(void)goodsPayAttentionSucceed:(NSNotification*)notification{
    isAttention = YES;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_GoodsInfo_Description] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)goodsPayAttentionFailed:(NSNotification*)notification{
}

//取消收藏
-(void)goodsCancelAttentionSucceed:(NSNotification*)notification{
    isAttention = NO;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_GoodsInfo_Description] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)goodsCancelAttentionFailed:(NSNotification*)notification{
    
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
    //    [_shopModel setDelegate:nil];
    [rightView removeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
