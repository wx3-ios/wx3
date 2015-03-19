//
//  KeyPadView.h
//  Woxin2.0
//
//  Created by le ting on 7/31/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIView.h"

#define kTopYGap (kIsAppModePublic?1.0:3.0)
#define kBtnGap (1.0)
#define kBtnHeight (IS_IPHONE_5?60.0:50.0)
#define kYBtnNumber (5)
#define kXbtnNumber (3)
#define kKeyPadHeight (kBtnHeight*kYBtnNumber + kTopYGap + (kYBtnNumber-1)*kBtnGap)

typedef enum {
    E_KeyPad_Form_Down,
    E_KeyPad_Form_PartUp,
    E_KeyPad_Form_TotalUp,
}E_KeyPad_State;

@protocol KeyPadViewDelegate;
@interface KeyPadView : WXUIView
@property (nonatomic,assign)id<KeyPadViewDelegate>delegate;
@property (nonatomic,assign)E_KeyPad_State status;

@end

@protocol KeyPadViewDelegate <NSObject>
- (void)intputCharacter:(NSString*)ch;
- (void)keyBoardDown;
- (void)makeCall;
- (void)delSingleCharacter;
- (void)delAllCharacter;
@end
