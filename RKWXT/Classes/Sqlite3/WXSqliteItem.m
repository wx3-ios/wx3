//
//  WXSqliteEntity.m
//  SQLite
//
//  Created by le ting on 5/4/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXSqliteItem.h"

@implementation WXSqliteItem
@synthesize identifier = _identifier;
@synthesize dataType = _dataType;
@synthesize data = _data;
@synthesize isPrimary = _isPrimary;

- (void)dealloc{
//    [super dealloc];
}

+ (WXSqliteItem*)itemWithSqliteItemStruct:(S_WXSqliteItem)item{
    WXSqliteItem *sqliteItem = [[WXSqliteItem alloc] init];
    sqliteItem.identifier = item.idenfitifer;
    sqliteItem.dataType = item.dataType;
    sqliteItem.isPrimary = item.isPrimary;
    return sqliteItem;
}

- (NSString*)dataTypeString{
    NSString *dataTypeString = nil;
    
    switch (_dataType) {
        case E_SQLITE_DATA_INT:
            dataTypeString = @"INTEGER";
            break;
        case E_SQLITE_DATA_TXT:
            dataTypeString = @"TEXT";
            break;
        default:
            break;
    }
    if(_isPrimary && dataTypeString){
        dataTypeString = [NSString stringWithFormat:@"%@ PRIMARY KEY AUTOINCREMENT",dataTypeString];
    }
    return dataTypeString;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"identifier:%@,dataType:%d,data=%@",_identifier,_dataType,_data];
}

@end
