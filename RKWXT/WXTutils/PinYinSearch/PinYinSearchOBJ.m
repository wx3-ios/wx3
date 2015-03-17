//
//  PinYinSearchOBJ.m
//  WXServer
//
//  Created by le ting on 6/12/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//
#import "PinYinSearchOBJ.h"
#import "PinYinForObjc.h"

@implementation PinYinSearchOBJ

+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+ (BOOL)isIncludeString:(NSString*)desString inString:(NSString*)sourceString{
    NSAssert(sourceString, @"Source string can not be nil");
    if(!desString || [desString length] == 0){
        return YES;
    }
    if(![self isIncludeChineseInString:desString]){
        if([self isIncludeChineseInString:sourceString]){
            NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:sourceString];
            NSRange titleResult=[tempPinYinStr rangeOfString:desString options:NSCaseInsensitiveSearch];
            if(titleResult.length > 0){
                return YES;
            }
            
            NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:sourceString];
            NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:desString options:NSCaseInsensitiveSearch];
            if (titleHeadResult.length>0) {
                return YES;
            }
        }else{
            NSRange titleResult=[sourceString rangeOfString:desString options:NSCaseInsensitiveSearch];
            if(titleResult.length > 0){
                return YES;
            }
        }
    }else{
        NSRange titleResult=[sourceString rangeOfString:desString options:NSCaseInsensitiveSearch];
        if(titleResult.length > 0){
            return YES;
        }
    }
    return NO;
}

@end
