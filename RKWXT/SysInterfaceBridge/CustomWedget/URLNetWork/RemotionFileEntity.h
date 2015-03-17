//
//  RemotionFileEntity.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //初始状态
    E_Remotion_File_Status_Init = 0,
    //正在下载状态
    E_Remotion_File_Status_InDownload,
    //下载失败
    E_Remotion_File_Status_Failed,
    //下载成功
    E_Remotion_File_Status_Succeed,
}E_Remotion_File_Status;

//远程图片的状态
@interface RemotionFileEntity : NSObject
@property (nonatomic,assign)E_Remotion_File_Status status;

@end
