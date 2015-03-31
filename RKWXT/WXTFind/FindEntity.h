//
//  FindEntity.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindEntity : NSObject
@property (nonatomic,strong) NSString *emptyUrl;

+(FindEntity*)initFindEntityWith:(NSDictionary*)dic;

@end
