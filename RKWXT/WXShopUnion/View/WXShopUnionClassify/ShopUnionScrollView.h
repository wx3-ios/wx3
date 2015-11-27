//
//  ShopUnionScrollView.h
//  RKWXT
//
//  Created by SHB on 15/11/26.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

@protocol ShopUnionScrollViewDataSource;

@interface ShopUnionScrollView : WXUIView
@property (nonatomic,assign) id<ShopUnionScrollViewDataSource>dataSource;
@property (nonatomic,assign) id<UIScrollViewDelegate>scrollDelegate;

@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,retain) NSArray *subScrollViews;
@property (nonatomic,assign) BOOL pagingEnabled;

- (void)reload;
- (void)removeAllSubView;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
@end

@protocol ShopUnionScrollViewDataSource <NSObject>
- (NSInteger)numberOfPage;

@end
