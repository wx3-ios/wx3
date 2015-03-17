//
//  WXUILabel.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUILabel.h"

@implementation WXUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
		[self setTextAlignment:UITextAlignmentLeft];
    }
    return self;
}


- (id)init{
    if(self = [super init]){
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setMutiLine{
    [self setNumberOfLines:10000];
}
@end
