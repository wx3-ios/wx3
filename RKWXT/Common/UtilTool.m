//
//  UtilTool.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UtilTool.h"

@implementation UtilTool

+(NSString*)getCurDateTime:(int)type{
    return [UtilTool getDateTimeForDate:[NSDate date] type:type];
}

+(NSString*)getDateTimeForDate:(NSDate*)date type:(int)type{
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

+ (void)showAlertView:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView setTag:tag];
    [alertView show];
}

+ (void)showAlertView:(NSString*)message{
    return [self showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

@end
