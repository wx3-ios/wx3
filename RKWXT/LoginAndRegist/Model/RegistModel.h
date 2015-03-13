//
//  RegistModel.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegistDelegate;
@interface RegistModel : NSObject
@property (nonatomic,assign) id<RegistDelegate>delegate;
-(void)registWithUserPhone:(NSString*)userStr;
@end

@protocol RegistDelegate <NSObject>
-(void)registSucceed;
-(void)registFailed:(NSString*)errorMsg;

@end
