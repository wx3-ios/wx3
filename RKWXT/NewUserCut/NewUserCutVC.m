//
//  NewUserCutVC.m
//  RKWXT
//
//  Created by SHB on 15/9/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewUserCutVC.h"
#import "NewGoodsInfoBDCell.h"
#import "UserRefereeCell.h"
#import "NewMyClientVC.h"
#import "MyCutRefereeModel.h"
#import "MyRefereeEntity.h"

#import "SearchUserAliAccountModel.h"
#import "UserAliEntity.h"

#import "UserWithdrawalsVC.h"
#import "ConfirmUserAliPayVC.h"
#import "ApplyAliWithdrawalsVC.h"
#import "WithdrawalsRecordListVC.h"

#import "WXDropListView.h"

#define Size self.bounds.size

enum{
    NewCut_Section_team = 0,
    NewCut_Section_Referee,
    
    NewCut_Section_invalid,
};

enum{
    //提现
    DropList_Section_Money = 0,
    //提现记录
    DropList_Section_Record,
    
    DropList_Section_Invalid,
};

static NSString* g_dropItemList[DropList_Section_Invalid] ={
    @"提现",
    @"提现记录",
};

@interface NewUserCutVC ()<UITableViewDataSource,UITableViewDelegate,LoadMyCutRefereeModelDelegate,SearchUserAliAccountModelDelegate,WXDropListViewDelegate>{
    UITableView *_tableView;
    WXUILabel *_bigMoney;
    WXUILabel *_smallMoney;
    
    BOOL _isOpen;
    
    MyCutRefereeModel *_model;
    NSArray *myCutArr;
    
    SearchUserAliAccountModel *aliModel;
    UserAliEntity *userAliEntity;
    CGFloat userMoney;
    
    WXDropListView *_dropListView;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation NewUserCutVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeUserWithdrawalsInfoSucceed];
    [self applyAliSucceed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的提成"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _isOpen = NO;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableviewForHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self createNavRightBtn];
    
    _model = [[MyCutRefereeModel alloc] init];
    [_model setDelegate:self];
    [_model loadMyCutRefereeInfo];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
    aliModel = [[SearchUserAliAccountModel alloc] init];
    [aliModel setDelegate:self];
    [aliModel searchUserAliPayAccount];
}

-(void)createNavRightBtn{
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"提现" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setRightNavigationItem:rightBtn];
    
    _dropListView = [self createDropListViewWith:rightBtn];
    [_dropListView unshow:NO];
    [self addSubview:_dropListView];
}

//下拉菜单
- (WXDropListView*)createDropListViewWith:(WXUIButton*)btn{
    CGFloat height = 40;
    NSInteger row = DropList_Section_Invalid;
    CGFloat width = 150;
    CGRect rect = CGRectMake(IPHONE_SCREEN_WIDTH - width, 0, width, row*height);
    WXDropListView *dropListView = [[WXDropListView alloc] initWithFrame:self.bounds menuButton:btn dropListFrame:rect];
    [dropListView setDelegate:self];
    [dropListView setFont:[UIFont systemFontOfSize:15.0]];
    [dropListView setDropDirection:E_DropDirection_Left];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < DropList_Section_Invalid; i++) {
        WXDropListItem *item = [[WXDropListItem alloc] init];
        [item setTitle:g_dropItemList[i]];
        [itemArray addObject:item];
    }
    [dropListView setDataList:itemArray];
    return dropListView;
}

#pragma mark DropListDelegate
- (void)menuClickAtIndex:(NSInteger)index{
    switch (index) {
        case DropList_Section_Money:
            [self gotoUserWithdrawalsVC];
            break;
        case DropList_Section_Record:
        {
            WithdrawalsRecordListVC *listVC = [[WithdrawalsRecordListVC alloc] init];
            [self.wxNavigationController pushViewController:listVC];
        }
            break;
        default:
            break;
    }
}

-(UIView*)tableviewForHeadView{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 27;
    CGFloat bigHeight = 40;
    _bigMoney = [[WXUILabel alloc] init];
    _bigMoney.frame = CGRectMake(0, yOffset, Size.width, bigHeight);
    [_bigMoney setBackgroundColor:[UIColor clearColor]];
    [_bigMoney setFont:WXFont(41.0)];
    [_bigMoney setText:@"0.00"];
    [_bigMoney setTextAlignment:NSTextAlignmentCenter];
    [_bigMoney setTextColor:WXColorWithInteger(0xf36f25)];
    [headView addSubview:_bigMoney];
    
    yOffset += bigHeight+10;
    CGFloat btnWidth = 140;
    CGFloat btnHeight = 20;
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:[UIImage imageNamed:@"UserCut.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitle:@"账户安全保障中" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
    [button setTitleColor:WXColorWithInteger(0x59b904) forState:UIControlStateNormal];
    [button setEnabled:NO];
    [button.titleLabel setFont:WXFont(12.0)];
    [headView addSubview:button];
    
    yOffset = 130;
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [line setBackgroundColor:WXColorWithInteger(0xcfcfcf)];
    [headView addSubview:line];
    
    yOffset += 15;
    CGFloat smallWidth = 80;
    CGFloat smallHeight = 20;
    _smallMoney = [[WXUILabel alloc] init];
    _smallMoney.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [_smallMoney setBackgroundColor:[UIColor clearColor]];
    [_smallMoney setText:@"0.00"];
    [_smallMoney setTextAlignment:NSTextAlignmentCenter];
    [_smallMoney setFont:WXFont(15.0)];
    [_smallMoney setTextColor:WXColorWithInteger(0x000000)];
    [headView addSubview:_smallMoney];
    
    yOffset += smallHeight;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"提成"];
    [textLabel setTextColor:WXColorWithInteger(0x828282)];
    [textLabel setFont:WXFont(11.0)];
    [headView addSubview:textLabel];
    
    headView.frame = CGRectMake(0, 0, Size.width, 196);
    return headView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NewCut_Section_invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case NewCut_Section_team:
            row = 1;
            break;
        case NewCut_Section_Referee:
        {
            if(_isOpen){
                if(_selectedIndexPath.section == section){
                    if([myCutArr count] > 0){
                        MyRefereeEntity *ent = [myCutArr objectAtIndex:0];
                        if(ent.userID > 0){
                            return 2;
                        }
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case NewCut_Section_team:
            height = 9;
            break;
        case NewCut_Section_Referee:
            height = 0;
            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case NewCut_Section_team:
            height = 44;
            break;
        case NewCut_Section_Referee:{
            if(indexPath.row == 0){
                height = 44;
            }else{
                height = 125;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    headView.frame = CGRectMake(0, 0, Size.width, 9);
    return headView;
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

//我的团队
-(WXUITableViewCell*)tableViewForUserCutCell{
    static NSString *identifier = @"cutCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@"MyCutTeam.png"]];
    [cell.textLabel setText:@"我的团队"];
    [cell.textLabel setFont:WXFont(16.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell load];
    return cell;
}

//我的推荐人
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"MyCutReferee.png"]];
    [cell.textLabel setText:@"我的推荐者"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(16.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    return cell;
}

-(WXUITableViewCell*)tableViewForRefereeCell{
    static NSString *identifier = @"refereeCell";
    UserRefereeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserRefereeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    if([myCutArr count] > 0){
        [cell setCellInfo:myCutArr[0]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isOpen && indexPath.section == NewCut_Section_Referee){
        static NSString *identifier = @"showRefereeCell";
        NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row > 0){
            cell = (NewGoodsInfoBDCell*)[self tableViewForRefereeCell];
        }
        if(indexPath.row == 0){
            [cell changeArrowWithDown:_isOpen];
            [cell.imageView setImage:[UIImage imageNamed:@"MyCutReferee.png"]];
            [cell.textLabel setText:@"我的推荐者"];
            [cell.textLabel setFont:WXFont(16.0)];
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        switch (section) {
            case NewCut_Section_team:
                cell = [self tableViewForUserCutCell];
                break;
            case NewCut_Section_Referee:
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
    if(section == NewCut_Section_team){
        NewMyClientVC *clientVC = [[NewMyClientVC alloc] init];
        [self.wxNavigationController pushViewController:clientVC];
    }
    if(section == NewCut_Section_Referee){
        if(indexPath.row == 0){
            if([myCutArr count] > 0){
                MyRefereeEntity *ent = [myCutArr objectAtIndex:0];
                if(ent.userID == 0){
                    return;
                }
            }
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
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:NewCut_Section_Referee] withRowAnimation:UITableViewRowAnimationFade];
    if(_isOpen){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:NewCut_Section_Referee] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark myCutRefereeDelegate
-(void)loadMyCutRefereeInfoSucceed{
    [self unShowWaitView];
    myCutArr = _model.myCutInfoArr;
    if([myCutArr count] > 0){
        MyRefereeEntity *entity = [myCutArr objectAtIndex:0];
        [_bigMoney setText:[NSString stringWithFormat:@"%.2f",entity.balance]];
        [_smallMoney setText:[NSString stringWithFormat:@"%.2f",entity.cutMoney]];
        userMoney = entity.balance;
    }
    [_tableView reloadData];
}

-(void)loadMyCutRefereeInfoFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取提成失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark withdrawals
-(void)gotoUserWithdrawalsVC{
    //添加帐号
    if(userAliEntity.userali_type == UserAliCount_Type_None){
        ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
        comfirmVC.titleString = @"验证信息";
        [self.wxNavigationController pushViewController:comfirmVC];
    }
    //审核中
    if(userAliEntity.userali_type == UserAliCount_Type_Submit){
        UserWithdrawalsVC *userWithdrawalsVC = [[UserWithdrawalsVC alloc] init];
        [self.wxNavigationController pushViewController:userWithdrawalsVC];
    }
    //有账号
    if(userAliEntity.userali_type == UserAliCount_Type_Succeed){
        ApplyAliWithdrawalsVC *appliAliVC = [[ApplyAliWithdrawalsVC alloc] init];
        appliAliVC.entity = userAliEntity;
        appliAliVC.money = userMoney;
        [self.wxNavigationController pushViewController:appliAliVC];
    }
    //审核未通过
    if(userAliEntity.userali_type == UserAliCount_Type_Failed){
        [UtilTool showAlertView:@"抱歉，您的支付宝账户信息审核未通过，请重新填写"];
        
        ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
        comfirmVC.titleString = @"验证信息";
        [self.wxNavigationController pushViewController:comfirmVC];
    }
}

//提现成功后的通知
-(void)applyAliSucceed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGFloat moneyValue = [userDefaults floatForKey:ApplySucceed];
    
    if([myCutArr count] > 0 && moneyValue > 0){
        [UtilTool showAlertView:@"申请提现成功，系统将自动转到您的支付宝账户，请注意查收"];
        MyRefereeEntity *entity = [myCutArr objectAtIndex:0];
        [_bigMoney setText:[NSString stringWithFormat:@"%.2f",entity.balance-moneyValue]];
        [_tableView reloadData];
    }
}

//修改用户提现账号成功后的通知
-(void)changeUserWithdrawalsInfoSucceed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:ConfirmSign]){
        userAliEntity.userali_type = UserAliCount_Type_Submit;
    }
}

-(void)searchUserAliPayAccountSucceed{
    if([aliModel.userAliAcountArr count] > 0){
        userAliEntity = [aliModel.userAliAcountArr objectAtIndex:0];
    }
}

-(void)searchUserAliPayAccountFailed:(NSString *)errorMsg{
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:ConfirmSign];
    [userDefaults setFloat:0 forKey:ApplySucceed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
