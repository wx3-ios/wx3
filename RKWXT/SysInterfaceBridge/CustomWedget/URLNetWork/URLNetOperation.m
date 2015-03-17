//
//  URLNetOperation.m
//  WoXin
//
//  Created by le ting on 4/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "URLNetOperation.h"

@implementation URLNetOperation
@synthesize key;

- (void)dealloc{
    RELEASE_SAFELY(key);
    [super dealloc];
}

@end
