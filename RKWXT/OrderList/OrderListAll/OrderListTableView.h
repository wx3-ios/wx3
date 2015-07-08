//
//  OrderListTableView.h
//  RKWXT
//
//  Created by SHB on 15/7/7.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kPRStateNormal = 0,
    kPRStatePulling = 1,
    kPRStateLoading = 2,
    kPRStateHitTheEnd = 3
} KPRState;

@interface OrderListView : UIView {
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    BOOL _loading;
}
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) KPRState state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;
@end

@protocol PullingRefreshTableViewDelegate;

@interface OrderListTableView : WXUITableView<UIScrollViewDelegate>{
    OrderListView *_headerView;
    OrderListView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}

@property (assign,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

@end

@protocol PullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(OrderListTableView *)tableView;

@optional
- (void)pullingTableViewDidStartLoading:(OrderListTableView *)tableView;
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;
@end
