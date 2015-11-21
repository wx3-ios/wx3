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
#import "UserLocation.h"

@interface WXShopUnionVC(){
    UserLocation *userLocation;
}
@end

@implementation WXShopUnionVC

-(id)init{
    self = [super init];
    if(self){
        userLocation = [[UserLocation alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家联盟"];
    [userLocation startLocation];
    [self addNotification];
    
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setTitle:@"城市" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(gotoCityListVC) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:leftBtn];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationSucceed) name:K_Notification_Name_UserLocation_Succeed object:nil];
}

-(void)userLocationSucceed{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [UtilTool showAlertView:[NSString stringWithFormat:@"定位城市－%@",userObj.userLocationCity]];
}

-(void)gotoCityListVC{
    WXShopCityListVC *cityListVC = [[WXShopCityListVC alloc] init];
    cityListVC.titleStr = @"深圳";
    [self presentViewController:cityListVC animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
