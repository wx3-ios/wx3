//
//  ContactUitl.h
//  Okboo
//
//  Created by jjyo.kwan on 12-8-15.
//  Copyright (c) 2012年 jjyo.kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据初始化完成
#define AreaDataLoadingFinishNotification @"com.gjt.area.init"
//导入完成标记
#define UD_IMPORT_TAG @"unzip.import.place.tag"
@class EGODatabase;
@interface ContactUitl : NSObject
{
    
    @private
    BOOL _isLoad;
}
@property (nonatomic,strong) EGODatabase *placeDatabase;
@property (nonatomic, assign, getter = isLoaded) BOOL loaded; //配置完成
@property (strong, nonatomic) NSDictionary *areaDict;//固话归属地
+ (ContactUitl *)shareInstance;
//解压文本导入数据库
- (void)unzipDBFile;
- (NSInteger)count;
//读取固话归属地
- (NSDictionary *)readAreaCode;
// 添加号码归属地方法
- (NSString *)queryByPhone:(NSString *)phone;


@end
