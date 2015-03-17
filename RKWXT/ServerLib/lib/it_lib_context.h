// it_lib_context.h: interface for the CITLibContext class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_CONTEXT_H__F91B14B1_2142_418D_8367_810C7B3ADD35__INCLUDED_)
#define AFX_IT_LIB_CONTEXT_H__F91B14B1_2142_418D_8367_810C7B3ADD35__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

struct IT_Handle;



char* base64_encode(const char* data, int data_len); 
char* base64_decode(const char* data, int data_len); 

typedef struct IT_MSGTimeOutData
{
	SS_UINT32    m_un32MSGID; //消息ID
	SS_UINT64    m_un64Time;  //发送消息的时间
}IT_MSGTimeOutData,*PIT_MSGTimeOutData;

//////////////////////////////////////////////////////////////////////////


typedef struct IT_RecvData
{
    SS_str       m_s_msg;//收到的消息
    SS_CHAR      m_sIP[40];
    SS_USHORT    m_usnPort;
    SS_Socket    m_Socket;
}IT_RecvData,*PIT_RecvData;

typedef struct IT_SendData
{
    SS_str       m_s_msg;//收到的消息
    SS_CHAR      m_sIP[40];
    SS_USHORT    m_usnPort;
    SS_Socket    m_Socket;
}IT_SendData,*PIT_SendData;

//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////
typedef char ** IT_SqliteROW;

typedef struct IT_SqliteNode
{
    IT_SqliteROW m_pCollectValue;//列值
    //char**  m_pCollectValue;        //列值
    int     m_n32CollectCount;      //列数
    struct IT_SqliteNode*m_pPreNode;             //前一节点指针
    struct IT_SqliteNode*m_pNextNode;            //后一节点指针
}IT_SqliteNode,*PIT_SqliteNode;

typedef struct IT_SqliteRES
{
    PIT_SqliteNode m_pHead;                //头节点指针
    PIT_SqliteNode m_pLast;                //尾节点指针
    PIT_SqliteNode m_pCurrent;             //当前节点指针
    int            m_n32Count;             //节点个数
}IT_SqliteRES,*PIT_SqliteRES;

typedef struct IT_Sqlite
{
    sqlite3          *m_hDB;  /*数据库操作句柄*/
}IT_Sqlite,*PIT_Sqlite;



typedef  SS_VOID (*IT_DB_Record)(
        IN  struct IT_Handle *s_pHandle,
        IN  PIT_SqliteRES s_pResult,
        IN  SS_VOID  *ptr,
        IN  SS_UINT32 un32,
        IN  SS_UINT64 un64);//错误的原因

typedef struct IT_DBData
{
    SS_str       m_s_sql;
    SS_VOID     *m_ptr;
    SS_UINT32    m_un32;
    SS_UINT64    m_un64;
    IT_DB_Record m_f_CallBack;
}IT_DBData,*PIT_DBData;

//////////////////////////////////////////////////////////////////////////


typedef SS_SHORT (*ITLib_CallBack)(
    IN SS_UINT32 const un32MSGID,
    IN SS_CHAR **pParam,
    IN SS_UINT32 const un32ParamNumber);

typedef SS_SHORT (*ITLib_PCMCallBack)(
    IN SS_CHAR const *pPCM,
    IN SS_UINT32 const un32PCMLen);



//////////////////////////////////////////////////////////////////////////
//CALL state
//////////////////////////////////////////////////////////////////////////
typedef enum SS_CallStatus{
    CALL_STATE_IDLE                =0,
    CALL_STATE_INVITEING           =1, 
    CALL_STATE_INVITE              =2, 
    CALL_STATE_RINGING             =3, 
    CALL_STATE_ACCEPTED            =4, 
    CALL_STATE_CONNECTEDING        =5, 
    CALL_STATE_CONNECTED           =6, 
    CALL_STATE_DISCONNECTING       =7, 
    CALL_STATE_DISCONNECTED        =8, 
    CALL_STATE_TERMINATED          =9,  
    CALL_STATE_FROM_ACCEPTED       =10,
    CALL_STATE_CANCELLED           =11,
    CALL_STATE_CANCELLING          =12,
    CALL_STATE_UPDATE              =13,
    CALL_STATE_PROCEEDING_TIMEOUT  =14,
    CALL_STATE_MSG_SEND_FAILURE    =15,
    CALL_STATE_TIMEOUT             =16,
    CALL_STATE_REJECTING           =17,
    CALL_STATE_NEW_CALL            =18,
    CALL_STATE_TRANSFERING         =19,  //转接
    CALL_STATE_TRANSFER            =20, //转接
    CALL_STATE_DTMF                =21,
    CALL_STATE_MAKE_CALL           =22,
    CALL_STATE_RINGING_CODEC       =23,   //响铃，但是带语言编码 
    CALL_STATE_REINVITE            =24, 
    CALL_STATE_MODE_T38_IMAGE      =25,
    CALL_STATE_PLAY_SOUND          =26,   //放音，
    CALL_STATE_NEW_AUDIO_RTP       =27,    //所有的资源在这个状态释放
    CALL_STATE_NEW_VIDEO_RTP       =28,    //所有的资源在这个状态释放
    CALL_STATE_FREE_RESOURCE       =29    //所有的资源在这个状态释放
}SS_CallStatus;



typedef enum SS_CallStatusMode{
    Call_Fail_CauseCode_Caller_Not_Register=11,    //主叫没有注册
    Call_Fail_CauseCode_Called_Not_Register=12,    //被叫没有注册
    Call_Fail_CauseCode_Caller_REG_Time_Out=13,    //主叫没有注册
    Call_Fail_CauseCode_Called_REG_Time_Out=14,    //被叫没有注册
    Call_Fail_CauseCode_Caller_Busy        =15,    //主叫忙（一般在通话中）
    Call_Fail_CauseCode_Called_Busy        =16,    //被叫忙（一般在通话中）
    Call_Fail_CauseCode_Caller_Space_No    =17,    //主叫是一个空号
    Call_Fail_CauseCode_Called_Space_No    =18,    //被叫是一个空号
    Call_Fail_CauseCode_Not_Resource       =19,    //没有可用的被叫资源
    Call_Fail_CauseCode_Not_Call_This_Number=20,    //您不允许呼叫此号码 (You are not allowed to call this number)
    Call_Fail_CauseCode_Not_Implemented_Call=21,    //不认识请求的方法,不支持的呼叫类型
    Call_Fail_CauseCode_Call_Called_Time_Out=22,    //呼叫被叫超时
    Call_Fail_CauseCode_ERR_OTHER           =23,    //其它错误
    Call_Fail_CauseCode_DTMF_Time_Out       =24,    //DTMF 超时
    Call_Fail_CauseCode_GIOAS_DISCONNECT    =25,    //GIOAS 没有连接到互联网
    Call_Fail_CauseCode_Caller_Number_Error =26,    //主叫号码错误
    Call_Fail_CauseCode_Called_Number_Error =27,    //被叫号码错误
    Call_Fail_CauseCode_Not_Line            =28,    //没有线路，
    Call_Fail_CauseCode_Switching_Filure_Space_No    =29, //对不起，转接失败，转接电话不存在
    Call_Fail_CauseCode_Switching_Filure_Not_Register=30, //对不起，转接失败，转接电话没有登录
    Call_Fail_CauseCode_Switching_Filure_Busy        =31, //对不起，转接失败，转接电话正在通话中，请稍后在拨
    Call_Fail_CauseCode_Caller_HOOK                  =32, //主叫挂机
    Call_Fail_CauseCode_Called_HOOK                  =33, //被叫挂机
    Call_Fail_CauseCode_Not_Implemented_AUDIO_CODEC  =34, //语音编码不支持
    Call_Fail_CauseCode_Not_Implemented_VIDEO_CODEC  =35, //视频编码不支持
    Call_Fail_CauseCode_SURPASS_THE_BOUND            =36, //超越边界
    Call_Fail_CauseCode_NOT_CAPABILITY               =37, //不具备这样的能力
}SS_CallStatusMode;
//在其他地方定义并实现的函数
//SS_API SS_CHAR const* IT_GetCallStatusString(IN SS_CallStatus const e_CallStatus);

typedef enum {
    DIRECTION_IDLE =0,
    INBOUND_CALL   =1,
    OUTBOUND_CALL  =2,
    INCOMING_CALL  =1,
    OUTGOING_CALL  =2,
    INGRESS_CALL   =1,
    EGRESS_CALL    =2
}SS_CallDirection;

#define   IT_GetCallDirectionString(_Direction_) ((INBOUND_CALL==_Direction_)?"Inbound":(OUTBOUND_CALL==_Direction_)?"Outbound":"Unknow")


typedef struct IT_AudioConfig
{
    SS_Socket m_Socket;
    SS_UINT64   m_un64Code;//编码方式，如：711a 711u g723 g729 gsm ilbc 
    SS_CHAR   m_sIP[64];
    SS_CHAR   m_sCodeCache[512];
    SS_USHORT m_usnPort;
    SS_USHORT m_usnCurPort;//当前
    SS_USHORT m_usnMinPort;//最小
    SS_USHORT m_usnMaxPort;//最大

    SS_CHAR   m_sRemoteIP[64];
    SS_USHORT m_usnRemotePort;
    SS_USHORT m_usnRTPSequenceNumber;

    SS_UINT64 m_un64Milliseconds;//多少毫秒发送一个语音包
    SS_UINT32 m_un32Sampling;//采样率，8000  8K采样   16000 16K采样

    SS_BYTE   m_ubPalyFlag;//放音的标记，缓存语音包使用

//    gsm                           m_s_gsm;
//    SKP_SILK_SDK_EncControlStruct m_s_silk_encoder;
//    SKP_SILK_SDK_DecControlStruct m_s_silk_decoder;
//    iLBC_Enc_Inst_t               m_s_iLBCenc;
//    iLBC_Dec_Inst_t               m_s_iLBCdec;
}IT_AudioConfig,*PIT_AudioConfig;

typedef struct IT_VideoConfig
{
    SS_Socket m_Socket;
    SS_UINT32 m_un32Code;//编码方式，如：h263 h264 mpg4
    SS_CHAR   m_sIP[64];
    SS_CHAR   m_sCodeCache[8192];
    SS_USHORT m_usnPort;
    SS_USHORT m_usnCurPort;//当前
    SS_USHORT m_usnMinPort;//最小
    SS_USHORT m_usnMaxPort;//最大
}IT_VideoConfig,*PIT_VideoConfig;


typedef struct IT_MSGTimeOut
{
	time_t    m_time;
	SS_UINT32 m_un32SellerID;
	SS_UINT32 m_un32AreaID;
	SS_UINT32 m_un32ShopID;
	SS_UINT32 m_un32RedPackageID;
	SS_UINT32 m_un32GoodsID;
	SS_BYTE   m_ubFlag;//SS_TRUE表示发送出去请求消息 SS_FALSE表示没有发送出去请求消息
	SS_str    m_s_OrderCode;
}IT_MSGTimeOut,*PIT_MSGTimeOut;

typedef struct TimeOut
{
	IT_MSGTimeOut  m_s_TimeOutMallAreaInfoIND;
	IT_MSGTimeOut  m_s_TimeOutMallShopInfoIND;
	IT_MSGTimeOut  m_s_TimeOutMallHomeTopBigPictureIND;
	IT_MSGTimeOut  m_s_TimeOutMallHomeTopBigPictureExIND;
	IT_MSGTimeOut  m_s_TimeOutMallHomeNavigationIND;
	IT_MSGTimeOut  m_s_TimeOutMallGuessYouLikeRandomGoodsIND;
	IT_MSGTimeOut  m_s_TimeOutMallCategoryListIND;
	IT_MSGTimeOut  m_s_TimeOutMallSpecialPropertiesCategoryListIND;
	IT_MSGTimeOut  m_s_TimeOutMallPackageIND;
	IT_MSGTimeOut  m_s_TimeOutMallGetRedPackageBalanceIND;
	IT_MSGTimeOut  m_s_TimeOutMallGetSellerAboutInfoIND;
	IT_MSGTimeOut  m_s_TimeOutMallGetShopAboutInfoIND;
	IT_MSGTimeOut  m_s_TimeOutMallGetAreaShopInfoIND;
	IT_MSGTimeOut  m_s_TimeOutMallLoadRedPackageIND;
	IT_MSGTimeOut  m_s_TimeOutMallReceiveRedPackageIND;
	IT_MSGTimeOut  m_s_TimeOutMallUseRedPackageIND;
	IT_MSGTimeOut  m_s_TimeOutMallLoadRedPackageUseRulesIND;
	IT_MSGTimeOut  m_s_TimeOutMallAddOrderIND;
	IT_MSGTimeOut  m_s_TimeOutMallUpdateOrderIND;
	IT_MSGTimeOut  m_s_TimeOutMallDelOrderIND;
	IT_MSGTimeOut  m_s_TimeOutMallLoadOrderIND;
	
	
	
	IT_MSGTimeOut  m_s_TimeOutMallGetGoodsAllIND;
	IT_MSGTimeOut  m_s_TimeOutMallGetGoodsInfoIND;
	//////////////////////////////////////////////////////////////////////////

	IT_MSGTimeOut  m_s_TimeOutOrderRefundIND;
	IT_MSGTimeOut  m_s_TimeOutOrderConfirmIND;
	IT_MSGTimeOut  m_s_TimeOutOrderCancelIND;
	IT_MSGTimeOut  m_s_TimeOutLoadOrderSingleIND;
	IT_MSGTimeOut  m_s_TimeOutOrderRemindersIND;
	IT_MSGTimeOut  m_s_TimeOutSendPayResultIND;
	IT_MSGTimeOut  m_s_TimeOutGetOrderRefundInfoIND;

	IT_MSGTimeOut  m_s_TimeOutGetUnionpaySerialNumberIND;
	IT_MSGTimeOut  m_s_TimeOutGetCreditBalanceIND;
	IT_MSGTimeOut  m_s_TimeOutRechargeIND;
	IT_MSGTimeOut  m_s_TimeOutUpdateBoundMobileNumberIND;
	IT_MSGTimeOut  m_s_TimeOutAboutIND;
	IT_MSGTimeOut  m_s_TimeOutAboutHelp;
	IT_MSGTimeOut  m_s_TimeOutAboutProtocolIND;
	IT_MSGTimeOut  m_s_TimeOutAboutFeedBackIND;
	IT_MSGTimeOut  m_s_TimeOutUpdateREGShopIND;
	IT_MSGTimeOut  m_s_TimeOutReportTokenIND;
	IT_MSGTimeOut  m_s_TimeOutRegister;
	IT_MSGTimeOut  m_s_TimeOutUnregister;
	IT_MSGTimeOut  m_s_TimeOutLogin;
	IT_MSGTimeOut  m_s_TimeOutLogout;
	IT_MSGTimeOut  m_s_TimeOutUpdatePassword;
	IT_MSGTimeOut  m_s_TimeOutFindPassword;
	IT_MSGTimeOut  m_s_TimeOutReportVersionIND;
	IT_MSGTimeOut  m_s_TimeOutUpdateCPUID;
	IT_MSGTimeOut  m_s_TimeOutGetBalance;
//	IT_MSGTimeOut  m_s_TimeOutGetUserData;
	

}TimeOut,*PTimeOut;


typedef struct IT_Config
{
    SS_str         m_s_UserName;
    SS_str         m_s_UserNo;
    SS_str         m_s_Phone;
    SS_str         m_s_UserPassword;
    
    SS_str         m_s_PhoneTemp;
    SS_str         m_s_UserPasswordTemp;//修改密码的时候用

    //IT_VideoConfig m_s_VideoConfig;//视频配置
    //IT_AudioConfig m_s_AudioConfig;//语音配置
    SS_str         m_s_DBPath;//数据库保存的目录
    SS_str         m_s_DBFilesPath;//数据库保存的文件，绝对路径
    SS_Protocol    m_e_Protocol;//初始化的协议
    //本地要绑定IP
    SS_str         m_s_IP;
    //如果是SIP协议，这个就是SIP绑定的信令端口
    SS_USHORT      m_usnSIPPort;
    SS_UINT32      m_un32SIPRegisterTime;
    //服务器的IP和端口,注册服务器、登录服务器等
    SS_str         m_s_ServerIP;
	SS_str         m_s_ServerDomain;//服务器域名
    SS_USHORT      m_usnServerPort;
    SS_str         m_s_LogPath;
	//多少毫秒没有收到回复消息，表示超时，WINDOWS 1000等于一秒，LINUX 1000000等于一秒
	SS_UINT32      m_un32MessageTimeOut;

}IT_Config,*PIT_Config;



typedef struct IT_Handle
{
	SS_BYTE    m_ubGetUserDataFlag;
	SS_UINT32  m_un32APITimeOut;
	TimeOut    m_s_TimeOut;
    SS_UINT32  m_un32CallMSNode;
    SS_UINT32  m_un32CallREGNode;
    SS_UINT32  m_un32CallITNode;

    IT_AudioConfig     m_s_AudioConfig;
    IT_VideoConfig     m_s_VideoConfig;
    SS_CallStatus      m_e_CallStatus;
    SS_CallDirection   m_e_Direction;
    SS_UINT32          m_un32CallID;
    time_t             m_CallTimeOut;
    //保存最后呼叫命令的ID，在命令超时的时候用
    SS_UINT32          m_un32CallCMD;

    //APP设置的呼叫超时的时间，单位： 秒
    //默认 3 秒
    time_t             m_un32CallTimeOut;
	SS_BYTE            m_ubNetworkMode;//保存当前网络连接的模式 0是没有网络 1是WIFI 2是2G 3是3G 4是4G 5是5G 6是不知道是什么网络
    /*
    呼叫过程中的我信ID，呼出的时候是被叫的我信ID，呼入的时候是主叫的我信ID
    */
    SS_UINT64          m_un64CallWoXinID;
    //用户自己的我信ID
    SS_UINT64    m_un64WoXinID;
    SS_UINT32    m_un32SellerID;//商家ID
    IT_Config    m_s_Config;
    SS_USHORT    m_usnPhoneModel;//手机类型，安卓，IOS等
    SS_str       m_s_IconPath;
    //SIP 本地侦听句柄,UDP or TCP
    //SS TCP
    //信令、消息、通信句柄
    SS_Socket         m_SignalScoket;//
    //SIP 本地侦听句柄,UDP
    //SS UDP
    //语音通信句柄
    SS_Socket         m_AudioScoket;//
    //SIP 本地侦听句柄,UDP
    //SS UDP
    //视频通信句柄
    SS_Socket         m_VideoScoket;//
    //线程句柄和状态
    volatile SS_SHORT m_snThreadState;
    SS_THREAD_T       m_h_Threadhandle;
	//应用层发命令，不需要即时处理，放到这个队列  Slowly treatment
	SSLinkQueue       m_s_SlowlyTreatmentLinkQueue;
	SS_UINT32         m_un32SlowlyTreatmentTime;//多少毫秒处理一个一个消息，WINDOWS 1000等于一秒，LINUX 1000000等于一秒

	SSLinkQueue       m_s_MSGTimeOutLinkQueue;
	//应用层发命令到这个队列
    SSLinkQueue       m_s_SendLinkQueue;
    //网络层接收到的命令和消息到这个队列
    SSLinkQueue       m_s_RecvLinkQueue;
	//回调的消息队列
	SSLinkQueue       m_s_CallBackLinkQueue;
    //数据库相关的操作
    SSLinkQueue       m_s_DBLinkQueue;
    //PCM 队列，APP 发送语音的队列
    SSLinkQueue       m_s_PCMLinkQueue;
    //PCM 队列，APP 发送语音的队列
    SSRTPQueue       m_s_RTPQueue;
    //这个库与应用层调用临界资源的锁
    SS_THREAD_MUTEX_T m_s_Mutex;
    //网络连接的状态
    SS_ITStatus       m_e_ITStatus;
    SS_BYTE           m_ubAutoConnectServerFlag;//SS_TRUE 自动重连  SS_FALSE 不自动重连
    IT_Sqlite    m_s_SqliteDB;
	//连接服务器线程句柄和状态
	volatile SS_SHORT m_snConnectThreadState;
	SS_THREAD_T       m_h_ConnectThreadhandle;

    ITLib_CallBack     m_f_CallBack;
    ITLib_PCMCallBack  m_f_PCMCallBack;

    //支持的编码协议
    SS_Audio  m_s_Audio;
    //支持的编码协议
    SS_Video  m_c_Video;

    SS_CHAR   m_sIP[SS_IP_SIZE+1];
    SS_USHORT m_usnPort;

    SS_UINT32  m_un32DB_BookRID;
    SS_UINT32  m_un32DB_CallRecordRID;
    

    SS_str     m_s_realm;
    SS_str     m_s_nonce;
    SS_str     m_s_stale;
    SS_str     m_s_algorithm;
    SS_str     m_s_qop;
    SS_UINT32  m_un32CSeq;
    SS_UINT32  m_un32Expires;

    time_t     m_SIPTimeout;
    time_t     m_SIPTime;
    time_t     m_HeartBeatTime;

    SS_CHAR    m_sRecvBuf[4096];

}IT_Handle,*PIT_Handle;

SS_SHORT  IT_CheckConfig(IN PIT_Config s_pConfig);
SS_SHORT  IT_CopyConfig (IN PIT_Config s_pSource,IN PIT_Config s_pDest);
SS_SHORT  IT_CopyAudioConfig (IN PIT_AudioConfig s_pSource,IN PIT_AudioConfig s_pDest);
SS_SHORT  IT_CopyVideoConfig (IN PIT_VideoConfig s_pSource,IN PIT_VideoConfig s_pDest);
SS_SHORT  IT_ConnectServer(IN PIT_Handle s_pHandle);
SS_SHORT  IT_SendMessageToServer(IN PIT_Handle s_pHandle);
SS_SHORT  IT_RecvMessageFromServer(IN PIT_Handle s_pHandle);
SS_SHORT  IT_RecvUDPFromServer(IN PIT_Handle s_pHandle);
SS_SHORT  IT_ProcRecvMessage(IN PIT_Handle s_pHandle);
SS_SHORT  IT_ScanCallStatus(IN PIT_Handle s_pHandle);
SS_SHORT  IT_ScanREGStatus(IN PIT_Handle s_pHandle);


SS_SHORT  IT_FreeCallResource();


#endif // !defined(AFX_IT_LIB_CONTEXT_H__F91B14B1_2142_418D_8367_810C7B3ADD35__INCLUDED_)
