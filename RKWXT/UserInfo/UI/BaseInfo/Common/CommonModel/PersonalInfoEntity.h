//
//  PersonalInfoEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoEntity : NSObject
@property (nonatomic,assign) NSInteger bsex;
@property (nonatomic,assign) NSInteger birthday;
@property (nonatomic,strong) NSString *userNickName;

+(PersonalInfoEntity*)initWithPersonalInfoWith:(NSDictionary*)dic;

@end
