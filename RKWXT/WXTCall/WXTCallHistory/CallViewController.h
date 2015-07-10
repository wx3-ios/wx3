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

//iphone6  宽，高  (375,667)
//iphone6p 宽，高  (414,736)
#define DIphoneSixWidth   (375)
#define DIphoneSixHeight  (667)
#define DIphoneSixPWidth  (414)
#define DIphoneSixPHeight (736)

#define kInputChange        @"InputChange"
#define NumberBtnHeight (48)
#define InputTextHeight (35)
#define yGap (66)

#define IphoneSixYGap (118)
#define IphoneSixPYgap (168)

@protocol CallPhoneDelegate,WXKeyPadModelDelegate;
@interface CallViewController : WXUIViewController<WXKeyPadModelDelegate>
@property (nonatomic,assign) id<CallPhoneDelegate>callDelegate;

@property (nonatomic,assign) DownView_Type downview_type;
@property (nonatomic,assign) E_KeyPad_Type keyPad_type;
-(void)addNotification;
-(void)setEmptyText;
@end

@protocol CallPhoneDelegate <NSObject>
-(void)callPhoneWith:(NSString*)phoneStr andPhoneName:(NSString*)phoneName;

@end
