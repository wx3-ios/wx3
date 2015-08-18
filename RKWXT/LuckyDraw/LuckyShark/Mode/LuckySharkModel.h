//
//  LuckySharkModel.h
//  RKWXT
//
//  Created by SHB on 15/8/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LuckySharkModelDelegate;

@interface LuckySharkModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LuckySharkModelDelegate>delegate;
@property (nonatomic,strong) NSArray *luckyGoodsArr;

-(void)loadUserShark;
@end

@protocol LuckySharkModelDelegate <NSObject>
-(void)luckySharkSucceed;
-(void)luckySharkFailed:(NSString*)errorMsg;

@end
