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

#define DownViewHeight (46)
#define RightViewXGap (50)

@interface NewGoodsInfoVC()<UITableViewDataSource,UITableViewDelegate,PayAttentionToGoodsDelegate,NewGoodsInfoModelDelegate>{
    UITableView *_tableView;
    NewGoodsInfoRightView *rightView;
    BOOL _isOpen;
    BOOL _showUpview;
    
    NewGoodsInfoModel *_model;
    
    WXUIButton *buyNowBtn;
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
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _model.goodID = _goodsId;
    [_model loadGoodsInfo];
    
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
                    return 10;
                }
            }else{
                return 1;
            }
        }
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
    for(int i = 0; i< 2; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, T_GoodsInfoTopImgHeight)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:@"http://gz.67call.com/wx/Public/Uploads/20140925/20140925170535_4240443.jpeg"];
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
    [cell setCellInfo:nil];
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
    [cell setCellInfo:_model.baseDic];
    NSString *key = [[_model.baseDic allKeys] objectAtIndex:row-1];
    [cell setTextLabelWithKey:key];
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
-(void)payAttentionToSomeGoods:(id)entity{
}

-(void)goodsInfoModelLoadedSucceed{
    [_tableView reloadData];
    [_model setDelegate:nil];
}

-(void)goodsInfoModelLoadedFailed:(NSString *)errorMsg{
    
}

#pragma mark downBtnClicked
-(void)cartBtnClicked:(id)sender{
    T_MenuVC *meunVC = [[T_MenuVC alloc] init];
    [self.wxNavigationController pushViewController:meunVC];
}

-(void)buyNowBtnClicked:(id)sender{
    if(_showUpview){
        _showUpview = NO;
        [rightView showDropListUpView];
    }else{
        _showUpview = YES;
    }
}

-(void)insertMyShoppingCart:(id)sender{
    T_InsertData *insert = [[T_InsertData alloc] init];
    NSString *goodsNum = [NSString stringWithFormat:@"%ld",(long)2];
    NSString *goodsID = [NSString stringWithFormat:@"%ld",(long)10020];
    BOOL succeed = [insert insertData:goodsNum withGoodsID:goodsID withColorType:@"颜色分类:银色男款"];
    if(succeed){
        [UtilTool showAlertView:@"添加购物车成功"];
    }else{
        [UtilTool showAlertView:@"添加购物车失败"];
    }
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
}

@end
