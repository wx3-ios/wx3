//
//  URLNetNotificationOBJ.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLNetNotificationOBJ : NSObject
//值
@property (nonatomic,retain)id object;
//标识谁接受这个通知
@property (nonatomic,retain)id key;
//URLString
@property (nonatomic,retain)NSString *urlString;

@end
