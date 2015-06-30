//
//  UserInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoDef.h"

#define UserBgImageViewHeight (95)
#define Size self.view.bounds.size

@interface UserInfoVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PersonalOrderInfoDelegate>{
    UITableView *_tableView;
}
@end

@implementation UserInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我"];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_tableView];
    
    [_tableView setTableHeaderView:[self viewForTableHeadView]];
    [_tableView setTableFooterView:[self viewForTableFootView]];
}

-(UIView *)viewForTableHeadView{
    UIView *headView = [[UIView alloc] init];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [bgImageView setImage:[UIImage imageNamed:@"PersonalInfoBgViewImg.png"]];
//    [bgImageView setBackgroundColor:[UIColor redColor]];
    [headView addSubview:bgImageView];
    
    CGFloat xOffset = 18;
    CGFloat yOffset = 18;
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake(xOffset, UserBgImageViewHeight-yOffset-iconImg.size.height, iconImg.size.width, iconImg.size.height);
    [iconImageView setImage:iconImg];
    [headView addSubview:iconImageView];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    xOffset += iconImg.size.width+5;
    CGFloat phoneLabelWidth = 120;
    CGFloat phoneLabelHeight = 20;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(xOffset, UserBgImageViewHeight/2-20, phoneLabelWidth, phoneLabelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentLeft];
    [phoneLabel setFont:WXTFont(15.0)];
    [phoneLabel setText:userDefault.user];
    [phoneLabel setTextColor:WXColorWithInteger(0xffffff)];
    [headView addSubview:phoneLabel];
    
    yOffset += 30;
    WXUILabel *namelabel = [[WXUILabel alloc] init];
    namelabel.frame = CGRectMake(xOffset, yOffset, phoneLabelWidth, phoneLabelHeight);
    [namelabel setBackgroundColor:[UIColor clearColor]];
    [namelabel setFont:WXFont(12.0)];
    [namelabel setTextColor:WXColorWithInteger(0xffffff)];
    [namelabel setText:@"我是风儿"];
    [namelabel setTextAlignment:NSTextAlignmentLeft];
    [headView addSubview:namelabel];
    
    yOffset += phoneLabelHeight;
    xOffset += phoneLabelWidth;
    WXUIButton *nextBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(xOffset, yOffset, Size.width-xOffset, 20);
    [nextBtn setBackgroundColor:[UIColor clearColor]];
    [nextBtn setTitle:@"账户管理/收货地址 >" forState:UIControlStateNormal];
    [nextBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:WXFont(12.0)];
    [nextBtn addTarget:self action:@selector(nextPageSetInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:nextBtn];
    
    yOffset = UserBgImageViewHeight+0.1;
    CGFloat smallImgHeight = 42;
    UIImageView *smallImgView = [[UIImageView alloc] init];
    smallImgView.frame = CGRectMake(0, yOffset, Size.width, smallImgHeight);
    [smallImgView setImage:[UIImage imageNamed:@"PersonalInfoBgViewImg.png"]];
    [headView addSubview:smallImgView];
    
    CGFloat yGap = 5;
    UILabel *attentionNum = [[UILabel alloc] init];
    attentionNum.frame = CGRectMake(0, yGap, Size.width/2, 15);
    [attentionNum setBackgroundColor:[UIColor clearColor]];
    [attentionNum setTextAlignment:NSTextAlignmentCenter];
    [attentionNum setFont:WXFont(13.0)];
    [attentionNum setTextColor:WXColorWithInteger(0xffffff)];
    [attentionNum setText:@"50"];
    [smallImgView addSubview:attentionNum];
    
    yGap += 15;
    UILabel *attentionLabel = [[UILabel alloc] init];
    attentionLabel.frame = CGRectMake(0, yGap, Size.width/2, 15);
    [attentionLabel setBackgroundColor:[UIColor clearColor]];
    [attentionLabel setTextAlignment:NSTextAlignmentCenter];
    [attentionLabel setFont:WXFont(11.0)];
    [attentionLabel setTextColor:WXColorWithInteger(0xffffff)];
    [attentionLabel setText:@"我的收藏"];
    [smallImgView addSubview:attentionLabel];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(Size.width/2, 0, 0.5, smallImgHeight);
    [lineLabel setBackgroundColor:[UIColor grayColor]];
    [smallImgView addSubview:lineLabel];
    
    UILabel *wishNum = [[UILabel alloc] init];
    wishNum.frame = CGRectMake(Size.width/2+0.5, yGap-15, Size.width/2-0.5, 15);
    [wishNum setBackgroundColor:[UIColor clearColor]];
    [wishNum setTextAlignment:NSTextAlignmentCenter];
    [wishNum setFont:WXFont(13.0)];
    [wishNum setTextColor:WXColorWithInteger(0xffffff)];
    [wishNum setText:@"10"];
    [smallImgView addSubview:wishNum];
    
    UILabel *wishLabel = [[UILabel alloc] init];
    wishLabel.frame = CGRectMake(Size.width/2+0.5, yGap, Size.width/2, 15);
    [wishLabel setBackgroundColor:[UIColor clearColor]];
    [wishLabel setTextAlignment:NSTextAlignmentCenter];
    [wishLabel setFont:WXFont(11.0)];
    [wishLabel setTextColor:WXColorWithInteger(0xffffff)];
    [wishLabel setText:@"愿望清单"];
    [smallImgView addSubview:wishLabel];
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight+smallImgHeight);
    [headView setFrame:rect];
    return headView;
}

-(UIView*)viewForTableFootView{
    UIView *footView = [[UIView alloc] init];
    [footView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    CGFloat btnHeight = 45;
    WXTUIButton *quitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(0, 30, Size.width, btnHeight);
    [quitBtn setBackgroundImageOfColor:WXColorWithInteger(0xFFFFFF) controlState:UIControlStateNormal];
    [quitBtn setTitle:@"切换登录帐号" forState:UIControlStateNormal];
    [quitBtn setTitleColor:WXColorWithInteger(0x669696) forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:quitBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, 220);
    if(Size.width == 375){
        rect = CGRectMake(0, 0, Size.width, 320);
    }
    if(Size.width == 414){
        rect = CGRectMake(0, 0, Size.width, 390);
    }
    [footView setFrame:rect];
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return PersonalInfo_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case PersonalInfo_Order:
            number = Order_Invalid;
            break;
        case PersonalInfo_Money:
            number = Money_Invalid;
            break;
        case PersonalInfo_Call:
            number = Call_Invalid;
            break;
//        case PersonalInfo_Extend:
//            number = Extend_Invalid;
//            break;
        case PersonalInfo_System:
            number = System_Invalid;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = CommonCellHeight;
    if(indexPath.section == PersonalInfo_Order && indexPath.row == Order_Category){
        height = 53;
    }
    if(indexPath.section == PersonalInfo_Money && indexPath.row == Money_Category){
        height = 53;
    }
    return height;
}

-(WXTUITableViewCell*)tabelForUserInfoCommonCell:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    UserInfoCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserInfoCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell loadUserInfoBaseData:row];
    return cell;
}

//订单
-(WXTUITableViewCell*)tableViewForOrderCell:(NSInteger)row{
    static NSString *identifier = @"orderCell";
    PersonalInfoOrderListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalInfoOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == Order_listAll){
        [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
        [cell.imageView setImage:[UIImage imageNamed:@"OrderListImg.png"]];
        [cell.textLabel setText:@"我的订单"];
        [cell.textLabel setFont:WXFont(15.0)];
        [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        [cell load];
    }else{
        cell = (PersonalInfoOrderListCell*)[self tableViewForOrderInfoCell:row];
    }
    return cell;
}

-(WXTUITableViewCell*)tableViewForOrderInfoCell:(NSInteger)row{
    static NSString *identifier = @"orderInfoCell";
    PersonalOrderInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//钱包
-(WXTUITableViewCell*)tableViewForMoneyCell:(NSInteger)row{
    static NSString *identifier = @"moneyCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == Money_listAll){
        [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
        [cell.imageView setImage:[UIImage imageNamed:@"MyWalletImg.png"]];
        [cell.textLabel setText:@"我的钱包"];
        [cell.textLabel setFont:WXFont(15.0)];
        [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    }else{
        cell = (WXTUITableViewCell*)[self tableViewForMoneyInfoCell:row];
    }
    return cell;
}

-(WXTUITableViewCell*)tableViewForMoneyInfoCell:(NSInteger)row{
    static NSString *identifier = @"moneyInfoCell";
    PersonalMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//话费
-(WXTUITableViewCell*)tableViewForCallMoney:(NSInteger)row{
    static NSString *identifier = @"callMoneyCell";
    PersonalCallCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == Call_Recharge){
        [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
        [cell.imageView setImage:[UIImage imageNamed:@"MyCallMoneyImg.png"]];
        [cell.textLabel setText:@"我的话费"];
        [cell.textLabel setFont:WXFont(15.0)];
        [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    }else{
        cell = (PersonalCallCell*)[self tableViewForCallSign:row];
    }
    return cell;
}

-(WXTUITableViewCell*)tableViewForCallSign:(NSInteger)row{
    static NSString *identifier = @"callSignCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"SignGainCallMoney.png"]];
    [cell.textLabel setText:@"签到送话费"];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    return cell;
}

//分销
-(WXTUITableViewCell*)tableViewForExtendCellAtRow:(NSInteger)row{
    static NSString *identifier = @"extendCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case System_Setting:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"MyDistributionImg.png"]];
            [cell.textLabel setText:@"我的分销"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case System_About:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"MyExtendImg.png"]];
            [cell.textLabel setText:@"我的推广"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        default:
            break;
    }
    return cell;
}

//设置
-(WXTUITableViewCell*)tableViewForSystemCellAtRow:(NSInteger)row{
    static NSString *identifier = @"systemCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case System_Setting:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"SysSettingImg.png"]];
            [cell.textLabel setText:@"设置"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case System_About:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"AboutWxImg.png"]];
            [cell.textLabel setText:@"关于"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        default:
            break;
    }
    return cell;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case PersonalInfo_Order:
            cell = [self tableViewForOrderCell:row];
            break;
        case PersonalInfo_Money:
            cell = [self tableViewForMoneyCell:row];
            break;
        case PersonalInfo_Call:
            cell = [self tableViewForCallMoney:row];
            break;
//        case PersonalInfo_Extend:
//            cell = [self tableViewForExtendCellAtRow:row];
//            break;
        case PersonalInfo_System:
            cell = [self tableViewForSystemCellAtRow:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case PersonalInfo_Order:
        {
            if(row == Order_listAll){
                HomeOrderVC *orderListVC = [[HomeOrderVC alloc] init];
                [self.wxNavigationController pushViewController:orderListVC];
            }
        }
            break;
        case PersonalInfo_Money:
        {
            UserBonusVC *bonusVC = [[UserBonusVC alloc] init];
            [self.wxNavigationController pushViewController:bonusVC];
        }
            break;
        case PersonalInfo_Call:
        {
            if(row == Call_Recharge){
                UserBalanceVC *userBalanceVC = [[UserBalanceVC alloc] init];
                [self.wxNavigationController pushViewController:userBalanceVC];
            }else{
                SignViewController *signVC = [[SignViewController alloc] init];
                [self.wxNavigationController pushViewController:signVC];
            }
        }
            break;
//        case PersonalInfo_Extend:
//        {
//        }
//            break;
        case PersonalInfo_System:
        {
            if(row == System_Setting){
                NewSystemSettingVC *systemSetting = [[NewSystemSettingVC alloc] init];
                [self.wxNavigationController pushViewController:systemSetting];
            }else{
                AboutWxtInfoVC *aboutVC = [[AboutWxtInfoVC alloc] init];
                [self.wxNavigationController pushViewController:aboutVC];
            }
        }
            break;
        default:
            break;
    }
}

-(void)nextPageSetInfo{
    BaseInfoVC *baseInfoVC = [[BaseInfoVC alloc] init];
    [self.wxNavigationController pushViewController:baseInfoVC];
}

//订单delegate
-(void)personalInfoToShoppingCart{
    T_MenuVC *menuVC = [[T_MenuVC alloc] init];
    [self.wxNavigationController pushViewController:menuVC];
}

-(void)personalInfoToWaitPayOrderList{
    [[CoordinateController sharedCoordinateController] toOrderList:self selectedShow:1 animated:YES];
}

-(void)personalInfoToWaitReceiveOrderList{
    [[CoordinateController sharedCoordinateController] toOrderList:self selectedShow:3 animated:YES];
}

-(void)quit{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"确定要退出我信通吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger index = buttonIndex;
    if(index == 1){
        //清除用户信息
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        [userDefault removeAllUserInfo];
        
        LoginVC *loginVC = [[LoginVC alloc] init];
        WXUINavigationController *navigationController = [[WXUINavigationController alloc] initWithRootViewController:loginVC];
        [self.wxNavigationController presentViewController:navigationController animated:YES completion:^{
            [self.wxNavigationController popToRootViewControllerAnimated:YES Completion:^{
            }];
        }];
    }
}

@end
