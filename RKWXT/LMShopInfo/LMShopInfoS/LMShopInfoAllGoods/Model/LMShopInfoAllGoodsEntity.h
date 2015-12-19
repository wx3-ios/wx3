//
//  LMShopInfoAllGoodsEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShopInfoAllGoodsEntity : NSObject
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,assign) CGFloat marketPrice;
@property (nonatomic,assign) CGFloat shopPrice;
@property (nonatomic,assign) NSInteger shopID;
@property (nonatomic,assign) NSInteger addTime;

+(LMShopInfoAllGoodsEntity*)initLMShopInfoAllGoodsListEntity:(NSDictionary*)dic;

@end
