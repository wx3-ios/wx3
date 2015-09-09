//
//  UserHeaderModel.h
//  RKWXT
//
//  Created by SHB on 15/9/9.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

@interface UserHeaderModel : T_HPSubBaseModel
@property (nonatomic,strong) NSString *userHeaderImg;

+(UserHeaderModel*)shareUserHeaderModel;
-(void)loadUserHeaderImageWith;
-(void)updateUserHeaderSucceed:(NSString *)headerPath;

@end
