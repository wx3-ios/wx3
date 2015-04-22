//
//  CallModel.h
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CallStatus_Type_Normal = 0,
    CallStatus_Type_starting,
    CallStatus_Type_Ending,
}CallStatus_Type;

@protocol MakeCallDelegate;
@interface CallModel : NSObject
@property (nonatomic,assign) id<MakeCallDelegate>callDelegate;
@property (nonatomic,assign) CallStatus_Type callstatus_type;
@property (nonatomic,strong) NSString *callID;
-(void)makeCallPhone:(NSString *)phoneStr;
@end

@protocol MakeCallDelegate <NSObject>
-(void)makeCallPhoneSucceed;
-(void)makeCallPhoneFailed:(NSString*)failedMsg;

@end
