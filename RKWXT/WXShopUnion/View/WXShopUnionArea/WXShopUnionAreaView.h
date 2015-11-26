//
//  WXShopUnionAreaView.h
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define K_Notification_Name_ShopUnionAreaViewCityChoose @"K_Notification_Name_ShopUnionAreaViewCityChoose"
#define K_Notification_Name_MaskviewClicked @"K_Notification_Name_MaskviewClicked"

@protocol ShopUnionDropListViewDelegate;

@interface WXShopUnionAreaView : WXUIView
@property (nonatomic,assign) id<ShopUnionDropListViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame menuButton:(WXUIButton*)menuButton dropListFrame:(CGRect)dropListFrame;
-(void)unshow:(BOOL)animated;

-(void)selectCityArea;
@end

@protocol ShopUnionDropListViewDelegate <NSObject>
-(void)changeCityArea:(id)entity;

@end
