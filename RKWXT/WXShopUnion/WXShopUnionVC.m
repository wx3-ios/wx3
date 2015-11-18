//
//  WXShopUnionVC.m
//  RKWXT
//
//  Created by SHB on 15/11/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionVC.h"
#import "WXShopCityListVC.h"
#import "LocalAreaModel.h"

@implementation WXShopUnionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家联盟"];
    
    [self createLeftNavBtn];
}

-(void)createLeftNavBtn{
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setTitle:@"城市" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(gotoCityListVC) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:leftBtn];
}

-(void)gotoCityListVC{
    WXShopCityListVC *cityListVC = [[WXShopCityListVC alloc] init];
    [self presentViewController:cityListVC animated:YES completion:nil];
}

@end
