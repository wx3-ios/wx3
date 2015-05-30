//
//  HomePageTopEntity.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HomePage_TopType_URL,
}HomePage_TopType;

//typedef enum{
//    HomePage_TopType_URL,
//}HomePage_TopIDType;

@interface HomePageTopEntity : NSObject
@property (nonatomic,assign) NSInteger sort; //置顶排序
@property (nonatomic,assign) HomePage_TopType topType;//top_id
//@property (nonatomic,assign) HomePage_TopIDType topIdType;//top_type_id
@property (nonatomic,assign) NSInteger linkAddress; //链接地址
@property (nonatomic,strong) NSString *topImg; //图片URL

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary*)dic;

@end
