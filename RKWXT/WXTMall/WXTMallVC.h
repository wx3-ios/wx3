//
//  WXTMallVC.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

//#import "BaseViewController.h"

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

@interface WXTMallVC : BaseVC
@property (nonatomic,assign) DownView_Type downview_type;
@property (nonatomic,assign) E_KeyPad_Type keyPad_type;

@end
