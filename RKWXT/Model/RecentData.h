//
//  RecentData.h
//  WjtCall
//
//  Created by jjyo.kwan on 14-5-15.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentData : NSObject

@property (assign) NSInteger ROWID;
@property (nonatomic, strong) NSString * area;//归属地
@property (nonatomic, strong) NSDate * date;//日期
@property (assign) NSInteger duration;
@property (assign) NSInteger flags;
@property (nonatomic, strong) NSString * phone;//呼出号码
@property (assign) NSInteger groupCount;//组数量

@property (nonatomic, strong) NSString *section;//分类
@property (nonatomic, strong) NSString *time;//时间



@end
