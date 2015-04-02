//
//  FindEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    Find_YgapType_None = 0,
    Find_YgapType_BigSpace,     //大空格
    Find_YgapType_TwoBigSpace,  //两倍大空格
    Find_YgapType_SmallSpace,   //小空格
}Find_YgapType;

@interface FindEntity : NSObject
@property (nonatomic,strong) NSString *webUrl;
@property (nonatomic,strong) NSString *icon_url;
@property (nonatomic,assign) Find_YgapType find_ygap;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;

+(FindEntity*)initFindEntityWith:(NSDictionary*)dic;
+(FindEntity*)initFindTGapWith:(NSDictionary*)dic;

@end
