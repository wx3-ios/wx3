//
//  HomePageTopEntity.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageTopEntity : NSObject
@property (nonatomic,assign) NSInteger topType;//top_id
@property (nonatomic,assign) NSInteger linkID; //链接地址
@property (nonatomic,strong) NSString *topImg; //图片URL
@property (nonatomic,assign) NSInteger showPosition;  //显示位置  1.首页   5.发现

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary*)dic;

@end