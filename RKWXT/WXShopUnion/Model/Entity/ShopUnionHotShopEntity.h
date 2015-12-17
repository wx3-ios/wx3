//
//  ShopUnionHotShopEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopUnionHotShopEntity : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,assign) NSInteger sellerID;
@property (nonatomic,strong) NSString *sellerLogo;
@property (nonatomic,strong) NSString *sellerName;

+(ShopUnionHotShopEntity*)initShopUnionHotShopEntity:(NSDictionary*)dic;

@end
