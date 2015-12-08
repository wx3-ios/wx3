//
//  ShopUnionHotGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopUnionHotGoodsEntity : NSObject
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) CGFloat marketPrice;

+(ShopUnionHotGoodsEntity*)initHotGoodsEntityWithDic:(NSDictionary*)dic;

@end
