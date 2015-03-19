//
//  KeyPadView.m
//  Woxin2.0
//
//  Created by le ting on 7/31/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "KeyPadView.h"
#import "UIImage+Render.h"
#import <AudioToolbox/AudioToolbox.h>

enum {
    E_KeyPadBtnType_Plus = 10,
    E_KeyPadBtnType_Del = 14,
};

static NSString *buttonIcon[] =
{
    @"1",
    @"2",
    @"3",
    @"4",
    @"5",
    @"6",
    @"7",
    @"8",
    @"9",
    @"*",
    @"0",
    @"#",
    @"keyBoardDown",
    @"dial",
    @"del",
};

#define kBtnWidth ((IPHONE_SCREEN_WIDTH - kBtnGap*(kXbtnNumber-1))/3.0)
@implementation KeyPadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		if (kIsAppModePublic){
			[self setBackgroundImage:[UIImage imageFromColor:WXColorWithInteger(0xcbcbcb)]];
		}else{
			[self setBackgroundImage:[UIImage imageNamed:@"keyPadBg.jpg"]];
		}
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        for(int y = 0; y < kYBtnNumber; y++){
            CGFloat yOffset = kTopYGap + y*(kBtnGap + kBtnHeight);
            for(int x = 0; x < kXbtnNumber; x++){
                CGFloat xOffset = x*(kBtnGap + kBtnWidth);
                UIImage *norImg = [UIImage imageFromColor:WXColorWithInteger(0xf0f0f0)];
                UIImage *selImg = [UIImage imageFromColor:WXColorWithInteger(0xd2d2d2)];
				if (kIsAppModePublic){
					norImg = [UIImage imageFromColor:WXColorWithInteger(0xececec)];
					selImg = [UIImage imageFromColor:WXColorWithInteger(0x0c8bdf)];
				}
                WXUIButton *button = [WXUIButton buttonWithFrame:CGRectMake(xOffset, yOffset, kBtnWidth, kBtnHeight) Target:self selector:@selector(buttonClicked:) norBgImg:norImg selBgImg:selImg disableBgImg:nil];
				if (!kIsAppModePublic){
					[button setAlpha:0.5];
					[button setBorderRadian:10.0 width:0 color:[UIColor clearColor]];
				}
                NSInteger tag = y*kXbtnNumber+x;
				NSString *imgNameBase = buttonIcon[tag];
				
				if (kIsAppModePublic){
					NSString *normalImgName = [NSString stringWithFormat:@"%@.png",imgNameBase];
					NSString *selImgName = [NSString stringWithFormat:@"%@Sel.png",imgNameBase];
					UIImage *norIcon = [UIImage imageNamed:normalImgName];
					UIImage *selIcon = [UIImage imageNamed:selImgName];
					if (norIcon){
						[button setImage:norIcon forState:UIControlStateNormal];
					}
					if (selIcon){
						[button setImage:selIcon forState:UIControlStateHighlighted];
						[button setImage:selIcon forState:UIControlStateSelected];
					}
				}else{
					NSString *imgName = [NSString stringWithFormat:@"%@.png",imgNameBase];
					UIImage *img = [UIImage imageNamed:imgName];
					UIImageView *imgView = [[UIImageView alloc] initWithFrame:button.frame];
					[imgView setContentMode:UIViewContentModeCenter];
					[imgView setImage:img];
					[self addSubview:imgView];
				}
				
				
                [button setTag:tag];
                if(E_KeyPadBtnType_Plus == tag || E_KeyPadBtnType_Del == tag){
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                    [button addGestureRecognizer:longPress];
                }
                [self addSubview:button];
            }
        }
//        [pool drain];
    }
    return self;
}

-(void)sound:(NSString *)strSound
{
    WXUserDefault *userDefault = [WXUserDefault sharedWXUserDefault];
    NSInteger value = [userDefault integerValueForKey:@"KeyPadTone"];
    if(value == 2){
        return;
    }
    NSString *string = [NSString stringWithFormat:@"dtmf-%@",strSound];
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"aif"];
    SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (void)buttonClicked:(id)sender{
    WXUIButton *button = sender;
    NSInteger tag = button.tag;
    NSString *ch = nil;
    switch (tag) {
        case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:
            ch = [NSString stringWithFormat:@"%d",(int)tag+1];
            break;
        case 9:
            ch = @"*";
            break;
        case 10:
            ch = @"0";
            break;
        case 11:
            ch = @"#";
            break;
        case 12:
            if(_delegate && [_delegate respondsToSelector:@selector(keyBoardDown)]){
                [_delegate keyBoardDown];
            }
            break;
        case 13:
            if(_delegate && [_delegate respondsToSelector:@selector(makeCall)]){
                [_delegate makeCall];
            }
            break;
        case 14:
            if(_delegate && [_delegate respondsToSelector:@selector(delSingleCharacter)]){
                [_delegate delSingleCharacter];
            }
            break;
        default:
            break;
    }
    if (ch){
        if(_delegate && [_delegate respondsToSelector:@selector(intputCharacter:)]){
            [_delegate intputCharacter:ch];
        }
        [self sound:ch];
    }
}

- (void)longPress:(UIGestureRecognizer*)recgnizer{
    UIGestureRecognizerState state = recgnizer.state;
    if(state == UIGestureRecognizerStateBegan){
        WXUIButton *button = (WXUIButton*)recgnizer.view;
        NSInteger tag = button.tag;
        switch (tag) {
            case E_KeyPadBtnType_Plus:
                if(_delegate && [_delegate respondsToSelector:@selector(intputCharacter:)]){
                    [_delegate intputCharacter:@"+"];
                }
                break;
            case E_KeyPadBtnType_Del:
                if(_delegate && [_delegate respondsToSelector:@selector(delAllCharacter)]){
                    [_delegate delAllCharacter];
                }
                break;
            default:
                break;
        }
    }
}

@end
