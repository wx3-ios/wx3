//
//  T_HPSubBaseModel.h
//  RKWXT
//
//  Created by SHB on 15/5/29.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "URLBaseModel.h"

@interface T_HPSubBaseModel : URLBaseModel
@property (nonatomic,readonly) id data;

#pragma @required
-(void)fillDataWithJsonData:(NSDictionary*)jsonDicData;//填充数据
-(void)loadDataFromWeb; //从远程加载数据
-(void)loadCacheDataSucceed; //加载缓存数据成功

#pragma mark optional
-(BOOL)isDataEmpty; //判断是否为空
-(BOOL)dataNeedReload;//是否应该调用下载函数
-(void)loadData; //加载数据
-(BOOL)loadCache; //加载缓存，返回是否成功加载～或者是否有数据
-(NSString*)currentCachePath; //当前缓存地址
-(void)removeCache; //清楚缓存
-(void)saveCacheAtPath:(NSString*)path data:(id)jsonData; //保存数据

@end
