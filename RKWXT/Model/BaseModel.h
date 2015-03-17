//
//  BaseModel.h
//  Woxin2.0
//
//  Created by Elty on 11/24/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	E_ModelDataStatus_Init = 0, //初始状态
	E_ModelDataStatus_Loading,//正在加载~
	E_ModelDataStatus_LoadFailed,//加载失败
	E_ModelDataStatus_LoadSucceed,//加载成功
}E_ModelDataStatus;

//调用接口的返回值
typedef enum {
	E_LoadDataReturnValue_UnDetermined = -1,//不确定
	E_LoadDataReturnValue_Succeed = 0,//调用接口成功
	E_LoadDataReturnValue_ISLoading, //正在加载~
	E_LoadDataReturnValue_ISLoaded,//已经加载过了~
	E_LoadDataReturnValue_Failed,//调用接口失败
}E_LoadDataReturnValue;

@protocol BaseModelMark <NSObject>
@optional
- (void)serviceConnectedOK;
@end

@interface BaseModel : NSObject <BaseModelMark>
@property (nonatomic,assign)E_ModelDataStatus status;

- (E_LoadDataReturnValue)checkReturnValueInAdvance;
- (void)toInit; //返回初始状态~
@end