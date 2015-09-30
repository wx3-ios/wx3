//
//  MyRefereeEntity.h
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRefereeEntity : NSObject
@property (nonatomic,assign) NSInteger userID;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userIconImg;
@property (nonatomic,assign) CGFloat cutMoney;
@property (nonatomic,assign) CGFloat allMoney;
@property (nonatomic,assign) CGFloat balance;
@property (nonatomic,assign) NSInteger registTime;

+(MyRefereeEntity*)initRefereeEntityWithDic:(NSDictionary*)dic;

@end
