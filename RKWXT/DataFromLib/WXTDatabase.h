//
//  WXTDatabase.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDBVersion          @"1.0"
#define kDBDateTime         @"20150401"

typedef enum{
    WXTDBPathNotExit = -2,
    WXTDBFileNotExit = -1,
    WXTDatabaseFaild = 0,
    WXTDatabaseSuccess = 1,
    WXTTableSuccess = 2,
    WXTTableFaild = 3
}WXTDBMessage;
typedef void(^Callback)(void);
@class EGODatabase;
@protocol WXTDataBaseDelegate;

@interface WXTDatabase : NSObject{
}
@property (nonatomic,assign)id<WXTDataBaseDelegate> delegate;
@property (nonatomic, strong) EGODatabase * database;
@property (nonatomic, getter=isDBOpen, assign) BOOL isDBOpen;
@property (nonatomic, getter=isTableOpen, assign) BOOL isTableOpen;
@property (nonatomic, strong) NSString * dbPath; // 数据库文件名
+(instancetype)shareDatabase;
-(BOOL)checkWXTDBVersion;
-(BOOL)insertDBVersion;

-(NSInteger)getDBVersion;

-(BOOL)createDatabase:(NSString *)aDBPath;
// 查询数据库中表
-(BOOL)validateWXTTable:(NSString*)tableName;

-(BOOL)createWXTTable:(NSString*)tableSql;
-(BOOL)createWXTTable:(NSString*)tableSql finishedBlock:(Callback)callBack;

@end


@protocol WXTDataBaseDelegate <NSObject>

@required
//-(void)wxtDatabase:(NSString*)dbPath;
-(void)wxtDatabaseOpenSuccess;
-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg;
-(void)wxtCreateTableSuccess;
-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg;

@optional

@end