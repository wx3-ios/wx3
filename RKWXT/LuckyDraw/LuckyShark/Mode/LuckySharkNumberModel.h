//
//  LuckySharkNumberModel.h
//  RKWXT
//
//  Created by SHB on 15/8/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LuckySharkNumberModelDelegate;

@interface LuckySharkNumberModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckySharkNumberModelDelegate>delegate;
@property (nonatomic,assign) NSInteger number;

-(void)loadLuckySharkNumber;
@end

@protocol LuckySharkNumberModelDelegate <NSObject>
-(void)loadLuckySharkNumberSucceed;
-(void)loadLuckySharkNumberFailed:(NSString*)errormsg;

@end
