//
//  ContactBaseEntity.m
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "ContactBaseEntity.h"

@implementation ContactBaseEntity

- (NSString*)nameShow{
    return nil;
}
- (UIImage*)iconShow{
    return nil;
}

- (E_ContactRightView)rightViewType{
    return E_ContactRightView_None;
}

- (NSArray*)contactPhoneArray{
    return nil;
}

@end

@implementation ContactPhone

- (void)dealloc{
//    [super dealloc];
}
@end
