//
//  WXUIAlertView.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUIAlertView.h"

@implementation WXUIAlertView
@synthesize alertInfo = _alertInfo;

- (void)dealloc{
    RELEASE_SAFELY(_alertInfo);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
