//
//  HomeLimitBuyModel.h
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol HomeLimitBuyModelDelegate;
@interface HomeLimitBuyModel : T_HPSubBaseModel
@property (nonatomic,assign) id<HomeLimitBuyModelDelegate>delegate;
@end

@protocol HomeLimitBuyModelDelegate <NSObject>
-(void)homeLimitBuyLoadSucceed;
-(void)homeLimitBuyLoadFailed:(NSString*)errorMsg;

@end
