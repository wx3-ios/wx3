//
//  LoadAreaModel.h
//  RKWXT
//
//  Created by SHB on 15/11/5.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadAreaModel : NSObject
@property (nonatomic,strong) NSString *areaVersion;  //服务器端区域存储版本号
-(void)loadAllAreaData;

@end
