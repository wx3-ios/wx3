//
//  AlipayOBJ.m
//  Woxin2.0
//
//  Created by qq on 14-8-26.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "AlipayOBJ.h"

@implementation AlipayOBJ
@synthesize title = _title;
@synthesize price = _price;
@synthesize bSelected = _bSelected;

+ (AlipayOBJ*)alipayOBJWith:(NSString*)title price:(CGFloat)price{
    return [[AlipayOBJ alloc] initWithTitle:title price:price];
}

- (id)initWithTitle:(NSString*)title price:(CGFloat)price{
    if(self = [super init]){
        [self setTitle:title];
        [self setPrice:price];
        _bSelected = NO;
    }
    return self;
}

@end
