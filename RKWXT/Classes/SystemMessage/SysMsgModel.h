//
//  SysMsgModel.h
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SysMsgItem.h"

@protocol SysMsgModelDelegate;
@interface SysMsgModel : NSObject
@property (nonatomic,readonly)NSArray *sysMsgList;
@property (nonatomic,assign)id<SysMsgModelDelegate>delegate;
@end

@protocol SysMsgModelDelegate <NSObject>
- (void)incomePushList:(NSArray*)sysMsgArray;
@end