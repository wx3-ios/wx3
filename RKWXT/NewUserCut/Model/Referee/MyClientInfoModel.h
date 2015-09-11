//
//  MyClientInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol MyClientInfoModelDelegate;

@interface MyClientInfoModel : T_HPSubBaseModel
@property (nonatomic,assign) id<MyClientInfoModelDelegate>delegate;
@property (nonatomic,strong) NSArray *myClientInfoArr;

-(void)loadMyClientInfoWithWxID:(NSString*)wxID;
@end

@protocol MyClientInfoModelDelegate <NSObject>
-(void)loadMyClientInfoSucceed;
-(void)loadMyClientInfoFailed:(NSString*)errorMsg;

@end
