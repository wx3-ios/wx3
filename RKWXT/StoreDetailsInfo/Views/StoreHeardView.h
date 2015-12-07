//
//  StoreHeardView.h
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIScrollView.h"
@class  StoreHeardView;
@protocol StoreHeardViewDelegate <NSObject>
//点击拨打电话
- (void)storeHeardViewWihthPhone:(StoreHeardView*)heardView;
//点击轮播图片
- (void)storeHeardView:(StoreHeardView*)heardView  index:(int)index;
@end


@interface StoreHeardView : UIView
@property (nonatomic,weak)id<StoreHeardViewDelegate> delegate;
@end
