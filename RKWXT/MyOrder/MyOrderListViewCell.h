//
//  MyOrderListViewCell.h
//  Woxin2.0
//
//  Created by qq on 14-8-11.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol UseRedPagerDelegate;
@interface MyOrderListViewCell : WXUITableViewCell
@property (nonatomic,assign) id<UseRedPagerDelegate>delegate;
@end

@protocol UseRedPagerDelegate <NSObject>
-(void)useRedPager:(id)entity;

@end
