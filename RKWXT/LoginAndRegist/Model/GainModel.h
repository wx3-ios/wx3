//
//  GainModel.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GainNumDelegate;
@interface GainModel : NSObject
@property (nonatomic,assign) id<GainNumDelegate>delegate;
-(void)gainNumber:(NSString*)userStr;
@end

@protocol GainNumDelegate <NSObject>
-(void)gainNumSucceed;
-(void)gainNumFailed:(NSString*)errorMsg;

@end
