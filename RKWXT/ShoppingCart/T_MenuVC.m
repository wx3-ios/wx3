//
//  T_MenuVC.m
//  Woxin3.0
//
//  Created by SHB on 15/1/24.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_MenuVC.h"
#import "T_MeunDef.h"
#import "T_MenuCommonInfoCell.h"
#import "SCartListModel.h"
#import "ShoppingCartEntity.h"
#import "GoodsInfoEntity.h"

#define FootViewheight (40)

@interface T_MenuVC()<UITableViewDataSource,UITableViewDelegate,deleteStoreGoods>{
    WXUITableView *_tableView;
    NSInteger _cartID;
    
    SCartListModel *_model;
    NSArray *_cartList;
    
    WXUIButton *_circleBtn;
    WXUILabel *_sumPrice;
    WXUIButton *_sumBtn;
    
    CGFloat _allPrice;       //所有结算商品总价
    NSInteger _allNumber;    //所有结算商品数量
    BOOL _selectAll;         //是否全选所有商品结算
}
@end

@implementation T_MenuVC

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_sumPrice);
    [self removeObs];
    _cartID = 0;
    _allPrice = 0;
    _allNumber = 0;
    _selectAll = NO;
    [super dealloc];
}

-(id)init{
    if(self = [super init]){
        _cartList = [[[NSArray alloc] init] autorelease];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
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
    
    [self addObs];
    [[SCartListModel shareShoppingCartModel] loadShoppingCartList];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@"努力加载中..."];
//    _cartList = [SCartListModel shareShoppingCartModel].shoppingCartListArr;
}

-(void)addObs{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartDataSucceed) name:D_Notification_LoadShoppingCartList_Succeed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCartDataFailed:) name:D_Notification_LoadShoppingCartList_Failed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneGoodsSucceed) name:D_Notification_DeleteOneGoodsInShoppingCartList_Succeed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneGoodsFailed:) name:D_Notification_DeleteOneGoodsInShoppingCartList_Failed object:nil];
}

-(void)removeObs{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(WXUIView*)tableViewForFootView{
//    if([_cartList count] == 0){
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
    return [_cartList count];
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
    [cell setCellInfo:[_cartList objectAtIndex:row]];
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
-(void)loadCartDataSucceed{
    [self unShowWaitView];
    _cartList = [SCartListModel shareShoppingCartModel].shoppingCartListArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadCartDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorStr = notification.object;
    if(!errorStr){
        errorStr = @"加载失败";
    }
    [UtilTool showAlertView:errorStr];
}

-(void)deleteGoods:(NSInteger)cart_id{
    _cartID = cart_id;
    WXUIAlertView *alertView = [[WXUIAlertView alloc] initWithTitle:@"" message:@"确定要删除这个宝贝吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        return;
    }
    for(ShoppingCartEntity *entity in _cartList){
        if(entity.cart_id == _cartID){
            [[SCartListModel shareShoppingCartModel] deleteOneGoodsInShoppingCartList:_cartID];
            [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
            break;
        }
    }
}

-(void)deleteOneGoodsSucceed{
    [self unShowWaitView];
//    for(int i = 0;i < [_cartList count]; i++){
//        ShoppingCartEntity *ent = [_cartList objectAtIndex:i];
//        if(ent.cart_id == _cartID){
//            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//        }
//    }
    [_tableView reloadData];
    [self setSumPricelabel];
}

-(void)deleteOneGoodsFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"删除操作失败";
    }
    [UtilTool showAlertView:errorMsg];
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
    for(ShoppingCartEntity *entity in _cartList){
        if(entity.selected){
            _allPrice += entity.goods_Number*entity.goods_price;
            _allNumber += entity.goods_Number;
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
    for(ShoppingCartEntity *entity in _cartList){
        entity.selected = _selectAll;
    }
    T_MenuCommonInfoCell *cell = [[[T_MenuCommonInfoCell alloc] init] autorelease];
    [cell selectAllGoods:!_selectAll];
    [_tableView reloadData];
    [self setSumPricelabel];
}

//结算
-(void)settleAccountAllGoods{
    NSMutableArray *goodsArr = [[[NSMutableArray alloc] init] autorelease];
    for(ShoppingCartEntity *entity1 in _cartList){
        if(entity1.selected){
            GoodsInfoEntity *entity = [self goodsEntityWithCartData:entity1];
            [goodsArr addObject:entity];
        }
    }
    if([goodsArr count] == 0){
        [UtilTool showAlertView:@"商品不能为空"];
        return;
    }
    [[CoordinateController sharedCoordinateController] toMakeOrderVC:self orderInfo:goodsArr animated:YES];
}

-(GoodsInfoEntity*)goodsEntityWithCartData:(ShoppingCartEntity*)ent{
    if(!ent){
        return nil;
    }
    GoodsInfoEntity *entity = [[[GoodsInfoEntity alloc] init] autorelease];
    entity.goods_id = ent.goods_id;
    entity.intro = ent.goods_name;
    entity.smallImg = ent.smallImg;
    entity.stockPrice = ent.goods_price;
    entity.buyNumber = ent.goods_Number;
    entity.stockID = ent.stockID;
    entity.stockName = ent.stockName;
    entity.stockBonus = ent.bonusValue;
    entity.stockNumber = ent.stock_number;
    if(entity.stockNumber < ent.goods_Number){
        [UtilTool showAlertView:[NSString stringWithFormat:@"%@库存已不足",entity.intro]];
    }
    return entity;
}

@end