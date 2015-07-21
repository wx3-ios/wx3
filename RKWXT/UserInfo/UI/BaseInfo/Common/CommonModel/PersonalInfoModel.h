//
//  PersonalInfoModel.h
//  RKWXT
//
//  Created by SHB on 15/7/20.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "T_HPSubBaseModel.h"

typedef enum{
    PersonalInfo_Type_Updata = 1,
    PersonalInfo_Type_Load,
}PersonalInfo_Type;

@protocol PersonalInfoModelDelegate;

@interface PersonalInfoModel : T_HPSubBaseModel
@property (nonatomic,strong) NSArray *personalInfoArr;
@property (nonatomic,assign) PersonalInfo_Type type;
@property (nonatomic,assign) id<PersonalInfoModelDelegate>delegate;

-(void)loadUserInfo;
-(void)updataUserInfoWith:(NSInteger)sex withNickName:(NSString*)nickName withBirthday:(NSString*)birStr;
@end

@protocol PersonalInfoModelDelegate <NSObject>
-(void)updataPersonalInfoSucceed;
-(void)updataPersonalInfoFailed:(NSString*)errorMsg;
-(void)loadPersonalInfoSucceed;
-(void)loadPersonalInfoFainled:(NSString*)errorMsg;

@end
