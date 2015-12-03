//
//  WXToSnapUpController.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXToSnapUpController.h"
#import "ToDaySnapUPCell.h"
#import "ToSnapUpTopCell.h"
#import "ToSnapUp.h"
#import "TimeShopData.h"

#import "SearchTimeGoodsController.h"
#import "WXTURLFeedOBJ.h"
#import "WXUIActivityIndicatorView.h"
#import "NewGoodsInfoVC.h"

#import "StoreDetailsInfoVc.h"

@interface WXToSnapUpController ()<UITableViewDataSource,UITableViewDelegate,TimeShopModerDelegate,ToSnapUpTopCellDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *goodsarray;
@property (nonatomic,strong)NSMutableArray *timearray;

@property (nonatomic,strong)NSMutableArray *beg_goods;
@property (nonatomic,strong)NSMutableArray *beg_time_goods;
@property (nonatomic,strong)NSMutableArray *end_goods;
@property (nonatomic,strong)NSMutableArray *end_time_goods;
//时间
@property (nonatomic,strong)NSMutableArray *TimeGoods;
@property (nonatomic,strong)NSMutableArray *topTime;

@property (nonatomic,assign)BOOL pullUp;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)TimeShopModer *timeShop;

@property (nonatomic,strong)WXUIActivityIndicatorView *waitingView;
@end

@implementation WXToSnapUpController


#pragma mark ------  系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"限时购"];
     _count =1;
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    [self addSubview:tableview];
    tableview.sectionFooterHeight = 0.0001;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor whiteColor];
    self.tableview = tableview;
    
    TimeShopModer *timeShop = [[TimeShopModer alloc]init];
    timeShop.delegate = self;
    [timeShop timeShopModeListWithCount:1 page:_count];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    self.timeShop = timeShop;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown ];
    [self setRightNavigationItem:button];
    
}

- (void)clickBtn{
    StoreDetailsInfoVc *vc = [[StoreDetailsInfoVc alloc]init];
    [self.wxNavigationController pushViewController:vc];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.timearray.count;
    }
    return  self.TimeGoods.count ? 1 : 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
   // NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    switch (section) {
        case 0:{
            cell = [self setToSnapTopCell];
        }
         break;
        case 1:{
            cell = [self ToDaySnapUPCell:indexPath];
        }
            break;
    }
   
    return cell;
    
}

//提前抢
- (UITableViewCell*)setToSnapTopCell{
    NSString *cellIndef = @"toSnapTopCell";
    ToSnapUpTopCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[ToSnapUpTopCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndef goodsArray:self.goodsarray];
        cell.height = [ToSnapUpTopCell cellHeight];
    }
    cell.goodsArray = self.goodsarray;
    cell.delegate  =self;
    return cell;
}

- (UITableViewCell*)ToDaySnapUPCell:(NSIndexPath*)indexPath{
    ToDaySnapUPCell * cell = [ToDaySnapUPCell  toDaySnapTopCell:self.tableview];
    cell.data = self.timearray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return [ToSnapUpTopCell cellHeight];
    }
    
    return  [ToDaySnapUPCell cellHeight];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [self timeGoodsHeard];
    }
    return [self setheardview];
}

- (UIView*)setheardview{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    titleView.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(TopMargin, 12.5, self.view.width, titleView.height - 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @" 天天疯抢";
    label.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:label];
    
    return  titleView;
}

//今日抢购
- (UIView*)timeGoodsHeard{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIView *didscview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    didscview.backgroundColor = [UIColor grayColor];
    [titleView addSubview:didscview];
    
    UIView *downcview = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.height - 0.5, self.view.width, 0.5)];
    downcview.backgroundColor = [UIColor grayColor];
    [titleView addSubview:downcview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(TopMargin, 12.5, self.view.width, titleView.height - 25)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @" 今日抢购";
    label.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:label];
    
    return titleView;
}



-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   
      self.pullUp = YES;
    
    //_pullUp 是否可以上拉加载，向上拉的偏移超过50就加载
    if (self.pullUp && scrollView.frame.size.height+scrollView.contentOffset.y > scrollView.contentSize.height + 50)
    {
          _count++;
        
        [self.timeShop pullUpRefreshWithCount:_count];
       
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        TimeShopData *data = self.timearray[indexPath.row];
        NewGoodsInfoVC *newGoods = [[NewGoodsInfoVC alloc]init];
        newGoods.lEntity = data;
        newGoods.goodsInfo_type = GoodsInfo_LimitGoods;
        [self.wxNavigationController pushViewController:newGoods];
    }
    ToSnapUpTopCell *cell = (ToSnapUpTopCell*)[self.tableview cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}




#pragma mark ---- 网络处理

//网络请求失败
- (void)timeShopModerWithFailed:(NSString *)errorMsg{
    
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"加载数据失败";
    }
   // [UtilTool showAlertView:errorMsg];
    
   // [self noNewData];
    
}

- (void)noNewData{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewH = 40;
    CGFloat viewY = self.tableview.contentSize.height;
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0,viewY, viewW, viewH)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.tableview addSubview:downView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:downView.bounds];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"已经是最新数据了";
    [downView addSubview:label];
    
    
    [UIView animateWithDuration:1.5 animations:^{
        
        CGRect tableRect = self.tableview.frame;
        tableRect.origin.y -= 41;
        self.tableview.frame = tableRect;
        
        CGRect rect = downView.frame;
        rect.origin.y -= 41;
        downView.frame = rect;
      
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.2 animations:^{
                CGRect rect = downView.frame;
                rect.origin.y += 40;
                downView.frame = rect;
              CGRect tableRect = self.tableview.frame;
                tableRect.origin.y += 40;
                self.tableview.frame = tableRect;
            } completion:^(BOOL finished) {
                
                [downView removeFromSuperview];
            }];
            
        }
        
    }];

   
    
    
}


//网络请求成功
- (void)timeShopModerWithGoodArr:(NSMutableArray *)goodsArr timeGoods:(NSMutableArray *)timeGoods beg_goods:(NSMutableArray *)beg_goods beg_time_goods:(NSMutableArray *)beg_time_goods end_goods:(NSMutableArray *)end_goods end_time_goods:(NSMutableArray *)end_time_goods{
    
    [self unShowWaitView];
    self.goodsarray = goodsArr;
    self.timearray = timeGoods;
    self.beg_goods = beg_goods;
    self.beg_time_goods = beg_time_goods;
    self.end_goods = end_goods;
    self.end_time_goods = end_time_goods;
    
   

    [self timeDown];
    
    [self.tableview reloadData];
}


- (void)pullUpRefreshWithData:(TimeShopData *)data beg_time:(NSString*)beg_time end_time:(NSString*)end_time{
       [self.timearray addObject:data];
      [self.beg_time_goods addObject:beg_time];
      [self.end_time_goods addObject:end_time];
    
    
    
      [self timeDown];
      [self.tableview reloadData];
}


//倒计时方法
- (void)timeDown{
    
      self.TimeGoods  = [NSMutableArray array];
        for (int i = 0; i < self.timearray.count; i++) {
        
        NSTimeInterval end_time = [self.end_time_goods[i] longLongValue];
        NSDate *end_date = [NSDate dateWithTimeIntervalSince1970:end_time];
        NSMutableDictionary *endDict = [NSMutableDictionary dictionary];
        [endDict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
        [endDict setValue:end_date forKey:@"end_date"];
        [self.TimeGoods addObject:endDict];
        
    }
    
    self.topTime = [NSMutableArray array];
    for (int i = 0; i < self.goodsarray.count; i++) {
        NSTimeInterval end_time = [self.end_goods[i] longLongValue];
        NSDate *end_date = [NSDate dateWithTimeIntervalSince1970:end_time];
        NSMutableDictionary *dict= [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
        [dict setValue:end_date forKey:@"end_date"];
        [self.topTime addObject:dict];
    }
    
    
    NSTimer *timero = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moreTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timero forMode:NSRunLoopCommonModes];
}


- (void)moreTime{
    
    NSDate *now_date  = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    for (int i = 0; i < self.timearray.count; i++) {
        
        NSDate *end_date = [self.TimeGoods[i] valueForKey:@"end_date"];
        
        NSDateComponents *com = [cal components:unit fromDate:now_date toDate:end_date options:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[self.TimeGoods objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:1];
        ToDaySnapUPCell *cell = (ToDaySnapUPCell*)[self.tableview cellForRowAtIndexPath:indexPath];
        cell.timeDown.text = [NSString stringWithFormat:@"%02d:%02d:%02d",com.hour,com.minute,com.second];
        
        
        NSMutableDictionary *end_dict = [NSMutableDictionary dictionary];
        [end_dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
        [end_dict setValue:end_date  forKey:@"end_date"];
        [self.TimeGoods addObject:end_dict];
        
    }
    
    
    for (int i = 0; i < self.goodsarray.count; i++) {
        NSDate *end_date = [self.topTime[i] valueForKey:@"end_date"];
        NSDateComponents *com = [cal components:unit fromDate:now_date toDate:end_date options:0];
        ToSnapUpTopCell *cell = (ToSnapUpTopCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger index = [[self.topTime[i] objectForKey:@"index"] integerValue];
          
        HeardGoodsView *goods = cell.childArray[index];
        goods.timeDown.text = [NSString stringWithFormat:@"%02d:%02d:%02d",com.hour,com.minute,com.second];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
        [dict setValue:end_date  forKey:@"end_date"];
        [self.topTime addObject:dict];
    }
    

}

#pragma mark ---- 代理方法
- (void)toSnapUpToCellWithTouch:(ToSnapUpTopCell *)cell index:(NSInteger)index{
    HeardGoodsView *goods = nil;
    NewGoodsInfoVC *newGoods = [[NewGoodsInfoVC alloc]init];
    switch (index) {
        case ToSnapUpTopTypeIndexOne:{
            goods = cell.childArray[ToSnapUpTopTypeIndexOne];
            newGoods.lEntity = goods.data;
        }
         break;
        case ToSnapUpTopTypeIndexTwo:{
            goods = cell.childArray[ToSnapUpTopTypeIndexTwo];
            newGoods.lEntity = goods.data;
                    }
            break;
        case ToSnapUpTopTypeIndexThree:{
            goods = cell.childArray[ToSnapUpTopTypeIndexThree];
            newGoods.lEntity = goods.data;
            
        }
            break;
         }
    
   
    newGoods.goodsInfo_type = GoodsInfo_LimitGoods;
    [self.wxNavigationController pushViewController:newGoods];
}





@end
