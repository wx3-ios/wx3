//
//  WXKeyPadVC.h
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIViewController.h"

#import "KeyPadView.h"
@interface WXKeyPadVC : WXUIViewController
- (void)showKeyBoardStatus:(E_KeyPad_State)status animated:(BOOL)animated;
- (void)upKeyBoardButtonClicked;
@end
