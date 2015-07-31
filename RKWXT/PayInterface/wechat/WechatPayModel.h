//
//  WechatPayModel.h
//  RKWXT
//
//  Created by SHB on 15/7/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol WechatPayModelDelegate;

@interface WechatPayModel : T_HPSubBaseModel
@property (nonatomic,assign) id<WechatPayModelDelegate>delegate;
@property (nonatomic,strong) NSArray *wechatArr;

-(void)wechatPayWithOrderID:(NSString*)orderID;
@end

@protocol WechatPayModelDelegate <NSObject>
-(void)wechatPayLoadSucceed;
-(void)wechatPayLoadFailed:(NSString*)errorMsg;

@end
