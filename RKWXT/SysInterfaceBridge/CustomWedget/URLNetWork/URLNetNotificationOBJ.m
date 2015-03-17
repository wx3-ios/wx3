//
//  URLNetNotificationOBJ.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "URLNetNotificationOBJ.h"

@implementation URLNetNotificationOBJ
@synthesize object;
@synthesize key;
@synthesize urlString;

- (void)dealloc{
    RELEASE_SAFELY(object);
    RELEASE_SAFELY(key);
    RELEASE_SAFELY(urlString);
    [super dealloc];
}
@end
