//
//  WXToSnapUpController.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXToSnapUpController.h"
#import "ToDaySnapUPCell.h"
#import "ToSnapUp.h"
#import "TimeShopData.h"

#import "SearchTimeGoodsController.h"
#import "WXTURLFeedOBJ.h"


@interface WXToSnapUpController ()<UITableViewDataSource,UITableViewDelegate,HeardViewDelegate,TimeShopModerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *goodsarray;
@property (nonatomic,strong)NSMutableArray *timearray;

@property (nonatomic,strong)NSMutableArray *beg_goods;
@property (nonatomic,strong)NSMutableArray *beg_time_goods;
@property (nonatomic,strong)NSMutableArray *end_goods;
@property (nonatomic,strong)NSMutableArray *end_time_goods;
//时间
@property (nonatomic,strong)NSMutableArray *totalTime;

@property (nonatomic,assign)BOOL pullUp;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)HeardView *heardview;
@property (nonatomic,strong)TimeShopModer *timeShop;
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
    [timeShop timeShopModeListWithCount:_count page:1];
    

//#warning 右侧进入搜素
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 200, 300)];
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(clackBtn) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:button];
//    [self setRightNavigationItem:button];
    NSLog(@"%s %d", __FUNCTION__, __LINE__);

    self.totalTime = [NSMutableArray array];
    for (int i = 0; i < self.beg_time_goods.count; i++) {
        
        NSTimeInterval beg_time = [self.beg_time_goods[i] longLongValue];
        NSDate *beg_date = [NSDate dateWithTimeIntervalSince1970:beg_time];
        NSMutableDictionary *endDict = [NSMutableDictionary dictionary];
        [endDict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
        [endDict setValue:[NSString stringWithFormat:@"%@",beg_date] forKey:@"beg_date"];
        [self.totalTime addObject:endDict];
        
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moreTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
  
}

- (void)moreTime{


//    NSDate *now_date  = nil;
//    for (int i = 0; i < self.beg_time_goods.count; i++) {
//        
//        NSDate *beg_date = [self.totalTime[i] valueForKey:@"beg_date"];
//        now_date = [[NSDate date] laterDate:beg_date];
//         NSLog(@">>>>>>>>>>>>>%s %d", __FUNCTION__, __LINE__);
//        NSTimeInterval end_time = [self.end_time_goods[i] longLongValue];
//        NSDate *end_date = [NSDate dateWithTimeIntervalSince1970:end_time];
//        
//        NSCalendar *cal = [NSCalendar currentCalendar];
//        NSCalendarUnit unit =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//        NSDateComponents *com = [cal components:unit fromDate:now_date toDate:end_date options:0];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[self.totalTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:1];
//        ToDaySnapUPCell *cell = (ToDaySnapUPCell*)[self.tableview cellForRowAtIndexPath:indexPath];
//        cell.textLabel.text = [NSString stringWithFormat:@"%d : %d : %d",com.hour,com.minute,com.second];
//        
//        NSMutableDictionary *end_dict = [NSMutableDictionary dictionary];
//        [end_dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"indexPath"];
//        [end_dict setValue:[NSString stringWithFormat:@"%@",now_date]  forKey:@"beg_date"];
//        [self.totalTime addObject:end_dict];
//        
//    }
    
    
}




- (void)clackBtn{
    SearchTimeGoodsController *Searchvc = [[SearchTimeGoodsController alloc]init];
    [self.wxNavigationController pushViewController:Searchvc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
      
       
        return self.timearray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *name = @"cell";
     ToDaySnapUPCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell  = [[ToDaySnapUPCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name];
       // cell.height =[XBToDaySngnCell cellHeight:nil];
    }
    cell.data = self.timearray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [ToDaySnapUPCell cellHeight];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 188;
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
    self.heardview = [[HeardView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180) goodsArray:self.goodsarray];
    self.heardview.goodsArray = self.goodsarray;
     self.heardview.delegate = self;
    return  self.heardview;
}

- (UIView*)timeGoodsHeard{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIView *didscview = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, self.view.width, 0.5)];
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
        [self pullUpRefresh];//调用加载方法
    }
}

- (void)pullUpRefresh
{
    _count++;
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pid"] = @"ios";
    dict[@"ver"] =  [UtilTool currentVersion];
    dict[@"ts"] = timeSp;
    dict[@"type"] = [NSNumber numberWithInt:1];
    dict[@"page"] = [NSNumber numberWithInt:_count];
    dict[@"shop_id"] = [NSNumber numberWithInt:kSubShopID];
    debugLog(@"%@",dict);
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_TimeToBuy httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dict completion:^(URLFeedData *retData) {
        
        if(retData.code != 0){
        
            
        }else{
            //现在时间
            NSDate *date = [NSDate date];
            NSTimeInterval nowTime = [date timeIntervalSince1970];
            NSArray *array = retData.data[@"data"];
            for (NSDictionary *dict in array) {
                TimeShopData *moder = [[TimeShopData alloc]initWithDict:dict];
                [self.timearray addObject:moder];
                if (nowTime > [dict[@"begin_time"] longLongValue]) {
                    moder.beg_imageHidden = YES;
                    moder.downHidden = NO;
                    moder.end_Image_Hidden = YES;
                    
                    if (nowTime > [dict[@"end_time"] longLongValue]) {
                        moder.beg_imageHidden = YES;
                        moder.downHidden = NO;
                        moder.end_Image_Hidden = YES;
                    }else{
                        moder.beg_imageHidden = YES;
                        moder.downHidden = YES;
                        moder.end_Image_Hidden = NO;
                    }
                    
                }else {
                    moder.beg_imageHidden = NO;
                    moder.downHidden = YES;
                    moder.end_Image_Hidden = YES;
                }
                
                //刷新表格
                [self.tableview reloadData];
            }
            
            
        }
    }];
    

    
}

#pragma mark ---- 自定义代理方法

- (void)heardViewTouch:(HeardView *)heard{
    
    debugLog(@"商品被点击");
    
}

- (void)timeShopModerWithFailed:(NSString *)errorMsg{
    debugLog(@"没有数据");
}


- (void)timeShopModerWithGoodArr:(NSMutableArray *)goodsArr timeGoods:(NSMutableArray *)timeGoods beg_goods:(NSMutableArray *)beg_goods beg_time_goods:(NSMutableArray *)beg_time_goods end_goods:(NSMutableArray *)end_goods end_time_goods:(NSMutableArray *)end_time_goods{
    self.goodsarray = goodsArr;
    self.timearray = timeGoods;
    self.beg_goods = beg_goods;
    self.beg_time_goods = beg_time_goods;
    self.end_goods = end_goods;
    self.end_time_goods = end_time_goods;
    
    
    
     [self.tableview reloadData];
}

@end
