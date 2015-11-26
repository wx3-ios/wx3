//
//  WXShopUnionVC.m
//  RKWXT
//
//  Created by SHB on 15/11/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionVC.h"
#import "WXShopUnionDef.h"

#define Size self.bounds.size

@interface WXShopUnionVC()<ShopUnionDropListViewDelegate>{
    WXShopUnionAreaView *_areaListView;
    BOOL showAreaview;
    WXUIButton *rightBtn;
}
@end

@implementation WXShopUnionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    showAreaview = YES;
    if(rightBtn){
        [self changeCity];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家联盟"];
    
    CGFloat btnWidth = 85;
    CGFloat btnHeight = 25;
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Size.width-btnWidth-5, 66-btnHeight-10, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:userObj.userCurrentCity forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(14.0)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, btnWidth-15, 0, 0)];
    [rightBtn addTarget:self action:@selector(showAreaView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
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

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(gotoCityListVC) name:K_Notification_Name_ShopUnionAreaViewCityChoose object:nil];
    [defaultCenter addObserver:self selector:@selector(maskViewClicked) name:K_Notification_Name_MaskviewClicked object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showAreaView{
    if(showAreaview){
        showAreaview = NO;
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListUpImg.png"] forState:UIControlStateNormal];
    }else{
        showAreaview = YES;
        [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    }
}

#pragma mark cityAreaDelegate
-(void)changeCityArea:(id)entity{
    NSString *name = entity;
    [rightBtn setTitle:name forState:UIControlStateNormal];
    [self showAreaView];
}

-(void)changeCity{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [rightBtn setTitle:userObj.userCurrentCity forState:UIControlStateNormal];
}

#pragma mark tocityList
-(void)gotoCityListVC{
    [_areaListView unshow:YES];
    [rightBtn setImage:[UIImage imageNamed:@"GoodsListDownImg.png"] forState:UIControlStateNormal];
    WXShopCityListVC *cityListVC = [[WXShopCityListVC alloc] init];
    [self presentViewController:cityListVC animated:YES completion:^{
    }];
}

-(void)maskViewClicked{
    [self showAreaView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
