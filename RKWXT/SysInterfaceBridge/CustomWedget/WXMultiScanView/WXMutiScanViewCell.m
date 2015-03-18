//
//  WXMutiScanViewCell.m
//  WXScrollBrowser
//
//  Created by le ting on 6/25/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXMutiScanViewCell.h"

@implementation WXMutiScanViewCell

- (void)dealloc{
//    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    if(self = [super init]){
        [self setReuseIdentifier:reuseIdentifier];
    }
    return self;
}
@end
