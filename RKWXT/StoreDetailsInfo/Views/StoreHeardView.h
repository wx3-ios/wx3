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

- (void)storeHeardViewWihthPhone:(StoreHeardView*)heardView;

@end
@interface StoreHeardView : UIView
@property (nonatomic,weak)id<StoreHeardViewDelegate> delegate;
@end
