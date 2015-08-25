//
//  UserInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoDef.h"
#import "UserHeaderImgModel.h"
#import "WXWeiXinOBJ.h"
#import "ShareBrowserView.h"
#import "ShareSucceedModel.h"

#define UserBgImageViewHeight (95+66)
#define Size self.view.bounds.size

@interface UserInfoVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PersonalOrderInfoDelegate,ShareBrowserViewDelegate>{
    UITableView *_tableView;
    UIImageView *bgImageView;
    WXUILabel *namelabel;
    
    UIImageView *iconImageView;
    UIImage *_image;
    
    NSArray *menuList;
}
@end

@implementation UserInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(namelabel){
        WXTUserOBJ *user = [WXTUserOBJ sharedUserOBJ];
        if(user.nickname){
            [namelabel setText:user.nickname];
        }
    }
    
    if([self userIconImage]){
        [iconImageView setImage:[self userIconImage]];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [self addSubview:_tableView];
    
    [_tableView setTableHeaderView:[self viewForTableHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(uploadUserIconSucceed) name:D_Notification_Name_UploadUserIcon object:nil];
    [notificationCenter addObserver:self selector:@selector(uploadUserInfoSucceed) name:D_Notification_Name_UploadUserInfo object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIImage*)userIconImage{
    NSString *iconPath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:iconPath] && iconImageView){
        UIImage *img = [UIImage imageWithContentsOfFile:iconPath];
        return img;
    }
    return nil;
}

-(void)uploadUserIconSucceed{
    if([self userIconImage]){
        [iconImageView setImage:[self userIconImage]];
    }
}

-(void)uploadUserInfoSucceed{
    if(namelabel){
        WXTUserOBJ *user = [WXTUserOBJ sharedUserOBJ];
        if(user.nickname){
            [namelabel setText:user.nickname];
        }
    }
}

-(UIView *)viewForTableHeadView{
    UIView *headView = [[UIView alloc] init];
    
    bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [bgImageView setImage:[UIImage imageNamed:@"PersonalInfoBgViewImg.png"]];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headView addSubview:bgImageView];
    
    CGFloat xOffset = 18;
    CGFloat yOffset = 22;
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-iconImg.size.width)/2, yOffset, iconImg.size.width, iconImg.size.height);
    [iconImageView setImage:iconImg];
    [iconImageView setBorderRadian:iconImg.size.width/2 width:1.0 color:[UIColor clearColor]];
    [headView addSubview:iconImageView];
    if([self userIconImage]){
        [iconImageView setImage:[self userIconImage]];
    }
    
    yOffset += iconImg.size.height+3;
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    xOffset += iconImg.size.width+5;
    CGFloat phoneLabelWidth = 120;
    CGFloat phoneLabelHeight = 20;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-phoneLabelWidth)/2, yOffset, phoneLabelWidth, phoneLabelHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setFont:WXTFont(15.0)];
    [phoneLabel setText:userDefault.user];
    [phoneLabel setTextColor:WXColorWithInteger(0xffffff)];
    [headView addSubview:phoneLabel];
    
    yOffset += phoneLabelHeight+2;
    namelabel = [[WXUILabel alloc] init];
    namelabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-phoneLabelWidth)/2, yOffset, phoneLabelWidth, phoneLabelHeight);
    [namelabel setBackgroundColor:[UIColor clearColor]];
    [namelabel setFont:WXFont(14.0)];
    [namelabel setTextColor:WXColorWithInteger(0xffffff)];
    [namelabel setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:namelabel];
    
    if(userDefault.nickname){
        [namelabel setText:userDefault.nickname];
    }else{
        [namelabel setText:@"空"];
    }
    
    yOffset += phoneLabelHeight;
    xOffset += phoneLabelWidth;
    WXUIButton *nextBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-phoneLabelWidth-45)/2, yOffset, Size.width-xOffset+45, 20);
    [nextBtn setBackgroundColor:[UIColor clearColor]];
    [nextBtn setTitle:@"账户管理/收货地址 " forState:UIControlStateNormal];
    [nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [nextBtn setImage:[UIImage imageNamed:@"AddressNextImg.png"] forState:UIControlStateNormal];
    [nextBtn setImageEdgeInsets:UIEdgeInsetsMake(0, Size.width-xOffset+10, 0, 0)];
    [nextBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:WXFont(14.0)];
    [nextBtn addTarget:self action:@selector(nextPageSetInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:nextBtn];
    
    yOffset = UserBgImageViewHeight+0.1;
    CGFloat smallImgHeight = 42;
    UIImageView *smallImgView = [[UIImageView alloc] init];
    smallImgView.frame = CGRectMake(0, yOffset, Size.width, smallImgHeight);
    [smallImgView setImage:[UIImage imageNamed:@"PersonalInfoBgViewImg.png"]];
//    [headView addSubview:smallImgView];
    
//    CGFloat yGap = 5;
//    UILabel *attentionNum = [[UILabel alloc] init];
//    attentionNum.frame = CGRectMake(0, yGap, Size.width/2, 15);
//    [attentionNum setBackgroundColor:[UIColor clearColor]];
//    [attentionNum setTextAlignment:NSTextAlignmentCenter];
//    [attentionNum setFont:WXFont(13.0)];
//    [attentionNum setTextColor:WXColorWithInteger(0xffffff)];
//    [attentionNum setText:@"50"];
//    [smallImgView addSubview:attentionNum];
//    
//    yGap += 15;
//    UILabel *attentionLabel = [[UILabel alloc] init];
//    attentionLabel.frame = CGRectMake(0, yGap, Size.width/2, 15);
//    [attentionLabel setBackgroundColor:[UIColor clearColor]];
//    [attentionLabel setTextAlignment:NSTextAlignmentCenter];
//    [attentionLabel setFont:WXFont(11.0)];
//    [attentionLabel setTextColor:WXColorWithInteger(0xffffff)];
//    [attentionLabel setText:@"我的收藏"];
//    [smallImgView addSubview:attentionLabel];
//    
//    UILabel *lineLabel = [[UILabel alloc] init];
//    lineLabel.frame = CGRectMake(Size.width/2, 0, 0.5, smallImgHeight);
//    [lineLabel setBackgroundColor:[UIColor grayColor]];
//    [smallImgView addSubview:lineLabel];
//    
//    UILabel *wishNum = [[UILabel alloc] init];
//    wishNum.frame = CGRectMake(Size.width/2+0.5, yGap-15, Size.width/2-0.5, 15);
//    [wishNum setBackgroundColor:[UIColor clearColor]];
//    [wishNum setTextAlignment:NSTextAlignmentCenter];
//    [wishNum setFont:WXFont(13.0)];
//    [wishNum setTextColor:WXColorWithInteger(0xffffff)];
//    [wishNum setText:@"10"];
//    [smallImgView addSubview:wishNum];
//    
//    UILabel *wishLabel = [[UILabel alloc] init];
//    wishLabel.frame = CGRectMake(Size.width/2+0.5, yGap, Size.width/2, 15);
//    [wishLabel setBackgroundColor:[UIColor clearColor]];
//    [wishLabel setTextAlignment:NSTextAlignmentCenter];
//    [wishLabel setFont:WXFont(11.0)];
//    [wishLabel setTextColor:WXColorWithInteger(0xffffff)];
//    [wishLabel setText:@"愿望清单"];
//    [smallImgView addSubview:wishLabel];
    
//    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight+smallImgHeight);
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [headView setFrame:rect];
    return headView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = 0;
    if (yOffset < 0) {
        CGRect f = bgImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset+UserBgImageViewHeight;
        f.origin.x = xOffset;
        f.size.width = 320 + fabsf(xOffset)*2;
        bgImageView.frame = f;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return PersonalInfo_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section == PersonalInfo_Cut){
//        return 0;
//    }
    return 12;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case PersonalInfo_Order:
        {
            if([CustomMadeOBJ sharedCustomMadeOBJS].appCategory == E_App_Category_Eatable){
                number = 0;
            }else{
                number = Order_Invalid;
            }
        }
            break;
//        case PersonalInfo_Money:
//            number = Money_Invalid;
//            break;
        case PersonalInfo_SharkOrder:
            number = 1;
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
        case PersonalInfo_CutAndShare:
            number = User_Invalid;
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
    if([CustomMadeOBJ sharedCustomMadeOBJS].appCategory == E_App_Category_Eatable){
        if(indexPath.section == PersonalInfo_Order || indexPath.section == PersonalInfo_SharkOrder){
            height = 0;
        }
    }
    
//    if(indexPath.section == PersonalInfo_Money && indexPath.row == Money_Category){
//        height = 53;
//    }
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

//抽奖订单
-(WXTUITableViewCell*)tableViewForSharkOrderCell{
    static NSString *identifier = @"sharkOrderCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@"SharkImg.png"]];
    [cell.textLabel setText:@"奖品订单"];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
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

//提成
-(WXTUITableViewCell*)tableViewForUserCutCellAtRow:(NSInteger)row{
    static NSString *identifier = @"cutCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case User_Cut:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"MyExtendImg.png"]];
            [cell.textLabel setText:@"提成"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case User_Share:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"PersonalShareImg.png"]];
            [cell.textLabel setText:@"分享"];
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
        case PersonalInfo_SharkOrder:
            cell = [self tableViewForSharkOrderCell];
            break;
//        case PersonalInfo_Money:
//            cell = [self tableViewForMoneyCell:row];
//            break;
        case PersonalInfo_Call:
            cell = [self tableViewForCallMoney:row];
            break;
//        case PersonalInfo_Extend:
//            cell = [self tableViewForExtendCellAtRow:row];
//            break;
        case PersonalInfo_System:
            cell = [self tableViewForSystemCellAtRow:row];
            break;
        case PersonalInfo_CutAndShare:
            cell = [self tableViewForUserCutCellAtRow:row];
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
        case PersonalInfo_SharkOrder:
        {
            LuckyGoodsOrderList *orderList = [[LuckyGoodsOrderList alloc] init];
            [self.wxNavigationController pushViewController:orderList];
        }
            break;
//        case PersonalInfo_Money:
//        {
//            UserBonusVC *bonusVC = [[UserBonusVC alloc] init];
//            [self.wxNavigationController pushViewController:bonusVC];
//        }
//            break;
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
            }
            if(row == System_About){
                AboutWxtInfoVC *aboutVC = [[AboutWxtInfoVC alloc] init];
                [self.wxNavigationController pushViewController:aboutVC];
            }
        }
            break;
        case PersonalInfo_CutAndShare:
        {
            if(row == User_Cut){
                UserCutVC *cutVC = [[UserCutVC alloc] init];
                [self.wxNavigationController pushViewController:cutVC];
            }
            if(row == User_Share){
                WXUITableViewCell *cell = (WXUITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
                [self showShareBrowerFromThumbView:cell];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark share
-(void)showShareBrowerFromThumbView:(UIView*)thumb{
    ShareBrowserView *pictureBrowse = [[ShareBrowserView alloc] init];
    pictureBrowse.delegate = self;
    [pictureBrowse showShareThumbView:thumb toDestview:self.view withImage:[UIImage imageNamed:@"TwoDimension.png"]];
}

-(void)sharebtnClicked:(NSInteger)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if(index == Share_Type_WxFriends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:kMerchantName description:[UtilTool sharedString] linkURL:[UtilTool sharedURL] thumbImage:image];
    }
    if(index == Share_Type_WxCircle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:kMerchantName description:[UtilTool sharedString] linkURL:[UtilTool sharedURL] thumbImage:image];
    }
    if(index == Share_Type_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[UtilTool sharedURL]] title:kMerchantName description:[UtilTool sharedString] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Type_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[UtilTool sharedURL]] title:kMerchantName description:[UtilTool sharedString] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
}

#pragma mark qqDelegate
-(void)onResp:(QQBaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToQQResp class]]){
        NSInteger error = [resp.result integerValue];
        if(error != 0){
        }else{
            [[ShareSucceedModel sharedSucceed] sharedSucceed];
            [UtilTool showAlertView:nil message:@"QQ分享成功" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
}
-(void)onReq:(QQBaseReq *)req{}
-(void)isOnlineResponse:(NSDictionary *)response{}

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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeOBS];
}

@end
