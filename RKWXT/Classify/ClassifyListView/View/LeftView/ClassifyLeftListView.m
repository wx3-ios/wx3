//
//  ClassifyLeftListView.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyLeftListView.h"
#import "ClassifyModel.h"
#import "CLassifyEntity.h"

#define size self.bounds.size

@interface ClassifyLeftListView ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    NSString *titleStr;
    NSInteger lastCount;
    
    BOOL isSelect;
}

@end

@implementation ClassifyLeftListView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addOBS];
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
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loadClassifyDataSucceed) name:D_Notification_Name_LoadClassifyData_Succeed object:nil];
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
    [cell setCellInfo:listArr[indexPath.row]];
    [cell setSelectedStr:titleStr];
    [cell load];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == lastCount){
        return;
    }
    CLassifyEntity *entity = listArr[indexPath.row];
    titleStr = entity.catName;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:lastCount inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    lastCount = indexPath.row;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"userSelectRow" object:[NSNumber numberWithInteger:indexPath.row]];
}

-(void)loadClassifyDataSucceed{
    listArr = [ClassifyModel shareClassifyNodel].classifyDataArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self reloadTableview];
}

-(void)reloadTableview{
    isSelect = NO;
    NSInteger count = 0;
    for(CLassifyEntity *ent in listArr){
        if(ent.catID == _cat_id){
            count++;
            isSelect = YES;
            break;
        }
        count++;
    }
    if(_cat_id == 0 || !isSelect){
        count = 0;
    }
    NSIndexPath *first = [NSIndexPath indexPathForRow:(count==0?0:count-1) inSection:0];
    [_tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    if(_cat_id != 0 && count != 0){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter postNotificationName:@"userSelectRow" object:[NSNumber numberWithInteger:count-1]];
        lastCount = count-1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
