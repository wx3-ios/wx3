// it_lib_call.cpp: implementation of the CITLibCall class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_call.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT  Call_INVITE_CFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[32] = "";
    SS_CHAR  *Param[8];

    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_INVITE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_INVITE_CFM_TYPE_CALLED_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_INVITE_CFM_TYPE_CALLED_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_INVITE_CFM_TYPE_CALLED_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_INVITE_CFM message,%s,Result=%u,"
            "CalledMSNode=%u,CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,
            un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif
    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_MAKE_CALL != g_s_ITLibHandle.m_e_CallStatus ||
        un64Source           != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_MAKE_CALL,g_s_ITLibHandle.m_e_CallStatus,un64Source,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_ACCEPTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;

    g_s_ITLibHandle.m_un32CallMSNode =un32CalledMSNode;
    g_s_ITLibHandle.m_un32CallREGNode=un32CalledREGNode;
    g_s_ITLibHandle.m_un32CallITNode =un32CalledITNode;
    g_s_ITLibHandle.m_un64CallWoXinID=un64Dest;//被叫的我信ID

    s_pHandle->m_f_CallBack(IT_MSG_CALL_MAKE_CFM,Param,1);

    //释放相关的资源
    if (SS_SUCCESS != ubResult)
    {
        IT_FreeCallResource();
    }
    return  SS_SUCCESS;
}
SS_SHORT  Call_ALERTING_IND    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32Status=0;
    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_ALERTING_IND_TYPE_CALLED_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_ALERTING_IND_TYPE_CALLED_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_ALERTING_IND_TYPE_CALLED_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_ALERTING_IND_TYPE_STATUS:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Status);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_ALERTING_IND message,%s,"
            "Status=%u,CalledMSNode=%u,CalledREGNode=%u,CalledITNode=%u",sHeader,
            un32Status,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_ACCEPTED != g_s_ITLibHandle.m_e_CallStatus ||
        un64Source          != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_ACCEPTED,g_s_ITLibHandle.m_e_CallStatus,un64Source,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallAlertingCFM(un64Source,un64Dest,SS_FAILURE,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_RINGING;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",un32Status);
    Param[0] = sMSG;
    Param[1] = NULL;

    g_s_ITLibHandle.m_un32CallMSNode =un32CalledMSNode;
    g_s_ITLibHandle.m_un32CallREGNode=un32CalledREGNode;
    g_s_ITLibHandle.m_un32CallITNode =un32CalledITNode;
    g_s_ITLibHandle.m_un64CallWoXinID=un64Dest;//被叫的我信ID

    s_pHandle->m_f_CallBack(IT_MSG_CALL_ALERTING_IND,Param,1);

    ITREG_SendCallAlertingCFM(un64Source,un64Dest,SS_SUCCESS,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    return  SS_SUCCESS;
}
SS_SHORT  Call_ALERTING_SDP_IND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT  Call_CONNECT_IND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    PIT_AudioConfig  s_pAudio=&g_s_ITLibHandle.m_s_AudioConfig;

    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;
    SS_UINT64 un64AudioCode=0;
    SS_UINT32 un32VideoCode=0;
    SS_str    s_AudioIP;
    SS_str    s_VideoIP;
    SS_USHORT usnAudioPort=0;
    SS_USHORT usnVideoPort=0;

    SS_INIT_str(s_AudioIP);
    SS_INIT_str(s_VideoIP);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_CONNECT_IND_TYPE_CALLED_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_CALLED_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_CALLED_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_AUDIO_IP     :
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_AudioIP);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_VIDEO_IP     :
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_VideoIP);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_AUDIO_CODE   :
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64AudioCode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_VIDEO_CODE   :
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32VideoCode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_AUDIO_PORT   :
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnAudioPort);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CONNECT_IND_TYPE_VIDEO_PORT   :
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnVideoPort);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_CONNECT_IND message,%s,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u,AudioCode=" SS_Print64u ",VideoCode=%u,AudioIP=%s,VideoIP=%s,"
            "AudioPort=%u,VideoPort=%u",sHeader,un32CalledMSNode,un32CalledREGNode,un32CalledITNode,
            un64AudioCode,un32VideoCode,s_AudioIP.m_s,s_VideoIP.m_s,usnAudioPort,usnVideoPort);
    }
#endif

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_RINGING != g_s_ITLibHandle.m_e_CallStatus ||
        un64Source         != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_RINGING,g_s_ITLibHandle.m_e_CallStatus,un64Source,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallConnectCFM(un64Source,un64Dest,SS_FAILURE,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_CONNECTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    //SS_snprintf(sMSG,sizeof(sMSG),"%u",SS_SUCCESS);
    Param[0] = "8000";
    Param[1] = NULL;
    
    g_s_ITLibHandle.m_un32CallMSNode =un32CalledMSNode;
    g_s_ITLibHandle.m_un32CallREGNode=un32CalledREGNode;
    g_s_ITLibHandle.m_un32CallITNode =un32CalledITNode;
    g_s_ITLibHandle.m_un64CallWoXinID=un64Dest;//被叫的我信ID

    //对方语音的IP
    memcpy(g_s_ITLibHandle.m_s_AudioConfig.m_sRemoteIP,s_AudioIP.m_s,s_AudioIP.m_len);
    g_s_ITLibHandle.m_s_AudioConfig.m_usnRemotePort = usnAudioPort;

    if (un64AudioCode&SS_AUDIO_CODEC_SILK_24 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_SILK_24)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_SILK_24;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_SILK_16 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_SILK_16)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_SILK_16;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_SILK_12 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_SILK_12)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_SILK_12;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_SILK_8 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_SILK_8)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_SILK_8;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_ILBC_20 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_ILBC_20)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_ILBC_20;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_ILBC_30 && s_pAudio->m_un64Code&SS_AUDIO_CODEC_ILBC_30)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_ILBC_30;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_G729A && s_pAudio->m_un64Code&SS_AUDIO_CODEC_G729A)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_G729A;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_GSM && s_pAudio->m_un64Code&SS_AUDIO_CODEC_GSM)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_GSM;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_ULAW && s_pAudio->m_un64Code&SS_AUDIO_CODEC_ULAW)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_ULAW;
    }
    else if (un64AudioCode&SS_AUDIO_CODEC_ALAW && s_pAudio->m_un64Code&SS_AUDIO_CODEC_ALAW)
    {
        s_pAudio->m_un64Code = SS_AUDIO_CODEC_ALAW;
    }
    else
    {
        ITREG_SendCallConnectCFM(un64Source,un64Dest,SS_FAILURE,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
        return  SS_FAILURE;
    }
    switch(s_pAudio->m_un64Code)
    {
    case SS_AUDIO_CODEC_ALAW:
    case SS_AUDIO_CODEC_ULAW:break;
    case SS_AUDIO_CODEC_GSM:break;
    case SS_AUDIO_CODEC_ILBC_30:
        {
            //iLBC_initEncode(&s_pAudio->m_s_iLBCenc,30);
            //iLBC_initDecode(&s_pAudio->m_s_iLBCdec,30,1);
        }break;
    case SS_AUDIO_CODEC_ILBC_20:
        {
            //iLBC_initEncode(&s_pAudio->m_s_iLBCenc,20);
            //iLBC_initDecode(&s_pAudio->m_s_iLBCdec,20,1);
        }break;
    case SS_AUDIO_CODEC_SILK_8:
        {
        }break;
    case SS_AUDIO_CODEC_SILK_12:
        {
        }break;
    case SS_AUDIO_CODEC_SILK_16:
        {
        }break;
    case SS_AUDIO_CODEC_SILK_24:
        {
        }break;
    case SS_AUDIO_CODEC_G729A:
        {
        }break;
    default:break;
    }

    //memset(&s_pAudio->m_s_silk_encoder,0,sizeof(SKP_SILK_SDK_EncControlStruct));
    //memset(&s_pAudio->m_s_silk_decoder,0,sizeof(SKP_SILK_SDK_DecControlStruct));

    s_pHandle->m_f_CallBack(IT_MSG_CALL_CONNECT_IND,Param,1);
    ITREG_SendCallConnectCFM(un64Source,un64Dest,SS_SUCCESS,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    return  SS_SUCCESS;
}
SS_SHORT  Call_DISCONNECT_IND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32ReasonCode=0;
    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_DISCONNECT_IND_TYPE_CALLED_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_DISCONNECT_IND_TYPE_REASON_CODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ReasonCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_DISCONNECT_IND message,%s,"
            "ReasonCode=%u,CalledMSNode=%u,CalledREGNode=%u,CalledITNode=%u",sHeader,
            un32ReasonCode,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif
    SS_snprintf(sMSG,sizeof(sMSG),"%u",un32ReasonCode);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_DISCONNECT_IND,Param,1);
    ITREG_SendCallDisconnectCFM(un64Source,un64Dest,SS_SUCCESS,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);

    IT_FreeCallResource();

    return  SS_SUCCESS;
}
SS_SHORT  Call_REPEAL_CFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[32] = "";
    SS_CHAR  *Param[8];

    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_REPEAL_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REPEAL_CFM_TYPE_CALL_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REPEAL_CFM_TYPE_CALL_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REPEAL_CFM_TYPE_CALL_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_REPEAL_CFM message,%s,Result=%u,"
            "CalledMSNode=%u,CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,
            un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif

    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (un64Source != g_s_ITLibHandle.m_un64WoXinID)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_SUCCESS;
    }
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_CANCEL_CFM,Param,1);

    if (SS_SUCCESS == ubResult)
    {
        IT_FreeCallResource();
    }
    return  SS_SUCCESS;
}
SS_SHORT  Call_DTMF_CFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[32] = "";
    SS_CHAR  *Param[8];

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_DTMF_CFM_TYPE_RESULT:
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
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_DTMF_CFM message,%s,Result=%u",sHeader,ubResult);
    }
#endif
    
    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_DTMF_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT  Call_MAKE_CALL_IND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  *Param[20];
    SS_CHAR   sCallerWoXinID[64] = "";
    SS_UINT32   un32CallerMSNode=0;
    SS_UINT32   un32CallerREGNode=0;
    SS_UINT32   un32CallerITNode=0;
    SS_str s_Caller;
    SS_str s_CallerName;
    SS_str s_Called;
    SS_str s_CalledName;
    SS_UINT64 un64AudioCode=0;
    SS_UINT32 un32VideoCode=0;
    SS_str s_AudioIP;
    SS_str s_VideoIP;
    SS_USHORT usnAudioPort=0;
    SS_USHORT usnVideoPort=0;

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_INIT_str(s_Caller);
    SS_INIT_str(s_CallerName);
    SS_INIT_str(s_Called);
    SS_INIT_str(s_CalledName);
    SS_INIT_str(s_AudioIP);
    SS_INIT_str(s_VideoIP);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_MS_NODE ://
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_IT_NODE ://
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_REG_NODE://
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER       ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Caller);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLER_NAME  ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_CallerName);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLED       ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Called);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_CALLED_NAME  ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_CalledName);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_IP     ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_AudioIP);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_IP     ://
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_VideoIP);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_CODE   ://
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64AudioCode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_CODE   ://
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32VideoCode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_AUDIO_PORT   ://
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnAudioPort);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_MAKE_CALL_IND_TYPE_VIDEO_PORT   ://
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnVideoPort);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_MAKE_CALL_IND message,%s,Caller=%s,Called=%s,"
            "CallerName=%s,CalledName=%s,AudioIP=%s,VideoIP=%s,VideoCode=%x,AudioCode=" SS_Print64x
            ",AudioPort=%u,VideoPort=%u,CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,
            s_Caller.m_s,s_Called.m_s,s_CallerName.m_s,s_CalledName.m_s,s_AudioIP.m_s,s_VideoIP.m_s,
            un32VideoCode,un64AudioCode,usnAudioPort,usnVideoPort,un32CallerMSNode,un32CallerREGNode,
            un32CallerITNode);
    }
#endif

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_IDLE != g_s_ITLibHandle.m_e_CallStatus ||
        un64Dest        != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_IDLE,g_s_ITLibHandle.m_e_CallStatus,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallMakeCFM(un64Source,un64Dest,un32CallerMSNode,un32CallerREGNode,un32CallerITNode,SS_FAILURE);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_Direction = INBOUND_CALL;
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_INVITE;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    SS_snprintf(sCallerWoXinID,sizeof(sCallerWoXinID),SS_Print64u,un64Source);

    Param[0] = sCallerWoXinID;
    Param[1] = s_Caller.m_s;
    Param[2] = s_CallerName.m_s;
    Param[3] = s_Called.m_s;
    Param[4] = s_CalledName.m_s;
    Param[5] = "8000";
    Param[6] = NULL;

    g_s_ITLibHandle.m_un32CallMSNode =un32CallerMSNode;
    g_s_ITLibHandle.m_un32CallREGNode=un32CallerREGNode;
    g_s_ITLibHandle.m_un32CallITNode =un32CallerITNode;
    g_s_ITLibHandle.m_un64CallWoXinID=un64Source;//主叫的我信ID

    //对方语音的IP
    memcpy(g_s_ITLibHandle.m_s_AudioConfig.m_sRemoteIP,s_AudioIP.m_s,s_AudioIP.m_len);
    g_s_ITLibHandle.m_s_AudioConfig.m_usnRemotePort = usnAudioPort;


    ITREG_SendCallMakeCFM(un64Source,g_s_ITLibHandle.m_un64WoXinID,un32CallerMSNode,
        un32CallerREGNode,un32CallerITNode,SS_SUCCESS);

    s_pHandle->m_f_CallBack(IT_MSG_CALL_NEW_IND,Param,6);
    return  SS_SUCCESS;
}

SS_SHORT  Call_180_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32CallerMSNode=0;
    SS_UINT32  un32CallerREGNode=0;
    SS_UINT32  un32CallerITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_180_CFM_TYPE_CALLER_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_180_CFM_TYPE_CALLER_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_180_CFM_TYPE_CALLER_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_180_CFM_TYPE_RESULT:
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
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_180_CFM message,%s,Result=%u,"
            "CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,
            ubResult,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif

    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_RINGING != g_s_ITLibHandle.m_e_CallStatus ||
        un64Dest           != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_IDLE,g_s_ITLibHandle.m_e_CallStatus,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return SS_SUCCESS;
    }
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_ALERTING_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT  Call_180_SDP_CFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT  Call_200_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32CallerMSNode=0;
    SS_UINT32  un32CallerREGNode=0;
    SS_UINT32  un32CallerITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_200_CFM_TYPE_CALLER_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_200_CFM_TYPE_CALLER_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_200_CFM_TYPE_CALLER_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_200_CFM_TYPE_RESULT:
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
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_200_CFM message,%s,Result=%u,CallerMSNode=%u,"
            "CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,ubResult,un32CallerMSNode,
            un32CallerREGNode,un32CallerITNode);
    }
#endif

    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;


    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_CONNECTEDING != g_s_ITLibHandle.m_e_CallStatus ||
        un64Dest                != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u,WoXinID=" SS_Print64u "_" SS_Print64u,
            CALL_STATE_IDLE,g_s_ITLibHandle.m_e_CallStatus,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus = CALL_STATE_CONNECTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_ANSWER_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT  Call_BEY_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32CallerMSNode=0;
    SS_UINT32  un32CallerREGNode=0;
    SS_UINT32  un32CallerITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_BEY_CFM_TYPE_CALLER_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_BEY_CFM_TYPE_CALLER_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_BEY_CFM_TYPE_CALLER_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_BEY_CFM_TYPE_RESULT:
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
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_BEY_CFM message,%s,Result=%u,CallerMSNode=%u,"
            "CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,ubResult,un32CallerMSNode,
            un32CallerREGNode,un32CallerITNode);
    }
#endif

    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (CALL_STATE_DISCONNECTING != g_s_ITLibHandle.m_e_CallStatus)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u",CALL_STATE_IDLE,g_s_ITLibHandle.m_e_CallStatus);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_SUCCESS;
    }
    if (OUTBOUND_CALL==g_s_ITLibHandle.m_e_Direction)
    {
        if(un64Source == g_s_ITLibHandle.m_un64WoXinID && un64Dest == g_s_ITLibHandle.m_un64CallWoXinID)
        {
        }
        else
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_ERROR_LOG,"WoXinID=" SS_Print64u "_" SS_Print64u,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
            return  SS_SUCCESS;
        }
    }
    else
    {
        if(un64Dest == g_s_ITLibHandle.m_un64WoXinID && un64Source == g_s_ITLibHandle.m_un64CallWoXinID)
        {
        }
        else
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_ERROR_LOG,"WoXinID=" SS_Print64u "_" SS_Print64u,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
            return  SS_SUCCESS;
        }
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);

    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_RELEASE_CFM,Param,1);

    IT_FreeCallResource();

    return  SS_SUCCESS;
}
SS_SHORT  Call_CANCEL_IND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32ReasonCode=0;
    SS_UINT32  un32CallerMSNode=0;
    SS_UINT32  un32CallerREGNode=0;
    SS_UINT32  un32CallerITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_CANCEL_IND_TYPE_CALL_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CANCEL_IND_TYPE_CALL_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CANCEL_IND_TYPE_CALL_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_CANCEL_IND_TYPE_REASON_CODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ReasonCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_CANCEL_IND message,%s,"
            "ReasonCode=%u,CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,
            un32ReasonCode,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (un64Dest != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"WoXinID=" SS_Print64u "_" SS_Print64u,un64Dest,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallCancelCFM(un64Source,un64Dest,SS_FAILURE,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
        return SS_SUCCESS;
    }
    if (CALL_STATE_CONNECTED == g_s_ITLibHandle.m_e_CallStatus||
        CALL_STATE_CONNECTEDING==g_s_ITLibHandle.m_e_CallStatus)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u",g_s_ITLibHandle.m_e_CallStatus);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallCancelCFM(un64Source,un64Dest,SS_FAILURE,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",un32ReasonCode);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_CANCEL_IND,Param,1);
    ITREG_SendCallCancelCFM(un64Source,un64Dest,SS_SUCCESS,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);

    IT_FreeCallResource();

    return  SS_SUCCESS;
}

SS_SHORT  Call_RejectCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32CallerMSNode=0;
    SS_UINT32  un32CallerREGNode=0;
    SS_UINT32  un32CallerITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_REJECT_CFM_TYPE_CALLER_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REJECT_CFM_TYPE_CALLER_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REJECT_CFM_TYPE_CALLER_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CallerREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REJECT_CFM_TYPE_RESULT:
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
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_REJECT_CFM message,%s,Result=%u,"
            "CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,ubResult,
            un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif

    //cancel time out check
    g_s_ITLibHandle.m_un32CallCMD = 0;

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (un64Dest != g_s_ITLibHandle.m_un64WoXinID)
    {
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        return  SS_SUCCESS;
    }
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_REJECT_CFM,Param,1);

    IT_FreeCallResource();

    return  SS_SUCCESS;
}

SS_SHORT  Call_RefuseIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_CHAR  sMSG[64] = "";
    SS_CHAR  *Param[4];
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32  un32ReasonCode=0;
    SS_UINT32  un32CalledMSNode=0;
    SS_UINT32  un32CalledREGNode=0;
    SS_UINT32  un32CalledITNode=0;

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_REFUSE_IND_TYPE_CALLED_MS_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledMSNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REFUSE_IND_TYPE_CALLED_IT_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledITNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REFUSE_IND_TYPE_CALLED_REG_NODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32CalledREGNode);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_REFUSE_IND_TYPE_REASON_CODE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ReasonCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_REFUSE_IND message,%s,"
            "ReasonCode=%u,CalledMSNode=%u,CalledREGNode=%u,CalledITNode=%u",sHeader,
            un32ReasonCode,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif

    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    if (un64Source != g_s_ITLibHandle.m_un64WoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"WoXinID=" SS_Print64u "_" SS_Print64u,un64Source,g_s_ITLibHandle.m_un64WoXinID);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallRefuseCFM(un64Source,un64Dest,SS_FAILURE,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
        return SS_SUCCESS;
    }
    if (CALL_STATE_CONNECTED == g_s_ITLibHandle.m_e_CallStatus)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"CallStatus=%u_%u",CALL_STATE_IDLE,g_s_ITLibHandle.m_e_CallStatus);
#endif
        SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        ITREG_SendCallRefuseCFM(un64Source,un64Dest,SS_FAILURE,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
        return SS_SUCCESS;
    }
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_DISCONNECTED;
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);


    SS_snprintf(sMSG,sizeof(sMSG),"%u",un32ReasonCode);
    Param[0] = sMSG;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_REFUSE_IND,Param,1);
    ITREG_SendCallRefuseCFM(un64Source,un64Dest,SS_SUCCESS,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);

    IT_FreeCallResource();
    
    return  SS_SUCCESS;
}

SS_SHORT  Call_CallBackHookCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR  sMSG[8] = "";
	SS_CHAR  *Param[8];
	SS_str    s_Caller;
	SS_str    s_Called;
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
	SS_INIT_str(s_Caller);
	SS_INIT_str(s_Called);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_CALL_BACK_HOOK_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_HOOK_CFM_TYPE_CALLER:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Caller);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_HOOK_CFM_TYPE_CALLED:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Called);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_BACK_HOOK_CFM message,%s,"
			"Caller=%s,Called=%s,Result=%u",sHeader,s_Caller.m_s,s_Called.m_s,ubResult);
	}
#endif
	SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
	Param[0] = sMSG;
	Param[1] = s_Caller.m_s;
	Param[2] = s_Called.m_s;
	Param[3] = NULL;
	s_pHandle->m_f_CallBack(IT_MSG_CALL_BACK_HOOK_CFM,Param,3);
	return  SS_SUCCESS;
}

#ifdef __cplusplus
extern "C" 
{
#endif

extern  SS_UINT32  IT_AddCallRecord(
	IN SS_CHAR const* pPhone,
	IN SS_BYTE const  ubResult,
	IN SS_UINT32 const un32Time,
	IN SS_UINT32 const un32TalkTime);

#ifdef __cplusplus
}  /* end extern "C" */
#endif

SS_SHORT  Call_CallBackCDRIND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR  sMSG[32] = "";
	SS_CHAR  sRID[32] = "";
	SS_CHAR  sTime[32] = "";
	SS_CHAR  sTalkTime[32]="";
	
	SS_CHAR  *Param[8];
	SS_str    s_Phone;
	SS_UINT32 un32RID      = 0;
	SS_UINT32 un32Time     = 0;
	SS_UINT32 un32TalkTime = 0;
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
	SS_INIT_str(s_Phone);


Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_CALL_BACK_CDR_IND_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_CDR_IND_TYPE_RID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_CDR_IND_TYPE_TIME:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32Time);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_CDR_IND_TYPE_TALK_TIME:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32TalkTime);
			goto Divide_GOTO;
		}break;
	case ITREG_CALL_BACK_CDR_IND_TYPE_PHONE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Phone);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_BACK_CDR_IND message,%s,Phone=%s,Result=%u,"
			"RID=%u,Time=%u,TalkTime=%u",sHeader,s_Phone.m_s,ubResult,un32RID,un32Time,un32TalkTime);
	}
#endif
	ITREG_CallBackCDRCFM(un64Source,un64Dest,SS_SUCCESS,un32RID);
	un32RID = IT_AddCallRecord(s_Phone.m_s,ubResult,un32Time,un32TalkTime);
	SS_snprintf(sMSG,sizeof(sMSG),"%u",ubResult);
	SS_snprintf(sRID,sizeof(sRID),"%u",un32RID);
	SS_snprintf(sTime,sizeof(sTime),"%u",un32Time);
	SS_snprintf(sTalkTime,sizeof(sTalkTime),"%u",un32TalkTime);
	Param[0] = sRID;
	Param[1] = s_Phone.m_s;
	Param[2] = sMSG;
	Param[3] = sTime;
	Param[4] = sTalkTime;
	Param[5] = NULL;
	s_pHandle->m_f_CallBack(IT_MSG_CALL_BACK_CDR_IND,Param,5);
	return  SS_SUCCESS;
}
SS_SHORT  Call_CALL_BACK_STATUS(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
	SS_UINT32   un32AppHandle=0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubStatus=0;
    SS_CHAR  sMSG[8] = "";
	SS_CHAR  sAppHandle[32] = "";
    SS_CHAR  *Param[4];
    SS_str    s_Number;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Number);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_CALL_BACK_STATUS_TYPE_NUMBER:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Number);
            goto Divide_GOTO;
        }break;
    case ITREG_CALL_BACK_STATUS_TYPE_STATUS:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubStatus);
            goto Divide_GOTO;
        }break;
	case ITREG_CALL_BACK_STATUS_TYPE_APP_HANDLE:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32AppHandle);
			goto Divide_GOTO;
		}break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_CALL_BACK_STATUS message,%s,"
            "Number=%s,Status=%u,AppHandle=%u",sHeader,s_Number.m_s,ubStatus,un32AppHandle);
    }
#endif
    SS_snprintf(sMSG,sizeof(sMSG),"%u",ubStatus);
	SS_snprintf(sAppHandle,sizeof(sAppHandle),"%u",un32AppHandle);
    Param[0] = s_Number.m_s;
    Param[1] = sMSG;
	Param[2] = sAppHandle;
    Param[3] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_CALL_BACK_STATUS,Param,3);
    return  SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////

SS_SHORT      SS_ProcRecvMessage(
    IN PIT_Handle s_pHandle,
    IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const *pData=s_pRecvData->m_s_msg.m_s;
    SS_UINT32 un32ID = SSMSG_GetMSGNumberEx(pData);
    switch(un32ID)
    {
    case ITREG_CALL_INVITE_CFM      :{return Call_INVITE_CFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_ALERTING_IND    :{return Call_ALERTING_IND    (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_ALERTING_SDP_IND:{return Call_ALERTING_SDP_IND(s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_CONNECT_IND     :{return Call_CONNECT_IND     (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_DISCONNECT_IND  :{return Call_DISCONNECT_IND  (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_REPEAL_CFM      :{return Call_REPEAL_CFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_DTMF_CFM        :{return Call_DTMF_CFM        (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_MAKE_CALL_IND   :{return Call_MAKE_CALL_IND   (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_180_CFM         :{return Call_180_CFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_180_SDP_CFM     :{return Call_180_SDP_CFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_200_CFM         :{return Call_200_CFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_BEY_CFM         :{return Call_BEY_CFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_CANCEL_IND      :{return Call_CANCEL_IND      (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_BACK_STATUS     :{return Call_CALL_BACK_STATUS(s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_REJECT_CFM      :{return Call_RejectCFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_CALL_REFUSE_IND      :{return Call_RefuseIND       (s_pHandle,s_pRecvData);}break;
	case ITREG_CALL_BACK_HOOK_CFM   :{return Call_CallBackHookCFM (s_pHandle,s_pRecvData);}break;
	case ITREG_CALL_BACK_CDR_IND    :{return Call_CallBackCDRIND  (s_pHandle,s_pRecvData);}break;
		

    case ITREG_MALL_GET_AREA_INFO_CFM                       :{Shop_GET_AREA_INFO_CFM                       (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_SHOP_INFO_CFM                       :{Shop_GET_SHOP_INFO_CFM                       (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM            :{Shop_GET_HOME_TOP_BIG_PICTURE_CFM            (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM         :{Shop_GET_HOME_TOP_BIG_PICTURE_EX_CFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM                 :{Shop_GET_HOME_NAVIGATION_CFM                 (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM     :{Shop_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM                   :{Shop_GET_CATEGORY_LIST_CFM                   (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM:{Shop_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM(s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_GOODS_INFO_CFM                      :{Shop_GET_GOODS_INFO_CFM                      (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_REPORT_MY_LOCATION_CFM                  :{Shop_REPORT_MY_LOCATION_CFM                  (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_PACKAGE_CFM                         :{Shop_GET_PACKAGE_CFM                         (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_GOODS_ALL_CFM                       :{Shop_GET_GOODS_ALL_CFM                       (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_ADD_ORDER_CFM                           :{Shop_ADD_ORDER_CFM                           (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_UPDATE_ORDER_CFM                        :{Shop_UPDATE_ORDER_CFM                        (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_DEL_ORDER_CFM                           :{Shop_DEL_ORDER_CFM                           (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_LOAD_ORDER_CFM                          :{Shop_LOAD_ORDER_CFM                          (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_LOAD_RED_PACKAGE_CFM                    :{Shop_LOAD_RED_PACKAGE_CFM                    (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM                 :{Shop_RECEIVE_RED_PACKAGE_CFM                 (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_USE_RED_PACKAGE_CFM                     :{Shop_USE_RED_PACKAGE_CFM                     (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM          :{Shop_LOAD_RED_PACKAGE_USE_RULES_CFM          (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_PUSH_MESSAGE_IND                        :{Shop_PUSH_MESSAGE_IND                        (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM             :{Shop_GET_RED_PACKAGE_BALANCE_CFM             (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_SELLER_ABOUT_CFM                    :{Shop_GET_SELLER_ABOUT_CFM                    (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_SHOP_ABOUT_CFM                      :{Shop_GET_SHOP_ABOUT_CFM                      (s_pHandle,s_pRecvData);}break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM               :{Shop_GET_PUSH_MESSAGE_INFO_CFM               (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_GET_AREA_SHOP_INFO_CFM                  :{Shop_GET_AREA_SHOP_INFO_CFM                  (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM          :{Shop_GET_UNIONPAY_SERIAL_NUMBER_CFM          (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_ORDER_REFUND_CFM                        :{Shop_ORDER_REFUND_CFM                        (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_ORDER_CONFIRM_CFM                       :{Shop_ORDER_CONFIRM_CFM                       (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_ORDER_CANCEL_CFM                        :{Shop_ORDER_CANCEL_CFM                        (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM                   :{Shop_LOAD_ORDER_SINGLE_CFM                   (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_ORDER_REMINDERS_CFM                     :{Shop_ORDER_REMINDERS_CFM                     (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_SEND_PAY_RESULT_CFM                     :{Shop_SEND_PAY_RESULT_CFM                     (s_pHandle,s_pRecvData);}break;
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM               :{Shop_GET_ORDER_REFUND_INFO_CFM               (s_pHandle,s_pRecvData);}break;


    case ITREG_REGISTER_CFM             :{return IT_RegisterCFM           (s_pHandle,s_pRecvData);}break;
    case ITREG_UNREGISTER_CFM           :{return IT_UnregisterCFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_PASSWORD_CFM      :{return IT_UpdatePasswordCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_FIND_PASSWORD_CFM        :{return IT_FindPasswordCFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_LOGIN_STATE_CFM   :{return IT_UpdateLoginStateCFM   (s_pHandle,s_pRecvData);}break;
    case ITREG_FRIEND_LOGIN_STATE_CHANGE:{return IT_FriendLoginStateChange(s_pHandle,s_pRecvData);}break;
    case ITREG_CUR_VERSION_CFM          :{return IT_CurVersionCFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_CPUID_CFM         :{return IT_UpdateCPUID_CFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_REMOTE_LOGIN_IND         :{return IT_RemoteLoginIND        (s_pHandle,s_pRecvData);}break;
    case ITREG_SYS_MSG                  :{return IT_SYS_MSG               (s_pHandle,s_pRecvData);}break;
    case ITREG_SYS_MERCHANT_MSG         :{return IT_SYSMerchantMSG        (s_pHandle,s_pRecvData);}break;
    case ITREG_SYS_ENTERPRISE_MSG       :{return IT_SYSEnterpriseMSG      (s_pHandle,s_pRecvData);}break;
    case ITREG_SYS_PERSONAL_MSG         :{return IT_SYSPersonalMSG        (s_pHandle,s_pRecvData);}break;
    case ITREG_WINDOW_SHOCK             :{return IT_WindowShock           (s_pHandle,s_pRecvData);}break;
    case ITREG_GET_BALANCE_CFM          :{return IT_GetBalanceCFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_GET_USER_INFO_CFM        :{return IT_GetUserInfoCFM        (s_pHandle,s_pRecvData);}break;
    case ITREG_GET_PHONE_CHECK_CODE_CFM :{return IT_GetPhoneCheckCodeCFM  (s_pHandle,s_pRecvData);}break;
    case ITREG_LOGIN_CFM                :{return IT_LoginCFM              (s_pHandle,s_pRecvData);}break;
    case ITREG_LOGOUT_CFM               :{return IT_LogoutCFM             (s_pHandle,s_pRecvData);}break;
    case ITREG_UPLOAD_PHONE_INFO_CFM    :{return IT_UploadPhoneInfoCFM    (s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_USER_INFO_CFM     :{return IT_UploadUserInfoCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_REPORT_TOKEN_CFM         :{return IT_ReportTokenCFM        (s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_REG_SHOP_CFM      :{return IT_UpdateREGShopCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_IT_ABOUT_CFM             :{return IT_AboutCFM              (s_pHandle,s_pRecvData);}break;
    case ITREG_IT_ABOUT_HELP_CFM        :{return IT_AboutHelpCFM          (s_pHandle,s_pRecvData);}break;
    case ITREG_IT_ABOUT_PROTOCOL_CFM    :{return IT_AboutProtocolCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_IT_ABOUT_FEED_BACK_CFM   :{return IT_AboutFeedBackCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_RECHARGE_CFM             :{return IT_RechargeCFM           (s_pHandle,s_pRecvData);}break;
    case ITREG_GET_RECHARGE_PREFERENTIAL_RULES_CFM:{return IT_GetRechargePreferentialCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM:{return IT_UpdateBoundMobileNumberCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_GET_CREDIT_BALANCE_CFM   :{return IT_GetCreditBalanceCFM(s_pHandle,s_pRecvData);}break;
	case ITREG_SELECT_PHONE_CHECK_CODE_CFM:{return IT_SelectPhoneCheckCodeCFM(s_pHandle,s_pRecvData);}break;



    case ITREG_IM_UPLINK_IND           :{return IM_UplinkIND          (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_UPLINK_CFM           :{return IM_UplinkCFM          (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_DOWNLINK_IND         :{return IM_DownLinkIND        (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_DOWNLINK_CFM         :{return IM_DownLinkCFM        (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GET_NEW_IND          :{return IM_GetNewIND          (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GET_NEW_CFM          :{return IM_GetNewCFM          (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_SYNCHRONOUS_IND      :{return IM_SynchronousIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_SYNCHRONOUS_CFM      :{return IM_SynchronousCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_UPLINK_IND     :{return IM_GroupUplinkIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_UPLINK_CFM     :{return IM_GroupUplinkCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_DOWNLINK_IND   :{return IM_GroupDownLinkIND   (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_DOWNLINK_CFM   :{return IM_GroupDownLinkCFM   (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_GET_NEW_IND    :{return IM_GroupGetNewIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_GET_NEW_CFM    :{return IM_GroupGetNewCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_SYNCHRONOUS_IND:{return IM_GroupSynchronousIND(s_pHandle,s_pRecvData);}break;
    case ITREG_IM_GROUP_SYNCHRONOUS_CFM:{return IM_GroupSynchronousCFM(s_pHandle,s_pRecvData);}break;



    case ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND    :{return Book_UserFriendModefyNameIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND:{return Book_UserFriendModefyWoXinUserIND(s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND    :{return Book_UserFriendIconModefyIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM    :{return Book_UserUpdateRemarkNameCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_UPLOAD_MY_ICON_CFM        :{return Book_UserUploadMyIconCFM         (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_ADD_CFM                   :{return Book_UserAddCFM                  (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_DELETE_CFM                :{return Book_UserDeleteCFM               (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_UPDATE                    :{return Book_UserUpdate                  (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_USER_UPDATE_CFM                :{return Book_UserUpdateCFM               (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_SYNCHRONOUS_IND                :{return Book_SynchronousIND              (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_SYNCHRONOUS_CFM                :{return Book_SynchronousCFM              (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_ADD                   :{return Book_IMGroupAdd                  (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_ADD_CFM               :{return Book_IMGroupAdd_CFM              (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_DELETE                :{return Book_IMGroupDelete               (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_DELETE_CFM            :{return Book_IMGroupDeleteCFM            (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE                :{return Book_IMGroupUpdate               (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE_CFM            :{return Book_IMGroupUpdateCFM            (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_ADD            :{return Book_IMGroupMemberAdd            (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_ADD_CFM        :{return Book_IMGroupMemberAdd_CFM        (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_DELETE         :{return Book_IMGroupMemberDelete         (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_DELETE_CFM     :{return Book_IMGroupMemberDeleteCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_UPDATE         :{return Book_IMGroupMemberUpdate         (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_UPDATE_CFM     :{return Book_IMGroupMemberUpdateCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_SYNCHRONOUS_IND       :{return Book_IMGroupSynchronousIND       (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_SYNCHRONOUS_CFM       :{return Book_IMGroupSynchronousCFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_SYNCHRONOUS_IND:{return Book_IMGroupMemberSynchronousIND (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_SYNCHRONOUS_CFM:{return Book_IMGroupMemberSynchronousCFM (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE_CALL_BOARD     :{return Book_IMGroupUpdateCallBoard      (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE_CALL_BOARD_CFM :{return Book_IMGroupUpdateCallBoardCFM   (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_ADD_MEMBER_IND        :{return Book_IMGroupAddMemberIND         (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_DELETE_MEMBER_IND     :{return Book_IMGroupDeleteMemberIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_DELETE_MEMBER_ALL_IND :{return Book_IMGroupDeleteMemberALLIND   (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_ADD_IND               :{return Book_IMGroupAddIND               (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_DELETE_IND            :{return Book_IMGroupDeleteIND            (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_NAME_UPDATE           :{return Book_IMGroupNnmeUpdate           (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_CALL_BOARD_UPDATE     :{return Book_IMGroupCallBoardUpdate      (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_MEMBER_EXIT_IND       :{return Book_IMGroupMemberExitIND        (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE_MEMBER_NAME    :{return Book_IMGroupUpdateMemberName     (s_pHandle,s_pRecvData);}break;
    case ITREG_BOOK_IM_GROUP_UPDATE_MEMBER_CAPA_IND:{return Book_IMGroupUpdateMemberCapaIND  (s_pHandle,s_pRecvData);}break;

        


    case ITREG_FILE_OFF_LINE_UP_IND        :{return File_OffLineUpIND       (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_UP_CFM        :{return File_OffLineUpCFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_DOWN_IND      :{return File_OffLineDownIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_DOWN_CFM      :{return File_OffLineDownCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_GET_IND       :{return File_OffLineGetIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_GET_CFM       :{return File_OffLineGetCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_DELETE_IND    :{return File_OffLineDelete_IND  (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_OFF_LINE_DELETE_CFM    :{return File_OffLineDelete_CFM  (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_SEND_IND       :{return File_OnLineSendIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_SEND_CFM       :{return File_OnLineSendCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_RECV_IND       :{return File_OnLineRecvIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_RECV_CFM       :{return File_OnLineRecvCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_CANCEL_SEND_IND:{return File_OnLineCancelSendIND(s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_CANCEL_SEND_CFM:{return File_OnLineCancelSendCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_CANCEL_RECV_IND:{return File_OnLineCancelRecvIND(s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_CANCEL_RECV_CFM:{return File_OnLineCancelRecvCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_ON_LINE_RECV_RESULT    :{return File_OnLineRecvResult   (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_UP_IND        :{return File_IMGroupUpIND       (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_UP_CFM        :{return File_IMGroupUpCFM       (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_DOWN_IND      :{return File_IMGroupDownIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_DOWN_CFM      :{return File_IMGroupDownCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_DELETE_IND    :{return File_IMGroupDeleteIND   (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_DELETE_CFM    :{return File_IMGroupDeleteCFM   (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_GET_IND       :{return File_IMGroupGetIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_FILE_IM_GROUP_GET_CFM       :{return File_IMGroupGetCFM      (s_pHandle,s_pRecvData);}break;

    case ITREG_SMS_NORMAL_SEND_IND      :{return SMS_NormalSendIND     (s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_NORMAL_SEND_CFM      :{return SMS_NormalSendCFM     (s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_NORMAL_GROUP_SEND_IND:{return SMS_NormalGroupSendIND(s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_NORMAL_GROUP_SEND_CFM:{return SMS_NormalGroupSendCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_NORMAL_GET_RESULT_IND:{return SMS_NormalGetResultIND(s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_NORMAL_GET_RESULT_CFM:{return SMS_NormalGetResultCFM(s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_BRTCH_SEND_IND       :{return SMS_BrtchSendIND      (s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_BRTCH_SEND_CFM       :{return SMS_BrtchSendCFM      (s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_BRTCH_GET_RESULT_IND :{return SMS_BrtchGetResultIND (s_pHandle,s_pRecvData);}break;
    case ITREG_SMS_BRTCH_GET_RESULT_CFM :{return SMS_BrtchGetResultCFM (s_pHandle,s_pRecvData);}break;
    case SS_MSG_HEART_BEAT_CFM:
        {
            SS_GET_SECONDS(s_pHandle->m_HeartBeatTime);
#ifdef IT_LIB_DEBUG
            if(SS_Log_If(SS_LOG_DEBUG))
            {
                SS_Log_Printf(SS_DEBUG_LOG,"Recv SS_MSG_HEART_BEAT_CFM message");
            }
#endif
        }
    default:
        {
            int a =0;
        }
        break;
    }
    return  SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////


SS_SHORT  CallBack_GetRechargePreferentialRulesCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	ulong = *(unsigned long*)(pParam+8);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = pMSG;
	Param[3] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM,Param,3);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_ITAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	ulong = *(unsigned long*)(pParam+4);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = pMSG;
	Param[2] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_IT_ABOUT_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_IT_ABOUT_CFM,Param,2);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_ITAboutHelpCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	ulong = *(unsigned long*)(pParam+4);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = pMSG;
	Param[2] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_IT_ABOUT_HELP_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_IT_ABOUT_HELP_CFM,Param,2);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_ITAboutProtocolCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	ulong = *(unsigned long*)(pParam+4);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = pMSG;
	Param[2] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_IT_ABOUT_PROTOCOL_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_IT_ABOUT_PROTOCOL_CFM,Param,2);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetSellerAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	ulong = *(unsigned long*)(pParam+8);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = pMSG;
	Param[3] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_SELLER_ABOUT_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_SELLER_ABOUT_CFM,Param,3);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetShopAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+8));
	ulong = *(unsigned long*)(pParam+12);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sShopID;
	Param[3] = pMSG;
	Param[4] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_SHOP_ABOUT_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_SHOP_ABOUT_CFM,Param,4);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_LoadRedPackageUseRulesCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+8));
	ulong = *(unsigned long*)(pParam+12);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sShopID;
	Param[3] = pMSG;
	Param[4] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM,Param,4);
	SS_free(pMSG);
	return  SS_SUCCESS;
}

SS_SHORT  CallBack_GetAreaInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+8));
	ulong = *(unsigned long*)(pParam+12);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sNumber;
	Param[3] = pMSG;
	Param[4] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_AREA_INFO_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_AREA_INFO_CFM,Param,4);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetShopInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+12));
	ulong = *(unsigned long*)(pParam+16);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sNumber;
	Param[4] = pMSG;
	Param[5] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_SHOP_INFO_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_SHOP_INFO_CFM,Param,5);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetAreaShopInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[8];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	ulong = *(unsigned long*)(pParam+8);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = pMSG;
	Param[3] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_AREA_SHOP_INFO_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_AREA_SHOP_INFO_CFM,Param,3);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetHomeTopBigPictureCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetHomeTopBigPictureExCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetHomeNavigationCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_HOME_NAVIGATION_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_HOME_NAVIGATION_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetGuessYouLikeRandomGoodsCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetCategoryListCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_CATEGORY_LIST_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_CATEGORY_LIST_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetPackageCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_PACKAGE_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_PACKAGE_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetGoodsAllCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  *pDomain= NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	ulong = *(unsigned long*)(pParam+(20+sizeof(unsigned long)));
	pDomain=(SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = pDomain;
	Param[7] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_GOODS_ALL_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_GOODS_ALL_CFM,Param,7);
	SS_free(pMSG);
	SS_free(pDomain);
	return  SS_SUCCESS;
}

SS_SHORT  CallBack_GetSpecialPropertiesCategoryListCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[10];
	unsigned long ulong = 0;
	SS_CHAR  *pMSG   = NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sNumber[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(pParam+4));
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(pParam+8));
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(pParam+12));
	SS_snprintf(sNumber,sizeof(sNumber),"%u",*(SS_UINT32*)(pParam+16));
	ulong = *(unsigned long*)(pParam+20);
	pMSG  = (SS_CHAR*)ulong;
	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sNumber;
	Param[5] = pMSG;
	Param[6] = NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM,Param,6);
	SS_free(pMSG);
	return  SS_SUCCESS;
}
SS_SHORT  CallBack_GetGoodsInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam)
{
	SS_CHAR  *Param[20];
	unsigned long ulong = 0;
	SS_CHAR const *p=pParam+4;
	SS_CHAR  *pGroupID= NULL;
	SS_CHAR  *pDescription= NULL;
	SS_CHAR  *pName= NULL;
	SS_CHAR  *pMarketPrice= NULL;
	SS_CHAR  *pOURPrice= NULL;
	SS_CHAR  *pNumber= NULL;
	SS_CHAR  *pInfo= NULL;
	SS_CHAR  *pLikeCount= NULL;
	SS_CHAR  *pMeterageName= NULL;
	SS_CHAR  sSellerID[64] = "";
	SS_CHAR  sAreaID[64] = "";
	SS_CHAR  sShopID[64] = "";
	SS_CHAR  sGoodsID[64] = "";
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",*(SS_UINT32*)(p));p+=4;
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",*(SS_UINT32*)(p));p+=4;
	SS_snprintf(sShopID,sizeof(sShopID),"%u",*(SS_UINT32*)(p));p+=4;
	SS_snprintf(sGoodsID,sizeof(sGoodsID),"%u",*(SS_UINT32*)(p));p+=4;
	ulong = *(unsigned long*)(p);pGroupID     = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pDescription = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pName        = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pMarketPrice = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pOURPrice    = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pNumber      = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pInfo        = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pLikeCount   = (SS_CHAR*)ulong;p+=sizeof(unsigned long);
	ulong = *(unsigned long*)(p);pMeterageName= (SS_CHAR*)ulong;p+=sizeof(unsigned long);

	Param[0] = "0";
	Param[1] = sSellerID;
	Param[2] = sAreaID;
	Param[3] = sShopID;
	Param[4] = sGoodsID;
	Param[5] = pGroupID;
	Param[6] = pDescription;
	Param[7] = pName;
	Param[8] = pMarketPrice;
	Param[9] = pOURPrice;
	Param[10]= pNumber;
	Param[11]= pInfo;
	Param[12]= pLikeCount;
	Param[13]= pMeterageName;
	Param[14]= NULL;
#ifdef  IT_LIB_DEBUG
	SS_Log_Printf(SS_TRACE_LOG,"Cache CallBack IT_MSG_GET_GOODS_INFO_CFM");
#endif
	g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_GOODS_INFO_CFM,Param,14);
	SS_free(pGroupID);
	SS_free(pDescription);
	SS_free(pName);
	SS_free(pMarketPrice);
	SS_free(pOURPrice);
	SS_free(pNumber);
	SS_free(pInfo);
	SS_free(pLikeCount);
	SS_free(pMeterageName);
	return  SS_SUCCESS;
}
SS_SHORT  SS_ProcCallBackMessage(
    IN PIT_Handle s_pHandle,
    IN SS_CHAR const *pParam)
{
	switch(*(SS_UINT32*)pParam)
	{
	case IT_MSG_GET_RECHARGE_PREFERENTIAL_RULES_CFM:{CallBack_GetRechargePreferentialRulesCFM(s_pHandle,pParam);}break;
	case IT_MSG_IT_ABOUT_CFM                       :{CallBack_ITAboutCFM(s_pHandle,pParam);}break;
	case IT_MSG_IT_ABOUT_HELP_CFM                  :{CallBack_ITAboutHelpCFM(s_pHandle,pParam);}break;
	case IT_MSG_IT_ABOUT_PROTOCOL_CFM              :{CallBack_ITAboutProtocolCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_SELLER_ABOUT_CFM               :{CallBack_GetSellerAboutCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_SHOP_ABOUT_CFM                 :{CallBack_GetShopAboutCFM(s_pHandle,pParam);}break;
	case IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM     :{CallBack_LoadRedPackageUseRulesCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_AREA_INFO_CFM                  :{CallBack_GetAreaInfoCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_SHOP_INFO_CFM                  :{CallBack_GetShopInfoCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_AREA_SHOP_INFO_CFM             :{CallBack_GetAreaShopInfoCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM       :{CallBack_GetHomeTopBigPictureCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM    :{CallBack_GetHomeTopBigPictureExCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_HOME_NAVIGATION_CFM            :{CallBack_GetHomeNavigationCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM:{CallBack_GetGuessYouLikeRandomGoodsCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_CATEGORY_LIST_CFM              :{CallBack_GetCategoryListCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_PACKAGE_CFM                    :{CallBack_GetPackageCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_GOODS_ALL_CFM                  :{CallBack_GetGoodsAllCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM:{CallBack_GetSpecialPropertiesCategoryListCFM(s_pHandle,pParam);}break;
	case IT_MSG_GET_GOODS_INFO_CFM                 :{CallBack_GetGoodsInfoCFM(s_pHandle,pParam);}break;
		
	default:break;
	}
	return  SS_SUCCESS;
}


