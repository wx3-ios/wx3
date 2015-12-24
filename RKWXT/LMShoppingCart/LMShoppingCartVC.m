//
//  LMShoppingCartVC.m
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShoppingCartVC.h"
#import "LMShoppingCartTitleCell.h"
#import "LMShoppingCartGoodsListCell.h"
#import "LMShoppingCartModel.h"
#import "LMShoppingCartEntity.h"

#define Size self.bounds.size
#define DownViewHeight (42)

@interface LMShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate,LMShoppingCartModelDelegate,LMShoppingCartTitleCellBtnDelegate,LMShoppingCartGoodsListCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    WXUILabel *moneyLabel;
    LMShoppingCartModel *_model;
}

@end

@implementation LMShoppingCartVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMShoppingCartModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的购物车"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:[self downInfoView]];
    
    [_model searchLMShoppingCartData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(WXUIView*)downInfoView{
    WXUIView *downView = [[WXUIView alloc] init];
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 0, Size.width, 0.5);
    [lineLabel setBackgroundColor:WXColorWithInteger(0x9b9b9b)];
    [downView addSubview:lineLabel];
    
    CGFloat xOffset = 10;
    CGFloat labelWidth = 40;
    CGFloat labelHeight = 15;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, (DownViewHeight-labelHeight)/2, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setText:@"合计:"];
    [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
    [textLabel setFont:WXFont(14.0)];
    [downView addSubview:textLabel];
    
    xOffset += labelWidth;
    moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, (DownViewHeight-labelHeight)/2, 110, labelHeight);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [moneyLabel setText:@"￥29.00"];
    [moneyLabel setFont:WXFont(14.0)];
    [downView addSubview:moneyLabel];
    
    CGFloat btnWidth = 80;
    WXUIButton *balanceBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    balanceBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-btnWidth, 0, btnWidth, DownViewHeight);
    [balanceBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [balanceBtn setTitle:@"结算" forState:UIControlStateNormal];
    [balanceBtn.titleLabel setFont:WXFont(15.0)];
    [balanceBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [balanceBtn addTarget:self action:@selector(balanceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:balanceBtn];
    
    [downView setFrame:CGRectMake(0, IPHONE_SCREEN_HEIGHT-DownViewHeight, IPHONE_SCREEN_WIDTH, DownViewHeight)];
    return downView;
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
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([listArr count] > 0){
        return [[listArr objectAtIndex:section] count]+1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger row = indexPath.row;
    if(row == 0){
        height = LMShoppingCartTitleCellHieght;
    }else{
        height= LMShoppingCartGoodsListCellHeight;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section > 0){
        height = 11;
    }
    return height;
}

-(WXUITableViewCell*)shoppingCartTitleCell:(NSInteger)section{
    static NSString *identifier = @"titleCell";
    LMShoppingCartTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShoppingCartTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[[listArr objectAtIndex:section] objectAtIndex:0]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)shoppingCartGoodsListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identifier = @"goodsCell";
    LMShoppingCartGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShoppingCartGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([listArr count] > 0){
        [cell setCellInfo:[[listArr objectAtIndex:section] objectAtIndex:row-1]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == 0){
        cell = [self shoppingCartTitleCell:section];
    }else{
        cell = [self shoppingCartGoodsListCell:section atRow:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == 0){
        LMShoppingCartEntity *entity = [[listArr objectAtIndex:section] objectAtIndex:row];
        [[CoordinateController sharedCoordinateController] toLMShopInfoVC:self shopID:entity.shopID animated:YES];
    }else{
        LMShoppingCartEntity *entity = [[listArr objectAtIndex:section] objectAtIndex:row-1];
        [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:entity.goodsID animated:YES];
    }
}

#pragma mark shopcartData
-(void)loadLMShoppingCartSucceed{
    [self unShowWaitView];
    listArr = _model.shoppingCartArr;
    [_tableView reloadData];
}

-(void)loadLMShoppingCartFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)deleteLMShoppingCartGoodsSucceed{
//    [self unShowWaitView];
//    listArr = _model.shoppingCartArr;
//    [_tableView reloadData];
    [_model searchLMShoppingCartData];
}

-(void)deleteLMShoppingCartGoodsFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"删除数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark balance
-(void)balanceBtnClicked{
    
}

#pragma mark title
-(void)lmShoppingCartTitleCellCircleClicked:(id)sender{
    LMShoppingCartEntity *entity = sender;
    NSInteger index = 0;
    for(NSArray *arr in listArr){
        LMShoppingCartEntity *ent = [arr objectAtIndex:0];
        index ++;
        if(ent.shopID == entity.shopID){
            break;
        }
    }
    
    if(index > 0){
        NSInteger count = 0;
        for(NSArray *arr in listArr){
            if(count==index-1){
                for(LMShoppingCartEntity *ent in arr){
                    ent.selected = entity.selectAll;
                }
            }else{
                for(LMShoppingCartEntity *ent in arr){
                    ent.selected = NO;
                    ent.selectAll = NO;
                }
            }
            count++;
        }
    }
    
    [_tableView reloadData];
}

-(void)goodsCircleSellect:(id)sender{
    LMShoppingCartEntity *entity = sender;
    NSInteger index = 0;
    for(NSArray *arr in listArr){
        LMShoppingCartEntity *ent = [arr objectAtIndex:0];
        index ++;
        if(ent.shopID == entity.shopID){
            break;
        }
    }
    
    if(index > 0){
        NSInteger count = 0;
        NSInteger number = 0;
        for(NSArray *arr in listArr){
            if(number == index-1){
                for(LMShoppingCartEntity *ent in arr){
                    ent.selectAll = NO;
                    if(ent.selected){
                        count++;
                    }
                    if(count == [arr count]){
                        for(LMShoppingCartEntity *ent in arr){
                            ent.selectAll = YES;
                        }
                    }
                }
            }else{
                for(LMShoppingCartEntity *ent in arr){
                    ent.selectAll = NO;
                    ent.selected = NO;
                }
            }
            number++;
        }
        [_tableView reloadData];
    }
}

//编辑按钮
-(void)lmShoppingCartTitleCellEditClicked:(id)sender{
    LMShoppingCartEntity *entity = sender;
    for(NSArray *arr in listArr){
        LMShoppingCartEntity *ent = [arr objectAtIndex:0];
        if(ent.shopID == entity.shopID){
            for(LMShoppingCartEntity *entit in arr){
                entit.edit = entity.edit;
            }
        }else{
            
            //此行代码同步将改变未选择的各个商品
//            for(LMShoppingCartEntity *entit in arr){
//                entit.edit = NO;
//            }
        }
    }
    [_tableView reloadData];
}

//增加按钮
-(void)goodsPlusBtnClicked:(id)sender{
//    LMShoppingCartEntity *entity = sender;
//    for(NSArray *arr in listArr){
//        LMShoppingCartEntity *ent = [arr objectAtIndex:0];
//        if(ent.shopID == entity.shopID){
//            for(LMShoppingCartEntity *enti in arr){
//                if(enti.goodsID == entity.goodsID){
//                    enti.buyNumber = entity.buyNumber;
//                }
//            }
//        }
//    }
    [_tableView reloadData];
}

//减少按钮
-(void)goodsMinusBtnClicked:(id)sender{
    [_tableView reloadData];
}

-(void)goodsDelBtnClicked:(id)sender{
    LMShoppingCartEntity *entity = sender;
    [_model deleteLMShoppingCartGoods:entity.cartID];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
