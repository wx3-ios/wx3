//
//  LMCollectionVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMCollectionVC.h"
#import "DLTabedSlideView.h"

enum{
    LMCollection_Goods = 0,
    LMCollection_Shop,
    
    LMCollection_Invalid,
};

@interface LMCollectionVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}

@end
@implementation LMCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"收藏"];
    
    tabedSlideView = [[DLTabedSlideView alloc] init];
    tabedSlideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [tabedSlideView setDelegate:self];
    
    [tabedSlideView setBaseViewController:self];
    [tabedSlideView setTabItemNormalColor:WXColorWithInteger(0x646464)];
    [tabedSlideView setTabItemSelectedColor:WXColorWithInteger(0xdd2726)];
    [tabedSlideView setTabbarTrackColor:[UIColor redColor]];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"商品" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"店铺" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = 0;
    [self addSubview:tabedSlideView];
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case LMCollection_Goods:
        {
//            LMAllOrderListVC *listAll = [[LMAllOrderListVC alloc] init];
//            return listAll;
        }
            break;
        case LMCollection_Shop:
        {
//            LMAllOrderListVC *listAll = [[LMAllOrderListVC alloc] init];
//            return listAll;
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
