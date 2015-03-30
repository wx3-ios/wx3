//
//  CallBackVC.h
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseVC.h"

@interface CallBackVC : BaseVC

@property (nonatomic,strong) NSString *phoneName;   //手机号或名字

//多重判断，如果返回NO说明号码格式不正确,先做判断再跳转
-(BOOL)callPhone:(NSString *)phone;

@end
