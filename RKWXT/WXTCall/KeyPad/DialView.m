//
//  DialView.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-5.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "DialView.h"
#import "UIView+Sizing.h"

#import <AudioToolbox/AudioToolbox.h>

enum KeyTags {
    KEY_S = 1200,
    KEY_1,
    KEY_2,
    KEY_3,
    KEY_4,
    KEY_5,
    KEY_6,
    KEY_7,
    KEY_8,
    KEY_9,
    KEY_0,
    KEY_P
};

@implementation DialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.inputNumber = [NSMutableString string];
    _inputLabel.text = self.inputNumber;
    _sipButton.selected = [USER_DEFAULT boolForKey:kUserAgentSipCall];
}


- (void)updateInputData
{
    _inputLabel.text = _inputNumber;
    _placeholderLabel.hidden = _inputNumber.length > 0;
}

- (void)cleanAll
{
    _inputNumber.string = @"";
    [self updateInputData];
}


//按键
- (IBAction)keypadAction:(id)sender
{
    NSInteger tag = [sender tag];
    int index = (tag - 1200) % 10;
    NSString *number = [KEY_NUMBER substringWithRange:NSMakeRange(index, 1)];
    [_inputNumber appendString:number];
    //[self displayInputNumber];
    
    [self updateInputData];
    
    //播放按键音
    if (![self silenced]) {
        AudioServicesPlaySystemSound(tag);
    }
    if ([USER_DEFAULT boolForKey:kUserAgentVibration]) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }
}

//删除
- (IBAction)deleteAction:(id)sender
{
    int length = _inputNumber.length;
    if (length > 0) {
        [_inputNumber deleteCharactersInRange:NSMakeRange(length - 1, 1)];
    }
    [self updateInputData];
}

//长按删除
- (IBAction)deleteAllAction:(id)recognizer
{
    [self cleanAll];
}

//去显开关
- (IBAction)displayAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [USER_DEFAULT setBool:sender.selected forKey:kUserAgentDisplay];
}


//静音是否开启
-(BOOL)silenced
{
#if TARGET_IPHONE_SIMULATOR
    // return NO in simulator. Code causes crashes for some reason.
    return NO;
#endif
    
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
        return NO;
    else
        return YES;
}

//- (IBAction)sipAction:(id)sender
//{
//    _sipButton.selected = !_sipButton.selected;
//    [USER_DEFAULT setBool:_sipButton.selected forKey:kUserAgentSipCall];
//    [USER_DEFAULT synchronize];
//    if (_sipButton.selected) {
//        [[USER_AGENT sipAccount] connect];
//    }
//    else{
//        [[USER_AGENT sipAccount] disconnect];
//    }
//    
//}


@end
