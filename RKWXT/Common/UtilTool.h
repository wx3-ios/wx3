//
//  UtilTool.h
//  CallTesting
//
//  Created by le ting on 4/22/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilTool : NSObject

//淡入淡出
+(void)fadeOut:(UIView *)v withDuration:(float)d;
+(void)fadeIn: (UIView *)v withDuration:(float)d;

//得到日期时间格式为2012-9-3 12:20:00 type 1
//得到日期格式为2012-9-3 type 2
//得到时间格式为12:20:00 type 3
+(NSString*)getCurDateTime:(int)type;

+(NSString*)getDateTimeFor:(NSInteger)seconds type:(int)type;
//获取星期的字符串
typedef enum{
    E_SUN =0,
    E_MON,
    E_TUE,
    E_WED,
    E_THU,
    E_FRI,
    E_SAT,
    E_WEEK,
}EWeekDay;
+ (NSString*)getWeekDayString:(EWeekDay)index;
+ (NSString*)getDayString:(NSInteger)n;
+ (NSString*)getMonthString:(NSInteger)n;
+ (NSString*)getAMPMString:(NSInteger)n;

//分割字符串
+ (NSString*)getStringFrom:(NSString*)sourceString head:(NSString*)head tail:(NSString*)tail;

//设置边角圆角
+ (void)setTextViewVerticalCenter:(UITextView*)textView;
+ (void)copy:(NSString*)txt;

typedef enum{
    E_DEVICE_IPOD = 0,
    E_DEVICE_IPHONE,
    E_DEVICE_IPAD,
    
    E_DEVICE_INVALID,
}E_DEVICE_TYPE;
+ (E_DEVICE_TYPE)currentDeviceType;//设备类型
+ (NSString*)currentDeviceDescribtion;//设备名称
//将subView居中
+ (void)centerSubViews:(NSArray*)subViews in:(UIView*)superView;

//将GBK转化成UTF8
+ (NSData*)convertGBKDataToUTF8:(NSData*)data;

//提示框
+ (void)showAlertView:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
+ (void)showTipView:(NSString*)tip;
+ (void)showAlertView:(NSString*)message;
//种子~ 一些文字信息~
+ (void)feedDataInbackground:(NSString*)feedUrlString complete:(void(^)(NSData*))handle error:(void(^)(NSError**))error;

//传统电话拨打
+ (void)callBySystemAPI:(NSString*)telNumber;


//获取随机指定长度的字符串~
+ (NSString*)randomStringWithLen:(NSInteger)len;

//document 的path
+ (NSString*)documentPath;

//default width 44
#define kCustomButtonDefaultHeight (30.0)

//分享的语句
+ (NSString*)sharedString;
+ (NSString *)sharedURL;

//打开地址 浏览器
- (void)openURL:(NSString*)newVersionURL;

//是否全为数字
+ (BOOL)isAllNumbers:(NSString*)str;

//性别
+ (NSString*)sexString:(BOOL)sex;
//去掉特殊字符
+ (NSString *)stringByRemovingControlCharacters: (NSString *)inputString;
//设置扬声器
+ (void)setSpeaker:(BOOL)speaker;
+ (void)resignFirstResponder;

//将float型转化为字符串~
+ (NSString*)convertFloatToStringWithOutNoUseZero:(CGFloat)f;
+ (NSString*)convertFloatToString:(CGFloat)f;
/**
 颜色转换 IOS中十六进制的颜色转换为UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
