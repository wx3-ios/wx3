//
//  CallViewController.h
//  AiCall
//
//  Created by jjyo.kwan on 13-11-26.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//
#define KeyboardDur (0.4)

typedef enum{
    DownView_Init = 0,
    DownView_show,
    DownView_Del,
}DownView_Type;

//键盘
typedef enum{
    E_KeyPad_Noraml = 0,
    E_KeyPad_Show,
    E_KeyPad_Down,
}E_KeyPad_Type;
#define kInputChange        @"InputChange"

@interface CallViewController : BaseVC

@property (nonatomic,assign) DownView_Type downview_type;
@property (nonatomic,assign) E_KeyPad_Type keyPad_type;

@end
