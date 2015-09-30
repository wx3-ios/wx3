//
//  ApplyAliModel.h
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApplyAliModelDelegate;

@interface ApplyAliModel : NSObject
@property (nonatomic,assign) id<ApplyAliModelDelegate>delegate;

-(void)applyAliMoney:(CGFloat)money;

@end

@protocol ApplyAliModelDelegate <NSObject>
-(void)applyAliMoneySucceed;
-(void)applyAliMoneyFailed:(NSString*)errorMsg;

@end
