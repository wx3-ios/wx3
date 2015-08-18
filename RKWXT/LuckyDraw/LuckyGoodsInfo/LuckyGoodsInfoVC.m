//
//  LuckyGoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/8/14.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsInfoVC.h"
#import "LuckyGoodsInfoTopImgCell.h"
#import "LuckyGoodsDesCell.h"
#import "NewGoodsInfoBDCell.h"
#import "NewGoodsInfoDownCell.h"
#import "WXTMallListWebVC.h"
#import "NewGoodsInfoModel.h"
#import "GoodsInfoEntity.h"
#import "WXRemotionImgBtn.h"
#import "GoodsInfoDef.h"
#import "LuckyGoodsMakeOrderVC.h"
#import "LuckySharkEntity.h"
#import "DownSheet.h"
#import "WXWeiXinOBJ.h"
#import <TencentOpenAPI/QQApiInterface.h>

#define size self.bounds.size
#define TopNavigationViewHeight (64)
#define DownViewHeight (50)

enum{
    LuckyGoodsInfo_Section_TopImg = 0,
    LuckyGoodsInfo_Section_TopInfo,
    LuckyGoodsInfo_Section_WebShow,
    LuckyGoodsInfo_Section_GoodsInfo,
    
    LuckyGoodsInfo_Section_Invalid,
};

@interface LuckyGoodsInfoVC ()<UITableViewDataSource,UITableViewDelegate,NewGoodsInfoModelDelegate,DownSheetDelegate>{
    UITableView *_tableView;
    BOOL _isOpen;
    
    WXUIImageView *topImgView;
    
    NewGoodsInfoModel *_model;
    
    LuckySharkEntity *luckyEntity;
    
    NSArray *menuList;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation LuckyGoodsInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self crateTopNavigationView];
    [self initDropList];
    
    luckyEntity = _luckyEnt;
    _model = [[NewGoodsInfoModel alloc] init];
    [_model setDelegate:self];
    [_model loadGoodsInfo:luckyEntity.goods_id];
    
    if(luckyEntity.goods_price > 0){
        [self createDownView];
    }
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

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, size.width, TopNavigationViewHeight);
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
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xGap, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 30;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((size.width-labelWidth)/2, TopNavigationViewHeight-yGap-labelHeight, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(15.0)];
    [titleLabel setText:@"商品详情"];
    [titleLabel setTextColor:WXColorWithInteger(0x000000)];
    [topView addSubview:titleLabel];

    WXUIButton *sharebtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame = CGRectMake(size.width-xGap-btnWidth, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [sharebtn setBackgroundColor:[UIColor clearColor]];
    [sharebtn setImage:[UIImage imageNamed:@"T_ShareGoods.png"] forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(sharebtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sharebtn];
}

-(void)createDownView{
    WXUIButton *leftbtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, size.height-DownViewHeight, size.width/2, DownViewHeight);
    [leftbtn setBackgroundColor:WXColorWithInteger(0x888888)];
    [leftbtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(cancelPayGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftbtn];
    
    WXUIButton *rightbtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(size.width/2, size.height-DownViewHeight, size.width/2, DownViewHeight);
    [rightbtn setBackgroundColor:WXColorWithInteger(0xdd27262)];
    [rightbtn setTitle:@"付邮费" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(payGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbtn];
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
    return LuckyGoodsInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case LuckyGoodsInfo_Section_TopImg:
        case LuckyGoodsInfo_Section_TopInfo:
        case LuckyGoodsInfo_Section_WebShow:
            row = 1;
            break;
        case LuckyGoodsInfo_Section_GoodsInfo:
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
        case LuckyGoodsInfo_Section_TopImg:
            height = size.width;
            break;
        case LuckyGoodsInfo_Section_TopInfo:
            height = LuckyGoodsDesCellHeight;
            break;
        case LuckyGoodsInfo_Section_WebShow:
            height = 44;
            break;
        case LuckyGoodsInfo_Section_GoodsInfo:
        {
            if(indexPath.row == 0){
                height = 44;
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

//顶部大图
-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    LuckyGoodsInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = nil;
    if([_model.data count] > 0){
        entity = [_model.data objectAtIndex:0];
    }
    for(int i = 0; i< [entity.imgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, size.width, T_GoodsInfoTopImgHeight)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[entity.imgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[LuckyGoodsInfoTopImgCell alloc] initWithLuckyReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForLuckyGoodsDesCell{
    static NSString *identifier = @"luckyGoodsCell";
    LuckyGoodsDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    if([_model.data count] > 0){
        [cell setCellInfo:[_model.data objectAtIndex:0]];
        [cell setNewprice:luckyEntity.goods_price];
        [cell setName:luckyEntity.stockName];
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
        [cell setName:[entity.customNameArr objectAtIndex:row-1]];
        [cell setInfo:[entity.customInfoArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isOpen && indexPath.section == LuckyGoodsInfo_Section_GoodsInfo){
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
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        switch (section) {
            case LuckyGoodsInfo_Section_TopImg:
                cell = [self tableViewForTopImgCell];
                break;
            case LuckyGoodsInfo_Section_TopInfo:
                cell = [self tableViewForLuckyGoodsDesCell];
                break;
            case LuckyGoodsInfo_Section_WebShow:
                cell = [self tableViewWebShowCell];
                break;
            case LuckyGoodsInfo_Section_GoodsInfo:
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
    if(section == LuckyGoodsInfo_Section_WebShow){
        [self gotoWebView];
    }
    if(section == LuckyGoodsInfo_Section_GoodsInfo){
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat number = contentOffset.y/size.width;
    number = (number>=1.0?1.0:number);
    number = (number<0.1?0.1:number);
    [topImgView setAlpha:1.4*number];
}

#pragma mark cell下拉
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    _isOpen = firstDoInsert;
    NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell changeArrowWithDown:firstDoInsert];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:LuckyGoodsInfo_Section_GoodsInfo] withRowAnimation:UITableViewRowAnimationFade];
    if(_isOpen){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:LuckyGoodsInfo_Section_GoodsInfo] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)gotoWebView{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    WXTMallListWebVC *webViewVC = [[WXTMallListWebVC alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:luckyEntity.goods_id], @"goods_id",[NSNumber numberWithInteger:kMerchantID], @"sid", userObj.user, @"phone", [UtilTool newStringWithAddSomeStr:5 withOldStr:userObj.pwd], @"pwd", nil];
    id ret = [webViewVC initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
    NSLog(@"ret = %@",ret);
    [self.wxNavigationController pushViewController:webViewVC];
}

//分享
-(void)sharebtnClicked{
    DownSheet *sheet = [[DownSheet alloc] initWithlist:menuList height:0];
    sheet.delegate = self;
    [sheet showInView:self];
}

-(void)didSelectIndex:(NSInteger)index{
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
    if(index == Share_Invalid){
        NSLog(@"取消");
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
    description = [NSString stringWithFormat:@"我在我信商城抽到一个奖品,免费的哦,赶快来看看吧。"];
    return description;
}

-(NSString*)sharedGoodsInfoUrlString{
    NSString *strB = [[self sharedGoodsInfoTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *urlString = [NSString stringWithFormat:@"%@wx_html/index.php/Shop/index?shop_id=%d&MerchantID=100000&go=good_detail&title=%@&goods_id=%ld&woxin_id=%@",WXTShareBaseUrl,kSubShopID,strB,(long)_luckyEnt.goods_id,userDefault.wxtID];
    return urlString;
}

#pragma mark model
-(void)goodsInfoModelLoadedSucceed{
    [self unShowWaitView];
    [_tableView reloadData];
    [_model setDelegate:nil];
}

-(void)goodsInfoModelLoadedFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark cacel
-(void)cancelPayGoods{
    [self back];
}

-(void)payGoods{
    NSMutableArray *goodsArr = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = [self priceForStock:luckyEntity.stock_id];
    entity.buyNumber = 1;
    [goodsArr addObject:entity];
    LuckyGoodsMakeOrderVC *vc = [[LuckyGoodsMakeOrderVC alloc] init];
    vc.goodsList = goodsArr;
    vc.payMoney = luckyEntity.goods_price;
    vc.lotty_id = luckyEntity.lottery_id;
    [self.wxNavigationController pushViewController:vc];
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

-(void)back{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
