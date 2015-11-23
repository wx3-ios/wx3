//
//  HeardView.h
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeardView,HeardGoodsView;
@protocol HeardViewDelegate <NSObject>

- (void)heardViewTouch:(HeardView*)heard;

@end

@interface HeardView : UIView
@property (nonatomic,strong)HeardGoodsView *goods;
@property (nonatomic,weak)id<HeardViewDelegate> delegate;
@property (nonatomic,strong)NSArray *goodsArray;
- (instancetype)initWithFrame:(CGRect)frame goodsArray:(NSArray*)goodsArray;
@end
