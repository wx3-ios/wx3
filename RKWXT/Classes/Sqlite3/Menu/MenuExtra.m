//
//  MenuExtra.m
//  Woxin2.0
//
//  Created by le ting on 8/11/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "MenuExtra.h"

@implementation MenuExtra

- (void)dealloc{
//    [super dealloc];
}

+ (MenuExtra*)menuExtraWithExtra:(MenuExtra*)extra{
    return [[MenuExtra alloc] initWithExtra:extra] ;
}

- (id)initWithExtra:(MenuExtra*)extra{
    if(self = [super init]){
        [self setUID:extra.UID];
        [self setSubShopID:extra.subShopID];
        [self setSubShopName:extra.subShopName];
        [self setTime:extra.time];
        [self setMenuType:extra.menuType];
        [self setName:extra.name];
        [self setPhoneNumber:extra.phoneNumber];
        [self setAddress:extra.address];
        [self setRemark:extra.remark];
    }
    return self;
}

- (id)init{
    if(self = [super init]){
        WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
        NSString *phoneNumber = userOBJ.user;
        if(!phoneNumber){
            phoneNumber = @"";
        }
        [self setPhoneNumber:phoneNumber];
        [self setSubShopID:userOBJ.subShopID];
        [self setUID:kInvalidMenuItemUID];
        NSString *subShopName = userOBJ.subShopName;
        if(!subShopName){
            subShopName = @"";
        }
        [self setSubShopName:subShopName];
        [self setName:@""];
        [self setAddress:@""];
        [self setRemark:@""];
    }
    return self;
}

- (NSString*)menuTypeDesc{
	NSString *txt = nil;
	if(_menuType == E_MenuType_FaceToFace){
		txt = @"到店";
	}else{
		txt = @"外卖";
	}
	return txt;
}

@end