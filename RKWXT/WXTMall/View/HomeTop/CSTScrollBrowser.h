//
//  CSTScrollBrowser.h
//  Woxin2.0
//
//  Created by qq on 14-7-28.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSTScrollBrowserDataSource;

@interface CSTScrollBrowser : UIView
@property (nonatomic,assign) id<CSTScrollBrowserDataSource>dataSource;
@property (nonatomic,assign) id<UIScrollViewDelegate>scrollDelegate;

//CSTScrollBrowser被add到superview之后就不能再次修改了~
@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,retain) NSArray *subScrollViews;
@property (nonatomic,assign) BOOL pagingEnabled;

-(void)reload;
- (void)removeAllSubView;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
@end

@protocol CSTScrollBrowserDataSource <NSObject>
- (NSInteger)numberOfPage;

@end
