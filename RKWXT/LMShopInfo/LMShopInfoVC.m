//
//  LMShopInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoVC.h"
#import "LMShopInfoDef.h"

@interface LMShopInfoVC()<UITableViewDataSource,UITableViewDelegate,CDSideBarControllerDelegate>{
    UITableView *_tableView;
    CDSideBarController *sideBar;
    
    NSArray *evaluateArr;
}
@end

@implementation LMShopInfoVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.bounds.size.width-35, 66-35)];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"店铺详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    
    //初始化分享
    [self initDropList];
}

-(void)initDropList{
    NSArray *imageList = @[[UIImage imageNamed:@"ShareQqImg.png"], [UIImage imageNamed:@"ShareQzoneImg.png"], [UIImage imageNamed:@"ShareWxFriendImg.png"], [UIImage imageNamed:@"ShareWxCircleImg.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return LMShopInfo_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case LMShopInfo_Section_TopImg:
        case LMShopInfo_Section_BaseFunction:
        case LMShopInfo_Section_Activity:
            row = 1;
            break;
        case LMShopInfo_Section_HotGoods:
            row = 2;
            break;
        case LMShopInfo_Section_AllGoods:
            row = 2;
            break;
        case LMShopInfo_Section_Evaluate:
            row = [evaluateArr count]+2;
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
            height = LMShopInfoActivityHeight;
            break;
        case LMShopInfo_Section_HotGoods:
        {
            if(indexPath.row == 0){
                height = LMShopInfoSectionTitleHeight;
            }else{
                height = LMShopInfoHotGoodsHeight;
            }
        }
            break;
        case LMShopInfo_Section_AllGoods:
        {
            if(indexPath.row == 0){
                height = LMShopInfoSectionTitleHeight;
            }else{
                height = LMShopInfoHotGoodsHeight;
            }
        }
            break;
        case LMShopInfo_Section_Evaluate:
        {
            if(indexPath.row == 0 || indexPath.row == [evaluateArr count]-1){
                height = LMShopInfoSectionTitleHeight;
            }else{
                height = [ShopInfoEvaluateCell cellHeightOfInfo:nil];
            }
        }
            break;
        default:
            break;
    }
    return height;
}

//顶部大图
-(WXUITableViewCell*)shopInfoTopImgView{
    static NSString *identifier = @"topImgCell";
    LMShopInfoTopImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoTopImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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

//热销商品
-(WXUITableViewCell*)shopInfoHotGoodsTitleCell{
    static NSString *identifier = @"hotGoodsTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"热销商品";
    [cell.textLabel setFont:WXFont(15.0)];
    return cell;
}

-(WXUITableViewCell*)shopInfoHotGoodsListCell:(NSInteger)row{
    static NSString *identifier = @"hotGoodsCell";
    ShopInfoHotGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopInfoHotGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSMutableArray *rowArray = [NSMutableArray array];
//    NSInteger max = row*3;
//    NSInteger count = [ count];
//    if(max > count){
//        max = count;
//    }
//    for(NSInteger i = (row-1)*3; i < max; i++){
//        [rowArray addObject:[hotShopArr objectAtIndex:i]];
//    }
//    [cell setDelegate:self];
//    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//所有商品
-(WXUITableViewCell*)shopInfoAllGoodsTitleCell{
    static NSString *identifier = @"allGoodsTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"所有商品";
    [cell.textLabel setFont:WXFont(15.0)];
    return cell;
}

-(WXUITableViewCell*)shopInfoAllGoodsListCell:(NSInteger)row{
    static NSString *identifier = @"allGoodsCell";
    ShopInfAllGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopInfAllGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    NSMutableArray *rowArray = [NSMutableArray array];
    //    NSInteger max = row*3;
    //    NSInteger count = [ count];
    //    if(max > count){
    //        max = count;
    //    }
    //    for(NSInteger i = (row-1)*3; i < max; i++){
    //        [rowArray addObject:[hotShopArr objectAtIndex:i]];
    //    }
    //    [cell setDelegate:self];
    //    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

//评价
-(WXUITableViewCell*)shopInfoEvaluateTitleCell{
    static NSString *identifier = @"EvaluateTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"评价";
    [cell.textLabel setFont:WXFont(14.0)];
    return cell;
}

-(WXUITableViewCell*)shopInfoMoreEvaluateCell{
    static NSString *identifier = @"MoreEvaluateCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    cell.textLabel.text = @"查看更多评价";
    [cell.textLabel setFont:WXFont(14.0)];
    return cell;
}

-(WXUITableViewCell*)shopInfoEvaluateListCell{
    static NSString *identifier = @"evaluateListCell";
    ShopInfoEvaluateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopInfoEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

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
        {
            if(row == 0){
                cell = [self shopInfoHotGoodsTitleCell];
            }else{
                cell = [self shopInfoHotGoodsListCell:row];
            }
        }
            break;
        case LMShopInfo_Section_AllGoods:
        {
            if(row == 0){
                cell = [self shopInfoAllGoodsTitleCell];
            }else{
                cell = [self shopInfoAllGoodsListCell:row];
            }
        }
            break;
        case LMShopInfo_Section_Evaluate:
        {
            if(row == 0){
                cell = [self shopInfoEvaluateTitleCell];
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
}

#pragma mark 分享
-(void)menuButtonClicked:(int)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
//    if([_model.data count] > 0){
//        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
//        NSURL *url = [NSURL URLWithString:entity.smallImg];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        if(data){
//            image = [UIImage imageWithData:data];
//        }
//    }
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
//    if([_model.data count] > 0){
//        GoodsInfoEntity *entity = [_model.data objectAtIndex:0];
//        title = entity.intro;
//    }
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
//    NSString *urlString = [NSString stringWithFormat:@"%@wx_html/index.php/Shop/index?shop_id=%d&MerchantID=%d&go=good_detail&title=%@&goods_id=%ld&woxin_id=%@",WXTShareBaseUrl,kSubShopID,kMerchantID,strB,(long)_goodsId,userDefault.wxtID];
    return nil;
}

@end
