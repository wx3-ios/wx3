//
//  TimeShopModer.m
//  RKWXT
//
//  Created by app on 15/11/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "TimeShopModer.h"
#import "TimeShopData.h"
#import "WXTURLFeedOBJ+NewData.h"
@implementation TimeShopModer

- (NSMutableArray*)goodsA{
    if (!_goodsA) {
        _goodsA = [NSMutableArray array];
    }
    return _goodsA;
}

- (NSMutableArray*)timeGoodsA{
    if (!_timeGoodsA) {
        _timeGoodsA = [NSMutableArray array];
    }
    return _timeGoodsA;
}


- (NSMutableArray*)beg_goods{
    if (!_beg_goods) {
        _beg_goods = [NSMutableArray array];
    }
    return _beg_goods;
}

- (NSMutableArray*)beg_time_goods{
    if (!_beg_time_goods) {
        _beg_time_goods = [NSMutableArray array];
    }
    return _beg_time_goods;
}

- (NSMutableArray*)end_goods{
    if (!_end_goods) {
        _end_goods = [NSMutableArray array];
    }
    return _end_goods;
}

- (NSMutableArray*)end_time_goods{
    if (!_end_time_goods) {
        _end_time_goods = [NSMutableArray array];
    }
    return _end_time_goods;
}



- (void)timeShopModeListWithCount:(NSInteger)count page:(NSInteger)page{
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pid"] = @"ios";
    dict[@"ver"] =  [UtilTool currentVersion];
    dict[@"ts"] = timeSp;
    dict[@"type"] = [NSNumber numberWithInt:count];
    dict[@"page"] = [NSNumber numberWithInt:page];
    dict[@"shop_id"] = [NSNumber numberWithInt:kSubShopID];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_TimeToBuy httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dict completion:^(URLFeedData *retData) {
        
        if(retData.code != 0){
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeShopModerWithFailed:)]) {
                [self.delegate timeShopModerWithFailed:retData.errorDesc];
            }
            
        }else{
            
            NSArray *array = retData.data[@"data"];
            NSRange range = NSMakeRange(0, 3);
            NSArray *goods = [array subarrayWithRange:range];
            
            for (NSDictionary *dic in goods) {
                //开始时间
                NSTimeInterval beg_time = [dic[@"begin_time"] longLongValue];
                NSTimeInterval end_time = [dic[@"end_time"] longLongValue];
                 TimeShopData *moder = [[TimeShopData alloc]initWithDict:dic];
                
                 //判断
                [self moreTimeWithBeg_time:beg_time end_time:end_time timeShopData:moder scareBuyingN:moder.scare_buying_number];
                
                [self.goodsA addObject:moder];
                
               //取出时间
                [self.beg_goods addObject:dic[@"begin_time"]];
                [self.end_goods addObject:dic[@"end_time"]];
            
            }
            
            
            NSRange range1 = NSMakeRange(3,array.count - 3);
            NSArray *timeGoods = [array subarrayWithRange:range1];
            for (NSDictionary *dict in timeGoods) {
                //开始时间
                NSTimeInterval beg_time = [dict[@"begin_time"] longLongValue];
                NSTimeInterval end_time = [dict[@"end_time"] longLongValue];
              TimeShopData *moder = [[TimeShopData alloc]initWithDict:dict];
                
                //判断
                [self moreTimeWithBeg_time:beg_time end_time:end_time timeShopData:moder scareBuyingN:moder.scare_buying_number];
               
                
                [self.timeGoodsA addObject:moder];
                
              
                //取出时间
                [self.beg_time_goods addObject:dict[@"begin_time"]];
                [self.end_time_goods addObject:dict[@"end_time"]];
            }
            
            __block TimeShopModer *blockModer = self;
            //代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeShopModerWithGoodArr:timeGoods:beg_goods:beg_time_goods:end_goods:end_time_goods:)]) {
                 [blockModer setStatus:E_ModelDataStatus_LoadSucceed];
                [self.delegate timeShopModerWithGoodArr:self.goodsA timeGoods:self.timeGoodsA beg_goods:self.beg_goods beg_time_goods:self.beg_time_goods end_goods:self.end_goods end_time_goods:self.end_time_goods];
            }
            
            
        }
    }];

    }



- (void)pullUpRefreshWithCount:(NSInteger)count{
    
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pid"] = @"ios";
    dict[@"ver"] =  [UtilTool currentVersion];
    dict[@"ts"] = timeSp;
    dict[@"type"] = [NSNumber numberWithInt:1];
    dict[@"page"] = [NSNumber numberWithInt:count];
    dict[@"shop_id"] = [NSNumber numberWithInt:kSubShopID];
    
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_TimeToBuy httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dict completion:^(URLFeedData *retData) {
        
        if(retData.code != 0){     
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeShopModerWithFailed:)]) {
                [self.delegate timeShopModerWithFailed:retData.errorDesc];
            }
            
        }else{
          
            NSArray *array = retData.data[@"data"];
            for (NSDictionary *dict in array) {
                NSTimeInterval beg_time = [dict[@"begin_time"] longLongValue];
                NSTimeInterval end_time = [dict[@"end_time"] longLongValue];
                TimeShopData *moder = [[TimeShopData alloc]initWithDict:dict];
                
                [self moreTimeWithBeg_time:beg_time end_time:end_time timeShopData:moder scareBuyingN:moder.scare_buying_number];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(pullUpRefreshWithData:beg_time:end_time:)]) {
                    [self.delegate pullUpRefreshWithData:moder beg_time:dict[@"begin_time"] end_time:dict[@"end_time"]];
                }


            }
            
        }
    }];
    
}
    


//
- (void)moreTimeWithBeg_time:(NSTimeInterval)beg_time end_time:(NSTimeInterval)end_time timeShopData:(TimeShopData*)moder scareBuyingN:(NSString*)scarceBuyingN{
    NSUInteger count = [scarceBuyingN integerValue];
    
    
    NSDate *now_date = [NSDate date];
    NSTimeInterval nowTime = [now_date timeIntervalSince1970];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //比较时间
    NSDate *end_date = [NSDate dateWithTimeIntervalSince1970:end_time];
    NSDateComponents *com = [cal components:unit fromDate:now_date toDate:end_date options:0];
    moder.time_countdown = [NSString stringWithFormat:@"%02d:%02d:%02d",com.hour,com.minute,com.second];
    moder.top_time_countdown = [NSString stringWithFormat:@"%02d:%02d:%02d",com.hour,com.minute,com.second];
    
    if (nowTime > beg_time) {
        moder.beg_imageHidden = YES;
        moder.downHidden = NO;
        moder.end_Image_Hidden = YES;
        
        if (nowTime > end_time) {
            moder.beg_imageHidden = YES;
            moder.downHidden = YES;
            moder.end_Image_Hidden = NO;
        }else{
            moder.beg_imageHidden = YES;
            moder.downHidden = NO;
            moder.end_Image_Hidden = YES;
        }
        
        if (count <= 0) {
            moder.beg_imageHidden = YES;
            moder.downHidden = YES;
            moder.end_Image_Hidden = NO;
        }
        
        
    }else {
        moder.beg_imageHidden = NO;
        moder.downHidden = YES;
        moder.end_Image_Hidden = YES;
    }
}




@end
