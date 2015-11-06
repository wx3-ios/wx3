//
//  AreaEntity.h
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaEntity : NSObject
@property (nonatomic,assign) NSInteger areaID;
@property (nonatomic,assign) NSInteger areaPresentID;
@property (nonatomic,strong) NSString *areaName;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *proName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *disName;
@property (nonatomic,assign) NSInteger proID;
@property (nonatomic,assign) NSInteger cityID;
@property (nonatomic,assign) NSInteger disID;

@property (nonatomic,assign) NSInteger address_id;
@property (nonatomic,assign) NSInteger normalID;

+(AreaEntity*)initAreaEntityWith:(NSDictionary*)dic;

@end
