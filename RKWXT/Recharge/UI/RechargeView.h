//
//  RechargeView.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RechargeViewHeight (160)
#define ViewNormalDistance (150)
#define ViewBigDistance    (1000)
#define ViewUpDistance     (100)

@interface RechargeView : UIView
@property (nonatomic,strong) NSString *rechargeUserphoneStr;
-(void)removeNotification;

@end
