//
//  JuniorListEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JuniorListEntity : NSObject
@property (nonatomic,assign) NSInteger clientNums;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,assign) NSInteger wxID;
@property (nonatomic,assign) NSInteger rankingNum;

+(JuniorListEntity*)initJuniorListEntity:(NSDictionary*)dic;

@end
