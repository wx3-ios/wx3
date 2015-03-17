//
//  RechargeView.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RechargeViewHeight (133)
#define ViewNormalDistance (200)
#define ViewBigDistance    (1000)
#define ViewUpDistance     (100)

@protocol RechargeViewDelegate;
@interface RechargeView : UIView
@property (nonatomic,assign) id<RechargeViewDelegate>delegate;
-(void)removeNotification;
@end

@protocol RechargeViewDelegate <NSObject>
-(void)rechargeCancel;

@end
