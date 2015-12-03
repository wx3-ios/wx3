//
//  StoreListData.h
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreListData : NSObject
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *storeName;
@property (nonatomic,strong)NSArray *content;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
