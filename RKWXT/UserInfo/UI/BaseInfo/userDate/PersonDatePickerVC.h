//
//  PersonDatePickerVC.h
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

@protocol PersonDatePickerDelegate;
@interface PersonDatePickerVC : WXUIViewController
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,assign) id<PersonDatePickerDelegate>delegate;

@end

@protocol PersonDatePickerDelegate <NSObject>
-(void)didSelectDate:(NSString*)dateStr;

@end
