//
//  LMGoodsInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsInfoVC.h"
#import "LMGoodsInfoDef.h"

@interface LMGoodsInfoVC ()<UITableViewDataSource,UITableViewDelegate,MerchantImageCellDelegate>{
    UITableView *_tableView;
}

@end

@implementation LMGoodsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"商品详情"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
    
    [self addSubview:[self baseDownView]];
}

-(WXUIView*)baseDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    CGFloat btnWidth = IPHONE_SCREEN_WIDTH/3/2;
    CGFloat btnHeight = 28;
    
    CGFloat xOffset = 0;
    WXUIButton *sellerBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    sellerBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [sellerBtn setBackgroundColor:[UIColor clearColor]];
    [sellerBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [sellerBtn addTarget:sellerBtn action:@selector(sellerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sellerBtn];
    
    xOffset += btnWidth;
    WXUIButton *cartBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [cartBtn setBackgroundColor:[UIColor clearColor]];
    [cartBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cartBtn addTarget:sellerBtn action:@selector(cartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:cartBtn];
    
    xOffset += btnWidth;
    WXUIButton *buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(xOffset, (DownViewHeight-btnHeight)/2, (IPHONE_SCREEN_WIDTH-xOffset)/2, btnHeight);
    [buyBtn setBackgroundColor:[UIColor clearColor]];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [buyBtn addTarget:sellerBtn action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:buyBtn];
    
    WXUIButton *addBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset)/2, (DownViewHeight-btnHeight)/2, (IPHONE_SCREEN_WIDTH-xOffset)/2, btnHeight);
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [addBtn addTarget:sellerBtn action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:addBtn];
    
    return downView;
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
            
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10.0;
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
            title = @"推荐商家";
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
    
    CGFloat labelWidth = 112;
    CGFloat labelHeight = 18;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-labelWidth)/2, (height-labelHeight)/2, labelWidth, labelHeight);
    [textLabel setText:title];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(11.0)];
    [titleView addSubview:textLabel];
    
    titleView.frame = CGRectMake(0, 0, Size.width, height);
    return titleView;
}

//顶部大图
-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    MerchantImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MerchantImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
//    GoodsInfoEntity *entity = nil;
//    if([_model.data count] > 0){
//        entity = [_model.data objectAtIndex:0];
//    }
//    for(int i = 0; i< [entity.imgArr count]; i++){
//        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, T_GoodsInfoTopImgHeight)];
//        [imgView setExclusiveTouch:NO];
//        [imgView setCpxViewInfo:[entity.imgArr objectAtIndex:i]];
//        [merchantImgViewArray addObject:imgView];
//    }
    cell = [[MerchantImageCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
//    GoodsInfoEntity *entity = nil;
//    if([_model.data count] > 0){
//        entity = [_model.data objectAtIndex:0];
//    }
//    
//    NewImageZoomView *img = [[NewImageZoomView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height )imgViewSize:CGSizeZero];
//    [self.view addSubview:img];
//    [img updateImageDate:entity.imgArr selectIndex:index];
}

//商品介绍
-(WXUITableViewCell*)goodsDesCell{
    static NSString *identifier = @"desCell";
    LMGoodsDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

//商品详情
-(WXUITableViewCell*)goodsInfoCell{
    static NSString *identifier = @"infoCell";
    LMGoodsInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark downView
-(void)sellerBtnClick{
    
}

-(void)cartBtnClick{
    
}

-(void)buyBtnClick{
    
}

-(void)addBtnClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
