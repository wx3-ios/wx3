//
//  IConstants.h
//  AiCall
//
//  Created by jjyo.kwan on 13-11-24.
//  Copyright (c) 2013年 jjyo.kwan. All rights reserved.
//


#ifndef AiCall_IConstants_h
#define AiCall_IConstants_h

#define __UMENG_SDK__
//#define __WJT_VOIP__ //直拨
//#define SIP_DOMAIN  @"113.31.65.226:5068"

#define __USE_COREDATA__
//#define __Jailbreaking__
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define sysVersion ([[UIDevice currentDevice].systemVersion doubleValue])

//软件build号
#define APP_BUILD   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//软件版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//设备型号iPhone, iPad or iPod
#define DEVICE_MODEL    [[UIDevice currentDevice] model]
//通知中心
#define NOTIFY_CENTER  [NSNotificationCenter defaultCenter]
//xml存档
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define KEY_WINDOW [[UIApplication sharedApplication] keyWindow]

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define DOC_URL        [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
#define DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00) >> 16))/255.0 green:((float)((rgbValue & 0xc4) >> 8))/255.0 blue:((float)(rgbValue & 0x96))/255.0 alpha:1.0]
//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:0.2 green:0.2 blue:0.1 alpha:0.0]//0xefeff4
#define UIColorFromARGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 green:((float)((argbValue & 0xFF00) >> 8))/255.0 blue:((float)(argbValue & 0xFF))/255.0 alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

//单例模式
#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#import "AppDelegate.h"
#import "UserAgent.h"
#define   ScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define   ScreenHeight   [[UIScreen mainScreen] bounds].size.height


#endif
