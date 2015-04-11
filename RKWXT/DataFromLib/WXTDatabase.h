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
    WXTDatabaseFaild = 0,
    WXTDatabaseSuccess = 1,
    WXTTableSuccess = 2,
    WXTTableFaild = 3
}WXTDBMessage;
typedef void (^Callback) (void);
@class EGODatabase;
@protocol WXTDataBaseDelegate;

@interface WXTDatabase : NSObject{
}
@property (nonatomic,assign)id<WXTDataBaseDelegate> delegate;
@property (nonatomic, strong) EGODatabase * database;
@property (nonatomic, getter=isDBOpen, assign) BOOL isDBOpen;
@property (nonatomic, strong) NSString * dbName; // 数据库文件名
+(instancetype)shareDatabase;
-(BOOL)checkWXTDBVersion;
-(BOOL)insertDBVersion;

-(NSInteger)getDBVersion;

-(BOOL)createDatabase:(NSString *)dbName;
// 查询数据库中表
-(BOOL)validateWXTTable:(NSString*)tableName;

-(BOOL)createWXTTable:(NSString*)tableSql;
-(BOOL)createWXTTable:(NSString*)tableSql finishedBlock:(Callback)callBack;
-(NSInteger)insertCallHistory:(NSString*)aName telephone:(NSString *)aTelephone startTime:(NSString*)aStartTime duration:(NSInteger)aDuration type:(int)aType;
-(NSMutableArray *)queryCallHistory;
/**
 @param telephone 电话号码
 */
-(NSInteger)delCallHistory:(NSInteger)recordID;
@end


@protocol WXTDataBaseDelegate <NSObject>

@required
-(void)wxtDatabaseOpenSuccess;
-(void)wxtDatabaseOpenFaild:(WXTDBMessage)faildMsg;
-(void)wxtCreateTableSuccess;
-(void)wxtCreateTableFaild:(WXTDBMessage)faildMsg;

@optional

@end