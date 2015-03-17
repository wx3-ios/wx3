//
//  ServiceCommon.h
//  Woxin2.0
//
//  Created by le ting on 7/9/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#ifndef Woxin2_0_ServiceCommon_h
#define Woxin2_0_ServiceCommon_h

typedef enum {
    E_Service_Method_ReturnIn_Succeed = 0, //成功
    E_Service_Method_ReturnIn_Unknown,    //未知的原因
    E_Service_Method_ReturnIn_WrongPram,  //参数错误
    E_Service_Method_ReturnIn_Memory,     //内存分配出错
    E_Service_Method_ReturnIn_State,      //状态错误
    E_Service_Method_ReturnIn_Excute,     //执行错误
    E_Service_Method_ReturnIn_Parse,      //解析错误
    E_Service_Method_ReturnIn_TimeOut,     //超时
    E_Service_Method_ReturnIn_ServiceIdle,  //网络连接一直都没有建立
    E_Service_Method_ReturnIn_ServiceDisconnect,  //网络连接断开
    E_Service_Method_ReturnIn_OutOfDate,//过时
    E_Service_Method_ReturnIn_Invalid,
}E_Service_Method_ReturnIn;

//调用接口返回值
enum{
    //成功
    E_Service_Methode_Return_Succeed = 0,
    //失败
    E_Service_Methode_Return_Failed = 1,
    //服务器断开连接
    E_Service_Methode_Return_ServiceDisconnect,
};

#pragma mark 账号
//获取验证码
#define D_Notification_Name_FetchAuthCodeSucceed @"D_Notification_Name_FetchAuthCodeSucceed"
#define D_Notification_Name_FetchAuthCodeFailed @"D_Notification_Name_FetchAuthCodeFailed"
//注册
#define D_Notification_Name_RegisterSucceed @"D_Notification_Name_RegisterSucceed"
#define D_Notification_Name_RegisterFailed @"D_Notification_Name_RegisterFailed"
//注销
#define D_Notification_Name_UnRegisterBegin @"D_Notification_Name_UnRegisterBegin"
#define D_Notification_Name_UnRegisterSucceed @"D_Notification_Name_UnRegisterSucceed"
#define D_Notification_Name_UnRegisterFailed @"D_Notification_Name_UnRegisterFailed"
//修改密码
#define D_Notification_Name_UpdatePWDSucceed @"D_Notification_Name_UpdatePWDSucceed"
#define D_Notification_Name_UpdatePWDFailed @"D_Notification_Name_UpdatePWDFailed"
//上线
#define D_Notification_Name_LoginBegin @"D_Notification_Name_LoginBegin"
#define D_Notification_Name_LoginSucceed @"D_Notification_Name_LoginSucceed"
#define D_Notification_Name_LoginFailed @"D_Notification_Name_LoginFailed"
#define D_Notification_Name_LoginNoSuchAccount @"D_Notification_Name_LoginNoSuchAccount"
#define D_Notification_Name_LoginTimeOut @"D_Notification_Name_LoginTimeOut"
//下线
#define D_Notification_Name_LogoutBegin @"D_Notification_Name_LogoutBegin"
#define D_Notification_Name_LogoutSucceed @"D_Notification_Name_LogoutSucceed"
#define D_Notification_Name_LogoutFailed @"D_Notification_Name_LogoutFailed"
//服务器连接成功~
#define D_Notification_Name_ServiceConnectedOK @"D_Notification_Name_ServiceConnectedOK"
//服务器断开连接
#define D_Notification_Name_ServiceDisconnect  @"D_Notification_Name_ServiceDisconnect"
//被踢下线~
#define D_Notification_Name_KickedOut @"D_Notification_Name_KickedOut"
//找回密码
#define D_Notification_Name_FindPassWordSucceed @"D_Notification_Name_FindPassWordSucceed"
#define D_Notification_Name_FindPasssWordFailed @"D_Notification_Name_FindPasssWordFailed"

typedef enum {
    E_CallFinishReason_Normal = 0,//正常结束
    E_CallFinishReason_Reject, //被叫拒听
    E_CallFinishReason_Busy,//被叫忙~
    E_CallFinishReason_MakeCallTimeOut,//呼叫超时
    E_CallFinishReason_RingingTimeOut,//被叫响铃超时~ 被叫长时间未接~
    E_CallFinishReason_MakeCallFailed, //呼叫confirm失败
    E_CallFinishReason_RingFailed,  //响铃失败
    E_CallFinishReason_AnswerFailed, //接听失败
    E_CallFinishReason_HangUpFailed,//挂断失败
}E_CallFinishReason;

#pragma mark 通话
////呼叫，主叫的状态
//#define D_Notification_Name_MakeCall        @"D_Notification_Name_MakeCall"
#define D_Notification_Name_IncommingCall   @"D_Notification_Name_IncommingCall"//来电，被叫的状态
#define D_Notification_Name_CallEarly       @"D_Notification_Name_CallEarly"//被叫响铃，主叫的状态
#define D_Notification_Name_CallConnecting  @"D_Notification_Name_CallConnecting"//被叫接听，被叫的状态 没有这个状态了~
#define D_Notification_Name_CallConfirmed   @"D_Notification_Name_CallConfirmed"//通话已经建立~ 双方的状态
#define D_Notification_Name_CallDisconnected    @"D_Notification_Name_CallDisconnected"//通话结束，各种原因结束

#pragma mark 记载我信通讯录~
#define D_Notification_Name_LoadWXFriendBegin  @"D_Notification_Name_LoadWXFriendBegin"//开始加载我信通讯录~
#define D_Notification_Name_LoadAWXFriend      @"D_Notification_Name_LoadAWXFriend"//加载了一个我信联系人
#define D_Notification_Name_LoadWXFriendEnd    @"D_Notification_Name_LoadWXFriendEnd"//加载我信联系人完毕~
#define D_Notification_Name_IncreaseWXFriend   @"D_Notification_Name_IncreaseWXFriend"//增加我信用户~
#define D_Notification_Name_WXFriendChanged    @"D_Notification_Name_WXFriendChanged"//我信好友改变~

#pragma mark 个人信息
#define D_Notification_Name_Server_PersonalInfoChanged @"D_Notification_Name_Server_PersonalInfoChanged"//个人信息发生了改变~
#define D_Notification_Name_Lib_LoadPersonalInfoSucceed @"D_Notification_Name_Lib_LoadPersonalInfoSucceed"//获取个人信息成功~
#define D_Notification_Name_Lib_LoadPersonalInfoFailed @"D_Notification_Name_Lib_LoadPersonalInfoFailed"//获取个人信息失败~

#pragma mark 通话记录~
#define D_Notification_Name_CallRecord_LoadBegin @"D_Notification_Name_CallRecord_LoadBegin"//开始加载
#define D_Notification_Name_CallRecord_SingleLoad @"D_Notification_Name_CallRecord_SingleLoad"//加载单个通话记录~
#define D_Notification_Name_CallRecord_LoadFinish @"D_Notification_Name_CallRecord_LoadFinish"//结束加载~
#define D_Notification_Name_CallRecord_F_Added @"D_Notification_Name_CallRecord_F_Added"//增加了一个通话记录~ （一般是回拨）

#pragma mark 商城
#define D_Notification_Name_Lib_AllGoodsHaveLoaded @"D_Notification_Name_Lib_AllGoodsHaveLoaded" //加载了所有的商品~
#define D_Notification_Name_Lib_AllGoodsLoadedFailed @"D_Notification_Name_Lib_AllGoodsLoadedFailed" //加载所有商品失败
#define D_Notification_Name_Lib_NewGoodAdded @"D_Notification_Name_Lib_NewGoodAdded"  //lib库从服务器新增加了一个商品~
#define D_Notification_Name_Lib_LoadMenuList @"D_Notification_Name_Lib_LoadMenuList" //加载menu串
#define D_Notification_Name_Lib_LoadMenuListFailed @"D_Notification_Name_Lib_LoadMenuListFailed" //记载menu串失败

#define D_Notification_Name_Lib_LoadHomeTopGoodsFailed  @"D_Notification_Name_Lib_LoadHomeTopGoodsFailed" //加载顶部商品失败~
#define D_Notification_Name_Lib_LoadHomeTopGoodsSucceed @"D_Notification_Name_Lib_LoadHomeTopGoodsSucceed" //加载顶部商品成功
#define D_Notification_Name_Lib_LoadActivityGoodsFailed @"D_Notification_Name_Lib_LoadActivityGoodsFailed" //加载活动商品
#define D_Notification_Name_Lib_LoadActivityGoodsSucceed @"D_Notification_Name_Lib_LoadActivityGoodsSucceed" //加载活动商品成功
#define D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed @"D_Notification_Name_Lib_LoadGuessYouLikeGoodsFailed" //猜你喜欢商品失败
#define D_Notification_Name_Lib_LoadGuessYouLikeGoodsSucceed @"D_Notification_Name_Lib_LoadGuessYouLikeGoodsSucceed"//猜你喜欢商品成功
#define D_Notification_Name_Lib_LoadSetMealsFailed @"D_Notification_Name_Lib_LoadSetMealsFailed" //加载套餐失败
#define D_Notification_Name_Lib_LoadSetMealsSucceed @"D_Notification_Name_Lib_LoadSetMealsSucceed"//加载套餐成功

#define D_Notification_Name_Lib_LoadOfficeCitiesSucceed @"D_Notification_Name_Lib_LoadOfficeCitiesSucceed"  //加载商家城市成功
#define D_Notification_Name_Lib_LoadOfficeCitiesFailed @"D_Notification_Name_Lib_LoadOfficeCitiesFailed"  //加载商家城市失败
#define D_Notification_Name_Lib_LoadBranchOfficeSucceed @"D_Notification_Name_Lib_LoadBranchOfficeSucceed"  //加载分店成功
#define D_Notification_Name_Lib_LoadBranchOfficeFailed @"D_Notification_Name_Lib_LoadBranchOfficeFailed"  //加载分店失败
#define D_Notification_Name_Lib_LoadLocationSucceed @"D_Notification_Name_Lib_LoadLocationSucceed"  //加载地理位置成功
#define D_Notification_Name_Lib_LoadLocationFailed @"D_Notification_Name_Lib_LoadLocationFailed"  //加载地理位置失败
#define D_Notification_Name_Lib_LoadGoodsInfoSucceed @"D_Notification_Name_Lib_LoadGoodsInfoSucceed"  //加载商品详情成功
#define D_Notification_Name_Lib_LoadGoodsInfoFailed @"D_Notification_Name_Lib_LoadGoodsInfoFailed"  //加载商品详情失败

#pragma mark 订单
#define D_Notification_Name_Lib_LoadOrderListSucceed @"D_Notification_Name_Lib_LoadOrderListSucceed"  //加载订单列表成功
#define D_Notification_Name_Lib_LoadOrderListFailed @"D_Notification_Name_Lib_LoadOrderListFailed"  //加载订单列表失败
#define D_Notification_Name_Lib_SubmitOrderSucceed @"D_Notification_Name_Lib_SubmitOrderSucceed" //提交订单成功
#define D_Notification_Name_Lib_SubmitOrderFailed @"D_Notification_Name_Lib_SubmitOrderFailed" //提交订单失败
#define D_Notification_Name_Lib_CancelOrderSucceed @"D_Notification_Name_Lib_DeleteOrderSucceed" //取消订单成功
#define D_Notification_Name_Lib_CancelOrderFailed @"D_Notification_Name_Lib_DeleteOrderFailed" //取消订单失败
#define D_Notification_Name_Lib_OrderConfirmSucceed @"D_Notification_Name_Lib_OrderConfirmSucceed" //确认订单成功
#define D_Notification_Name_Lib_OrderConfirmFailed @"D_Notification_Name_Lib_OrderConfirmFailed" //确认订单失败
#define D_Notification_Name_Lib_GetOrderPayTypeSucceed @"D_Notification_Name_Lib_GetOrderPayTypeSucceed" //获取订单支付方式成功
#define D_Notification_Name_Lib_GetOrderPayTypeFailed @"D_Notification_Name_Lib_GetOrderPayTypeFailed" //获取订单支付方式失败
#define D_Notification_Name_Lib_LoadSingleOrderInfoSucceed @"D_Notification_Name_Lib_LoadSingleOrderInfoSucceed"//加载单个订单信息成功
#define D_Notification_Name_Lib_LoadSingleOrderInfoFailed @"D_Notification_Name_Lib_LoadSingleOrderInfoFailed"//加载单个订单信息失败

#pragma mark 红包
#define D_Notification_Name_Lib_LoadRedPagerSucceed @"D_Notification_Name_Lib_LoadRedPagerSucceed" //加载红包成功
#define D_Notification_Name_Lib_LoadRedPagerFailed @"D_Notification_Name_Lib_LoadRedPagerFailed" //加载红包失败
#define D_Notification_Name_Lib_GainRedPagerSucceed @"D_Notification_Name_Lib_GainRedPagerSucceed" //领取红包成功
#define D_Notification_Name_Lib_GainRedPagerFailed @"D_Notification_Name_Lib_GainRedPagerFailed" //领取红包失败
#define D_Notification_Name_Lib_UseRedPagerSucceed @"D_Notification_Name_Lib_UseRedPagerSucceed" //使用红包成功
#define D_Notification_Name_Lib_UseRedPagerFailed @"D_Notification_Name_Lib_UseRedPagerFailed" //使用红包失败
#define D_Notification_Name_Lib_LoadUseRPRuleSucceed @"D_Notification_Name_Lib_LoadUseRPRuleSucceed" //加载红包使用规则成功
#define D_Notification_Name_Lib_LoadUseRPRuleFailed @"D_Notification_Name_Lib_LoadUseRPRuleFailed" //加载红包使用规则失败
#define D_Notification_Name_Lib_LoadRpBalanceSucceed @"D_Notification_Name_Lib_LoadRpBalanceSucceed" //加载红包余额成功
#define D_Notification_Name_Lib_LoadRpBalanceFailed @"D_Notification_Name_Lib_LoadRpBalanceFailed" //加载红包余额失败

#pragma mark  推送
#define D_Notification_Name_Lib_IncomePushInfo @"D_Notification_Name_Lib_IncomePushInfo" //加载了推送信息~
#define D_Notification_Name_Lib_SendTokenFailed @"D_Notification_Name_Lib_SendTokenFailed"//发送token失败
#define D_Notification_Name_Lib_SendTokenSucceed @"D_Notification_Name_Lib_SendTokenSucceed"//发送token成功

#pragma mark 版本更新
#define D_Notification_Name_Lib_VersionUpdateSucceed @"D_Notification_Name_Lib_VersionUpdateSucceed"//版本更新成功
#define D_Notification_Name_Lib_VersionUpdateFailed @"D_Notification_Name_Lib_VersionUpdateFailed"//版本更新失败

#pragma mark 商家信息
#define D_Notification_Name_Lib_LoadOfficeInfoSucceed @"D_Notification_Name_Lib_LoadOfficeInfoSucceed"  //加载店铺详情成功
#define D_Notification_Name_Lib_LoadOfficeInfoFailed @"D_Notification_Name_Lib_LoadOfficeInfoFailed"  //加载店铺详情失败
#define D_Notification_Name_Lib_LoadAboutShopSucceed @"D_Notification_Name_Lib_LoadAboutShopSucceed"  //加载商家关于成功
#define D_Notification_Name_Lib_LoadAboutShopFailed @"D_Notification_Name_Lib_LoadAboutShopFailed"  //加载商家关于失败

#pragma mark 我信关于
#define D_Notification_Name_Lib_LoadWXUseHelpSucceed @"D_Notification_Name_Lib_LoadWXUseHelpSucceed"  //加载使用帮助成功
#define D_Notification_Name_Lib_LoadWXUseHelpFailed @"D_Notification_Name_Lib_LoadWXUseHelpFailed"  //加载使用帮助失败
#define D_Notification_Name_Lib_LoadUserProtocalSucceed @"D_Notification_Name_Lib_LoadUserProtocalSucceed"  //加载用户协议成功
#define D_Notification_Name_Lib_LoadUserProtocalFailed @"D_Notification_Name_Lib_LoadUserProtocalFailed"  //加载用户协议失败
#define D_Notification_Name_Lib_LoadWXContactSucceed @"D_Notification_Name_Lib_LoadWXContactSucceed"  //加载我信联系方式成功
#define D_Notification_Name_Lib_LoadWXContactFailed @"D_Notification_Name_Lib_LoadWXContactFailed"  //加载我信联系方式失败
#define D_Notification_Name_Lib_QuestionFeedBackSucceed @"D_Notification_Name_Lib_QuestionFeedBackSucceed"  //问题反馈成功
#define D_Notification_Name_Lib_QuestionFeedBackFailed @"D_Notification_Name_Lib_QuestionFeedBackFailed"  //问题反馈失败

#pragma mark 充值
#define D_Notification_Name_Lib_LoadRechargeRuleSucceed @"D_Notification_Name_Lib_LoadRechargeRuleSucceed"  //加载充值规则成功
#define D_Notification_Name_Lib_LoadRechargeRuleFailed @"D_Notification_Name_Lib_LoadRechargeRuleFailed"  //加载充值规则失败
#define D_Notification_Name_Lib_RechargeSucceed @"D_Notification_name_Lib_RechargeSucceed" //充值成功
#define D_Notification_Name_Lib_RechargeFailed @"D_Notification_Name_Lib_RechargeFailed" //充值失败
#define D_Notification_Name_Lib_LoadWxBalanceSucceed @"D_Notification_Name_Lib_LoadWxBalanceSucceed" //获取话费余额成功
#define D_Notification_Name_Lib_LoadWxBalanceFailed @"D_Notification_Name_Lib_LoadWxBalanceFailed" //获取话费余额失败

#pragma mark 回拨
#define D_Notification_Name_Lib_BackCallRequestSucceed @"D_Notification_Name_Lib_BackCallRequestSucceed" //回拨的调用服务器已经收到~
//#define D_Notification_Name_Lib_BackCallRequestFailed @"D_Notification_Name_Lib_BackCallRequestFailed" //回拨调用失败 这个由连接服务器断开处理~
#define D_Notification_Name_Lib_BackCallerRing @"D_Notification_Name_Lib_BackCallerRing" //回拨主叫开始响铃~
#define D_Notification_Name_Lib_BackCallArrearage @"D_Notification_Name_Lib_BackCallArrearage" //余额不足~
#define D_Notification_Name_Lib_BackCallServiceBusy @"D_Notification_Name_Lib_BackCallServiceBusy" //系统忙~
#define D_Notification_Name_Lib_BackCallMainCallIllegal @"D_Notification_Name_Lib_BackCallMainCallIllegal" //主叫不合法
#define D_Notification_Name_Lib_BackCallCalledNumberIllegal @"D_Notification_Name_Lib_BackCallCalledNumberIllegal" //被叫不合法~
#define D_Notification_Name_Lib_HangUpSucceed @"D_Notification_Name_Lib_HangUpSucceed" //挂断成功~
#define D_Notification_Name_Lib_HandUpFailed @"D_Notification_Name_Lib_HandUpFailed" //挂断失败~
#define D_Notification_Name_Lib_BackCallTerminate @"D_Notification_Name_Lib_BackCallTerminate"//通话结束

#pragma mark 加载分店列表
#define D_Notification_Name_Lib_LoadSubShopListSucceed @"D_Notification_Name_Lib_LoadSubShopListSucceed"//加载分店列表成功
#define D_Notification_Name_Lib_LoadSubShopListFailed @"D_Notification_Name_Lib_LoadSubShopListFailed"//加载分店列表失败

#pragma DB库发生了变化~
#define D_Notification_Name_Lib_DBStructHasChanged @"D_Notification_Name_Lib_DBStructHasChanged" //DB库发生了变化~

#pragma mark 支付
#define D_Notification_Name_Lib_GetOrderCodePayModeSucceed @"D_Notification_Name_Lib_GetOrderCodePayModeSucceed"
#define D_Notification_Name_Lib_GetOrderCodePayModeFailed @"D_Notification_Name_Lib_GetOrderCodePayModeFailed"
#define D_Notification_Name_Lib_ApplyOrderRefundSucceed @"D_Notification_Name_Lib_ApplyOrderRefundSucceed"
#define D_Notification_Name_Lib_ApplyOrderRefundFailed @"D_Notification_Name_Lib_ApplyOrderRefundFailed"
#define D_Notification_Name_lib_LoadRefundStatusInfoSucceed @"D_Notification_Name_lib_LoadRefundStatusInfoSucceed"
#define D_Notification_Name_lib_LoadRefundStatusInfoFailed @"D_Notification_Name_lib_LoadRefundStatusInfoFailed"

#endif