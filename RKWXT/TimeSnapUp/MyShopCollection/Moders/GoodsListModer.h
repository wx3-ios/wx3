//
//  GoodsListModer.h
//  RKWXT
//
//  Created by app on 15/11/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoodsListModerDelegate  <NSObject>
//成功
- (void)requestNotWorkSuccessful:(NSMutableArray*)goodsID;
//失败
- (void)requestNotWorkFailure:(NSString*)error;
@end
@interface GoodsListModer : NSObject
@property (nonatomic,strong)NSMutableArray *goodsID;
@property (nonatomic,weak)id<GoodsListModerDelegate> delegate;
//网络请求
- (void)requestNotWork:(NSInteger)type;
@end
