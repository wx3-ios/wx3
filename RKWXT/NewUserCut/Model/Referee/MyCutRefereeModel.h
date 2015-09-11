//
//  MyCutRefereeModel.h
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@protocol LoadMyCutRefereeModelDelegate;

@interface MyCutRefereeModel : T_HPSubBaseModel
@property (nonatomic,assign) id<LoadMyCutRefereeModelDelegate>delegate;
@property (nonatomic,strong) NSArray *myCutInfoArr;

-(void)loadMyCutRefereeInfo;
@end

@protocol LoadMyCutRefereeModelDelegate <NSObject>
-(void)loadMyCutRefereeInfoSucceed;
-(void)loadMyCutRefereeInfoFailed:(NSString*)errorMsg;

@end
