//
//  UserWithdrawalsVC.m
//  RKWXT
//
//  Created by SHB on 15/9/28.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserWithdrawalsVC.h"

#define BgViewHeight (187)
#define size self.bounds.size

@interface UserWithdrawalsVC (){
    
}

@end

@implementation UserWithdrawalsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"验证"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    [self createStaticView];
}

-(void)createStaticView{
    WXUIView *bgView = [[WXUIView alloc] init];
    bgView.frame = CGRectMake(0, 0, size.width, BgViewHeight);
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    CGFloat yOffset = 40;
    CGFloat imgWidth = 60;
    CGFloat imgHeight = imgWidth;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake((size.width-imgWidth)/2, yOffset, imgWidth, imgHeight);
    [imgView setImage:[UIImage imageNamed:@"UserWithdrawals.png"]];
    [self addSubview:imgView];
    
    yOffset += imgHeight+19;
    CGFloat labelWidth = 150;
    CGFloat labelHeight = 43;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((size.width-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"支付宝验证已提交正在审核中..."];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:WXFont(17.0)];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setNumberOfLines:0];
    [self addSubview:textLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
