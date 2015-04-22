//
//  HangupModel.h
//  RKWXT
//
//  Created by SHB on 15/4/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HangupDelegate;
@interface HangupModel : NSObject
@property (nonatomic,assign) id<HangupDelegate>hangupDelegate;
-(void)hangupWithCallID:(NSString *)callID;
@end

@protocol HangupDelegate <NSObject>
-(void)hangupSucceed;
-(void)hangupFailed:(NSString*)failedMsg;

@end
