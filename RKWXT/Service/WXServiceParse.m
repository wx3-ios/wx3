//
//  WXServiceParse.m
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXServiceParse.h"
#import "ServiceCommon.h"
//#import "MyOrderListObj.h"

//改变登陆状态的返回值
enum{
    E_LogStatusErrorCode_Invalid = 0, //未知,初始化
    E_LogStatusErrorCode_LogIn,       //上线
    E_LogStatusErrorCode_LogOut,      //离线
    E_LogStatusErrorCode_NotHear,     //离开，暂时不在电脑旁边
    E_LogStatusErrorCode_Busy,        //忙碌
    E_LogStatusErrorCode_InCall,      //通话中
    E_LogStatusErrorCode_Hiding,      //隐身
    E_LogStatusErrorCode_NOBother,   //请勿打扰
    
    E_LogStatusErrorCode_InLogIn,    //登录过程中
    E_LogStatusErrorCode_LoginSucceed, //登录成功
    E_LogStatusErrorCode_LoginFaield,   //登录失败
    E_LogStatusErrorCode_InLogOut,     //退出登录过程中
    E_LogStatusErrorCode_LogOutSucceed, //退出登录成功
    E_LogStatusErrorCode_LogOutFailed,  //退出登录失败
    E_LogStatusErrorCode_ConnectToServerOK, // 连接注册服务器成功
    E_LogStatusErrorCode_DisconnectToServerOK, //注册服务器连接断开
	
	E_LogStatusErrorCode_NoSuchAccount = 17,//登录账号不存在~
	E_LogStatusErrorCode_LoginTimeOut = 18,//登录超时~
};

typedef enum {
#pragma mark 用户信息
    E_Service_MessageID_FetchAuthCode = 109,//获取验证码
    E_Service_MessageID_Register = 110,//注册
    E_Service_MessageID_UnRegister = 111,//注销
    E_Service_MessageID_SwitchLogStatus = 100,//改变登陆状态
    E_Service_MessageID_UpdatePWD = 101,//修改密码
    E_Service_Message_ID_FindPWD = 102,//获取密码
#pragma mark 通话
    E_Call_Message_ID_Confirm_MakeCall = 119, //make call的confirm返回~
    E_Call_Message_ID_Confirm_MakeCall_TimeOut = 140,
    E_Call_Message_ID_Signalling_IncommingCall = 124,//被叫来电信令
    E_Call_Message_ID_Signalling_CalledRing = 125,//被叫响铃 主叫收到的信令
    
    E_Call_Message_ID_Confirm_CancelCall = 120, //主叫取消呼叫
    E_Call_Message_ID_Confirm_CancelCall_TimeOut = 141,
    E_Call_Message_ID_Signalling_CallerCancelCall = 131,//主叫主动挂机~ 对方还在响铃，被叫收到的信令
    
    E_Call_Message_ID_Confirm_AlertCall = 128, //被叫返回响铃
    E_Call_Message_ID_Confirm_AlertCall_TimeOut = 142,
    
    E_Call_Message_ID_Confirm_AnswerCall = 121,//被叫接听
    E_Call_Message_ID_Confirm_AnswerCall_TimeOut = 143,
    E_Call_Message_ID_Signalling_CalledAnswer = 129,//主叫收到被叫接听的信令
    
    E_Call_Message_ID_Confirm_RejectCall = 122,//被叫拒听
    E_Call_Message_ID_Confirm_RejectCall_TimeOut = 144,
    E_Call_Message_ID_Signalling_RejectCall = 133, //被叫拒听
    
    E_Call_Message_ID_Confirm_ReleaseCall = 123,//通话建立之后一方挂断
    E_Call_Message_ID_Confirm_ReleaseCall_TimeOut = 145,
    E_Call_Message_ID_Signalling_CallFinishedNormal = 130,//通话正常结束
#pragma mark 通讯录~
    E_Service_Message_ID_LoadAddressbook = 112,//加载通讯录~
    E_Service_Message_ID_LoadWXFriend = 152,//加载我信用户~
    E_Service_Message_ID_IncreasedWXFriend = 150, //增加或者删除一个我信好友~
    E_Service_Message_ID_NickNameChanged = 151,//昵称发生了改变~
    E_Service_Message_ID_IconChanged = 116,//图像发生了改变~
#pragma mark 通话记录~
    E_Service_Message_ID_LoadCallRecord = 153,//加载通话记录~
    E_Service_Message_ID_CallRecordAdded = 135, // 增加了通话记录~
#pragma mark 用户信息~
    E_Service_Message_ID_UploadPersonalIcon = 114,//上传个人图片~
    E_Service_Message_ID_UploadPersonalInfo = 155,//上传个人信息
    
#pragma mark 商城
    E_Service_Message_ID_LoadGoodList = 171,//加载商品列表
    E_Service_Message_ID_AddAGood = 1,//增加了一个商品
    E_Service_Message_ID_LoadMenuList = 165,//加载菜单列表~
//    E_Service_Message_ID_LoadTopGoods = 162,//加载顶部商品~
	E_Service_Message_ID_LoadTopGoods = 198,//加载顶部商品~
    E_Service_Message_ID_LoadActivityGoods = 163,//加载活动商品
    E_Service_Message_ID_GuessYouLikeGoods = 164,//猜你喜欢的商品~
    E_Service_Message_ID_LoadSetMeals = 170,//加载所有套餐
    
    E_Service_Message_ID_LoadOfficeCity = 160,//商家的所有地区
    E_Service_Message_ID_LoadBranchOffice = 161, //该地区有多少分店
    E_Service_Message_ID_LoadLocation = 168, //该地区有多少分店
    E_Service_message_ID_UpdateBranch = 186, //更新用户注册的分店
    
    E_Service_Message_ID_LoadOrderList = 175, //订单列表
    E_Service_Message_ID_AddAnOrder = 172,      //添加订单
	E_Service_Message_ID_DeleteOrder = 174,	    //删除订单~
    E_Service_Message_ID_LoadGoodsInfo = 167,      //加载商品详情
	E_Service_Message_ID_ConfirmOrder = 202,  //确认订单
	E_Service_Message_ID_CancelOrder = 203,		//取消订单~
	E_Service_Message_ID_LoadSingleOrder = 204,//单个订单获取
    
#pragma mark 红包
    E_Service_Message_ID_LoadRedPager = 176,      //加载红包
    E_Service_Message_ID_GainRedPager = 177,      //领取红包
    E_Service_Message_ID_UseRedPager = 178,      //使用红包
    E_Service_Message_ID_LoadRPRule = 179,      //红包使用规则
    E_Service_Message_ID_LoadRPBalance = 181,      //加载红包余额
    
#pragma mark 推送~
    E_Service_Message_ID_IncomePushInfo = 180, //推送的信息
    
#pragma mark 关于
    E_Service_Message_ID_LoadOfficeInfo = 183, //关于分店~
    E_Service_Message_ID_LoadShopInfo = 182, //关于商家
    E_Service_Message_ID_LoadUseHelp = 188, //加载我信使用帮助
    E_Service_Message_ID_LoadWXContact = 187,//加载我信联系方式
    E_Service_Message_ID_WxFeedBack = 190,//我信问题反馈
    E_Service_Message_ID_WxUseProtocal = 189,//我信用户协议
    
#pragma mark 版本更新
    E_Service_Message_ID_VersionUpdate = 104, //版本更新
#pragma mark 上传token
    E_Service_Message_ID_TokenUpdate = 185,//上传token
    
#pragma mark 获取个人信息
    E_Service_Message_ID_LoadPersonInfo = 154,//获取个人信息
    
#pragma mark 充值
    E_Service_Message_ID_LoadRechargeRule = 193,//调取充值规则
    E_Service_Message_ID_Recharge = 192, //充值接口
    E_Service_Message_ID_LoadWxBalance = 195, //充值接口
#pragma mark 被踢下线~
    E_Service_Message_ID_KickedOut = 191,//异地登陆~
#pragma mark 回拨
    E_Service_Message_ID_BackCall = 108,//回拨状态
#pragma mark 记载分店列表
	E_Service_Message_ID_FectchSubShopList = 197, //记载分店列表
#pragma mark DB库数据结构发生了更新~
	E_Service_Message_ID_DBStructChanged = 201,//DB库数据结构发生了更新~
#pragma mark 获取流水号或支付URL
	E_Service_Message_ID_GetOrderCodePayMode = 199, //获取流水号或支付URL
    E_Service_Message_ID_GetApplyRefundResult = 200, //申请支付是否成功
    E_Service_Message_ID_LoadRefundStatusInfo = 207,  //当前退款状态的信息
}E_Service_Message_ID;

@implementation WXServiceParse

+ (id)sharedWXServiceParse{
    static dispatch_once_t onceToken;
    static WXServiceParse *sharedServiceParse = nil;
    dispatch_once(&onceToken, ^{
        sharedServiceParse = [[WXServiceParse alloc] init];
    });
    return sharedServiceParse;
}

- (void)parseMessageID:(SS_UINT32)messageID pParam:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject
{
    if(paramNumber <= 0){
        return;
    }
    WXError *error = [[[WXError alloc] init] autorelease];
    NSInteger retCode = [self errorCode:pParam[0]];
    switch (messageID) {
#pragma mark 账号
        case E_Service_MessageID_FetchAuthCode:
            *pNotificationName = D_Notification_Name_FetchAuthCodeSucceed;
            if(retCode != SS_SUCCESS){
                *pNotificationName = D_Notification_Name_FetchAuthCodeFailed;
            }
            break;
        case E_Service_MessageID_Register:
            [self parseRegister:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_MessageID_UnRegister:
            [self parseUnRegister:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_MessageID_SwitchLogStatus:
            [self parseSwitchLogStatus:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
//        case E_Service_MessageID_UpdatePWD:
//            *pNotificationName = D_Notification_Name_UpdatePWDSucceed;
//            if(retCode != SS_SUCCESS){
//                *pNotificationName = D_Notification_Name_UpdatePWDFailed;
//                KFLog_Normal(YES, @"修改密码失败");
//            }else{
//                KFLog_Normal(YES, @"修改密码成功");
//            }
//            break;
        case E_Service_MessageID_UpdatePWD:   //重置密码
            [self parseChangePassWord:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_FindPWD:
            *pNotificationName = D_Notification_Name_FindPassWordSucceed;
            if(retCode != SS_SUCCESS){
                *pNotificationName = D_Notification_Name_FindPasssWordFailed;
                KFLog_Normal(YES, @"找回密码失败");
            }else{
                KFLog_Normal(YES, @"找回密码成功");
            }
            break;
#pragma mark 通话~
        case E_Call_Message_ID_Confirm_MakeCall: //make call的confirm返回~
            [self parseMakeCall:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Call_Message_ID_Confirm_MakeCall_TimeOut:
            KFLog_Normal(YES, @"呼叫超时");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_MakeCallTimeOut];
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_IncommingCall:
            KFLog_Normal(YES, @"来电");
            *pNotificationName = D_Notification_Name_IncommingCall;
//            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_CalledRing://被叫响铃 主叫收到的信令
            KFLog_Normal(YES, @"接收到被叫响铃信令");
            *pNotificationName = D_Notification_Name_CallEarly;
            break;
        case E_Call_Message_ID_Confirm_CancelCall://主叫取消呼叫
            if(retCode == 0){
                KFLog_Normal(YES, @"主叫取消呼叫成功");
                [error setErrorCode:E_CallFinishReason_Normal];
            }else{
                KFLog_Normal(YES, @"主叫取消呼叫失败");
                [error setErrorCode:E_CallFinishReason_HangUpFailed];
            }
            *pNotificationName = D_Notification_Name_CallDisconnected;
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Confirm_CancelCall_TimeOut:
            KFLog_Normal(YES, @"主叫取消呼叫超时");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_HangUpFailed];
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_CallerCancelCall://主叫主动挂机~ 对方还在响铃，被叫收到的信令
            KFLog_Normal(YES, @"被叫接收到主叫取消呼叫的信令");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_Normal];
            *pNotificationObject = error;
            break;
            
        case E_Call_Message_ID_Confirm_AlertCall://被叫响铃返回
            if(retCode == 0){
                KFLog_Normal(YES, @"被叫响铃返回成功");
            }else{
                KFLog_Normal(YES, @"被叫响铃返回失败");
                *pNotificationName = D_Notification_Name_CallDisconnected;
                [error setErrorCode:E_CallFinishReason_RingFailed];
                *pNotificationObject = error;
            }
            break;
        case E_Call_Message_ID_Confirm_AlertCall_TimeOut:
            KFLog_Normal(YES, @"被叫响铃返回超时");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_RingFailed];
            *pNotificationObject = error;
            break;
            
        case E_Call_Message_ID_Confirm_AnswerCall://被叫接听
            if(retCode == 0){
                KFLog_Normal(YES, @"被叫接听返回成功");
                *pNotificationName = D_Notification_Name_CallConfirmed;
            }else{
                KFLog_Normal(YES, @"被叫接听返回失败");
                *pNotificationName = D_Notification_Name_CallDisconnected;
                [error setErrorCode:E_CallFinishReason_AnswerFailed];
                *pNotificationObject = error;
            }
            break;
        case E_Call_Message_ID_Confirm_AnswerCall_TimeOut:
            KFLog_Normal(YES, @"被叫接听返回超时");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_AnswerFailed];
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_CalledAnswer://被叫接听
            KFLog_Normal(YES, @"主叫收到被叫接听的信令");
            *pNotificationName = D_Notification_Name_CallConfirmed;
            break;
        case E_Call_Message_ID_Confirm_RejectCall://被叫拒听
            if(retCode == 0){
                KFLog_Normal(YES, @"被叫拒听返回成功");
                [error setErrorCode:E_CallFinishReason_Normal];
            }else{
                KFLog_Normal(YES, @"被叫拒听返回失败");
                [error setErrorCode:E_CallFinishReason_HangUpFailed];
                *pNotificationObject = error;
            }
            *pNotificationName = D_Notification_Name_CallDisconnected;
            break;
        case E_Call_Message_ID_Confirm_RejectCall_TimeOut:
            KFLog_Normal(YES, @"被叫拒听返回超时");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_HangUpFailed];
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_RejectCall://被叫拒听
            KFLog_Normal(YES, @"主叫收到被叫拒听信令");
            *pNotificationName = D_Notification_Name_CallDisconnected;
            [error setErrorCode:E_CallFinishReason_Reject];
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Confirm_ReleaseCall://通话建立之后一方挂断
            if(retCode == 0){
                KFLog_Normal(YES, @"挂断电话返回成功");
                [error setErrorCode:E_CallFinishReason_Normal];
            }else{
                KFLog_Normal(YES, @"挂断电话返回失败");
                [error setErrorCode:E_CallFinishReason_HangUpFailed];
            }
            *pNotificationName = D_Notification_Name_CallDisconnected;
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Confirm_ReleaseCall_TimeOut:
            KFLog_Normal(YES, @"挂断电话返回超时");
            [error setErrorCode:E_CallFinishReason_HangUpFailed];
            *pNotificationName = D_Notification_Name_CallDisconnected;
            *pNotificationObject = error;
            break;
        case E_Call_Message_ID_Signalling_CallFinishedNormal://通话正常结束
            KFLog_Normal(YES, @"接收到对方挂断电话的信令");
            [error setErrorCode:E_CallFinishReason_Normal];
            *pNotificationName = D_Notification_Name_CallDisconnected;
            *pNotificationObject = error;
            break;
#pragma mark 通讯录~
        case E_Service_Message_ID_LoadWXFriend:
            [self parseLoadWXFriend:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_IncreasedWXFriend:
            [self parseIncreasedWXFriend:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_NickNameChanged:
            [self parseWXFriendNickNameChanged:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_IconChanged:
            [self parseWXFriendIconChanged:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 上传个人信息
        case E_Service_Message_ID_UploadPersonalIcon:
//            *pNotificationName = D_Notification_Name_PersonalIconUploadSucceed;
//            if(retCode != SS_SUCCESS){
//                *pNotificationName = D_Notification_Name_PersonalIconUploadFailed;
//            }

            [self parseUploadMyIcon:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_UploadPersonalInfo:
            *pNotificationName = D_Notification_Name_PersonalInfoUpload_Succeed;
            if(retCode != SS_SUCCESS){
                *pNotificationName = D_Notification_Name_PersonalInfoUpload_Failed;
            }
            break;
#pragma mark 加载通话记录~
        case E_Service_Message_ID_LoadCallRecord:
            [self parseCallRecord:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_CallRecordAdded:
            [self parseCallRecordAdded:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 商城
        case E_Service_Message_ID_LoadGoodList://加载商品列表
            [self parseLoadGoodList:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_AddAGood://增加了一个商品
            [self parseGoodAdded:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadMenuList://加载菜单列表~
            [self parseCategoryLoaded:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadTopGoods://顶部商品~
            [self parseTopGoods:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadActivityGoods: //活动商品~
            [self parseActivityGoods:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_GuessYouLikeGoods://猜你喜欢的商品~
            [self parseGuessYouLikeGoods:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadSetMeals: //加载所有套餐~
            [self parseLoadSetMeals:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadOfficeCity://商家的所有地区
            [self parseOfficeCity:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadBranchOffice://商家分店
            [self parseBranchOffice:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadLocation://地理位置
            [self parseLocation:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_message_ID_UpdateBranch://更新用户注册的分店
            [self parseUpdateBranch:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_AddAnOrder:   //添加订单
            [self parseAddOrder:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
		case E_Service_Message_ID_CancelOrder://取消订单~
			[self parseCancelOrder:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
			break;
		case E_Service_Message_ID_LoadSingleOrder:
			[self parseLoadSingleOrder:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
			break;
		case E_Service_Message_ID_ConfirmOrder:
			[self parseConfirmOrder:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
			break;
			
        case E_Service_Message_ID_LoadOrderList://订单列表
            [self parseOrderList:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadGoodsInfo:
            [self parseLoadGoodsInfo:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 红包
        case E_Service_Message_ID_LoadRedPager://加载红包
            [self parseLoadRedPager:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_GainRedPager://领取红包
            [self parseGainRedPager:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadRPRule://红包规则
            [self parseLoadRpRule:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadRPBalance://红包余额
            [self parseLoadRpBalance:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_UseRedPager://使用红包
            [self parseUseRedPager:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 推送
        case E_Service_Message_ID_IncomePushInfo: //接受到推送的内容
            [self parseIncomePushInfo:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma  mark 关于
        case E_Service_Message_ID_LoadOfficeInfo: //店铺关于
            [self parseLoadOfficeInfo:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadShopInfo: //商家关于
            [self parseLoadAboutShop:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadUseHelp: //我信帮助
            [self parseLoadWXUseHelp:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadWXContact: //我信联系方式
            [self parseLoadWXContact:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_WxFeedBack: //我信反馈
            [self parseWxFeedBack:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_WxUseProtocal:
            [self parseWxUserProtocal:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 版本更新
        case E_Service_Message_ID_VersionUpdate://版本更新~
            [self parseVersionUpdate:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 获取个人信息
        case E_Service_Message_ID_LoadPersonInfo: //获取个人信息
            [self parseLoadPersonalInfo:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 充值
        case E_Service_Message_ID_LoadRechargeRule: //调用充值优惠规则
            [self parseLoadRechargeRule:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_Recharge:  //充值接口
            [self parseRecharge:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadWxBalance: //获取话费余额
            [self parseLoadWxBalance:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
#pragma mark 上传token
        case E_Service_Message_ID_TokenUpdate://上传token
            if(retCode == 0){
                KFLog_Normal(YES, @"上传token成功");
                *pNotificationName = D_Notification_Name_Lib_SendTokenSucceed;
            }else{
                KFLog_Normal(YES, @"上传token失败 = %d",(int)retCode);
                *pNotificationName = D_Notification_Name_Lib_SendTokenFailed;
            }            
            break;
        case E_Service_Message_ID_KickedOut://被踢下线~
            *pNotificationName = D_Notification_Name_KickedOut;
            break;
        case E_Service_Message_ID_BackCall:
            [self parseBackCall:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
		case E_Service_Message_ID_FectchSubShopList:
			[self parseFetchSubShopList:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
			break;
		case E_Service_Message_ID_DBStructChanged:
		{
			AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
			[app setDbHasChanged:YES];
		}
			break;
		case E_Service_Message_ID_GetOrderCodePayMode:
			[self parseGetOrderCodePayMode:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
			break;
        case E_Service_Message_ID_GetApplyRefundResult:
            [self parseGetOrderRefundResult:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        case E_Service_Message_ID_LoadRefundStatusInfo:
            [self parseLoadRefundStatusInfo:pParam paramNumber:paramNumber notificationName:pNotificationName notificationObject:pNotificationObject];
            break;
        default:
            break;
    }
}

- (NSInteger)errorCode:(const char *)pRetString{
    return atoi(pRetString);
}

#pragma mark 账号处理~
- (void)parseRegister:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
     notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
    *pNotificationName = D_Notification_Name_RegisterFailed;
    NSString *notificationOBJ = nil;
    switch (retCode) {
        case 0:
            KFLog_Normal(YES, @"注册成功");
            *pNotificationName = D_Notification_Name_RegisterSucceed;
            break;
        case 1:
            notificationOBJ = @"注册失败";
            break;
        case 2:
            notificationOBJ = @"注册失败,验证码错误";
            break;
        case 3:
            notificationOBJ =  @"注册失败,该用户已经被注册";
            break;
        case 4:
            notificationOBJ =  @"注册失败,验证码已过期";
            break;
		case 5:
			notificationOBJ = @"请输入正确的号码";
			break;
        default:
            break;
    }
    if(notificationOBJ){
        WXError *error = [[[WXError alloc] init] autorelease];
        [error setErrorMessage:notificationOBJ];
        *pNotificationObject = error;
        KFLog_Normal(YES, @"%@",notificationOBJ);
    }
}

- (void)parseUnRegister:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
       notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
    *pNotificationName = D_Notification_Name_UnRegisterFailed;
    NSString *notificationOBJ = nil;
    switch (retCode) {
        case 0:
            KFLog_Normal(YES, @"注销成功");
            *pNotificationName = D_Notification_Name_UnRegisterSucceed;
            break;
        case 1:
            notificationOBJ = @"注销失败";
            break;
        case 2:
            notificationOBJ = @"注销失败,请登陆后再注销";
            break;
        case 3:
            notificationOBJ = @"注销失败,密码错误";
            break;
        default:
            break;
    }
    if(notificationOBJ){
        WXError *error = [[[WXError alloc] init] autorelease];
        [error setErrorMessage:notificationOBJ];
        *pNotificationObject = error;
        KFLog_Normal(YES, @"%@",notificationOBJ);
    }
}

//IT_STATUS_IDLE    =  0, 未知,初始化
//IT_STATUS_ON_LINE =  1, 上线
//IT_STATUS_OFF_LINE=  2, 离线
//IT_STATUS_DISTANCE=  3, 离开，暂时不在电脑旁边
//IT_STATUS_BUSY    =  4, 忙碌
//IT_STATUS_CALL    =  5, 通话中
//IT_STATUS_STEALTH =  6, 隐身
//IT_STATUS_NOT_BOTHER=7, 请勿打扰
//IT_STATUS_LOGIN   =  8, 登录过程中
//IT_STATUS_LOGIN_OK=  9, 登录成功
//IT_STATUS_LOGIN_ERR =10, 登录失败
//IT_STATUS_LOGOUT    =11,  退出登录过程中
//IT_STATUS_LOGOUT_OK =12,  退出登录成功
//IT_STATUS_LOGOUT_ERR=13,  退出登录失败
//IT_STATUS_REG_SERVER_CONNECT_OK=14,   连接注册服务器成功
//IT_STATUS_REG_SERVER_DISCONNECT_OK=15 注册服务器连接断开
//IT_STATUS_LOGIN_NOT_ACCOUNT=17 // 登录帐号不存在
//IT_STATUS_LOGIN_TIME_OUT=18 // 登录超时

- (void)parseSwitchLogStatus:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
            notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
	NSString *notificationOBJ = nil;
    switch (retCode) {
        case E_LogStatusErrorCode_InLogIn:
            KFLog_Normal(YES, @"正在上线");
            break;
        case E_LogStatusErrorCode_LoginSucceed:
            KFLog_Normal(YES, @"登陆成功");
            *pNotificationName = D_Notification_Name_LoginSucceed;
            break;
        case E_LogStatusErrorCode_LoginFaield:
            KFLog_Normal(YES, @"登陆失败");
            *pNotificationName = D_Notification_Name_LoginFailed;
			notificationOBJ = @"登陆失败";
            break;
        case E_LogStatusErrorCode_InLogOut:
            KFLog_Normal(YES, @"正在下线")
            break;
        case E_LogStatusErrorCode_LogOutSucceed:
            KFLog_Normal(YES, @"退出登陆成功");
            *pNotificationName = D_Notification_Name_LogoutSucceed;
            break;
        case E_LogStatusErrorCode_LogOutFailed:
            KFLog_Normal(YES, @"退出登陆失败");
            *pNotificationName = D_Notification_Name_LogoutFailed;
            break;
        case E_LogStatusErrorCode_ConnectToServerOK:
            KFLog_Normal(YES, @"连接服务器成功");
            *pNotificationName = D_Notification_Name_ServiceConnectedOK;
            break;
        case E_LogStatusErrorCode_DisconnectToServerOK:
            KFLog_Normal(YES, @"与服务器连接断开");
            *pNotificationName = D_Notification_Name_ServiceDisconnect;
            break;
		case E_LogStatusErrorCode_NoSuchAccount:
			KFLog_Normal(YES, @"没有这个账号");
			*pNotificationName = D_Notification_Name_LoginNoSuchAccount;
			notificationOBJ = @"登录账号不存在";
			break;
		case E_LogStatusErrorCode_LoginTimeOut:
			KFLog_Normal(YES, @"登录超时");
			*pNotificationName = D_Notification_Name_LoginTimeOut;
			notificationOBJ = @"登录超时";
			break;
        default:
            break;
    }
	
	if(notificationOBJ){
		*pNotificationObject = notificationOBJ;
	}
}
#pragma mark 通话处理~
- (void)parseMakeCall:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        *pNotificationName = D_Notification_Name_CallDisconnected;
        WXError *error = [[[WXError alloc] init] autorelease];
        error.errorCode = E_CallFinishReason_Busy;
        *pNotificationObject = error;
    }
}

#pragma makr 通讯录
- (void)parseLoadWXFriend:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
            notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    const char *firstParam = pParam[0];
    if(strcmp(firstParam, "BEGIN") == 0){
        *pNotificationName = D_Notification_Name_LoadWXFriendBegin;
    }else if(strcmp(firstParam, "END") == 0){
        *pNotificationName = D_Notification_Name_LoadWXFriendEnd;
    }else{
        *pNotificationName = D_Notification_Name_LoadAWXFriend;
        NSMutableArray *paramArray = [NSMutableArray array];
        for(int i = 0; i < paramNumber; i++){
            [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
        }
        *pNotificationObject = paramArray;
    }
}

- (void)parseIncreasedWXFriend:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    *pNotificationName = D_Notification_Name_IncreaseWXFriend;
    NSMutableArray *paramArray = [NSMutableArray array];
    for(int i = 0; i < paramNumber; i++){
        [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
    }
    *pNotificationObject = paramArray;
}

- (void)parseWXFriendNickNameChanged:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    *pNotificationName = D_Notification_Name_WXFriendChanged;
    NSMutableArray *paramArray = [NSMutableArray array];
    for(int i = 0; i < paramNumber; i++){
        [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
    }
    *pNotificationObject = paramArray;
}

- (void)parseWXFriendIconChanged:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
                notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    *pNotificationName = D_Notification_Name_WXFriendChanged;
    NSMutableArray *paramArray = [NSMutableArray array];
    for(int i = 0; i < paramNumber; i++){
        [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
    }
    *pNotificationObject = paramArray;
}

#pragma mark 通话记录~
- (void)parseCallRecord:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
              notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    const char *firstParam = pParam[0];
    if(strcmp(firstParam, "BEGIN") == 0){
        *pNotificationName = D_Notification_Name_CallRecord_LoadBegin;
    }else if(strcmp(firstParam, "END") == 0){
        *pNotificationName = D_Notification_Name_CallRecord_LoadFinish;
    }else{
        *pNotificationName = D_Notification_Name_CallRecord_SingleLoad;
        NSMutableArray *paramArray = [NSMutableArray array];
        for(int i = 0; i < paramNumber; i++){
            [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
        }
        *pNotificationObject = paramArray;
    }
}

- (void)parseCallRecordAdded:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
            notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    *pNotificationName = D_Notification_Name_CallRecord_F_Added;
    NSMutableArray *paramArray = [NSMutableArray array];
    for(int i = 0; i < paramNumber; i++){
        [paramArray addObject:[NSString stringWithUTF8String:pParam[i]]];
    }
    *pNotificationObject = paramArray;
}

#pragma mark 商城

- (BOOL)checkConfirdValid:(const char *)merchantID areaID:(const char *)areaID subStoreID:(const char *)subStoreID{
#warning 先不考虑~
    return YES;
    WXUserOBJ *userOBJ = [WXUserOBJ sharedUserOBJ];
    if(atoi(merchantID) != kMerchantID){
        KFLog_Normal(YES, @"商家ID不相同");
        return NO;
    }
    
    if(atoi(areaID) != userOBJ.areaID){
        KFLog_Normal(YES, @"地区ID不相同");
        return NO;
    }
    
    if(atoi(subStoreID) != userOBJ.subShopID){
        KFLog_Normal(YES, @"分店ID不相同");
        return NO;
    }
    return YES;
}


- (void)parseLoadGoodList:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
       notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadMenuListFailed object:error userInfo:nil];
        return;
    }
    
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载商品列表失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadMenuListFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载商品列表成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        NSString *domain = [NSString stringWithUTF8String:pParam[6]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_AllGoodsHaveLoaded object:[NSDictionary dictionaryWithObjectsAndKeys:jsonString,@"jsonString",domain,@"domain", nil] userInfo:nil];
    }
}

- (void)parseGoodAdded:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
}

- (void)parseCategoryLoaded:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadMenuListFailed object:error userInfo:nil];
        return;
    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载类别列表失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadMenuListFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载类别列表成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadMenuList object:jsonString userInfo:nil];
    }
}


- (void)parseTopGoods:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
     notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
//        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadHomeTopGoodsFailed object:error userInfo:nil];
        return;
    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载顶部商品失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadHomeTopGoodsFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载顶部商品成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadHomeTopGoodsSucceed
                                        object:jsonString userInfo:nil];
    }
}

- (void)parseActivityGoods:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
     notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
//        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadActivityGoodsFailed object:error userInfo:nil];
        return;
    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载活动商品失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadActivityGoodsFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载活动商品成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadActivityGoodsSucceed
                                                          object:jsonString userInfo:nil];
    }
}

- (void)parseGuessYouLikeGoods:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
     notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
//        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
        return;
    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载猜你喜欢的商品失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载猜你喜欢的商品成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsSucceed
                                                          object:jsonString userInfo:nil];
    }
}

- (void)parseLoadSetMeals:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
              notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
        KFLog_Normal(YES, @"过时的回调");
        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
        return;
    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载套餐成功 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSetMealsFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载套餐失败");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[5]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSetMealsSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseOfficeCity:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
//        KFLog_Normal(YES, @"过时的回调");
//        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
//        return;
//    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载商家城市失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOfficeCitiesFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载商家城市成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOfficeCitiesSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseBranchOffice:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
//        KFLog_Normal(YES, @"过时的回调");
//        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
//        return;
//    }
    NSInteger retCode = [self errorCode:pParam[0]];
    NSString *jsonString = [NSString stringWithUTF8String:pParam[4]];
    if(jsonString.length <= 11){
        KFLog_Normal(YES, @"加载商家分店失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadBranchOfficeFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载商家分店成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[4]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadBranchOfficeSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseLocation:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
        notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
//        KFLog_Normal(YES, @"过时的回调");
//        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
//        return;
//    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载地理位置失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadLocationFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载地理位置成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[2]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadLocationSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseUpdateBranch:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
    notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"更新用户注册的分店失败 = %d",(int)retCode);
    }else{
        KFLog_Normal(YES, @"更新用户注册的分店成功");
    }
}

-(void)parseOrderList:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
    notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
//        KFLog_Normal(YES, @"过时的回调");
//        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
//        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
//        return;
//    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载订单列表失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOrderListFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载订单列表成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[4]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOrderListSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseAddOrder:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
     notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
	NSString *orderID = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
    if(retCode != 0 && retCode != 250){
        KFLog_Normal(YES, @"添加订单失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_SubmitOrderFailed
                                                          object:orderID userInfo:nil];
    }else{
        KFLog_Normal(YES, @"添加订单成功");
        NSString *retCodeStr = [NSString stringWithFormat:@"%ld",(long)retCode];
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        if (retCode){
            [dic setObject:retCodeStr forKey:@"retCode"];
        }
        if (orderID){
            [dic setObject:orderID forKey:@"orderID"];
        }
        [[MyOrderListObj sharedOrderList] removeOrderList];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_SubmitOrderSucceed
                                                          object:dic userInfo:nil];
    }
}

-(void)parseCancelOrder:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
	notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSInteger retCode = [self errorCode:pParam[0]];
	NSString *orderID = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
	if(retCode != 0){
		KFLog_Normal(YES, @"取消订单失败 = %d",(int)retCode);
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_CancelOrderFailed
														  object:orderID userInfo:nil];
	}else{
		KFLog_Normal(YES, @"取消订单成功");
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_CancelOrderSucceed
														  object:orderID userInfo:nil];
	}
}

-(void)parseLoadSingleOrder:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
	   notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSInteger retCode = [self errorCode:pParam[0]];
	NSString *orderID = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
	NSString *json = [NSString stringWithCString:pParam[4] encoding:NSUTF8StringEncoding];
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"orderID",json,@"json",nil];
	if(retCode != 0){
		KFLog_Normal(YES, @"加载单个订单失败 = %d",(int)retCode);
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSingleOrderInfoFailed
														  object:dic userInfo:nil];
	}else{
		KFLog_Normal(YES, @"加载单个订单成功");
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSingleOrderInfoSucceed
														  object:dic userInfo:nil];
	}
}


-(void)parseConfirmOrder:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
	   notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSInteger retCode = [self errorCode:pParam[0]];
	NSString *orderID = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
	if(retCode != 0){
		KFLog_Normal(YES, @"确认订单失败 = %d",(int)retCode);
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_OrderConfirmFailed
														  object:orderID userInfo:nil];
	}else{
		KFLog_Normal(YES, @"确认订单成功");
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_OrderConfirmSucceed
														  object:orderID userInfo:nil];
	}
}


-(void)parseLoadRedPager:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
    notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载红包失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRedPagerFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载红包成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRedPagerSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseGainRedPager:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
        notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"领取红包失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_GainRedPagerFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"领取红包成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[4]];
        NSString *jsonString1 = [NSString stringWithUTF8String:pParam[3]];
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
		if (jsonString){
			[dic setObject:jsonString forKey:@"balance"];
		}
		if (jsonString1){
			[dic setObject:jsonString1 forKey:@"rpID"];
		}
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_GainRedPagerSucceed
                                                          object:dic userInfo:nil];
    }
}

-(void)parseLoadRpRule:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载红包使用规则失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadUseRPRuleFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载红包使用规则成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadUseRPRuleSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseLoadRpBalance:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
        notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载红包余额失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRpBalanceFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载红包余额成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[2]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRpBalanceSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseUseRedPager:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //    if(![self checkConfirdValid:pParam[1] areaID:pParam[2] subStoreID:pParam[3]]){
    //        KFLog_Normal(YES, @"过时的回调");
    //        //        WXError *error = [WXError errorWithCode:E_Service_Method_ReturnIn_OutOfDate errorMessage:@"过时的回调"];
    //        //        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed object:error userInfo:nil];
    //        return;
    //    }
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"使用红包失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_UseRedPagerFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"使用红包成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
        NSString *jsonString1 = [NSString stringWithUTF8String:pParam[4]];
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:jsonString forKey:@"balance"];
        [dic setObject:jsonString1 forKey:@"orderNum"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_UseRedPagerSucceed
                                                          object:dic userInfo:nil];
    }
}


-(void)parseIncomePushInfo:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
    [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_IncomePushInfo
                                                      object:jsonString userInfo:nil];
}

-(void)parseLoadOfficeInfo:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
       notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载分店关于失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOfficeInfoFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载分店关于成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[3]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadOfficeInfoSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseLoadAboutShop:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
          notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载商家关于失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadAboutShopFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载商家关于成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[2]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadAboutShopSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseLoadWXUseHelp:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载使用帮助失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWXUseHelpFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载使用帮助成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[1]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWXUseHelpSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseLoadWXContact:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载联系方式失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWXContactFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载联系方式成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[1]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWXContactSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseWxFeedBack:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"问题反馈失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_QuestionFeedBackFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"问题反馈成功");
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_QuestionFeedBackSucceed
                                                          object:nil userInfo:nil];
    }
}

-(void)parseWxUserProtocal:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
          notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"调取使用协议成功 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadUserProtocalFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"调取使用协议成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[1]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadUserProtocalSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseChangePassWord:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"修改密码失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_UpdatePWDFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"修改密码成功");
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_UpdatePWDSucceed
                                                          object:nil userInfo:nil];
    }
}

-(void)parseUploadMyIcon:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
          notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"上传头像 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_PersonalIconUploadFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"上传头像成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[1]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_PersonalIconUploadSucceed
                                                          object:jsonString userInfo:nil];
    }
}


-(void)parseLoadGoodsInfo:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
      notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载商品详情失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGoodsInfoFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载商品详情成功");
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *jsonString6 = [NSString stringWithUTF8String:pParam[6]];
        NSString *jsonString7 = [NSString stringWithUTF8String:pParam[7]];
        NSString *jsonString8 = [NSString stringWithUTF8String:pParam[8]];
        NSString *jsonString9 = [NSString stringWithUTF8String:pParam[9]];
        NSString *jsonString10 = [NSString stringWithUTF8String:pParam[10]];
        NSString *jsonString11 = [NSString stringWithUTF8String:pParam[11]];
        NSString *jsonString12 = [NSString stringWithUTF8String:pParam[12]];
        NSString *jsonString13 = [NSString stringWithUTF8String:pParam[13]];
        [dic setObject:jsonString6 forKey:@"description"];
        [dic setObject:jsonString7 forKey:@"name"];
        [dic setObject:jsonString8 forKey:@"MarketPrice"];
        [dic setObject:jsonString9 forKey:@"OURPrice"];
        [dic setObject:jsonString10 forKey:@"number"];
        [dic setObject:jsonString11 forKey:@"json"];
        [dic setObject:jsonString12 forKey:@"likeCount"];
        [dic setObject:jsonString13 forKey:@"MeterageName"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadGoodsInfoSucceed
                                                          object:dic userInfo:nil];
    }
}

-(void)parseLoadPersonalInfo:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *jsonString0 = [NSString stringWithUTF8String:pParam[0]];
    NSString *jsonString1 = [NSString stringWithUTF8String:pParam[1]];
    NSString *jsonString2 = [NSString stringWithUTF8String:pParam[2]];
    NSString *jsonString3 = [NSString stringWithUTF8String:pParam[3]];
    NSString *jsonString4 = [NSString stringWithUTF8String:pParam[4]];
    NSString *jsonString5 = [NSString stringWithUTF8String:pParam[5]];
    NSString *jsonString6 = [NSString stringWithUTF8String:pParam[6]];
    NSString *jsonString7 = [NSString stringWithUTF8String:pParam[7]];
    NSString *jsonString8 = [NSString stringWithUTF8String:pParam[8]];
    NSString *jsonString9 = [NSString stringWithUTF8String:pParam[9]];
    NSString *jsonString10 = [NSString stringWithUTF8String:pParam[10]];
    [dic setObject:jsonString0 forKey:@"pName"];
    [dic setObject:jsonString1 forKey:@"pvName"];
    [dic setObject:jsonString2 forKey:@"pPhone"];
    [dic setObject:jsonString3 forKey:@"ubSex"];
    [dic setObject:jsonString4 forKey:@"pBirthday"];
    [dic setObject:jsonString5 forKey:@"pQQ"];
    [dic setObject:jsonString6 forKey:@"pCharacterSignature"];
    [dic setObject:jsonString7 forKey:@"pStreet"];
    [dic setObject:jsonString8 forKey:@"pArea"];
    [dic setObject:jsonString9 forKey:@"icon_path"];
    [dic setObject:jsonString10 forKey:@"WX_ID"];
    [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadPersonalInfoSucceed
                                                      object:dic userInfo:nil];
}

-(void)parseLoadRechargeRule:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
            notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"加载充值规则 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRechargeRuleFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"加载充值规则成功");
        NSString *jsonString = [NSString stringWithUTF8String:pParam[2]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadRechargeRuleSucceed
                                                          object:jsonString userInfo:nil];
    }
}

-(void)parseRecharge:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
    notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"充值 = %d",(int)retCode);
        NSMutableDictionary *dic1 = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *jsonString4 = [NSString stringWithUTF8String:pParam[4]];
        [dic1 setObject:jsonString4 forKey:@"WoXinResult"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_RechargeFailed
                                                          object:dic1 userInfo:nil];
    }else{
        KFLog_Normal(YES, @"充值成功");
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *jsonString2 = [NSString stringWithUTF8String:pParam[2]];
        NSString *jsonString3 = [NSString stringWithUTF8String:pParam[3]];
        NSString *jsonString4 = [NSString stringWithUTF8String:pParam[4]];
        [dic setObject:jsonString2 forKey:@"orderID"];
        [dic setObject:jsonString3 forKey:@"PhpUrl"];
        [dic setObject:jsonString4 forKey:@"WoXinResult"];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_RechargeSucceed
                                                          object:dic userInfo:nil];
    }
}

-(void)parseLoadWxBalance:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSInteger retCode = [self errorCode:pParam[0]];
    if(retCode != 0){
        KFLog_Normal(YES, @"获取话费余额 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWxBalanceFailed
                                                          object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"获取话费余额成功");
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *jsonString1 = [NSString stringWithUTF8String:pParam[1]];
        NSString *jsonString2 = [NSString stringWithUTF8String:pParam[2]];
		if (jsonString1){
			[dic setObject:jsonString1 forKey:@"balance"];
		}else{
			KFLog_Normal(YES, @"余额为空");
		}
		if (jsonString2){
			[dic setObject:jsonString2 forKey:@"minutes"];
        }else{
            KFLog_Normal(YES, @"剩余分钟数为空");
        }
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadWxBalanceSucceed
                                                          object:dic userInfo:nil];
    }
}

-(void)parseVersionUpdate:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
         notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSString *updateType = [NSString stringWithUTF8String:pParam[0]];
    NSString *urlString = nil;
    const char *url = pParam[1];
    if(url){
        urlString = [NSString stringWithUTF8String:url];
    }
    NSString *updateMsg = nil;
    const char *cUpdateMsg = pParam[2];
    if(cUpdateMsg){
        updateMsg = [NSString stringWithUTF8String:cUpdateMsg];
    }
    
    NSString *newestVersion = nil;
    const char *cNewestVersion = pParam[4];
    
    if(cNewestVersion){
        newestVersion = [NSString stringWithUTF8String:cNewestVersion];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:updateType forKey:@"VersionUpdateType"];
    if(urlString){
        [dic setObject:urlString forKey:@"VersionUpdateURL"];
    }
    if(updateMsg){
        [dic setObject:updateMsg forKey:@"VersionUpdateReason"];
    }
    
    if(newestVersion){
        [dic setObject:newestVersion forKey:@"NewestVersion"];
    }
    
    [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_VersionUpdateSucceed object:dic userInfo:nil];
}

-(void)parseBackCall:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
    notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSString *phoneNumber = [NSString stringWithUTF8String:pParam[0]];
    NSInteger code = atoi(pParam[1]);
    NSString *notificationName = nil;
    switch (code) {
        case 1://服务器收到请求
            notificationName = D_Notification_Name_Lib_BackCallRequestSucceed;
            break;
        case 4://开始呼叫主叫~
            notificationName = D_Notification_Name_Lib_BackCallerRing;
            break;
        case 11://余额不足
            notificationName = D_Notification_Name_Lib_BackCallArrearage;
            break;
		case 14:
			notificationName = D_Notification_Name_Lib_BackCallServiceBusy;
			break;
		case 8: //主叫挂机
		case 9://被叫挂机
        case 10: //通话结束
		case 12://被叫忙
            notificationName = D_Notification_Name_Lib_BackCallTerminate;
            break;
		case 15:
			notificationName = D_Notification_Name_Lib_BackCallMainCallIllegal;
			break;
		case 16:
			notificationName = D_Notification_Name_Lib_BackCallCalledNumberIllegal;
			break;
        default:
            break;
    }
    if(notificationName){
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:notificationName object:phoneNumber userInfo:nil];
    }
}

-(void)parseFetchSubShopList:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
	notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
	NSInteger retCode = [self errorCode:pParam[0]];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	if(retCode != 0){
		KFLog_Normal(YES, @"获取分店列表失败 = %d",(int)retCode);
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSubShopListFailed
														  object:nil userInfo:nil];
	}else{
		KFLog_Normal(YES, @"获取分店列表成功");
		NSString *jsonString = [NSString stringWithUTF8String:pParam[2]];
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_LoadSubShopListSucceed
														  object:jsonString userInfo:nil];
	}
}

- (void)parseGetOrderCodePayMode:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
				notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
	NSInteger retCode = [self errorCode:pParam[0]];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	if(retCode != 0){
		KFLog_Normal(YES, @"获取支付ID失败 = %d",(int)retCode);
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_GetOrderCodePayModeFailed
														  object:nil userInfo:nil];
	}else{
		KFLog_Normal(YES, @"获取支付ID成功");
		NSString *merchantID = [NSString stringWithCString:pParam[1] encoding:NSUTF8StringEncoding];
		NSString *subShopID = [NSString stringWithCString:pParam[2] encoding:NSUTF8StringEncoding];
		NSString *payType = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
		NSString *orderCode = [NSString stringWithCString:pParam[4] encoding:NSUTF8StringEncoding];
		NSString *payID = [NSString stringWithCString:pParam[5] encoding:NSUTF8StringEncoding];
		
		NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
		if (merchantID){
			[mutDic setObject:merchantID forKey:@"SellerID"];
		}
		if (subShopID){
			[mutDic setObject:subShopID forKey:@"ShopID"];
		}
		if (payType){
			[mutDic setObject:payType forKey:@"Type"];
		}
		if (orderCode){
			[mutDic setObject:orderCode forKey:@"OrderCode"];
		}
		if (payID){
			[mutDic setObject:payID forKey:@"payID"];
		}
		[notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_GetOrderCodePayModeSucceed
														  object:mutDic userInfo:nil];
	}
}

-(void)parseGetOrderRefundResult:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
                notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
	
	NSString *merchantID = [NSString stringWithCString:pParam[1] encoding:NSUTF8StringEncoding];
	NSString *subShopID = [NSString stringWithCString:pParam[2] encoding:NSUTF8StringEncoding];
	NSString *orderID = [NSString stringWithCString:pParam[3] encoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
	if(merchantID){
		[mutableDic setObject:merchantID forKey:@"merchantID"];
	}
	if(subShopID){
		[mutableDic setObject:subShopID forKey:@"refundSubShopID"];
	}
	if(orderID){
		[mutableDic setObject:orderID forKey:@"refundOrderID"];
	}
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(retCode != 0){
        KFLog_Normal(YES, @"订单申请退款失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_ApplyOrderRefundFailed object:mutableDic userInfo:nil];
    }else{
        KFLog_Normal(YES, @"订单申请退款成功");
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_Lib_ApplyOrderRefundSucceed object:mutableDic userInfo:nil];
    }
}

-(void)parseLoadRefundStatusInfo:(SS_CHAR**)pParam paramNumber:(SS_UINT32)paramNumber
                notificationName:(NSString**)pNotificationName notificationObject:(id*)pNotificationObject{
    NSInteger retCode = [self errorCode:pParam[0]];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if(retCode != 0){
        KFLog_Normal(YES, @"调取退款状态信息失败 = %d",(int)retCode);
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_lib_LoadRefundStatusInfoFailed object:nil userInfo:nil];
    }else{
        KFLog_Normal(YES, @"调取退款状态信息成功");
        NSString *jsonStr = [NSString stringWithUTF8String:pParam[4]];
        [notificationCenter postNotificationOnMainThreadWithName:D_Notification_Name_lib_LoadRefundStatusInfoSucceed object:jsonStr userInfo:nil];
    }
}

@end

