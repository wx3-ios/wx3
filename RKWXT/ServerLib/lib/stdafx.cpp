// stdafx.cpp : source file that includes just the standard includes
//    it_lib.pch will be the pre-compiled header
//    stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
#include "it_lib_db.h"


SS_SHORT IT_CharProc(IN SS_CHAR const*pSrc,OUT SS_CHAR *pDest)
{
	SS_UINT32  un32=0;
	SS_UINT32  un32Len=strlen(pSrc);
	if (NULL==pSrc||NULL==pDest)
	{
		return  SS_ERR_PARAM;
	}
	for (un32=0;un32<un32Len;un32++)
	{
		if ('\'' == *pSrc || '\\' == *pSrc || '"' == *pSrc)
		{
			*pDest = '\\';
			pDest++;
		}
		*pDest++=*pSrc++;
	}
	return  SS_SUCCESS;
}

SS_SHORT IT_BindRTPAddr(
    IN  SS_CHAR   const*pIP,
    IN  SS_USHORT const usnMinPort,
    IN  SS_USHORT const usnMaxPort,
    IN  SS_USHORT *pusnCurPort,
    IN  SS_USHORT *pusnPort,
    IN  SS_Socket *pSocket)
{
    SS_USHORT  usn=0;
    for (usn=usnMinPort;usn<usnMaxPort;usn++)
    {
        if (*pusnCurPort >= usnMaxPort)
        {
            *pusnCurPort = usnMinPort;
        }
        if (SS_SOCKET_ERROR ==(*pSocket = SS_UDP_Bind(pIP,*pusnCurPort)))
        {
            *pusnCurPort = (*pusnCurPort)+1;
            continue;
        }
        //bind OK
        *pusnPort    = *pusnCurPort;
        *pusnCurPort = (*pusnCurPort)+1;
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"bind udp port ok,Port=%u",*pusnPort);
#endif
        return  SS_SUCCESS;
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_ERROR_LOG,"bind udp port fail,MaxPort=%u,MinPort=%u",usnMaxPort,usnMinPort);
#endif
    return  SS_FAILURE;
}
SS_CHAR const* IT_GetCallStatusString(IN SS_CallStatus const e_CallStatus)
{
    switch(e_CallStatus)
    {
    case CALL_STATE_IDLE              :{return "Idle";}break;
    case CALL_STATE_INVITEING         :{return "Inviteing";}break;
    case CALL_STATE_INVITE            :{return "Invite";}break;
    case CALL_STATE_RINGING           :{return "Ringing";}break;
    case CALL_STATE_ACCEPTED          :{return "Accepted";}break;
    case CALL_STATE_CONNECTEDING      :{return "Connecteding";}break;
    case CALL_STATE_CONNECTED         :{return "Connected";}break;
    case CALL_STATE_DISCONNECTING     :{return "Disconnecting";}break;
    case CALL_STATE_DISCONNECTED      :{return "Disconnected";}break;
    case CALL_STATE_TERMINATED        :{return "TERMINATED";}break;
    case CALL_STATE_FROM_ACCEPTED     :{return "FromAccepted";}break;
    case CALL_STATE_CANCELLED         :{return "Cancel";}break;
    case CALL_STATE_CANCELLING        :{return "Canceling";}break;
    case CALL_STATE_UPDATE            :{return "update";}break;
    case CALL_STATE_PROCEEDING_TIMEOUT:{return "ProceedingTimeOut";}break;
    case CALL_STATE_MSG_SEND_FAILURE  :{return "MSGSendfail";}break;
    case CALL_STATE_TIMEOUT           :{return "TimeOut";}break;
    case CALL_STATE_REJECTING         :{return "Rejecting";}break;
    case CALL_STATE_NEW_CALL          :{return "NewCall";}break;
    case CALL_STATE_TRANSFERING       :{return "TRANSFERING";}break;
    case CALL_STATE_TRANSFER          :{return "TRANSFER";}break;
    case CALL_STATE_DTMF              :{return "DTMF";}break;
    case CALL_STATE_MAKE_CALL         :{return "MakeCall";}break;
    case CALL_STATE_RINGING_CODEC     :{return "RingingCodec";}break;
    case CALL_STATE_REINVITE          :{return "ReInvite";}break;
    case CALL_STATE_MODE_T38_IMAGE    :{return "T38Image";}break;
    case CALL_STATE_PLAY_SOUND        :{return "PlaySound";}break;
    case CALL_STATE_NEW_AUDIO_RTP     :{return "NewAudioRTP";}break;
    case CALL_STATE_NEW_VIDEO_RTP     :{return "NewVideoRTP";}break;
    case CALL_STATE_FREE_RESOURCE     :{return "FreeResource";}break;
    default:break;
    }
    return  "Unknow";
}


SS_SHORT IT_RegisterCFM           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_UINT64   un64WoXinID = 0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_USHORT   usnPort=0;
    SS_str      s_IP;
    SS_CHAR     sResult[12] = "";
    SS_CHAR     sWoXinID[64] = "";
    SS_CHAR    *Param[4];
    SS_INIT_str(s_IP);
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_REGISTER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_REGISTER_CFM_TYPE_IP:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_IP);
            goto Divide_GOTO;
        }break;
    case ITREG_REGISTER_CFM_TYPE_PORT:
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnPort);
            goto Divide_GOTO;
        }break;
    case ITREG_REGISTER_CFM_TYPE_WOXIN_ID:
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64WoXinID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

    SS_snprintf(sWoXinID,sizeof(sWoXinID),SS_Print64u,un64WoXinID);
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_REGISTER_CFM message,%s,Result=%u,"
            "Addr=%s_%u,WoXinID=%s",sHeader,ubResult,s_IP.m_s,usnPort,sWoXinID);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRegister.m_ubFlag)
	{
		if (un64WoXinID)
		{
			SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo);
			SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo,sWoXinID);
			IT_DBSetLoginID(sWoXinID);
			g_s_ITLibHandle.m_un64WoXinID = un64WoXinID;
		}
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sWoXinID;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_REGISTER_CFM,Param,2);
		memset(g_s_ITLibHandle.m_sIP,0,sizeof(g_s_ITLibHandle.m_sIP));
		g_s_ITLibHandle.m_usnPort=usnPort;
		strncpy(g_s_ITLibHandle.m_sIP,s_IP.m_s,SS_IP_SIZE);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRegister.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_UnregisterCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[12] = "";
    SS_CHAR    *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_REGISTER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UNREGISTER_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUnregister.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UNREGISTER_CFM,Param,1);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUnregister.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_UpdatePasswordCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    //SS_UINT64   un64WoXinID=0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[3];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_PASSWORD_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_PASSWORD_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdatePassword.m_ubFlag)
	{
		if (SS_SUCCESS == ubResult)
		{
			if (g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp.m_s)
			{
				IT_DBSetLoginPassWord(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp.m_s);
				SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword);
				SS_COPY_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword,g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp);
				//SS_aToun64(g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,un64WoXinID);
				//ITREG_Login(g_s_ITLibHandle.m_un64WoXinID,0,g_s_ITLibHandle.m_un32SellerID,g_s_ITLibHandle.m_usnPhoneModel,
				//    g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s,
				//    g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_s);
			}
		}
		SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
		Param[0] = sMSG;
		Param[1] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UPDATE_PASSWORD,Param,1);
		SS_USLEEP(1000);
		IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdatePassword.m_ubFlag = SS_TRUE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_FindPasswordCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[3];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_FIND_PASSWORD_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_FIND_PASSWORD_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutFindPassword.m_ubFlag)
	{
		SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
		Param[0] = sMSG;
		Param[1] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_FIND_PASSWORD,Param,1);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutFindPassword.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_UpdateLoginStateCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[3];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_LOGIN_STATE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_LOGIN_STATE_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_UPDATE_LOGIN_STATE,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT IT_FriendLoginStateChange(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_CurVersionCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sID[64] = "";
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[8];
    SS_str    s_url;
    SS_str    s_Info;
    SS_str    s_NewVer;
    SS_UINT32 un32ID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_url);
    SS_INIT_str(s_Info);
    SS_INIT_str(s_NewVer);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CUR_VERSION_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_CUR_VERSION_CFM_TYPE_URL:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_url);
            goto Divide_GOTO;
        }break;
    case ITREG_CUR_VERSION_CFM_TYPE_INFO:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    case ITREG_CUR_VERSION_CFM_TYPE_NEW_VER:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_NewVer);
            goto Divide_GOTO;
        }break;
    case ITREG_CUR_VERSION_CFM_TYPE_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CUR_VERSION_CFM message,%s,Result=%u,"
            "url=%s,ID=%u,Info=%s,NewVer=%s",sHeader,ubResult,s_url.m_s,un32ID,s_Info.m_s,s_NewVer.m_s);
    }
#endif
	if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportVersionIND.m_ubFlag)
	{
		SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
		SS_snprintf(sID,sizeof(sID),"%u",un32ID);
		Param[0] = sMSG;
		Param[1] = s_url.m_s;
		Param[2] = s_Info.m_s;
		Param[3] = sID;
		Param[4] = s_NewVer.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_REPORT_VERSION_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportVersionIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_UpdateCPUID_CFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[3];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_CPUID_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_CPUID_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_ubFlag)
	{
		SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
		Param[0] = sMSG;
		Param[1] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UPDATE_CPUID_CFM,Param,1);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_RemoteLoginIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     usnPhoneType=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[3];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_REMOTE_LOGIN_IND_TYPE_TYEP:
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnPhoneType);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_REMOTE_LOGIN_IND message,%s,ubType=%u",sHeader,usnPhoneType);
    }
#endif
    SS_snprintf(sMSG,sizeof(sMSG),"%u",usnPhoneType);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_REMOTE_LOGIN_IND,Param,1);
    SS_USLEEP(1000);
    IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
    g_s_ITLibHandle.m_un64WoXinID=0;
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_Phone);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp);
    SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp);
    return  SS_SUCCESS;
}
SS_SHORT IT_SYS_MSG               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_SYSMerchantMSG        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_SYSEnterpriseMSG      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_SYSPersonalMSG        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_WindowShock           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IT_GetBalanceCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[8] = "";
    SS_CHAR  *Param[4];
    SS_str    s_Balance;
    SS_INIT_str(s_Balance);
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_GET_BALANCE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_BALANCE_CFM_TYPE_BALANCE:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Balance);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_GET_BALANCE_CFM message,%s,"
            "Result=%u,Balance=%s",sHeader,ubResult,s_Balance.m_s);
    }
#endif
    if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetBalance.m_ubFlag)
	{
		SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
		Param[0] = sMSG;
		Param[1] = s_Balance.m_s;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_BALANCE_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetBalance.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_GetUserInfoCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[20];
    SS_str    s_Balance;
    SS_str    s_Amount;
    SS_str    s_Icon;
	SS_str   s_Name;
	SS_str   s_VName;
	SS_str   s_Phone;
	SS_BYTE  ubSex=0;
	SS_str   s_Birthday;
	SS_str   s_QQ;
	SS_str   s_CharacterSignature;
	SS_str   s_Street;
	SS_str   s_Area;

    SS_UINT32 un32Integral=0;
    SS_UINT32 un32OnLineTime=0;
    SS_BYTE   ubCurState = 0;
    SS_USHORT usnLevel=0;
    SS_CHAR  sResult[20] = "";
    SS_CHAR  sIntegral[24] = "";
    SS_CHAR  sOnLineTime[24] = "";
    SS_CHAR  sCurState[8] = "";
    SS_CHAR  sLevel[12] = "";
	SS_CHAR  sSex[12] = "";
    SS_CHAR  sPath[2048] = "";
    FILE *fp = NULL;

    SS_INIT_str(s_Balance);
    SS_INIT_str(s_Amount);
    SS_INIT_str(s_Icon);
	SS_INIT_str(s_Name);
	SS_INIT_str(s_VName);
	SS_INIT_str(s_Phone);
	SS_INIT_str(s_Birthday);
	SS_INIT_str(s_QQ);
	SS_INIT_str(s_CharacterSignature);
	SS_INIT_str(s_Street);
	SS_INIT_str(s_Area);

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_GET_USER_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_CUR_STATE:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubCurState);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_BALANCE:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Balance);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_AMOUNT:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Amount);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_ON_LINE_TIME:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32OnLineTime);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_INTEGRAL:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Integral);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_LEVEL:
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnLevel);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_USER_INFO_CFM_TYPE_ICON:
        {
            SSMSG_GetBigMessageParam(pParam,usnType,s_Icon);
            goto Divide_GOTO;
        }break;
	case ITREG_GET_USER_INFO_CFM_TYPE_SEX:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubSex);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_NAME:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Name);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_VNAME:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_VName);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_PHONE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Phone);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_BIRTHBAY:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Birthday);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_QQ:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_QQ);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_CHARACTER_SIGNATURE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_CharacterSignature);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_STREET:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Street);
			goto Divide_GOTO;
		}break;
	case ITREG_GET_USER_INFO_CFM_TYPE_AREA:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Area);
			goto Divide_GOTO;
		}break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_GET_USER_INFO_CFM message,%s,Result=%u,Balance=%s,"
			"CurState=%u,Amount=%s,OnLineTime=%u,Integral=%u,Level=%u,Icon=%u,Sex=%u,Name=%s,VName=%s,"
			"Phone=%s,Birthday=%s,QQ=%s,CharacterSignature=%s,Street=%s,Area=%s",sHeader,ubResult,
			s_Balance.m_s,ubCurState,s_Amount.m_s,un32OnLineTime,un32Integral,usnLevel,s_Icon.m_len,
			ubSex,s_Name.m_s,s_VName.m_s,s_Phone.m_s,s_Birthday.m_s,s_QQ.m_s,s_CharacterSignature.m_s,
			s_Street.m_s,s_Area.m_s);
    }
#endif

	SS_CHAR sSQL[8192] = "";
	SS_snprintf(sPath,sizeof(sPath),SS_Print64u ".icon",g_s_ITLibHandle.m_un64WoXinID);
	SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET Name='%s',VName='%s',Phone='%s',sex=%u,"
		"birthday='%s',qq=%s,character_signature='%s',street='%s',area='%s',icon_path='%s' ",
		s_Name.m_s,s_VName.m_s,s_Phone.m_s,ubSex,s_Birthday.m_s,s_QQ.m_s,s_CharacterSignature.m_s,
		s_Street.m_s,s_Area.m_s,sPath);
	IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);

    Param[7] = "";
    //有大头像
    if (s_Icon.m_len)
    {
        SS_snprintf(sPath,sizeof(sPath),"%s" SS_Print64u ".icon",
            g_s_ITLibHandle.m_s_IconPath.m_s,g_s_ITLibHandle.m_un64WoXinID);
        if (fp = fopen(sPath,"wb"))
        {
            fwrite(s_Icon.m_s,s_Icon.m_len,1,fp);
            fclose(fp);
            fp = NULL;
            Param[7] = sPath;
        }
    }

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    SS_snprintf(sIntegral,sizeof(sIntegral),"%u",un32Integral);
    SS_snprintf(sOnLineTime,sizeof(sOnLineTime),"%u",un32OnLineTime);
    SS_snprintf(sCurState,sizeof(sCurState),"%u",ubCurState);
    SS_snprintf(sLevel,sizeof(sLevel),"%u",usnLevel);
	SS_snprintf(sSex,sizeof(sSex),"%u",ubSex);

    Param[0] = sResult;
    Param[1] = sOnLineTime;
    Param[2] = s_Balance.m_s;
    Param[3] = sCurState;
    Param[4] = s_Amount.m_s;
    Param[5] = sIntegral;
    Param[6] = sLevel;
	Param[8] = s_Name.m_s;
	Param[9] = s_VName.m_s;
	Param[10] = s_Phone.m_s;
	Param[11] = sSex;
	Param[12] = s_Birthday.m_s;
	Param[13] = s_QQ.m_s;
	Param[14] = s_CharacterSignature.m_s;
	Param[15] = s_Street.m_s;
	Param[16] = s_Area.m_s;
    Param[17] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_GET_USER_INFO_CFM,Param,17);
    return  SS_SUCCESS;
}

SS_SHORT IT_GetPhoneCheckCodeCFM  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[8] = "";
    SS_str      s_Code;
    SS_INIT_str(s_Code);
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_GET_PHONE_CHECK_CODE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_PHONE_CHECK_CODE_CFM_TYPE_CHECK_CODE:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Code);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_GET_PHONE_CHECK_CODE_CFM "
            "message,%s,Result=%u,Code=%s",sHeader,ubResult,s_Code.m_s);
    }
#endif
    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);

    Param[0] = sResult;
    Param[1] = s_Code.m_s;
    Param[2] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_GET_PHONE_CHECK_CODE_CFM,Param,2);
    return  SS_SUCCESS;
}

SS_SHORT IT_LoginCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_USHORT   usnPort=0;
    SS_str      s_IP;
    SS_CHAR     sBuf[1024] = "";
    SS_CHAR     sPath[8192] = "";
    SS_INIT_str(s_IP);
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_LOGIN_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_LOGIN_CFM_TYPE_IP:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_IP);
            goto Divide_GOTO;
        }break;
    case ITREG_LOGIN_CFM_TYPE_PORT:
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnPort);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_LOGIN_CFM message,%s,Result=%u,Addr=%s_%u",
            sHeader,ubResult,s_IP.m_s,usnPort);
    }
#endif
    if (SS_SUCCESS == ubResult)
    {
        if (g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp.m_s)
        {
            SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_Phone);
            SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_Phone,g_s_ITLibHandle.m_s_Config.m_s_PhoneTemp.m_s);
        }
        if (g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp.m_s)
        {
            SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword);
            SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword,g_s_ITLibHandle.m_s_Config.m_s_UserPasswordTemp.m_s);
        }

        g_s_ITLibHandle.m_un64WoXinID = un64Dest;
        SS_snprintf(sBuf,sizeof(sBuf),SS_Print64u,un64Dest);
        SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo);
        SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo,sBuf);

        SS_snprintf(sPath,sizeof(sPath),"%s%s.db",
            g_s_ITLibHandle.m_s_Config.m_s_DBPath.m_s,sBuf);
        SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath);
        SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath,sPath);

        if (IT_GetConnectSqliteStatus(&g_s_ITLibHandle))
        {
#ifdef  IT_LIB_DEBUG
			SS_Log_Printf(SS_STATUS_LOG,"Disconnect sqlite DB");
#endif
            IT_DisconnectSqliteDB(&g_s_ITLibHandle);
        }
        IT_CheckUserDB(SS_FALSE);
        
        IT_DBSetLoginID(g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s);
        IT_DBSetPhoneNumber(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s);
        IT_DBSetLoginPassWord(g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_s);
		if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag)
		{
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGIN_OK);
		}
    }
    else if (SS_ERR_NO_ACCOUNT == ubResult)
    {
		if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag)
		{
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGIN_NOT_ACCOUNT);
		}
		SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
		g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag = SS_FALSE;
		SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
		return SS_SUCCESS;
    } 
    else
    {
		if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag)
		{
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGIN_ERR);
		}
		SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
		g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag = SS_FALSE;
		SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
		return SS_SUCCESS;
    }
    memset(g_s_ITLibHandle.m_sIP,0,sizeof(g_s_ITLibHandle.m_sIP));
    g_s_ITLibHandle.m_usnPort=usnPort;
    strncpy(g_s_ITLibHandle.m_sIP,s_IP.m_s,SS_IP_SIZE);
    IT_DBCheckUploadBook();
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_LogoutCFM             (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_LOGOUT_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_LOGOUT_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogout.m_ubFlag)
	{
		if (SS_SUCCESS == ubResult)
		{
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGOUT_OK);
		}
		else
		{
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGOUT_ERR);
		}
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogout.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT IT_UploadPhoneInfoCFM    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[8] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPLOAD_PHONE_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPLOAD_PHONE_INFO_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    Param[0] = sResult;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_UPLOAD_PHONE_INFO_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT IT_UploadUserInfoCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  sResult[8] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_USER_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_USER_INFO_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
    if (SS_SUCCESS == ubResult)
    {
        SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET synchronous_update_flag=0 ");
        IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    }
    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    Param[0] = sResult;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_UPDATE_USER_INFO_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT IT_ReportTokenCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32SellerID=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[32] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_REPORT_TOKEN_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_REPORT_TOKEN_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_REPORT_TOKEN_CFM message,%s,"
            "Result=%u,SellerID=%u",sHeader,ubResult,un32SellerID);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportTokenIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_REPORT_TOKEN_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportTokenIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_UpdateREGShopCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[32] = "";
    SS_CHAR  sShopID[32] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_REG_SHOP_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_UPDATE_REG_SHOP_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_UPDATE_REG_SHOP_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_REG_SHOP_CFM message,%s,"
            "Result=%u,SellerID=%u,ShopID=%u",sHeader,ubResult,un32SellerID,un32ShopID);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UPDATE_REG_SHOP_CFM,Param,3);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_AboutCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
	SS_CHAR  sSQL[1024] = "";
    SS_str   s_Json;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_IT_ABOUT_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_IT_ABOUT_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam(pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_IT_ABOUT_CFM message,%s,Result=%u,Json=%s",sHeader,ubResult,s_Json.m_s);
    }
#endif
	if (0 == ubResult)
	{
		SS_snprintf(sSQL,sizeof(sSQL),"delete from About;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		SS_GET_SECONDS(un32Time);
		SS_CHAR *pCache=NULL;
		if (pCache = (SS_CHAR *)SS_malloc(s_Json.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Json.m_s,s_Json.m_len);
			SS_snprintf(pCache,s_Json.m_len*2+1024,"INSERT INTO About(context,time) "
				"VALUES('%s',%u);",pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM About;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			memset(sSQL,0,sizeof(sSQL));
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[1] = pInfo;
						Param[2] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_CFM,Param,2);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = s_Json.m_s;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return   SS_SUCCESS;
}
SS_SHORT IT_AboutHelpCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_str   s_Content;
	SS_UINT32   un32Time=0;
	SS_BYTE     ubFlag=SS_FALSE;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  sSQL[1024] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Content);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_IT_ABOUT_HELP_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_IT_ABOUT_HELP_CFM_TYPE_CONTENT:
        {
            SSMSG_GetBigMessageParam(pParam,usnType,s_Content);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_IT_ABOUT_HELP_CFM message,%s,"
            "Result=%u,Content=%s",sHeader,ubResult,s_Content.m_s);
    }
#endif
	if (0 == ubResult)
	{
		SS_snprintf(sSQL,sizeof(sSQL),"delete from AboutHelp;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		SS_GET_SECONDS(un32Time);
		SS_CHAR *pCache=NULL;
		if (pCache = (SS_CHAR *)SS_malloc(s_Content.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Content.m_s,s_Content.m_len);
			SS_snprintf(pCache,s_Content.m_len*2+1024,"INSERT INTO AboutHelp(context,time) "
				"VALUES('%s',%u);",pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM AboutHelp;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			memset(sSQL,0,sizeof(sSQL));
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[0] = "0";
						Param[1] = pInfo;
						Param[2] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_HELP_CFM,Param,2);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = s_Content.m_s;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_HELP_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return   SS_SUCCESS;
}
SS_SHORT IT_AboutProtocolCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_str   s_Content;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SS_CHAR  sSQL[1024] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Content);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_IT_ABOUT_PROTOCOL_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_IT_ABOUT_PROTOCOL_CFM_TYPE_CONTENT:
        {
            SSMSG_GetBigMessageParam(pParam,usnType,s_Content);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_IT_ABOUT_PROTOCOL_CFM message,%s,"
            "Result=%u,Content=%s",sHeader,ubResult,s_Content.m_s);
    }
#endif
	if (0 == ubResult)
	{
		SS_snprintf(sSQL,sizeof(sSQL),"delete from AboutProtocol;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		SS_GET_SECONDS(un32Time);
		SS_CHAR *pCache=NULL;
		if (pCache = (SS_CHAR *)SS_malloc(s_Content.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Content.m_s,s_Content.m_len);
			SS_snprintf(pCache,s_Content.m_len*2+1024,"INSERT INTO AboutProtocol(context,time) "
				"VALUES('%s',%u);",pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		memset(sSQL,0,sizeof(sSQL));
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM AboutProtocol;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			memset(sSQL,0,sizeof(sSQL));
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[0] = "0";
						Param[1] = pInfo;
						Param[2] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_PROTOCOL_CFM,Param,2);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = s_Content.m_s;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_PROTOCOL_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return   SS_SUCCESS;
}
SS_SHORT IT_AboutFeedBackCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_IT_ABOUT_FEED_BACK_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_IT_ABOUT_FEED_BACK_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_FEED_BACK_CFM,Param,1);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return   SS_SUCCESS;
}
SS_SHORT IT_RechargeCFM           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32SellerID=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[24] = "";
    SS_str      s_OrderID;
    SS_str      s_PhpURL;
	SS_str      s_WoXinResult;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_INIT_str(s_OrderID);
    SS_INIT_str(s_PhpURL);
	SS_INIT_str(s_WoXinResult);
Divide_GOTO:

    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_RECHARGE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_RECHARGE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_RECHARGE_CFM_TYPE_ORDER_ID:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_OrderID);
            goto Divide_GOTO;
        }break;
    case ITREG_RECHARGE_CFM_TYPE_PHP_URL:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_PhpURL);
            goto Divide_GOTO;
        }break;
	case ITREG_RECHARGE_CFM_TYPE_WOXIN_RESULT:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_WoXinResult);
			goto Divide_GOTO;
		}break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_RECHARGE_CFM message,%s,Result=%u,SellerID=%u,"
            "OrderID=%s,PhpURL=%s,WoXinResult=%s",sHeader,ubResult,un32SellerID,s_OrderID.m_s,
			s_PhpURL.m_s,s_WoXinResult.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRechargeIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = s_OrderID.m_s;
		Param[3] = s_PhpURL.m_s;
		Param[4] = s_WoXinResult.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_RECHARGE_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRechargeIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_GetRechargePreferentialCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32SellerID=0;
	SS_UINT32   un32Time=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[24] = "";
	SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sMSG[20480]="";
	SS_CHAR const*p=NULL;
    SS_str      s_Json;
	SS_BYTE  ubFlag=SS_FALSE;
	SS_UINT32 un32Len=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:

    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM_TYPE_JSON:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM message,%s,"
            "Result=%u,SellerID=%u,Json=%s",sHeader,ubResult,un32SellerID,s_Json.m_s);
    }
#endif

	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	if (0 == ubResult)
	{
		SS_snprintf(sSQL,sizeof(sSQL),"delete from RechargePreferentialRules;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		SS_GET_SECONDS(un32Time);
		p = s_Json.m_s;
		SS_UINT32  un32Top=0;
		SS_UINT32  un32Equals=0;
		SS_CHAR    sDesc[1024] = "";
		//[{"Top":10,"equals":26,"desc":"描述"},{"Top":100,"equals":260,"desc":"描述"}] //Top 10 equals 26(充值10等于26)
		while(p &&(*p != '\0'))
		{
			if (p = strchr(p,'{'))
			{
				p++;
				un32Top=0;
				un32Equals=0;
				memset(sDesc,0,sizeof(sDesc));
				if (p = strchr(p,':'))
				{
					p++;
					un32Top=atoi(p);
				}
				if (p = strchr(p,':'))
				{
					p++;
					un32Equals=atoi(p);
				}
				if (p = strchr(p,':'))
				{
					p+=2;
					un32Len=sizeof(sDesc);
					SS_String_GetBeginToChar(p,'"',sDesc,&un32Len);
				}
				memset(sSQL,0,sizeof(sSQL));
				SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO RechargePreferentialRules(Top,equals,desc,time) "
					"VALUES('%u','%u','%s',%u);",un32Top,un32Equals,sDesc,un32Time);
				IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
			}
		}
	}
	else
	{
		SS_CHAR *pP=NULL;
		SS_snprintf(sSQL,sizeof(sSQL),"SELECT Top,equals,desc FROM RechargePreferentialRules;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			pP = sMSG;
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				*pP = '[';pP++;
				do 
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						if (ubFlag)
						{
							*pP = ',';pP++;
						}
						un32Len = SS_snprintf(pP,1024,"{\"Top\":%s,\"equals\":%s,\"desc\":\"%s\"}",
							SS_IfROWString(s_ROW[0]),SS_IfROWString(s_ROW[1]),SS_IfROWString(s_ROW[2]));
						pP += un32Len;
						ubFlag = SS_TRUE;
					}
				} while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
				*pP = ']';
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (sMSG[0])
		{
			Param[0] = "0";
			Param[1] = sSellerID;
			Param[2] = sMSG;
			Param[3] = NULL;
			g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM,Param,3);
			return  SS_SUCCESS;
		}
	}

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    Param[0] = sResult;
    Param[1] = sSellerID;
    Param[2] = s_Json.m_s;
    Param[3] = NULL;

	s_pHandle->m_f_CallBack(IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM,Param,3);
    return  SS_SUCCESS;
}
SS_SHORT IT_UpdateBoundMobileNumberCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[24] = "";
    SS_UINT32   un32SellerID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    default:break;
    }
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM "
            "message,%s,Result=%u,SellerID=%u",sHeader,ubResult,un32SellerID);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UPDATE_BOUND_MOBILE_NUMBER_CFM,Param,2);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT IT_GetCreditBalanceCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[24] = "";
    SS_CHAR  sSellerID[32] = "";
    SS_CHAR  sMinutes[32] = "";
	SS_CHAR  sPrice[64]   = "";
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32Minutes =0;
    SS_str      s_Price;
    SS_INIT_str(s_Price);
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_GET_CREDIT_BALANCE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_CREDIT_BALANCE_CFM_TYPE_MINUTES:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Minutes);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_CREDIT_BALANCE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_GET_CREDIT_BALANCE_CFM_TYPE_PRICE:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Price);
            goto Divide_GOTO;
        }break;
    default:break;
    }
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_GET_CREDIT_BALANCE_CFM message,%s,Result=%u,"
            "SellerID=%u,Minutes=%u,Price=%s",sHeader,ubResult,un32SellerID,un32Minutes,s_Price.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sMinutes,sizeof(sMinutes),"%u",un32Minutes);
		if (s_Price.m_s&&s_Price.m_len)
		{
			SS_UINT32 un32=0;
			for (un32=0;un32<s_Price.m_len;un32++)
			{
				switch(s_Price.m_s[un32])
				{
				case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9': case '.':
					{
						if (0 == un32 && '.' == s_Price.m_s[0])
						{
							goto  IT_GetCreditBalanceCFM_GOTO;
						}
					}break;
				default:
					{
						goto  IT_GetCreditBalanceCFM_GOTO;
					}break;
				}
			}
		}
		else
		{
IT_GetCreditBalanceCFM_GOTO:
			SS_snprintf(sPrice,sizeof(sPrice),"%.2f",(SS_FLOAT)un32Minutes*0.39);
		}
		if (!sPrice[0])
		{
			SS_snprintf(sPrice,sizeof(sPrice),"%s",s_Price.m_s);
		}
		Param[0] = sResult;
		Param[1] = sPrice;//s_Price.m_s;
		Param[2] = sMinutes;
		Param[3] = sSellerID;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_CREDIT_BALANCE_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT IT_SelectPhoneCheckCodeCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR  *Param[8];
	SS_CHAR  sResult[24] = "";
	SS_str      s_Code;
	SS_str      s_Phone;
	SS_INIT_str(s_Phone);
	SS_INIT_str(s_Code);
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_PHONE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Phone);
			goto Divide_GOTO;
		}break;
	case ITREG_SELECT_PHONE_CHECK_CODE_CFM_TYPE_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Code);
			goto Divide_GOTO;
		}break;
	default:break;
	}
#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_SELECT_PHONE_CHECK_CODE_CFM message,%s,"
			"Result=%u,Phone=%s,Code=%s",sHeader,ubResult,s_Phone.m_s,s_Code.m_s);
	}
#endif
	SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);

	Param[0] = sResult;
	Param[1] = s_Phone.m_s;
	Param[2] = s_Code.m_s;
	Param[3] = NULL;
	s_pHandle->m_f_CallBack(IT_MSG_SELECT_PHONE_CHECK_CODE_CFM,Param,3);
	return  SS_SUCCESS;
}

//////////////////////////////////////////////////////////////////////////

SS_SHORT  IT_Connect()
{
    SSMSG     s_msg;
    SS_CHAR   sBuf[256] = "";
	SS_CHAR   sIP[128] = "";
    SS_CHAR  *p=NULL;
    SS_BYTE   ubResult=0;
    SS_USHORT usnType=0;
    SS_UINT32 un32Len = 0;
    SS_str    s_IP;
	if (0 == g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_len && 0==g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_len)
	{
		return  SS_FAILURE;
	}
	if (0 == g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_len)
	{
		SS_TCP_getRemoterHostIP(g_s_ITLibHandle.m_s_Config.m_s_ServerDomain.m_s,sIP,sizeof(sIP));
		if (g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_len)
		{
			SS_DEL_str(g_s_ITLibHandle.m_s_Config.m_s_ServerIP);
		}
		if (sIP[0])
		{
			SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_ServerIP,sIP);
		}
		else
		{
			return  SS_FAILURE;
		}
	}
    if (SS_SOCKET_ERROR == (g_s_ITLibHandle.m_SignalScoket = SS_TCP_Connect(
        g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_s,g_s_ITLibHandle.m_s_Config.m_usnServerPort)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Connect IT REG Server fail,Addr=%s_%u",
            g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_s,g_s_ITLibHandle.m_s_Config.m_usnServerPort);
#endif
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }

#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"Connect IT REG Server OK,Addr=%s_%u",
        g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_s,g_s_ITLibHandle.m_s_Config.m_usnServerPort);
#endif
    SSMSG_INIT(s_msg);
    s_msg.m_un32Len       = SS_MSG_HEADER_LEN;
    s_msg.m_un32MSGNumber = SS_MSG_INIT_COMM;
    SS_aToun64(g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,s_msg.m_un64Source);
    SSMSG_CreateMessageHeader(sBuf,s_msg);
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sBuf,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send SS_MSG_INIT_COMM message to IT REG Server fail,codec=%u_%s",errno,strerror(errno));
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }

    memset(sBuf,0,sizeof(sBuf));
    if (SS_SUCCESS != SS_TCP_RecvTimeOut(g_s_ITLibHandle.m_SignalScoket,sBuf,4,0,10))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Recv message hander fail from IT REG Server,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
    if (SS_MSG_HEADER_LEN!=SSMSG_GetLengthEx(sBuf))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Message length error,%u!=%u",SS_MSG_HEADER_LEN,SSMSG_GetLengthEx(sBuf));
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
    if (SS_SUCCESS != SS_TCP_RecvTimeOut(g_s_ITLibHandle.m_SignalScoket,sBuf+4,SS_MSG_HEADER_LEN-4,0,10))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Recv message content from IT REG Server fail,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }

    SSMSG_INIT(s_msg);
    SSMSG_DivideMessageHeader(sBuf,s_msg);
    if (SS_MSG_INIT_COMM_CFM != s_msg.m_un32MSGNumber)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Check IT REG Server connect fail,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"Check IT REG Server OK,Addr=%s_%u",
        g_s_ITLibHandle.m_s_Config.m_s_ServerIP.m_s,g_s_ITLibHandle.m_s_Config.m_usnServerPort);
#endif
    //////////////////////////////////////////////////////////////////////////

	g_s_ITLibHandle.m_e_ITStatus=IT_STATUS_CONNECT_REG_SERVER_OK;
    //IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_CONNECT_OK);
//    SS_USLEEP(500000);
//    IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
    return  SS_SUCCESS;

/*    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s)
    {
        return  SS_SUCCESS;
    }

    IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_LOGIN);
    if (SS_SUCCESS != ITREG_Register(0,0,g_s_ITLibHandle.m_s_Config.m_s_UserNo.m_s,
        g_s_ITLibHandle.m_s_Config.m_s_UserPassword.m_s))
    {
        return SS_FAILURE;
    }*/

    //////////////////////////////////////////////////////////////////////////


    memset(sBuf,0,sizeof(sBuf));
    if (SS_SUCCESS != SS_TCP_RecvTimeOut(g_s_ITLibHandle.m_SignalScoket,sBuf,4,0,10))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Recv message hander fail from IT REG Server,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
    if ((un32Len = SSMSG_GetLengthEx(sBuf)) >= sizeof(sBuf))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Message length error,%u!=%u",SS_MSG_HEADER_LEN,SSMSG_GetLengthEx(sBuf));
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
    if (SS_SUCCESS != SS_TCP_RecvTimeOut(g_s_ITLibHandle.m_SignalScoket,sBuf+4,un32Len-4,0,10))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Recv message content from IT REG Server fail,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }

    SSMSG_INIT(s_msg);
    SSMSG_DivideMessageHeader(sBuf,s_msg);

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sBuf,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_REGISTER_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif


    if (ITREG_REGISTER_CFM != s_msg.m_un32MSGNumber)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Login IT REG Server connect fail,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }
    p = sBuf+SS_MSG_HEADER_LEN;
    ubResult=0;
    SSMSG_GetByteMessageParam(p,usnType,ubResult);
    if (SS_SUCCESS != ubResult)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Login IT REG Server connect fail,Close this socket,%X",
            g_s_ITLibHandle.m_SignalScoket);
#endif
        SS_closesocket(g_s_ITLibHandle.m_SignalScoket);
        g_s_ITLibHandle.m_SignalScoket=SS_SOCKET_ERROR;
        return SS_FAILURE;
    }

    SS_INIT_str(s_IP);
    memset(g_s_ITLibHandle.m_sIP,0,sizeof(g_s_ITLibHandle.m_sIP));
    g_s_ITLibHandle.m_usnPort=0;

    SSMSG_GetShortMessageParam(p,usnType,g_s_ITLibHandle.m_usnPort);
    SSMSG_GetMessageParamEx(p,usnType,s_IP);
    strncpy(g_s_ITLibHandle.m_sIP,s_IP.m_s,SS_IP_SIZE);

#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"Login IT REG Server connect OK,%X,Addr=%s_%u",
        g_s_ITLibHandle.m_SignalScoket,s_IP.m_s,g_s_ITLibHandle.m_usnPort);
#endif
    IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_LOGIN_OK);
    return  SS_SUCCESS;
}

SS_SHORT  IT_SendHeartBeat()
{
    SSMSG    s_msg;
    SS_CHAR  sMSG[256] = "";
    SS_CHAR  *p=NULL;
    time_t   time;

    if (SS_SOCKET_ERROR == g_s_ITLibHandle.m_SignalScoket)
    {
        SS_USLEEP(2000);
        return  SS_SUCCESS;
    }

    SS_GET_SECONDS(time);
    if ((time-g_s_ITLibHandle.m_HeartBeatTime)<5)//小于50秒，不发心跳包
    {
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_HeartBeatTime = time;

    SSMSG_INIT(s_msg);
    s_msg.m_un32Len       = SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*2);
    s_msg.m_un32MSGNumber = SS_MSG_HEART_BEAT;
    SSMSG_CreateMessageHeader(sMSG,s_msg);
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Send heart beat message fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_MEMORY;
    }
#ifdef IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_DEBUG))
    {
        SS_Log_Printf(SS_DEBUG_LOG,"Send SS_MSG_HEART_BEAT message");
    }
#endif
    return  SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////

#if defined(_MSC_VER)

void IT_Gb2312_2_Unicode(unsigned short* dst, const char * src)
{
    MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, src, 2, (LPWSTR)dst, 1);
}
void IT_Unicode_2_UTF8(char* dst, unsigned short* src)
{
    char* pchar = (char *)src;
    dst[0] = (0xE0 | ((pchar[1] & 0xF0) >> 4));
    dst[1] = (0x80 | ((pchar[1] & 0x0F) << 2)) + ((pchar[0] & 0xC0) >> 6);
    dst[2] = (0x80 | ( pchar[0] & 0x3F));
}

int IT_GB2312_2_UTF8(char * buf, int buf_len, const char * src, int src_len)
{
    int j = 0;
    int i;
    if (0 == src_len)
    {
        src_len = strlen(src);
    }
    for ( i = 0; i < src_len; )
    {
        if (j >= buf_len - 1)
        {
            break;
        }
        if (src[i] >= 0)
        {
            buf[j++] = src[i++];
        }
        else
        {
            unsigned short w_c = 0;
            char tmp[4] = "";
            IT_Gb2312_2_Unicode(&w_c, src + i);
            IT_Unicode_2_UTF8(tmp, &w_c);
            buf[j+0] = tmp[0];
            buf[j+1] = tmp[1];
            buf[j+2] = tmp[2];
            i += 2;
            j += 3;
        }
    }
    buf[j] = '\0';
    return j;
}
#endif
