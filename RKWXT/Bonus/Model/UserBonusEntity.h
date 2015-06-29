//
//  UserBonusEntity.h
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBonusEntity : NSObject
@property (nonatomic,assign) NSInteger begin_time;
@property (nonatomic,assign) NSInteger end_time;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) NSInteger bonusID;
@property (nonatomic,assign) NSInteger bonusValue;

+(UserBonusEntity*)initUserBonusEntityWithDictionary:(NSDictionary*)dic;

@end
