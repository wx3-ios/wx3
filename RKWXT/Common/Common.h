//
//  Common.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#ifndef WoXin_Common_h
#define WoXin_Common_h

#define RELEASE_SAFELY(_obj) if(_obj) { [_obj release]; _obj = nil; }
#define RETAIN_SAFELY(_receiver, _assigner) do { id __assigner = _assigner; if (__assigner != _receiver) { [_receiver release]; _receiver = [__assigner retain]; } } while (0)

typedef enum {
    E_Sex_Female = 0, //女性
    E_Sex_Male,     //男性
}E_Sex;

typedef enum {
    E_DeviceType_Android =1,
    E_DeviceType_IOS,
}E_DeviceType;

#define kUIViewAutoresizingFlexibleAll UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin
#pragma mark 系统的一些尺寸以及版本定义~
//上层ui统一使用该宏作为screen的宽度和高度
#define IS_IPHONE_5 (UIDeviceScreenType_iPhoneRetina4Inch == [UIDevice currentScreenType])
#define iosVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define isIOS6     (iosVersion >= 6.0 && iosVersion < 7.0)
#define isIOS7     (iosVersion >= 7.0)
#define isIOS8     (iosVersion >= 8.0)
#define IPHONE_SCREEN_WIDTH 320
#define IPHONE_SCREEN_HEIGHT (IS_IPHONE_5 ? 568 : 480)
#define IPHONE_STATUS_BAR_HEIGHT 20                     //状态栏高度
#define NAVIGATION_BAR_HEGITH      (44)
#define TAB_NAVIGATION_BAR_HEGITH  (49)
#define kIOS7OffX                  (-15)


#pragma 全局的Notification宏
#define D_Notification_Name_ReceiveAudioCallPush @"D_Notification_Name_ReceiveCallPush"//接收到语音通话的推送~
#define D_Notification_Name_AppEnterBackGround @"D_Notification_Name_AppEnterBackGround"//程序进入后台
#define D_Notification_Name_AppEnterForground @"D_Notification_Name_AppEnterForground"//程序进入前台~
#define D_Notification_Name_HasLogin @"D_Notification_Name_HasLogin" //已经登录
#define D_Notification_Name_HasLogout @"D_Notification_Name_HasLogout"//已经退出登陆~


#pragma mark 通讯录
#define D_Notification_Name_AddressBookHasChanged @"D_Notification_Name_AddressBookHasChanged"//通讯录发生了改变
#pragma mark 我信通讯录~
#define D_Notification_Name_WXAddressBookHasChanged @"D_Notification_Name_WXAddressBookHasChanged"//我信通讯录发生了变化~
#define D_Notification_Name_WXContacterHasChanged @"D_Notification_Name_WXContacterHasChanged"//单个我信联系人发生了变化~
#define D_Notification_Name_WXContacterAdded @"D_Notification_Name_WXContacterAdded"//增加了一个我信联系人~
#define D_Notification_Name_WXContacterDeleted @"D_Notification_Name_WXContacterDeleted"//删除了一个我信联系人~

#pragma mark 个人信息
#define D_Notification_Name_PersonalInfoUpload_Failed @"D_Notification_Name_PersonalInfoUpload_Failed"//上传个人信息失败
#define D_Notification_Name_PersonalInfoUpload_Succeed @"D_Notification_Name_PersonalInfoUpload_Succeed"//上传个人信息成功
#define D_Notification_Name_PersonalIconUploadFailed @"D_Notification_Name_PersonalIconUploadFailed"//上传个人图片失败
#define D_Notification_Name_PersonalIconUploadSucceed @"D_Notification_Name_PersonalIconUploadSucceed"//上传个人图片成功

#pragma mark 通话记录
#define D_Notification_Name_CallRecordLoadFinished @"D_Notification_Name_CallRecordLoadFinished" //通话记录加载完毕
#define D_Notification_Name_CallRecordAdded @"D_Notification_Name_CallRecordAdded" //新增了一个通话记录~

#pragma mark 分店修改了~
#define D_Notification_Name_SubShopHasChanged @"D_Notification_Name_SubShopHasChanged" //分店发生了改变~

#pragma mark 检测系统来电
#define D_Notification_Name_SystemCallIncomming @"D_Notification_Name_SystemCallIncomming"//系统来电~
#define D_Notification_Name_SystemCallFinished @"D_Notification_Name_SystemCallFinished" //系统通话结束~

#pragma mark 商城
typedef enum {
    E_CategoryType_Good = 0,//商品~
    E_CategoryType_PacketGood,//套餐~
}E_GoodType;

#define D_Notification_Name_AllGoodsLoadedFinished @"D_Notification_Name_AllGoodsLoadedFinished" //所有商品加载完毕~
#define D_Notification_Name_NewGoodAdded @"D_Notification_Name_NewGoodAdded" //新加载了一件商品~

#pragma mark 菜单
#define D_Notification_Name_MenuItemUpdate @"D_Notification_Name_MenuItemUpdate"//更新了一个菜单~

#pragma mark  延迟提示连接服务器失败的提示
#define D_Notification_Name_NetTipDelayFinished @"D_Notification_Name_NetTipDelayFinished" //延迟提示连接服务器失败的提示

#pragma mark 网络检测
#define D_Notification_Name_NetWorkDisconnected @"D_Notification_Name_NetWorkUnreachable" //网络连接断开~
#define	D_Notification_Name_NetWorkWifi @"D_Notification_Name_NetWorkWifi" //wifi连接
#define	D_Notification_Name_NetWorkWWAN @"D_Notification_Name_NetWorkWWAN" //3G

#define	D_Notification_Name_AutoLoginHasCalled @"D_Notification_Name_AutoLoginHasCalled"//登录接口已经调用~

//商城顶部图片~
#define kGoodTopImageSize CGSizeMake(460.0,230.0)
//icon图片~
#define kGoodIconSize CGSizeMake(174.0,162.0)
//商品详情顶部图片~
#define kGoodImageDetailTop CGSizeMake(457.0,405.0)
//消息图片
#define kMessageImage CGSizeMake(320,160)
//联系人头像
#define kPersonalHeadImgSize CGSizeMake (150,150)

typedef enum {
    //商城顶部图片
    E_ImageType_Good_Top = 0,
    //商品icon （小图片）
    E_ImageType_Good_Icon,
    //商品详情顶部图片~ （大图片）
    E_ImageType_Good_DetailTop,
    //消息图片
    E_ImageType_Message_Image,
    //联系人头像
    E_ImageType_Personal_Img,
    
    E_Image_Type_Invalid,
}E_Image_Type;

#endif
