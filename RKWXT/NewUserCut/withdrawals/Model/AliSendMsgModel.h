//
//  AliSendMsgModel.h
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AliSendMsgModelDelegate;

@interface AliSendMsgModel : NSObject
@property (nonatomic,assign) id<AliSendMsgModelDelegate>delegate;

-(void)sendALiMsg:(NSString*)phone;

@end

@protocol AliSendMsgModelDelegate <NSObject>
-(void)sendALiMsgSucceed;
-(void)sendALiMsgFailed:(NSString*)errorMsg;

@end
