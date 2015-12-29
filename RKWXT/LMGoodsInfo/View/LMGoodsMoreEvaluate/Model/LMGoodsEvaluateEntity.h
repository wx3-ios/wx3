//
//  LMGoodsEvaluateEntity.h
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMGoodsEvaluateEntity : NSObject
@property (nonatomic,assign) NSInteger addTime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *userHeadImg;

+(LMGoodsEvaluateEntity*)initLMGoodsEvaluateEntity:(NSDictionary*)dic;

@end
