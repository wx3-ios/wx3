//
//  T_HPSubBaseModel.m
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@implementation T_HPSubBaseModel

-(void)toInit{
    [super toInit];
    [self removeCache];
}

-(BOOL)isDataEmpty{
    if([self.data isKindOfClass:[NSDictionary class]]){
        NSDictionary *dicData = self.data;
        return [[dicData allKeys] count] == 0;
    }else if ([self.data isKindOfClass:[NSArray class]]){
        NSArray *listData = self.data;
        return [listData count] == 0;
    }
    return YES;
}

-(BOOL)dataNeedReload{
    return self.status == E_ModelDataStatus_Init || E_ModelDataStatus_LoadFailed == self.status;
}

-(NSString*)urlDataCacheFilepath{
    NSString *path = [UtilTool documentPath];
    path = [path stringByAppendingPathComponent:@"urlDataCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

-(NSString*)currentCachePath{
    NSString *path = [self urlDataCacheFilepath];
    path = [path stringByAppendingPathComponent:NSStringFromClass([self class])];
    return path;
}

-(void)removeCache{
    NSString *currentCachepath = [self urlDataCacheFilepath];
    if(currentCachepath){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:currentCachepath]){
            [fileManager removeItemAtPath:currentCachepath error:nil];
        }
    }
}

-(void)fillDataWithJsonData:(NSDictionary *)jsonDicData{
}

-(void)loadData{
    if([self isDataEmpty]){
        if(![self loadCache]){
            [self loadDataFromWeb];
        }else{
            [self performSelector:@selector(loadCacheDataSucceed) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        }
    }else{
        [self loadDataFromWeb];
    }
}

-(void)loadDataFromWeb{
}

-(void)loadCacheDataSucceed{
}

-(BOOL)loadCache{
    NSDictionary *jsonDic = [self loadJsonDataFromPath:[self currentCachePath]];
    if([[jsonDic allKeys] count] == 0){
        return NO;
    }
    [self fillDataWithJsonData:jsonDic];
    if([self isDataEmpty]){
        return NO;
    }
    return YES;
}

-(NSDictionary*)loadJsonDataFromPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }else{
        return nil;
    }
}

-(void)saveCacheAtPath:(NSString *)path data:(id)jsonData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    
    if([jsonData isKindOfClass:[NSDictionary class]]){
        NSDictionary *dicData = jsonData;
        [dicData writeToFile:path atomically:NO];
    }else if ([jsonData isKindOfClass:[NSArray class]]){
        NSArray *listData = jsonData;
        [listData writeToFile:path atomically:NO];
    }
}

@end
