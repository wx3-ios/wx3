//
//  T_SettingSwitchCell.h
//  RKWXT
//
//  Created by SHB on 15/6/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol SettingKeyPadToneDelegate;
@interface T_SettingSwitchCell : WXUITableViewCell
@property (nonatomic,assign) id<SettingKeyPadToneDelegate>delegate;
-(void)setSwitchIsOn:(BOOL)on;
@end

@protocol SettingKeyPadToneDelegate <NSObject>
-(void)keyPadToneSetting:(WXUISwitch*)s;

@end
