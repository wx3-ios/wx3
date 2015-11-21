//
//  LuckyGoodsShowVC.m
//  RKWXT
//
//  Created by SHB on 15/8/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsShowVC.h"
#import "LuckyGoodsShowCell.h"
#import "LuckyGoodsModel.h"
#import "NewGoodsInfoVC.h"
#import "OrderListTableView.h"
#import "LuckyGoodsEntity.h"

typedef enum{
    E_CellRefreshing_Nothing = 0,
    E_CellRefreshing_UnderWay,
    E_CellRefreshing_Finish,
    
    E_CellRefreshing_Invalid,
}E_CellRefreshing;

#define Size self.bounds.size
#define EveryTimeLoadDataNumber 20

@interface LuckyGoodsShowVC ()<UITableViewDataSource,UITableViewDelegate,LuckyGoodsModelDelegate,PullingRefreshTableViewDelegate>{
    OrderListTableView *_tableView;
    WXUIButton *rightBtn;
    NSArray *goodsArr;
    NSInteger orderlistCount;
    LuckyGoodsModel *_model;
    
    BOOL showUp;
    
    NSMutableArray *totalLastTime;
}
@property (nonatomic,assign) E_CellRefreshing e_cellRefreshing;
@end

@implementation LuckyGoodsShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"奖品列表"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    totalLastTime = [[NSMutableArray alloc] init];
    for(int i = 0; i< 4; i++){
        NSMutableDictionary *overDic = [[NSMutableDictionary alloc] init];
        [overDic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
        [overDic setValue:[NSString stringWithFormat:@"%d",100+i]  forKey:@"lastTime"];
        [totalLastTime addObject:overDic];
    }
    
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    _tableView = [[OrderListTableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setPullingDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self createRightBtn];
    
    _model = [[LuckyGoodsModel alloc] init];
    [_model setDelegate:self];
    
    [_model setType:LuckyGoods_Type_Normal];
    [_model loadLuckyGoodsListWith:0 with:EveryTimeLoadDataNumber];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)createRightBtn{
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
    return [goodsArr count];
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
    [cell setCellInfo:goodsArr[row]];
    [cell load];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForLuckyGoodsListCellAtRow:row];
    if(indexPath.row > 4){
        [cell.textLabel setHidden:YES];
    }else{
        [cell.textLabel setHidden:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    LuckyGoodsEntity *entity = [goodsArr objectAtIndex:indexPath.row];
    NewGoodsInfoVC *infoVC = [[NewGoodsInfoVC alloc] init];
    infoVC.goodsInfo_type = GoodsInfo_LuckyGoods;
    infoVC.goodsId = entity.goodsID;
    [self.wxNavigationController pushViewController:infoVC];
}

-(void)changeListViewShow{
    showUp = !showUp;
    if(showUp){
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
        goodsArr = [self goodsPriceDownSort];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
        goodsArr = [self goodsPriceUpSort];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//升序排序
-(NSArray*)goodsPriceUpSort{
    NSArray *sortArray = [goodsArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        LuckyGoodsEntity *entity_0 = obj1;
        LuckyGoodsEntity *entity_1 = obj2;
        
        if (entity_0.market_price > entity_1.market_price){
            return NSOrderedDescending;
        }else if (entity_0.market_price < entity_1.market_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

//降序排序
-(NSArray*)goodsPriceDownSort{
    NSArray *sortArray = [goodsArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        LuckyGoodsEntity *entity_0 = obj1;
        LuckyGoodsEntity *entity_1 = obj2;
        
        if (entity_0.market_price < entity_1.market_price){
            return NSOrderedDescending;
        }else if (entity_0.market_price > entity_1.market_price){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

-(void)loadLuckyGoodsSuceeed{
    [self unShowWaitView];
    if(orderlistCount == [_model.luckyGoodsArr count] && self.e_cellRefreshing != E_CellRefreshing_Finish){
        _tableView.reachedTheEnd = YES;
    }
    self.e_cellRefreshing = E_CellRefreshing_Nothing;
    goodsArr = _model.luckyGoodsArr;
    orderlistCount = [goodsArr count];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}

-(void)refreshLessTime{
    NSUInteger time;
    for (int i = 0; i < [totalLastTime count]; i++) {
        time = [[[totalLastTime objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:0];
        LuckyGoodsShowCell *cell = (LuckyGoodsShowCell *)[_tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"剩%d",--time];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
        [dic setValue:[NSString stringWithFormat:@"%d",time]  forKey:@"lastTime"];
        [totalLastTime replaceObjectAtIndex:i withObject:dic];
    }
}

//-(void)refreshLessTime{
//    NSUInteger time;
//    for (int i = 0; i < [totalLastTime count]; i++) {
//        time = [[[totalLastTime objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:0];
//        LuckyGoodsShowCell *cell = (LuckyGoodsShowCell *)[_tableView cellForRowAtIndexPath:indexPath];
//        cell.textLabel.text = [NSString stringWithFormat:@"剩%d",--time];
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
//        [dic setValue:[NSString stringWithFormat:@"%d",time]  forKey:@"lastTime"];
//        [totalLastTime replaceObjectAtIndex:i withObject:dic];
//    }
//}

#pragma mark luckyModelDelegate
-(void)loadLuckyGoodsFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取商品失败";
    }
    [UtilTool showAlertView:errorMsg];
    if([errorMsg isEqualToString:@"没有您要查询的数据"]){
        _tableView.reachedTheEnd = YES;
    }
}

#pragma mark pullingDelegate
-(void)pullingTableViewDidStartRefreshing:(OrderListTableView *)tableView{
    self.e_cellRefreshing = E_CellRefreshing_UnderWay;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(NSDate*)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [UtilTool getCurDateTime:1];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}

-(void)pullingTableViewDidStartLoading:(OrderListTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

-(void)loadData{
    if(self.e_cellRefreshing == E_CellRefreshing_UnderWay){
        self.e_cellRefreshing = E_CellRefreshing_Finish;
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_tableView tableViewDidFinishedLoadingWithMessage:@"刷新完成"];
        [_model setType:LuckyGoods_Type_Refresh];
        [_model loadLuckyGoodsListWith:0 with:[goodsArr count]];
    }else{
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        [_model setType:LuckyGoods_Type_Loading];
        [_model loadLuckyGoodsListWith:[goodsArr count] with:EveryTimeLoadDataNumber];
    }
    if(!_tableView.reachedTheEnd){
        [_tableView tableViewDidFinishedLoading];
        _tableView.reachedTheEnd = NO;
    }
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_tableView tableViewDidEndDragging:scrollView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
