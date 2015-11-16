//
//  UtilTool.m
//  CallTesting
//
//  Created by le ting on 4/22/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "UtilTool.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>

//匹配手机的正则
#define REGEX_MOBILE @"^1[34578][0-9]{9}$"
//电话区号正则
#define REGEX_TELEPHONE @"^0[123456789]\\d{8,10}"

@implementation UtilTool

+(void)fadeOut:(UIView *)v withDuration:(float) d{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:d];
    [v setAlpha:0.0f];
    [UIView commitAnimations];
}

+ (void) fadeIn: (UIView *)v withDuration:(float) d{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:d];
    [v setAlpha:1.0f];
    [UIView commitAnimations];
}

//得到日期时间格式为2012-9-3 12:20:00
//type 1 date time
//type 2 date
//type 3 time
+(NSString*)getDateTimeForDate:(NSDate*)date type:(int)type
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    if(type == 1 )
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else if(type == 2 )
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    else if(type == 3 )
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *curDateTime = [dateFormatter stringFromDate:date];
    return curDateTime;
}

+(NSString*)getDateTimeFor:(NSInteger)seconds type:(int)type
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [UtilTool getDateTimeForDate:date type:type];
}
+ (NSString*)getWeekDayString:(EWeekDay)index{
    NSArray *array = [NSArray arrayWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",nil];
    if(index >= [array count]){
        return nil;
    }
    NSString *weekDayString = NSLocalizedString([array objectAtIndex:index], nil);
    return weekDayString;
}

+ (NSString*)getDayString:(NSInteger)n{
    NSArray *array = [NSArray arrayWithObjects:
                      @"1day",@"2day",@"3day",@"4day",@"5day",
                      @"6day",@"7day",@"8day",@"9day",@"10day",
                      @"11day",@"12day",@"13day",@"14day",@"15day",
                      @"16day",@"17day",@"18day",@"19day",@"20day",
                      @"21day",@"22day",@"23day",@"24day",@"25day",
                      @"26day",@"27day",@"28day",@"29day",@"30day",
                      @"31day",nil];
    if(n >= [array count]){
        return nil;
    }
    return NSLocalizedString([array objectAtIndex:n], nil);
}
+ (NSString*)getMonthString:(NSInteger)n{
    NSArray *array = [NSArray arrayWithObjects:
                      @"Jan",@"Feb",@"Mar",@"Apr",@"May",
                      @"Jun",@"Jul",@"Aug",@"Sep",@"Oct",
                      @"Nov",@"Dec",nil];
    if(n >= [array count]){
        return nil;
    }
    return NSLocalizedString([array objectAtIndex:n], nil);
}
+ (NSString*)getAMPMString:(NSInteger)n{
    NSArray *array = [NSArray arrayWithObjects:@"am",@"pm",nil];
    if(n >= [array count]){
        return nil;
    }
    return NSLocalizedString([array objectAtIndex:n], nil);
}

+(NSString*)getCurDateTime:(int)type
{
    return [UtilTool getDateTimeForDate:[NSDate date] type:type];
}

+ (NSString*)getStringFrom:(NSString*)sourceString head:(NSString*)head tail:(NSString*)tail
{
    NSRange headRange = [sourceString rangeOfString:head];
    if(headRange.location == NSNotFound)
    {
        return nil;
    }
    NSRange tailRange = [sourceString rangeOfString:tail];
    if(tailRange.location == NSNotFound){
        return nil;
    }
    if(tailRange.location <= headRange.location){
        return nil;
    }
    NSRange range = {headRange.location + headRange.length, tailRange.location-(headRange.location+headRange.length)};
    return [sourceString substringWithRange:range];
}

+ (void)shadowForButton:(UIButton*)button
{
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    button.titleLabel.layer.shadowOpacity = 0.3;
    button.titleLabel.layer.shadowColor = [UIColor clearColor].CGColor;
}

+ (void)setTextViewVerticalCenter:(UITextView*)textView
{
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height * [textView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

+ (void)copy:(NSString *)txt{
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setString:txt];
}

+ (E_DEVICE_TYPE)currentDeviceType{
    NSString *deviceModel = [[UIDevice currentDevice] model];
    E_DEVICE_TYPE deviceType = E_DEVICE_INVALID;
    if ([deviceModel isEqualToString:@"iPhone"]) {
        deviceType = E_DEVICE_IPHONE;
    }else if ([deviceModel isEqualToString:@"iPod touch"]){
        deviceType = E_DEVICE_IPOD;
    }else if ([deviceModel isEqualToString:@"iPad"]){
        deviceType = E_DEVICE_IPAD;
    }
    return deviceType;
}

+ (NSString*)currentDeviceDescribtion{
	return [[UIDevice currentDevice] systemName];
}

+ (void)centerSubViews:(NSArray*)subViews in:(UIView*)superView{
    if(!subViews && [subViews count] == 0){
        return;
    }
    if(!superView){
        return;
    }
    
    CGSize superViewSize = superView.bounds.size;
    NSInteger subViewCount = [subViews count];
    CGFloat subViewAllWidth = 0;
    for(UIView *subView in subViews){
        CGRect frame = subView.bounds;
        frame.origin.y = (superViewSize.height - CGRectGetHeight(frame))/2;
        [subView setFrame:frame];
        subViewAllWidth += CGRectGetWidth(frame);
    }
    CGFloat subViewGap = (superViewSize.width - subViewAllWidth)/(subViewCount + 1);
    
    CGFloat xOffset = 0;
    for (int i = 0; i < subViewCount; i++) {
        UIView *subView = [subViews objectAtIndex:i];
        CGRect frame = subView.frame;
        xOffset += subViewGap;
        frame.origin.x = xOffset;
        [subView setFrame:frame];
        xOffset += CGRectGetWidth(frame);
    }
}

+ (NSData*)convertGBKDataToUTF8:(NSData*)data{
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString*pageSource = [[NSString alloc] initWithData:data encoding:gbkEncoding] ;
    NSData *utf8Data = [pageSource dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}

+ (void)showAlertView:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    WXUIAlertView *alertView = [[WXUIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView setTag:tag];
    [alertView show];

}

+ (void)showAlertView:(NSString*)message{
    return [self showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

+ (void)showTipView:(NSString*)tip{
    WXPopAlertView *popAlertView = [[WXPopAlertView alloc] initWithTip:tip];
    [popAlertView show];

}

+ (void)feedDataInbackground:(NSString*)feedUrlString complete:(void(^)(NSData*))handle error:(void(^)(NSError**))error{
    NSURL *url = [NSURL URLWithString:feedUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if(!request){
        KFLog_Normal(YES, @"create request error");
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data){
                handle(data);
            }else{
                KFLog_Normal(YES, @"fetch feed error");
            }
        });
    });
}

//传统电话拨打
+ (void)callBySystemAPI:(NSString*)telNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNumber]];
    static UIWebView *phoneCallWebView = nil;
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

//len长度的随机字符串
+ (NSString*)randomStringWithLen:(NSInteger)len{
    char randString[len];
    
    for(int i = 0; i < len; i++){
        randString[i] = 'a'+(arc4random_uniform(25));
    }
    NSString *dataPoint = [[NSString alloc] initWithBytes:randString length:len encoding:NSUTF8StringEncoding] ;
    return dataPoint;
}

//document 的path
+ (NSString*)documentPath{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return docsDir;
}

+ (NSString*)sharedString{
    NSString *str = [NSString stringWithFormat:@"这年头没好事哪敢骚扰你，用%@打国内电话低至3分。",kMerchantName];
    if (kMerchantID == 10192) {
        str = [NSString  stringWithFormat:@"下载进口特惠商城，手机话费充100送378，8分钱／分钟打遍全国。"];
    }
    if(kMerchantID == 10233 || kMerchantID == 10248 || kMerchantID == 10249){
        str = [NSString stringWithFormat:@"这个世界上肯定有一个人能帮到你，你也会帮到另一个人。分享到朋友圈去帮助更多的人"];
    }
    if(kMerchantID == 10198){
        str = [NSString stringWithFormat:@"这年头没好事哪敢骚扰您，了解世纪医微通，您会感激我一辈子……"];
    }
    return str;
}

+ (NSString *)sharedURL{
    NSString *urlString = @"http://121.201.18.130/wx_html/index.php/Public/app_download/sid/";
    NSString *str = [NSString stringWithFormat:@"%@%d",urlString,kMerchantID];
    return str;
}

- (void)openURL:(NSString*)newVersionURL{
//    BOOL ret = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionURL]];
//    if(!ret){
//        KFLog_Normal(YES, @"无效的地址");
//    }
}

//是否全为数字
+ (BOOL)isAllNumbers:(NSString*)str{
    BOOL ret = YES;
    if(str){
        NSInteger len = str.length;
        if(len > 0){
            for(NSInteger i = 0; i < len; i++){
                unichar c = [str characterAtIndex:i];
                if(!(c >= '0' && c <= '9')){
                    ret = NO;
                    break;
                }
            }
        }
    }
    return ret;
}

//性别
+ (NSString*)sexString:(BOOL)sex{
    NSString *sexStr = @"男";
    if(sex){
        sexStr = @"女";
    }
    return sexStr;
}

+(NSString *)convertString:(NSString*)sourceString toEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)sourceString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

+ (NSString *)stringByRemovingControlCharacters: (NSString *)inputString{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

+ (void)setSpeaker:(BOOL)speaker{
    UInt32 audioRouteOverride = speaker ? kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

+ (void)resignFirstResponder{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


+ (NSInteger)indexOfDotAtFString:(NSString*)fString{
	NSInteger index = -1;
	NSInteger length = [fString length];
	for (NSInteger i = 0; i < length; i++){
		unichar ch = [fString characterAtIndex:i];
		if (ch == '.'){
			index = i;
		}
	}
	return index;
}

+ (NSString*)convertFloatToStringWithOutNoUseZero:(CGFloat)f{
	NSString *fString = [NSString stringWithFormat:@"%.2f",f];
	return [self removeNoUseZeroFromFString:fString];
}


+ (NSString*)convertFloatString:(NSString*)floatString toPrecision:(NSInteger)precision{
	NSInteger length = [floatString length];
	
	if (length == 0){
		return floatString;
	}
	
	NSInteger index = [self indexOfDotAtFString:floatString];
	if (index < 0){
		return  floatString;
	}
	
	NSInteger curPrecision = length - (index+1);
	
	if (curPrecision < precision){
		for (NSInteger i = curPrecision; i < precision; i++){
			floatString = [floatString stringByAppendingString:@"0"];
		}
		return floatString;
	}
	
	return [floatString substringToIndex:index + precision + 1];
}


+ (NSString*)removeNoUseZeroFromFString:(NSString*)fString{
	NSInteger length = [fString length];
	
	if (length == 0){
		return fString;
	}
	
	NSInteger index = [self indexOfDotAtFString:fString];
	if (index < 0){
		return  fString;
	}
	
	NSInteger noUseZeroCount = 0;
	for (NSInteger i = length - 1; i > index; i--){
		unichar ch = [fString characterAtIndex:i];
		if (ch == '0'){
			noUseZeroCount ++;
		}else{
			break;
		}
	}
	NSInteger location = length - noUseZeroCount;
	if (location - 1== index){
		location -= 1;
	}
	
	if (location <= 0){
		return 0;
	}
	return [fString substringToIndex:location];
}

+ (NSString*)convertFloatToString:(CGFloat)f{
	NSString *fString = [self convertFloatToStringWithOutNoUseZero:f];
	if (f > 10000){
		NSArray *subStrings = [fString componentsSeparatedByString:@"."];
		NSInteger count = [subStrings count];
		if (count == 0){
			return @"";
		}
		NSString *firstSub = [subStrings objectAtIndex:0];
		NSInteger firstLen = [firstSub length];
		NSString *intString = [firstSub substringToIndex:firstLen - 4];
		NSString *floatString = [firstSub substringFromIndex:firstLen - 4];
		NSString *newString = [NSString stringWithFormat:@"%@.%@",intString,floatString];
		if (count == 2){
			newString = [NSString stringWithFormat:@"%@%@",newString,[subStrings objectAtIndex:1]];
		}
		newString = [self convertFloatString:newString toPrecision:2];
		fString = [self removeNoUseZeroFromFString:newString];
		fString = [NSString stringWithFormat:@"%@万",fString];
	}
	return fString;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(NSString*)callPhoneNumberRemovePreWith:(NSString*)oldPhone{
    if(!oldPhone){   //号码为空
        return nil;
    }
    if(oldPhone.length < 10){    //暂时不清楚属于哪类号码
        return oldPhone;
    }
    if([oldPhone hasPrefix:@"0"]){   //区号开头，暂时认为是固话
        return oldPhone;
    }
    
    if([oldPhone hasPrefix:@"1"]){  //以1开始的字符串认作是手机号直接返回
        return oldPhone;
    }
    NSString *newPhone = nil;
    if([oldPhone hasPrefix:@"+86"]){
        newPhone = [oldPhone substringFromIndex:3]; //+86的号码去掉前缀后返回
    }
    if([oldPhone hasPrefix:@"86"]){
        newPhone = [oldPhone substringFromIndex:2]; //86前缀的可能性很小
    }
    return newPhone;
}

+(BOOL)determineNumberTrue:(NSString*)phoneNumber{
    BOOL isOk = NO;
    if(!phoneNumber){
        return NO;
    }
    if([phoneNumber hasPrefix:@"1"]){
        return [self isMobileNumber:phoneNumber];
    }
    if([phoneNumber hasPrefix:@"0"]){
        return [self isTelephoneNumber:phoneNumber];
    }
    return isOk;
}

//是否是手机号码
+ (BOOL)isMobileNumber:(NSString*)phone{
    if(!phone){
        return NO;
    }
    if (phone.length == 11){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_MOBILE];
        if ([predicate evaluateWithObject:phone]) {
            return YES;
        }
    }
    return NO;
}

//是否是固定电话号码
+ (BOOL)isTelephoneNumber:(NSString*)phone{
    if(!phone){
        return NO;
    }
    if (phone.length == 11 || phone.length == 12) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_TELEPHONE];
        if ([predicate evaluateWithObject:phone]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSString*)newStringWithAddSomeStr:(NSInteger)number withOldStr:(NSString*)oldStr{
    NSString *md5Str = [[self class] md5:oldStr];
    return [[NSString alloc] initWithFormat:@"%@%@",[[self class] randomStringWithLen:number],md5Str];
}

+(NSInteger)timeChange{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    return (long)date;
}

+(NSString*)currentVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
