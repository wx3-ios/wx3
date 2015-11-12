//
//  NewMyClientVC.m
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewMyClientVC.h"
#import "MyClientInfoVC.h"
#import "MyRefereeEntity.h"

#define size self.bounds.size

@interface NewMyClientVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    MyRefereeEntity *refEntity;
    NSArray *itemsArr;
}
@end

@implementation NewMyClientVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"店小二"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    itemsArr = @[@"一级客户",
                 @"二级客户",
                 @"三级客户"];
    refEntity = _entity;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [itemsArr count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(WXUITableViewCell*)tableViewForClientCellAtRow:(NSInteger)row{
    static NSString *identifier = @"clientCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.textLabel setText:itemsArr[row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell.textLabel setFont:WXFont(16.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    
    [cell.detailTextLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell.detailTextLabel setFont:WXFont(14.0)];
    if(row == 0 && refEntity.parent_1 != 0){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"(%ld)",(long)refEntity.parent_1]];
    }
    if(row == 1 && refEntity.parent_2 != 0){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"(%ld)",(long)refEntity.parent_2]];
    }
    if(row == 2 && refEntity.parent_3 != 0){
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"(%ld)",(long)refEntity.parent_3]];
    }
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForClientCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    MyClientInfoVC *clientInfoVC = [[MyClientInfoVC alloc] init];
    [clientInfoVC setTitleName:itemsArr[row]];
    [clientInfoVC setClient_grade:row+1];
    [self .wxNavigationController pushViewController:clientInfoVC];
}

@end
