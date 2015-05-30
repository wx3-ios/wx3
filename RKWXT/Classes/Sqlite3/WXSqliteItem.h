//
//  WXSqliteEntity.h
//  SQLite
//
//  Created by le ting on 5/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //整形
    E_SQLITE_DATA_INT = 0,
    //txt
    E_SQLITE_DATA_TXT,
}E_SQLITE_DATA_TYPE;


typedef struct {
    __unsafe_unretained NSString *idenfitifer;
    E_SQLITE_DATA_TYPE dataType;
    BOOL isPrimary;
}S_WXSqliteItem;

@interface WXSqliteItem : NSObject
@property (nonatomic,retain)NSString *identifier;
@property (nonatomic,assign)E_SQLITE_DATA_TYPE dataType;
@property (nonatomic,assign)BOOL isPrimary;
@property (nonatomic,retain)id data;

+ (WXSqliteItem*)itemWithSqliteItemStruct:(S_WXSqliteItem)item;
- (NSString*)dataTypeString;
@end
