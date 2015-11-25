//
//  WXShopUnionVC.m
//  RKWXT
//
//  Created by SHB on 15/11/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionVC.h"
#import "WXShopUnionDef.h"

@interface WXShopUnionVC()<ShopUnionDropListViewDelegate>{
    UserLocation *userLocation;
    
    WXShopUnionAreaView *_areaListView;
    BOOL showAreaview;
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
    
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"城市" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoCityListVC) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:rightBtn];
    
    //下拉区域列表
    showAreaview = YES;
    _areaListView = [self createAreaDropListViewWith:rightBtn];
    [_areaListView unshow:NO];
    [self addSubview:_areaListView];
    
    [[LocalAreaModel shareLocalArea] loadLocalAreaData];
}

-(WXShopUnionAreaView*)createAreaDropListViewWith:(WXUIButton*)btn{
    CGFloat width = self.bounds.size.width;
    CGFloat height = 300;
    CGRect rect = CGRectMake(0, 0, width, height);
    _areaListView = [[WXShopUnionAreaView alloc] initWithFrame:self.bounds menuButton:btn dropListFrame:rect];
    [_areaListView setDelegate:self];
    return _areaListView;
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationSucceed) name:K_Notification_Name_UserLocation_Succeed object:nil];
}

-(void)userLocationSucceed{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [UtilTool showAlertView:[NSString stringWithFormat:@"定位城市－%@",userObj.userLocationCity]];
}

-(void)gotoCityListVC{
//    WXShopCityListVC *cityListVC = [[WXShopCityListVC alloc] init];
//    cityListVC.titleStr = @"深圳";
//    [self presentViewController:cityListVC animated:YES completion:nil];
    
    if(showAreaview){
        showAreaview = NO;
        [_areaListView selectCityArea];
    }else{
        showAreaview = YES;
    }
}

-(void)changeCityArea{

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
