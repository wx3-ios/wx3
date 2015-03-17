//
//  ContactBaseEntity.h
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSearchEntity.h"

typedef enum {
    E_ContactRightView_None,
    E_ContactRightView_Add, //点击添加好友
    E_ContactRightView_Accept, //点击接受好友请求
    E_ContactRightView_WaiteForAccpet, //等待对方接受好友请求
    E_ContactRightView_HasNewFriend, //有好友请求~
    E_ContactRightView_ShowWXIcon, //显示我信图片
}E_ContactRightView;

@interface ContactBaseEntity : BaseSearchEntity
- (NSString*)nameShow;
- (UIImage*)iconShow;
- (E_ContactRightView)rightViewType;
@end

@interface ContactBaseEntity (Detail)
- (BOOL)shouldShowInviteButton;
- (BOOL)shouldShowNickName;
- (NSString*)nickNameShow;
- (NSArray *)callHistory;
- (NSArray*)contactPhoneArray;
@end

@interface ContactPhone : NSObject
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,assign)BOOL isWX;
@end

