//
//  UtilTool.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UtilTool.h"

@implementation UtilTool

+ (void)showAlertView:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView setTag:tag];
    [alertView show];
}

+ (void)showAlertView:(NSString*)message{
    return [self showAlertView:nil message:message delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
}


@end
