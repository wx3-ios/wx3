//
//  SignEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignEntity : NSObject
@property (nonatomic,assign) CGFloat money;
@property (nonatomic,assign) NSInteger time;

+(SignEntity*)signWithDictionary:(NSDictionary*)dic;

@end
