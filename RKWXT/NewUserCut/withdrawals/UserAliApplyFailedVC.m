//
//  UserAliApplyFailedVC.m
//  RKWXT
//
//  Created by SHB on 16/4/25.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserAliApplyFailedVC.h"
#import "ConfirmUserAliPayVC.h"
#import "UserAliEntity.h"

#define BgViewHeight (187)
#define size self.bounds.size

@interface UserAliApplyFailedVC (){
    UserAliEntity *aliEntity;
}

@end

@implementation UserAliApplyFailedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"验证失败"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    aliEntity = _entity;
    
    [self createStaticView];
}

-(void)createStaticView{
    CGFloat yOffset = 40;
    CGFloat imgWidth = 60;
    CGFloat imgHeight = imgWidth;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake((size.width-imgWidth)/2, yOffset, imgWidth, imgHeight);
    [imgView setImage:[UIImage imageNamed:@"UserAliAccountFailed.png"]];
    [self addSubview:imgView];
    
    yOffset += imgHeight+10;
    CGFloat labelWidth = 150;
    CGFloat labelHeight = 43;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((size.width-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"审核失败"];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:WXFont(17.0)];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [self addSubview:textLabel];
    
    yOffset += labelHeight;
    labelWidth = 200;
    WXUILabel *infoLabel = [[WXUILabel alloc] init];
    infoLabel.frame = CGRectMake((size.width-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setText:aliEntity.refuseMsg];
    if(!aliEntity.refuseMsg){
        [infoLabel setText:@"支付宝审核失败，请重试"];
    }
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setFont:WXFont(17.0)];
    [infoLabel setTextColor:WXColorWithInteger(0x000000)];
    [infoLabel setNumberOfLines:0];
    [self addSubview:infoLabel];
    
    yOffset += labelHeight+30;
    CGFloat btnWidth = 150;
    CGFloat btnHeight = 35;
    WXUIButton *resetBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [resetBtn setTitle:@"重新绑定支付宝" forState:UIControlStateNormal];
    [resetBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(gotoApplyAliAccountVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
}

-(void)gotoApplyAliAccountVC{
    ConfirmUserAliPayVC *confirmVC = [[ConfirmUserAliPayVC alloc] init];
    confirmVC.titleString = @"验证信息";
    confirmVC.aliAcount = aliEntity.aliCount;
    confirmVC.userName = aliEntity.aliName;
    confirmVC.confirmType = Confirm_Type_Change;
    [self.wxNavigationController pushViewController:confirmVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end