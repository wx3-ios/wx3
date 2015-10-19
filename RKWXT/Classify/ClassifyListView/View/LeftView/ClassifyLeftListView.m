//
//  ClassifyLeftListView.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyLeftListView.h"

#define size self.bounds.size

@interface ClassifyLeftListView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    NSString *titleStr;
    NSInteger lastCount;
}

@end

@implementation ClassifyLeftListView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    listArr = @[@{@"title":@"000"},
                @{@"title":@"001"},
                @{@"title":@"002"},
                @{@"title":@"003"},
                @{@"title":@"004"},
                @{@"title":@"005"},
                @{@"title":@"006"},
                @{@"title":@"007"},
                @{@"title":@"008"},
                @{@"title":@"009"},
                @{@"title":@"010"},
                @{@"title":@"011"},
                @{@"title":@"012"},
                @{@"title":@"013"},
                @{@"title":@"014"},
                @{@"title":@"015"}
                   ];
    
    [self reloadTableview];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ClassifyLeftViewHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"leftViewCell";
    ClassifyLeftTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [cell.selectedBackgroundView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [cell setCellInfo:[listArr[indexPath.row] objectForKey:@"title"]];
    [cell setSelectedStr:titleStr];
    [cell load];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    titleStr = [listArr[indexPath.row] objectForKey:@"title"];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:lastCount inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    lastCount = indexPath.row;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"userSelectRow" object:[NSNumber numberWithInteger:indexPath.row]];
}

-(void)reloadTableview{
    titleStr = [listArr[0] objectForKey:@"title"];
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"userSelectRow" object:[NSNumber numberWithInteger:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
