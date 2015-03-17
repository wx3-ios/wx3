//
//  UIResponder+FirstResponder.m
//  CallTesting
//
//  Created by le ting on 5/16/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;
@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
