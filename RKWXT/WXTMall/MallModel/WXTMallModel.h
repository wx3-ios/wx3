//
//  WXTMallModel.h
//  RKWXT
//
//  Created by SHB on 15/3/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol wxtMallDelegate;
@interface WXTMallModel : NSObject
@property (nonatomic,strong) NSArray *mallDataArr;
@property (nonatomic,assign) id<wxtMallDelegate>mallDelegate;
-(void)loadMallData;
@end

@protocol wxtMallDelegate <NSObject>
-(void)initMalldataSucceed;
-(void)initMalldataFailed:(NSString*)errorMsg;

@end
