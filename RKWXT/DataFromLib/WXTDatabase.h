//
//  WXTDatabase.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class EGODatabase;
@interface WXTDatabase : NSObject
//@property (nonatomic, strong) EGODatabase * database;
@property (nonatomic, strong) NSString * dbName; // 数据库文件名
+(instancetype)shareDatabase;
-(BOOL)createDatabase:(NSString *)dbName;
-(BOOL)createWXTTable;
-(void)insertCallHistory:(NSString *)telephone date:(NSString*)date type:(int)type;
@end
