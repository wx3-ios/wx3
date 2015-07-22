//
//  WXService.h
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCommon.h"

@interface WXService : NSObject
@property (nonatomic,assign)BOOL hasCalledLogin;

+ (WXService*)sharedService;
//- (BOOL)initServerLib;
//
//- (NSString*)dbDir;//DB path
//- (void)setLogOpen:(BOOL)bOpen;//是否打开日志
//- (NSInteger)fetchAuthCode:(NSString*)user error:(WXError**)error;//获取验证码
//- (NSInteger)registerUser:(NSString*)user merchantID:(NSInteger)merchantID password:(NSString*)password authCode:(NSString*)authCode error:(WXError**)error;//注册
//- (NSInteger)unRegisterUser:(NSString*)user merchantID:(NSInteger)merchantID password:(NSString*)password error:(WXError**)errror;//注销
//- (NSInteger)login:(NSString*)user password:(NSString*)password erorr:(WXError**)error;//登陆
//- (NSInteger)logout:(NSString*)user password:(NSString*)password error:(WXError**)error;//退出登陆
//- (NSInteger)updateUser:(NSString*)user oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword error:(WXError**)erorr;//修改密码
//- (NSInteger)findPassword:(NSString*)user phoneNumber:(NSString*)phoneNumber error:(WXError**)erorr;//找回密码
@end

@interface WXService (Contacter)
//- (NSInteger)updateContacter:(NSInteger)recordID name:(NSString*)name phone:(NSString*)phone
//                  createTime:(NSInteger)createTime modifyTime:(NSInteger)modifyTime;//程序启动的时候将通讯录上传~
//- (NSInteger)loadWXContacterFromDB;//获取我信用户~
//- (NSString*)wxContacterIcon:(NSUInteger)rID;//获取我信用户的图标~
//- (NSInteger)deleteWXContacter:(NSUInteger)rID;//删除我信用户~
//- (NSInteger)updateNickName:(NSString*)nickName rID:(NSUInteger)rID;//更新别名
//- (NSInteger)updateWXIcon:(NSString*)iconPath;//上传自定义图片
//- (NSInteger)uploadDeviceInfo;//上传设备信息
@end

@class PersonalInfo;
@interface WXService (Call)
//- (BOOL)makeBackCall:(NSString*)phone; //回拨
//- (BOOL)makeCall:(NSString*)phone;//拨打电话~
//- (BOOL)hangUpBackCall:(NSString*)phone;//挂断回拨
//
//
//- (BOOL)cancelCall;//主叫主动取消电话呼叫~
//- (BOOL)rejectCall:(BOOL)isOverTime;//被叫拒听
//- (BOOL)releaseCall;//通话建立了之后~ 挂断~
//
//- (BOOL)alertCall;//被叫接到主叫invite消息，返回响铃
//- (BOOL)answerCall;//被叫接听
//
//- (BOOL)setCallTimeOut:(NSUInteger)timeOut; //设置超时时间 默认为3秒
//- (BOOL)sendPCM:(NSData*)pcmData;//发送PCM数据~
@end

@interface WXService (UserInfo)
//- (NSString*)iconDir;;//图片的目录
//- (UIImage*)getFriendIcon:(NSInteger)rID;//获取好友图片~
- (BOOL)uploadIcon:(NSData*)imageData;//上传图像~
//- (BOOL)updateUserInfo:(PersonalInfo*)entity;
@end
