//
//  ShopUnionClassifyEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopUnionClassifyEntity : NSObject
@property (nonatomic,assign) NSInteger industryID;
@property (nonatomic,strong) NSString *industryName;
@property (nonatomic,strong) NSString *industryImg;

+(ShopUnionClassifyEntity*)initClassifyEntityWithDic:(NSDictionary*)dic;

@end
