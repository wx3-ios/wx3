//
//  LMSearchSellerResultVC.m
//  RKWXT
//
//  Created by SHB on 15/12/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchSellerResultVC.h"
#import "LMSearchSellerResultCell.h"
#import "LMSearchSellerEntity.h"

#define Size self.bounds.size

@interface LMSearchSellerResultVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}
@end

@implementation LMSearchSellerResultVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"搜索结果"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMSearchSellerResultCellHeight;
}

-(WXUITableViewCell*)searchSellerResultCell:(NSInteger)row{
    static NSString *identifier = @"sellerCell";
    LMSearchSellerResultCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSearchSellerResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([_listArr count] > 0){
        [cell setCellInfo:[_listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self searchSellerResultCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row  = indexPath.row;
    LMSearchSellerEntity *entity = [_listArr objectAtIndex:row];
    [[CoordinateController sharedCoordinateController] toLMSellerInfopVC:self sellerID:entity.sellerID animated:YES];
}

@end
