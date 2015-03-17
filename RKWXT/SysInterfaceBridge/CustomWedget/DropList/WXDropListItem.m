//
//  WXDropListItem.m
//  DropList
//
//  Created by le ting on 5/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXDropListItem.h"

@implementation WXDropListItem
@synthesize title = _title;
@synthesize icon = _icon;

- (void)dealloc{
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_icon);
    [super dealloc];
}

@end
