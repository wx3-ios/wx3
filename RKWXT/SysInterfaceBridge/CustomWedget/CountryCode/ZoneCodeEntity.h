//
//  ZoneCodeEntity.h
//  Woxin2.0
//
//  Created by Elty on 11/13/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoneCodeEntity : NSObject
@property (nonatomic,retain)NSString *zoneName; //区域名称
@property (nonatomic,retain)NSString *zoneCode;	//区号
@property (nonatomic,assign)NSInteger phoneLen; //座机号码的位数


+ (ZoneCodeEntity*)zoneCodeEntityWithArray:(NSArray*)objArray;
@end
