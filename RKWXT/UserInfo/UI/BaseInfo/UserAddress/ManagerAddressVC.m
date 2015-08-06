//
//  ManagerAddressVC.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ManagerAddressVC.h"
#import "AddressEntity.h"
#import "AddressEditVC.h"
#import "AddressBaseInfoCell.h"
#import "AddressManagerCell.h"
#import "UserAddressModel.h"

enum{
    Address_BaseInfo = 0,
    Address_Manager,
    
    Address_Invalid,
};

@interface ManagerAddressVC()<UITableViewDataSource,UITableViewDelegate,AddressManagerDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSArray *_addListArr;
}
@end

@implementation ManagerAddressVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BOOL reload = [[UserAddressModel shareUserAddress] shouldDataReload];
    if(reload){
        [[UserAddressModel shareUserAddress] loadUserAddress];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }else{
        _addListArr = [UserAddressModel shareUserAddress].userAddressArr;
        [_tableView reloadData];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"地址管理"];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableViewForFootView]];
    [self addnotification];
}

-(void)addnotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadAddressDataSucceed) name:K_Notification_UserAddress_LoadDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadAddressDataFailed:) name:K_Notification_UserAddress_LoadDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(delAddressDataSucceed) name:K_Notification_UserAddress_DelDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(delAddressDataFailed:) name:K_Notification_UserAddress_DelDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(setAddNormalSucceed) name:K_Notification_UserAddress_SetNorAddSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(setAddNormalFailed:) name:K_Notification_UserAddress_SetNorAddFailed object:nil];
}

-(void)remoNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView*)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    CGFloat yOffset = 30;
    CGFloat xOffset = 30;
    WXUIButton *createBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width-2*xOffset, 40);
    [createBtn setBorderRadian:6.0 width:0.1 color:WXColorWithInteger(0xdd2726)];
    [createBtn setBackgroundColor:[UIColor redColor]];
    [createBtn setTitle:@"+ 新建收货地址" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:createBtn];
    
    yOffset += 40;
    footView.frame = CGRectMake(0, 0, self.bounds.size.width, yOffset);
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_addListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Address_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case Address_BaseInfo:
            height = [AddressBaseInfoCell cellHeightOfInfo:_addListArr[indexPath.row]];
            break;
        case Address_Manager:
            height = AddressManagerCellHeight;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForAddressBaseInfoCellAtSection:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identifier = @"baseInfoCell";
    AddressBaseInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AddressBaseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(row == Address_Manager){
        cell = (AddressBaseInfoCell*)[self tableViewForManagerAddress:section];
    }else{
        [cell setCellInfo:_addListArr[section]];
        [cell load];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section != 0){
        height = 10;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForManagerAddress:(NSInteger)section{
    static NSString *identifier = @"baseCell";
    AddressManagerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:_addListArr[section]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell = [self tableViewForAddressBaseInfoCellAtSection:section atRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)createNewAddress{
    AddressEditVC *addeditVC = [[AddressEditVC alloc] init];
    addeditVC.address_type = Address_Type_Insert;
    [self.wxNavigationController pushViewController:addeditVC completion:^{
    }];
}

-(void)editAddressInfo:(AddressEntity *)entity{
    AddressEditVC *addeditVC = [[AddressEditVC alloc] init];
    addeditVC.address_type = Address_Type_Modify;
    addeditVC.entity = entity;
    [self.wxNavigationController pushViewController:addeditVC completion:^{
    }];
}

#pragma mark addressManagerDelegate
-(void)setAddressNormal:(AddressEntity *)entity{
    if(!entity){
        return;
    }
    if(entity.normalID == 1){
        return;
    }
    NSInteger oldID = 0;
    for(AddressEntity *entity in _addListArr){
        if(entity.normalID == 1){
            oldID = entity.address_id;
        }
    }
    [[UserAddressModel shareUserAddress] setNormalAddressWithOldAddID:oldID withNewAddID:entity.address_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)setAddNormalSucceed{
    [self unShowWaitView];
    _addListArr = [UserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
}

-(void)setAddNormalFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"设置默认收货信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark load
-(void)loadAddressDataSucceed{
    [self unShowWaitView];
    _addListArr = [UserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
}

-(void)loadAddressDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"查询数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark del
-(void)delAddress:(AddressEntity *)entity{
    if(entity.normalID == entity.address_id){
        [UtilTool showAlertView:@"请先更改默认地址后再删除!"];
        return;
    }
    [[UserAddressModel shareUserAddress] deleteUserAddressWithAddressID:entity.address_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)delAddressDataSucceed{
    [self unShowWaitView];
    _addListArr = [UserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
}

-(void)delAddressDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"删除数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
