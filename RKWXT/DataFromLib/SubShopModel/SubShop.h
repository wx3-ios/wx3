//
//  SubShopOBJ.h
//  Woxin2.0
//
//  Created by Elty on 10/16/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubShop : NSObject
@property (nonatomic,assign)NSInteger subShopID;//分店ID
@property (nonatomic,retain)NSString *shopName;//分店名称
@property (nonatomic,retain)NSString *shopImage;//店面图片
@property (nonatomic,assign)BOOL isSelected;

+ (SubShop*)subShopWithDictionary:(NSDictionary*)dic;

@end