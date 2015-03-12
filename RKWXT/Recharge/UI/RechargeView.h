//
//  RechargeView.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RechargeViewHeight (133)

@protocol RechargeViewDelegate;
@interface RechargeView : UIView
@property (nonatomic,assign) id<RechargeViewDelegate>delegate;
@end

@protocol RechargeViewDelegate <NSObject>
-(void)rechargeCancel;
-(void)rechargeSubmitBaseData;

@end
