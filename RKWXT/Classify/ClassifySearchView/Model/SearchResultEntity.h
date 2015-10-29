//
//  SearchResultEntity.h
//  RKWXT
//
//  Created by SHB on 15/10/24.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultEntity : NSObject
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,assign) CGFloat market_price;
@property (nonatomic,assign) CGFloat shop_price;

+(SearchResultEntity*)initSearchResultEntityWith:(NSDictionary*)dic;

@end
