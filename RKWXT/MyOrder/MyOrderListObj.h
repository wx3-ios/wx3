//
//  MyOrderListObj.h
//  Woxin2.0
//
//  Created by qq on 14-8-12.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define loadMyOrderListSucceed @"loadMyOrderListSucceed"
#define loadMyOrderListFailed  @"loadMyOrderListFailed"

@interface MyOrderListObj : NSObject
@property (nonatomic,retain) NSArray *orderListArr;
+ (MyOrderListObj *)sharedOrderList;
-(void)loadOrderList;
-(void)removeOrderList;
-(BOOL)isLoadOrderList;
@end

