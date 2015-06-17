//
//  HomePageThmEntity.h
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageThmEntity : NSObject

@property (nonatomic,assign) NSInteger cat_id;//分类id
@property (nonatomic,strong) NSString *cat_intro;//分类描述
@property (nonatomic,assign) NSInteger sort;//排序
@property (nonatomic,strong) NSString *category_img;//分类图片
@property (nonatomic,strong) NSString *cat_name; //分类名称

+(HomePageThmEntity*)homePageThmEntityWithDictionary:(NSDictionary *)dic;

@end