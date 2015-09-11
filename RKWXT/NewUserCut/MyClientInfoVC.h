//
//  MyClientInfoVC.h
//  RKWXT
//
//  Created by SHB on 15/9/10.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "MyClientPersonModel.h"

@interface MyClientInfoVC : WXUIViewController
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,assign) MyClient_Grade client_grade;

@end
