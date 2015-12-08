//
//  WXUserdefaultDefine.h
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#ifndef CallTesting_WXUserdefaultDefine_h
#define CallTesting_WXUserdefaultDefine_h

/*
 i:int类型
 b:bool类型
 t:字符串类型
 d:字典类型
 f:浮点型
 如D_WXUserdefault_Key_iUnreadSysMsg中iUnreadSysMsg里面的i表示为int类型
 */
#pragma mark 用户信息
#define	D_WXUserdefault_Key_tWoxinID @"D_WXUserdefault_Key_tWoxinID" //我信ID
#define D_WXUserdefault_Key_tUser  @"D_WXUserdefault_Key_tUser"//账号
#define D_WXUserdefault_Key_tPWD   @"D_WXUserdefault_Key_tPWD"//用户密码
#define D_WXUserdefault_Key_iLoadType @"D_WXUserdefault_Key_iAutoLoad"//0 :不自动登陆 1：自动登陆
#define D_WXUserdefault_Key_bRememberPWD @"D_WXUserdefault_Key_bRememberPWD"//0:不记录密码 1:记住密码
#define D_WXUserDefault_Key_iSubShopID @"D_WXUserDefault_Key_iSubShopID" //分店ID
#define D_WXUserDefault_Key_iAreaID @"D_WXUserDefault_Key_iAreaID" //地区ID
#define D_WXUserDefault_Key_tSubShopName @"D_WXUserDefault_Key_tSubShopName"//分店的名称
#define D_WXUserdefault_Key_iSubCityName @"D_WXUserdefault_Key_iSubCityName" //城市的名称
#define D_WXUserdefault_Key_locationCity @"D_WXUserdefault_Key_locationCity" //定位城市

#pragma mark 系统信息
#define D_WXUserdefault_Key_iUnreadSysMsg @"D_WXUserdefault_Key_iUnreadSysMsg"//系统信息未读的数目
#define D_WXUserdefault_Key_iUnfetchRewardPacket @"D_WXUserdefault_Key_iUnfetchRewardPacket"//未领取的红包个数

//#pragma mark tocken
//#define D_WXUserdefault_Key_tToken @"D_WXUserdefault_Key_tTokenTemp"//token

#pragma mark 系统升级
#define D_WXUserdefault_Key_iLastUpdateNotifyTime @"D_WXUserdefault_Key_iLastUpdateNotifyTime"//上一次升级提醒的时间~
#define D_WXUserdefault_Key_tUpdateVersionSkiped @"D_WXUserdefault_Key_tUpdateVersionSkiped"//跳过更新的版本~
#define D_WXUserdefault_Key_tNewestVersion @"D_WXUserdefault_Key_tNewestVersion"//最新版本~
#define	D_WXUserdefault_Key_tLastVersion @"D_WXUserdefault_Key_tLastVersion"//上一次版本~
//是否第一次登陆~
#define D_WXUserdefault_Key_bHasLoad @"D_WXUserdefault_Key_bHasLoad"


//子代理名称 缩写
#define D_WXUserdefault_Key_tAgentAcronymName  @"D_WXUserdefault_Key_tAgentAcronymName"
#define D_WXUserdefault_Key_tAgentName @"D_WXUserdefault_Key_tAgentName"
#define D_WXUserdefault_Key_iSubAgentID @"D_WXUserdefault_Key_iSubAgentID"
#define D_WXUserdefault_Key_iAuthority @"D_WXUserdefault_Key_iAuthority"//权限 0：最大权限 1：子管理账号权限
#define D_WXUserdefault_Key_bGeneralAgency @"D_WXUserdefault_Key_bGeneralAgency"//是否为总代理

#define D_WXUserdefault_Key_tSignature @"D_WXUserdefault_Key_tSignature"//个性签名
#define D_WXUserdefault_Key_bSex @"D_WXUserdefault_Key_bSex"//性别
#define D_WXUserdefault_Key_tQQ   @"D_WXUserdefault_Key_tQQ"//qq
#define D_WXUserdefault_Key_iBirth @"D_WXUserdefault_Key_iBirth"//生日
#define D_WXUserdefault_Key_tAddress @"D_WXUserdefault_Key_tAddress"//地址

//定位
#define D_WXUserdefault_Location_Pro @"D_WXUserdefault_Location_Pro"  //用户所在省份
#define D_WXUserdefault_Location_City @"D_WXUserdefault_Location_City"  //用户定位城市
#define D_WXUserdefault_Location_Area @"D_WXUserdefault_Location_Area" //用户定位区域
#define D_WXUserdefault_UserCurrentCity @"D_WXUserdefault_UserCurrentCity"  //用户当前查看城市
#define D_WXUserdefault_Location_Latitude @"D_WXUserdefault_Location_Latitude" //经纬度
#define D_WXUserdefault_Location_Longitude @"D_WXUserdefault_Location_Longitude"

#pragma mark 提示mask
#define D_WXUserdefault_Key_bMaskHomePage           @"D_WXUserdefault_Key_bMaskHomePage"//主页面
#define D_WXUserdefault_Key_bMaskSliderSetting      @"D_WXUserdefault_Key_bMaskSliderSetting"//侧滑栏
#define D_WXUserdefault_Key_bMaskKeyPad             @"D_WXUserdefault_Key_bMaskKeyPad"//键盘
#define D_WXUserdefault_Key_bMaskResent             @"D_WXUserdefault_Key_bMaskResent"//最近通话
#define D_WXUserdefault_Key_bMaskContacter          @"D_WXUserdefault_Key_bMaskContacter"//联系人

#define	mark CallID
#define	D_WXUserdefault_Key_iBackCallID @"D_WXUserdefault_Key_iBackCallID" //callID
#endif
