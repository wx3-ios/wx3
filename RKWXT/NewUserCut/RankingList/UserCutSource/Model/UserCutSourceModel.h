//
//  UserCutSourceModel.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserCutSourceModelDelegate;

@interface UserCutSourceModel : NSObject
@property (nonatomic,assign) id<UserCutSourceModelDelegate>delegate;
@property (nonatomic,strong) NSArray *sourceArr;

-(void)loadUserCutSource;
@end

@protocol UserCutSourceModelDelegate <NSObject>
-(void)loadUserCutSourceSucceed;
-(void)loadUserCutSourceFailed:(NSString*)errorMsg;

@end
