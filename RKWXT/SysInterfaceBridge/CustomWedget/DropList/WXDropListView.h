//
//  WXDropListView.h
//  DropList
//
//  Created by le ting on 5/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXDropListItem.h"

typedef enum {
    //默认为向右边
    E_DropDirection_Right = 0,
    E_DropDirection_Left,
}E_DropDirection;

@protocol WXDropListViewDelegate;
@interface WXDropListView : UIView
@property (nonatomic,retain)UIFont *font;
@property (nonatomic,retain)UIColor *textColor;
//数据~
@property (nonatomic,retain)NSArray *dataList;
@property (nonatomic,assign)E_DropDirection dropDirection;
@property (nonatomic,assign)id<WXDropListViewDelegate>delegate;

//frame 外部调用只能设置一次frame
- (id)initWithFrame:(CGRect)frame menuButton:(WXUIButton*)memuButton dropListFrame:(CGRect)dropListFrame;
- (void)showAnimated:(BOOL)animated;
- (void)unshow:(BOOL)animated;
@end

@protocol WXDropListViewDelegate <NSObject>
- (void)menuClickAtIndex:(NSInteger)index;
@end
