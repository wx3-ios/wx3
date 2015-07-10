//
//  ContactUitl.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import "ContactUitl.h"
#import "SSZipArchive.h"
#import "EGODatabase.h"
#import "DBCommon.h"
#import "NSString+Helper.h"
@implementation ContactUitl

- (id)init
{
    if (self  = [super init]) {
        self.areaDict = [self readAreaCode];
        _placeDatabase = [EGODatabase databaseWithPath:kWXTPlacePath];
        //PRIMARY KEY
        NSArray *array = @[@"phone text PRIMARY KEY", @"area text"];
        NSString * sql = [NSString stringWithFormat:kWXTCreateTable, kWXTPlaceTable, [array componentsJoinedByString:@","]];
        if (![_placeDatabase executeUpdate:sql]) {
            NSLog(@"create table = %@ faild!!!, error:%@", kWXTPlaceTable, _placeDatabase.lastErrorMessage);
        }
        [self unzipDBFile];
    }
    return self;
}

+ (ContactUitl *)shareInstance
{
    static ContactUitl *instance = nil;
    if(!instance)
    {
        instance = [[ContactUitl alloc]init];
//        instance.placeDatabase = [[EGODatabase alloc] initWithPath:kWXTPlacePath];
    }
    return instance;
}

- (NSString *)queryByPhone:(NSString *)phone
{
    NSString *area = nil;
//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if (_loaded && [phone isMobileNumber]) {
        NSString *mobileTag = [phone substringToIndex:7];
        NSString *sql = [NSString stringWithFormat:kWXTSelectArea, kWXTPlaceTable, mobileTag];
        EGODatabaseResult *result = [_placeDatabase executeQuery:sql];
        for(EGODatabaseRow* row in result)
        {
            area = [row stringForColumn:@"area"];
            //CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//            NSLog(@"query one row data use time = %f", end-start);
        }
    }
    else if ([phone isTelephoneNumber])
    {
        NSString *key = [phone substringToIndex:4];
        if ([key characterAtIndex:1] <= '2')
        {
            key = [key substringToIndex:3];
        }
        area = _areaDict[key];
    }
    if (!area) {
        NSLog(@"QUERY phone(%@) not exist!", phone);
    }
    return area;
}

- (NSInteger)count{
    int count = 0;
    EGODatabaseResult *result = [_placeDatabase executeQuery:[NSString stringWithFormat:kWXTSelectCount, kWXTPlaceTable]];
    for (EGODatabaseRow *row in result) {
        count = [row intForColumnAtIndex:0];
    }
    return count;
}

- (void)unzipDBFile{
    BOOL import = [USER_DEFAULT boolForKey:UD_IMPORT_TAG];
    if (import) {
        _loaded = YES;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = DOC_URL;
        NSString *toPath = [url path] ;
        NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"dat"];
        NSString *filePath = [toPath stringByAppendingPathComponent:@"place.txt"];
        //如果place.txt不存在..解压place.zip资源文件
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        [SSZipArchive unzipFileAtPath:fromPath toDestination:toPath];
        CFAbsoluteTime a = CFAbsoluteTimeGetCurrent();
        
        FILE *file = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
        if (!file) {
            return ;
        }
        
        char line[200];
        NSMutableArray *lines = [NSMutableArray array];
        int index = 0;
        while (fgets(line, 200, file) != NULL) {
            //            printf("%s", line);
            if (index >= 5000) {
                [self addAreaString:lines];
                index = 0;
                lines = [NSMutableArray array];
            }
            index++;
            NSString *lineString = [[NSString alloc]initWithUTF8String:line];
            [lines addObject:lineString];
            
        }
        [self addAreaString:lines];
        CFAbsoluteTime b = CFAbsoluteTimeGetCurrent();
        NSLog(@"---------------------------");
        NSLog(@"TOTAL USE TIME = %f", b - a);
        fclose(file);
        
        NSInteger count = [self count];
        
        NSLog(@"place data count = %ld", (long)count);
        if (count > 300000) {
            _loaded = YES;
            [USER_DEFAULT setBool:YES forKey:UD_IMPORT_TAG];
            [USER_DEFAULT synchronize];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [NOTIFY_CENTER postNotificationName:AreaDataLoadingFinishNotification object:nil];
            
            NSURL *url = [NSURL fileURLWithPath:kWXTPlacePath];
            //保存路径. 防止加到iCloud备份
            [Tools addSkipBackupAttributeToItemAtURL:url];
        }
        else{
            [_placeDatabase close];
            [[NSFileManager defaultManager] removeItemAtPath:kWXTPlacePath error:nil];
        }
    });
}

- (void)addAreaString:(NSArray *)lines{
    if (lines.count == 0) {
        return;
    }
//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //[_placeDatabase executeUpdate:@"PRAGMA synchronous = OFF"];
    [_placeDatabase executeUpdate:@"begin transaction"];//开始事务
    for (NSString * line in lines) {
        NSString *lll = [line substringToIndex:line.length - 2];
        NSArray * array = [lll componentsSeparatedByString:@"|"];
        if (array.count == 2) {
            NSString * sql = [NSString stringWithFormat:kWXTInsertPlace];
            [_placeDatabase executeUpdate:sql parameters:array];
        }
    }
    [_placeDatabase executeUpdate:@"commit"]; //提交事备
//    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//    NSLog(@"insert %lu rowdata use time = %f", lines.count, end - start);
}

- (NSDictionary *)readAreaCode{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"areacode" ofType:@""];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    
    NSString *province = @"";
    for (NSString *lineString in lines) {
        if (lineString.length < 1) {
            continue;
        }
        
        NSArray *values = [lineString componentsSeparatedByString:@" "];
        if (values.count == 1) {
            province = values[0];
        }
        else if(values.count == 2)
        {
            NSString *city = values[0];
            NSString *area = values[1];
            
            NSString *name = [NSString stringWithFormat:@"%@%@", province, city];
            name = [name stringByReplacingOccurrencesOfString:@"省" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            [dict setValue:name forKey:area];
        }
    }
    return dict;
}
@end
