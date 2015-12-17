//
//  LMSellerInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMSellerInfoEntity : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSArray *imgUrlArr;
@property (nonatomic,strong) NSString *sellerImg;
@property (nonatomic,strong) NSString *sellerName;
@property (nonatomic,strong) NSString *sellerPhone;

//商家下的店铺
@property (nonatomic,strong) NSString *shopImg;
@property (nonatomic,strong) NSString *shopName;

//店铺下的信息
@property (nonatomic,strong) NSArray *shopArr;
@property (nonatomic,strong) NSString *goodsImg;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) NSInteger shopID;

+(LMSellerInfoEntity*)initSellerInfoEntity:(NSDictionary*)dic;
+(LMSellerInfoEntity*)initShopListEntity:(NSDictionary*)dic;
+(LMSellerInfoEntity*)initShopInfoEtity:(NSDictionary*)dic;

@end
