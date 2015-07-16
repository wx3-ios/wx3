//
//  JPushInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/7/15.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol JPushMessageDelegate;

@interface JPushInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) id<JPushMessageDelegate>delegate;
@property (nonatomic,strong) NSArray *infoArr;

-(void)loadJPushMessageInfoWit:(NSInteger)messageID;
@end

@protocol JPushMessageDelegate <NSObject>
-(void)loadJPushMessageSucceed;
-(void)loadJPushMessageFailed:(NSString*)errorMsg;

@end
