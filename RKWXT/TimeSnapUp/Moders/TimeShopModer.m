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
            //现在时间
            NSDate *date = [NSDate date];
            NSTimeInterval nowTime = [date timeIntervalSince1970];
           
            
            NSArray *array = retData.data[@"data"];
            NSRange range = NSMakeRange(0, 3);
            NSArray *goods = [array subarrayWithRange:range];
            
            for (NSDictionary *dic in goods) {
                //开始时间
                NSTimeInterval beg_time = [dic[@"begin_time"] longLongValue];
                NSTimeInterval end_time = [dic[@"end_time"] longLongValue];
                
                TimeShopData *moder = [[TimeShopData alloc]initWithDict:dic];
                if (nowTime > beg_time) {
                    moder.beg_imageHidden = YES;
                    moder.downHidden = NO;
                    moder.end_Image_Hidden = YES;
                    
                    if (nowTime > end_time) {
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
                if (nowTime > beg_time) {
                    moder.beg_imageHidden = YES;
                    moder.downHidden = NO;
                    moder.end_Image_Hidden = YES;
                    
                    if (nowTime > end_time) {
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
                 [self.timeGoodsA addObject:moder];
                
                //取出时间
                //取出时间
                [self.beg_time_goods addObject:dict[@"begin_time"]];
                [self.end_time_goods addObject:dict[@"end_time"]];
            }
            
            
            //代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeShopModerWithGoodArr:timeGoods:beg_goods:beg_time_goods:end_goods:end_time_goods:)]) {
               
                [self.delegate timeShopModerWithGoodArr:self.goodsA timeGoods:self.timeGoodsA beg_goods:self.beg_goods beg_time_goods:self.beg_time_goods end_goods:self.end_goods end_time_goods:self.end_time_goods];
            }
            
            
        }
    }];

    }


@end
