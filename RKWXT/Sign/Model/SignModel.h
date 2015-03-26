//
//  SignModel.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LastSignDate @"LastSignDate"
#define GainMoneyForSign @"GainMoneyForSign"

@protocol SignDelegate;
@interface SignModel : NSObject
@property (nonatomic,strong) NSArray *signArr;
@property (nonatomic,assign) id<SignDelegate>delegate;
-(void)signGainMoney;
@end

@protocol SignDelegate <NSObject>
-(void)signSucceed;
-(void)signFailed:(NSString*)errorMsg;

@end
