//
//  StoreListModer.h
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoreListModer;
@protocol  StoreListModerDelegate <NSObject>
//请求网络数据
- (void)storeListWithData:(StoreListModer*)moder;
//请求网络数据失败
- (void)storeListWithFailure:(StoreListModer*)moder;
//查看是否收藏
- (void)storeListWithShare:(StoreListModer*)moder;

@end

@interface StoreListModer : NSObject
//请求网络数据
- (void)requestWithNetWork;
//保存收藏
- (void)saveCollection;

@end
