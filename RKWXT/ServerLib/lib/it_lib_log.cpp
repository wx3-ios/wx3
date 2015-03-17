// it_lib_log.cpp: implementation of the CITLIBLOG class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_log.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_THREAD_MUTEX_T g_s_SSLogMutex;
SSLinkQueue         g_s_SSLogLinkQueue;
SS_CHAR          g_sSSBuf[LOG_MAX_BUF]="";
SS_CHAR           g_sSSWorkDir[2048] = "";
SS_UINT32         g_un32SSDebug = 0;
SS_BYTE           g_ubSSLogScreenDisplay=SS_TRUE;
SS_INT32          g_n32Hour=0;
FILE             *g_s_fp=NULL;


SS_SHORT SS_Log_SetScreenDisplay(IN SS_BYTE const ubState)//SS_TRUE 显示 SS_FALSE 不显示
{
    g_ubSSLogScreenDisplay = ubState;
    return  SS_SUCCESS;
}
static SS_CHAR const*Log_GetLevelString(IN SS_UINT32 const un32Log)
{
    switch (un32Log)
    {
    case SS_LOG_START        :{return "START    ";}break;
    case SS_LOG_STOP         :{return "STOP     ";}break;
    case SS_LOG_ERROR        :{return "ERROR    ";}break;
    case SS_LOG_DEBUG        :{return "DEBUG    ";}break;
    case SS_LOG_REPORT       :{return "REPORT   ";}break;
    case SS_LOG_WARNING      :{return "WARNING  ";}break;
    case SS_LOG_DB           :{return "DB       ";}break;
    case SS_LOG_MEMORY       :{return "MEMORY   ";}break;
    case SS_LOG_TRACE        :{return "TRACE    ";}break;
    case SS_LOG_SIP_INVITE   :{return "INVITE   ";}break;
    case SS_LOG_SIP_ACK      :{return "ACK      ";}break;
    case SS_LOG_SIP_PRACK    :{return "PRACK    ";}break;
    case SS_LOG_SIP_BYE      :{return "BYE      ";}break;
    case SS_LOG_SIP_CANCEL   :{return "CANCEL   ";}break;
    case SS_LOG_SIP_OPTIONS  :{return "OPTIONS  ";}break;
    case SS_LOG_SIP_MESSAGE  :{return "MESSAGE  ";}break;
    case SS_LOG_SIP_INFO     :{return "INFO     ";}break;
    case SS_LOG_SIP_UPDATE   :{return "UPDATE   ";}break;
    case SS_LOG_SIP_REGISTER :{return "REGISTER ";}break;
    case SS_LOG_SIP_REFER    :{return "REFER    ";}break;
    case SS_LOG_SIP_NOTIFY   :{return "NOTIFY   ";}break;
    case SS_LOG_SIP_PUBLISH  :{return "PUBLISH  ";}break;
    case SS_LOG_SIP_SUBSCRIBE:{return "SUBSCRIBE";}break;
    case SS_LOG_STATUS       :{return "STATUS   ";}break;
    case SS_LOG_XML          :{return "XML      ";}break;
        
    default:break;
    }
    return "Unknow";
}
static SS_SHORT LOG_CreateFile(IN  FILE  **s_fp,IN SS_Time *s_pTM)
{
    SS_CHAR    sTime[64] = "";
    SS_UINT32  un32ID=0;
    SS_snprintf(sTime,sizeof(sTime),"%04d%02d%02d%02d",s_pTM->m_n32Year+1900,
        s_pTM->m_n32Mon+1,s_pTM->m_n32Mday,s_pTM->m_n32Hour);

    un32ID = 0;
    SS_Mutex_Lock(&g_s_SSLogMutex);
    memset(g_sSSBuf,0,LOG_MAX_BUF);
    while(1)
    {
        memset(g_sSSBuf,0,LOG_MAX_BUF);
        if (0==un32ID)
        {
            SS_snprintf(g_sSSBuf,LOG_MAX_BUF,"%s%s%s.log",g_sSSWorkDir,SS_PATH,sTime);
        }
        else
        {
            SS_snprintf(g_sSSBuf,LOG_MAX_BUF,"%s%s%s%u.log",g_sSSWorkDir,SS_PATH,sTime,un32ID);
        }
        un32ID++;
        if (*s_fp = fopen(g_sSSBuf,"rb"))
        {
            fclose(*s_fp);
            continue;
        }
        if (NULL == (*s_fp = fopen(g_sSSBuf,"wb")))
        {
            SS_Mutex_UnLock(&g_s_SSLogMutex);
            return SS_FAILURE;
        }
        break;
    }
    SS_Mutex_UnLock(&g_s_SSLogMutex);
    return SS_SUCCESS;
}

SS_SHORT SS_Log_Proc()
{
    SS_UINT32 un32Count=0;
    SS_UINT32 un32_fflush_Count=0;//多少次写入调一次fflush函数
    SS_Time   s_TM;
    time_t    tSeconds=0;
    SS_CHAR   sTime[32] = "";
    PSSLogData  s_pLogData=NULL;
    {
        SS_GET_SECONDS(tSeconds);
        memcpy(&s_TM,(void*)localtime(&tSeconds),sizeof(SS_Time));
        if (g_n32Hour!=s_TM.m_n32Hour)
        {
            g_n32Hour= s_TM.m_n32Hour;
            if (g_s_fp)
            {
                fclose(g_s_fp);
            }
            g_s_fp = NULL;
            LOG_CreateFile(&g_s_fp,&s_TM);
        }
        un32Count=0;
        while(SS_SUCCESS == SS_LinkQueue_ReadData(&g_s_SSLogLinkQueue,(SS_VOID**)&s_pLogData))
        {
            if (NULL == s_pLogData)
            {
                continue;
            }
            if (NULL == s_pLogData->m_s_MSG.m_s)
            {
                free(s_pLogData);
                s_pLogData = NULL;
                continue;
            }
            if (g_s_fp)
            {
                memset(sTime,0,sizeof(sTime));
                SS_Timeval_FormatYearMonthDayHourMinuteSecondMilliseconds(&(s_pLogData->m_s_Time),sTime,sizeof(sTime));

                fprintf(g_s_fp,"%s >> %s ",Log_GetLevelString(s_pLogData->m_ubLevel),sTime);
                
                if (g_ubSSLogScreenDisplay)
                {
                    printf("%s >> %s ",Log_GetLevelString(s_pLogData->m_ubLevel),sTime);
                }
                
                fwrite(s_pLogData->m_s_MSG.m_s,s_pLogData->m_s_MSG.m_len,1,g_s_fp);
                
                if (g_ubSSLogScreenDisplay)
                {
                    printf("%s",s_pLogData->m_s_MSG.m_s);
                }
                
                fwrite("\r\n",2,1,g_s_fp);
                
                if (g_ubSSLogScreenDisplay)
                {
                    printf("\r\n");
                }
                fflush(g_s_fp);
            }
            else
            {
                LOG_CreateFile(&g_s_fp,&s_TM);
            }
            free(s_pLogData->m_s_MSG.m_s);
            free(s_pLogData);
            un32Count++;
            if (un32Count > 100)
            {
                break;
            }
            s_pLogData = NULL;
        }
    }
    return 0;
}



SS_SHORT SS_Log_ModuleInit(IN const char* pWorkDir)
{
    SS_INT32  n32Len=0;
    SS_CHAR   sPath[4096] = "";
    if (NULL == pWorkDir)
    {
        return  SS_ERR_PARAM;
    }
    n32Len=strlen(pWorkDir);

    if (SS_SUCCESS != SS_Mutex_Init(&g_s_SSLogMutex))
    {
        return SS_ERR_ACTION;
    }
    if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_SSLogLinkQueue))
    {
        SS_Mutex_Destroy(&g_s_SSLogMutex);
        return SS_ERR_ACTION;
    }
    if (n32Len >= sizeof(g_sSSWorkDir))
    {
        SS_Mutex_Destroy(&g_s_SSLogMutex);
        SS_LinkQueue_Destroy(&g_s_SSLogLinkQueue);
        return  SS_ERR_PARAM;
    }
    memset(g_sSSBuf,0,LOG_MAX_BUF);
    g_sSSWorkDir[n32Len] = 0;
    memcpy(g_sSSWorkDir,pWorkDir,n32Len);
    if (n32Len >= 2)
    {
        if ('\\' == g_sSSWorkDir[n32Len-1] || '/' == g_sSSWorkDir[n32Len-1])
        {
            g_sSSWorkDir[n32Len-1]=0;
        }
    }
    SS_snprintf(sPath,sizeof(sPath),"%s%s",g_sSSWorkDir,SS_PATH);
    SS_CreatePathFolder(sPath,strlen(sPath));
    g_un32SSDebug=SS_LOG_START_VALUE|SS_LOG_STOP_VALUE|SS_LOG_ERROR_VALUE|SS_LOG_STATUS_VALUE;

    {
        SS_Time   s_TM;
        time_t    tSeconds=0;
        SS_GET_SECONDS(tSeconds);
        memcpy(&s_TM,(void*)localtime(&tSeconds),sizeof(SS_Time));
        g_n32Hour = s_TM.m_n32Hour;
        LOG_CreateFile(&g_s_fp,&s_TM);
    }
    return  SS_SUCCESS;
}

SS_SHORT SS_Log_ModuleFree()
{
    SS_Mutex_Lock(&g_s_SSLogMutex);
    if (g_s_fp)
    {
        fclose(g_s_fp);
    }
    SS_Mutex_UnLock(&g_s_SSLogMutex);
    SS_Mutex_Destroy(&g_s_SSLogMutex);
    return  SS_SUCCESS;
}
SS_SHORT SS_Log_AddMode(IN SS_UINT32 const un32Log)//添加输出日志的模块
{
    switch (un32Log)
    {
    case SS_LOG_START        :{if(!(SS_LOG_START_VALUE        &g_un32SSDebug))g_un32SSDebug|=SS_LOG_START_VALUE        ;}break;
    case SS_LOG_STOP         :{if(!(SS_LOG_STOP_VALUE         &g_un32SSDebug))g_un32SSDebug|=SS_LOG_STOP_VALUE         ;}break;
    case SS_LOG_ERROR        :{if(!(SS_LOG_ERROR_VALUE        &g_un32SSDebug))g_un32SSDebug|=SS_LOG_ERROR_VALUE        ;}break;
    case SS_LOG_DEBUG        :{if(!(SS_LOG_DEBUG_VALUE        &g_un32SSDebug))g_un32SSDebug|=SS_LOG_DEBUG_VALUE        ;}break;
    case SS_LOG_REPORT       :{if(!(SS_LOG_REPORT_VALUE       &g_un32SSDebug))g_un32SSDebug|=SS_LOG_REPORT_VALUE       ;}break;
    case SS_LOG_WARNING      :{if(!(SS_LOG_WARNING_VALUE      &g_un32SSDebug))g_un32SSDebug|=SS_LOG_WARNING_VALUE      ;}break;
    case SS_LOG_DB           :{if(!(SS_LOG_DB_VALUE           &g_un32SSDebug))g_un32SSDebug|=SS_LOG_DB_VALUE           ;}break;
    case SS_LOG_MEMORY       :{if(!(SS_LOG_MEMORY_VALUE       &g_un32SSDebug))g_un32SSDebug|=SS_LOG_MEMORY_VALUE       ;}break;
    case SS_LOG_TRACE        :{if(!(SS_LOG_TRACE_VALUE        &g_un32SSDebug))g_un32SSDebug|=SS_LOG_TRACE_VALUE        ;}break;
    case SS_LOG_SIP_INVITE   :{if(!(SS_LOG_SIP_INVITE_VALUE   &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_INVITE_VALUE   ;}break;
    case SS_LOG_SIP_ACK      :{if(!(SS_LOG_SIP_ACK_VALUE      &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_ACK_VALUE      ;}break;
    case SS_LOG_SIP_PRACK    :{if(!(SS_LOG_SIP_PRACK_VALUE    &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_PRACK_VALUE    ;}break;
    case SS_LOG_SIP_BYE      :{if(!(SS_LOG_SIP_BYE_VALUE      &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_BYE_VALUE      ;}break;
    case SS_LOG_SIP_CANCEL   :{if(!(SS_LOG_SIP_CANCEL_VALUE   &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_CANCEL_VALUE   ;}break;
    case SS_LOG_SIP_OPTIONS  :{if(!(SS_LOG_SIP_OPTIONS_VALUE  &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_OPTIONS_VALUE  ;}break;
    case SS_LOG_SIP_MESSAGE  :{if(!(SS_LOG_SIP_MESSAGE_VALUE  &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_MESSAGE_VALUE  ;}break;
    case SS_LOG_SIP_INFO     :{if(!(SS_LOG_SIP_INFO_VALUE     &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_INFO_VALUE     ;}break;
    case SS_LOG_SIP_UPDATE   :{if(!(SS_LOG_SIP_UPDATE_VALUE   &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_UPDATE_VALUE   ;}break;
    case SS_LOG_SIP_REGISTER :{if(!(SS_LOG_SIP_REGISTER_VALUE &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_REGISTER_VALUE ;}break;
    case SS_LOG_SIP_REFER    :{if(!(SS_LOG_SIP_REFER_VALUE    &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_REFER_VALUE    ;}break;
    case SS_LOG_SIP_NOTIFY   :{if(!(SS_LOG_SIP_NOTIFY_VALUE   &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_NOTIFY_VALUE   ;}break;
    case SS_LOG_SIP_PUBLISH  :{if(!(SS_LOG_SIP_PUBLISH_VALUE  &g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_PUBLISH_VALUE  ;}break;
    case SS_LOG_SIP_SUBSCRIBE:{if(!(SS_LOG_SIP_SUBSCRIBE_VALUE&g_un32SSDebug))g_un32SSDebug|=SS_LOG_SIP_SUBSCRIBE_VALUE;}break;
    case SS_LOG_STATUS       :{if(!(SS_LOG_STATUS_VALUE       &g_un32SSDebug))g_un32SSDebug|=SS_LOG_STATUS_VALUE       ;}break;
    case SS_LOG_XML          :{if(!(SS_LOG_XML_VALUE          &g_un32SSDebug))g_un32SSDebug|=SS_LOG_XML_VALUE          ;}break;
    default:break;
    }
    return  SS_SUCCESS;
}
SS_SHORT SS_Log_DelMode(IN SS_UINT32 const un32Log)//删除输出日志的模块
{
    switch (un32Log)
    {
    case SS_LOG_START        :{if(SS_LOG_START_VALUE        &g_un32SSDebug)g_un32SSDebug^=SS_LOG_START_VALUE        ;}break;
    case SS_LOG_STOP         :{if(SS_LOG_STOP_VALUE         &g_un32SSDebug)g_un32SSDebug^=SS_LOG_STOP_VALUE         ;}break;
    case SS_LOG_ERROR        :{if(SS_LOG_ERROR_VALUE        &g_un32SSDebug)g_un32SSDebug^=SS_LOG_ERROR_VALUE        ;}break;
    case SS_LOG_DEBUG        :{if(SS_LOG_DEBUG_VALUE        &g_un32SSDebug)g_un32SSDebug^=SS_LOG_DEBUG_VALUE        ;}break;
    case SS_LOG_REPORT       :{if(SS_LOG_REPORT_VALUE       &g_un32SSDebug)g_un32SSDebug^=SS_LOG_REPORT_VALUE       ;}break;
    case SS_LOG_WARNING      :{if(SS_LOG_WARNING_VALUE      &g_un32SSDebug)g_un32SSDebug^=SS_LOG_WARNING_VALUE      ;}break;
    case SS_LOG_DB           :{if(SS_LOG_DB_VALUE           &g_un32SSDebug)g_un32SSDebug^=SS_LOG_DB_VALUE           ;}break;
    case SS_LOG_MEMORY       :{if(SS_LOG_MEMORY_VALUE       &g_un32SSDebug)g_un32SSDebug^=SS_LOG_MEMORY_VALUE       ;}break;
    case SS_LOG_TRACE        :{if(SS_LOG_TRACE_VALUE        &g_un32SSDebug)g_un32SSDebug^=SS_LOG_TRACE_VALUE        ;}break;
    case SS_LOG_SIP_INVITE   :{if(SS_LOG_SIP_INVITE_VALUE   &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_INVITE_VALUE   ;}break;
    case SS_LOG_SIP_ACK      :{if(SS_LOG_SIP_ACK_VALUE      &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_ACK_VALUE      ;}break;
    case SS_LOG_SIP_PRACK    :{if(SS_LOG_SIP_PRACK_VALUE    &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_PRACK_VALUE    ;}break;
    case SS_LOG_SIP_BYE      :{if(SS_LOG_SIP_BYE_VALUE      &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_BYE_VALUE      ;}break;
    case SS_LOG_SIP_CANCEL   :{if(SS_LOG_SIP_CANCEL_VALUE   &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_CANCEL_VALUE   ;}break;
    case SS_LOG_SIP_OPTIONS  :{if(SS_LOG_SIP_OPTIONS_VALUE  &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_OPTIONS_VALUE  ;}break;
    case SS_LOG_SIP_MESSAGE  :{if(SS_LOG_SIP_MESSAGE_VALUE  &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_MESSAGE_VALUE  ;}break;
    case SS_LOG_SIP_INFO     :{if(SS_LOG_SIP_INFO_VALUE     &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_INFO_VALUE     ;}break;
    case SS_LOG_SIP_UPDATE   :{if(SS_LOG_SIP_UPDATE_VALUE   &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_UPDATE_VALUE   ;}break;
    case SS_LOG_SIP_REGISTER :{if(SS_LOG_SIP_REGISTER_VALUE &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_REGISTER_VALUE ;}break;
    case SS_LOG_SIP_REFER    :{if(SS_LOG_SIP_REFER_VALUE    &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_REFER_VALUE    ;}break;
    case SS_LOG_SIP_NOTIFY   :{if(SS_LOG_SIP_NOTIFY_VALUE   &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_NOTIFY_VALUE   ;}break;
    case SS_LOG_SIP_PUBLISH  :{if(SS_LOG_SIP_PUBLISH_VALUE  &g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_PUBLISH_VALUE  ;}break;
    case SS_LOG_SIP_SUBSCRIBE:{if(SS_LOG_SIP_SUBSCRIBE_VALUE&g_un32SSDebug)g_un32SSDebug^=SS_LOG_SIP_SUBSCRIBE_VALUE;}break;
    case SS_LOG_STATUS       :{if(SS_LOG_STATUS_VALUE       &g_un32SSDebug)g_un32SSDebug^=SS_LOG_STATUS_VALUE       ;}break;
    case SS_LOG_XML          :{if(SS_LOG_XML_VALUE          &g_un32SSDebug)g_un32SSDebug^=SS_LOG_XML_VALUE          ;}break;
    default:break;
    }
    return  SS_SUCCESS;
}
SS_SHORT SS_Log_EmptyMode()//清空全部输出日志的模块，只输出启动，停止，错误的日志，其它任何日志都不会输出
{
    g_un32SSDebug=SS_LOG_START_VALUE|SS_LOG_STOP_VALUE|SS_LOG_ERROR_VALUE|SS_LOG_STATUS_VALUE;
    return  SS_SUCCESS;
}
SS_SHORT SS_Log_If(IN SS_UINT32 const un32Log)//判断这个LOG模块的日志要不要写入硬盘 SS_TRUE 写入 SS_FALSE 不写入
{
    switch (un32Log)
    {
    case SS_LOG_START        :{return  (SS_LOG_START_VALUE        &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_STOP         :{return  (SS_LOG_STOP_VALUE         &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_ERROR        :{return  (SS_LOG_ERROR_VALUE        &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_DEBUG        :{return  (SS_LOG_DEBUG_VALUE        &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_REPORT       :{return  (SS_LOG_REPORT_VALUE       &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_WARNING      :{return  (SS_LOG_WARNING_VALUE      &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_DB           :{return  (SS_LOG_DB_VALUE           &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_MEMORY       :{return  (SS_LOG_MEMORY_VALUE       &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_TRACE        :{return  (SS_LOG_TRACE_VALUE        &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_INVITE   :{return  (SS_LOG_SIP_INVITE_VALUE   &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_ACK      :{return  (SS_LOG_SIP_ACK_VALUE      &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_PRACK    :{return  (SS_LOG_SIP_PRACK_VALUE    &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_BYE      :{return  (SS_LOG_SIP_BYE_VALUE      &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_CANCEL   :{return  (SS_LOG_SIP_CANCEL_VALUE   &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_OPTIONS  :{return  (SS_LOG_SIP_OPTIONS_VALUE  &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_MESSAGE  :{return  (SS_LOG_SIP_MESSAGE_VALUE  &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_INFO     :{return  (SS_LOG_SIP_INFO_VALUE     &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_UPDATE   :{return  (SS_LOG_SIP_UPDATE_VALUE   &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_REGISTER :{return  (SS_LOG_SIP_REGISTER_VALUE &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_REFER    :{return  (SS_LOG_SIP_REFER_VALUE    &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_NOTIFY   :{return  (SS_LOG_SIP_NOTIFY_VALUE   &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_PUBLISH  :{return  (SS_LOG_SIP_PUBLISH_VALUE  &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_SIP_SUBSCRIBE:{return  (SS_LOG_SIP_SUBSCRIBE_VALUE&g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_STATUS       :{return  (SS_LOG_STATUS_VALUE       &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    case SS_LOG_XML          :{return  (SS_LOG_XML_VALUE          &g_un32SSDebug)?SS_TRUE:SS_FALSE;}break;
    default:break;
    }
    return  SS_FALSE;
}
SS_SHORT  SS_Log_Printf(
    IN SS_BYTE const  ubLevel,
    IN const char* pFile,
    IN const char* pFun,
    IN const SS_UINT32 un32Line,
    IN const char* format, ...)
{
    PSSLogData s_pLogData=NULL;
    SS_INT32 n32Len=0;
    if (NULL == g_sSSBuf)
    {
        return  SS_ERR_ACTION;
    }
    if (NULL == (s_pLogData = (PSSLogData)malloc(sizeof(SSLogData))))
    {
        return  SS_ERR_MEMORY;
    }

    s_pLogData->m_ubLevel = ubLevel;
    SS_GET_NONCE_DATETIME(s_pLogData->m_s_Time);

    SS_Mutex_Lock(&g_s_SSLogMutex);

    n32Len = SS_snprintf(g_sSSBuf,LOG_MAX_BUF,"%s:%u:%s,",pFile,un32Line,pFun);

    va_list paramList;
    va_start(paramList, format);
#ifdef  _WIN32
    
#if  _MSC_VER > 1400
    s_pLogData->m_s_MSG.m_len = vsnprintf_s(g_sSSBuf+n32Len,LOG_MAX_BUF-n32Len,_TRUNCATE,format, paramList);
#else
    s_pLogData->m_s_MSG.m_len = _vsnprintf(g_sSSBuf+n32Len,LOG_MAX_BUF-n32Len,format, paramList);
#endif
    
#else
    s_pLogData->m_s_MSG.m_len = vsnprintf(g_sSSBuf+n32Len,LOG_MAX_BUF-n32Len,format, paramList);
#endif
    va_end(paramList);
	if (-1 == s_pLogData->m_s_MSG.m_len)
	{
		free(s_pLogData);
		return SS_ERR_ACTION;
	}
    s_pLogData->m_s_MSG.m_len+=n32Len;
    if (NULL == (s_pLogData->m_s_MSG.m_s = (SS_CHAR*)malloc(s_pLogData->m_s_MSG.m_len+2)))
    {
        free(s_pLogData);
        SS_Mutex_UnLock(&g_s_SSLogMutex);
        return  SS_ERR_MEMORY;
    }
    s_pLogData->m_s_MSG.m_s[s_pLogData->m_s_MSG.m_len] = 0;
    memcpy(s_pLogData->m_s_MSG.m_s,g_sSSBuf,s_pLogData->m_s_MSG.m_len);

    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_SSLogLinkQueue,(SS_VOID*)s_pLogData))
    {
        free(s_pLogData->m_s_MSG.m_s);
        free(s_pLogData);
        s_pLogData =NULL;
        SS_Mutex_UnLock(&g_s_SSLogMutex);
        return  SS_ERR_MEMORY;
    }
    SS_Mutex_UnLock(&g_s_SSLogMutex);
    return  SS_SUCCESS;
}




