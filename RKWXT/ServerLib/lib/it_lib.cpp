#include "stdafx.h"
#include "it_lib.h"

#ifdef   IT_ANDROID_BIND

#include <jni.h>
#include <android/log.h>

#endif
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


IT_Handle  g_s_ITLibHandle;


SS_SHORT  IT_SetSellerID(IN  SS_UINT32 const un32SellerID)
{
	SS_Log_Printf(SS_STATUS_LOG,"set seller id is %u",un32SellerID);
	g_s_ITLibHandle.m_un32SellerID = un32SellerID;
	return  SS_SUCCESS;
}
SS_UINT32 IT_GetSellerID()
{
	return  g_s_ITLibHandle.m_un32SellerID;
}
SS_SHORT      IT_SetWoXinID(IN  SS_CHAR const*pLoginID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL==pLoginID)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pLoginID))
    {
        return SS_ERR_PARAM;
    }
	SS_aToun64(pLoginID,g_s_ITLibHandle.m_un64WoXinID);
	SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo);
	SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo,pLoginID);
	SS_Log_Printf(SS_STATUS_LOG,"set woxin id is %s",pLoginID);
    return  IT_DBSetLoginID(pLoginID);
}
SS_CHAR const*IT_GetWoXinID(OUT SS_CHAR *pLoginID,IN SS_UINT32 const un32Size)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pLoginID || 0 == un32Size)
    {
        return  "";
    }
    if (g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        memcpy(pLoginID,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,
            g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_len);
        return pLoginID;;
    }
    return  IT_DBGetLoginID(pLoginID,un32Size);
}
SS_SHORT      IT_SetLoginPassWord(IN  SS_CHAR const*pPassWord)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pPassWord)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassWord))
    {
        return  SS_ERR_PARAM;
    }
    return  IT_DBSetLoginPassWord(pPassWord);
}
SS_CHAR const*IT_GetLoginPassWord(OUT SS_CHAR *pPassWord,IN SS_UINT32 const un32Size)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pPassWord || 0 == un32Size)
    {
        return  "";
    }
    if (g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_s)
    {
        memcpy(pPassWord,g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_s,
            g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_len);
        return pPassWord;;
    }
    return  IT_DBGetLoginPassWord(pPassWord,un32Size);
}

SS_SHORT      IT_SetPhoneNumber(IN  SS_CHAR const*pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    return  IT_DBSetPhoneNumber(pPhone);
}

SS_CHAR const*IT_GetPhoneNumber(OUT SS_CHAR *pPhone,IN SS_UINT32 const un32Size)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pPhone || 0 == un32Size || un32Size <= g_s_ITLibHandle.m_s_Config.m_s_Phone.m_len)
    {
        return  "";
    }
    if (g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s)
    {
        memcpy(pPhone,g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,
            g_s_ITLibHandle.m_s_Config.m_s_Phone.m_len);
        return pPhone;;
    }
    return  IT_DBGetPhoneNumber(pPhone,un32Size);
}

SS_UINT8  IT_linear2alaw(IN SS_UINT16 const un16)
{
    return  ss_audio_g711_linear2alaw(un16);
}
SS_UINT16 IT_alaw2linear(IN SS_UINT8 const un8)
{
    return  ss_audio_g711_alaw2linear(un8);
}
SS_UINT8  IT_linear2ulaw(IN SS_UINT16 const un16)
{
    return  ss_audio_g711_linear2ulaw(un16);
}
SS_UINT16 IT_ulaw2linear(IN SS_UINT8 const un8)
{
    return  ss_audio_g711_ulaw2linear(un8);
}
SS_UINT8  IT_alaw2ulaw(IN SS_UINT8 const un8)
{
    return  ss_audio_g711_alaw2ulaw(un8);
}
SS_UINT8  IT_ulaw2alaw(IN SS_UINT8 const un8)
{
    return  ss_audio_g711_ulaw2alaw(un8);
}




SS_SHORT ITLIB_ThreadSIPProc(IN PIT_Handle s_pHandle)
{
    if (SS_SUCCESS != IT_SendMessageToServer(s_pHandle))
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_RecvMessageFromServer(s_pHandle))
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_ProcRecvMessage(s_pHandle))
    {
        return  SS_SUCCESS;
    }
    switch(s_pHandle->m_e_ITStatus)
    {
    case IT_STATUS_IDLE    ://=  0,
    case IT_STATUS_REG_SERVER_DISCONNECT_OK:
        {
            IT_ConnectServer(s_pHandle);
            SS_USLEEP(500000);
            return  SS_SUCCESS;
        }break;
    case IT_STATUS_ON_LINE ://=  1,
    case IT_STATUS_DISTANCE://=  3,
    case IT_STATUS_BUSY    ://=  4,
    case IT_STATUS_CALL    ://=  5,
    case IT_STATUS_STEALTH ://=  6,
    case IT_STATUS_NOT_BOTHER://=7 
        {
        }break;
    default:break;
    }
    if (SS_SUCCESS != IT_ScanCallStatus(s_pHandle))
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_ScanREGStatus(s_pHandle))
    {
        return  SS_SUCCESS;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITLIB_ThreadH323Proc(IN PIT_Handle s_pHandle)
{
    return  SS_SUCCESS;
}

#ifdef WIN32
DWORD WINAPI __ITLIB_ConnectThread(LPVOID lpParameter)
#else
void * __ITLIB_ConnectThread(void * lpParameter)
#endif
{
	PIT_Handle s_pHandle = (PIT_Handle)lpParameter;
	SS_Log_Printf(SS_START_LOG,"ITLIB connect Thread start OK");
	SS_Mutex_Lock(&s_pHandle->m_s_Mutex);
	s_pHandle->m_snConnectThreadState = SS_THREAD_STATE_RUNING;
	SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
	IT_Connect();
	SS_Mutex_Lock(&s_pHandle->m_s_Mutex);
	s_pHandle->m_snConnectThreadState = SS_THREAD_STATE_EXIT;
	SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
	SS_Log_Printf(SS_START_LOG,"ITLIB connect Thread exit OK");
	return 0;
}

SS_SHORT ITLIB_ThreadSSProc(IN PIT_Handle s_pHandle)
{
	IT_ProcRecvMessage(s_pHandle);
    if(IT_STATUS_REG_SERVER_DISCONNECT_OK == s_pHandle->m_e_ITStatus)
    {
        if (s_pHandle->m_ubAutoConnectServerFlag)
        {
			SS_Mutex_Lock(&s_pHandle->m_s_Mutex);
			if (SS_THREAD_STATE_IDLE==s_pHandle->m_snConnectThreadState||
				SS_THREAD_STATE_EXIT==s_pHandle->m_snConnectThreadState)
			{
				s_pHandle->m_snConnectThreadState = SS_THREAD_STATE_START;
#ifdef  _WIN32
				if (NULL == (s_pHandle->m_h_ConnectThreadhandle = ::CreateThread(NULL,0,
					__ITLIB_ConnectThread,s_pHandle,0,NULL)))
#else
				if (0 != pthread_create(&s_pHandle->m_h_ConnectThreadhandle,NULL,
					__ITLIB_ConnectThread,s_pHandle))
#endif
				{
					SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
					SS_Log_Printf(SS_START_LOG,"Create IT __ITLIB_ConnectThread fail");
					return SS_SUCCESS;
				}
			}
			SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
			SS_USLEEP(100000);
			return SS_SUCCESS;
        }
        else
        {
			SS_Log_Printf(SS_START_LOG,"Auto connect server flag is false");
			SS_USLEEP(100000);
            return SS_SUCCESS;
        }
    }
	else if(IT_STATUS_CONNECT_REG_SERVER_OK==s_pHandle->m_e_ITStatus)
	{
		IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_CONNECT_OK);
		if (g_s_ITLibHandle.m_ubGetUserDataFlag&&g_s_ITLibHandle.m_un64WoXinID)
		{
			ITREG_GetUserData(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
		}
	}

    IT_SendHeartBeat();
    IT_SendMessageToServer(s_pHandle);
    IT_RecvMessageFromServer(s_pHandle);
    IT_RecvUDPFromServer(s_pHandle);
    return  SS_SUCCESS;
}

#ifdef   IT_ANDROID_BIND

extern  JavaVM    *g_jvm;
extern  jobject    g_obj;
extern  JNIEnv    *g_env;
extern  jclass     g_cls;
extern  jmethodID  g_mid;
extern  jmethodID  g_midPCM;

#endif




#ifdef WIN32
DWORD WINAPI __ITLIB_Thread(LPVOID lpParameter)
#else
void * __ITLIB_Thread(void * lpParameter)
#endif
{
    PIT_Handle s_pHandle = (PIT_Handle)lpParameter;
    time_t      time=0;
    SS_CHAR   sSecodes[45] = "";
    SS_CHAR  *Param[5];
    SS_Log_Printf(SS_START_LOG,"ITLIB Thread start OK");


	if (0 == g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_len)
	{
		SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain,"load.67call.com");
	}
	SS_TCP_getRemoterHostIP(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_s,sSecodes,sizeof(sSecodes));
	if (sSecodes[0])
	{
		SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerIP,sSecodes);
	}
	memset(sSecodes,0,sizeof(sSecodes));


#ifdef   IT_ANDROID_BIND
    SS_Log_Printf(SS_START_LOG,"AttachCurrentThread java vm");
    //Attach主线程
    if((*g_jvm)->AttachCurrentThread(g_jvm, &g_env, NULL) != JNI_OK)
    {
        SS_Log_Printf(SS_START_LOG,"AttachCurrentThread java vm fail");
        SS_Log_Printf(SS_START_LOG,"ITLIB Thread Exit");
        s_pHandle->m_snThreadState = SS_THREAD_STATE_EXIT;
        return NULL;
    }
    SS_Log_Printf(SS_START_LOG,"GetObjectClass ");
    //找到对应的类
    if(NULL == (g_cls = (*g_env)->GetObjectClass(g_env,g_obj)))
    {
        SS_Log_Printf(SS_START_LOG,"GetObjectClass  fail");
        goto Attach_Jvm_error;
    }
    //再获得类中的方法
    SS_Log_Printf(SS_START_LOG,"GetStaticMethodID,WoXinCallback,(I[Ljava/lang/String;I)V");
    if (NULL == (g_mid = (*g_env)->GetStaticMethodID(g_env,  g_cls,"WoXinCallback","(I[Ljava/lang/String;I)V")))
    {
        SS_Log_Printf(SS_START_LOG,"GetStaticMethodID fail,WoXinCallback,(I[Ljava/lang/String;I)V");
        goto Attach_Jvm_error;
    }

    SS_Log_Printf(SS_START_LOG,"GetStaticMethodID,WoXinPCMCallback,([BI)V");
    if (NULL == (g_midPCM = (*g_env)->GetStaticMethodID(g_env,g_cls,"WoXinPCMCallback","([BI)V")))
    {
        SS_Log_Printf(SS_START_LOG,"GetStaticMethodID fail,WoXinPCMCallback,([BI)V");
        goto Attach_Jvm_error;
    }

#endif
    s_pHandle->m_ubAutoConnectServerFlag = SS_TRUE;
    s_pHandle->m_SignalScoket = SS_SOCKET_ERROR;
    s_pHandle->m_e_ITStatus   = IT_STATUS_REG_SERVER_DISCONNECT_OK;
//    IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
    s_pHandle->m_snThreadState = SS_THREAD_STATE_RUNING;
    while(SS_THREAD_STATE_RUNING == s_pHandle->m_snThreadState)
    {
        switch(s_pHandle->m_s_Config.m_e_Protocol)
        {
        case SS_PROTOCOL_SIP:
            {
                ITLIB_ThreadSIPProc(s_pHandle);
            }break;
        case SS_PROTOCOL_SS:
            {
                ITLIB_ThreadSSProc(s_pHandle);
            }break;
        case SS_PROTOCOL_H323:
            {
                ITLIB_ThreadH323Proc(s_pHandle);
            }break;
        default:break;
        }
        SS_Log_Proc();
        if (g_s_ITLibHandle.m_un32CallCMD)
        {
            SS_GET_SECONDS(time);
            if ((time-g_s_ITLibHandle.m_CallTimeOut) >= g_s_ITLibHandle.m_un32CallTimeOut)
            {
                memset(sSecodes,0,sizeof(sSecodes));
                SS_snprintf(sSecodes,sizeof(sSecodes),"%u",g_s_ITLibHandle.m_un32CallTimeOut);
                Param[0] = sSecodes;
                Param[1] = NULL;
                s_pHandle->m_f_CallBack(g_s_ITLibHandle.m_un32CallCMD,Param,1);
                if (IT_MSG_DTMF_CALL_TIME_OUT != g_s_ITLibHandle.m_un32CallCMD)
                {
                    IT_FreeCallResource();
                }
            }
        }
    }

#ifdef   IT_ANDROID_BIND
Attach_Jvm_error:
    if(g_jvm)
    {
        if((*g_jvm)->DetachCurrentThread(g_jvm) != JNI_OK)
        {
            SS_Log_Printf(SS_STOP_LOG,"DetachCurrentThread java vm fail");
        }
        else
        {
            SS_Log_Printf(SS_STOP_LOG,"DetachCurrentThread java vm oK");
        }
    }
#endif

    SS_Log_Printf(SS_STOP_LOG,"ITLIB Thread Exit");
    s_pHandle->m_snThreadState = SS_THREAD_STATE_EXIT;
    return  0;
}



SS_SHORT             IT_InitConfig(
    IN  SS_CHAR  *pProtocol,//初始化的协议
    IN  SS_CHAR  *pLogPath)//日志路径
{
    SS_CHAR  sLogPath[8192] = "";
	SS_CHAR  sIP[128] = "";
    SS_UINT32 un32Len = 0;
    memset(&g_s_ITLibHandle,0,sizeof(IT_Handle));
    if (NULL == pProtocol || NULL == pLogPath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pProtocol) || 0 == strlen(pLogPath))
    {
        return  SS_ERR_PARAM;
    }
	g_s_ITLibHandle.m_un32APITimeOut = IT_MESSAGE_MAX_TIME_OUT;
	SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain,"load.67call.com");
	SS_GET_SECONDS(g_s_ITLibHandle.m_un32SlowlyTreatmentTime);
    g_s_ITLibHandle.m_un32CallTimeOut = 3;
    g_s_ITLibHandle.m_SignalScoket = SS_SOCKET_ERROR;
    g_s_ITLibHandle.m_ubAutoConnectServerFlag = SS_TRUE;
    g_s_ITLibHandle.m_s_AudioConfig.m_Socket = SS_SOCKET_ERROR;
    g_s_ITLibHandle.m_s_AudioConfig.m_un64Code = 0;
    g_s_ITLibHandle.m_s_AudioConfig.m_usnPort  = 0;
    g_s_ITLibHandle.m_s_AudioConfig.m_usnMinPort=2050 ;//最小
    g_s_ITLibHandle.m_s_AudioConfig.m_usnCurPort = g_s_ITLibHandle.m_s_AudioConfig.m_usnMinPort;
    g_s_ITLibHandle.m_s_AudioConfig.m_usnMaxPort=20500;//最大
    strncpy(g_s_ITLibHandle.m_s_AudioConfig.m_sIP,"0.0.0.0",sizeof(g_s_ITLibHandle.m_s_AudioConfig.m_sIP));

    g_s_ITLibHandle.m_s_VideoConfig.m_Socket = SS_SOCKET_ERROR;
    g_s_ITLibHandle.m_s_VideoConfig.m_un32Code = 0;
    g_s_ITLibHandle.m_s_VideoConfig.m_usnPort  = 0;
    g_s_ITLibHandle.m_s_VideoConfig.m_usnMinPort=20500;//最小
    g_s_ITLibHandle.m_s_VideoConfig.m_usnCurPort = g_s_ITLibHandle.m_s_VideoConfig.m_usnMinPort;
    g_s_ITLibHandle.m_s_VideoConfig.m_usnMaxPort=65530;//最大
    strncpy(g_s_ITLibHandle.m_s_VideoConfig.m_sIP,"0.0.0.0",sizeof(g_s_ITLibHandle.m_s_VideoConfig.m_sIP));

/*    if(NULL == (g_s_ITLibHandle.m_s_AudioConfig.m_s_gsm = gsm_create()))
    {
        return  SS_ERR_MEMORY;
    }*/

    g_s_ITLibHandle.m_s_AudioConfig.m_un32Sampling = 8000;

    if (NULL==pProtocol||NULL==pLogPath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32Len = strlen(pLogPath)))
    {
        return  SS_ERR_PARAM;
    }
    memcpy(sLogPath,pLogPath,un32Len);

#ifdef  WIN32
    if ('\\' != sLogPath[un32Len-1])
    {
        sLogPath[un32Len]='\\';
        un32Len++;
    }
#else
    if ('/' != sLogPath[un32Len-1])
    {
        sLogPath[un32Len]='/';
        un32Len++;
    }
#endif

	{//只保留最近7天的日志，其他的全部删除
		SS_CHAR    sTime[64] = "";
		SS_Time    s_TM;
		time_t     tSeconds=0;
		SS_GET_SECONDS(tSeconds);
		tSeconds-=691200;//减去8天的秒数
		memcpy(&s_TM,(void*)localtime(&tSeconds),sizeof(SS_Time));
		SS_snprintf(sTime,sizeof(sTime),"%04d%02d%02d%02d",s_TM.m_n32Year+1900,
			s_TM.m_n32Mon+1,s_TM.m_n32Mday,s_TM.m_n32Hour);
		SS_DeleteDirectoryFiles(pLogPath,sTime);
	}
    if (SS_SUCCESS != SS_CreatePathFolder(sLogPath,un32Len))
    {
        return  SS_ERR_ACTION;
    }
    switch(*pProtocol)
    {
    //case '1':g_s_ITLibHandle.m_s_Config.m_e_Protocol = SS_PROTOCOL_SIP;break;
    case '2':g_s_ITLibHandle.m_s_Config.m_e_Protocol = SS_PROTOCOL_SS;break;
    //case '3':g_s_ITLibHandle.m_s_Config.m_e_Protocol = SS_PROTOCOL_H323;break;
    default :return  SS_ERR_PARAM;break;
    }
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_LogPath,sLogPath);


/*    SKP_SILK_SDK_EncControlStruct encoder_object;
    SKP_SILK_SDK_DecControlStruct decoder_object;
    memset(&encoder_object,0,sizeof(SKP_SILK_SDK_EncControlStruct));
    memset(&decoder_object,0,sizeof(SKP_SILK_SDK_DecControlStruct));
    SS_INT32  n32EncSizeBytes=0;
    if (SKP_Silk_SDK_Get_Encoder_Size(&n32EncSizeBytes))
    {
        return SS_FAILURE;
    }*/
#ifdef _WIN32
	g_s_ITLibHandle.m_s_Config.m_un32MessageTimeOut = 1000;
#else
	g_s_ITLibHandle.m_s_Config.m_un32MessageTimeOut = 1000000;
#endif
    return  SS_SUCCESS;
}

SS_SHORT             IT_UpdateUserName(IN  SS_CHAR  *pUserName)
{
    SS_UINT32 un32Len=0;
    if (NULL==pUserName)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32Len=strlen(pUserName)))
    {
        return  SS_ERR_PARAM;
    }
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserName);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserName,pUserName);
    return  SS_SUCCESS;
}
SS_SHORT             IT_SetIconPath(IN  SS_CHAR  *pPath)
{
    SS_CHAR   sPath[4096] = "";
    SS_UINT32 un32Len=0;
    if (NULL==pPath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32Len=strlen(pPath)))
    {
        return  SS_ERR_PARAM;
    }
    memcpy(sPath,pPath,un32Len);
#ifdef  WIN32
    if ('\\' != sPath[un32Len-1])
    {
        sPath[un32Len]='\\';
        un32Len++;
    }
#else
    if ('/' != sPath[un32Len-1])
    {
        sPath[un32Len]='/';
        un32Len++;
    }
#endif

    if (SS_SUCCESS != SS_CreatePathFolder(sPath,un32Len))
    {
        return  SS_ERR_ACTION;
    }

    SS_DEL_str(g_s_ITLibHandle.m_s_IconPath);
    SS_ADD_str(g_s_ITLibHandle.m_s_IconPath,sPath);
    return  SS_SUCCESS;
}
SS_SHORT             IT_UpdateDBPath(IN  SS_CHAR  *pDBPath)//数据库保存的目录，绝对路径
{
    SS_SHORT  sn = 0;
    SS_UINT32 un32Len=0;
    SS_CHAR   sDBPath[8192] = "";
    if (NULL==pDBPath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32Len = strlen(pDBPath)))
    {
        return  SS_ERR_PARAM;
    }
    memcpy(sDBPath,pDBPath,un32Len);

#ifdef  WIN32
    if ('\\' != sDBPath[un32Len-1])
    {
        sDBPath[un32Len]='\\';
        un32Len++;
    }
#else
    if ('/' != sDBPath[un32Len-1])
    {
        sDBPath[un32Len]='/';
        un32Len++;
    }
#endif

    if (SS_SUCCESS != SS_CreatePathFolder(sDBPath,un32Len))
    {
        return  SS_ERR_ACTION;
    }
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_DBPath);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_DBPath,sDBPath);
    return SS_SUCCESS;
}

IT_API SS_SHORT   IT_ConnectDB(IN  SS_CHAR  *pDBFilePath)
{
    if (NULL == pDBFilePath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pDBFilePath))
    {
        return  SS_ERR_PARAM;
    }
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath,pDBFilePath);
    if (IT_GetConnectSqliteStatus(&g_s_ITLibHandle))
    {
        IT_DisconnectSqliteDB(&g_s_ITLibHandle);
    }
    return  IT_CheckUserDB(SS_FALSE);
}


#if defined(__GNUC__)

SS_VOID SignalFun(SS_INT32 n32ID)
{
    switch(n32ID)
    {
    case SIGINT:  //CTRL+C
        {
            //SS_Log_Printf(SS_ERROR_LOG,"Receive Signal SIGINT_%d!",n32ID);
        }break;
    case SIGTERM: //killall
        {
            SS_Log_Printf(SS_ERROR_LOG,"Receive Signal SIGTERM_%d!",n32ID);
        }break;
    case SIGPIPE:
        {
            //SS_Log_Printf(SS_ERROR_LOG,"Receive Signal SIGPIPE_%d!",n32ID);
        }break;
    case SIGBUS:
        {
            //SS_Log_Printf(SS_ERROR_LOG,"Receive Signal SIGPIPE_%d!",n32ID);
        }break;
    default: break;
    }
}

#endif

int LoadSignal()
{
#if defined(__GNUC__)
    signal(SIGINT   , SignalFun);
    signal(SIGTERM  , SignalFun);
    signal(SIGPIPE  , SignalFun);
    signal(SIGBUS  , SignalFun);
#endif
    return SS_SUCCESS;
}


SS_SHORT             IT_Init()
{
    if (SS_SUCCESS != IT_CheckConfig(&g_s_ITLibHandle.m_s_Config))
    {
        return SS_ERR_PARAM;
    }
    if (SS_SUCCESS != SS_Log_ModuleInit(g_s_ITLibHandle.m_s_Config.m_s_LogPath.m_s))
    {
        return  SS_FAILURE;
    }
    SS_Log_AddMode(SS_LOG_MEMORY);
    SS_Log_AddMode(SS_LOG_TRACE);
    SS_Log_AddMode(SS_LOG_DB);
    SS_Log_AddMode(SS_LOG_WARNING);
    SS_Log_AddMode(SS_LOG_DEBUG);
    SS_Log_AddMode(SS_LOG_REPORT);
    //SS_Log_AddMode(SS_LOG_SIP_INVITE);
    //SS_Log_AddMode(SS_LOG_SIP_ACK);
    //SS_Log_AddMode(SS_LOG_SIP_BYE);
    //SS_Log_AddMode(SS_LOG_SIP_CANCEL);
    //SS_Log_AddMode(SS_LOG_SIP_INFO);
    SS_Log_AddMode(SS_LOG_DB);
    SS_Log_AddMode(SS_LOG_XML);


    switch(g_s_ITLibHandle.m_s_Config.m_e_Protocol)
    {
    case SS_PROTOCOL_SIP:
        {
            if (0 == g_s_ITLibHandle.m_s_Config.m_s_IP.m_len||0 == g_s_ITLibHandle.m_s_Config.m_usnSIPPort)
            {
                SS_Log_Printf(SS_ERROR_LOG,"SIP IP and port error");
                SS_Log_ModuleFree();
                return SS_ERR_PARAM;
            }
            if (SS_SOCKET_ERROR-1 == (g_s_ITLibHandle.m_SignalScoket = 
                SS_UDP_Bind(g_s_ITLibHandle.m_s_Config.m_s_IP.m_s,g_s_ITLibHandle.m_s_Config.m_usnSIPPort)))
            {
                SS_Log_Printf(SS_ERROR_LOG,"SIP Bind %s_%u error",
                    g_s_ITLibHandle.m_s_Config.m_s_IP.m_s,g_s_ITLibHandle.m_s_Config.m_usnSIPPort);
                SS_Log_ModuleFree();
                return SS_ERR_ACTION;
            }
            g_s_ITLibHandle.m_un32CSeq = 1;
            g_s_ITLibHandle.m_un32Expires=g_s_ITLibHandle.m_s_Config.m_un32SIPRegisterTime;
        }break;
    default:
        {
        }break;
    }

    memset(&g_s_ITLibHandle.m_s_RTPQueue,0,sizeof(SSRTPQueue));

	if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_CallBackLinkQueue))
	{
		SS_Log_Printf(SS_ERROR_LOG,"init call back link queue faild");
		SS_Log_ModuleFree();
		return  SS_FAILURE;
	}
    if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_RecvLinkQueue))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init recv link queue faild");
        SS_Log_ModuleFree();
        return  SS_FAILURE;
    }
	if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_MSGTimeOutLinkQueue))
	{
		SS_Log_Printf(SS_ERROR_LOG,"init message time out link queue faild");
		SS_Log_ModuleFree();
		return  SS_FAILURE;
	}
    if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_SendLinkQueue))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init send link queue faild");
        SS_Log_ModuleFree();
        return  SS_FAILURE;
    }
	if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_SlowlyTreatmentLinkQueue))
	{
		SS_Log_Printf(SS_ERROR_LOG,"init Slowly Treatment link queue faild");
		SS_Log_ModuleFree();
		return  SS_FAILURE;
	}
    if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_DBLinkQueue))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init DB link queue faild");
        SS_Log_ModuleFree();
        return  SS_FAILURE;
    }
    if (SS_SUCCESS != SS_LinkQueue_Init(&g_s_ITLibHandle.m_s_PCMLinkQueue))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init PCM link queue faild");
        SS_Log_ModuleFree();
        return  SS_FAILURE;
    }

    if (SS_SUCCESS != SS_Mutex_Init(&g_s_ITLibHandle.m_s_Mutex))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init Mutex faild");
        SS_Log_ModuleFree();
        return  SS_FAILURE;
    }

    SS_GET_SECONDS(g_s_ITLibHandle.m_SIPTime);

    RTPA_AddCodec(&g_s_ITLibHandle.m_s_Audio,SS_AUDIO_CODEC_ALAW,SS_AUDIO_PT_ALAW);
    RTPA_AddCodec(&g_s_ITLibHandle.m_s_Audio,SS_AUDIO_CODEC_ULAW,SS_AUDIO_PT_ULAW);

    //RTPA_AddCodec(&g_s_ITLibHandle.m_s_Audio,SS_AUDIO_CODEC_G729,SS_AUDIO_PT_G729);
    //RTPA_AddCodec(&g_s_ITLibHandle.m_s_Audio,SS_AUDIO_CODEC_G723_63,SS_AUDIO_PT_G723_63);
    //RTPA_AddCodec(&g_s_ITLibHandle.m_s_Audio,SS_AUDIO_CODEC_GSM,SS_AUDIO_PT_GSM);

    return  LoadSignal();
}
IT_API SS_SHORT             IT_SetCallBack(IN SS_SHORT (*f_CallBack)(IN SS_UINT32 const ,IN SS_CHAR **,IN SS_UINT32 const))
{
    if (NULL == f_CallBack)
    {
        return  SS_ERR_PARAM;
    }
    g_s_ITLibHandle.m_f_CallBack = f_CallBack;
    return  SS_SUCCESS;
}
IT_API SS_SHORT             IT_UnInit()
{
    switch(g_s_ITLibHandle.m_s_Config.m_e_Protocol)
    {
    case SS_PROTOCOL_SIP:
        {
        }break;
    case SS_PROTOCOL_SS:
        {
        }break;
    case SS_PROTOCOL_H323:
        {
        }break;
    }
    SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
    SS_closesocket(g_s_ITLibHandle.m_AudioScoket);
    SS_closesocket(g_s_ITLibHandle.m_VideoScoket);
	SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_CallBackLinkQueue);
    SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_RecvLinkQueue);
    SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_SendLinkQueue);
	SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_MSGTimeOutLinkQueue);
	SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_SlowlyTreatmentLinkQueue);
    SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_DBLinkQueue);
    SS_LinkQueue_Destroy(&g_s_ITLibHandle.m_s_PCMLinkQueue);
    SS_Mutex_Destroy(&g_s_ITLibHandle.m_s_Mutex);
    g_s_ITLibHandle.m_e_ITStatus = IT_STATUS_IDLE;
    g_s_ITLibHandle.m_f_CallBack = NULL;
    return  SS_SUCCESS;
}
IT_API SS_SHORT             IT_Start()
{
    g_s_ITLibHandle.m_snThreadState = SS_THREAD_STATE_START;
#ifdef  _WIN32
    if (NULL == (g_s_ITLibHandle.m_h_Threadhandle = ::CreateThread(NULL,0,__ITLIB_Thread,&g_s_ITLibHandle,0,NULL)))
#else
    if (0 != pthread_create(&g_s_ITLibHandle.m_h_Threadhandle,NULL,__ITLIB_Thread,&g_s_ITLibHandle))
#endif
    {
        SS_Log_Printf(SS_START_LOG,"Create IT LIB thread fail");
        return SS_FAILURE;
    }
    SS_USLEEP(10000);
    return  SS_SUCCESS;
}
IT_API SS_SHORT             IT_Stop()
{
	if(SS_THREAD_STATE_RUNING == g_s_ITLibHandle.m_snThreadState)
	{
		g_s_ITLibHandle.m_snThreadState = SS_THREAD_STATE_STOP;
		while(SS_THREAD_STATE_EXIT!=g_s_ITLibHandle.m_snThreadState)
		{
			SS_USLEEP(1000);
			if (SS_THREAD_STATE_RUNING == g_s_ITLibHandle.m_snThreadState)
			{
				g_s_ITLibHandle.m_snThreadState = SS_THREAD_STATE_STOP;
			}
		}
		if (SS_THREAD_STATE_STOP == g_s_ITLibHandle.m_snThreadState)
		{
			g_s_ITLibHandle.m_snThreadState = SS_THREAD_STATE_EXIT;
		}
		SS_Log_ModuleFree();
	}
    return  SS_SUCCESS;
}
IT_API SS_CHAR const*const  GetITLibVer()
{
    return  IT_VERSION;
}
IT_API SS_UINT32            GetITLibVerNo()
{
    return  90;
}
SS_SHORT             IT_LogScreenDisplay(IN SS_BYTE const ubState)
{
    return  SS_Log_SetScreenDisplay(ubState);
}
//////////////////////////////////////////////////////////////////////////
IT_API SS_SHORT IT_SendPayResultIND(
	IN SS_UINT32 const  un32ShopID,
	IN SS_CHAR   const *pOrderCode,
	IN SS_BYTE   const  ubPayType,
	IN SS_BYTE   const  ubResult)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallSendPayResultIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode,ubPayType,ubResult);
}
IT_API SS_SHORT IT_GetOrderRefundInfoIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallGetOrderRefundInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}

IT_API SS_SHORT IT_MallLoadOrderSingleIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallLoadOrderSingleIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}

IT_API SS_SHORT IT_MallOrderRemindersIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallOrderRemindersIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}
IT_API SS_SHORT IT_MallCancelOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallCancelOrderIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}

IT_API SS_SHORT IT_OrderConfirmIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallOrderConfirmIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}

IT_API SS_SHORT IT_SetAPITimeOut(IN SS_UINT32 const un32Seconds)
{
	if (un32Seconds >= 20 || un32Seconds <= 1)
	{
		return SS_ERR_PARAM;
	}
	g_s_ITLibHandle.m_un32APITimeOut = un32Seconds;
	return  SS_SUCCESS;
}
IT_API SS_SHORT IT_OrderRefundIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode,
	IN SS_CHAR const *pGrounds)
{
	if (NULL==pOrderCode||NULL==pGrounds||0==un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallOrderRefundIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode,pGrounds);
	return  SS_SUCCESS;
}
IT_API SS_SHORT IT_GetOrderCodePayModeIND(
	IN SS_UINT32 const  un32Type,
	IN SS_UINT32 const  un32ShopID,
	IN SS_CHAR   const *pOrderCode)
{
	if (NULL==pOrderCode||0==un32ShopID||0==un32Type)
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_MallGetOrderCodePayModeIND(g_s_ITLibHandle.m_un64WoXinID,0,
		un32Type,g_s_ITLibHandle.m_un32SellerID,un32ShopID,pOrderCode);
}

IT_API SS_SHORT IT_NetworkModeChange(IN SS_BYTE const ubMode)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_ERROR_LOG,"API ubMode=%u",ubMode);
#endif
	g_s_ITLibHandle.m_ubNetworkMode=ubMode;
	if (0 == ubMode)//没有网络
	{
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_ERROR_LOG,"Set auto connect server flag is false");
#endif
		g_s_ITLibHandle.m_ubAutoConnectServerFlag=SS_FALSE;
	}
	else
	{
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_ERROR_LOG,"Set auto connect server flag is true");
#endif
		g_s_ITLibHandle.m_ubAutoConnectServerFlag=SS_TRUE;
	}
	IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
	return  SS_SUCCESS;
}
IT_API SS_SHORT IT_SelectPhoneCheckCodeIND(IN SS_CHAR *pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_ERROR_LOG,"phone number error");
#endif
		return  sn;
	}
	IT_CHECK_NETWORK;
	return  ITREG_SelectPhoneCheckCodeIND(g_s_ITLibHandle.m_un64WoXinID,0,pPhone);
}

IT_API SS_SHORT IT_GetCreditBalanceIND()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_GetCreditBalanceIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID);
}
IT_API SS_SHORT IT_RechargeIND(
    IN  SS_UINT32 const un32Type,
    IN  SS_UINT32 const un32Price,
    IN  SS_CHAR   const*pAccount,
    IN  SS_CHAR   const*pPassword)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if(NULL == pPassword||NULL == pAccount || 0 == un32Type)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword) || 0 == strlen(pAccount))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_RechargeIND(g_s_ITLibHandle.m_un64WoXinID,0,un32Type,
        g_s_ITLibHandle.m_un32SellerID,un32Price,pAccount,pPassword);
}
IT_API SS_SHORT IT_GetRechargePreferentialRulesIND()
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sMSG[20480]="";
	SS_CHAR  *p=NULL;
	SS_BYTE  ubFlag=SS_FALSE;
	SS_UINT32 un32Len=0;
	SS_UINT32 un32OldTime=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT Top,equals,desc,time FROM RechargePreferentialRules;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		p = sMSG;
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			*p = '[';p++;
			do 
			{
				if (s_ROW = IT_SqliteFetchRow(s_pRecord))
				{
					if (ubFlag)
					{
						*p = ',';p++;
					}
					un32Len = SS_snprintf(p,1024,"{\"Top\":%s,\"equals\":%s,\"desc\":\"%s\"}",
						SS_IfROWString(s_ROW[0]),SS_IfROWString(s_ROW[1]),SS_IfROWString(s_ROW[2]));
					p += un32Len;
					ubFlag = SS_TRUE;
					un32OldTime=SS_IfROWNumber(s_ROW[3]);
				}
			} while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
			*p = ']';
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (sMSG[0])
	{
		un32Len = strlen(sMSG);
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(6*sizeof(SS_CHAR*))))
		{
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,sMSG,un32Len);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_RECHARGE_RULES))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_GetRechargePreferentialRulesIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID);
		return SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"not find cache IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_GetRechargePreferentialRulesIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID);
}
IT_API SS_SHORT IT_UpdateBoundMobileNumberIND(IN SS_CHAR const*pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_UpdateBoundMobileNumberIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,pPhone);
}

IT_API SS_SHORT IT_LibisRuning()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (SS_THREAD_STATE_RUNING == g_s_ITLibHandle.m_snThreadState)
    {
        return  SS_SUCCESS;
    }
    return  SS_FAILURE;
}
IT_API SS_SHORT IT_SetAutoConnectServer(IN SS_BYTE const ubFlag)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
	if (ubFlag)
	{
		SS_Log_Printf(SS_ERROR_LOG,"Set auto connect server flag is true");
	}
	else
	{
		SS_Log_Printf(SS_ERROR_LOG,"Set auto connect server flag is false");
	}
#endif
    g_s_ITLibHandle.m_ubAutoConnectServerFlag = ubFlag;
    return  SS_SUCCESS;
}
IT_API SS_SHORT IT_AboutIND()
{
    SS_str  s_str;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR *pCache=NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
    SS_INIT_str(s_str);
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM About;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(6*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_IT_ABOUT_CFM;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_ABOUT))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_IT_ABOUT_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_AboutIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
		return SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_IT_ABOUT_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_AboutIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
}
IT_API SS_SHORT IT_AboutHelpIND()
{
    SS_str  s_str;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR *pCache=NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
	SS_INIT_str(s_str);
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM AboutHelp;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(6*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_IT_ABOUT_HELP_CFM;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_ABOUT))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_IT_ABOUT_HELP_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_AboutHelpIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_IT_ABOUT_HELP_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_AboutHelpIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
}
IT_API SS_SHORT IT_AboutProtocolIND()
{
    SS_str  s_str;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache= NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
	SS_INIT_str(s_str);
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM AboutProtocol;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(6*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_IT_ABOUT_PROTOCOL_CFM;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_ABOUT))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_IT_ABOUT_PROTOCOL_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_AboutProtocolIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_IT_ABOUT_PROTOCOL_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_AboutProtocolIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str);
}

IT_API SS_SHORT IT_AboutFeedBackIND(
    IN SS_CHAR const*pQQ,
    IN SS_CHAR const*pEMail,
    IN SS_CHAR const*pContent)
{
	SS_SHORT usn=0;
    SS_str  s_str;
	SS_CHAR *p=NULL;
	SS_UINT32 un32Len=0;
    SS_INIT_str(s_str);
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pQQ || NULL == pEMail || NULL == pContent)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pQQ)||0 == strlen(pEMail)||0 == (un32Len=strlen(pContent)))
    {
        return  SS_ERR_PARAM;
    }
	if (NULL == (p=(SS_CHAR*)SS_malloc(un32Len+un32Len/2)))
	{
		return  SS_ERR_MEMORY;
	}
	IT_CHECK_NETWORK;
	memset(p,0,un32Len+un32Len/2);
	IT_CharProc(pContent,p);
    usn=ITREG_AboutFeedBackIND(g_s_ITLibHandle.m_un64WoXinID,0,&s_str,pQQ,pEMail,p);
	SS_free(p);
	return  usn;
}

IT_API SS_SHORT IT_UpdateREGShopIND(IN  SS_UINT32 const un32ShopID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID)
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_UpdateREGShopIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32ShopID);
}
IT_API SS_SHORT IT_ReportTokenIND(
    IN  SS_CHAR   const*pToken,
    IN  SS_CHAR   const*pUserID,
    IN  SS_UINT32 const un32CertsType,
    IN  SS_CHAR   const*pMachineID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32CertsType || NULL == pToken || NULL == pUserID||NULL==pMachineID)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pToken) || 0 == strlen(pUserID)||0==strlen(pMachineID))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_ReportTokenIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,pToken,pUserID,un32CertsType,pMachineID);
}
IT_API SS_SHORT IT_MallGetPushMessageInfoIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_UINT32 const un32MSGType)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || 0 == un32MSGID || 0 == un32MSGType)
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallGetPushMessageInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32ShopID,un32MSGID,un32MSGType);
}
IT_API SS_SHORT IT_MallGetRedPackageBalanceIND()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallGetRedPackageBalanceIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_un64WoXinID);
}
IT_API SS_SHORT IT_MallGetSellerAboutInfoIND()
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache= NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[256] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM SellerAbout;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(6*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_SELLER_ABOUT_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_ABOUT))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_SELLER_ABOUT_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetSellerAboutInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_un64WoXinID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_SELLER_ABOUT_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetSellerAboutInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_un64WoXinID);
}
IT_API SS_SHORT IT_MallGetShopAboutInfoIND(IN SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32ShopID)
	{
		return  SS_SUCCESS;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM ShopAbout WHERE ShopID=%u;",un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(7*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_SHOP_ABOUT_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_ABOUT))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_SHOP_ABOUT_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetShopAboutInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_un64WoXinID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_SHOP_ABOUT_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetShopAboutInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_un64WoXinID,un32ShopID);
}
IT_API SS_SHORT IT_MallLoadRedPackageIND(IN SS_UINT32 const un32ShopID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID)
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallLoadRedPackageIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32ShopID,g_s_ITLibHandle.m_un64WoXinID);
}
IT_API SS_SHORT IT_MallReceiveRedPackageIND(IN SS_UINT32 const un32ShopID,IN SS_UINT32 const un32RedPackageID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || 0 == un32RedPackageID)
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallReceiveRedPackageIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,un32RedPackageID);
}
IT_API SS_SHORT IT_MallUseRedPackageIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_CHAR   const*pPrice,
    IN SS_CHAR   const*pOrderCode)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || NULL == pPrice|| NULL == pOrderCode)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPrice) || 0 == strlen(pOrderCode))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallUseRedPackageIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,pPrice,pOrderCode);
}
IT_API SS_SHORT IT_MallLoadRedPackageUseRulesIND(IN SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32ShopID)
	{
		return  SS_SUCCESS;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM RedPackageUseRules WHERE ShopID=%u;",un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				un32Len=strlen(SS_IfROWString(s_ROW[0]));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(s_ROW[0]),un32Len);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(7*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_RED_PACKAGE_RECHARGE_RULES))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallLoadRedPackageUseRulesIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32ShopID,g_s_ITLibHandle.m_un64WoXinID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallLoadRedPackageUseRulesIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32ShopID,g_s_ITLibHandle.m_un64WoXinID);
}
IT_API SS_SHORT IT_MallAddOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pJson)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || NULL == pJson)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pJson))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallAddOrderIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,pJson);
}
IT_API SS_SHORT IT_MallUpdateOrderIND(
    IN SS_UINT32 const un32ShopID,
    IN SS_CHAR const *pOrderCode,
    IN SS_CHAR const *pJson)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || NULL == pOrderCode|| NULL == pJson)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pJson)||0 == strlen(pOrderCode))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallUpdateOrderIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,pOrderCode,pJson);
}
IT_API SS_SHORT IT_MallDelOrderIND(IN SS_UINT32 const un32ShopID,IN SS_CHAR const *pOrderCode)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID || NULL == pOrderCode)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pOrderCode))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallDelOrderIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,pOrderCode);
}
IT_API SS_SHORT IT_MallLoadOrderIND(
	IN SS_UINT32 const un32ShopID,
	IN SS_UINT32 const un32OffSet,
	IN SS_UINT32 const un32Limit)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32ShopID)
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_MallLoadOrderIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,
        un32ShopID,g_s_ITLibHandle.m_un64WoXinID,un32OffSet,un32Limit);
}

SS_SHORT IT_MallGetAreaInfoIND()
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sNumber[64] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM AreaInfo;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(7*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_AREA_INFO_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_AREA_SHOP))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_AREA_INFO_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetAreaInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_AREA_INFO_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetAreaInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID);
}
SS_SHORT IT_MallGetShopInfoIND(IN  SS_UINT32 const un32AreaID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM ShopInfo WHERE AreaID=%u;",un32AreaID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(8*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_SHOP_INFO_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_AREA_SHOP))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_SHOP_INFO_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetShopInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,un32AreaID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_SHOP_INFO_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetShopInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,un32AreaID);
}
SS_SHORT IT_MallGetAreaShopInfoIND()
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM AreaShopInfo;");
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}

	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(8*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_AREA_SHOP_INFO_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_AREA_SHOP))
		{
			return SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_AREA_SHOP_INFO_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetAreaShopInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_AREA_SHOP_INFO_CFM");
	}
#endif
	IT_CHECK_NETWORK;
	return  ITREG_MallGetAreaShopInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID);
}

SS_SHORT IT_MallGetHomeTopBigPictureIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM HomeTopBigPicture "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetHomeTopBigPictureIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetHomeTopBigPictureIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT IT_MallGetHomeTopBigPictureExIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM HomeTopBigPictureEx "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetHomeTopBigPictureExIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM");
	}
#endif
	IT_CHECK_NETWORK;
	return  ITREG_MallGetHomeTopBigPictureExIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}


SS_SHORT IT_MallGetHomeNavigationIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM HomeNavigation "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_HOME_NAVIGATION_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_HOME_NAVIGATION_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetHomeNavigationIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_HOME_NAVIGATION_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetHomeNavigationIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT IT_MallGetGuessYouLikeRandomGoodsIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM GuessYouLikeRandomGoods "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}

	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetGuessYouLikeRandomGoodsIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetGuessYouLikeRandomGoodsIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT IT_MallGetCategoryListIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM CategoryList "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_CATEGORY_LIST_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_CATEGORY_LIST_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetCategoryListIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_CATEGORY_LIST_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetCategoryListIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}

SS_SHORT IT_MallGetPackageIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM Package "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_PACKAGE_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return  SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_PACKAGE_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetPackageIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_PACKAGE_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetPackageIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT IT_MallGetGoodsAllIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_CHAR  sDomain[256] = "";
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *pDomain= NULL;
	SS_CHAR  *p=NULL;
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_UINT32 un32DomainLen=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count,Domain FROM GoodsAll "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]   = 0;
				pCache[un32Len+1] = 0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
				un32DomainLen=SS_snprintf(sDomain,sizeof(sDomain),"%s",SS_IfROWString(s_ROW[3]));

/*				un32Len=strlen(SS_IfROWString(s_ROW[0]));
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),un32Len);
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len] = 0;
				pCache[un32Len+1] = 0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
				un32DomainLen=SS_snprintf(sDomain,sizeof(sDomain),"%s",SS_IfROWString(s_ROW[3]));
*/
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(12*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pDomain = (SS_CHAR *)SS_malloc(un32DomainLen)))
		{
			SS_free(pCache);
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		pDomain[un32DomainLen] = 0;
		pDomain[un32DomainLen+1] = 0;
		memcpy(pDomain,sDomain,un32DomainLen);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_GOODS_ALL_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pDomain;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_GOODS_ALL_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetGoodsAllIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_GOODS_ALL_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetGoodsAllIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}

SS_SHORT IT_MallGetSpecialPropertiesCategoryListIND(IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  *pCache = NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32Len=0;
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *p=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time,count FROM SpecialPropertiesCategoryList "
		"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
				un32Len=strlen(SS_IfROWString(pInfo));
				if (NULL == (pCache = (SS_CHAR *)SS_malloc(un32Len)))
				{
					return  SS_ERR_MEMORY;
				}
				pCache[un32Len]=0;
				pCache[un32Len+1]=0;
				memcpy(pCache,SS_IfROWString(pInfo),un32Len);
				SS_free(pInfo);
				un32OldTime=SS_IfROWNumber(s_ROW[1]);
				strncpy(sNumber,SS_IfROWString(s_ROW[2]),sizeof(sNumber));
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (pCache)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(10*sizeof(SS_CHAR*))))
		{
			SS_free(pCache);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32Len)))
		{
			SS_free(pCache);
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		pMSG[un32Len] = 0;
		pMSG[un32Len+1] = 0;
		memcpy(pMSG,pCache,un32Len);
		SS_free(pCache);
		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = atoi(sNumber);p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pMSG;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pMSG);
			return  SS_ERR_MEMORY;
		}
		//不需要更新缓存
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetSpecialPropertiesCategoryListIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetSpecialPropertiesCategoryListIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT IT_MallGetGoodsInfoIND(
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT32 const un32GoodsID)
{
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	
	SS_CHAR  sGroupID[128] = "";
	SS_CHAR  sDescription[8192] = "";
	SS_CHAR  sName[1024] = "";
	SS_CHAR  sMarketPrice[128] = "";
	SS_CHAR  sOURPrice[128] = "";
	SS_CHAR  sNumber[128] = "";
	SS_CHAR  sInfo[8192] = "";
	SS_CHAR  sLikeCount[64] = "";
	SS_CHAR  sMeterageName[8192] = "";
	SS_CHAR  *pParam = NULL;
	SS_CHAR  *pGroupID= NULL;
	SS_CHAR  *pDescription= NULL;
	SS_CHAR  *pName= NULL;
	SS_CHAR  *pMarketPrice= NULL;
	SS_CHAR  *pOURPrice= NULL;
	SS_CHAR  *pNumber= NULL;
	SS_CHAR  *pInfo= NULL;
	SS_CHAR  *pLikeCount= NULL;
	SS_CHAR  *pMeterageName= NULL;
	SS_CHAR  *p=NULL;
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sGoodsID[64] = "";
	SS_UINT32 un32OldTime=0;
	SS_UINT32 un32GroupIDLen=0;
	SS_UINT32 un32DescriptionLen=0;
	SS_UINT32 un32NameLen=0;
	SS_UINT32 un32MarketPriceLen=0;
	SS_UINT32 un32OURPriceLen=0;
	SS_UINT32 un32NumberLen=0;
	SS_UINT32 un32InfoLen=0;
	SS_UINT32 un32LikeCountLen=0;
	SS_UINT32 un32MeterageNameLen=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (0 == un32AreaID || 0 == un32ShopID || 0 == un32GoodsID)
	{
		return  SS_ERR_PARAM;
	}
	SS_snprintf(sSQL,sizeof(sSQL),"SELECT GroupID,Description,Name,MarketPrice,OURPrice,"
		"Number,Info,LikeCount,MeterageName,time FROM GoodsInfo WHERE AreaID=%u AND "
		"ShopID=%u AND GoodsID=%u;",un32AreaID,un32ShopID,un32GoodsID);

	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
	if (s_pRecord)
	{
		if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
		{
			if (s_ROW = IT_SqliteFetchRow(s_pRecord))
			{
				un32GroupIDLen=SS_snprintf(sGroupID,sizeof(sGroupID),"%s",SS_IfROWString(s_ROW[0]));

				SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[1]),strlen(SS_IfROWString(s_ROW[1])));
				un32DescriptionLen=SS_snprintf(sDescription,sizeof(sDescription),"%s",SS_IfROWString(pInfo));
				SS_free(pInfo);

				pInfo=base64_decode(SS_IfROWString(s_ROW[2]),strlen(SS_IfROWString(s_ROW[2])));
				un32NameLen=SS_snprintf(sName,sizeof(sName),"%s",SS_IfROWString(pInfo));
				SS_free(pInfo);

				un32MarketPriceLen=SS_snprintf(sMarketPrice,sizeof(sMarketPrice),"%s",SS_IfROWString(s_ROW[3]));
				un32OURPriceLen=SS_snprintf(sOURPrice,sizeof(sOURPrice),"%s",SS_IfROWString(s_ROW[4]));
				un32NumberLen=SS_snprintf(sNumber,sizeof(sNumber),"%s",SS_IfROWString(s_ROW[5]));
				
				pInfo=base64_decode(SS_IfROWString(s_ROW[6]),strlen(SS_IfROWString(s_ROW[6])));
				un32InfoLen=SS_snprintf(sInfo,sizeof(sInfo),"%s",SS_IfROWString(pInfo));
				SS_free(pInfo);

				un32LikeCountLen=SS_snprintf(sLikeCount,sizeof(sLikeCount),"%s",SS_IfROWString(s_ROW[7]));
				
				pInfo=base64_decode(SS_IfROWString(s_ROW[8]),strlen(SS_IfROWString(s_ROW[8])));
				un32MeterageNameLen=SS_snprintf(sMeterageName,sizeof(sMeterageName),"%s",SS_IfROWString(pInfo));
				SS_free(pInfo);

				un32OldTime=SS_IfROWNumber(s_ROW[9]);
			}
		}
		IT_SqliteRelease(&s_pRecord);
	}
	if (un32OldTime)
	{
		if (NULL == (pParam = (SS_CHAR*)SS_malloc(30*sizeof(SS_CHAR*))))
		{
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pGroupID = (SS_CHAR *)SS_malloc(un32GroupIDLen)))
		{
			SS_free(pParam);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pDescription = (SS_CHAR *)SS_malloc(un32DescriptionLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pName = (SS_CHAR *)SS_malloc(un32NameLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMarketPrice = (SS_CHAR *)SS_malloc(un32MarketPriceLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pOURPrice = (SS_CHAR *)SS_malloc(un32OURPriceLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pNumber = (SS_CHAR *)SS_malloc(un32NumberLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			SS_free(pOURPrice);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pInfo = (SS_CHAR *)SS_malloc(un32InfoLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			SS_free(pOURPrice);
			SS_free(pNumber);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pLikeCount = (SS_CHAR *)SS_malloc(un32LikeCountLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			SS_free(pOURPrice);
			SS_free(pNumber);
			SS_free(pInfo);
			return  SS_ERR_MEMORY;
		}
		if (NULL == (pMeterageName = (SS_CHAR *)SS_malloc(un32MeterageNameLen)))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			SS_free(pOURPrice);
			SS_free(pNumber);
			SS_free(pInfo);
			SS_free(pLikeCount);
			return  SS_ERR_MEMORY;
		}
		pGroupID[un32GroupIDLen] = 0;pGroupID[un32GroupIDLen+1] = 0;memcpy(pGroupID,sGroupID,un32GroupIDLen);
		pDescription[un32DescriptionLen] = 0;pDescription[un32DescriptionLen+1] = 0;memcpy(pDescription,sDescription,un32DescriptionLen);
		pName[un32NameLen] = 0;pName[un32NameLen+1] = 0;memcpy(pName,sName,un32NameLen);
		pMarketPrice[un32MarketPriceLen] = 0;pMarketPrice[un32MarketPriceLen+1] = 0;memcpy(pMarketPrice,sMarketPrice,un32MarketPriceLen);
		pOURPrice[un32OURPriceLen] = 0;pOURPrice[un32OURPriceLen+1] = 0;memcpy(pOURPrice,sOURPrice,un32OURPriceLen);
		pNumber[un32NumberLen] = 0;pNumber[un32NumberLen+1] = 0;memcpy(pNumber,sNumber,un32NumberLen);
		pInfo[un32InfoLen] = 0;pInfo[un32InfoLen+1] = 0;memcpy(pInfo,sInfo,un32InfoLen);
		pLikeCount[un32LikeCountLen] = 0;pLikeCount[un32LikeCountLen+1] = 0;memcpy(pLikeCount,sLikeCount,un32LikeCountLen);
		pMeterageName[un32MeterageNameLen] = 0;pMeterageName[un32MeterageNameLen+1] = 0;memcpy(pMeterageName,sMeterageName,un32MeterageNameLen);

		p = pParam;
		*(SS_UINT32*)p = IT_MSG_GET_GOODS_INFO_CFM;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = g_s_ITLibHandle.m_un32SellerID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32AreaID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32ShopID;p+=sizeof(SS_UINT32);
		*(SS_UINT32*)p = un32GoodsID;p+=sizeof(SS_UINT32);
		*(unsigned long*)p = (unsigned long)pGroupID;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pDescription;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pName;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pMarketPrice;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pOURPrice;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pNumber;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pInfo;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pLikeCount;p+=sizeof(unsigned long);
		*(unsigned long*)p = (unsigned long)pMeterageName;p+=sizeof(unsigned long);
		*(SS_UINT32*)p = 0;
		if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_CallBackLinkQueue,(SS_VOID*)pParam))
		{
			SS_free(pParam);
			SS_free(pGroupID);
			SS_free(pDescription);
			SS_free(pName);
			SS_free(pMarketPrice);
			SS_free(pOURPrice);
			SS_free(pNumber);
			SS_free(pInfo);
			SS_free(pLikeCount);
			SS_free(pMeterageName);
			return  SS_ERR_MEMORY;
		}
		if (SS_SUCCESS != SS_CheckCacheTime(un32OldTime,CACHE_UPDATE_TIME_SHOP_INFO))
		{
			return SS_SUCCESS;
		}
#ifdef IT_LIB_DEBUG
		SS_Log_Printf(SS_TRACE_LOG,"Update cache IT_MSG_GET_GOODS_INFO_CFM");
#endif
		if(SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
		{
			SS_Log_Printf(SS_ERROR_LOG,"server is disconnect");
			return SS_SUCCESS;
		}
		ITREG_MallGetGoodsInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
			g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID,un32GoodsID);
		return  SS_SUCCESS;
	}
#ifdef IT_LIB_DEBUG
	else
	{
		SS_Log_Printf(SS_TRACE_LOG,"Not find cache IT_MSG_GET_GOODS_INFO_CFM");
	}
#endif
	IT_CHECK_NETWORK;
    return  ITREG_MallGetGoodsInfoIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,un32AreaID,un32ShopID,un32GoodsID);
}
SS_SHORT IT_MallReportMyLocationIND(
    IN  SS_CHAR   const*pLatitude,
    IN  SS_CHAR   const*pLongitude)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pLatitude || NULL == pLongitude)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pLatitude) || 0 == strlen(pLongitude))
    {
        return  SS_ERR_PARAM;
    }
	IT_CHECK_NETWORK;
    return  ITREG_MallReportMyLocationIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_un32SellerID,pLatitude,pLongitude);
}
IT_API SS_SHORT IT_MallGetLastBrowseShopIND()
{
    SS_str  *s_pMSG=NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_GET_LAST_BROWSE_SHOP;
    s_pMSG->m_s = NULL;
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
//////////////////////////////////////////////////////////////////////////

SS_SHORT  IT_GetPhoneCheckCode(IN SS_CHAR const*pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    IT_CHECK_NETWORK;
    return ITREG_GetPhoneCheckCode(0,0,pPhone);
}
SS_SHORT  IT_Login(
	IN SS_UINT32 const un32ID,
	IN SS_USHORT const usnPhoneModel,
	IN SS_CHAR const*pPhone,
	IN SS_CHAR const*pPassword,
	IN SS_CHAR const*pPhoneID)//登录密码
{
    SS_UINT64  un64WoXinID = 0;
    SS_CHAR    sWoXinID[64] = "";
	SS_UINT32  un32Len=0;
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pPassword||NULL==pPhoneID)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword)||0==(un32Len=strlen(pPhoneID)))
    {
        return  SS_ERR_PARAM;
    }
	if (un32Len>64)
	{
		return  SS_ERR_PARAM;
	}
    IT_CHECK_NETWORK;
    g_s_ITLibHandle.m_un32SellerID = un32ID;
    g_s_ITLibHandle.m_usnPhoneModel=usnPhoneModel;
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp,pPhone);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp,pPassword);

    if (g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s)
    {
        if ((0 == strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone)) &&
            g_s_ITLibHandle.m_un64WoXinID)
        {
            if (IT_STATUS_LOGIN_OK==g_s_ITLibHandle.m_e_ITStatus)
            {
                return  SS_SUCCESS;
            }
            return  ITREG_Login(g_s_ITLibHandle.m_un64WoXinID,0,un32ID,usnPhoneModel,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pPhone,pPassword,pPhoneID);
        }
    }
    SS_snprintf(sWoXinID,sizeof(sWoXinID),"1%s",pPhone);
    return  ITREG_Login(0,0,un32ID,usnPhoneModel,sWoXinID,pPhone,pPassword,pPhoneID);
}

SS_SHORT  IT_Logout(
    IN SS_UINT32 const un32ID,
    IN SS_CHAR const*pPhone,  //我信ID
    IN SS_CHAR const*pPassword)//登录密码
{
    SS_UINT64  un64WoXinID = 0;
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pPassword)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    SS_aToun64(g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,un64WoXinID);
    sn=ITREG_Logout(un64WoXinID,0,un32ID,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pPhone,pPassword);
	if (SS_SUCCESS == sn)
	{
		if (IT_GetConnectSqliteStatus(&g_s_ITLibHandle))
		{
			SS_Log_Printf(SS_STATUS_LOG,"Disconnect sqlite DB");
			IT_DisconnectSqliteDB(&g_s_ITLibHandle);
		}
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserName);
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo);
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_Phone);
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword);
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp);
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp);
		g_s_ITLibHandle.m_e_Direction=DIRECTION_IDLE;
		g_s_ITLibHandle.m_e_CallStatus=CALL_STATE_IDLE;
		g_s_ITLibHandle.m_un32CallID=0;
		g_s_ITLibHandle.m_un32CallCMD=0;
		g_s_ITLibHandle.m_un64CallWoXinID=0;
		g_s_ITLibHandle.m_un64WoXinID=0;
	}
	return  sn;
}

IT_API SS_SHORT  IT_Register(IN SS_UINT32 const un32ID,IN SS_CHAR const*pPhone,IN SS_CHAR const*pPassword,IN SS_CHAR const*pCode)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pPassword||NULL==pCode)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword)||0 == strlen(pCode))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_Phone);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_Phone,pPhone);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword,pPassword);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  ITREG_Register(0,0,un32ID,pPhone,pPassword,pCode);
}
IT_API SS_SHORT  IT_Unregister(IN SS_UINT32 const un32ID,IN SS_CHAR const*pPhone,IN SS_CHAR const*pPassword)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pPassword)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    switch(g_s_ITLibHandle.m_e_ITStatus)
    {
    case IT_STATUS_ON_LINE:
    case IT_STATUS_LOGIN_OK:
    case IT_STATUS_LOGOUT_OK:
        {
        }break;
    default:
        {
            return  SS_ERR_STATE;
        }
        break;
    }
    IT_CHECK_NETWORK;
    return  ITREG_Unregister(g_s_ITLibHandle.m_un64WoXinID,0,un32ID,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pPhone,pPassword);
}
IT_API SS_SHORT  IT_UpdatePassword(IN SS_CHAR const*pPhone,IN SS_CHAR const*pOld,IN SS_CHAR const*pNew)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pOld ||NULL==pNew)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pOld)||0 == strlen(pNew))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp);
    SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp,pNew);
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    return  ITREG_UpdatePassword(0,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pOld,pNew);
}
IT_API SS_SHORT  IT_FindPassword(IN SS_UINT32 const un32SellerID,IN SS_CHAR const*pPhone,IN SS_CHAR const*pSMSPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pSMSPhone||0==un32SellerID)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pSMSPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    return  ITREG_FindPassword(0,un32SellerID,pPhone,pSMSPhone);
}
IT_API SS_SHORT  IT_ChangeLoginStatus(IN SS_CHAR const*pPhone,IN SS_BYTE const ubStatus)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    return  ITREG_UpdateLoginState(0,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,ubStatus);
}
IT_API SS_SHORT  IT_ReportVersionIND(
    IN SS_CHAR const*pPhone,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR const*pVersion,
    IN SS_USHORT const usnPhoneModel)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pVersion||0==un32ID||0==usnPhoneModel)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pVersion))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    return  ITREG_ReportVersionIND(0,usnPhoneModel,pPhone,un32ID,pVersion);
}
IT_API SS_SHORT  IT_UpdateCPUID(IN SS_CHAR const*pPhone,IN SS_CHAR const*pID)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pID)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pID))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    return  ITREG_UpdateCPUID(0,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pID);
}
IT_API SS_SHORT  IT_GetBalance(IN SS_CHAR const*pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s||
        NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_GetBalance(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
}
IT_API SS_SHORT  IT_GetUserData(IN SS_CHAR const*pPhone)
{
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	/*if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}*/
    if (0==g_s_ITLibHandle.m_un64WoXinID||NULL==g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
		SS_Log_Printf(SS_ERROR_LOG,"woxinid=" SS_Print64u ",%p",
			g_s_ITLibHandle.m_un64WoXinID,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
        return  SS_ERR_NO_INIT_DB;
    }
    /*if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }*/
	g_s_ITLibHandle.m_ubGetUserDataFlag=SS_TRUE;
    IT_CHECK_NETWORK;
	//IT_CHECK_LOGIN;
    return  ITREG_GetUserData(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
}

IT_API SS_CHAR const*const IT_GetPublicIP()
{
    return  g_s_ITLibHandle.m_sIP;
}
IT_API SS_USHORT           IT_GetPublicPort()
{
    return  g_s_ITLibHandle.m_usnPort;
}


IT_API SS_SHORT  IT_UpdateFriend(
    IN SS_CHAR   const*pRecordID,
    IN SS_CHAR   const*pName,
    IN SS_CHAR   const*pPhone,
    IN SS_UINT32 const un32CreateTime,
    IN SS_UINT32 const un32ModifyTime)
{
    SS_str  *s_pMSG=NULL;
    SS_CHAR  sMSG[4096] = "";
    SS_UINT32 un32len=0;
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pRecordID||NULL==pName)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pRecordID)||0 == strlen(pName))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    IT_CHECK_NETWORK;
    un32len=SS_snprintf(sMSG,sizeof(sMSG),"%s\r%s\r%s\r%u\r%u\r",
        pRecordID,pName,pPhone,un32CreateTime,un32ModifyTime);
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+2)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_UPDATE_USER;
    s_pMSG->m_s[un32len] = 0;
    memcpy(s_pMSG->m_s,sMSG,un32len);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_SlowlyTreatmentLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG->m_s);
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}

IT_API SS_SHORT  IT_DeleteFriend(IN SS_UINT32 const un32RID)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == un32RID)
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_BookUserDelete(g_s_ITLibHandle.m_un64WoXinID,0,un32RID);
}

IT_API SS_SHORT  IT_UpdateFriendRemarkName(
    IN SS_UINT32 const un32RID,
    IN SS_CHAR   const*pRemark)
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
    SS_CHAR  sMSG[4096] = "";
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL==pRemark)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32len=strlen(pRemark)))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    IT_CHECK_NETWORK;
    un32len=SS_snprintf(sMSG,sizeof(sMSG),"%u\r%s\r",un32RID,pRemark);
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+2)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_UPDATE_REMARK_NAME;
    s_pMSG->m_s[un32len] = 0;
    memcpy(s_pMSG->m_s,sMSG,un32len);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG->m_s);
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_LoadFriend()
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_LOAD_FRIEND;
    s_pMSG->m_s = NULL;
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_LoadWoXinFriend()
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_LOAD_WOXIN_FRIEND;
    s_pMSG->m_s = NULL;
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_LoadCallRecord()
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_LOAD_CALL_RECORD;
    s_pMSG->m_s = NULL;
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_UINT32  IT_AddCallRecord(
    IN SS_CHAR const* pPhone,
    IN SS_BYTE const  ubResult,
    IN SS_UINT32 const un32Time,
    IN SS_UINT32 const un32TalkTime)
{
    SS_CHAR  sSQL[2048] = "";
    SS_UINT32  un32RID=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == pPhone || 0 == un32Time)
    {
        SS_Log_Printf(SS_ERROR_LOG,"Param error,Phone=%p,Time=%u,TalkTime=%u",
            pPhone,un32Time,un32TalkTime);
        return -2;//SS_ERR_PARAM
    }
    if (0 == strlen(pPhone))
    {
        return -2;//SS_ERR_PARAM
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return -3;//SS_ERR_NO_INIT_DB;
    }

	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    un32RID=g_s_ITLibHandle.m_un32DB_CallRecordRID++;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO CallRecord(RID,Phone,Result,Time,TalkTime) "
        "VALUES(%u,'%s',%u,%u,%u)",un32RID,pPhone,ubResult,un32Time,un32TalkTime);
    if (SS_SUCCESS != IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL))
    {
        return -1;//SS_FAILURE;
    }
    return  un32RID;
}
IT_API SS_SHORT  IT_DelCallRecord(IN SS_UINT32 const un32RID)
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
    SS_CHAR   sMSG[128] = "";
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    un32len=SS_snprintf(sMSG,sizeof(sMSG),"%u",un32RID);
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+2)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_DEL_CALL_RECORD;
    memset(s_pMSG->m_s,0,un32len+2);
    memcpy(s_pMSG->m_s,sMSG,un32len);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT      IT_GetUserinfo()
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_LOAD_USER_INFO;
    s_pMSG->m_s = NULL;
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT      IT_UpdateUserinfo(
    IN  SS_CHAR const*pName,
    IN  SS_CHAR const*pVName,
    IN  SS_CHAR const*pPhone,
    IN  SS_BYTE const ubSex,
    IN  SS_CHAR const*pBirthday,
    IN  SS_CHAR const*pQQ,
    IN  SS_CHAR const*pCharacterSignature,
    IN  SS_CHAR const*pStreet,
    IN  SS_CHAR const*pArea)
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
    SS_CHAR   sMSG[4096] = "";
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    un32len=SS_snprintf(sMSG,sizeof(sMSG),"%u\r%s\r%s\r%s\r%s\r%s\r%s\r%s\r%s",ubSex,
        pName,pVName,pPhone,pBirthday,pQQ,pCharacterSignature,pStreet,pArea);
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+2)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_UPDATE_USER_INFO;
    memset(s_pMSG->m_s,0,un32len+2);
    memcpy(s_pMSG->m_s,sMSG,un32len);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
//    SS_Log_Printf(SS_STATUS_LOG,"%u,%s,%s,%s,%s,%s,%s,%s,%s",ubSex,
//        pName,pVName,pPhone,pBirthday,pQQ,pCharacterSignature,pStreet,pArea);
    return  SS_SUCCESS;
}


IT_API SS_SHORT  IT_GetFriendIcon(IN SS_UINT32 const un32RID)
{
    SS_str  *s_pMSG=NULL;
    SS_UINT32 un32len=0;
    SS_CHAR  sMSG[128] = "";
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0==un32RID)
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    un32len=SS_snprintf(sMSG,sizeof(sMSG),"%u\r",un32RID);
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+2)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_GET_FRIEND_ICON;
    s_pMSG->m_s[un32len] = 0;
    memcpy(s_pMSG->m_s,sMSG,un32len);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG->m_s);
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_CHAR const*IT_GetFriendIconEx(IN SS_UINT32 const un32RID)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  sPath[1024] = "";
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT icon_path FROM book WHERE RID=%u",un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if (s_ROW[0])
                {
                    memcpy(sPath,s_ROW[0],strlen(s_ROW[0]));
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return sPath;
}
IT_API SS_SHORT  IT_UploadMyIcon(IN SS_CHAR const*pIconPath)
{
    SS_SHORT  usn=0;
    SS_CHAR  *pIcon=NULL;
    SS_UINT32 un32len=0;
    FILE *fp =NULL;
    SS_str *s_pMSG=NULL;
    SS_CHAR  sPath[4096] = "";
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL==pIconPath)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32len=strlen(pIconPath)))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s||
        NULL == g_s_ITLibHandle.m_s_IconPath.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    IT_CHECK_NETWORK;
    if (NULL == (fp = fopen(pIconPath,"rb")))
    {
        return  SS_ERR_PARAM;
    }

    fseek(fp,0,SEEK_END);//移到文件的结尾
    un32len = ftell(fp);//得到文件的长度
    fseek(fp,0,SEEK_SET);//移到文件的开始

    if ((un32len/1024)>180)
    {
        fclose(fp);
        return  SS_ERR_ACTION;
    }

    if (NULL == (pIcon = (SS_CHAR*)SS_malloc(un32len)))
    {
        fclose(fp);
        return  SS_ERR_MEMORY;
    }
    pIcon[un32len]   = 0;
    pIcon[un32len+1] = 0;
    fread(pIcon,un32len,1,fp);
    fclose(fp);
    fp = NULL;

    SS_snprintf(sPath,sizeof(sPath),"%s%s.icon",g_s_ITLibHandle.m_s_IconPath.m_s,
        g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);

    if (NULL == (fp = fopen(sPath,"wb")))
    {
        free(pIcon);
        return  SS_ERR_ACTION;
    }
    fwrite(pIcon,un32len,1,fp);
    fclose(fp);
    fp = NULL;
    
    if (SS_SUCCESS != (usn=ITREG_BookUserUploadMyIcon(g_s_ITLibHandle.m_un64WoXinID,0,pIcon,un32len)))
    {
        free(pIcon);
        return  usn;
    }
    free(pIcon);

    //////////////////////////////////////////////////////////////////////////
	memset(sPath,0,sizeof(sPath));
	un32len=SS_snprintf(sPath,sizeof(sPath),"%s.icon",g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
    if (NULL == (s_pMSG = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pMSG->m_s = (SS_CHAR*)malloc(un32len+4)))
    {
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    s_pMSG->m_len = DB_MSG_UPLOAD_MY_ICON;
    SS_snprintf(s_pMSG->m_s,un32len+2,"%s\r",sPath);
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_Video*)s_pMSG))
    {
        SS_free(s_pMSG->m_s);
        SS_free(s_pMSG);
        return  SS_ERR_MEMORY;
    }
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_UploadPhoneInfo(
    IN SS_USHORT const usnSysType,
    IN SS_CHAR   const*pPhoneModel,
    IN SS_CHAR   const*pSysVersion)
{
    SS_UINT32  un32PhoneModelLen = 0;
    SS_UINT32  un32SysVersionLen = 0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (0 == usnSysType || NULL == pPhoneModel || NULL==pSysVersion)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == (un32PhoneModelLen=strlen(pPhoneModel)) || 0 == (un32SysVersionLen = strlen(pSysVersion)))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_UploadPhoneInfo(g_s_ITLibHandle.m_un64WoXinID,0,usnSysType,pPhoneModel,
        un32PhoneModelLen,pSysVersion,un32SysVersionLen);
}

//-------------------------------------------------------------------

IT_API SS_SHORT  IT_CallBackIND(
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled,
    IN SS_BYTE const ubCallMode,
    IN SS_BYTE const ubRateMode,
	IN SS_UINT32 const un32AppHandle)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    if (NULL==pCaller||NULL==pCalled)
    {
        return  SS_ERR_PARAM;
    }
    if (0 == strlen(pCaller)||0 == strlen(pCalled))
    {
        return  SS_ERR_PARAM;
    }
	if (strlen(pCaller) > 25 ||strlen(pCalled) > 25)
	{
		return  SS_ERR_PARAM;
	}
    IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
    return  ITREG_SendCallBackIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pCaller,pCalled,ubCallMode,ubRateMode,un32AppHandle);
}
IT_API SS_SHORT  IT_CallBackHookIND(
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (NULL==pCaller||NULL==pCalled)
	{
		return  SS_ERR_PARAM;
	}
	if (0 == strlen(pCaller)||0 == strlen(pCalled))
	{
		return  SS_ERR_PARAM;
	}
	IT_CHECK_NETWORK;
	IT_CHECK_LOGIN;
	return  ITREG_SendCallBackHookIND(g_s_ITLibHandle.m_un64WoXinID,0,
		g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,pCaller,pCalled);
}

IT_API SS_SHORT  IT_SetCallTimeOut(IN SS_UINT32 const un32Second)
{
    g_s_ITLibHandle.m_un32CallTimeOut = un32Second;
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_SetServerIP(IN SS_CHAR const *pIP)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (NULL == pIP)
	{
		return SS_ERR_PARAM;
	}
	if (0 == strlen(pIP))
	{
		return SS_ERR_PARAM;
	}
	if (g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_len)
	{
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain);
	}
	SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain,pIP);
/*	SS_CHAR sIP[128] = "";
    if (NULL == pIP)
    {
        return SS_ERR_PARAM;
    }
    if (0 == strlen(pIP))
    {
        return SS_ERR_PARAM;
    }
	if (g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_len)
	{
		SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain);
	}
	SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain,pIP);
	SS_TCP_getRemoterHostIP(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_s,sIP,sizeof(sIP));
    if (g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_len)
    {
        SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_ServerIP);
    }
	if (sIP[0])
	{
		SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerIP,sIP);
		if (SS_SOCKET_ERROR!=g_s_ITLibHandle.m_SignalScoket)
		{
			SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
			g_s_ITLibHandle.m_SignalScoket = SS_SOCKET_ERROR;
		}
		g_s_ITLibHandle.m_e_ITStatus   = IT_STATUS_REG_SERVER_DISCONNECT_OK;
	}*/
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_MakeCall   (
    IN SS_CHAR const*pPhone,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCallerName,
    IN SS_CHAR const*pCalled,
    IN SS_CHAR const*pCalledName)
{
    SS_UINT32  un32PhoneLen=0;
    SS_UINT32  un32CallerLen=0;
    SS_UINT32  un32CallerNameLen=0;
    SS_UINT32  un32CalledLen=0;
    SS_UINT32  un32CalledNameLen=0;
    PIT_AudioConfig  s_pAudio=&g_s_ITLibHandle.m_s_AudioConfig;
    PIT_VideoConfig  s_pVideo=&g_s_ITLibHandle.m_s_VideoConfig;
	SS_SHORT sn=0;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
	if (SS_SUCCESS != (sn=SS_String_CheckPhoneNumber(pPhone)))
	{
		return  sn;
	}
    if (NULL==pCaller||NULL==pCalled||NULL==pCalledName||NULL==pCallerName)
    {
        return  SS_ERR_PARAM;
    }
    if ((0==(un32PhoneLen=strlen(pPhone)))||(0==(un32CallerLen=strlen(pCaller)))||
        (0==(un32CalledLen=strlen(pCalled)))||(0==(un32CallerNameLen=strlen(pCallerName)))||
        (0==(un32CalledNameLen=strlen(pCalledName))))
    {
        return  SS_ERR_PARAM;
    }
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return SS_ERR_NO_INIT_DB;
    }
    if (strcmp(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,pPhone))
    {
        return  SS_ERR_PARAM;
    }
    IT_CHECK_NETWORK;
    
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_IDLE != g_s_ITLibHandle.m_e_CallStatus)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    g_s_ITLibHandle.m_e_Direction = OUTBOUND_CALL;
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_MAKE_CALL;
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_MAKE_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    if (SS_SUCCESS != SS_RTPQueue_Init(&g_s_ITLibHandle.m_s_RTPQueue,65538,180))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init PCM queue faild");
        return  SS_ERR_MEMORY;
    }

    s_pAudio->m_usnPort = 0;
    if (SS_SUCCESS != IT_BindRTPAddr(s_pAudio->m_sIP,s_pAudio->m_usnMinPort,s_pAudio->m_usnMaxPort,
        &s_pAudio->m_usnCurPort,&s_pAudio->m_usnPort,&s_pAudio->m_Socket))
    {
        return  SS_ERR_ACTION;
    }
    SS_GET_MILLISECONDS(g_s_ITLibHandle.m_s_AudioConfig.m_un64Milliseconds);

    //添加语音编码
    s_pAudio->m_un64Code  = SS_AUDIO_CODEC_ALAW;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ULAW;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_GSM;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ILBC_30;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ILBC_20;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_8;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_12;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_16;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_24;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_G729A;
    
//    memset(&s_pAudio->m_s_silk_encoder,0,sizeof(SKP_SILK_SDK_EncControlStruct));
//    memset(&s_pAudio->m_s_silk_decoder,0,sizeof(SKP_SILK_SDK_DecControlStruct));
//    memset(&s_pAudio->m_s_iLBCenc,0,sizeof(iLBC_Enc_Inst_t));
//    memset(&s_pAudio->m_s_iLBCdec,0,sizeof(iLBC_Dec_Inst_t));


    return  ITREG_SendCallInviteIND(g_s_ITLibHandle.m_un64WoXinID,0,
        g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_len,
        pPhone,un32PhoneLen,pCaller,un32CallerLen,pCallerName,un32CallerNameLen,pCalled,
        un32CalledLen,pCalledName,un32CalledNameLen,s_pAudio->m_un64Code,s_pVideo->m_un32Code,
        s_pAudio->m_sIP,strlen(s_pAudio->m_sIP),s_pVideo->m_sIP,strlen(s_pVideo->m_sIP),
        s_pAudio->m_usnPort,s_pVideo->m_usnPort);
}
IT_API SS_SHORT  IT_CancelCall ()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (OUTBOUND_CALL      != g_s_ITLibHandle.m_e_Direction)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    switch(g_s_ITLibHandle.m_e_CallStatus)
    {
    case CALL_STATE_MAKE_CALL:
    case CALL_STATE_ACCEPTED:
    case CALL_STATE_RINGING:
        break;
    default:
        {
            SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
            return  SS_ERR_CALL;
        }break;
    }
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_CANCEL_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTING;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    //发送撤销呼叫的请求
    return  ITREG_SendCallRepealIND(g_s_ITLibHandle.m_un64WoXinID,g_s_ITLibHandle.m_un64CallWoXinID,
        SS_SUCCESS,g_s_ITLibHandle.m_un32CallMSNode,g_s_ITLibHandle.m_un32CallREGNode,g_s_ITLibHandle.m_un32CallITNode);
}
IT_API SS_SHORT  IT_RejectCall (IN SS_UINT32 const un32ReasonCode)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (INBOUND_CALL      != g_s_ITLibHandle.m_e_Direction)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    switch(g_s_ITLibHandle.m_e_CallStatus)
    {
    case CALL_STATE_RINGING:
    case CALL_STATE_INVITE:
        break;
    default:
        {
            SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
            return  SS_ERR_CALL;
        }break;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTING;
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_REJECT_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    return  ITREG_SendCallRejectIND(g_s_ITLibHandle.m_un64CallWoXinID,
        g_s_ITLibHandle.m_un64WoXinID,un32ReasonCode,g_s_ITLibHandle.m_un32CallMSNode,
        g_s_ITLibHandle.m_un32CallREGNode,g_s_ITLibHandle.m_un32CallITNode);

}
IT_API SS_SHORT  IT_AlertingCall()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_INVITE != g_s_ITLibHandle.m_e_CallStatus ||
        INBOUND_CALL      != g_s_ITLibHandle.m_e_Direction)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_RINGING;
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_ALERTING_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  ITREG_SendCall180IND(g_s_ITLibHandle.m_un64CallWoXinID,g_s_ITLibHandle.m_un64WoXinID,
        SS_SUCCESS,g_s_ITLibHandle.m_un32CallMSNode,g_s_ITLibHandle.m_un32CallREGNode,g_s_ITLibHandle.m_un32CallITNode);
}
IT_API SS_SHORT  IT_AnswerCall ()
{
    PIT_AudioConfig  s_pAudio=&g_s_ITLibHandle.m_s_AudioConfig;
    PIT_VideoConfig  s_pVideo=&g_s_ITLibHandle.m_s_VideoConfig;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_RINGING != g_s_ITLibHandle.m_e_CallStatus ||
        INBOUND_CALL       != g_s_ITLibHandle.m_e_Direction)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_CONNECTEDING;
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_ANSWER_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    if (SS_SUCCESS != SS_RTPQueue_Init(&g_s_ITLibHandle.m_s_RTPQueue,65538,180))
    {
        SS_Log_Printf(SS_ERROR_LOG,"init PCM queue faild");
        return  SS_ERR_MEMORY;
    }
    SS_GET_MILLISECONDS(g_s_ITLibHandle.m_s_AudioConfig.m_un64Milliseconds);
    s_pAudio->m_usnPort = 0;
    if (SS_SUCCESS != IT_BindRTPAddr(s_pAudio->m_sIP,s_pAudio->m_usnMinPort,s_pAudio->m_usnMaxPort,
        &s_pAudio->m_usnCurPort,&s_pAudio->m_usnPort,&s_pAudio->m_Socket))
    {
        return  SS_ERR_ACTION;
    }

    s_pAudio->m_un64Code  = SS_AUDIO_CODEC_ALAW;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ULAW;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_GSM;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ILBC_30;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_ILBC_20;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_8;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_12;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_16;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_SILK_24;
    s_pAudio->m_un64Code += SS_AUDIO_CODEC_G729A;

    return  ITREG_SendCall200IND(g_s_ITLibHandle.m_un64CallWoXinID,g_s_ITLibHandle.m_un64WoXinID,
        g_s_ITLibHandle.m_un32CallMSNode,g_s_ITLibHandle.m_un32CallREGNode,g_s_ITLibHandle.m_un32CallITNode,
        s_pAudio->m_un64Code,s_pVideo->m_un32Code,s_pAudio->m_sIP,strlen(s_pAudio->m_sIP),s_pVideo->m_sIP,
        strlen(s_pVideo->m_sIP),s_pAudio->m_usnPort,s_pVideo->m_usnPort);
}
IT_API SS_SHORT  IT_ReleaseCall()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_IDLE == g_s_ITLibHandle.m_e_CallStatus)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTING;
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_RELEASE_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    if (OUTBOUND_CALL==g_s_ITLibHandle.m_e_Direction)
    {
        return  ITREG_SendCallBeyIND(g_s_ITLibHandle.m_un64WoXinID,g_s_ITLibHandle.m_un64CallWoXinID,
            SS_SUCCESS,g_s_ITLibHandle.m_un32CallMSNode,g_s_ITLibHandle.m_un32CallREGNode,
            g_s_ITLibHandle.m_un32CallITNode);
    }
    else
    {
        return  ITREG_SendCallBeyIND(g_s_ITLibHandle.m_un64CallWoXinID,g_s_ITLibHandle.m_un64WoXinID,
            SS_SUCCESS,g_s_ITLibHandle.m_un32CallMSNode,g_s_ITLibHandle.m_un32CallREGNode,
            g_s_ITLibHandle.m_un32CallITNode);
    }
}
IT_API SS_SHORT  IT_DTMF(IN SS_BYTE const ubKey)
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (OUTBOUND_CALL!= g_s_ITLibHandle.m_e_Direction)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    if (CALL_STATE_CONNECTED == g_s_ITLibHandle.m_e_CallStatus)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_ERR_CALL;
    }
    g_s_ITLibHandle.m_un32CallCMD = IT_MSG_DTMF_CALL_TIME_OUT;
    SS_GET_SECONDS(g_s_ITLibHandle.m_CallTimeOut);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    return  ITREG_SendCallDTMF_IND(0,0,ubKey,g_s_ITLibHandle.m_un32CallMSNode,
        g_s_ITLibHandle.m_un32CallREGNode,g_s_ITLibHandle.m_un32CallITNode);
}
IT_API SS_SHORT  IT_EmptyCallStateMachine()
{
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"API");
#endif
    return  IT_FreeCallResource();
}

IT_API SS_SHORT  IT_SendPCM(IN SS_CHAR const*pPCM,IN SS_UINT32 const un32PCMLen)
{
    SS_str  *s_pcm;
    SS_UINT32 un32Len = 0;
    if (NULL == pPCM || 0 == un32PCMLen)
    {
        return  SS_ERR_PARAM;
    }
    switch(g_s_ITLibHandle.m_s_AudioConfig.m_un32Sampling)
    {
    case 8000:
        {
            un32Len = 320;
        }break;
    case 16000:
        {
            un32Len = 640;
        }break;
    default:return  SS_ERR_ACTION;
    }
    if (CALL_STATE_CONNECTED != g_s_ITLibHandle.m_e_CallStatus)
    {
        return  SS_ERR_CALL;
    }
    if (NULL == (s_pcm = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pcm->m_s = (SS_CHAR*)malloc(un32Len+1)))
    {
        free(s_pcm);
        return  SS_ERR_MEMORY;
    }
    memset(s_pcm->m_s,0,un32Len);
    s_pcm->m_len = un32Len;
    memcpy(s_pcm->m_s,pPCM,(un32PCMLen > un32Len)?un32Len:un32PCMLen);

    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_PCMLinkQueue,(SS_Video*)s_pcm))
    {
        SS_free(s_pcm->m_s);
        SS_free(s_pcm);
        return  SS_ERR_MEMORY;
    }

/*    SS_str  *s_pcm;
    SS_UINT32 un32Len = (8000==g_s_ITLibHandle.m_s_AudioConfig.m_un32Sampling)?965:1925;
    if (NULL == pPCM || 0 == un32PCMLen || un32PCMLen > 1920)
    {
        return SS_ERR_PARAM;
    }
    if (CALL_STATE_CONNECTED != g_s_ITLibHandle.m_e_CallStatus)
    {
        return  SS_ERR_CALL;
    }
    if (NULL == (s_pcm = (SS_str *)malloc(sizeof(SS_str))))
    {
        return  SS_ERR_MEMORY;
    }
    if (NULL == (s_pcm->m_s = (SS_CHAR*)malloc(un32Len+1)))
    {
        free(s_pcm);
        return  SS_ERR_MEMORY;
    }
    memset(s_pcm->m_s+un32PCMLen,0,un32Len-un32PCMLen);
    s_pcm->m_len = un32PCMLen;
    s_pcm->m_s[s_pcm->m_len] = 0;
    memcpy(s_pcm->m_s,pPCM,s_pcm->m_len);
    
    if (SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_PCMLinkQueue,(SS_Video*)s_pcm))
    {
        SS_free(s_pcm->m_s);
        SS_free(s_pcm);
        return  SS_ERR_MEMORY;
    }*/
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_SetPCMCallBack(IN SS_SHORT (*f_PCMCallBack)(IN SS_CHAR const*,IN SS_UINT32 const))
{
    if (NULL == f_PCMCallBack)
    {
        return SS_ERR_PARAM;
    }
    g_s_ITLibHandle.m_f_PCMCallBack = f_PCMCallBack;
    return  SS_SUCCESS;
}
//-------------------------------------------------------------------
IT_API SS_SHORT  IT_SendIMMessage(
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pFriend,
    IN SS_CHAR   const*pContent,
    IN SS_UINT32 const un32ContentLen,
    IN  SS_BYTE  const ubLanguage,
    IN  SS_BYTE  const ubFontCodec,
    IN  SS_BYTE  const ubFontStyle,
    IN  SS_BYTE  const ubFontColor,
    IN  SS_BYTE  const ubFontSpecialties)
{
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_GetIMNewMessage (IN SS_CHAR const*pPhone)
{
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_GetIMSynchronous(IN SS_CHAR const*pPhone,IN SS_CHAR const*pDataTime)
{
    if (NULL==pPhone||NULL==pDataTime)
    {
        return  SS_ERR_PARAM;
    }
    return  ITREG_GetIMSynchronous(0,0,pPhone,pDataTime);
}
IT_API SS_SHORT  IT_GetIMSelect(IN SS_CHAR const*pFriend,IN SS_UINT32 const un32CurRID){
    return  SS_SUCCESS;
}



IT_API SS_SHORT  IT_SendIMGroupMessage(
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pGroupID,
    IN SS_CHAR   const*pContent,
    IN SS_UINT32 const un32ContentLen,
    IN  SS_BYTE  const ubLanguage,
    IN  SS_BYTE  const ubFontCodec,
    IN  SS_BYTE  const ubFontStyle,
    IN  SS_BYTE  const ubFontColor,
    IN  SS_BYTE  const ubFontSpecialties)
{
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_GetIMGroupNewMessage (IN SS_CHAR const*pPhone,IN SS_CHAR const*pGroupID)
{
    return  SS_SUCCESS;
}
IT_API SS_SHORT  IT_GetIMGroupSynchronous(IN SS_CHAR const*pPhone,IN SS_CHAR const*pGroupID,IN SS_CHAR const*pDataTime)
{
    SS_UINT32 un64GroupID=0;
    if (NULL==pPhone||NULL==pGroupID||NULL==pDataTime)
    {
        return  SS_ERR_PARAM;
    }
    SS_aToun64(pGroupID,un64GroupID);
    return  ITREG_GetIMGroupSynchronous(0,0,pPhone,un64GroupID,pDataTime);
}
IT_API SS_SHORT  IT_GetIMGroupSelect(IN SS_CHAR const*pGroupID,IN SS_UINT32 const un32CurRID)
{
    return  SS_SUCCESS;
}


