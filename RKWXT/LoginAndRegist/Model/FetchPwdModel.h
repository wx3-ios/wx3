//
//  FetchPwdModel.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchPwdDelegate;
@interface FetchPwdModel : NSObject
@property (nonatomic,assign) id<FetchPwdDelegate>delegate;

-(void)fetchPwdWithUserPhone:(NSString*)phone;
@end

@protocol FetchPwdDelegate <NSObject>
-(void)fetchPwdSucceed;
-(void)fetchPwdFailed:(NSString*)errorMsg;

@end
