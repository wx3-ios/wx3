//
//  ContacterSearched.h
//  Woxin2.0
//
//  Created by le ting on 8/1/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CallHistoryEntity;
@interface SysContacterEntityEx : NSObject
@property (nonatomic,retain)ContacterEntity *contactEntity;
@property (nonatomic, strong)CallHistoryEntity * callHistoryEntity;
@property (nonatomic,retain)NSString *phoneMatched;

@end
