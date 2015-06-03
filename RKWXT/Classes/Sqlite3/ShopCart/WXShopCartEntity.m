//
//  WXShopCartEntity.m
//  CallTesting
//
//  Created by le ting on 5/15/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXShopCartEntity.h"

@implementation WXShopCartEntity
@synthesize primaryID = _primaryID;
@synthesize goodID = _goodID;
@synthesize name = _name;
@synthesize price = _price;
@synthesize attribute = _attribute;
@synthesize goodNumber = _goodNumber;
@synthesize isSelect = _isSelect;
@synthesize priceTxt = _priceTxt;
@synthesize iconURL = _iconURL;
@synthesize isReady = _isReady;

- (void)dealloc{
//    [super dealloc];
}
@end
