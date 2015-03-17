//
//  LoadingEntity.h
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    E_LoadStatus_Loading,//正在加载
    E_LoadStatus_LoadSucceed,//加载成功
    E_LoadStatus_LoadFailed,//加载失败,
}E_LoadStatus;

@interface LoadingEntity : NSObject
@property (nonatomic,assign)E_LoadStatus loadStatus;

@end
