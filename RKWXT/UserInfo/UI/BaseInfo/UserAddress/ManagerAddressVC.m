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
#import "AddSqlite.h"
#import "AddressBaseInfoCell.h"
#import "AddressManagerCell.h"

enum{
    Address_BaseInfo = 0,
    Address_Manager,
    
    Address_Invalid,
};

@interface ManagerAddressVC()<UITableViewDataSource,UITableViewDelegate,AddressManagerDelegate>{
    UITableView *_tableView;
    AddSqlite *_fmdb;
    NSArray *_addListArr;
}
@end

@implementation ManagerAddressVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addObs];
}

-(void)addObs{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressSqliteChange) name:AddressSqliteHasChanged object:nil];
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
    
    _fmdb = [[AddSqlite alloc] init];
    [_fmdb createOrOpendb];
    [_fmdb createTable];
    _addListArr = [_fmdb selectAll];
}

-(UIView*)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    CGFloat yOffset = 30;
    CGFloat xOffset = 10;
    WXUIButton *createBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width-2*xOffset, 40);
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
    static NSString *identifier = @"baseInfoCell";
    AddressManagerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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

-(void)addressSqliteChange{
    _addListArr = [_fmdb selectAll];
    [_tableView reloadData];
}

-(void)createNewAddress{
    AddressEditVC *addeditVC = [[AddressEditVC alloc] init];
    [self.wxNavigationController pushViewController:addeditVC completion:^{
    }];
}

-(void)removeObs{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark addressManagerDelegate
-(void)setAddressNormal:(AddressEntity *)entity{
//    for(AddressEntity *en in _addListArr){
//        if(en.userName == entity.userName && en.userPhone == entity.userPhone && en.address == entity.address){
//            [_fmdb changeTestListWith:en.userName phone:en.userPhone address:en.address sel:@"0"];
//        }else{
//            [_fmdb changeTestListWith:en.userName phone:en.userPhone address:en.address sel:@"0"];
//        }
//    }
}

-(void)editAddressInfo:(AddressEntity *)entity{
    AddressEditVC *addeditVC = [[AddressEditVC alloc] init];
    addeditVC.entity = entity;
    [self.wxNavigationController pushViewController:addeditVC completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObs];
}

@end
