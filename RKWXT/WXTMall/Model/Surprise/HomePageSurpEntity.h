//
//  HomePageSurpEntity.h
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageSurpEntity : NSObject

@property (nonatomic,assign) NSInteger goods_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *home_img;
@property (nonatomic,strong) NSString *goods_intro;
//@property (nonatomic,assign) CGFloat market_price;
@property (nonatomic,assign) CGFloat shop_price;

+(HomePageSurpEntity*)homePageSurpEntityWithDictionary:(NSDictionary*)dic;

@end