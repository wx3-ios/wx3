//
//  WXContacterEntity.h
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

typedef enum {
    E_WXContacterStatus_ISWX = 0, //当前为我信用户~
    E_WXContacterStatus_ToAdd, //可添加为我信用户~ 但还不是我信好友~
    E_WXContacterStatus_AcceptInvit, //添加好友请求
    E_WXContacterStatus_WaitForRecept, //等待接受号码申请（添加好友，等待对方接受请求~）
    E_WXContacterStatus_NoneWX, //和我信没有关系
    
    E_WXContacterStatus_Invalid
}E_WXContacterStatus;

#import <Foundation/Foundation.h>
#import "ContactBaseEntity.h"

@interface WXContacterEntity : ContactBaseEntity
@property (nonatomic,retain)NSString *nickName;//昵称~
@property (nonatomic,retain)NSString *wxID;//我信唯一ID~
@property (nonatomic,retain)NSString *rID;//lib库分配的唯一ID
@property (nonatomic,assign)NSInteger recordID;
@property (nonatomic,retain)NSString *bindID; //绑定的ID 目前为电话号码~
@property (nonatomic,retain)NSString *iconPath; //联系人的图标~
@property (nonatomic,retain)NSString *remark;//备注名~
//目前不用~
@property (nonatomic,assign)E_WXContacterStatus wxStatus; //联系人的状态~

+ (WXContacterEntity*)wxContacterWithParamArray:(NSArray*)array;
+ (WXContacterEntity*)increaseWXContacterWithParamArray:(NSArray *)array;
@end