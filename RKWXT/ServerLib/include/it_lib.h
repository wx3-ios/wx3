// it_lib.h : main header file for the IT_LIB DLL
//

#if !defined(AFX_IT_LIB_H__B1343414_E238_4806_B5AB_EE30B97B6086__INCLUDED_)
#define AFX_IT_LIB_H__B1343414_E238_4806_B5AB_EE30B97B6086__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// version : 0.0.0.90

typedef unsigned char        SS_BOOL,*PSS_BOOL;
typedef char                 SS_CHAR,*PSS_CHAR;
typedef unsigned char        SS_BYTE,*PSS_BYTE;
typedef signed short         SS_SHORT,*PSS_SHORT;
typedef unsigned short       SS_USHORT,*PSS_USHORT;
typedef signed char          SS_INT8,*PSS_INT8;
typedef unsigned char        SS_UINT8,*PSS_UINT8;
typedef signed short         SS_INT16,*PSS_INT16;
typedef unsigned short       SS_UINT16,*PSS_UINT16;
typedef signed int           SS_INT32,*PSS_INT32;
typedef unsigned int         SS_UINT32,*PSS_UINT32;
typedef float                SS_FLOAT,*PSS_FLOAT;
typedef double               SS_DOUBLE,*PSS_DOUBLE;
typedef void                 SS_VOID,*PSS_VOID;


#ifndef IN
#define IN
#endif

#ifndef OUT
#define OUT
#endif

#ifndef IT_API
#define IT_API
#endif

#ifndef SS_FALSE
#define SS_FALSE 0
#endif

#ifndef SS_TRUE
#define SS_TRUE 1 
#endif


#define   SS_SUCCESS       0    //成功
#define   SS_FAILURE       1    //未知的原因
#define   SS_ERR_PARAM     2    //参数错误
#define   SS_ERR_MEMORY    3    //内存分配出错
#define   SS_ERR_STATE     4    //状态错误
#define   SS_ERR_ACTION    5    //执行错误
#define   SS_ERR_PARSE     6    //解析错误
#define   SS_ERR_TIME_OUT  7    //超时
#define   SS_ERR_NETWORK_IDLE        8  //网络连接一直都没有建立
#define   SS_ERR_NETWORK_DISCONNECT  9  //网络连接断开
#define   SS_ERR_NOTFOUND  10
#define   SS_ERR_NO_INIT_DB 11  //调用这个函数前没有初始化数据库
#define   SS_ERR_CALL       12  //通话中，或通话还没有结束
#define   SS_ERR_NOT_LOGIN  13  //没有登录，至少登录成功一次才能调用这个API


/*
建议启动方式
IT_InitConfig
IT_UpdateDBPath
IT_SetIconPath

//IT_LogScreenDisplay

IT_Init
IT_SetPCMCallBack
IT_SetCallBack

IT_ConnectDB();
IT_SetWoXinID("102669");
IT_SetSellerID(10021);
IT_SetServerIP("121.37.63.179");

IT_Start()

*/

typedef SS_SHORT (*ITLib_CallBack)(
    IN SS_UINT32 const un32MSGID,
    IN SS_CHAR **pParam,
    IN SS_UINT32 const un32ParamNumber);


typedef SS_VOID (* IT_WaveRecordData)(
    SS_CHAR  const*pBuffer,
    SS_INT32 const n32Len,
    SS_VOID  *pContext);


#define   IT_MSG_CALL_BACK_CDR_IND     135
//Param[0] = RID        记录的唯一ID
//Param[1] = Phone      号码，主叫或被叫
//Param[2] = Result     1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 7 回拨  8 回拨主叫拒接 9 回拨被叫忙/被叫拒接
//Param[3] = un32Time   通话开始的时间 
//Param[4] = TalkTime   //单位  秒

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


//在异地登录成功，当前被迫下线
#define   IT_MSG_REMOTE_LOGIN_IND           191
//Param[0] = type //登录终端的类型,扩展用

//设置注册服务器的IP或域名，调用IT_SetServerIP()API来设置。
#define   IT_MSG_SET_REG_SERVER_IP_OR_DOMAIN 198

//更新数据通知消息
#define   IT_MSG_UPDATE_DB_IND  201
//Param[0] = path //  库的路径


#ifdef __cplusplus
extern "C" 
{
#endif
/*************************************************
Function:    IT_GetOrderRefundInfoIND()
Description: 获得订单退款信息接口
Input:       un32ShopID 分店ID
Input:       pOrderCode 订单号
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_ORDER_REFUND_INFO_CFM      207
			 Param[0] = Result  //0 成功 其他 失败
			 Param[1] = SellerID    商家ID
			 Param[2] = ShopID      分店ID
			 Param[3] = OrderCode    订单号
			 Param[4] = json 串
			 {
			 "order_refund_id":22, //退款表ID
			 "pay_type":0, //该订单的支付方式  1未支付宝  2银联
			 "refund_remark":"abccc", //退款理由
			 "refund_time":1418803525, //用户申请退款的时间
			 "operator_refund_user":429556859142144, //操作退款的woxinID  如果是我信小二 则值为1
			 "user_id":429556859142144, //该订单所属的woxinID
			 "agreed_refund":0,//商家是否同意退款  0 初始状态商家不操作  1 同意退款  2 不同意退款
			 "disagree_refund_remark":"", //商家不同意(同意)退款的理由
			 "agreed_refund_time":0, //同意(不同意)退款的时间
			 "operator_seller_user":0, //操作的后台登陆ID
			 "refund_result_info":"",  //退款的原始信息
			 "union_refund_order_time":"0", //银联退款会生成新的订单时间   用于查询退款状态
			 "union_refund_order_number":"",//银联退款会生成新的订单号     用于查询退款状态
			 "union_refund_qn":"", //银联退款成功后的流水号 此字段暂时无用
			 "refund_money":0.00, //本次申请退款的金额
			 "success_refund_money":0.00, //本次成功退款的金额
			 "alipay_batch_no":"", //支付宝退款的批次号 申请时就写入数据库，通知时好判断
			 "refund_close":0, //本次退款是否关闭 0.未关闭 1已关闭
			 "refund_success_time":0, //退款成功(失败)的时间
			 "refund_status":0 //本次的退款的状态  1退款成功  2退款失败
			 }
*************************************************/
IT_API SS_SHORT IT_GetOrderRefundInfoIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_SendPayResultIND()
Description: 发送支付结果到服务器
Input:       un32ShopID 分店ID
Input:       pOrderCode 订单号
Input:       ubPayType  支付类型 0原始值 1 支付宝  2  银联
Input:       Result     支付结果 0原始值 1成功 2失败
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_SEND_PAY_RESULT_CFM  206
			 Param[0] = Result  //0  成功 其他 失败
			 Param[1] = SellerID     商家ID
			 Param[2] = ShopID       分店ID
			 Param[3] = OrderCode    订单号
*************************************************/
IT_API SS_SHORT IT_SendPayResultIND(
	IN SS_UINT32 const  un32ShopID,
	IN SS_CHAR   const *pOrderCode,
	IN SS_BYTE   const  ubPayType,
	IN SS_BYTE   const  ubResult);
/*************************************************
Function:    IT_MallOrderRemindersIND()
Description: 订单催单接口
Input:       un32ShopID  分店ID
Input:       pOrderCode  订单号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_ORDER_REMINDERS_CFM      205
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = order_code  订单号
*************************************************/
IT_API SS_SHORT IT_MallOrderRemindersIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_MallLoadOrderSingleIND()
Description: 加载单条订单
Input:       un32ShopID  分店ID
Input:       pOrderCode  订单号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_ORDER_SINGLE_CFM      204
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
			 Param[3] = order_code  订单号
             Param[4] = json 串
             {"order_id":"201394392749",
             "price":40.00,
             "red_package":10,//0 没有用红包 其他为使用了红包
             "time":1548245850
             "order_type":1,               //1 到店  2 外面
             "phone":"13823169200",  //联系电话
             "name":"sunshine",      //用户姓名
             "shop_id":15854,        //分店id
             "shop_name":"longhuadian", //分店名称
             "remark":"Hungry",      //特殊备注
             "address":"aaa.bbb.cc", //地址
			 "is_payment":0,         //0 代表未支付 1 代表已经支付
			 "is_dispose":0,         //0 未受理     1 已受理
			 "is_complete":0,        //0 未完成     1 已完成
			 "is_refund":0,          //0 用户未申请退款 其他值为用户已申请退款
			 "begin_datetime":1417664745,     //吃饭开始时间 int类型
			 "end_datetime":1417665745,       //吃饭结束时间 int类型
			 "is_cancel":0,  // 0未取消  1用户手动取消 2支付超时自动取消
			 "is_close":0,   // 0未关闭  1关闭
			 "pay_type":1,   //支付类型 0 未操作 1 支付宝 2 银联
             "data":[
             {"type":1,"id":1,"num":1,"name":"a","price":10.23}, //(type 1 商品  2 套餐) (id 如果是套餐就是套餐的ID，如果是商品，就是商品的ID) (num 个数)
             {"type":1,"id":2,"num":1,"name":"b","price":10.23},
             {"type":1,"id":3,"num":1,"name":"c","price":10.23},
             {"type":1,"id":4,"num":1,"name":"d","price":10.23}
             ]}
*************************************************/
IT_API SS_SHORT IT_MallLoadOrderSingleIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_MallCancelOrderIND()
Description: 取消订单
Input:       un32ShopID  分店ID
Input:       pOrderCode  订单号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CANCEL_ORDER_CFM      203
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = order_code  订单号
*************************************************/
IT_API SS_SHORT IT_MallCancelOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_OrderConfirmIND()
Description: 订单确认接口
Input:       un32ShopID 分店ID
Input:       pOrderCode 订单号
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_ORDER_CONFIRM_CFM  202
			 Param[0] = Result  //0  成功 其他 失败
			 Param[1] = SellerID     商家ID
			 Param[2] = ShopID       分店ID
			 Param[3] = OrderCode    订单号
*************************************************/
IT_API SS_SHORT IT_OrderConfirmIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_SetAPITimeOut()
Description: 设置调用API超时的时间
Input:       un32Seconds 超时的时长，单位秒,2到19秒之间
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing 
*************************************************/
IT_API SS_SHORT IT_SetAPITimeOut(IN SS_UINT32 const un32Seconds);
/*************************************************
Function:    IT_OrderRefundIND()
Description: 订单申请退款接口
Input:       un32ShopID 分店ID
Input:       pOrderCode 订单号
Input:       pGrounds   退款的理由
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_ORDER_REFUND_CFM  200
			 Param[0] = Result  //0  成功 其他 失败
			 Param[1] = SellerID     商家ID
			 Param[2] = ShopID       分店ID
			 Param[3] = OrderCode    订单号
*************************************************/
IT_API SS_SHORT IT_OrderRefundIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode,
	IN SS_CHAR const *pGrounds);
/*************************************************
Function:    IT_GetOrderCodePayModeIND()
Description: 获得订单的支付方式
Input:       un32Type   类型  1  银联  2 支付宝
Input:       un32ShopID 分店ID
Input:       pOrderCode 订单号
Output:      nothing 
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_ORDER_CODE_PAY_MODE_CFM 199
			 Param[0] = Result  //0  成功 其他 失败
			 Param[1] = SellerID     商家ID
			 Param[2] = ShopID       分店ID
			 Param[3] = Type         类型
			 Param[4] = OrderCode    订单号
			 Param[5] = string       流水号或URL
*************************************************/
IT_API SS_SHORT IT_GetOrderCodePayModeIND(
	IN SS_UINT32 const  un32Type,
	IN SS_UINT32 const  un32ShopID,
	IN SS_CHAR   const *pOrderCode);
/*************************************************
Function:    IT_NetworkModeChange()
Description: 手机的网路模式发生改变
Input:       ubMode   当前的网络模式  0是没有网络 1是WIFI 2是2G 3是3G 4是4G 5是5G 6是不知道是什么网络
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT IT_NetworkModeChange(IN SS_BYTE const ubMode);
/*************************************************
Function:    IT_SelectPhoneCheckCodeIND()
Description: 查询注册验证码
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_SELECT_PHONE_CHECK_CODE_CFM     196
			 Param[0] = Result  //0 成功 其他 失败
			 Param[1] = phone   手机号码
			 Param[2] = code    验证码
*************************************************/
IT_API SS_SHORT IT_SelectPhoneCheckCodeIND(IN SS_CHAR *pPhone);
/*************************************************
Function:    IT_GetCreditBalanceIND()
Description: 获得话费余额
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_CREDIT_BALANCE_CFM     195
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = Balance     余额
             Param[2] = Minutes     分钟数
             Param[3] = SellerID    商家ID
*************************************************/
IT_API SS_SHORT IT_GetCreditBalanceIND();
/*************************************************
Function:    IT_RechargeIND()
Description: 充值
Input:       un32Type     //充值类型  1 我信  2 支付宝  3  移动  4 联通
Input:       un32Price    //金额
Input:       pAccount     //帐号
Input:       pPassword    //密码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_RECHARGE_CFM           192
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = OrderID     订单ID
             Param[3] = PhpURL      
			 Param[4] = WoXinResult 我信充值卡的充值结果
*************************************************/
IT_API SS_SHORT IT_RechargeIND(
    IN  SS_UINT32 const un32Type,
    IN  SS_UINT32 const un32Price,
    IN  SS_CHAR   const*pAccount,
    IN  SS_CHAR   const*pPassword);
/*************************************************
Function:    IT_GetRechargePreferentialRulesIND()
Description: 获得充值优惠规则
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM           193
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = JSON        json串
             Param[1] = Json
             [{"Top":10,"equals":26,"desc":"描述"},{"Top":100,"equals":260,"desc":"描述"}] //Top 10 equals 26(充值10等于26)
*************************************************/
IT_API SS_SHORT IT_GetRechargePreferentialRulesIND();
/*************************************************
Function:    IT_UpdateBoundMobileNumberIND()
Description: 更新绑定的手机号码
Input:       pPhone
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_BOUND_MOBILE_NUMBER_CFM           194
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
*************************************************/
IT_API SS_SHORT IT_UpdateBoundMobileNumberIND(IN SS_CHAR const*pPhone);
/*************************************************
Function:    IT_LibisRuning()
Description: 判断Lib库是否在运行
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 在运行中，其他没有运行
Others:      nothing
*************************************************/
IT_API SS_SHORT IT_LibisRuning();
/*************************************************
Function:    IT_SetAutoConnectServer()
Description: 设置是否自动连接服务器
Input:       ubFlag   0 取消自动连接服务器  1 自动连接服务器
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT IT_SetAutoConnectServer(IN SS_BYTE const ubFlag);
/*************************************************
Function:    IT_AboutIND()
Description: 我信关于
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_IT_ABOUT_CFM     187
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = Json 
             {
             "tel":"400-888-9999999",    //联系方式
             "web":"http://www.67call.com", //官方网址
             "xinlang_blog":"http://weibo.com/5144421865" //新浪微博
             }
*************************************************/
IT_API SS_SHORT IT_AboutIND();
/*************************************************
Function:    IT_AboutHelpIND()
Description: 我信关于帮助
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_IT_ABOUT_HELP_CFM     188
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = Content //内容    
*************************************************/
IT_API SS_SHORT IT_AboutHelpIND();
/*************************************************
Function:    IT_AboutProtocolIND()
Description: 我信关于协议
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_IT_ABOUT_PROTOCOL_CFM     189
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = Content //内容
*************************************************/
IT_API SS_SHORT IT_AboutProtocolIND();
/*************************************************
Function:    IT_AboutFeedBackIND()
Description: 我信关于问题反馈
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_IT_ABOUT_FEED_BACK_CFM     190
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT IT_AboutFeedBackIND(
    IN SS_CHAR const*pQQ,
    IN SS_CHAR const*pEMail,
    IN SS_CHAR const*pContent);
/*************************************************
Function:    IT_UpdateREGShopIND()
Description: 更新用户注册的分店
Input:       ShopID   分店
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_REG_SHOP_CFM    186
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
*************************************************/
IT_API SS_SHORT IT_UpdateREGShopIND(IN  SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_ReportTokenIND()
Description: 上报自己的令牌，IOS版本API
Input:       Token   令牌
Input:       UserID  用户
Input:       un32CertsType  证书类型，如：1 开发证书  2 发布证书
Input:       MachineID  机器ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_REPORT_TOKEN_CFM       185
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
*************************************************/
IT_API SS_SHORT IT_ReportTokenIND(
    IN  SS_CHAR   const*pToken,
    IN  SS_CHAR   const*pUserID,
    IN  SS_UINT32 const un32CertsType,
    IN  SS_CHAR   const*pMachineID);

/*************************************************
Function:    IT_MallGetPushMessageInfoIND()
Description: 获得推送消息的详细信息
Input:       un32ShopID   //分店ID
Input:       un32MSGID    //消息ID
Input:       un32MSGType  //消息类型
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_PUSH_MESSAGE_INFO_CFM       184
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = msg_id      //消息ID
             Param[4] = msg_type    //消息类型
             Param[5] = ShopName    //分店名称
             Param[6] = Title       //标题
             Param[7] = ImageURL    //图片的URL
             Param[8] = HtmlURL     //消息的ULR
             Param[9] = Abstract    //消息概要
             Param[10]= Json        //扩展用，目前不用
*************************************************/
IT_API SS_SHORT IT_MallGetPushMessageInfoIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_UINT32 const un32MSGType);
/*************************************************
Function:    IT_MallGetRedPackageBalanceIND()
Description: 获得红包余额
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_RED_PACKAGE_BALANCE_CFM  181
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = Balance     红包余额
*************************************************/
IT_API SS_SHORT IT_MallGetRedPackageBalanceIND();

/*************************************************
Function:    IT_MallGetSellerAboutInfoIND()
Description: 获得商家关于信息
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_SELLER_ABOUT_CFM         182
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = json        关于信息
*************************************************/
IT_API SS_SHORT IT_MallGetSellerAboutInfoIND();

/*************************************************
Function:    IT_MallGetShopAboutInfoIND()
Description: 获得分店关于信息
Input:       un32ShopID  分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_SHOP_ABOUT_CFM           183
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = json        关于信息
*************************************************/
IT_API SS_SHORT IT_MallGetShopAboutInfoIND(IN SS_UINT32 const un32ShopID);

/*************************************************
Function:    IT_MallLoadRedPackageIND()
Description: 加载红包
Input:       un32ShopID  分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_RED_PACKAGE_CFM     176
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = Json        红包信息
             {"pack":[
             "type":1,    //注册红包
             "shop_id":55555, //分店ID 注册送的红包
             "name":"longhuadian", //分店名称
             "data":[
             {"id":1,"price":1,"title":"vvvvvvvv","remark":"Hungry","end_date":"2018-05-05"} //id 红包ID  price 红包的面值 title 标题  remark 备注，规则等信息 end_date 活动结束日期
             ]},
             {
             "type":2,    //活动红包
             "shop_id":6666, //分店ID 促销活动
             "name":"nanshandian", //分店名称
             "data":[
             {"id":1,"price":1,"title":"vvvvvvvv","remark":"Hungry","end_date":"2018-05-05"} //id 红包ID  price 红包的面值 title 标题  remark 备注，规则等信息 end_date 活动结束日期
             ]}
             ]}
*************************************************/
IT_API SS_SHORT IT_MallLoadRedPackageIND(IN SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallReceiveRedPackageIND()
Description: 领取红包
Input:       un32ShopID  分店ID
Input:       un32RedPackageID  领取红包的ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_RECEIVE_RED_PACKAGE_CFM     177
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = RedPackageID红包ID
             Param[4] = total_money 红包余额
*************************************************/
IT_API SS_SHORT IT_MallReceiveRedPackageIND(IN SS_UINT32 const un32ShopID,IN SS_UINT32 const un32RedPackageID);
/*************************************************
Function:    IT_MallUseRedPackageIND()
Description: 使用红包
Input:       un32ShopID  分店ID
Input:       pPrice      使用多少红包的金额
Input:       pOrderCode  订单号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_USE_RED_PACKAGE_CFM     178
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = total_money 红包余额
             Param[4] = OrderCode   订单号order_code
*************************************************/
IT_API SS_SHORT IT_MallUseRedPackageIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_CHAR   const*pPrice,
    IN SS_CHAR   const*pOrderCode);
/*************************************************
Function:    IT_MallLoadRedPackageUseRulesIND()
Description: 加载红包使用规则
Input:       un32ShopID  分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM     179
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = Json        红包使用规则信息
             {
             "shop_id":55555, //分店ID 注册送的红包
             "data":[
             {"title":"vvvvvvvv","remark":"Hungry","over":1,"minus":1} //title 标题 remark 备注 over 300  minus 100(满 300 减 100)
             ]}
*************************************************/
IT_API SS_SHORT IT_MallLoadRedPackageUseRulesIND(IN SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallAddOrderIND()
Description: 添加订单
Input:       un32ShopID  分店ID
Input:       pJson       订单信息
             {
             "order_type":1,               //1 到店  2 外面
             "phone":"13823169200",  //联系电话
             "name":"sunshine",      //用户姓名
             "shop_name":"longhuadian", //分店名称
             "remark":"Hungry",      //特殊备注
             "address":"aaa.bbb.cc", //地址
             "count":4,
			 "begin_datetime":1417664745,     //吃饭开始时间 int类型
			 "end_datetime":1417665745,       //吃饭结束时间 int类型
			 "red_package":4,   //这个订单使用多少红包,单位：元
             "data":[
             {"type":1,"id":1,"num":1}, //(type 1 商品  2 套餐) (id 如果是套餐就是套餐的ID，如果是商品，就是商品的ID) (num 个数)
             {"type":1,"id":2,"num":1},
             {"type":1,"id":3,"num":1},
             {"type":1,"id":4,"num":1}
             ]}
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_ADD_ORDER_CFM      172
             Param[0] = Result  //0 成功 其他 失败 250 表示使用红包大于或等于订单总金额
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = order_code  订单号
*************************************************/
IT_API SS_SHORT IT_MallAddOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pJson);
/*************************************************
Function:    IT_MallUpdateOrderIND()
Description: 更新订单
Input:       un32ShopID  分店ID
Input:       pOrderCode  订单号
Input:       pJson       订单信息
             {
             "order_type":1,               //1 到店  2 外面
             "phone":"13823169200",  //联系电话
             "name":"sunshine",      //用户姓名
             "shop_name":"longhuadian", //分店名称
             "remark":"Hungry",      //特殊备注
             "address":"aaa.bbb.cc", //地址
             "count":4,
			 "begin_datetime":1417664745,     //吃饭开始时间 int类型
			 "end_datetime":1417665745,       //吃饭结束时间 int类型
			 "red_package":4,   //这个订单使用多少红包,单位：元
             "data":[
             {"type":1,"id":1,"num":1}, //(type 1 商品  2 套餐) (id 如果是套餐就是套餐的ID，如果是商品，就是商品的ID) (num 个数)
             {"type":1,"id":2,"num":1},
             {"type":1,"id":3,"num":1},
             {"type":1,"id":4,"num":1}
             ]}
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_ORDER_CFM   173
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = order_code  订单号
*************************************************/
IT_API SS_SHORT IT_MallUpdateOrderIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_CHAR const *pOrderCode,
    IN SS_CHAR const *pJson);
/*************************************************
Function:    IT_MallDelOrderIND()
Description: 删除订单
Input:       un32ShopID  分店ID
Input:       pOrderCode  订单号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_DEL_ORDER_CFM      174
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = order_code  订单号
*************************************************/
IT_API SS_SHORT IT_MallDelOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode);
/*************************************************
Function:    IT_MallLoadOrderIND()
Description: 加载订单
Input:       un32ShopID  分店ID
Input:       un32OffSet  偏移量
Input:       un32Limit   得到多少条
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_ORDER_CFM     175
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = ShopID      分店ID
             Param[3] = number      多少个
             Param[4] = json 串
             {"order_id":"201394392749",
             "price":40.00,
             "red_package":10,//0 没有用红包 其他为使用了红包
             "time":1548245850
             "order_type":1,               //1 到店  2 外面
             "phone":"13823169200",  //联系电话
             "name":"sunshine",      //用户姓名
             "shop_id":15854,        //分店id
             "shop_name":"longhuadian", //分店名称
             "remark":"Hungry",      //特殊备注
             "address":"aaa.bbb.cc", //地址
			 "is_payment":0,         //0 代表未支付 1 代表已经支付
			 "is_dispose":0,         //0 未受理     1 已受理
			 "is_complete":0,        //0 未完成     1 已完成
			 "is_refund":0,          //0 用户未申请退款 其他值为用户已申请退款
			 "begin_datetime":1417664745,     //吃饭开始时间 int类型
			 "end_datetime":1417665745,       //吃饭结束时间 int类型
			 "is_cancel":0,  // 0未取消  1用户手动取消 2支付超时自动取消
			 "is_close":0,   // 0未关闭  1关闭
			 "pay_type":1,   //支付类型 0 未操作 1 支付宝 2 银联
			 "hasten_number":1, //用户催次数
			 "user_is_refund":0, //0用户可以申请退款   1.用户不能申请退款
			 "total_refund_money":0.00, //该订单退款成功的总金额
			 "cancel_time":1417665745, //订单取消时间
			 "dispose_time":1417665745, //订单接单时间
			 "shipments_time":1417665745, //订单发货时间
			 "clearing_time":1417665745, //订单结算时间
			 "complete_time":1417665745, //订单完成时间
			 "close_time":1417665745, //订单关闭时间
             "data":[
             {"type":1,"id":1,"num":1,"name":"a","price":10.23}, //(type 1 商品  2 套餐) (id 如果是套餐就是套餐的ID，如果是商品，就是商品的ID) (num 个数)
             {"type":1,"id":2,"num":1,"name":"b","price":10.23},
             {"type":1,"id":3,"num":1,"name":"c","price":10.23},
             {"type":1,"id":4,"num":1,"name":"d","price":10.23}
             ]},
             {"order_id":"201394392750",
             "price":40.00,
             "red_package":10,//0 没有用红包 其他为使用了红包
             "time":1548245854
             "order_type":1,               //1 到店  2 外面
             "phone":"13823169200",  //联系电话
             "name":"sunshine",      //用户姓名
             "shop_id":15854,        //分店id
             "shop_name":"longhuadian", //分店名称
             "remark":"Hungry",      //特殊备注
             "address":"aaa.bbb.cc", //地址
			 "is_payment":0,         //0 代表未支付 1 代表已经支付
			 "is_dispose":0,         //0 未受理     1 已受理
			 "is_complete":0,        //0 未完成     1 已完成
			 "is_refund":0,          //0 用户未申请退款 其他值为用户已申请退款
			 "begin_datetime":1417664745,     //吃饭开始时间 int类型
			 "end_datetime":1417665745,       //吃饭结束时间 int类型
			 "is_cancel":0,  // 0未取消  1用户手动取消 2支付超时自动取消
			 "is_close":0,   // 0未关闭  1关闭
			 "pay_type":1,   //支付类型 0 未操作 1 支付宝 2 银联
			 "hasten_number":1, //用户催次数
			 "user_is_refund":0, //0用户可以申请退款   1.用户不能申请退款
			 "total_refund_money":0.00, //该订单退款成功的总金额
			 "cancel_time":1417665745, //订单取消时间
			 "dispose_time":1417665745, //订单接单时间
			 "shipments_time":1417665745, //订单发货时间
			 "clearing_time":1417665745, //订单结算时间
			 "complete_time":1417665745, //订单完成时间
			 "close_time":1417665745, //订单关闭时间
             "data":[
             {"type":1,"id":5,"num":1,"name":"e","price":10.23}, //(type 1 商品  2 套餐) (id 如果是套餐就是套餐的ID，如果是商品，就是商品的ID) (num 个数)
             {"type":1,"id":6,"num":1,"name":"f","price":10.23},
             {"type":1,"id":7,"num":1,"name":"g","price":10.23},
             {"type":1,"id":8,"num":1,"name":"h","price":10.23}
             ]}
             ]}
*************************************************/
IT_API SS_SHORT IT_MallLoadOrderIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_UINT32 const un32OffSet,
	IN SS_UINT32 const un32Limit);
/*************************************************
Function:    IT_MallGetAreaInfoIND()
Description: 获得一个商家有多少个地区
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_AREA_INFO_CFM   160
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = number      有多少个
             Param[3] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetAreaInfoIND();
/*************************************************
Function:    IT_MallGetShopInfoIND()
Description: 获得一个地区有多少个分店
Input:       un32AreaID   地区ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_SHOP_INFO_CFM    161
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = number      有多少个
             Param[4] = json 串
			 {"data":[
			 {"name":"明治店","img":"aaa\bbb\ddd.jpg","id":10,"open_time":"字符串形式","destine_day":5,"shop_tel":"0755-12345678"}",
			 {"name":"龙华店","img":"aaa\bbb\ccc.jpg","id":13,"open_time":"字符串形式","destine_day":7,"shop_tel":"0755-87654321"}"
			 ]}
			 open_time   营业时间
			 destine_day 就餐预定天数
			 shop_tel    电话
*************************************************/
IT_API SS_SHORT IT_MallGetShopInfoIND(IN  SS_UINT32 const un32AreaID);
/*************************************************
Function:    IT_MallGetAreaShopInfoIND()
Description: 获得一个商家所有多少地区和分店
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_AREA_SHOP_INFO_CFM   197
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[3] = json 串
			 [{"name":"深圳地区","id":1,"shop":[{"name":"龙华店","img":"http:\\xxx.jpg","id":100},{"name":"福田店","img":"http:\\xxx.jpg","id":200}]},
			  {"name":"上海地区","id":2,"shop":[{"name":"浦东店","img":"http:\\xxx.jpg","id":300},{"name":"黄浦江店","img":"http:\\xxx.jpg","id":400}]},
			  {"name":"北京地区","id":3,"shop":[{"name":"朝阳店","img":"http:\\xxx.jpg","id":500},{"name":"海淀店","img":"http:\\xxx.jpg","id":600}]},
			  {"name":"重庆地区","id":4,"shop":[{"name":"码头店","img":"http:\\xxx.jpg","id":700},{"name":"新区店","img":"http:\\xxx.jpg","id":800}]}]
*************************************************/
IT_API SS_SHORT IT_MallGetAreaShopInfoIND();
/*************************************************
Function:    IT_MallGetHomeTopBigPictureIND()
Description: 首页置顶大图
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM  162
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetHomeTopBigPictureIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallGetHomeTopBigPictureExIND()
Description: 首页置顶大图，新借口，增加了跳转属性
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM  198
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetHomeTopBigPictureExIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallGetHomeNavigationIND()
Description: 首页导航功能
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_HOME_NAVIGATION_CFM  163
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetHomeNavigationIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);

/*************************************************
Function:    IT_MallGetGuessYouLikeRandomGoodsIND()
Description: 猜你喜欢的随机商品
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM  164
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetGuessYouLikeRandomGoodsIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);

/*************************************************
Function:    IT_MallGetCategoryListIND()
Description: 商品分类列表接口
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_CATEGORY_LIST_CFM  165
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetCategoryListIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallGetPackageIND()
Description: 获得套餐列表
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_PACKAGE_CFM   170
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetPackageIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);
/*************************************************
Function:    IT_MallGetGoodsAllIND()
Description: 获得全部的商品列表
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_GOODS_ALL_CFM   171
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      多少个
             Param[5] = json 串
             Param[6] = Domain      域名前缀
*************************************************/
IT_API SS_SHORT IT_MallGetGoodsAllIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);

/*************************************************
Function:    IT_MallGetSpecialPropertiesCategoryListIND()
Description: 特殊属性的商品列表接口
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM  166
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = number      有多少个
             Param[5] = json 串
*************************************************/
IT_API SS_SHORT IT_MallGetSpecialPropertiesCategoryListIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);

/*************************************************
Function:    IT_MallGetGoodsInfoIND()
Description: 商品详情接口
Input:       un32AreaID   地区ID
Input:       un32ShopID   分店ID
Input:       un32GoodsID  商品ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_GOODS_INFO_CFM  167
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = AreaID      地区ID
             Param[3] = ShopID      分店ID
             Param[4] = GoodsID     商品ID
             Param[5] = GroupID     商品组ID
             Param[6] = Description 商品描述
             Param[7] = Name        商品名
             Param[8] = MarketPrice 市场价格
             Param[9] = OURPrice    本店价格
             Param[10]= number      有多少个
             Param[11]= json 串
             Param[12]= LikeCount   喜欢累加
			 Param[13]= MeterageName 单位
*************************************************/
IT_API SS_SHORT IT_MallGetGoodsInfoIND(
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT32 const un32GoodsID);

/*************************************************
Function:    IT_MallReportMyLocationIND()
Description: 上报自己的地理位置,返回自己所在的地区，地区的分店，最近的分店是那一个
Input:       pLatitude   纬度
Input:       pLongitude  经度
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_REPORT_MY_LOCATION_CFM  168
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = SellerID    商家ID
             Param[2] = json 串 flag 0 找到最近的店  1 附近的店  2 其他店
             [{"shop_id":10,"shop_name":"nanshan","shop_img":"a.jpg","area_id":10,"flag":0},
             {"shop_id":10,"shop_name":"futian" ,"shop_img":"a.jpg","area_id":10,"flag":1},
             {"shop_id":10,"shop_name":"chaoynag","shop_img":"a.jpg","area_id":10,"flag":2}]
*************************************************/
IT_API SS_SHORT IT_MallReportMyLocationIND(
    IN  SS_CHAR   const*pLatitude,
    IN  SS_CHAR   const*pLongitude);
/*************************************************
Function:    IT_MallGetLastBrowseShopIND()
Description: 获得最后浏览的那个分店的信息
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_LAST_BROWSE_SHOP_CFM  169
             Param[0] = SellerID    商家ID
             Param[1] = AreaID      地区ID
             Param[2] = ShopID      分店ID
*************************************************/
IT_API SS_SHORT IT_MallGetLastBrowseShopIND();

/*************************************************
Function:    IT_GetUserinfo()
Description: 获得用户自己的相关信息
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_USER_INFO_CFM   154
             Param[0] = pName       昵称
             Param[1] = pVName      真实姓名
             Param[2] = pPhone      绑定的手机号码
             Param[3] = ubSex       性别 0 女性 1 男性 2 未知 
             Param[4] = pBirthday   生日
             Param[5] = pQQ         QQ号
             Param[6] = pCharacterSignature 个性签名
             Param[7] = pStreet     住址
             Param[8] = pArea       地区
             Param[9] = icon_path   大头像路径
             Param[10]= WoXinID     我信ID
*************************************************/
IT_API SS_SHORT      IT_GetUserinfo();

/*************************************************
Function:    IT_UpdateUserinfo()
Description: 获得用户自己的相关信息
Input:       pName       昵称
Input:       pVName      真实姓名
Input:       pPhone      绑定的手机号码
Input:       ubSex       性别 0 女性 1 男性 2 未知 
Input:       pBirthday   生日
Input:       pQQ         QQ号
Input:       pCharacterSignature 个性签名
Input:       pStreet     住址
Input:       pArea       地区
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_USER_INFO_CFM   155
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT      IT_UpdateUserinfo(
    IN  SS_CHAR const*pName,
    IN  SS_CHAR const*pVName,
    IN  SS_CHAR const*pPhone,
    IN  SS_BYTE const ubSex,
    IN  SS_CHAR const*pBirthday,
    IN  SS_CHAR const*pQQ,
    IN  SS_CHAR const*pCharacterSignature,
    IN  SS_CHAR const*pStreet,
    IN  SS_CHAR const*pArea);

/*************************************************
Function:    IT_InitConfig()
Description: 初始化协议和日志目录
Input:       pProtocol    初始化的协议 1 SIP 协议, 2 私有协议,3 H323协议
Input:       pLogPath     日志路径 LIB库会创建这个文件夹
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_InitConfig(
    IN  SS_CHAR  *pProtocol,//初始化的协议
    IN  SS_CHAR  *pLogPath);//日志路径
/*************************************************
Function:    IT_UpdateUserName()
Description: 更新显示的用户名，用在SIP协议，屏幕显示名
Input:       pUserName    显示名
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_UpdateUserName(
    IN  SS_CHAR  *pUserName);
/*************************************************
Function:    IT_SetIconPath()
Description: 设置大头像文件保存的目录
Input:       pPath    路径，目录
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_SetIconPath(IN  SS_CHAR  *pPath);
/*************************************************
Function:    IT_UpdateDBPath()
Description: 设置sqlite数据库的创建目录，LIB库会创建并保存这个目录
Input:       pDBPath    数据库保存的目录
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_UpdateDBPath(IN  SS_CHAR  *pDBPath);

/*************************************************
Function:    IT_ConnectDB()
Description: 在没有网络，或启动时无法连接服务器的情况下使用，
             保证在没有网络的情况下可以正常使用我们的软件，
             但与网络相关的操作就无法进行。
Input:       pDBFilePath    数据库文件保存的绝对路径
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_ConnectDB(IN  SS_CHAR  *pDBFilePath);
/*************************************************
Function:    IT_Init()
Description: 初始化LIB库的相关资源
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_Init();
/*************************************************
Function:    IT_SetCallBack()
Description: 装载回调函数，所有的网络消息都从这个回调返回
Input:       f_CallBack  回调函数地址
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_SetCallBack(
    IN SS_SHORT (*f_CallBack)(IN SS_UINT32 const ,IN SS_CHAR **,IN SS_UINT32 const));
/*************************************************
Function:    IT_UnInit()
Description: 释放LIB库的相关资源
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_UnInit();
/*************************************************
Function:    IT_Start()
Description: 启动LIB库，LIB库会创建一个线程在后台运行
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_Start();
/*************************************************
Function:    IT_Stop()
Description: 停止LIB库线程的运行
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_Stop();
/*************************************************
Function:    GetITLibVer()
Description: 获得当前LIB的版本
Input:       nothing
Output:      nothing
Return:      returns  返回当前库的版本号
Others:      nothing
*************************************************/
IT_API SS_CHAR const*const  GetITLibVer();
/*************************************************
Function:    GetITLibVerNo()
Description: 获得当前LIB的版本 数字形式
Input:       nothing
Output:      nothing
Return:      returns  返回当前库的版本号
Others:      nothing
*************************************************/
IT_API SS_UINT32            GetITLibVerNo();
/*************************************************
Function:    IT_LogScreenDisplay()
Description: 设置要不要在屏幕上打印LIB版本的日志
Input:       ubState  SS_TRUE 显示 SS_FALSE 不显示
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT             IT_LogScreenDisplay(IN SS_BYTE const ubState);

//////////////////////////////////////////////////////////////////////////
/*************************************************
Function:    IT_SetWoXinID()
Description: 设置我信ID到LIB的数据表里面
Input:       pLoginID 我信ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT      IT_SetWoXinID(IN  SS_CHAR const*pLoginID);
/*************************************************
Function:    IT_GetWoXinID()
Description: 获得我信ID从LIB的数据表里面
Input:       pLoginID 保存我信ID的缓存
Input:       un32Size 缓存的大小
Output:      nothing
Return:      returns  返回我信的ID
Others:      nothing
*************************************************/
IT_API SS_CHAR const*IT_GetWoXinID(OUT SS_CHAR *pLoginID,IN SS_UINT32 const un32Size);
/*************************************************
Function:    IT_SetSellerID()
Description: 设置商家ID到LIB的缓存
Input:       un32SellerID 我信ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_SetSellerID(IN  SS_UINT32 const un32SellerID);
/*************************************************
Function:    IT_GetSellerID()
Description: 获得商家ID从LIB的缓存
Input:       nothing
Output:      nothing
Return:      returns  返回商家ID
Others:      nothing
*************************************************/
IT_API SS_UINT32 IT_GetSellerID();
/*************************************************
Function:    IT_SetLoginPassWord()
Description: 设置我信的登录密码到LIB的数据表里面
Input:       pPassWord  登录密码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT      IT_SetLoginPassWord(IN  SS_CHAR const*pPassWord);
/*************************************************
Function:    IT_GetLoginPassWord()
Description: 获得登录密码从LIB的数据表里面
Input:       pPassWord 保存登录密码的缓存
Input:       un32Size  缓存的大小
Output:      nothing
Return:      returns  返回登录密码
Others:      nothing
*************************************************/
IT_API SS_CHAR const*IT_GetLoginPassWord(OUT SS_CHAR *pPassWord,IN SS_UINT32 const un32Size);
/*************************************************
Function:    IT_SetPhoneNumber()
Description: 设置我信绑定的手机号码到LIB的数据表里面
Input:       pPassWord  绑定的手机号码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT      IT_SetPhoneNumber(IN  SS_CHAR const*pPhone);
/*************************************************
Function:    IT_GetPhoneNumber()
Description: 获得绑定的手机号码从LIB的数据表里面
Input:       pPassWord 保存绑定的手机号码的缓存
Input:       un32Size  缓存的大小
Output:      nothing
Return:      returns  返回绑定的手机号码
Others:      nothing
*************************************************/
IT_API SS_CHAR const*IT_GetPhoneNumber(OUT SS_CHAR *pPhone,IN SS_UINT32 const un32Size);

//////////////////////////////////////////////////////////////////////////

/*************************************************
Function:    IT_GetPhoneCheckCode()
Description: 获得手机验证码,一般在新用户注册的时候使用
Input:       pPhone 接收短信的手机号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_PHONE_CHECK_CODE_CFM 109
             Param[0] = Result  0 成功 其他 失败
             Param[1] = Code    手机验证码
*************************************************/
IT_API SS_SHORT  IT_GetPhoneCheckCode(IN SS_CHAR const*pPhone);
/*************************************************
Function:    IT_Register()
Description: 注册一个新帐号
Input:       un32ID    商家ID
Input:       pPhone    绑定的手机号
Input:       pPassword 登录密码
Input:       pCode     短信验证码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_REGISTER_CFM 110
             Param[0] = Result  0 成功 其他 失败
			 Param[1] = WoXinID 系统唯一ID
             MKS_DB_REGISTER_RESULT_CODE_ERROR  2 //手机验证码错误
             MKS_DB_REGISTER_RESULT_PHONE_REG   3 //手机号码已经注册
             MKS_DB_REGISTER_RESULT_CODE_TIMEOUT 4 //手机验证码超时
			 MKS_DB_REGISTER_RESULT_NUMBER_ERROR 5 //非法的手机号码
*************************************************/
IT_API SS_SHORT  IT_Register(
    IN SS_UINT32 const un32ID,
    IN SS_CHAR const*pPhone,   //绑定的手机
    IN SS_CHAR const*pPassword,//登录密码
    IN SS_CHAR const*pCode);   //短信验证码
/*************************************************
Function:    IT_Unregister()
Description: 注销一个用户，如果注销成功，那么这个用户系统将不存在
Input:       un32ID    商家ID
Input:       pPhone    绑定的手机号
Input:       pPassword 登录密码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UNREGISTER_CFM 111
             Param[0] = Result  0 成功 其他 失败
             MKS_DB_UNREGISTER_RESULT_NO_LOGIN       2 //没有登录
             MKS_DB_UNREGISTER_RESULT_PASSWORD_ERROR 3 //密码错误
             MKS_DB_UNREGISTER_RESULT_PASSWORD_ERROR 4 //用户已经注册
*************************************************/
IT_API SS_SHORT  IT_Unregister(
    IN SS_UINT32 const un32ID,
    IN SS_CHAR const*pPhone,
    IN SS_CHAR const*pPassword);
/*************************************************
Function:    IT_Login()
Description: 登录 上线
Input:       un32ID    商家ID
Input:       usnPhoneModel 手机类型 1 Android ; 2 IOS
Input:       pPhone    绑定的手机号
Input:       pPassword 登录密码
Input:       pPhoneID  手机的唯一ID，表示为一个唯一的手机设备，长度小于等于64 (<=64)
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOGIN_STATUS_CHANGE 100
             Param[0] = Result 
             IT_STATUS_IDLE    =  0, 未知,初始化
             IT_STATUS_ON_LINE =  1, 上线
             IT_STATUS_OFF_LINE=  2, 离线
             IT_STATUS_DISTANCE=  3, 离开，暂时不在电脑旁边
             IT_STATUS_BUSY    =  4, 忙碌
             IT_STATUS_CALL    =  5, 通话中
             IT_STATUS_STEALTH =  6, 隐身
             IT_STATUS_NOT_BOTHER=7, 请勿打扰
             IT_STATUS_LOGIN   =  8, 登录过程中
             IT_STATUS_LOGIN_OK=  9, 登录成功
             IT_STATUS_LOGIN_ERR =10, 登录失败
             IT_STATUS_LOGOUT    =11,  退出登录过程中
             IT_STATUS_LOGOUT_OK =12,  退出登录成功
             IT_STATUS_LOGOUT_ERR=13,  退出登录失败
             IT_STATUS_REG_SERVER_CONNECT_OK=14,   连接注册服务器成功
             IT_STATUS_REG_SERVER_DISCONNECT_OK=15 注册服务器连接断开
			 IT_STATUS_LOGIN_NOT_ACCOUNT=17 // 登录帐号不存在
			 IT_STATUS_LOGIN_TIME_OUT=18 // 登录超时
*************************************************/
IT_API SS_SHORT  IT_Login(
	IN SS_UINT32 const un32ID,
	IN SS_USHORT const usnPhoneModel,
	IN SS_CHAR const*pPhone,
	IN SS_CHAR const*pPassword,
	IN SS_CHAR const*pPhoneID);
/*************************************************
Function:    IT_Logout()
Description: 登出 离线,调用成功会断开sqlite的连接，清空用户名、密码、我信ID信息。
Input:       un32ID    商家ID
Input:       pPhone    绑定的手机号
Input:       pPassword 登录密码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOGIN_STATUS_CHANGE 100
             Param[0] = Result 
             IT_STATUS_IDLE    =  0, 未知,初始化
             IT_STATUS_ON_LINE =  1, 上线
             IT_STATUS_OFF_LINE=  2, 离线
             IT_STATUS_DISTANCE=  3, 离开，暂时不在电脑旁边
             IT_STATUS_BUSY    =  4, 忙碌
             IT_STATUS_CALL    =  5, 通话中
             IT_STATUS_STEALTH =  6, 隐身
             IT_STATUS_NOT_BOTHER=7, 请勿打扰
             IT_STATUS_LOGIN   =  8, 登录过程中
             IT_STATUS_LOGIN_OK=  9, 登录成功
             IT_STATUS_LOGIN_ERR =10, 登录失败
             IT_STATUS_LOGOUT    =11,  退出登录过程中
             IT_STATUS_LOGOUT_OK =12,  退出登录成功
             IT_STATUS_LOGOUT_ERR=13,  退出登录失败
             IT_STATUS_REG_SERVER_CONNECT_OK=14,   连接注册服务器成功
             IT_STATUS_REG_SERVER_DISCONNECT_OK=15 注册服务器连接断开
*************************************************/
IT_API SS_SHORT  IT_Logout(IN SS_UINT32 const un32ID,IN SS_CHAR const*pPhone,IN SS_CHAR const*pPassword);
/*************************************************
Function:    IT_UpdatePassword()
Description: 修改登录密码
Input:       pPhone  绑定的手机号
Input:       pOld    旧密码
Input:       pNew    新密码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_PASSWORD   101
             Param[0] = Result  0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_UpdatePassword(
    IN SS_CHAR const*pPhone,
    IN SS_CHAR const*pOld,
    IN SS_CHAR const*pNew);
/*************************************************
Function:    IT_FindPassword()
Description: 找回登录密码
Input:       un32SellerID 商家ID
Input:       pPhone     绑定的手机号
Input:       pSMSPhone  接收密码短信的手机号码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_FIND_PASSWORD    102
             Param[0] = Result  0 成功 100 手机号码不是系统用户，  其他 失败
*************************************************/
IT_API SS_SHORT  IT_FindPassword(IN SS_UINT32 const un32SellerID,IN SS_CHAR const*pPhone,IN SS_CHAR const*pSMSPhone);
/*************************************************
Function:    IT_ChangeLoginStatus()
Description: 找回登录密码
Input:       pPhone  绑定的手机号
Input:       ubStatus  
             IT_STATUS_DISTANCE=  3, 离开，暂时不在电脑旁边
             IT_STATUS_BUSY    =  4, 忙碌
             IT_STATUS_CALL    =  5, 通话中
             IT_STATUS_STEALTH =  6, 隐身
             IT_STATUS_NOT_BOTHER=7, 请勿打扰
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_LOGIN_STATE    103
             Param[0] = Result  0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_ChangeLoginStatus(IN SS_CHAR const*pPhone,IN SS_BYTE const ubStatus);
/*************************************************
Function:    IT_ReportVersionIND()
Description: 登录的时候报告当前的版本给服务器，在CFM消息告诉客户端是否要更新
Input:       pPhone    绑定的手机号
Input:       un32ID    商家ID
Input:       pVersion  当前的版本
Input:       usnPhoneModel 手机类型 1 Android ; 2 IOS
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_REPORT_VERSION_CFM    104
             Param[0] = Result  0 当前是最新版本 1 有新版本，可以不更新 2  必须更新，才能使用 3 请求超时
             Param[1] = url     // 下载地址
             Param[2] = info    // 更新信息，新版本都更新那些内容
             Param[3] = ID      // 商家ID
             Param[4] = NewVer  // 当前最新的版本
*************************************************/
IT_API SS_SHORT  IT_ReportVersionIND(
    IN SS_CHAR const*pPhone,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR const*pVersion,
    IN SS_USHORT const usnPhoneModel);
/*************************************************
Function:    IT_UpdateCPUID()
Description: 唯一的ID，当修改了我信通讯录的时候要调用这个方法
Input:       pPhone  绑定的手机号
Input:       pID     客户端生成的唯一ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_CPUID_CFM      105
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_UpdateCPUID(IN SS_CHAR const*pPhone,IN SS_CHAR const*pID);
/*************************************************
Function:    IT_GetBalance()
Description: 获得用户的当前余额
Input:       pPhone  绑定的手机号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_BALANCE_CFM       106
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = Balance //余额
*************************************************/
IT_API SS_SHORT  IT_GetBalance(IN SS_CHAR const*pPhone);
/*************************************************
Function:    IT_GetUserData()
Description: 获得用户的基本信息
Input:       pPhone  绑定的手机号
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_USER_INFO_CFM     107
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = OnLineTime //在线的总时长
             Param[2] = Balance    //余额
             Param[3] = CurState   //服务器显示的当前的状态
             Param[4] = Amount     //赠送金额
             Param[5] = Integral   //累计积分
             Param[6] = Level      //等级
			 Param[7] = IconPath   //大头像的路径
			 Param[8] = Name       昵称
			 Param[9] = VName      真实姓名
			 Param[10]= Phone      绑定的手机号码
			 Param[11]= Sex       性别 0 女性 1 男性 2 未知 
			 Param[12]= Birthday   生日
			 Param[13]= QQ         QQ号
			 Param[14]= CharacterSignature 个性签名
			 Param[15]= Street     住址
			 Param[16]= Area       地区
*************************************************/
IT_API SS_SHORT  IT_GetUserData(IN SS_CHAR const*pPhone);

/*************************************************
Function:    IT_CallBackIND()
Description: 回呼
Input:       pCaller     主叫号码
Input:       pCalled     被叫号码
Input:       ubCallMode  呼叫模式 0 当主叫接通后在呼叫被叫  1 当主叫响铃后呼叫被叫  
Input:       ubRateMode  路由模式 以下三种
Input:       un32AppHandle 与这同电话相关的句柄
             RATE_MODE_PERSONAL_VERSION        1 // 个人版本  Personal version 
             RATE_MODE_MERCHANT_VERSION        2 // 商家版本 Merchant version 
             RATE_MODE_ENTERPRISE_EDITION      3 // 企业版本 Enterprise Edition
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_BACK_STATUS     108
             Param[0] = number      //主叫或被叫号码
             Param[1] = call status //这个通呼叫的状态
			 Param[2] = sAppHandle;
			 #define   MKS_CALL_BACK_STATUS_BEGIN               1   //服务器收到请求
			 #define   MKS_CALL_BACK_STATUS_CALLER_MAKE         2   //开始呼叫主叫
			 #define   MKS_CALL_BACK_STATUS_CALLED_MAKE         3   //开始呼叫被叫
			 #define   MKS_CALL_BACK_STATUS_CALLER_ALERTING     4   //主叫响铃
			 #define   MKS_CALL_BACK_STATUS_CALLED_ALERTING     5   //被叫响铃
			 #define   MKS_CALL_BACK_STATUS_CALLER_ANSWER       6   //主叫接听
			 #define   MKS_CALL_BACK_STATUS_CALLED_ANSWER       7   //被叫接听
			 #define   MKS_CALL_BACK_STATUS_CALLER_HOOK         8   //主叫挂机
			 #define   MKS_CALL_BACK_STATUS_CALLED_HOOK         9   //被叫挂机
			 #define   MKS_CALL_BACK_STATUS_END                 10  //通话结束
			 #define   MKS_CALL_BACK_STATUS_NO_BALANCE          11  //余额不足
			 #define   MKS_CALL_BACK_STATUS_CALLED_BUSY         12  //被叫忙
			 #define   MKS_CALL_BACK_STATUS_CALLED_NO_ANSWER    13  //被叫无人接听
			 #define   MKS_CALL_BACK_STATUS_SYS_BUSY            14  //系统忙，请稍后在拨
			 #define   MKS_CALL_BACK_STATUS_CALLER_NUMBER_ERROR 15  //非法的主叫号码
			 #define   MKS_CALL_BACK_STATUS_CALLED_NUMBER_ERROR 16  //非法的被叫号码
*************************************************/
IT_API SS_SHORT  IT_CallBackIND(
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled,
    IN SS_BYTE const ubCallMode,
    IN SS_BYTE const ubRateMode,
	IN SS_UINT32 const un32AppHandle);
/*************************************************
Function:    IT_CallBackHookIND()
Description: 回拨挂机
Input:       pCaller     主叫号码
Input:       pCalled     被叫号码
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_BACK_HOOK_CFM     134
             Param[0] = Result  //0 成功 其他 失败
			 Param[1] = caller  //主叫
			 Param[2] = called  //被叫
*************************************************/
IT_API SS_SHORT  IT_CallBackHookIND(
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled);


/*
通话功能 注意事项：

//新的呼叫
#define   IT_MSG_CALL_NEW_IND      124
//Param[0] = WoXinID     主叫我信ID
//Param[1] = Caller      主叫号码,可以是我信ID
//Param[2] = CallerName  主叫姓名
//Param[3] = Called      被叫号码,可以是我信ID
//Param[4] = CalledName  被叫姓名
//Param[5] = Sampling    采样率，8000  8K采样   16000 16K采样


//被叫响铃
#define   IT_MSG_CALL_ALERTING_IND  125
//Param[0] = Result  //0 成功 其他 失败

//被叫响铃,要打开放音通道,目前没有用到
#define   IT_MSG_CALL_ALERTING_SDP_IND  126
//Param[0] = Result  //0 成功 其他 失败
//被叫接听
#define   IT_MSG_CALL_CONNECT_IND  129
//Param[0] = Sampling    采样率，8000  8K采样   16000 16K采样
//对方挂机
#define   IT_MSG_CALL_DISCONNECT_IND  130
//Param[0] = Result  //0 成功 其他 失败
//主叫取消呼叫
#define   IT_MSG_CALL_CANCEL_IND       131
//Param[0] = Result  //0 成功 其他 失败
//被叫拒绝接听
#define   IT_MSG_CALL_REFUSE_IND       133
//Param[0] = ReasonCode  //1  被叫主动拒绝 ,  2  被叫没有接听，超时

//每个通话API命令的超时消息
#define   IT_MSG_MAKE_CALL_TIME_OUT       140
#define   IT_MSG_CANCEL_CALL_TIME_OUT     141
#define   IT_MSG_ALERTING_CALL_TIME_OUT   142
#define   IT_MSG_ANSWER_CALL_TIME_OUT     143
#define   IT_MSG_REJECT_CALL_TIME_OUT     144
#define   IT_MSG_RELEASE_CALL_TIME_OUT    145
#define   IT_MSG_DTMF_CALL_TIME_OUT       146

*/

/*************************************************
Function:    IT_SetCallTimeOut()
Description: 设置超时的时常,默认 3 秒
Input:       un32Second   超时的秒
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_SetCallTimeOut(IN SS_UINT32 const un32Second);

/*************************************************
Function:    IT_SetServerIP()
Description: 设置服务器的IP，方便发布开放版、测试版，发布版
Input:       pIP   服务器的IP
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_SetServerIP(IN SS_CHAR const *pIP);


/*************************************************
Function:    IT_MakeCall()
Description: 发起新的呼叫
Input:       pPhone   绑定的手机号码，也就是登录的手机号码
Input:       pCaller  主叫，可以是手机号码，也可以是我信ID
Input:       pCallerName  显示名
Input:       pCalled  被叫，可以是手机号码，也可以是我信ID
Input:       pCalledName  显示名
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_MAKE_CFM     119
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_MakeCall   (
    IN SS_CHAR const*pPhone,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCallerName,
    IN SS_CHAR const*pCalled,
    IN SS_CHAR const*pCalledName);
/*************************************************
Function:    IT_CancelCall()
Description: 取消呼叫
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_CANCEL_CFM      120
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_CancelCall ();

/*************************************************
Function:    IT_AlertingCall()
Description: 发送响铃事件给对方
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_ALERTING_CFM  128
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_AlertingCall ();
/*************************************************
Function:    IT_AnswerCall()
Description: 接听来电
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_ANSWER_CFM      121
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_AnswerCall ();
/*************************************************
Function:    IT_RejectCall()
Description: 拒绝接听
Input:       un32ReasonCode
             1  被叫主动拒绝
             2  被叫没有接听，超时
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_REJECT_CFM      122
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_RejectCall (IN SS_UINT32 const un32ReasonCode);
/*************************************************
Function:    IT_ReleaseCall()
Description: 挂机
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_RELEASE_CFM     123
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_ReleaseCall();

/*************************************************
Function:    IT_DTMF()
Description: 在通过过程中的按键输入
Input:       ubKey  按键值  (0-16)之间
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_CALL_DTMF_CFM     132
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_DTMF(IN SS_BYTE const ubKey);


/*************************************************
Function:    IT_EmptyCallStateMachine()
Description: 清空呼叫状态机
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_EmptyCallStateMachine();

/*************************************************
Function:    IT_SendPCM()
Description: 发送语音给对方
Input:       pPCM         语音缓存的地址
Input:       un32PCMLen   语音缓存的大小
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_SendPCM(IN SS_CHAR const*pPCM,IN SS_UINT32 const un32PCMLen);

/*************************************************
Function:    IT_SetPCMCallBack()
Description: 设置一个回调，收到对方的语音从回调返回
Input:       f_PCMCallBack   回调处理函数
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/

IT_API SS_SHORT  IT_SetPCMCallBack(IN SS_SHORT (*f_PCMCallBack)(IN SS_CHAR const*,IN SS_UINT32 const));

//-------------------------------------------------------------------

/*************************************************
特别说明：IT_UpdateFriend()函数调用不一定会有消息返回，这个函数不调用也有可能
接收到IT_MSG_FRIEND_ICON_MODIFY_IND消息，定义：
//好友的图片修改通知消息
//#define   IT_MSG_FRIEND_ICON_MODIFY_IND  116
//Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
//Param[1] = IconPath 图片文件的路径 
//Param[2] = Phone 手机号码

Function:    IT_UpdateFriend()
Description: 更新好友，APP启动的时候调用这个接口，LIB库自动验证并做同步
Input:       pRecordID    手机通讯录的记录ID
Input:       pName        姓名
Input:       pPhone       手机号码
Input:       un32CreateTime  创建的时间
Input:       un32ModifyTime  修改的时间
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_UpdateFriend(
    IN SS_CHAR   const*pRecordID,
    IN SS_CHAR   const*pName,
    IN SS_CHAR   const*pPhone,
    IN SS_UINT32 const un32CreateTime,
    IN SS_UINT32 const un32ModifyTime);
/*************************************************
Function:    IT_DeleteFriend()
Description: 删除好友的所有信息
Input:       un32RID  记录的唯一ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_DELETE_FRIEND_CFM   118
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = RID    删除的记录的ID
*************************************************/
IT_API SS_SHORT  IT_DeleteFriend(IN SS_UINT32 const un32RID);
/*************************************************
Function:    IT_UpdateFriendRemarkName()
Description: 更新好友的备注名
Input:       un32RID  记录的唯一ID
Input:       pRemark  备注信息
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPDATE_FRIEND_REMARK_NAME_CFM 115
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_UpdateFriendRemarkName(
    IN SS_UINT32 const un32RID,
    IN SS_CHAR   const*pRemark);

/*************************************************
Function:    IT_LoadFriend()
Description: 加载通讯录，异步方式返回
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_FRIEND_CFM 112
             Param[0] == BEGIN 开始  END 结束
             Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
             Param[1] = Phone 手机号码  
             Param[2] = Name  姓名
             Param[3] = Remark 备注名
             Param[4] = RecordID  手机的记录ID
             Param[5] = wo_xin_id 我信ID，有ID表示是我信用户，没有 ID表示不是我信用户
             Param[6] = icon_path 好友大头像的路径
*************************************************/
IT_API SS_SHORT  IT_LoadFriend();
/*************************************************
Function:    IT_LoadWoXinFriend()
Description: 加载通讯录，异步方式返回
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_WOXIN_FRIEND_CFM 152
             Param[0] == BEGIN 开始  END 结束
             Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
             Param[1] = Phone 手机号码  
             Param[2] = Name  姓名
             Param[3] = Remark 备注名
             Param[4] = RecordID  手机的记录ID
             Param[5] = wo_xin_id 我信ID，有ID表示是我信用户，没有 ID表示不是我信用户
             Param[6] = icon_path 好友大头像的路径
*************************************************/
IT_API SS_SHORT  IT_LoadWoXinFriend();
/*************************************************
Function:    IT_LoadCallRecord()
Description: 加载通话记录
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_LOAD_CALL_RECORD_CFM   153
             Param[0] == BEGIN 开始  END 结束
             Param[0] = RID        记录的唯一ID
             Param[1] = Phone      号码，主叫或被叫
			 Param[2] = Result     1 呼入oK  2 呼入未接 3 呼入拒接  4 呼出oK  5 呼出未接 6 呼出拒接 7 回拨oK  8 回拨主叫拒接 9 回拨被叫拒接  10 回拨被叫忙 11 回拨余额不足 12 回拨主叫未接 13 回拨被叫未接  14 回拨主叫忙
             Param[3] = un32Time   通话开始的时间 
             Param[4] = TalkTime   //单位  秒
*************************************************/
IT_API SS_SHORT  IT_LoadCallRecord();
/*************************************************
Function:    IT_AddCallRecord()
Description: 添加通话记录到数据库
Input:       pPhone        号码，主叫或被叫
Input:       ubResult      1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 
Input:       un32Time      通话开始的时间 
Input:       un32TalkTime  通话时长,单位  秒
Output:      nothing
Return:      returns  -1 SS_FAILURE ,-2 SS_ERR_PARAM ,-3 SS_ERR_NO_INIT_DB,大于或等于1为RID 添加成功
Others:      nothing
*************************************************/
IT_API SS_UINT32  IT_AddCallRecord(
    IN SS_CHAR const* pPhone,
    IN SS_BYTE const  ubResult,
    IN SS_UINT32 const un32Time,
    IN SS_UINT32 const un32TalkTime);
/*************************************************
Function:    IT_DelCallRecord()
Description: 删除通话记录
Input:       un32RID  记录ID
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      nothing
*************************************************/
IT_API SS_SHORT  IT_DelCallRecord(IN SS_UINT32 const un32RID);

/*************************************************
Function:    IT_GetFriendIcon()
Description: 获得单个好友图片的接口，异步方式返回
Input:       nothing
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_GET_FRIEND_ICON_CFM 113
             Param[0] = RID   记录的唯一ID，以后所有与它相关的消息都会带有这个ID
             Param[1] = IconPath 图片文件的路径  
*************************************************/
IT_API SS_SHORT  IT_GetFriendIcon(IN SS_UINT32 const un32RID);
/*************************************************
Function:    IT_GetFriendIconEx()
Description: 获得单个好友图片的接口，同步方式返回
Input:       nothing
Output:      nothing
Return:      returns  "" 没有找到相关的数据, "/tmp/a.icon" 图片路径
Others:      nothing
*************************************************/
IT_API SS_CHAR const*IT_GetFriendIconEx(IN SS_UINT32 const un32RID);
/*************************************************
Function:    IT_UploadMyIcon()
Description: 上传自己的大头像
Input:       pIconPath  图片路径 比如 ： "/tmp/a.icon"
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPLOAD_MY_ICON_CFM 114
             Param[0] = Result  //0 成功 其他 失败
             Param[1] = IconPath //大头像保存的路径
*************************************************/
IT_API SS_SHORT  IT_UploadMyIcon(IN SS_CHAR const*pIconPath);

/*************************************************
Function:    IT_UploadPhoneInfo()
Description: 上传手机信息
Input:       usnSysType    系统类型 1 Android ; 2 IOS 
Input:       pPhoneModel   手机型号：如：魅族、三星、苹果4S、苹果5S 等
Input:       pSysVersion   手机操作系统的版本
Output:      nothing
Return:      returns  SS_SUCCESS 执行成功,其它见状态说明
Others:      CFM 消息ID  IT_MSG_UPLOAD_PHONE_INFO_CFM 117
             Param[0] = Result  //0 成功 其他 失败
*************************************************/
IT_API SS_SHORT  IT_UploadPhoneInfo(
    IN SS_USHORT const usnSysType,
    IN SS_CHAR   const*pPhoneModel,
    IN SS_CHAR   const*pSysVersion);



//-------------------------------------------------------------------
IT_API SS_SHORT  IT_SendIMMessage(
    IN SS_CHAR   const*pUser,
    IN SS_CHAR   const*pFriend,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties);  //字体的特效
IT_API SS_SHORT  IT_GetIMNewMessage (IN SS_CHAR const*pUser);
IT_API SS_SHORT  IT_GetIMSynchronous(IN SS_CHAR const*pUser,IN SS_CHAR const*pDataTime);
IT_API SS_SHORT  IT_GetIMSelect(IN SS_CHAR const*pFriend,IN SS_UINT32 const un32CurRID);


IT_API SS_SHORT  IT_SendIMGroupMessage(
    IN SS_CHAR   const*pUser,
    IN SS_CHAR   const*pGroupID,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties);  //字体的特效
IT_API SS_SHORT  IT_GetIMGroupNewMessage (IN SS_CHAR const*pUser,IN SS_CHAR const*pGroupID);
IT_API SS_SHORT  IT_GetIMGroupSynchronous(IN SS_CHAR const*pUser,IN SS_CHAR const*pGroupID,IN SS_CHAR const*pDataTime);
IT_API SS_SHORT  IT_GetIMGroupSelect(IN SS_CHAR const*pGroupID,IN SS_UINT32 const un32CurRID);


//////////////////////////////////////////////////////////////////////////

//获得外网的地址
IT_API SS_CHAR const*const IT_GetPublicIP();
IT_API SS_USHORT           IT_GetPublicPort();


//////////////////////////////////////////////////////////////////////////

//录音相关的函数，目前上层不需要使用，以后在根据实际情况挑战
IT_API SS_SHORT  IT_StartWaveRecord(IN IT_WaveRecordData f_WaveRecordData,IN void *pContext);
IT_API SS_SHORT  IT_StartWavePlay  ();
IT_API SS_SHORT  IT_WavePlay  (IN char const* buf,IN SS_UINT32 un32Size);
IT_API SS_SHORT  IT_StopWaveRecord();
IT_API SS_SHORT  IT_StopWavePlay  ();


//////////////////////////////////////////////////////////////////////////
//pcma  pcmu 的编解码
IT_API SS_UINT8  IT_linear2alaw(IN SS_UINT16 const un16);
IT_API SS_UINT16 IT_alaw2linear(IN SS_UINT8 const un8);
IT_API SS_UINT8  IT_linear2ulaw(IN SS_UINT16 const un16);
IT_API SS_UINT16 IT_ulaw2linear(IN SS_UINT8 const un8);
IT_API SS_UINT8  IT_alaw2ulaw(IN SS_UINT8 const un8);
IT_API SS_UINT8  IT_ulaw2alaw(IN SS_UINT8 const un8);


#ifdef __cplusplus
}  /* end extern "C" */
#endif

#endif // !defined(AFX_IT_LIB_H__B1343414_E238_4806_B5AB_EE30B97B6086__INCLUDED_)
