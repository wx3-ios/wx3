//
//  WXCpxBaseView.m
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCpxBaseView.h"

@implementation WXCpxBaseView
@synthesize cpxViewInfo;

- (void)dealloc{
    RELEASE_SAFELY(cpxViewInfo);
    [super dealloc];
}

- (void)load{
    
}

- (void)unLoad{
    
}

@end
