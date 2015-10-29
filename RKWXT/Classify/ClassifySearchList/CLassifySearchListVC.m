//
//  CLassifySearchListVC.m
//  RKWXT
//
//  Created by SHB on 15/10/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "CLassifySearchListVC.h"
#import "ClassifyResultListCell.h"
#import "NewGoodsInfoVC.h"
#import "SearchResultEntity.h"

#define Size self.bounds.size

@interface CLassifySearchListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tabelView;
    WXUIButton *rightBtn;
    BOOL showUp;
}
@end

@implementation CLassifySearchListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"搜索结果"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tabelView = [[UITableView alloc] init];
    _tabelView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tabelView setBackgroundColor:[UIColor whiteColor]];
    [_tabelView setDelegate:self];
    [_tabelView setDataSource:self];
    [self addSubview:_tabelView];
    [_tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self createRightItemBtn];
}

-(void)createRightItemBtn{
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 25;
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Size.width-btnWidth-10, 66-btnHeight-10, btnWidth, 25);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"价格" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [rightBtn addTarget:self action:@selector(changeListViewShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_searchList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ClassifyResultListCellHeight;
}

-(WXUITableViewCell*)tableViewForGoodsListCellAt:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    ClassifyResultListCell *cell = [_tabelView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([_searchList count] > 0){
        [cell setCellInfo:_searchList[row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForGoodsListCellAt:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tabelView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    SearchResultEntity *entity = [_searchList objectAtIndex:row];
    NewGoodsInfoVC *goodsInfoVC = [[NewGoodsInfoVC alloc] init];
    goodsInfoVC.goodsId = entity.goodsID;
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

-(void)changeListViewShow{
    showUp = !showUp;
    if(showUp){
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
        _searchList = [self goodsPriceDownSort];
        [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
        _searchList = [self goodsPriceUpSort];
        [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//升序排序
-(NSArray*)goodsPriceUpSort{
    NSArray *sortArray = [_searchList sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        SearchResultEntity *entity_0 = obj1;
        SearchResultEntity *entity_1 = obj2;
        
        if (entity_0.shop_price > entity_1.shop_price){
            return NSOrderedDescending;
        }else if (entity_0.shop_price < entity_1.shop_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

//降序排序
-(NSArray*)goodsPriceDownSort{
    NSArray *sortArray = [_searchList sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        SearchResultEntity *entity_0 = obj1;
        SearchResultEntity *entity_1 = obj2;
        
        if (entity_0.shop_price < entity_1.shop_price){
            return NSOrderedDescending;
        }else if (entity_0.shop_price > entity_1.shop_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

@end
