//
//  T_MenuVC.m
//  Woxin3.0
//
//  Created by SHB on 15/1/24.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_MenuVC.h"
#import "T_MeunDef.h"
#import "NewGoodsInfoModel.h"
#import "T_MenuEntity.h"
#import "T_MenuCommonInfoCell.h"
#import "T_Sqlite.h"
#import "GoodsInfoEntity.h"
//#import "GoodMenuModel.h"
//#import "OrderConfirmVC.h"
//#import "GoodMenuEntity.h"
//#import "WXGoodEntity.h"
//#import "WXUIGoodEntity.h"
//#import "T_GoodsInfoVC.h"

#define FootViewheight (40)

@interface T_MenuVC()<UITableViewDataSource,UITableViewDelegate,NewGoodsInfoModelDelegate,deleteStoreGoods>{
    WXUITableView *_tableView;
    T_Sqlite *_fmdb;
    NewGoodsInfoModel *_model;
    NSArray *_oldArr;
    NSInteger _goodsID;
    
    WXUIButton *_circleBtn;
    WXUILabel *_sumPrice;
    WXUIButton *_sumBtn;
    
    CGFloat _allPrice;       //所有结算商品总价
    NSInteger _allNumber;    //所有结算商品数量
    BOOL _selectAll;         //是否全选所有商品结算
}
@property (nonatomic,retain) NSMutableArray *arr;
@end

@implementation T_MenuVC

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_arr);
    RELEASE_SAFELY(_model);
    [_model setDelegate:nil];
    RELEASE_SAFELY(_sumPrice);
    _goodsID = 0;
    _allPrice = 0;
    _allNumber = 0;
    _selectAll = NO;
    [super dealloc];
}

-(id)init{
    if(self = [super init]){
        _model = [[NewGoodsInfoModel alloc] init];
        [_model setDelegate:self];
        _arr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的购物车"];
    
    CGSize size = self.bounds.size;
    _tableView = [[WXUITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height-FootViewheight);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    if(isIOS7){
        [_tableView setSeparatorInset:(UIEdgeInsetsMake(0, xGap, 0, 0))];
        [_tableView setSeparatorColor:WXColorWithInteger(T_MenuCellLineColor)];
    }
    [self addSubview:_tableView];
    [self addSubview:[self tableViewForFootView]];
    
    _fmdb = [[T_Sqlite alloc] init];
    [_fmdb createOrOpendb];
    [_fmdb createTable];
    _oldArr = [_fmdb selectAll];

//    if([_oldArr count] > 0){
//        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock tip:@""];
//    }
    
    for(int i = 0;i < [_oldArr count]; i++){
        T_MenuEntity *entity = [_oldArr objectAtIndex:i];
        [_model setGoodID:[entity.goodsID integerValue]];
        [_model loadGoodsInfo];
    }
}

-(WXUIView*)tableViewForFootView{
//    if([_arr count] == 0){
//        return nil;
//    }
    CGSize size = self.bounds.size;
    _tableView.frame = CGRectMake(0, 0, size.width, size.height-FootViewheight);
    
    WXUIView *footView = [[[WXUIView alloc] init] autorelease];
    [footView setBackgroundColor:WXColorWithInteger(0xEEEEEE)];
    CGFloat xOffset = 15;
    CGFloat footHeight = FootViewheight;
    UIImage *circleImg = [UIImage imageNamed:@"ShoppingCartCircle.png"];
    _circleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    _circleBtn.frame = CGRectMake(xOffset, (footHeight-circleImg.size.height)/2, circleImg.size.width, circleImg.size.height);
    [_circleBtn setBackgroundColor:[UIColor clearColor]];
    [_circleBtn setImage:circleImg forState:UIControlStateNormal];
    [_circleBtn addTarget:self action:@selector(selectAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_circleBtn];
    
    xOffset += circleImg.size.width+2;
    CGFloat labelHeight = 17;
    WXUILabel *selLabel = [[WXUILabel alloc] init];
    selLabel.frame = CGRectMake(xOffset, (footHeight-labelHeight)/2, 50, labelHeight);
    [selLabel setBackgroundColor:[UIColor clearColor]];
    [selLabel setText:@"全选"];
    [selLabel setTextAlignment:NSTextAlignmentLeft];
    [selLabel setTextColor:WXColorWithInteger(0x323232)];
    [selLabel setFont:[UIFont systemFontOfSize:12.0]];
    [footView addSubview:selLabel];
    RELEASE_SAFELY(selLabel);
    
    CGFloat yOffset = 6;
    xOffset = 130;
    CGFloat sumWidth = 40;
    CGFloat sumHeight = 16;
    WXUILabel *sumLabel = [[WXUILabel alloc] init];
    sumLabel.frame = CGRectMake(xOffset, yOffset, sumWidth, sumHeight);
    [sumLabel setBackgroundColor:[UIColor clearColor]];
    [sumLabel setTextAlignment:NSTextAlignmentRight];
    [sumLabel setText:@"合计:"];
    [sumLabel setFont:[UIFont systemFontOfSize:10.0]];
    [sumLabel setTextColor:WXColorWithInteger(0xff9c00)];
    [footView addSubview:sumLabel];
    RELEASE_SAFELY(sumLabel);
    
    
    xOffset += sumWidth;
    _sumPrice = [[WXUILabel alloc] init];
    _sumPrice.frame = CGRectMake(xOffset, yOffset-1, 70, sumHeight);
    [_sumPrice setBackgroundColor:[UIColor clearColor]];
    [_sumPrice setTextAlignment:NSTextAlignmentLeft];
    [_sumPrice setText:@"￥0.00"];
    [_sumPrice setFont:[UIFont systemFontOfSize:12.0]];
    [_sumPrice setTextColor:WXColorWithInteger(0xff9c00)];
    [footView addSubview:_sumPrice];
    
    yOffset += sumHeight;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset-5, yOffset, 80, sumHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"不含运费"];
    [textLabel setFont:[UIFont systemFontOfSize:10.0]];
    [textLabel setTextColor:WXColorWithInteger(0x646464)];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [footView addSubview:textLabel];
    RELEASE_SAFELY(textLabel);
    
    xOffset += 66;
    CGFloat btnWidth = 73;
    CGFloat btnHeight = 35;
    _sumBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    _sumBtn.frame = CGRectMake(xOffset, (footHeight-btnHeight)/2, btnWidth, btnHeight);
    [_sumBtn setBorderRadian:3.0 width:0.5 color:WXColorWithInteger(0xff9c00)];
    [_sumBtn setBackgroundImageOfColor:WXColorWithInteger(0xff9c00) controlState:UIControlStateNormal];;
    [_sumBtn setBackgroundImageOfColor:WXColorWithInteger(0xdd8802) controlState:UIControlStateSelected];
    [_sumBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [_sumBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_sumBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
    [_sumBtn addTarget:self action:@selector(settleAccountAllGoods) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_sumBtn];
    
    footView.frame = CGRectMake(0, size.height-FootViewheight, IPHONE_SCREEN_WIDTH, FootViewheight);
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return T_MenuCommonCellHeight;
}

-(WXUITableViewCell*)tableViewForCommonInfoCellAtSection:(NSInteger)row{
    static NSString *identifier = @"commonInfoCell";
    T_MenuCommonInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[T_MenuCommonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
    [cell setGoodsInfo:[_oldArr objectAtIndex:row]];
    [cell setCellInfo:[_arr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForCommonInfoCellAtSection:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger row = indexPath.row;
//    T_GoodInfoEntity *entity = [_arr objectAtIndex:row];
//    T_GoodsInfoVC *goodsInfoVC = [[[T_GoodsInfoVC alloc] init] autorelease];
//    goodsInfoVC.goodsID = entity.goods_id;
//    [self.wxNavigationController pushViewController:goodsInfoVC];
}
//
-(void)goodsInfoModelLoadedSucceed{
    [self unShowWaitView];
    _model.entity.buyNumber = 1;
    _model.entity.selested = NO;
    _model.entity.shop_price = 1888;
    _model.entity.market_price = 3000;
    [_arr addObject:_model.entity];
    if([_arr count] == [_oldArr count]){
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [_model setDelegate:nil];
    }
}

-(void)goodsInfoModelLoadedFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
    [_model setDelegate:nil];
}

-(void)deleteGoods:(NSInteger)goodsID{
    _goodsID = goodsID;
    WXUIAlertView *alertView = [[WXUIAlertView alloc] initWithTitle:@"" message:@"确定要删除这个宝贝吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        return;
    }
    BOOL isDel = NO;
    for(T_MenuEntity *entity in _oldArr){
        if([entity.goodsID integerValue] == _goodsID){
            isDel = [_fmdb deleteTestList:entity];
            break;
        }
    }
    if(isDel){
        for(int i = 0;i < [_arr count]; i++){
            GoodsInfoEntity *ent = [_arr objectAtIndex:i];
            if(ent.goods_id == _goodsID){
                [_arr removeObject:ent];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
    }
    [self setSumPricelabel];
}

//选
-(void)selectGoods{
    [self setSumPricelabel];
}

//取消
-(void)cancelGoods{
    [self setSumPricelabel];
}

//增加
-(void)plusBtnClicked{
    [self setSumPricelabel];
}

//减少
-(void)minusBtnClicked{
    [self setSumPricelabel];
}

//底部总价和商品个数的显示
-(void)setSumPricelabel{
    _allPrice = 0.0;
    _allNumber = 0;
    for(GoodsInfoEntity *entity in _arr){
        if(entity.selested){
            _allPrice += entity.buyNumber*entity.shop_price;
            _allNumber += entity.buyNumber;
        }
    }
    [_sumPrice setText:[NSString stringWithFormat:@"￥%.2f",_allPrice]];
    NSString *number = [NSString stringWithFormat:@"结算(%ld)",(long)_allNumber];
    [_sumBtn setTitle:number forState:UIControlStateNormal];
}

//全选
-(void)selectAllBtnClicked{
    if(_selectAll){
        _selectAll = NO;
        [_circleBtn setImage:[UIImage imageNamed:@"ShoppingCartCircle.png"] forState:UIControlStateNormal];
    }else{
        _selectAll = YES;
        [_circleBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }
    for(GoodsInfoEntity *entity in _arr){
        entity.selested = _selectAll;
    }
    T_MenuCommonInfoCell *cell = [[[T_MenuCommonInfoCell alloc] init] autorelease];
    [cell selectAllGoods:!_selectAll];
    [_tableView reloadData];
    [self setSumPricelabel];
}

//结算
-(void)settleAccountAllGoods{
//    [_menuArr removeAllObjects];
//    for(T_GoodInfoEntity *entity in _arr){
//        if(entity.selested){
//            WXUIGoodEntity *ent = [WXUIGoodEntity menuEntityWithT_GoodInfoEntity:entity];
//            [_menuArr addObject:ent];
//        }
//    }
//    [[CoordinateController sharedCoordinateController] toOrderConfirm:self delegate:self source:E_OrderMenuSource_None goodList:_menuArr goodExtra:[[self class] menuExtra]];
}
//
//+(MenuExtra*)menuExtra{
//    MenuExtra *extra = [[[MenuExtra alloc] init] autorelease];
//    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
//    extra.UID = -1;
//    extra.subShopID = userObj.subShopID;
//    extra.subShopName = userObj.subShopName;
//    extra.time = [[NSDate date] timeIntervalSince1970];
//    extra.menuType = E_MenuType_FaceToFace;
//    return extra;
//}

@end

