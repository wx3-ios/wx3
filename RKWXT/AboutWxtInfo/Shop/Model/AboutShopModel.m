//
//  AboutShopModel.m
//  RKWXT
//
//  Created by SHB on 15/7/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutShopModel.h"
#import "AboutShopEntity.h"

@interface AboutShopModel(){
    NSMutableArray *_shopInfoArr;
}
@end

@implementation AboutShopModel

-(id)init{
    self = [super init];
    if(self){
        _shopInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadShopInfo{
    
}

@end
