//
//  NewWXTLiDB.h
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewWXTLiDB : NSObject

+(NewWXTLiDB*)sharedWXLibDB;
//加载数据
-(void)loadData;
//清除数据
-(void)removeData;

@end
