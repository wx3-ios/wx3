//
//  TimeShopModer.h
//  RKWXT
//
//  Created by app on 15/11/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeShopData;
@protocol TimeShopModerDelegate <NSObject>
//请求网络成功
- (void)timeShopModerWithGoodArr:(NSMutableArray*)goodsArr timeGoods:(NSMutableArray*)timeGoods beg_goods:(NSMutableArray*)beg_goods beg_time_goods:(NSMutableArray*)beg_time_goods end_goods:(NSMutableArray*)end_goods end_time_goods:(NSMutableArray*)end_time_goods;//请求网络失败
//刷新
- (void)pullUpRefreshWithData:(TimeShopData*)data  beg_time:(NSString*)beg_time end_time:(NSString*)end_time;



- (void)timeShopModerWithFailed:(NSString *)errorMsg;
@end

@interface TimeShopModer : NSObject
@property (nonatomic,weak)id<TimeShopModerDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *goodsA;
@property (nonatomic,strong)NSMutableArray *timeGoodsA;
//时间
@property (nonatomic,strong)NSMutableArray *beg_goods;
@property (nonatomic,strong)NSMutableArray *beg_time_goods;
@property (nonatomic,strong)NSMutableArray *end_goods;
@property (nonatomic,strong)NSMutableArray *end_time_goods;


- (void)timeShopModeListWithCount:(NSInteger)count  page:(NSInteger)page ;
- (void)pullUpRefreshWithCount:(NSInteger)count ;
@end
