//
//  CallModel.h
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MakeCallDelegate;
@interface CallModel : NSObject
@property (nonatomic,assign) id<MakeCallDelegate>callDelegate;
-(void)makeCallPhone:(NSString*)phoneStr;
@end

@protocol MakeCallDelegate <NSObject>
-(void)makeCallPhoneSucceed;
-(void)makeCallPhoneFailed:(NSString*)failedMsg;

@end
