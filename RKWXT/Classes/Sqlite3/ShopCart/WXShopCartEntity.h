//
//  WXShopCartEntity.h
//  CallTesting
//
//  Created by le ting on 5/15/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXShopCartEntity : NSObject
@property (nonatomic,assign)NSInteger primaryID;
@property (nonatomic,retain)NSString *attribute;
@property (nonatomic,assign)NSInteger goodID;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,assign)CGFloat price;
@property (nonatomic,retain)NSString *priceTxt;
@property (nonatomic,assign)NSInteger goodNumber;
@property (nonatomic,retain)NSString *iconURL;
//数据从网络上是否补全了~
@property (nonatomic,assign)BOOL isReady;

//界面上的显示
@property (nonatomic,assign)BOOL isSelect;

@end
