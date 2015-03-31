//
//  MallEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Mall_UnShow = 0,   //不显示商城
    Mall_Show,
}Mall_Type;

@interface MallEntity : NSObject
@property (nonatomic,assign) Mall_Type mall_type;
@property (nonatomic,strong) NSString *mall_update;
@property (nonatomic,strong) NSString *mall_url;

+(MallEntity*)initMallDataWithDic:(NSDictionary*)dic;

@end
