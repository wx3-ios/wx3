// it_lib_log.h: interface for the CITLIBLOG class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_LOG_H__3ED936BD_11F6_4420_8868_F4C0341A2AA0__INCLUDED_)
#define AFX_IT_LIB_LOG_H__3ED936BD_11F6_4420_8868_F4C0341A2AA0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define SS_LOG_START         0       /* 系统在启动过程的显示*/
#define SS_LOG_STOP          1       /* 系统在停止过程的显示*/
#define SS_LOG_ERROR         2
#define SS_LOG_DEBUG         3      /* 追踪有关于全部的操作的信息*/
#define SS_LOG_REPORT        4      /* 报告有关于工作状态相关的操作的信息，也就是每隔多长时间报告一次*/
#define SS_LOG_WARNING       5      /* 报告有关于一些警告信息，这些信息绝对不会影响到服务器的正常运行相关的操作的信息*/
#define SS_LOG_DB            6      /* 数据库日志*/
#define SS_LOG_MEMORY        7      /* 分配或动态申请内存错误*/
#define SS_LOG_TRACE         8
#define SS_LOG_SIP_INVITE    9
#define SS_LOG_SIP_ACK       10
#define SS_LOG_SIP_BYE       11
#define SS_LOG_SIP_CANCEL    12
#define SS_LOG_SIP_OPTIONS   13
#define SS_LOG_SIP_MESSAGE   14
#define SS_LOG_SIP_INFO      15
#define SS_LOG_SIP_UPDATE    16
#define SS_LOG_SIP_REGISTER  17
#define SS_LOG_SIP_REFER     18
#define SS_LOG_SIP_NOTIFY    19
#define SS_LOG_SIP_PUBLISH   20
#define SS_LOG_SIP_SUBSCRIBE 21
#define SS_LOG_STATUS        22
#define SS_LOG_XML           23
#define SS_LOG_SIP_PRACK     24



#define SS_LOG_START_VALUE         (1<<0)
#define SS_LOG_STOP_VALUE          (1<<1)
#define SS_LOG_ERROR_VALUE         (1<<2)
#define SS_LOG_DEBUG_VALUE         (1<<3)
#define SS_LOG_REPORT_VALUE        (1<<4)
#define SS_LOG_WARNING_VALUE       (1<<5)
#define SS_LOG_DB_VALUE            (1<<6)
#define SS_LOG_MEMORY_VALUE        (1<<7)
#define SS_LOG_TRACE_VALUE         (1<<8)
#define SS_LOG_SIP_INVITE_VALUE    (1<<9)
#define SS_LOG_SIP_ACK_VALUE       (1<<10)
#define SS_LOG_SIP_BYE_VALUE       (1<<11)
#define SS_LOG_SIP_CANCEL_VALUE    (1<<12)
#define SS_LOG_SIP_OPTIONS_VALUE   (1<<13)
#define SS_LOG_SIP_MESSAGE_VALUE   (1<<14)
#define SS_LOG_SIP_INFO_VALUE      (1<<15)
#define SS_LOG_SIP_UPDATE_VALUE    (1<<16)
#define SS_LOG_SIP_REGISTER_VALUE  (1<<17)
#define SS_LOG_SIP_REFER_VALUE     (1<<18)
#define SS_LOG_SIP_NOTIFY_VALUE    (1<<19)
#define SS_LOG_SIP_PUBLISH_VALUE   (1<<20)
#define SS_LOG_SIP_SUBSCRIBE_VALUE (1<<21)
#define SS_LOG_STATUS_VALUE        (1<<22)
#define SS_LOG_XML_VALUE           (1<<23)
#define SS_LOG_SIP_PRACK_VALUE     (1<<24)


#define SS_START_LOG          SS_LOG_START        ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_STOP_LOG           SS_LOG_STOP         ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_ERROR_LOG          SS_LOG_ERROR        ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_DEBUG_LOG          SS_LOG_DEBUG        ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_REPORT_LOG         SS_LOG_REPORT       ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_WARNING_LOG        SS_LOG_WARNING      ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_DB_LOG             SS_LOG_DB           ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_MEMORY_LOG         SS_LOG_MEMORY       ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_TRACE_LOG          SS_LOG_TRACE        ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_INVITE_LOG     SS_LOG_SIP_INVITE   ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_ACK_LOG        SS_LOG_SIP_ACK      ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_BYE_LOG        SS_LOG_SIP_BYE      ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_CANCEL_LOG     SS_LOG_SIP_CANCEL   ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_OPTIONS_LOG    SS_LOG_SIP_OPTIONS  ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_MESSAGE_LOG    SS_LOG_SIP_MESSAGE  ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_INFO_LOG       SS_LOG_SIP_INFO     ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_UPDATE_LOG     SS_LOG_SIP_UPDATE   ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_REGISTER_LOG   SS_LOG_SIP_REGISTER ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_REFER_LOG      SS_LOG_SIP_REFER    ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_NOTIFY_LOG     SS_LOG_SIP_NOTIFY   ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_PUBLISH_LOG    SS_LOG_SIP_PUBLISH  ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_SUBSCRIBE_LOG  SS_LOG_SIP_SUBSCRIBE,__FILE__,__FUNCTION__,__LINE__
#define SS_STATUS_LOG         SS_LOG_STATUS       ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_XML_LOG            SS_LOG_XML          ,__FILE__,__FUNCTION__,__LINE__ 
#define SS_SIP_PRACK_LOG      SS_LOG_SIP_PRACK    ,__FILE__,__FUNCTION__,__LINE__ 



typedef struct SSLogData
{
    SS_BYTE     m_ubLevel;
    SS_Timeval  m_s_Time;
    SS_str      m_s_MSG;
}SSLogData,*PSSLogData;


SS_SHORT SS_Log_ModuleInit(IN const char* pWorkDir);
SS_SHORT SS_Log_ModuleFree();
SS_SHORT SS_Log_Proc();
SS_SHORT SS_Log_SetScreenDisplay(IN SS_BYTE const ubState);//SS_TRUE 显示 SS_FALSE 不显示
SS_SHORT SS_Log_AddMode(IN SS_UINT32 const un32Log);//添加输出日志的模块
SS_SHORT SS_Log_DelMode(IN SS_UINT32 const un32Log);//删除输出日志的模块
SS_SHORT SS_Log_EmptyMode();//清空全部输出日志的模块，只输出启动，停止，错误的日志，其它任何日志都不会输出
SS_SHORT SS_Log_If(IN SS_UINT32 const un32Log);//判断这个LOG模块的日志要不要写入硬盘 SS_TRUE 写入 SS_FALSE 不写入
SS_SHORT SS_Log_Printf(
    IN SS_BYTE const  ubLevel,
    IN const char* pFile,
    IN const char* pFun,
    IN const SS_UINT32 un32Line,
    IN const char* format, ...);

#endif // !defined(AFX_IT_LIB_LOG_H__3ED936BD_11F6_4420_8868_F4C0341A2AA0__INCLUDED_)
