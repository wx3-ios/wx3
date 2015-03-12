//
//  UserInfoCommonCell.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITableViewCell.h"

typedef enum{
    WXT_UserInfo_Recharge = 0,
    WXT_UserInfo_Balance,
    WXT_UserInfo_Sign,
    
    WXT_UserInfo_Invalid,
}WXT_UserInfo;
#define UserInfoCommonCellHeight (44)

@interface UserInfoCommonCell : WXTUITableViewCell
-(void)loadUserInfoBaseData:(NSInteger)row;

@end
