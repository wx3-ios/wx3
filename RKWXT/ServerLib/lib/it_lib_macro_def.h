#ifndef __IT_LIB_MACRO_DEF_H__
#define __IT_LIB_MACRO_DEF_H__


#define   IT_VERSION "0.0.0.90"
#define   IT_NAME "woxin_it"
#define   IT_LIB_DB_VERSION 8

//#define   IT_ANDROID_BIND 1

#define   IT_MESSAGE_MAX_TIME_OUT  5  //单位秒

#define  IT_LIB_DEBUG  1

#define   IT_UPDATE_LOGIN_STATUS(_s_pHandle_,_ITNewStatus_)\
{\
    SS_CHAR  sMSG[8] = "";\
    SS_CHAR  *Param[3];\
    if(IT_STATUS_REG_SERVER_DISCONNECT_OK == _ITNewStatus_)\
    {\
        SS_closesocket((_s_pHandle_)->m_SignalScoket);\
        (_s_pHandle_)->m_SignalScoket = SS_SOCKET_ERROR;\
    }\
    (_s_pHandle_)->m_e_ITStatus   = _ITNewStatus_;\
    SS_snprintf(sMSG,sizeof(sMSG),"%u",(_s_pHandle_)->m_e_ITStatus);\
    Param[0] = sMSG;\
    Param[1] = NULL;\
    (_s_pHandle_)->m_f_CallBack(IT_MSG_LOGIN_STATUS_CHANGE,Param,1);\
}

#define   IT_MSG_TIME_OUT_CALL_BACK(_p_TimeData_)\
{\
	if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)_p_TimeData_))\
	{\
		SS_free(_p_TimeData_);\
	}\
}

/*#define   IT_CHECK_NETWORK if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)\
{\
	SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");\
	return SS_ERR_NETWORK_DISCONNECT;\
}*/

#define   IT_CHECK_NETWORK \
if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)\
{\
	SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");\
	return SS_ERR_NETWORK_DISCONNECT;\
}\
else\
{\
	SS_SHORT       snRetval=0;\
	fd_set         s_WriteSet;\
	struct timeval s_tv;\
	FD_ZERO(&s_WriteSet);\
	FD_SET(g_s_ITLibHandle.m_SignalScoket,&s_WriteSet);\
	s_tv.tv_sec  = 0;\
	s_tv.tv_usec = 200;\
	snRetval = select(g_s_ITLibHandle.m_SignalScoket+1,&s_WriteSet,NULL,NULL,&s_tv);\
	if (-1 == snRetval)\
	{\
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);\
		return SS_ERR_NETWORK_DISCONNECT;\
	}\
}



#define   IT_CHECK_LOGIN   if(0 == g_s_ITLibHandle.m_un64WoXinID)\
{\
	SS_Log_Printf(SS_ERROR_LOG,"Not login");\
	return SS_ERR_NOT_LOGIN;\
}


#define   CACHE_UPDATE_TIME_RECHARGE_RULES                 30     //充值规则
#define   CACHE_UPDATE_TIME_ABOUT                          15     //关于
#define   CACHE_UPDATE_TIME_RED_PACKAGE_RECHARGE_RULES     7      //红包使用规则
#define   CACHE_UPDATE_TIME_AREA_SHOP                      2      //地区和分店信息
#define   CACHE_UPDATE_TIME_SHOP_INFO                      1      //分店信息


#define   DB_MSG_UPDATE_USER          1
#define   DB_MSG_UPDATE_REMARK_NAME   2
#define   DB_MSG_LOAD_FRIEND          3
#define   DB_MSG_GET_FRIEND_ICON      4
#define   DB_MSG_UPLOAD_MY_ICON       5
#define   DB_MSG_DELETE_FRIEND        6
#define   DB_MSG_LOAD_WOXIN_FRIEND    7
#define   DB_MSG_LOAD_CALL_RECORD     8
#define   DB_MSG_ADD_CALL_RECORD      9
#define   DB_MSG_DEL_CALL_RECORD      10
#define   DB_MSG_LOAD_USER_INFO       11  //加载用户自己的信息
#define   DB_MSG_UPDATE_USER_INFO     12  //更新用户自己的信息
#define   DB_MSG_GET_LAST_BROWSE_SHOP 13


//////////////////////////////////////////////////////////////////////////

#define   IT_MSG_LOGIN_STATUS_CHANGE   100
//Param[0] = Result  //0 成功 其他 失败
#define   IT_MSG_UPDATE_PASSWORD       101
//Param[0] = Result  //0 成功 其他 失败
#define   IT_MSG_FIND_PASSWORD         102
//Param[0] = Result  //0 成功 其他 失败
#define   IT_MSG_UPDATE_LOGIN_STATE    103
//Param[0] = Result  //0 成功 其他 失败
#define   IT_MSG_REPORT_VERSION_CFM    104
//Param[0] = Result  //0 当前是最新版本 1 有新版本，可以不更新 2  必须更新，才能使用
//Param[1] = url     // 下载地址
//Param[2] = info    // 更新信息，新版本都更新那些内容
//Param[3] = ID      // 商家ID
//Param[4] = NewVer  // 当前最新的版本
#define   IT_MSG_UPDATE_CPUID_CFM      105
//Param[0] = Result  //0 成功 其他 失败
#define   IT_MSG_GET_BALANCE_CFM       106
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = Balance //余额

#define   IT_MSG_GET_USER_INFO_CFM     107
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = OnLineTime //在线的总时长
//Param[2] = Balance    //余额
//Param[3] = CurState   //服务器显示的当前的状态
//Param[4] = Amount     //赠送金额
//Param[5] = Integral   //累计积分
//Param[6] = Level      //等级
//Param[7] = IconPath   //大头像的路径
//Param[8] = Name       昵称
//Param[9] = VName      真实姓名
//Param[10]= Phone      绑定的手机号码
//Param[11]= Sex       性别 0 女性 1 男性 2 未知 
//Param[12]= Birthday   生日
//Param[13]= QQ         QQ号
//Param[14]= CharacterSignature 个性签名
//Param[15]= Street     住址
//Param[16]= Area       地区


#define   IT_MSG_CALL_BACK_STATUS     108
//Param[0] = number      //主叫或被叫号码
//Param[1] = call status //这个号码的状态
//Param[2] = sAppHandle;


#define   IT_MSG_GET_PHONE_CHECK_CODE_CFM 109
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = Code    //手机验证码

#define   IT_MSG_REGISTER_CFM 110
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = WoXinID //系统唯一ID

#define   IT_MSG_UNREGISTER_CFM 111
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_LOAD_FRIEND_CFM 112
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = Phone 手机号码
//Param[2] = Name  姓名
//Param[3] = RemarkName 备注
//Param[4] = RecordID  
//Param[5] = wo_xin_id 
//Param[6] = icon_path

#define   IT_MSG_GET_FRIEND_ICON_CFM 113
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = IconPath 图片文件的路径  

//上传自己的图片
#define   IT_MSG_UPLOAD_MY_ICON_CFM 114
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = IconPath //大头像保存的路径


#define   IT_MSG_UPDATE_FRIEND_REMARK_NAME_CFM 115
//Param[0] = Result  //0 成功 其他 失败

//好友的图片修改通知消息
#define   IT_MSG_FRIEND_ICON_MODIFY_IND  116
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = IconPath 图片文件的路径  
//Param[2] = Phone 手机号码

#define   IT_MSG_UPLOAD_PHONE_INFO_CFM 117
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_DELETE_FRIEND_CFM   118
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = RID    删除的记录的ID



//发起新的呼叫
#define   IT_MSG_CALL_MAKE_CFM        119
//Param[0] = Result  //0 成功 其他 失败
//取消呼叫
#define   IT_MSG_CALL_CANCEL_CFM      120
//Param[0] = Result  //0 成功 其他 失败
//接听来电
#define   IT_MSG_CALL_ANSWER_CFM      121
//Param[0] = Result  //0 成功 其他 失败
//拒绝接听
#define   IT_MSG_CALL_REJECT_CFM      122
//Param[0] = Result  //0 成功 其他 失败
//挂机
#define   IT_MSG_CALL_RELEASE_CFM     123
//Param[0] = Result  //0 成功 其他 失败

//新的呼叫
#define   IT_MSG_CALL_NEW_IND      124
//Param[0] = WoXinID     主叫我信ID
//Param[1] = Caller      主叫号码,可以是我信ID
//Param[2] = CallerName  主叫姓名
//Param[3] = Called      被叫号码,可以是我信ID
//Param[4] = CalledName  被叫姓名
//Param[5] = Sampling    采样率，8000  8K采样   16000 16K采样


//对方响铃
#define   IT_MSG_CALL_ALERTING_IND  125
//Param[0] = Result  //0 成功 其他 失败

//对方响铃,要打开放音通道
#define   IT_MSG_CALL_ALERTING_SDP_IND  126
//Param[0] = Result  //0 成功 其他 失败
//对方挂机
//#define   IT_MSG_CALL_RELEASE_IND   127
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_CALL_ALERTING_CFM  128
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_CALL_CONNECT_IND  129
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_CALL_DISCONNECT_IND  130
//Param[0] = Sampling    采样率，8000  8K采样   16000 16K采样

#define   IT_MSG_CALL_CANCEL_IND       131
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_CALL_DTMF_CFM     132
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_CALL_REFUSE_IND       133
//Param[0] = ReasonCode  //1  被叫主动拒绝 ,  2  被叫没有接听，超时

#define   IT_MSG_CALL_BACK_HOOK_CFM     134
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = caller //主叫
//Param[2] = called //被叫

#define   IT_MSG_CALL_BACK_CDR_IND     135
//Param[0] = RID        记录的唯一ID
//Param[1] = Phone      号码，主叫或被叫
//Param[2] = Result     1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 7 回拨  8 回拨主叫拒接 9 回拨被叫忙/被叫拒接
//Param[3] = un32Time   通话开始的时间 
//Param[4] = TalkTime   //单位  秒



#define   IT_MSG_MAKE_CALL_TIME_OUT       140
#define   IT_MSG_CANCEL_CALL_TIME_OUT     141
#define   IT_MSG_ALERTING_CALL_TIME_OUT   142
#define   IT_MSG_ANSWER_CALL_TIME_OUT     143
#define   IT_MSG_REJECT_CALL_TIME_OUT     144
#define   IT_MSG_RELEASE_CALL_TIME_OUT    145
#define   IT_MSG_DTMF_CALL_TIME_OUT       146


//是我信用户的通知
#define   IT_MSG_FRIEND_MODIFY_WOXIN_USER_IND    150
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = Phone 手机号码
//Param[2] = Name  姓名
//Param[3] = RemarkName 备注
//Param[4] = RecordID  
//Param[5] = wo_xin_id 
//Param[6] = icon_path
//Param[7] = 0     0 不在是我信用户  1 是我信用户


//好友昵称发生改变的通知
#define   IT_MSG_FRIEND_MODIFY_NAME_IND          151
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = Phone 手机号码
//Param[2] = Name  姓名
//Param[3] = RemarkName 备注
//Param[4] = RecordID  
//Param[5] = wo_xin_id 
//Param[6] = icon_path



#define   IT_MSG_LOAD_WOXIN_FRIEND_CFM 152
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = Phone 手机号码
//Param[2] = Name  姓名
//Param[3] = RemarkName 备注姓名
//Param[4] = RecordID  
//Param[5] = wo_xin_id 
//Param[6] = icon_path

#define   IT_MSG_LOAD_CALL_RECORD_CFM   153
//Param[0] = RID        记录的唯一ID
//Param[1] = Phone      号码，主叫或被叫
//Param[2] = Result     1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 
//Param[3] = un32Time   通话开始的时间 
//Param[4] = TalkTime   //单位  秒


#define   IT_MSG_LOAD_USER_INFO_CFM   154
//Param[0] = pName       昵称
//Param[1] = pVName      真实姓名
//Param[2] = pPhone      绑定的手机号码
//Param[3] = ubSex       性别 0 女性 1 男性 2 未知 
//Param[4] = pBirthday   生日
//Param[5] = pQQ         QQ号
//Param[6] = pCharacterSignature 个性签名
//Param[7] = pStreet     住址
//Param[8] = pArea       地区
//Param[9] = icon_path   大头像路径
//Param[10]= WoXinID     我信ID

//更新用户自己的信息
#define   IT_MSG_UPDATE_USER_INFO_CFM   155
//Param[0] = Result  //0 成功 其他 失败



//////////////////////////////////////////////////////////////////////////

//获得一个商家有多少个地区
#define   IT_MSG_GET_AREA_INFO_CFM   160
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = number      有多少个
//Param[3] = json 串

//获得一个地区有多少个分店
#define   IT_MSG_GET_SHOP_INFO_CFM    161
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = number      有多少个
//Param[4] = json 串

//首页置顶大图
#define   IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM  162
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

//首页导航功能
#define   IT_MSG_GET_HOME_NAVIGATION_CFM  163
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

//猜你喜欢的随机商品
#define   IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM  164
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

//商品分类列表接口
#define   IT_MSG_GET_CATEGORY_LIST_CFM  165
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

//特殊属性的商品列表接口
#define   IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM  166
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

//商品详情接口
#define   IT_MSG_GET_GOODS_INFO_CFM  167
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = GoodsID     商品ID
//Param[5] = GroupID     商品组ID
//Param[6] = Description 商品描述
//Param[7] = Name        商品名
//Param[8] = MarketPrice 市场价格
//Param[9] = OURPrice    本店价格
//Param[10]= number      有多少个
//Param[11]= json 串
//Param[12]= LikeCount   喜欢累加
//Param[13]= MeterageName 单位


//商品详情接口
#define   IT_MSG_REPORT_MY_LOCATION_CFM  168
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2]= json 串

#define   IT_MSG_GET_LAST_BROWSE_SHOP_CFM  169
//Param[0] = SellerID    商家ID
//Param[1] = AreaID      地区ID
//Param[2] = ShopID      分店ID

#define   IT_MSG_GET_PACKAGE_CFM   170
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      多少个
//Param[5] = json 串

#define   IT_MSG_GET_GOODS_ALL_CFM   171
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      多少个
//Param[5] = json 串
//Param[6] = Domain      域名前缀


#define   IT_MSG_ADD_ORDER_CFM      172
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = order_code  订单号

#define   IT_MSG_UPDATE_ORDER_CFM   173
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = order_code  订单号

#define   IT_MSG_DEL_ORDER_CFM      174
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = order_code  订单号

#define   IT_MSG_LOAD_ORDER_CFM     175
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = number      多少个
//Param[4] = json 串

//加载红包
#define   IT_MSG_LOAD_RED_PACKAGE_CFM     176
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = Json        红包信息
//领取红包
#define   IT_MSG_RECEIVE_RED_PACKAGE_CFM     177
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = RedPackageID红包ID
//Param[4] = total_money 红包余额

//使用红包
#define   IT_MSG_USE_RED_PACKAGE_CFM     178
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = total_money 红包余额
//Param[4] = OrderCode   订单号order_code
//加载红包使用规则
#define   IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM     179
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = Json        红包使用规则信息
//推送消息
#define   IT_MSG_PUSH_MESSAGE_IND     180
//Param[0] = SellerID    商家ID
//Param[1] = ShopID      分店ID 目前不用这个字段
//Param[2] = MSGID       消息ID 目前不用这个字段
//Param[3] = Json        消息
//[
//{
//    "shop_id":22, // 分店ID
//    "shop_name":"龙华", // 分店名称
//    "msg_id":1000,// 消息ID
//    "msg_type":1,// 1 红包 2 消息
//    "time":1407829283,//推送时间
//    "push_title":"标题",
//    "push_content":"消息内容"
//    "price":500, /*红包面值*/
//    "red_type":1,//如: 1 注册红包 2 促销活动红包
//    "end_time":1407829283, //红包的截止日期
//    "red_title":"红包标题",
//    "red_remark":"红包备注，规则"
//},
//{
//    "shop_id":22, // 分店ID
//    "shop_name":"龙华", // 分店名称
//    "msg_id":1000,// 消息ID
//    "msg_type":2,// 1 红包 2 消息
//    "time":1407829283,
//    "push_title":"标题",
//    "push_content":"消息内容"
//    "list_title":"标题",
//    "list_image_url":"图片的URL",
//    "list_html_url":"消息的ULR",
//    "list_abstract":"消息概要"
//}
//]


#define   IT_MSG_GET_RED_PACKAGE_BALANCE_CFM  181
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = Balance     余额

#define   IT_MSG_GET_SELLER_ABOUT_CFM         182
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = Json        关于信息

#define   IT_MSG_GET_SHOP_ABOUT_CFM           183
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = Json        关于信息

#define   IT_MSG_GET_PUSH_MESSAGE_INFO_CFM       184
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = msg_id      //消息ID
//Param[4] = msg_type    //消息类型
//Param[5] = ShopName    //分店名称
//Param[6] = Title       //标题
//Param[7] = ImageURL    //图片的URL
//Param[8] = HtmlURL     //消息的ULR
//Param[9] = Abstract    //消息概要
//Param[10]= Json        //扩展用，目前不用

#define   IT_MSG_REPORT_TOKEN_CFM       185
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID


#define   IT_MSG_UPDATE_REG_SHOP_CFM    186
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID


#define   IT_MSG_IT_ABOUT_CFM     187
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = JSON    

#define   IT_MSG_IT_ABOUT_HELP_CFM     188
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = Content //内容

#define   IT_MSG_IT_ABOUT_PROTOCOL_CFM     189
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = Content //内容

#define   IT_MSG_IT_ABOUT_FEED_BACK_CFM     190
//Param[0] = Result  //0 成功 其他 失败

#define   IT_MSG_REMOTE_LOGIN_IND           191
//Param[0] = type //登录终端的类型,扩展用

//充值
#define   IT_MSG_RECHARGE_CFM           192
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = OrderID     订单ID
//Param[3] = PhpURL      
//Param[4] = WoXinResult 我信充值卡的充值结果

//获得充值优惠规则
#define   IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM           193
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = JSON        json串


//更新绑定的手机号码
#define   IT_MSG_UPDATE_BOUND_MOBILE_NUMBER_CFM           194
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID


#define   IT_MSG_GET_CREDIT_BALANCE_CFM     195
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = Balance     余额
//Param[2] = Minutes     分钟数
//Param[3] = SellerID    商家ID

#define   IT_MSG_SELECT_PHONE_CHECK_CODE_CFM     196
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = phone   手机号码
//Param[2] = code    验证码

//获得一个商家有多少个地区
#define   IT_MSG_GET_AREA_SHOP_INFO_CFM   197
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[3] = json 串

//首页置顶大图,带跳转属性
#define   IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM  198
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = AreaID      地区ID
//Param[3] = ShopID      分店ID
//Param[4] = number      有多少个
//Param[5] = json 串

#define   IT_MSG_GET_ORDER_CODE_PAY_MODE_CFM 199
//Param[0] = Result  //0  成功 其他 失败
//Param[1] = SellerID     商家ID
//Param[2] = ShopID       分店ID
//Param[3] = Type         类型
//Param[4] = OrderCode    订单号
//Param[5] = string       流水号或URL

#define   IT_MSG_ORDER_REFUND_CFM  200
//Param[0] = Result  //0  成功 其他 失败
//Param[1] = SellerID     商家ID
//Param[2] = ShopID       分店ID
//Param[3] = OrderCode    订单号

#define   IT_MSG_UPDATE_DB_IND  201
//Param[0] = path //  库的路径

//订单确认接口
#define   IT_MSG_ORDER_CONFIRM_CFM  202
//Param[0] = Result  //0  成功 其他 失败
//Param[1] = SellerID     商家ID
//Param[2] = ShopID       分店ID
//Param[3] = OrderCode    订单号

#define   IT_MSG_CANCEL_ORDER_CFM      203
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = order_code  订单号

#define   IT_MSG_LOAD_ORDER_SINGLE_CFM      204
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = number      多少个
//Param[4] = json 串

#define   IT_MSG_ORDER_REMINDERS_CFM      205
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = order_code  订单号


#define   IT_MSG_SEND_PAY_RESULT_CFM  206
//Param[0] = Result  //0  成功 其他 失败
//Param[1] = SellerID     商家ID
//Param[2] = ShopID       分店ID
//Param[3] = OrderCode    订单号

#define   IT_MSG_GET_ORDER_REFUND_INFO_CFM      207
//Param[0] = Result  //0 成功 其他 失败
//Param[1] = SellerID    商家ID
//Param[2] = ShopID      分店ID
//Param[3] = OrderCode    订单号
//Param[4] = json 串

//////////////////////////////////////////////////////////////////////////

//与商城相关的消息定义
#define   ITREG_MALL_GET_AREA_INFO_IND                         (SS_MSG+800) //获得一个商家有多少个地区，比如连锁店在多个城市
#define   ITREG_MALL_GET_AREA_INFO_IND_TYPE_SELLER_ID          1   //商家ID

#define   ITREG_MALL_GET_AREA_INFO_CFM                         (SS_MSG+801) //
#define   ITREG_MALL_GET_AREA_INFO_CFM_TYPE_RESULT          1
#define   ITREG_MALL_GET_AREA_INFO_CFM_TYPE_SELLER_ID       2   //商家ID
#define   ITREG_MALL_GET_AREA_INFO_CFM_TYPE_NUMBER          3  //有多少个
#define   ITREG_MALL_GET_AREA_INFO_CFM_TYPE_INFO            4  //地区信息

#define   ITREG_MALL_GET_SHOP_INFO_IND                         (SS_MSG+802) //获得一个地区有多少个分店，在一个地区的分店
#define   ITREG_MALL_GET_SHOP_INFO_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_SHOP_INFO_IND_TYPE_AREA_ID            2   //地区ID

#define   ITREG_MALL_GET_SHOP_INFO_CFM                         (SS_MSG+803) //
#define   ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_NUMBER             4  //有多少个
#define   ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_INFO               5   //分店信息

#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND              (SS_MSG+804) //首页置顶大图
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_SHOP_ID            3   //分店ID


#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM              (SS_MSG+805) //
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_INFO               6   //图片相关信息

#define   ITREG_MALL_GET_HOME_NAVIGATION_IND                   (SS_MSG+806) //首页导航功能
#define   ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM                   (SS_MSG+807) //
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_INFO               6   //信息

#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND       (SS_MSG+808) //猜你喜欢的随机商品
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM       (SS_MSG+809) //
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_INFO               6   //信息

#define   ITREG_MALL_GET_CATEGORY_LIST_IND                     (SS_MSG+810) //商品分类列表接口
#define   ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_CATEGORY_LIST_CFM                     (SS_MSG+811) //
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_INFO               6   //信息

#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND  (SS_MSG+812) // 特殊属性的商品列表接口
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM  (SS_MSG+813) // 特殊属性的商品列表接口
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_INFO               6   //信息


#define   ITREG_MALL_GET_GOODS_INFO_IND                        (SS_MSG+814) //商品详情接口
#define   ITREG_MALL_GET_GOODS_INFO_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_GOODS_INFO_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_GOODS_INFO_IND_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_GET_GOODS_INFO_IND_TYPE_GOODS_ID           4   //商品ID

#define   ITREG_MALL_GET_GOODS_INFO_CFM                        (SS_MSG+815) //
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_GOODS_ID           5   //商品ID
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_GROUP_ID           6   //商品组ID
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_DESCRIPTION        7   //商品描述
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_NAME               8   //商品名
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_MARKET_PRICE       9   //市场价格
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_OUR_PRICE          10   //本店价格
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_PICTURE_NUMBER     11  //商品图片URL 多张
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_INFO               12   //信息
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_TYPE_LIKE_COUNT    13   //喜欢累加
#define   ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_TYPE_METERAGE_NAME 14   //单位

#define   ITREG_MALL_REPORT_MY_LOCATION_IND                        (SS_MSG+816) //上报自己的地理位置
#define   ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_SELLER_ID      1   //商家ID
#define   ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_LATITUDE       2  //纬度
#define   ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_LONGITUDE      3  //经度

#define   ITREG_MALL_REPORT_MY_LOCATION_CFM                        (SS_MSG+817) //上报自己的地理位置
#define   ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_RESULT         1   //
#define   ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_SELLER_ID      2   //商家ID
#define   ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_JSON           3   //信息


#define   ITREG_MALL_GET_PACKAGE_IND                            (SS_MSG+818) //获得套餐列表
#define   ITREG_MALL_GET_PACKAGE_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_PACKAGE_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_PACKAGE_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_PACKAGE_CFM                        (SS_MSG+820) //获得套餐列表
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_NUMBER             5   //多少个
#define   ITREG_MALL_GET_PACKAGE_CFM_TYPE_JSON               6   //信息

#define   ITREG_MALL_GET_GOODS_ALL_IND                         (SS_MSG+821) //获得全部的商品列表
#define   ITREG_MALL_GET_GOODS_ALL_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_GOODS_ALL_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_GOODS_ALL_IND_TYPE_SHOP_ID            3   //分店ID

#define   ITREG_MALL_GET_GOODS_ALL_CFM                        (SS_MSG+822) //获得全部的商品列表
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_NUMBER             5   //多少个
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_JSON               6   //信息
#define   ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_DOMAIN             7   //域名前缀

#define   ITREG_MALL_ADD_ORDER_IND                         (SS_MSG+823) //添加订单
#define   ITREG_MALL_ADD_ORDER_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_ADD_ORDER_IND_TYPE_SHOP_ID            2   //分店ID
#define   ITREG_MALL_ADD_ORDER_IND_TYPE_WOXIN_ID           3   //我信ID
#define   ITREG_MALL_ADD_ORDER_IND_TYPE_JSON               4   //信息

#define   ITREG_MALL_ADD_ORDER_CFM                         (SS_MSG+824) //添加订单
#define   ITREG_MALL_ADD_ORDER_CFM_TYPE_RESULT             1
#define   ITREG_MALL_ADD_ORDER_CFM_TYPE_ORDER_CODE         2  //订单号order_code
#define   ITREG_MALL_ADD_ORDER_CFM_TYPE_SELLER_ID          3   //商家ID
#define   ITREG_MALL_ADD_ORDER_CFM_TYPE_SHOP_ID            4   //分店ID

#define   ITREG_MALL_UPDATE_ORDER_IND                      (SS_MSG+825) //更新订单
#define   ITREG_MALL_UPDATE_ORDER_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_UPDATE_ORDER_IND_TYPE_SHOP_ID            2   //分店ID
#define   ITREG_MALL_UPDATE_ORDER_IND_TYPE_WOXIN_ID           3   //我信ID
#define   ITREG_MALL_UPDATE_ORDER_IND_TYPE_ORDER_CODE         4   //订单号order_code
#define   ITREG_MALL_UPDATE_ORDER_IND_TYPE_JSON               5   //信息

#define   ITREG_MALL_UPDATE_ORDER_CFM                      (SS_MSG+826) //更新订单
#define   ITREG_MALL_UPDATE_ORDER_CFM_TYPE_RESULT             1
#define   ITREG_MALL_UPDATE_ORDER_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_UPDATE_ORDER_CFM_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_UPDATE_ORDER_CFM_TYPE_ORDER_CODE         4   //订单号order_code

#define   ITREG_MALL_DEL_ORDER_IND                         (SS_MSG+827) //删除订单
#define   ITREG_MALL_DEL_ORDER_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_DEL_ORDER_IND_TYPE_SHOP_ID            2   //分店ID
#define   ITREG_MALL_DEL_ORDER_IND_TYPE_WOXIN_ID           3   //我信ID
#define   ITREG_MALL_DEL_ORDER_IND_TYPE_ORDER_CODE         4   //订单号order_code

#define   ITREG_MALL_DEL_ORDER_CFM                         (SS_MSG+828) //删除订单
#define   ITREG_MALL_DEL_ORDER_CFM_TYPE_RESULT             1
#define   ITREG_MALL_DEL_ORDER_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_DEL_ORDER_CFM_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_DEL_ORDER_CFM_TYPE_ORDER_CODE         4   //订单号order_code

#define   ITREG_MALL_LOAD_ORDER_IND                         (SS_MSG+829) //加载订单列表
#define   ITREG_MALL_LOAD_ORDER_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_LOAD_ORDER_IND_TYPE_SHOP_ID            2   //分店ID
#define   ITREG_MALL_LOAD_ORDER_IND_TYPE_WOXIN_ID           3   //我信ID
#define   ITREG_MALL_LOAD_ORDER_IND_TYPE_OFF_SET            4   //
#define   ITREG_MALL_LOAD_ORDER_IND_TYPE_LIMIT              5   //

#define   ITREG_MALL_LOAD_ORDER_CFM                         (SS_MSG+830) //加载订单列表
#define   ITREG_MALL_LOAD_ORDER_CFM_TYPE_RESULT             1
#define   ITREG_MALL_LOAD_ORDER_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_LOAD_ORDER_CFM_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_LOAD_ORDER_CFM_TYPE_NUMBER             4
#define   ITREG_MALL_LOAD_ORDER_CFM_TYPE_JSON               5   //信息


#define   ITREG_MALL_LOAD_RED_PACKAGE_IND                    (SS_MSG+831) //加载红包
#define   ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_SELLER_ID     1   //商家ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_SHOP_ID       2   //分店ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_WOXIN_ID      3   //我信ID

#define   ITREG_MALL_LOAD_RED_PACKAGE_CFM                    (SS_MSG+832) //加载红包
#define   ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_RESULT        1
#define   ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_SELLER_ID     2   //商家ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_SHOP_ID       3   //分店ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_JSON          4   //Json串

#define   ITREG_MALL_RECEIVE_RED_PACKAGE_IND                 (SS_MSG+833) //领取红包
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_SELLER_ID      1   //商家ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_SHOP_ID        2   //分店ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_WOXIN_ID       3   //我信ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_RED_PACKAGE_ID 4   //红包ID

#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM                 (SS_MSG+834) //领取红包
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_RESULT         1
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_SELLER_ID      2   //商家ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_SHOP_ID        3   //分店ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_RED_PACKAGE_ID 4   //红包ID
#define   ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_TOTAL_MONEY    5   //红包余额


#define   ITREG_MALL_USE_RED_PACKAGE_IND                       (SS_MSG+835) //使用红包
#define   ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_SELLER_ID        1   //商家ID
#define   ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_SHOP_ID          2   //分店ID
#define   ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_WOXIN_ID         3   //我信ID
#define   ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_PRICE            4   //红包金额
#define   ITREG_MALL_USE_RED_PACKAGE_IND_ORDER_CODE            5   //订单号order_code

#define   ITREG_MALL_USE_RED_PACKAGE_CFM                      (SS_MSG+836) //使用红包
#define   ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_RESULT          1
#define   ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_SELLER_ID       2   //商家ID
#define   ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_SHOP_ID         3   //分店ID
#define   ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_TOTAL_MONEY     4   //红包余额
#define   ITREG_MALL_USE_RED_PACKAGE_CFM_ORDER_CODE           5   //订单号order_code


#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND                 (SS_MSG+837) //加载红包使用规则
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_SELLER_ID  1   //商家ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_SHOP_ID    2   //分店ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_WOXIN_ID   3   //我信ID

#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM                 (SS_MSG+838) //加载红包使用规则
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_RESULT     1
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_SELLER_ID  2   //商家ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_SHOP_ID    3   //分店ID
#define   ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_JSON       4   //Json串


#define   ITREG_MALL_PUSH_MESSAGE_IND                 (SS_MSG+839) //推送消息
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_SELLER_ID  1   //商家ID
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_SHOP_ID    2   //分店ID
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_MSG_ID     3   //消息ID
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_JSON       4   //Json串
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_TYPE       5
#define   ITREG_MALL_PUSH_MESSAGE_IND_TYPE_MSG_ARRAY  6

#define   ITREG_MALL_PUSH_MESSAGE_CFM                 (SS_MSG+840) //推送消息
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_RESULT     1
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_SELLER_ID  2   //商家ID
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_SHOP_ID    3   //分店ID
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_MSG_ID     4   //消息ID
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_TYPE       5
#define   ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_MSG_ARRAY  6


#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND      (SS_MSG+843) //获得红包余额
#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND_TYPE_SELLER_ID  1   //商家ID

#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM      (SS_MSG+844) //获得红包余额
#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_RESULT     1
#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_SELLER_ID  2   //商家ID
#define   ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_BALANCE    3   //余额

#define   ITREG_MALL_GET_SELLER_ABOUT_IND             (SS_MSG+845) //获得商家关于信息
#define   ITREG_MALL_GET_SELLER_ABOUT_IND_TYPE_SELLER_ID  1   //商家ID

#define   ITREG_MALL_GET_SELLER_ABOUT_CFM             (SS_MSG+846) //获得商家关于信息
#define   ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_RESULT     1
#define   ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_SELLER_ID  2   //商家ID
#define   ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_JSON       3   //关于信息

#define   ITREG_MALL_GET_SHOP_ABOUT_IND               (SS_MSG+847) //获得分店关于信息
#define   ITREG_MALL_GET_SHOP_ABOUT_IND_TYPE_SELLER_ID  1   //商家ID
#define   ITREG_MALL_GET_SHOP_ABOUT_IND_TYPE_SHOP_ID    2   //分店ID

#define   ITREG_MALL_GET_SHOP_ABOUT_CFM               (SS_MSG+848) //获得分店关于信息
#define   ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_RESULT     1
#define   ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_SELLER_ID  2   //商家ID
#define   ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_SHOP_ID    3   //分店ID
#define   ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_JSON       4   //关于信息

#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND               (SS_MSG+849) //获得推送消息的详细信息
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_SELLER_ID   1   //商家ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_SHOP_ID     2   //分店ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_MSG_ID      3   //消息ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_MSG_TYPE    4   //消息类型

#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM               (SS_MSG+850) //获得推送消息的详细信息
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_RESULT      1
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SELLER_ID   2   //商家ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SHOP_ID     3   //分店ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_MSG_ID      4   //消息ID
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_MSG_TYPE    5   //消息类型
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SHOP_NAME   6   //分店名称
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_TITLE       7   //标题
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_IMAGE_URL   8   //图片的URL
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_HTML_URL    9   //消息的ULR
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_ABSTRACT    10  //消息概要
#define   ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_JSON        11  //扩展用，目前不用


#define   ITREG_MALL_GET_AREA_SHOP_INFO_IND                    (SS_MSG+863) //获得一个商家所有的地区和分店信息
#define   ITREG_MALL_GET_AREA_SHOP_INFO_IND_TYPE_SELLER_ID     1   //商家ID

#define   ITREG_MALL_GET_AREA_SHOP_INFO_CFM                    (SS_MSG+864) //获得一个商家所有的地区和分店信息
#define   ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_RESULT        1
#define   ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_SELLER_ID     2   //商家ID
#define   ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_JSON          3   //


#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND              (SS_MSG+865) //首页置顶大图
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_SELLER_ID          1   //商家ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_AREA_ID            2   //地区ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_SHOP_ID            3   //分店ID


#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM              (SS_MSG+866) //
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_AREA_ID            3   //地区ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_SHOP_ID            4   //分店ID
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_NUMBER             5   //有多少个
#define   ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_INFO               6   //图片相关信息


#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND              (SS_MSG+867) //银联支付流水号
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE              4
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM              (SS_MSG+868) //银联支付流水号
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_RESULT        1
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_ORDER_CODE    4
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SERIAL_NUMBER 5
#define   ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE               6

#define   ITREG_MALL_ORDER_REFUND_IND              (SS_MSG+869) //银联支付流水号
#define   ITREG_MALL_ORDER_REFUND_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_ORDER_REFUND_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_ORDER_REFUND_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_ORDER_REFUND_IND_TYPE_GROUNDS      4
#define   ITREG_MALL_ORDER_REFUND_CFM              (SS_MSG+870) //银联支付流水号
#define   ITREG_MALL_ORDER_REFUND_CFM_TYPE_RESULT        1
#define   ITREG_MALL_ORDER_REFUND_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_ORDER_REFUND_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_ORDER_REFUND_CFM_TYPE_ORDER_CODE    4

#define   ITREG_MALL_ORDER_CONFIRM_IND              (SS_MSG+871) //银联支付流水号
#define   ITREG_MALL_ORDER_CONFIRM_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_ORDER_CONFIRM_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_ORDER_CONFIRM_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_ORDER_CONFIRM_CFM              (SS_MSG+872) //银联支付流水号
#define   ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_RESULT        1
#define   ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_ORDER_CODE    4

#define   ITREG_MALL_ORDER_CANCEL_IND              (SS_MSG+873) //银联支付流水号
#define   ITREG_MALL_ORDER_CANCEL_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_ORDER_CANCEL_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_ORDER_CANCEL_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_ORDER_CANCEL_CFM              (SS_MSG+874) //银联支付流水号
#define   ITREG_MALL_ORDER_CANCEL_CFM_TYPE_RESULT        1
#define   ITREG_MALL_ORDER_CANCEL_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_ORDER_CANCEL_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_ORDER_CANCEL_CFM_TYPE_ORDER_CODE    4

#define   ITREG_MALL_LOAD_ORDER_SINGLE_IND              (SS_MSG+875) //
#define   ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM              (SS_MSG+876) //
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_RESULT             1
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_ORDER_CODE         4
#define   ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_JSON               5   //信息

#define   ITREG_MALL_ORDER_REMINDERS_IND              (SS_MSG+877) //银联支付流水号
#define   ITREG_MALL_ORDER_REMINDERS_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_ORDER_REMINDERS_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_ORDER_REMINDERS_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_ORDER_REMINDERS_CFM              (SS_MSG+878) //银联支付流水号
#define   ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_RESULT        1
#define   ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_ORDER_CODE    4


#define   ITREG_MALL_SEND_PAY_RESULT_IND              (SS_MSG+879) //银联支付流水号
#define   ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_RESULT       4
#define   ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_PAY_TYPE     5

#define   ITREG_MALL_SEND_PAY_RESULT_CFM              (SS_MSG+880) //银联支付流水号
#define   ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_RESULT        1
#define   ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_SELLER_ID     2
#define   ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_SHOP_ID       3
#define   ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_ORDER_CODE    4

#define   ITREG_MALL_GET_ORDER_REFUND_INFO_IND              (SS_MSG+881) //
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_SELLER_ID    1
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_SHOP_ID      2
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_ORDER_CODE   3
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM              (SS_MSG+882) //
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_RESULT             1
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_SELLER_ID          2   //商家ID
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_SHOP_ID            3   //分店ID
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_ORDER_CODE         4
#define   ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_JSON               5   //信息

//////////////////////////////////////////////////////////////////////////

#define   ITREG_CALL_INVITE_IND         (SS_MSG+601)      //开始呼叫
#define   ITREG_CALL_INVITE_IND_TYPE_WO_XIN_ID    1
#define   ITREG_CALL_INVITE_IND_TYPE_PHONE        2
#define   ITREG_CALL_INVITE_IND_TYPE_CALLER       3
#define   ITREG_CALL_INVITE_IND_TYPE_CALLER_NAME  4
#define   ITREG_CALL_INVITE_IND_TYPE_CALLED       5
#define   ITREG_CALL_INVITE_IND_TYPE_CALLED_NAME  6
#define   ITREG_CALL_INVITE_IND_TYPE_AUDIO_IP     7
#define   ITREG_CALL_INVITE_IND_TYPE_VIDEO_IP     8
#define   ITREG_CALL_INVITE_IND_TYPE_AUDIO_CODE   9
#define   ITREG_CALL_INVITE_IND_TYPE_VIDEO_CODE   10
#define   ITREG_CALL_INVITE_IND_TYPE_AUDIO_PORT   11
#define   ITREG_CALL_INVITE_IND_TYPE_VIDEO_PORT   12

#define   ITREG_CALL_INVITE_CFM         (SS_MSG+602)      //确认
#define   ITREG_CALL_INVITE_CFM_TYPE_RESULT          1
#define   ITREG_CALL_INVITE_CFM_TYPE_CALLED_MS_NODE  2
#define   ITREG_CALL_INVITE_CFM_TYPE_CALLED_IT_NODE  3
#define   ITREG_CALL_INVITE_CFM_TYPE_CALLED_REG_NODE 4

#define   ITREG_CALL_ALERTING_IND       (SS_MSG+603)      //响铃
#define   ITREG_CALL_ALERTING_IND_TYPE_CALLED_MS_NODE  1
#define   ITREG_CALL_ALERTING_IND_TYPE_CALLED_IT_NODE  2
#define   ITREG_CALL_ALERTING_IND_TYPE_CALLED_REG_NODE 3
#define   ITREG_CALL_ALERTING_IND_TYPE_STATUS          4

#define   ITREG_CALL_ALERTING_CFM       (SS_MSG+604)      //确认
#define   ITREG_CALL_ALERTING_CFM_TYPE_RESULT          1
#define   ITREG_CALL_ALERTING_CFM_TYPE_CALLED_MS_NODE  2
#define   ITREG_CALL_ALERTING_CFM_TYPE_CALLED_IT_NODE  3
#define   ITREG_CALL_ALERTING_CFM_TYPE_CALLED_REG_NODE 4

#define   ITREG_CALL_ALERTING_SDP_IND   (SS_MSG+605)      //响铃 带语音
#define   ITREG_CALL_ALERTING_SDP_CFM   (SS_MSG+606)      //确认

#define   ITREG_CALL_CONNECT_IND        (SS_MSG+607)      //
#define   ITREG_CALL_CONNECT_IND_TYPE_AUDIO_IP         1
#define   ITREG_CALL_CONNECT_IND_TYPE_VIDEO_IP         2
#define   ITREG_CALL_CONNECT_IND_TYPE_AUDIO_CODE       3
#define   ITREG_CALL_CONNECT_IND_TYPE_VIDEO_CODE       4
#define   ITREG_CALL_CONNECT_IND_TYPE_AUDIO_PORT       5
#define   ITREG_CALL_CONNECT_IND_TYPE_VIDEO_PORT       6
#define   ITREG_CALL_CONNECT_IND_TYPE_CALLED_MS_NODE   7
#define   ITREG_CALL_CONNECT_IND_TYPE_CALLED_IT_NODE   8
#define   ITREG_CALL_CONNECT_IND_TYPE_CALLED_REG_NODE  9


#define   ITREG_CALL_CONNECT_CFM        (SS_MSG+608)      //确认
#define   ITREG_CALL_CONNECT_CFM_TYPE_RESULT           1
#define   ITREG_CALL_CONNECT_CFM_TYPE_CALLED_MS_NODE   2
#define   ITREG_CALL_CONNECT_CFM_TYPE_CALLED_IT_NODE   3
#define   ITREG_CALL_CONNECT_CFM_TYPE_CALLED_REG_NODE  4

#define   ITREG_CALL_DISCONNECT_IND     (SS_MSG+609)      //
#define   ITREG_CALL_DISCONNECT_IND_TYPE_REASON_CODE      1 //愿因码
#define   ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_MS_NODE   2
#define   ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_IT_NODE   3
#define   ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_REG_NODE  4

#define   ITREG_CALL_DISCONNECT_CFM     (SS_MSG+610)     //确认
#define   ITREG_CALL_DISCONNECT_CFM_TYPE_RESULT           1
#define   ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_MS_NODE   2
#define   ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_IT_NODE   3
#define   ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_REG_NODE  4

#define   ITREG_CALL_REPEAL_IND         (SS_MSG+611)    //撤销呼叫
#define   ITREG_CALL_REPEAL_IND_TYPE_REASON_CODE      1 //愿因码
#define   ITREG_CALL_REPEAL_IND_TYPE_CALL_MS_NODE     2
#define   ITREG_CALL_REPEAL_IND_TYPE_CALL_IT_NODE     3
#define   ITREG_CALL_REPEAL_IND_TYPE_CALL_REG_NODE    4

#define   ITREG_CALL_REPEAL_CFM        (SS_MSG+612)
#define   ITREG_CALL_REPEAL_CFM_TYPE_RESULT           1
#define   ITREG_CALL_REPEAL_CFM_TYPE_CALL_MS_NODE   2
#define   ITREG_CALL_REPEAL_CFM_TYPE_CALL_IT_NODE   3
#define   ITREG_CALL_REPEAL_CFM_TYPE_CALL_REG_NODE  4


#define   ITREG_CALL_DTMF_IND           (SS_MSG+613)
#define   ITREG_CALL_DTMF_IND_TYPE_KEY            1
#define   ITREG_CALL_DTMF_IND_TYPE_CALL_MS_NODE   2
#define   ITREG_CALL_DTMF_IND_TYPE_CALL_IT_NODE   3
#define   ITREG_CALL_DTMF_IND_TYPE_CALL_REG_NODE  4

#define   ITREG_CALL_DTMF_CFM           (SS_MSG+614)
#define   ITREG_CALL_DTMF_CFM_TYPE_RESULT           1


#define   ITREG_CALL_MAKE_CALL_IND      (SS_MSG+615)     //创建呼叫
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER       1
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_NAME  2
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLED       3
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLED_NAME  4
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_IP     5
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_IP     6
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_CODE   7
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_CODE   8
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_PORT   9
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_PORT   10
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_MS_NODE      11
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_IT_NODE      12
#define   ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_REG_NODE     13

#define   ITREG_CALL_MAKE_CALL_CFM      (SS_MSG+616)     //确认
#define   ITREG_CALL_MAKE_CALL_CFM_TYPE_RESULT          1
#define   ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_MS_NODE  2
#define   ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_IT_NODE  3
#define   ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_REG_NODE 4

#define   ITREG_CALL_180_IND            (SS_MSG+617)     //创建呼叫
#define   ITREG_CALL_180_IND_TYPE_CALLER_MS_NODE  1
#define   ITREG_CALL_180_IND_TYPE_CALLER_IT_NODE  2
#define   ITREG_CALL_180_IND_TYPE_CALLER_REG_NODE 3
#define   ITREG_CALL_180_IND_TYPE_STATUS          4

#define   ITREG_CALL_180_CFM            (SS_MSG+618)     //确认
#define   ITREG_CALL_180_CFM_TYPE_RESULT           1
#define   ITREG_CALL_180_CFM_TYPE_CALLER_MS_NODE   2
#define   ITREG_CALL_180_CFM_TYPE_CALLER_IT_NODE   3
#define   ITREG_CALL_180_CFM_TYPE_CALLER_REG_NODE  4


#define   ITREG_CALL_180_SDP_IND        (SS_MSG+619)     //创建呼叫
#define   ITREG_CALL_180_SDP_CFM        (SS_MSG+620)     //确认
#define   ITREG_CALL_200_IND            (SS_MSG+621)     //创建呼叫
#define   ITREG_CALL_200_IND_TYPE_AUDIO_IP        1
#define   ITREG_CALL_200_IND_TYPE_VIDEO_IP        2
#define   ITREG_CALL_200_IND_TYPE_AUDIO_CODE      3
#define   ITREG_CALL_200_IND_TYPE_VIDEO_CODE      4
#define   ITREG_CALL_200_IND_TYPE_AUDIO_PORT      5
#define   ITREG_CALL_200_IND_TYPE_VIDEO_PORT      6
#define   ITREG_CALL_200_IND_TYPE_CALLER_MS_NODE  7
#define   ITREG_CALL_200_IND_TYPE_CALLER_IT_NODE  8
#define   ITREG_CALL_200_IND_TYPE_CALLER_REG_NODE 9


#define   ITREG_CALL_200_CFM            (SS_MSG+622)     //确认
#define   ITREG_CALL_200_CFM_TYPE_RESULT           1
#define   ITREG_CALL_200_CFM_TYPE_CALLER_MS_NODE   2
#define   ITREG_CALL_200_CFM_TYPE_CALLER_IT_NODE   3
#define   ITREG_CALL_200_CFM_TYPE_CALLER_REG_NODE  4

#define   ITREG_CALL_BEY_IND            (SS_MSG+623)     //创建呼叫
#define   ITREG_CALL_BEY_IND_TYPE_CALLER_MS_NODE  1
#define   ITREG_CALL_BEY_IND_TYPE_CALLER_IT_NODE  2
#define   ITREG_CALL_BEY_IND_TYPE_CALLER_REG_NODE 3
#define   ITREG_CALL_BEY_IND_TYPE_REASON_CODE     4 //愿因码

#define   ITREG_CALL_BEY_CFM            (SS_MSG+624)     //确认
#define   ITREG_CALL_BEY_CFM_TYPE_RESULT           1
#define   ITREG_CALL_BEY_CFM_TYPE_CALLER_MS_NODE   2
#define   ITREG_CALL_BEY_CFM_TYPE_CALLER_IT_NODE   3
#define   ITREG_CALL_BEY_CFM_TYPE_CALLER_REG_NODE  4

#define   ITREG_CALL_CANCEL_IND         (SS_MSG+625)     //取消呼叫
#define   ITREG_CALL_CANCEL_IND_TYPE_REASON_CODE      1 //愿因码
#define   ITREG_CALL_CANCEL_IND_TYPE_CALL_MS_NODE     2
#define   ITREG_CALL_CANCEL_IND_TYPE_CALL_IT_NODE     3
#define   ITREG_CALL_CANCEL_IND_TYPE_CALL_REG_NODE    4

#define   ITREG_CALL_CANCEL_CFM         (SS_MSG+626)     //确认
#define   ITREG_CALL_CANCEL_CFM_TYPE_RESULT           1
#define   ITREG_CALL_CANCEL_CFM_TYPE_CALL_MS_NODE     2
#define   ITREG_CALL_CANCEL_CFM_TYPE_CALL_IT_NODE     3
#define   ITREG_CALL_CANCEL_CFM_TYPE_CALL_REG_NODE    4


#define   ITREG_CALL_REJECT_IND         (SS_MSG+627)     //拒绝呼叫 上行
#define   ITREG_CALL_REJECT_IND_TYPE_REASON_CODE      1 //愿因码
#define   ITREG_CALL_REJECT_IND_TYPE_CALLER_MS_NODE     2
#define   ITREG_CALL_REJECT_IND_TYPE_CALLER_IT_NODE     3
#define   ITREG_CALL_REJECT_IND_TYPE_CALLER_REG_NODE    4

#define   ITREG_CALL_REJECT_CFM         (SS_MSG+628)     //确认
#define   ITREG_CALL_REJECT_CFM_TYPE_RESULT           1
#define   ITREG_CALL_REJECT_CFM_TYPE_CALLER_MS_NODE     2
#define   ITREG_CALL_REJECT_CFM_TYPE_CALLER_IT_NODE     3
#define   ITREG_CALL_REJECT_CFM_TYPE_CALLER_REG_NODE    4

#define   ITREG_CALL_REFUSE_IND         (SS_MSG+629)     //拒绝呼叫 下行
#define   ITREG_CALL_REFUSE_IND_TYPE_REASON_CODE      1 //愿因码
#define   ITREG_CALL_REFUSE_IND_TYPE_CALLED_MS_NODE     2
#define   ITREG_CALL_REFUSE_IND_TYPE_CALLED_IT_NODE     3
#define   ITREG_CALL_REFUSE_IND_TYPE_CALLED_REG_NODE    4

#define   ITREG_CALL_REFUSE_CFM         (SS_MSG+630)     //确认
#define   ITREG_CALL_REFUSE_CFM_TYPE_RESULT             1
#define   ITREG_CALL_REFUSE_CFM_TYPE_CALLED_MS_NODE     2
#define   ITREG_CALL_REFUSE_CFM_TYPE_CALLED_IT_NODE     3
#define   ITREG_CALL_REFUSE_CFM_TYPE_CALLED_REG_NODE    4



#define   ITREG_IT_ABOUT_IND              (SS_MSG+5) //关于
#define   ITREG_IT_ABOUT_IND_TYPE_STRING  1 //扩展用

#define   ITREG_IT_ABOUT_CFM              (SS_MSG+6) //关于
#define   ITREG_IT_ABOUT_CFM_TYPE_RESULT   1
#define   ITREG_IT_ABOUT_CFM_TYPE_JSON     2

#define   ITREG_IT_ABOUT_HELP_IND         (SS_MSG+7) //关于帮助
#define   ITREG_IT_ABOUT_HELP_IND_TYPE_STRING  1 //扩展用

#define   ITREG_IT_ABOUT_HELP_CFM         (SS_MSG+8) //关于帮助
#define   ITREG_IT_ABOUT_HELP_CFM_TYPE_RESULT   1
#define   ITREG_IT_ABOUT_HELP_CFM_TYPE_CONTENT  2

#define   ITREG_IT_ABOUT_PROTOCOL_IND     (SS_MSG+9) //关于协议
#define   ITREG_IT_ABOUT_PROTOCOL_IND_TYPE_STRING  1 //扩展用

#define   ITREG_IT_ABOUT_PROTOCOL_CFM     (SS_MSG+10) //关于协议
#define   ITREG_IT_ABOUT_PROTOCOL_CFM_TYPE_RESULT   1
#define   ITREG_IT_ABOUT_PROTOCOL_CFM_TYPE_CONTENT  2

#define   ITREG_IT_ABOUT_FEED_BACK_IND    (SS_MSG+11) //关于问题反馈
#define   ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_STRING   1 //扩展用
#define   ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_QQ       2
#define   ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_EMAIL    3
#define   ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_CONTENT  4

#define   ITREG_IT_ABOUT_FEED_BACK_CFM    (SS_MSG+12) //关于问题反馈
#define   ITREG_IT_ABOUT_FEED_BACK_CFM_TYPE_RESULT       1


#define   ITREG_UPDATE_REG_SHOP_IND              (SS_MSG+13)//更新用户注册的分店
#define   ITREG_UPDATE_REG_SHOP_IND_TYPE_SELLER_ID    1
#define   ITREG_UPDATE_REG_SHOP_IND_TYPE_SHOP_ID      2

#define   ITREG_UPDATE_REG_SHOP_CFM              (SS_MSG+14)
#define   ITREG_UPDATE_REG_SHOP_CFM_TYPE_RESULT       1
#define   ITREG_UPDATE_REG_SHOP_CFM_TYPE_SELLER_ID    2
#define   ITREG_UPDATE_REG_SHOP_CFM_TYPE_SHOP_ID      3


#define   ITREG_REPORT_TOKEN_IND              (SS_MSG+15)
#define   ITREG_REPORT_TOKEN_IND_TYPE_SELLER_ID    1
#define   ITREG_REPORT_TOKEN_IND_TYPE_TOKEN        2
#define   ITREG_REPORT_TOKEN_IND_TYPE_USER_ID      3
#define   ITREG_REPORT_TOKEN_IND_TYPE_CERTS_TYPE   4
#define   ITREG_REPORT_TOKEN_IND_TYPE_MACHINE_ID   5

#define   ITREG_REPORT_TOKEN_CFM              (SS_MSG+16)
#define   ITREG_REPORT_TOKEN_CFM_TYPE_RESULT       1
#define   ITREG_REPORT_TOKEN_CFM_TYPE_SELLER_ID    2


#define   ITREG_UPDATE_USER_INFO              (SS_MSG+17)
#define   ITREG_UPDATE_USER_INFO_TYPE_NAME                 1
#define   ITREG_UPDATE_USER_INFO_TYPE_VNAME                2
#define   ITREG_UPDATE_USER_INFO_TYPE_PHONE                3
#define   ITREG_UPDATE_USER_INFO_TYPE_SEX                  4
#define   ITREG_UPDATE_USER_INFO_TYPE_BIRTHBAY             5
#define   ITREG_UPDATE_USER_INFO_TYPE_QQ                   6
#define   ITREG_UPDATE_USER_INFO_TYPE_CHARACTER_SIGNATURE  7
#define   ITREG_UPDATE_USER_INFO_TYPE_STREET               8
#define   ITREG_UPDATE_USER_INFO_TYPE_AREA                 9

#define   ITREG_UPDATE_USER_INFO_CFM          (SS_MSG+18)
#define   ITREG_UPDATE_USER_INFO_CFM_TYPE_RESULT   1


#define   ITREG_CALL_BACK_IND        (SS_MSG+19) //回呼，
#define   ITREG_CALL_BACK_IND_TYPE_CALLER       1
#define   ITREG_CALL_BACK_IND_TYPE_CALLED       2
#define   ITREG_CALL_BACK_IND_TYPE_CALL_MODE    3
#define   ITREG_CALL_BACK_IND_TYPE_RATE_MODE    4
#define   ITREG_CALL_BACK_IND_TYPE_USER         5
#define   ITREG_CALL_BACK_IND_TYPE_APP_HANDLE   6

#define   ITREG_CALL_BACK_STATUS     (SS_MSG+20) //回呼的状态通过这个回复
#define   ITREG_CALL_BACK_STATUS_TYPE_NUMBER     1 //号码
#define   ITREG_CALL_BACK_STATUS_TYPE_STATUS     2 //状态
#define   ITREG_CALL_BACK_STATUS_TYPE_APP_HANDLE 3


#define   ITREG_REGISTER                   (SS_MSG+21)
#define   ITREG_REGISTER_TYPE_PHONE       1
#define   ITREG_REGISTER_TYPE_PASSWORD    2
#define   ITREG_REGISTER_TYPE_CODE        3
#define   ITREG_REGISTER_TYPE_ID          4

#define   ITREG_REGISTER_CFM              (SS_MSG+22)
#define   ITREG_REGISTER_CFM_TYPE_RESULT   1
#define   ITREG_REGISTER_CFM_TYPE_IP       2
#define   ITREG_REGISTER_CFM_TYPE_PORT     3
#define   ITREG_REGISTER_CFM_TYPE_WOXIN_ID 4


#define   ITREG_UNREGISTER               (SS_MSG+23)
#define   ITREG_UNREGISTER_TYPE_NO       1
#define   ITREG_UNREGISTER_TYPE_REALM    2
#define   ITREG_UNREGISTER_TYPE_NONCE    3
#define   ITREG_UNREGISTER_TYPE_URI      4
#define   ITREG_UNREGISTER_TYPE_RESPONSE 5
#define   ITREG_UNREGISTER_TYPE_CNONCE   6
#define   ITREG_UNREGISTER_TYPE_NC       7
#define   ITREG_UNREGISTER_TYPE_QOP      8
#define   ITREG_UNREGISTER_TYPE_PHOND    9
#define   ITREG_UNREGISTER_TYPE_ID       10

#define   ITREG_UNREGISTER_CFM             (SS_MSG+24)
#define   ITREG_UNREGISTER_CFM_TYPE_RESULT   1

#define   ITREG_UPDATE_PASSWORD            (SS_MSG+25)
#define   ITREG_UPDATE_PASSWORD_TYPE_NO       1
#define   ITREG_UPDATE_PASSWORD_TYPE_REALM    2
#define   ITREG_UPDATE_PASSWORD_TYPE_NONCE    3
#define   ITREG_UPDATE_PASSWORD_TYPE_URI      4
#define   ITREG_UPDATE_PASSWORD_TYPE_RESPONSE 5
#define   ITREG_UPDATE_PASSWORD_TYPE_CNONCE   6
#define   ITREG_UPDATE_PASSWORD_TYPE_NC       7
#define   ITREG_UPDATE_PASSWORD_TYPE_QOP      8
#define   ITREG_UPDATE_PASSWORD_TYPE_NEW_PASSWORD  9

#define   ITREG_UPDATE_PASSWORD_CFM        (SS_MSG+26)
#define   ITREG_UPDATE_PASSWORD_CFM_TYPE_RESULT   1

#define   ITREG_FIND_PASSWORD_IND          (SS_MSG+27)
#define   ITREG_FIND_PASSWORD_IND_TYPE_SMS_PHONE  1
#define   ITREG_FIND_PASSWORD_IND_TYPE_PHONE      2

#define   ITREG_FIND_PASSWORD_CFM          (SS_MSG+28)
#define   ITREG_FIND_PASSWORD_CFM_TYPE_RESULT   1


#define   ITREG_UPDATE_LOGIN_STATE         (SS_MSG+29)
#define   ITREG_UPDATE_LOGIN_STATE_TYPE_NO     1
#define   ITREG_UPDATE_LOGIN_STATE_TYPE_STATUS 2

#define   ITREG_UPDATE_LOGIN_STATE_CFM     (SS_MSG+30)
#define   ITREG_UPDATE_LOGIN_STATE_CFM_TYPE_RESULT   1

#define   ITREG_FRIEND_LOGIN_STATE_CHANGE  (SS_MSG+31)

#define   ITREG_CUR_VERSION_IND            (SS_MSG+32)
#define   ITREG_CUR_VERSION_IND_TYPE_NO      1
#define   ITREG_CUR_VERSION_IND_TYPE_VERSION 2
#define   ITREG_CUR_VERSION_IND_TYPE_ID      3 //商家ID

#define   ITREG_CUR_VERSION_CFM            (SS_MSG+33)
#define   ITREG_CUR_VERSION_CFM_TYPE_RESULT  1
#define   ITREG_CUR_VERSION_CFM_TYPE_URL     2
#define   ITREG_CUR_VERSION_CFM_TYPE_ID      3
#define   ITREG_CUR_VERSION_CFM_TYPE_INFO    4
#define   ITREG_CUR_VERSION_CFM_TYPE_NEW_VER 5


#define   ITREG_REMOTE_LOGIN_IND   (SS_MSG+34) //异地登录
#define   ITREG_REMOTE_LOGIN_IND_TYPE_TYEP 1  //登录终端的类型


#define   ITREG_UPDATE_CPUID_IND           (SS_MSG+35)
#define   ITREG_UPDATE_CPUID_IND_TYPE_NO      1
#define   ITREG_UPDATE_CPUID_IND_TYPE_CPUID   2

#define   ITREG_UPDATE_CPUID_CFM           (SS_MSG+36)
#define   ITREG_UPDATE_CPUID_CFM_TYPE_RESULT  1

#define   ITREG_SYS_MSG                    (SS_MSG+37) //公司广播消息
#define   ITREG_SYS_MERCHANT_MSG           (SS_MSG+38) //公司广播消息,商家版本
#define   ITREG_SYS_ENTERPRISE_MSG         (SS_MSG+39) //公司广播消息,企业版本
#define   ITREG_SYS_PERSONAL_MSG           (SS_MSG+40) //公司广播消息,个人版本
#define   ITREG_WINDOW_SHOCK               (SS_MSG+41) //抖动窗口

#define   ITREG_GET_BALANCE_IND            (SS_MSG+42) //获得账户余额
#define   ITREG_GET_BALANCE_IND_TYPE_NO      1

#define   ITREG_GET_BALANCE_CFM            (SS_MSG+43) //
#define   ITREG_GET_BALANCE_CFM_TYPE_RESULT   1
#define   ITREG_GET_BALANCE_CFM_TYPE_BALANCE  2

#define   ITREG_GET_USER_INFO              (SS_MSG+44)//获得用户自己的信息
#define   ITREG_GET_USER_INFO_TYPE_NO      1

#define   ITREG_GET_USER_INFO_CFM          (SS_MSG+45)//
#define   ITREG_GET_USER_INFO_CFM_TYPE_RESULT        1
#define   ITREG_GET_USER_INFO_CFM_TYPE_ON_LINE_TIME  2
#define   ITREG_GET_USER_INFO_CFM_TYPE_CUR_STATE     3
#define   ITREG_GET_USER_INFO_CFM_TYPE_BALANCE       4
#define   ITREG_GET_USER_INFO_CFM_TYPE_AMOUNT        5
#define   ITREG_GET_USER_INFO_CFM_TYPE_INTEGRAL      6
#define   ITREG_GET_USER_INFO_CFM_TYPE_LEVEL         7
#define   ITREG_GET_USER_INFO_CFM_TYPE_ICON          8 //用户的大头像
#define   ITREG_GET_USER_INFO_CFM_TYPE_NAME                 9
#define   ITREG_GET_USER_INFO_CFM_TYPE_VNAME                10
#define   ITREG_GET_USER_INFO_CFM_TYPE_PHONE                11
#define   ITREG_GET_USER_INFO_CFM_TYPE_SEX                  12
#define   ITREG_GET_USER_INFO_CFM_TYPE_BIRTHBAY             13
#define   ITREG_GET_USER_INFO_CFM_TYPE_QQ                   14
#define   ITREG_GET_USER_INFO_CFM_TYPE_CHARACTER_SIGNATURE  15
#define   ITREG_GET_USER_INFO_CFM_TYPE_STREET               16
#define   ITREG_GET_USER_INFO_CFM_TYPE_AREA                 17


#define   ITREG_GET_PHONE_CHECK_CODE              (SS_MSG+46)//获得手机验证码
#define   ITREG_GET_PHONE_CHECK_CODE_TYPE_PHONE_NUMBER        1 //接收验证码的手机号码
#define   ITREG_GET_PHONE_CHECK_CODE_CFM          (SS_MSG+47)//
#define   ITREG_GET_PHONE_CHECK_CODE_CFM_TYPE_RESULT        1
#define   ITREG_GET_PHONE_CHECK_CODE_CFM_TYPE_CHECK_CODE    2

#define   ITREG_LOGIN                   (SS_MSG+48)
#define   ITREG_LOGIN_TYPE_NO       1
#define   ITREG_LOGIN_TYPE_REALM    2
#define   ITREG_LOGIN_TYPE_NONCE    3
#define   ITREG_LOGIN_TYPE_URI      4
#define   ITREG_LOGIN_TYPE_RESPONSE 5
#define   ITREG_LOGIN_TYPE_CNONCE   6
#define   ITREG_LOGIN_TYPE_NC       7
#define   ITREG_LOGIN_TYPE_QOP      8
#define   ITREG_LOGIN_TYPE_PHOND    9
#define   ITREG_LOGIN_TYPE_ID       10
#define   ITREG_LOGIN_TYPE_PHONE_MODEL 11
#define   ITREG_LOGIN_TYPE_PHONE_ID    12

#define   ITREG_LOGIN_CFM              (SS_MSG+49)
#define   ITREG_LOGIN_CFM_TYPE_RESULT  1
#define   ITREG_LOGIN_CFM_TYPE_IP      2
#define   ITREG_LOGIN_CFM_TYPE_PORT    3

#define   ITREG_LOGOUT               (SS_MSG+50)
#define   ITREG_LOGOUT_TYPE_NO       1
#define   ITREG_LOGOUT_TYPE_REALM    2
#define   ITREG_LOGOUT_TYPE_NONCE    3
#define   ITREG_LOGOUT_TYPE_URI      4
#define   ITREG_LOGOUT_TYPE_RESPONSE 5
#define   ITREG_LOGOUT_TYPE_CNONCE   6
#define   ITREG_LOGOUT_TYPE_NC       7
#define   ITREG_LOGOUT_TYPE_QOP      8
#define   ITREG_LOGOUT_TYPE_PHOND    9
#define   ITREG_LOGOUT_TYPE_ID       10

#define   ITREG_LOGOUT_CFM             (SS_MSG+51)
#define   ITREG_LOGOUT_CFM_TYPE_RESULT   1

#define   ITREG_UPLOAD_PHONE_INFO       (SS_MSG+52)
#define   ITREG_UPLOAD_PHONE_INFO_TYPE_SYS_TYPE      1
#define   ITREG_UPLOAD_PHONE_INFO_TYPE_PHONE_MODEL   2
#define   ITREG_UPLOAD_PHONE_INFO_TYPE_SYS_VERSION   3

#define   ITREG_UPLOAD_PHONE_INFO_CFM       (SS_MSG+53)
#define   ITREG_UPLOAD_PHONE_INFO_CFM_TYPE_RESULT     1

#define   ITREG_RECHARGE_IND              (SS_MSG+54)//充值
#define   ITREG_RECHARGE_IND_TYPE            1 //充值类型  1 我信  2 支付宝  3  移动  4 联通
#define   ITREG_RECHARGE_IND_TYPE_ACCOUNT    2 //帐号
#define   ITREG_RECHARGE_IND_TYPE_PASSWORD   3 //密码
#define   ITREG_RECHARGE_IND_TYPE_PRICE      4 //金额
#define   ITREG_RECHARGE_IND_TYPE_SELLER_ID  5 //商家ID

#define   ITREG_RECHARGE_CFM              (SS_MSG+55)//充值
#define   ITREG_RECHARGE_CFM_TYPE_RESULT       1
#define   ITREG_RECHARGE_CFM_TYPE_SELLER_ID    2 //商家ID
#define   ITREG_RECHARGE_CFM_TYPE_ORDER_ID     3
#define   ITREG_RECHARGE_CFM_TYPE_PHP_URL      4
#define   ITREG_RECHARGE_CFM_TYPE_WOXIN_RESULT 5

#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND     (SS_MSG+56)//充值优惠规则
#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND_TYPE_SELLER_ID  1 //商家ID

#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM     (SS_MSG+57)//充值优惠规则
#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_RESULT     1
#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_SELLER_ID  2 //商家ID
#define   ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_JSON       3

#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND     (SS_MSG+58)//更新绑定的手机号码
#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND_TYPE_PHONE      1
#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND_TYPE_SELLER_ID  2 //商家ID

#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM     (SS_MSG+59)//更新绑定的手机号码
#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM_TYPE_RESULT     1
#define   ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM_TYPE_SELLER_ID  2 //商家ID

#define   ITREG_GET_CREDIT_BALANCE_IND     (SS_MSG+60)//获得话费余额
#define   ITREG_GET_CREDIT_BALANCE_IND_TYPE_SELLER_ID  1 //商家ID

#define   ITREG_GET_CREDIT_BALANCE_CFM     (SS_MSG+61)//获得话费余额
#define   ITREG_GET_CREDIT_BALANCE_CFM_TYPE_RESULT     1
#define   ITREG_GET_CREDIT_BALANCE_CFM_TYPE_PRICE      2 //金额
#define   ITREG_GET_CREDIT_BALANCE_CFM_TYPE_MINUTES    3 //分钟数
#define   ITREG_GET_CREDIT_BALANCE_CFM_TYPE_SELLER_ID  4 //商家ID


#define   ITREG_CALL_BACK_HOOK_IND        (SS_MSG+62) //回呼挂断
#define   ITREG_CALL_BACK_HOOK_IND_TYPE_WO_XIN_ID  1
#define   ITREG_CALL_BACK_HOOK_IND_TYPE_CALLER     2
#define   ITREG_CALL_BACK_HOOK_IND_TYPE_CALLED     3

#define   ITREG_CALL_BACK_HOOK_CFM        (SS_MSG+63) //回呼挂断
#define   ITREG_CALL_BACK_HOOK_CFM_TYPE_RESULT     1
#define   ITREG_CALL_BACK_HOOK_CFM_TYPE_CALLER     2
#define   ITREG_CALL_BACK_HOOK_CFM_TYPE_CALLED     3

#define   ITREG_CALL_BACK_CDR_IND        (SS_MSG+64) //回呼话单
#define   ITREG_CALL_BACK_CDR_IND_TYPE_RID        1  //服务器记录ID
#define   ITREG_CALL_BACK_CDR_IND_TYPE_PHONE      2  //被叫或主叫号码
#define   ITREG_CALL_BACK_CDR_IND_TYPE_RESULT     3  //这通电话的结果
#define   ITREG_CALL_BACK_CDR_IND_TYPE_TIME       4  //通话开始的时间
#define   ITREG_CALL_BACK_CDR_IND_TYPE_TALK_TIME  5  //通话时长 单位  秒

#define   ITREG_CALL_BACK_CDR_CFM        (SS_MSG+65) //回呼话单
#define   ITREG_CALL_BACK_CDR_CFM_TYPE_RESULT     1
#define   ITREG_CALL_BACK_CDR_CFM_TYPE_RID        2  //服务器记录ID

#define   ITREG_SELECT_PHONE_CHECK_CODE_IND        (SS_MSG+66) //查询注册验证码
#define   ITREG_SELECT_PHONE_CHECK_CODE_IND_TYPE_PHONE        1

#define   ITREG_SELECT_PHONE_CHECK_CODE_CFM        (SS_MSG+67) //查询注册验证码
#define   ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_RESULT      1
#define   ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_PHONE       2
#define   ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_CODE        3


//////////////////////////////////////////////////////////////////////////
#define   ITREG_IM_UPLINK_IND              (SS_MSG+201) //上行
#define   ITREG_IM_UPLINK_IND_TYPE_USER              1
#define   ITREG_IM_UPLINK_IND_TYPE_FRIEND            2
#define   ITREG_IM_UPLINK_IND_TYPE_CONTENT           3
#define   ITREG_IM_UPLINK_IND_TYPE_DIRECTION         4
#define   ITREG_IM_UPLINK_IND_TYPE_LANGUAGE          5
#define   ITREG_IM_UPLINK_IND_TYPE_FONT_CODEC        6
#define   ITREG_IM_UPLINK_IND_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_UPLINK_IND_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_UPLINK_IND_TYPE_FONT_SPECIALTIES  9 //字体的特效

#define   ITREG_IM_UPLINK_CFM              (SS_MSG+202) //
#define   ITREG_IM_UPLINK_CFM_TYPE_RESULT            1

#define   ITREG_IM_DOWNLINK_IND            (SS_MSG+203) //下行
#define   ITREG_IM_DOWNLINK_IND_TYPE_USER              1
#define   ITREG_IM_DOWNLINK_IND_TYPE_CONTENT           3
#define   ITREG_IM_DOWNLINK_IND_TYPE_DIRECTION         4
#define   ITREG_IM_DOWNLINK_IND_TYPE_LANGUAGE          5
#define   ITREG_IM_DOWNLINK_IND_TYPE_FONT_CODEC        6
#define   ITREG_IM_DOWNLINK_IND_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_DOWNLINK_IND_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_DOWNLINK_IND_TYPE_FONT_SPECIALTIES  9 //字体的特效

#define   ITREG_IM_DOWNLINK_CFM            (SS_MSG+204) //
#define   ITREG_IM_DOWNLINK_CFM_TYPE_RESULT            1

#define   ITREG_IM_GET_NEW_IND             (SS_MSG+205) //新消息
#define   ITREG_IM_GET_NEW_IND_TYPE_NO       1   //用户
#define   ITREG_IM_GET_NEW_IND_TYPE_CUR_RID  2   //从这个记录ID开始

#define   ITREG_IM_GET_NEW_CFM             (SS_MSG+206) //
#define   ITREG_IM_GET_NEW_CFM_TYPE_RESULT            1
#define   ITREG_IM_GET_NEW_CFM_TYPE_USER              2
#define   ITREG_IM_GET_NEW_CFM_TYPE_CONTENT           3
#define   ITREG_IM_GET_NEW_CFM_TYPE_DIRECTION         4
#define   ITREG_IM_GET_NEW_CFM_TYPE_LANGUAGE          5
#define   ITREG_IM_GET_NEW_CFM_TYPE_FONT_CODEC        6
#define   ITREG_IM_GET_NEW_CFM_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_GET_NEW_CFM_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_GET_NEW_CFM_TYPE_FONT_SPECIALTIES  9 //字体的特效


#define   ITREG_IM_SYNCHRONOUS_IND         (SS_MSG+207) //同步消息
#define   ITREG_IM_SYNCHRONOUS_IND_TYPE_NO        1
#define   ITREG_IM_SYNCHRONOUS_IND_TYPE_DATE_TIME 2 //从那一天开始同步

#define   ITREG_IM_SYNCHRONOUS_CFM         (SS_MSG+208) //
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_RESULT            1
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_USER              2
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_CONTENT           3
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_DIRECTION         4
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_LANGUAGE          5
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_FONT_CODEC        6
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_SYNCHRONOUS_CFM_TYPE_FONT_SPECIALTIES  9 //字体的特效


#define   ITREG_IM_GROUP_UPLINK_IND        (SS_MSG+221) //上行
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_GROUP_ID          1
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_USER              2 //发送消息方
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_MEMBER            3 //接收消息方，也就是群成员
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_MEMBER_COUNT      4 //多少个成员
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_CONTENT           5
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_LANGUAGE          6
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_CODEC        7
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_STYLE        8 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_COLOR        9 //字体的颜色
#define   ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_SPECIALTIES  10 //字体的特效

#define   ITREG_IM_GROUP_UPLINK_CFM        (SS_MSG+222) //
#define   ITREG_IM_GROUP_UPLINK_CFM_TYPE_RESULT  1

#define   ITREG_IM_GROUP_DOWNLINK_IND      (SS_MSG+223) //下行
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_GROUP_ID          1
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_USER              2 //发送消息方
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_CONTENT           3
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_LANGUAGE          4
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_FONT_CODEC        5
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_FONT_STYLE        6 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_FONT_COLOR        7 //字体的颜色
#define   ITREG_IM_GROUP_DOWNLINK_IND_TYPE_FONT_SPECIALTIES  8 //字体的特效

#define   ITREG_IM_GROUP_DOWNLINK_CFM      (SS_MSG+224) //
#define   ITREG_IM_GROUP_DOWNLINK_CFM_TYPE_RESULT  1

#define   ITREG_IM_GROUP_GET_NEW_IND       (SS_MSG+225) //新消息
#define   ITREG_IM_GROUP_GET_NEW_IND_TYPE_NO        1 //用户
#define   ITREG_IM_GROUP_GET_NEW_IND_TYPE_GROUP_ID  2 //组ID
#define   ITREG_IM_GROUP_GET_NEW_IND_TYPE_CUR_RID   3 //从这个记录ID开始

#define   ITREG_IM_GROUP_GET_NEW_CFM       (SS_MSG+226) //
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_RESULT            1
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_GROUP_ID          2
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_USER              3
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_CONTENT           4
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_LANGUAGE          5
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_FONT_CODEC        6
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_GROUP_GET_NEW_CFM_TYPE_FONT_SPECIALTIES  9 //字体的特效

#define   ITREG_IM_GROUP_SYNCHRONOUS_IND   (SS_MSG+227) //同步消息
#define   ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_NO        1 //用户
#define   ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_GROUP_ID  2 //组ID
#define   ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_DATE_TIME 3 //从那一天开始同步

#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM   (SS_MSG+228) //
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_RESULT            1
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_GROUP_ID          2
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_USER              3
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_CONTENT           4
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_LANGUAGE          5
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_FONT_CODEC        6
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_FONT_STYLE        7 //字体的样式，比如：正方，斜体。。。。
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_FONT_COLOR        8 //字体的颜色
#define   ITREG_IM_GROUP_SYNCHRONOUS_CFM_TYPE_FONT_SPECIALTIES  9 //字体的特效

//////////////////////////////////////////////////////////////////////////

#define   ITREG_BOOK_USER_ADD                         (SS_MSG+301)
#define   ITREG_BOOK_USER_ADD_TYPE_RECORD_ID     1
#define   ITREG_BOOK_USER_ADD_TYPE_NAME          2
#define   ITREG_BOOK_USER_ADD_TYPE_PHONE         3
#define   ITREG_BOOK_USER_ADD_TYPE_CREATE_TIME   4
#define   ITREG_BOOK_USER_ADD_TYPE_MODIFY_TIME   5
#define   ITREG_BOOK_USER_ADD_TYPE_RID           6

#define   ITREG_BOOK_USER_ADD_CFM                     (SS_MSG+302)
#define   ITREG_BOOK_USER_ADD_CFM_TYPE_RESULT    1
#define   ITREG_BOOK_USER_ADD_CFM_TYPE_RID       2

#define   ITREG_BOOK_USER_DELETE                      (SS_MSG+303)
#define   ITREG_BOOK_USER_DELETE_TYPE_RID           1

#define   ITREG_BOOK_USER_DELETE_CFM                  (SS_MSG+304)
#define   ITREG_BOOK_USER_DELETE_CFM_TYPE_RESULT    1
#define   ITREG_BOOK_USER_DELETE_CFM_TYPE_RID       2

#define   ITREG_BOOK_USER_UPDATE                      (SS_MSG+305)
#define   ITREG_BOOK_USER_UPDATE_CFM                  (SS_MSG+306)
#define   ITREG_BOOK_SYNCHRONOUS_IND                  (SS_MSG+307)      //同步通讯录信息
#define   ITREG_BOOK_SYNCHRONOUS_CFM                  (SS_MSG+308)      //
#define   ITREG_BOOK_IM_GROUP_ADD                     (SS_MSG+309)
#define   ITREG_BOOK_IM_GROUP_ADD_CFM                 (SS_MSG+310)
#define   ITREG_BOOK_IM_GROUP_DELETE                  (SS_MSG+311)
#define   ITREG_BOOK_IM_GROUP_DELETE_CFM              (SS_MSG+312)
#define   ITREG_BOOK_IM_GROUP_UPDATE                  (SS_MSG+313)
#define   ITREG_BOOK_IM_GROUP_UPDATE_CFM              (SS_MSG+314)
#define   ITREG_BOOK_IM_GROUP_MEMBER_ADD              (SS_MSG+315)
#define   ITREG_BOOK_IM_GROUP_MEMBER_ADD_CFM          (SS_MSG+316)
#define   ITREG_BOOK_IM_GROUP_MEMBER_DELETE           (SS_MSG+317)
#define   ITREG_BOOK_IM_GROUP_MEMBER_DELETE_CFM       (SS_MSG+318)
#define   ITREG_BOOK_IM_GROUP_MEMBER_UPDATE           (SS_MSG+319)
#define   ITREG_BOOK_IM_GROUP_MEMBER_UPDATE_CFM       (SS_MSG+320)
#define   ITREG_BOOK_IM_GROUP_SYNCHRONOUS_IND         (SS_MSG+321)      //同步通讯录聊天群信息
#define   ITREG_BOOK_IM_GROUP_SYNCHRONOUS_CFM         (SS_MSG+322)      //
#define   ITREG_BOOK_IM_GROUP_MEMBER_SYNCHRONOUS_IND  (SS_MSG+323)      //同步通讯录聊天群成员信息
#define   ITREG_BOOK_IM_GROUP_MEMBER_SYNCHRONOUS_CFM  (SS_MSG+324)      //
#define   ITREG_BOOK_IM_GROUP_UPDATE_CALL_BOARD       (SS_MSG+325)
#define   ITREG_BOOK_IM_GROUP_UPDATE_CALL_BOARD_CFM   (SS_MSG+326)
#define   ITREG_BOOK_IM_GROUP_ADD_MEMBER_IND          (SS_MSG+327) //添加成员
#define   ITREG_BOOK_IM_GROUP_DELETE_MEMBER_IND       (SS_MSG+328) //删除成员
#define   ITREG_BOOK_IM_GROUP_DELETE_MEMBER_ALL_IND   (SS_MSG+329) //删除成员
#define   ITREG_BOOK_IM_GROUP_ADD_IND                 (SS_MSG+330) //添加群
#define   ITREG_BOOK_IM_GROUP_DELETE_IND              (SS_MSG+331) //删除群
#define   ITREG_BOOK_IM_GROUP_NAME_UPDATE             (SS_MSG+332) //修改群名称
#define   ITREG_BOOK_IM_GROUP_CALL_BOARD_UPDATE       (SS_MSG+333) //修改公告内容
#define   ITREG_BOOK_IM_GROUP_MEMBER_EXIT_IND         (SS_MSG+334) //退出这个群
#define   ITREG_BOOK_IM_GROUP_UPDATE_MEMBER_NAME      (SS_MSG+335) //修改成员姓名
#define   ITREG_BOOK_IM_GROUP_UPDATE_MEMBER_CAPA_IND  (SS_MSG+336) //转让创建者身份

#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME          (SS_MSG+337)
#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME_TYPE_RID          1
#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME_TYPE_REMARK_NAME  2

#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM      (SS_MSG+338)
#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM_TYPE_RESULT    1
#define   ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM_TYPE_RID       2

#define   ITREG_BOOK_USER_UPLOAD_MY_ICON              (SS_MSG+339)
#define   ITREG_BOOK_USER_UPLOAD_MY_ICON_TYPE_IOCN    1

#define   ITREG_BOOK_USER_UPLOAD_MY_ICON_CFM          (SS_MSG+340)
#define   ITREG_BOOK_USER_UPLOAD_MY_ICON_CFM_TYPE_RESULT    1


#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND       (SS_MSG+341)
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_IOCN       1
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_RID        2
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_WO_XIN_ID  3

#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM       (SS_MSG+342)
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_RESULT     1
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_RID        2
#define   ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_WO_XIN_ID  3


#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND   (SS_MSG+343)
#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND_TYPE_RID        1
#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND_TYPE_WO_XIN_ID  2

#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM   (SS_MSG+344)
#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_RESULT     1
#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_RID        2
#define   ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_WO_XIN_ID  3

#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND         (SS_MSG+345)
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_RID        1
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_WO_XIN_ID  2
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_NAME       3

#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM         (SS_MSG+346)
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_RESULT     1
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_RID        2
#define   ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_WO_XIN_ID  3





#define   ITREG_FILE_OFF_LINE_UP_IND             (SS_MSG+401) //用户上传离线文件 默认 30 MB
#define   ITREG_FILE_OFF_LINE_UP_CFM             (SS_MSG+402) //
#define   ITREG_FILE_OFF_LINE_DOWN_IND           (SS_MSG+403) //用户下载离线文件
#define   ITREG_FILE_OFF_LINE_DOWN_CFM           (SS_MSG+404) //
#define   ITREG_FILE_OFF_LINE_GET_IND            (SS_MSG+405) //用户查找离线文件
#define   ITREG_FILE_OFF_LINE_GET_CFM            (SS_MSG+406) //
#define   ITREG_FILE_OFF_LINE_DELETE_IND         (SS_MSG+407) //用户删除离线文件
#define   ITREG_FILE_OFF_LINE_DELETE_CFM         (SS_MSG+408) //

#define   ITREG_FILE_ON_LINE_SEND_IND            (SS_MSG+421) //
#define   ITREG_FILE_ON_LINE_SEND_CFM            (SS_MSG+422) //
#define   ITREG_FILE_ON_LINE_RECV_IND            (SS_MSG+423) //
#define   ITREG_FILE_ON_LINE_RECV_CFM            (SS_MSG+424) //
#define   ITREG_FILE_ON_LINE_CANCEL_SEND_IND     (SS_MSG+425) //
#define   ITREG_FILE_ON_LINE_CANCEL_SEND_CFM     (SS_MSG+426) //
#define   ITREG_FILE_ON_LINE_CANCEL_RECV_IND     (SS_MSG+427) //
#define   ITREG_FILE_ON_LINE_CANCEL_RECV_CFM     (SS_MSG+428) //
#define   ITREG_FILE_ON_LINE_RECV_RESULT         (SS_MSG+429) //

#define   ITREG_FILE_IM_GROUP_UP_IND             (SS_MSG+441) //群上传永久文件 默认 30 MB
#define   ITREG_FILE_IM_GROUP_UP_CFM             (SS_MSG+442) //
#define   ITREG_FILE_IM_GROUP_DOWN_IND           (SS_MSG+443) //群下载永久文件
#define   ITREG_FILE_IM_GROUP_DOWN_CFM           (SS_MSG+444) //
#define   ITREG_FILE_IM_GROUP_DELETE_IND         (SS_MSG+445) //群下载永久文件
#define   ITREG_FILE_IM_GROUP_DELETE_CFM         (SS_MSG+446) //
#define   ITREG_FILE_IM_GROUP_GET_IND            (SS_MSG+447) //群查找永久文件
#define   ITREG_FILE_IM_GROUP_GET_CFM            (SS_MSG+448) //

#define   ITREG_SMS_NORMAL_SEND_IND              (SS_MSG+501) //文字短信一条
#define   ITREG_SMS_NORMAL_SEND_CFM              (SS_MSG+502) //
#define   ITREG_SMS_NORMAL_GROUP_SEND_IND        (SS_MSG+503) //文字短信多条
#define   ITREG_SMS_NORMAL_GROUP_SEND_CFM        (SS_MSG+504) //
#define   ITREG_SMS_NORMAL_GET_RESULT_IND        (SS_MSG+505) //获得短信发送结果
#define   ITREG_SMS_NORMAL_GET_RESULT_CFM        (SS_MSG+506) //
#define   ITREG_SMS_BRTCH_SEND_IND               (SS_MSG+507) //文字短信批量发送
#define   ITREG_SMS_BRTCH_SEND_CFM               (SS_MSG+508) //
#define   ITREG_SMS_BRTCH_GET_RESULT_IND         (SS_MSG+509) //获得短信批量发送结果
#define   ITREG_SMS_BRTCH_GET_RESULT_CFM         (SS_MSG+510) //



//下面的消息不在使用
/*
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_COMMAND              1  //命令，MKS向MS发命令
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_REG_NEW_ACCOUNT      2  //申请新账号
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_QUERY                3  //查询
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_REGISTER             4  //注册
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_REPORT               5  //报告状态和能力
#define   JL_TO_JL_REG_SERVER_SESSION_TYPE_COMM                 6  //初始化通信连接、建立连接等


#define   JL_TO_JL_REG_SERVER_COMMAND_GW_CONNECT_JL                       (SS_MSG+1 )
#define   JL_TO_JL_REG_SERVER_COMMAND_GW_CONNECT_JL_CFM                   (SS_MSG+2 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CONNECT_GW                       (SS_MSG+3 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CONNECT_GW_CFM                   (SS_MSG+4 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CONNECT_JL                       (SS_MSG+5 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CONNECT_JL_CFM                   (SS_MSG+6 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CAPABILITY_CHANGE                (SS_MSG+7 )
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_CAPABILITY_CHANGE_CFM            (SS_MSG+8 )
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_CAPABILITY                (SS_MSG+9 )
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_CAPABILITY_CFM            (SS_MSG+10)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_IM_ALL_Message            (SS_MSG+11)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_IM_ALL_Message_CFM        (SS_MSG+12)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_IM_Message                (SS_MSG+13)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_IM_Message_CFM            (SS_MSG+14)
#define   JL_TO_JL_REG_SERVER_COMMAND_UPDATE_JL_PASSWORD_TIME_OUT         (SS_MSG+15)
#define   JL_TO_JL_REG_SERVER_COMMAND_UPDATE_JL_PASSWORD_TIME_OUT_CFM     (SS_MSG+16)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_STUN                     (SS_MSG+17)  //请求穿透服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_STUN_CFM                 (SS_MSG+18)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_IM                       (SS_MSG+19)  //请求即时消息服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_IM_CFM                   (SS_MSG+20)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_CALL                     (SS_MSG+21)  //请求呼叫服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_CALL_CFM                 (SS_MSG+22)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_MEETING                  (SS_MSG+23)  //请求会议服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_MEETING_CFM              (SS_MSG+24)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_FILES                    (SS_MSG+25)  //请求文件传输中转服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_FILES_CFM                (SS_MSG+26)
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_UPGRADE                  (SS_MSG+27)  //请求升级服务器支持
#define   JL_TO_JL_REG_SERVER_COMMAND_JL_REQUEST_UPGRADE_CFM              (SS_MSG+28)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_PROXY_Addr                (SS_MSG+29)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_PROXY_Addr_CFM            (SS_MSG+30)
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_JL_TO_GW_Addr             (SS_MSG+31) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_JL_TO_GW_Addr_CFM         (SS_MSG+32) //请求确认
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_JL_TO_JL_Addr             (SS_MSG+33) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_JL_TO_JL_Addr_CFM         (SS_MSG+34) //请求确认
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_Internet_PROXY_Addr       (SS_MSG+35) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_Internet_PROXY_Addr_CFM   (SS_MSG+36) //请求确认
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_XManage_Addr              (SS_MSG+37) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_XManage_Addr_CFM          (SS_MSG+38) //请求确认
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_Telnet_Addr               (SS_MSG+39) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_COMMAND_REPORT_JL_Telnet_Addr_CFM           (SS_MSG+40) //请求确认


#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_IND                      (SS_MSG+1)  
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_IND_CFM                  (SS_MSG+2)  
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_UPDATE_PASSWORD          (SS_MSG+3)  
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_UPDATE_PASSWORD_CFM      (SS_MSG+4)  
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_UPDATE_PASSWORD_KEY      (SS_MSG+5)
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_UPDATE_PASSWORD_KEY_CFM  (SS_MSG+6) 
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_FORGOT_PASSWORD          (SS_MSG+7)
#define   JL_TO_JL_REG_SERVER_REG_NEW_ACCOUNT_JL_FORGOT_PASSWORD_CFM      (SS_MSG+8)

#define   JL_TO_JL_REG_SERVER_QUERY_GW_CAPABILITY                (SS_MSG+1 )
#define   JL_TO_JL_REG_SERVER_QUERY_GW_CAPABILITY_CFM            (SS_MSG+2 )
#define   JL_TO_JL_REG_SERVER_QUERY_JL_CAPABILITY                (SS_MSG+3 )
#define   JL_TO_JL_REG_SERVER_QUERY_JL_CAPABILITY_CFM            (SS_MSG+4 )
#define   JL_TO_JL_REG_SERVER_QUERY_GW_GW_TO_JL_Addr             (SS_MSG+7 ) //查询GW 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_QUERY_GW_GW_TO_JL_Addr_CFM         (SS_MSG+8 ) //请求确认
#define   JL_TO_JL_REG_SERVER_QUERY_JL_JL_TO_JL_Addr             (SS_MSG+9 ) //查询JL 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_QUERY_JL_JL_TO_JL_Addr_CFM         (SS_MSG+10) //请求确认
#define   JL_TO_JL_REG_SERVER_QUERY_JL_JL_TO_GW_Addr             (SS_MSG+11) //查询JL 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_QUERY_JL_JL_TO_GW_Addr_CFM         (SS_MSG+12) //请求确认
#define   JL_TO_JL_REG_SERVER_QUERY_GW_PROXY_Addr                (SS_MSG+13) //查询GW 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_QUERY_GW_PROXY_Addr_CFM            (SS_MSG+14) //请求确认
#define   JL_TO_JL_REG_SERVER_QUERY_JL_PROXY_Addr                (SS_MSG+15) //查询JL 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_QUERY_JL_PROXY_Addr_CFM            (SS_MSG+16) //请求确认

#define   JL_TO_JL_REG_SERVER_REGISTER_JL_REG                             (SS_MSG+1)
#define   JL_TO_JL_REG_SERVER_REGISTER_JL_REG_CFM                         (SS_MSG+2)
#define   JL_TO_JL_REG_SERVER_REGISTER_JL_UNREG                           (SS_MSG+3)
#define   JL_TO_JL_REG_SERVER_REGISTER_JL_UNREG_CFM                       (SS_MSG+4)
#define   JL_TO_JL_REG_SERVER_REGISTER_HEART_BEAT                         (SS_MSG+5)
#define   JL_TO_JL_REG_SERVER_REGISTER_HEART_BEAT_CFM                     (SS_MSG+6)
                                                                                
#define   JL_TO_JL_REG_SERVER_REPORT_JL_CAPABILITY                     (SS_MSG+1 )
#define   JL_TO_JL_REG_SERVER_REPORT_JL_CAPABILITY_CFM                 (SS_MSG+2 )
#define   JL_TO_JL_REG_SERVER_REPORT_JL_JL_TO_GW_Addr                  (SS_MSG+3 )//报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_REPORT_JL_JL_TO_GW_Addr_CFM              (SS_MSG+4 )//请求确认
#define   JL_TO_JL_REG_SERVER_REPORT_JL_JL_TO_JL_Addr                  (SS_MSG+5 )//报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_REPORT_JL_JL_TO_JL_Addr_CFM              (SS_MSG+6 )//请求确认
#define   JL_TO_JL_REG_SERVER_REPORT_JL_Internet_PROXY_Addr            (SS_MSG+7 )//报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_REPORT_JL_Internet_PROXY_Addr_CFM        (SS_MSG+8 )//请求确认
#define   JL_TO_JL_REG_SERVER_REPORT_JL_XManage_Addr                   (SS_MSG+9 )//报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_REPORT_JL_XManage_Addr_CFM               (SS_MSG+10) //请求确认
#define   JL_TO_JL_REG_SERVER_REPORT_JL_Telnet_Addr                    (SS_MSG+11) //报告 侦听地址的请求
#define   JL_TO_JL_REG_SERVER_REPORT_JL_Telnet_Addr_CFM                (SS_MSG+12) //请求确认
#define   JL_TO_JL_REG_SERVER_REPORT_JL_PROXY_Addr                     (SS_MSG+13)
#define   JL_TO_JL_REG_SERVER_REPORT_JL_PROXY_Addr_CFM                 (SS_MSG+14)

                                                                                
#define   JL_TO_JL_REG_SERVER_COMM_GW_CONNECT_JL                          (SS_MSG+1 )
#define   JL_TO_JL_REG_SERVER_COMM_GW_CONNECT_JL_CFM                      (SS_MSG+2 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_CONNECT_GW                          (SS_MSG+3 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_CONNECT_GW_CFM                      (SS_MSG+4 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_CONNECT_JL                          (SS_MSG+5 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_CONNECT_JL_CFM                      (SS_MSG+6 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_STUN                        (SS_MSG+7 ) //请求穿透服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_STUN_CFM                    (SS_MSG+8 )
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_IM                          (SS_MSG+9 )//请求即时消息服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_IM_CFM                      (SS_MSG+10)
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_CALL                        (SS_MSG+11) //请求呼叫服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_CALL_CFM                    (SS_MSG+12)
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_MEETING                     (SS_MSG+13) //请求会议服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_MEETING_CFM                 (SS_MSG+14)
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_FILES                       (SS_MSG+15) //请求文件传输中转服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_FILES_CFM                   (SS_MSG+16)
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_UPGRADE                     (SS_MSG+17) //请求升级服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_UPGRADE_CFM                 (SS_MSG+18)
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_PROXY                       (SS_MSG+19) //请求代理服务器支持
#define   JL_TO_JL_REG_SERVER_COMM_JL_REQUEST_PROXY_CFM                   (SS_MSG+20)

*/


#endif //__IT_LIB_MACRO_DEF_H__


