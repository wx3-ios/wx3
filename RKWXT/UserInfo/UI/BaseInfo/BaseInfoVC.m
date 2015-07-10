//
//  BaseInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoVC.h"
#import "BaseInfoDef.h"

#define Size self.bounds.size

@interface BaseInfoVC ()<UITableViewDataSource,UITableViewDelegate,PersonaSexSelectDelegate,PersonDatePickerDelegate,PersonNickNameDelegate>{
    UITableView *_tableView;
}
@property (nonatomic,assign) BOOL bSex;
@property (nonatomic,strong) NSString *nickNameStr;
@property (nonatomic,strong) NSString *dateStr;
@end

@implementation BaseInfoVC
static NSString *_nameListArray[BaseInfo_Invalid]={
    @"头像",
    @"昵称",
    @"性别",
    @"出生日期"
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"个人资料"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_Base_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case T_Base_UserInfo:
            number = BaseInfo_Invalid;
            break;
        case T_Base_ManagerInfo:
            number = Manager_Invalid;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == T_Base_ManagerInfo){
        height = 15.0;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = BaseInfoForCommonCellHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == T_Base_UserInfo && row == BaseInfo_Userhead){
        height = BaseInfoForUserHeadHeight;
    }
    return height;
}

-(BaseInfoHeadCell*)tableViewForBaseInfoHeadImgCell:(NSInteger)row{
    static NSString *identifier = @"headCell";
    BaseInfoHeadCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[BaseInfoHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.textLabel setText:_nameListArray[row]];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell load];
    return cell;
}

-(BaseInfoCommonCell *)tableViewForCommonCellAtRow:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    BaseInfoCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[BaseInfoCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.textLabel setText:_nameListArray[row]];
    [cell.textLabel setFont:WXFont(15.0)];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)row];
    switch (row) {
        case BaseInfo_Nickname:
            str = _nickNameStr;
            break;
        case BaseInfo_Usersex:
            str = (_bSex==0?@"男":@"女");
            break;
        case BaseInfo_Userdate:
            str = _dateStr;
            break;
        default:
            break;
    }
    [cell setCellInfo:str];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForManagerCellAtRow:(NSInteger)row{
    static NSString *identifier = @"managerCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    NSString *nameStr = @"收货地址管理";
    if(row == 1){
        nameStr = @"修改密码";
    }
    [cell.textLabel setText:nameStr];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case T_Base_UserInfo:
            if(row == BaseInfo_Userhead){
                cell = [self tableViewForBaseInfoHeadImgCell:row];
            }else{
                cell = [self tableViewForCommonCellAtRow:row];
            }
            break;
        case T_Base_ManagerInfo:
            cell = [self tableViewForManagerCellAtRow:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == T_Base_UserInfo){
        switch (row) {
            case BaseInfo_Userhead:
                break;
            case BaseInfo_Nickname:
            {
                PersonNicknameVC *nickNameVC = [[PersonNicknameVC alloc] init];
                [nickNameVC setDelegate:self];
                [self.wxNavigationController pushViewController:nickNameVC];
            }
                break;
            case BaseInfo_Usersex:
            {
                PersonSexVC *sexVC= [[PersonSexVC alloc] init];
                if(_bSex){
                    sexVC.sexSelectedIndex = 1;
                }else{
                    sexVC.sexSelectedIndex = 0;
                }
                [sexVC setDelegate:self];
                [self.wxNavigationController pushViewController:sexVC];
            }
                break;
            case BaseInfo_Userdate:
            {
                PersonDatePickerVC *datePickerVC = [[PersonDatePickerVC alloc] init];
                [datePickerVC setDelegate:self];
                [datePickerVC setDateString:_dateStr];
                [self.wxNavigationController pushViewController:datePickerVC];
            }
                break;
            default:
                break;
        }
    }
    if(section == T_Base_ManagerInfo){
        switch (row) {
            case ManagerAddress:
            {
                ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
                [self.wxNavigationController pushViewController:addressVC];
            }
                break;
//            case ManagerPassword:
//            {
//                WXTResetPwdVC *resetPwdVC = [[WXTResetPwdVC alloc] init];
//                [self.wxNavigationController pushViewController:resetPwdVC];
//            }
//                break;
            default:
                break;
        }
    }
}

#pragma mark 选择性别
-(void)didSelectAtIndex:(NSInteger)index{
    self.bSex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BaseInfo_Usersex inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 日期选择
-(void)didSelectDate:(NSString *)dateStr{
    self.dateStr = dateStr;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BaseInfo_Userdate inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)didSetPersonNickname:(NSString *)nickName{
    _nickNameStr = nickName;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:BaseInfo_Nickname inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
