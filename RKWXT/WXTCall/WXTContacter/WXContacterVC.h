//
//  WXContacterVC.h
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIViewController.h"
#define kSearchBarHeight (44)

@protocol ToContactDetailVCDelegate;
@interface WXContacterVC : WXUIViewController{
    UILabel * _accessGrantedTip;
}
@property (nonatomic,assign) id<ToContactDetailVCDelegate>detailDelegate;
@end

@protocol ToContactDetailVCDelegate <NSObject>
-(void)toContailDetailVC:(id)sender;

@end
