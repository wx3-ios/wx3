//
//  LuckyGoodsShowVC.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsShowVC.h"
#import "LuckyGoodsShowCell.h"
#import "SharkVC.h"
#import "LuckyGoodsModel.h"
#import "NewGoodsInfoVC.h"

#define Size self.bounds.size

@interface LuckyGoodsShowVC ()<UITableViewDataSource,UITableViewDelegate,LuckyGoodsModelDelegate>{
    UITableView *_tableView;
    WXUIButton *rightBtn;
    NSArray *goodsArr;
    LuckyGoodsModel *_model;
}

@end

@implementation LuckyGoodsShowVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LuckyGoodsModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"奖品列表"];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setRightNavigationItem:[self createRightBtn]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(WXUIButton*)createRightBtn{
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"抽奖" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(gotoSharkVC) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
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
//    return [goodsArr count];
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    height = LuckyGoodsShowCellHeight;
    return height;
}

-(WXUITableViewCell*)tableViewForLuckyGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"luckyCell";
    LuckyGoodsShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForLuckyGoodsListCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewGoodsInfoVC *infoVC = [[NewGoodsInfoVC alloc] init];
    infoVC.goodsInfo_type = GoodsInfo_LuckyGoods;
    infoVC.goodsId = 1;
    [self.wxNavigationController pushViewController:infoVC];
}

-(void)gotoSharkVC{
    SharkVC *sharkVC = [[SharkVC alloc] init];
    [self.wxNavigationController pushViewController:sharkVC];
}

-(void)loadLuckyGoodsSuceeed{
    [self unShowWaitView];
    goodsArr = _model.luckyGoodsArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadLuckyGoodsFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商品失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
