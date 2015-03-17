// it_lib_context.cpp: implementation of the CITLibContext class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_context.h"
#include "it_lib.h"
#include <stdio.h> 

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
const char base[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="; 

/*
*/ 
char* base64_encode(const char* data, int data_len)
{ 
	int prepare = 0; 
	int ret_len; 
	int temp = 0; 
	char *ret = NULL; 
	char *f = NULL; 
	int tmp = 0; 
	char changed[4]; 
	int i = 0; 
	ret_len = data_len / 3; 
	temp = data_len % 3; 
	if (temp > 0) 
	{ 
		ret_len += 1; 
	} 
	ret_len = ret_len*4 + 1; 
	ret = (char *)malloc(ret_len); 

	if ( ret == NULL) 
	{ 
		return  NULL;
	} 
	memset(ret, 0, ret_len); 
	f = ret; 
	while (tmp < data_len) 
	{ 
		temp = 0; 
		prepare = 0; 
		memset(changed, '\0', 4); 
		while (temp < 3) 
		{ 
			//printf("tmp = %d\n", tmp); 
			if (tmp >= data_len) 
			{ 
				break; 
			} 
			prepare = ((prepare << 8) | (data[tmp] & 0xFF)); 
			tmp++; 
			temp++; 
		} 
		prepare = (prepare<<((3-temp)*8)); 
		//printf("before for : temp = %d, prepare = %d\n", temp, prepare); 
		for (i = 0; i < 4 ;i++ ) 
		{ 
			if (temp < i) 
			{ 
				changed[i] = 0x40; 
			} 
			else 
			{ 
				changed[i] = (prepare>>((3-i)*6)) & 0x3F; 
			} 
			*f = base[changed[i]]; 
			//printf("%.2X", changed[i]); 
			f++; 
		} 
	} 
	*f = '\0'; 
	return ret;
} 
static char find_pos(char ch)   
{ 
	char *ptr = (char*)strrchr(base, ch);//the last position (the only) in base[] 
	return (ptr - base); 
} 
/* */ 
char *base64_decode(const char *data, int data_len) 
{ 
	int ret_len = (data_len / 4) * 3; 
	int equal_count = 0; 
	char *ret = NULL; 
	char *f = NULL; 
	int tmp = 0; 
	int temp = 0; 
	char need[3]; 
	int prepare = 0; 
	int i = 0; 
	if (*(data + data_len - 1) == '=') 
	{ 
		equal_count += 1; 
	} 
	if (*(data + data_len - 2) == '=') 
	{ 
		equal_count += 1; 
	} 
	if (*(data + data_len - 3) == '=') 
	{//seems impossible 
		equal_count += 1; 
	} 
	switch (equal_count) 
	{ 
	case 0: 
		ret_len += 4;//3 + 1 [1 for NULL] 
		break; 
	case 1: 
		ret_len += 4;//Ceil((6*3)/8)+1 
		break; 
	case 2: 
		ret_len += 3;//Ceil((6*2)/8)+1 
		break; 
	case 3: 
		ret_len += 2;//Ceil((6*1)/8)+1 
		break; 
	} 
	ret = (char *)malloc(ret_len+2); 
	if (ret == NULL) 
	{ 
		return NULL;
	} 
	memset(ret, 0, ret_len); 
	f = ret; 
	while (tmp < (data_len - equal_count)) 
	{ 
		temp = 0; 
		prepare = 0; 
		memset(need, 0, 4); 
		while (temp < 4) 
		{ 
			if (tmp >= (data_len - equal_count)) 
			{ 
				break; 
			} 
			prepare = (prepare << 6) | (find_pos(data[tmp])); 
			temp++; 
			tmp++; 
		} 
		prepare = prepare << ((4-temp) * 6); 
		for (i=0; i<3 ;i++ ) 
		{ 
			if (i == temp) 
			{ 
				break; 
			} 
			*f = (char)((prepare>>((2-i)*8)) & 0xFF); 
			f++; 
		} 
	} 
	*f = '\0'; 
	return ret; 
}


//////////////////////////////////////////////////////////////////////////


SS_SHORT  IT_CheckConfig(IN PIT_Config s_pConfig)
{
    s_pConfig->m_usnServerPort = 6020;
    if (0==s_pConfig->m_un32SIPRegisterTime)
    {
        s_pConfig->m_un32SIPRegisterTime=60;
    }
    if (s_pConfig->m_un32SIPRegisterTime>3600)
    {
        s_pConfig->m_un32SIPRegisterTime=3600;
    }
    return  SS_SUCCESS;
}

SS_SHORT  IT_CopyConfig (IN PIT_Config s_pSource,IN PIT_Config s_pDest)
{
    return  SS_SUCCESS;
}
SS_SHORT  IT_CopyAudioConfig (IN PIT_AudioConfig s_pSource,IN PIT_AudioConfig s_pDest)
{
    return  SS_SUCCESS;
}
SS_SHORT  IT_CopyVideoConfig (IN PIT_VideoConfig s_pSource,IN PIT_VideoConfig s_pDest)
{
    return  SS_SUCCESS;
}
SS_SHORT  IT_ConnectServer(IN PIT_Handle s_pHandle)
{
    switch(s_pHandle->m_s_Config.m_e_Protocol)
    {
    case SS_PROTOCOL_SIP:
        {
            //SIP_Login(s_pHandle);
        }break;
    case SS_PROTOCOL_SS:
        {
        }break;
    case SS_PROTOCOL_H323:
        {
        }break;
    }
    return  SS_SUCCESS;
}

SS_SHORT  IT_SendMessageToServer(IN PIT_Handle s_pHandle)
{
    PIT_SendData s_pSendData=NULL;
    while (SS_SUCCESS == SS_LinkQueue_ReadData(&s_pHandle->m_s_SendLinkQueue,(SS_VOID**)&s_pSendData))
    {
        if (NULL == s_pSendData)
        {
            continue;
        }
        if (NULL == s_pSendData->m_s_msg.m_s)
        {
            free(s_pSendData);
            continue;
        }
        switch(s_pHandle->m_s_Config.m_e_Protocol)
        {
        case SS_PROTOCOL_SIP:
            {
                SS_UDP_Send_Ex(s_pSendData->m_Socket,s_pSendData->m_s_msg.m_s,
                    s_pSendData->m_s_msg.m_len,s_pSendData->m_sIP,s_pSendData->m_usnPort);
            }break;
        case SS_PROTOCOL_SS:
            {
                if (SS_SUCCESS != SS_TCP_Send(s_pSendData->m_Socket,s_pSendData->m_s_msg.m_s,
                    s_pSendData->m_s_msg.m_len,0))
                {
#ifdef  IT_LIB_DEBUG
                    SS_Log_Printf(SS_ERROR_LOG,"Send message to REG server fail");
#endif
                    IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
                    SS_SLEEP(2);
                }
            }break;
        case SS_PROTOCOL_H323:
            {
            }break;
        }
        free(s_pSendData->m_s_msg.m_s);
        free(s_pSendData);
        s_pSendData=NULL;
        break;
    }
    return  SS_SUCCESS;
}

SS_SHORT  IT_RecvUDPFromServer(IN PIT_Handle s_pHandle)
{
    IT_AudioConfig*s_pAudio=&s_pHandle->m_s_AudioConfig;
    SS_SHORT       snRetval=0;
    fd_set         s_ReadSet;
    struct timeval s_tv;
    SS_SOCKADDR_IN s_Addr;
    SS_CHAR        sBuf[4096] = "";
    SS_UINT32      un32Len=0;
    SS_USHORT      usnRTPSequenceNumber=0;

    if (SS_SOCKET_ERROR == s_pAudio->m_Socket)
    {
        return  SS_SUCCESS;
    }
    FD_ZERO(&s_ReadSet);
    FD_SET(s_pAudio->m_Socket,&s_ReadSet);
    s_tv.tv_sec  = 0;
    s_tv.tv_usec = 200;
    snRetval = select(s_pAudio->m_Socket+1,&s_ReadSet,NULL,NULL,&s_tv);
    switch(snRetval)
    {
    case -1://出错
        {
            return SS_FAILURE;
        }break;
    case 0://没有消息
        {
            return SS_SUCCESS;
        }break;
    default:
        {
        }break;
    }

    memset(&s_Addr,0,sizeof(SS_SOCKADDR_IN));
    un32Len=sizeof(sBuf);
    SS_UDP_RecvFrom(s_pAudio->m_Socket,sBuf,un32Len,&s_Addr);
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_ERROR_LOG,"Recv udp message,Len=%u",un32Len);
#endif
    if (-1 == un32Len)
    {
        return SS_SUCCESS;
    }
/*    if (g_s_ITLibHandle.m_f_PCMCallBack)
    {
        g_s_ITLibHandle.m_f_PCMCallBack(sBuf,un32Len);
    }
    return  SS_SUCCESS;*/

    usnRTPSequenceNumber=*(SS_USHORT*)sBuf;
    SS_RTPQueue_WriteData(&s_pHandle->m_s_RTPQueue,usnRTPSequenceNumber,sBuf+sizeof(SS_SHORT),un32Len-sizeof(SS_SHORT));
    if (s_pHandle->m_s_RTPQueue.m_un32WaitingLen >= 6)
    {
        s_pAudio->m_ubPalyFlag = SS_TRUE;
    }
    return  SS_SUCCESS;
}


SS_SHORT  IT_RecvMessageFromServer(IN PIT_Handle s_pHandle)
{
    PIT_RecvData   s_pRecvData=NULL;
    SS_SHORT       snRetval=0;
    fd_set         s_ReadSet;
    struct timeval s_tv;
	SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
    //SS_SOCKADDR_IN  s_Addr;
    SS_INT32        n32BufLen=0;

    //没有连接上服务器
    if (SS_SOCKET_ERROR == s_pHandle->m_SignalScoket)
    {
        SS_USLEEP(2000);
        return  SS_SUCCESS;
    }
    FD_ZERO(&s_ReadSet);
    FD_SET(s_pHandle->m_SignalScoket,&s_ReadSet);
    s_tv.tv_sec  = 0;
    s_tv.tv_usec = 2000;
    snRetval = select(s_pHandle->m_SignalScoket+1,&s_ReadSet,NULL,NULL,&s_tv);
    switch(snRetval)
    {
    case -1://出错
        {
            if (IT_STATUS_REG_SERVER_DISCONNECT_OK != s_pHandle->m_e_ITStatus)
            {
                IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
                SS_USLEEP(2000);
            }
            return SS_FAILURE;
        }break;
    case 0://没有消息
        {
            return SS_SUCCESS;
        }break;
    default:
        {
        }break;
    }
    switch(s_pHandle->m_s_Config.m_e_Protocol)
    {
    case SS_PROTOCOL_SIP:
        {
            if (NULL == (s_pRecvData = (PIT_RecvData)malloc(sizeof(IT_RecvData))))
            {
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"malloc faild");
#endif
                return  SS_ERR_MEMORY;
            }
            memset(s_pRecvData,0,sizeof(IT_RecvData));
            n32BufLen=sizeof(s_pHandle->m_sRecvBuf)-1;
            SS_UDP_RecvFrom_strip(s_pHandle->m_SignalScoket,s_pHandle->m_sRecvBuf,n32BufLen,
                s_pRecvData->m_sIP,s_pRecvData->m_usnPort);
            if (-1 == n32BufLen)
            {
                free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"recv from message faild,socket error");
#endif
                IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
                return SS_FAILURE;
            }
            if (NULL == (s_pRecvData->m_s_msg.m_s = (SS_CHAR*)SS_malloc(n32BufLen)))
            {
                free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"malloc faild");
#endif
                return SS_ERR_MEMORY;
            }
            s_pRecvData->m_s_msg.m_s[n32BufLen] = 0;
            memcpy(s_pRecvData->m_s_msg.m_s,s_pHandle->m_sRecvBuf,n32BufLen);
            s_pRecvData->m_s_msg.m_len = n32BufLen;
            s_pRecvData->m_Socket = s_pHandle->m_SignalScoket;
            if (SS_SUCCESS != SS_LinkQueue_WriteData(&s_pHandle->m_s_RecvLinkQueue,(SS_VOID*)s_pRecvData))
            {
                free(s_pRecvData->m_s_msg.m_s);
                free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"Write recv queue faild");
#endif
                return SS_ERR_MEMORY;
            }
        }break;
    case SS_PROTOCOL_SS:
        {
            if (NULL == (s_pRecvData = (PIT_RecvData)malloc(sizeof(IT_RecvData))))
            {
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"malloc faild");
#endif
                SS_SLEEP(1);
                return  SS_ERR_MEMORY;
            }
            memset(s_pRecvData,0,sizeof(IT_RecvData));
            memset(s_pHandle->m_sRecvBuf,0,sizeof(s_pHandle->m_sRecvBuf));
            //if (SS_SUCCESS != SS_TCP_Recv(s_pHandle->m_SignalScoket,s_pHandle->m_sRecvBuf,4,0))
			if (SS_SUCCESS != SS_TCP_RecvTimeOut(s_pHandle->m_SignalScoket,s_pHandle->m_sRecvBuf,4,0,1))
            {
                free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
                SS_Log_Printf(SS_ERROR_LOG,"recv message handel fail,socket error,Code=%u_%s",
					errno,strerror(errno));
#endif
                IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
                SS_SLEEP(1);
                return SS_FAILURE;
            }
            n32BufLen = SSMSG_GetLengthEx(s_pHandle->m_sRecvBuf);
            //if (n32BufLen >= (sizeof(s_pHandle->m_sRecvBuf)-1))
            //{
			if (NULL == (s_pRecvData->m_s_msg.m_s = (SS_CHAR*)SS_malloc(n32BufLen+10)))
			{
				free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
				SS_Log_Printf(SS_ERROR_LOG,"malloc faild");
#endif
				IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
				SS_SLEEP(1);
				return SS_ERR_MEMORY;
			}
			memset(s_pRecvData->m_s_msg.m_s+n32BufLen,0,10);
			memcpy(s_pRecvData->m_s_msg.m_s,s_pHandle->m_sRecvBuf,sizeof(SS_UINT32));
			//if (SS_SUCCESS != SS_TCP_Recv(s_pHandle->m_SignalScoket,s_pRecvData->m_s_msg.m_s+4,n32BufLen-4,0))
			if (SS_SUCCESS != SS_TCP_RecvTimeOut(s_pHandle->m_SignalScoket,s_pRecvData->m_s_msg.m_s+4,n32BufLen-4,0,1))
			{
				free(s_pRecvData->m_s_msg.m_s);
				free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
				SS_Log_Printf(SS_ERROR_LOG,"recv message contact faild,socket error,Code=%u_%s",
					errno,strerror(errno));
#endif
				IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
				SS_SLEEP(1);
				return SS_FAILURE;
			}
			s_pRecvData->m_s_msg.m_len = n32BufLen;
			s_pRecvData->m_Socket = s_pHandle->m_SignalScoket;

			strncpy(s_pRecvData->m_sIP,s_pHandle->m_s_Config.m_s_ServerIP.m_s,sizeof(s_pRecvData->m_sIP));
			s_pRecvData->m_usnPort = s_pHandle->m_s_Config.m_usnServerPort;

			if (SS_SUCCESS != SS_LinkQueue_WriteData(&s_pHandle->m_s_RecvLinkQueue,(SS_VOID*)s_pRecvData))
			{
				free(s_pRecvData->m_s_msg.m_s);
				free(s_pRecvData);
#ifdef  IT_LIB_DEBUG
				SS_Log_Printf(SS_ERROR_LOG,"Write recv queue faild");
#endif
				return SS_ERR_MEMORY;
			}
			SSMSG_DivideMessageHeaderToBuf(s_pRecvData->m_s_msg.m_s,sHeader,sizeof(sHeader));
#ifdef  IT_LIB_DEBUG
			SS_Log_Printf(SS_TRACE_LOG,"Recv %s",sHeader);
#endif
            return SS_SUCCESS;
            //}
            /*if (SS_SUCCESS != SS_TCP_Recv(s_pHandle->m_SignalScoket,s_pHandle->m_sRecvBuf+4,n32BufLen-4,0))
            {
                free(s_pRecvData);
                SS_Log_Printf(SS_ERROR_LOG,"recv message contact faild,socket error,Code=%u_%s",errno,strerror(errno));
                IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
                SS_SLEEP(1);
                return SS_FAILURE;
            }
            if (NULL == (s_pRecvData->m_s_msg.m_s = (SS_CHAR*)SS_malloc(n32BufLen)))
            {
                free(s_pRecvData);
                SS_Log_Printf(SS_ERROR_LOG,"malloc faild");
                SS_SLEEP(1);
                return SS_ERR_MEMORY;
            }
            s_pRecvData->m_s_msg.m_s[n32BufLen] = 0;
            memcpy(s_pRecvData->m_s_msg.m_s,s_pHandle->m_sRecvBuf,n32BufLen);
            s_pRecvData->m_s_msg.m_len = n32BufLen;
            s_pRecvData->m_Socket = s_pHandle->m_SignalScoket;

            strncpy(s_pRecvData->m_sIP,s_pHandle->m_s_Config.m_s_ServerIP.m_s,sizeof(s_pRecvData->m_sIP));
            s_pRecvData->m_usnPort = s_pHandle->m_s_Config.m_usnServerPort;

            if (SS_SUCCESS != SS_LinkQueue_WriteData(&s_pHandle->m_s_RecvLinkQueue,(SS_VOID*)s_pRecvData))
            {
                free(s_pRecvData->m_s_msg.m_s);
                free(s_pRecvData);
                SS_Log_Printf(SS_ERROR_LOG,"Write recv queue faild");
                return SS_ERR_MEMORY;
            }*/
        }break;
    case SS_PROTOCOL_H323:
        {
        }break;
    default:
        {
            return SS_SUCCESS;
        }break;
    }
    return  SS_SUCCESS;
}
SS_SHORT  SendPCMToRemote(SS_str const*s_pMSG)
{
    SS_CHAR const *pPCM = s_pMSG->m_s;
    SS_UINT32      un32PCMLen = s_pMSG->m_len;
    SS_UINT32      un32=0;
    SS_UINT32      un32Count=0;
    SS_CHAR  sData[256] = "";
    PIT_AudioConfig s_pAudio = &g_s_ITLibHandle.m_s_AudioConfig;
    
    
    *(SS_USHORT*)sData = s_pAudio->m_usnRTPSequenceNumber++;
    un32Count=2;
    //gsm_encode(g_s_ITLibHandle.m_s_AudioConfig.m_s_gsm,(gsm_signal*)pPCM,(gsm_byte*)(sData+2));
    un32Count+=33;

    /*
    //PCMU
    for (un32=0;un32<320;un32+=2)
    {
        sData[un32Count++] = IT_linear2ulaw(*(SS_UINT16*)pPCM);
        pPCM+=2;
    }*/
    
    SS_UDP_Send_Ex(s_pAudio->m_Socket,sData,un32Count,s_pAudio->m_sRemoteIP,s_pAudio->m_usnRemotePort);

    //PIT_AudioConfig s_pAudio = &g_s_ITLibHandle.m_s_AudioConfig;
    //SS_UDP_Send_Ex(s_pAudio->m_Socket,s_pMSG->m_s,s_pMSG->m_len,s_pAudio->m_sRemoteIP,s_pAudio->m_usnRemotePort);
/*    SS_CHAR const *pPCM = s_pMSG->m_s;
    SS_UINT32      un32PCMLen = s_pMSG->m_len;
    SS_UINT32      un32=0;
    SS_UINT32      un32Count=0;
    SS_CHAR  sData[256] = "";
    PIT_AudioConfig s_pAudio = &g_s_ITLibHandle.m_s_AudioConfig;
    *(SS_USHORT*)sData = s_pAudio->m_usnRTPSequenceNumber++;
    un32Count=2;
    for (un32=0;un32<320;un32+=2)
    {
        sData[un32Count++] = IT_linear2ulaw(*(SS_UINT16*)pPCM);
        pPCM+=2;
    }
    SS_UDP_Send_Ex(s_pAudio->m_Socket,sData,un32Count,s_pAudio->m_sRemoteIP,s_pAudio->m_usnRemotePort);
    memset(sData,0,sizeof(sData));
    *(SS_USHORT*)sData = s_pAudio->m_usnRTPSequenceNumber++;
    un32Count=2;
    for (un32=0;un32<320;un32+=2)
    {
        sData[un32Count++] = IT_linear2ulaw(*(SS_UINT16*)pPCM);
        pPCM+=2;
    }
    SS_UDP_Send_Ex(s_pAudio->m_Socket,sData,un32Count,s_pAudio->m_sRemoteIP,s_pAudio->m_usnRemotePort);
    memset(sData,0,sizeof(sData));
    *(SS_USHORT*)sData = s_pAudio->m_usnRTPSequenceNumber++;
    un32Count=2;
    for (un32=0;un32<320;un32+=2)
    {
        sData[un32Count++] = IT_linear2ulaw(*(SS_UINT16*)pPCM);
        pPCM+=2;
    }
    SS_UDP_Send_Ex(s_pAudio->m_Socket,sData,un32Count,s_pAudio->m_sRemoteIP,s_pAudio->m_usnRemotePort);
    */
    return  SS_SUCCESS;
}
SS_SHORT  IT_CheckTimeOutMessage(IN PIT_Handle s_pHandle,IN SS_UINT32 const un32Time)
{
	SS_CHAR    *Param[20];
	SS_CHAR    sSellerID[64] = "";
	SS_CHAR    sAreaID[64] = "";
	SS_CHAR    sShopID[64] = "";
	SS_CHAR    sGoodsID[64] = "";
	SS_CHAR    sRedPackageID[64] = "";
	SS_CHAR sType[128] = "";
	SS_str    *s_pStr=NULL;

	if (s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = "";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_ORDER_REFUND_INFO_CFM,Param,5);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_ORDER_REFUND_INFO_CFM message,Call back IT_MSG_GET_ORDER_REFUND_INFO_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_SEND_PAY_RESULT_CFM,Param,4);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_SEND_PAY_RESULT_CFM message,Call back IT_MSG_SEND_PAY_RESULT_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_ORDER_REMINDERS_CFM,Param,4);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_ORDER_REMINDERS_CFM message,Call back IT_MSG_ORDER_REMINDERS_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = "";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_LOAD_ORDER_SINGLE_CFM,Param,5);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_LOAD_ORDER_SINGLE_CFM message,Call back IT_MSG_LOAD_ORDER_SINGLE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_CANCEL_ORDER_CFM,Param,4);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_ORDER_CANCEL_CFM message,Call back IT_MSG_CANCEL_ORDER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_ORDER_CONFIRM_CFM,Param,4);
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_s_OrderCode);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_ORDER_CONFIRM_CFM message,Call back IT_MSG_ORDER_CONFIRM_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32ShopID);
			SS_snprintf(sGoodsID,sizeof(sGoodsID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32GoodsID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = sGoodsID;
			Param[5] = "0";
			Param[6] = "0";
			Param[7] = "0";
			Param[8] = "0.0";
			Param[9] = "0.0";
			Param[10]= "0";
			Param[11]= "0";
			Param[12]= "0";
			Param[13]= "0";
			Param[14]= NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_GOODS_INFO_CFM,Param,14);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_GOODS_INFO_CFM message,Call back IT_MSG_GET_GOODS_INFO_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_GOODS_ALL_CFM message,Call back IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = "0";
			Param[3] = "";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_INFO_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_AREA_INFO_CFM message,Call back IT_MSG_GET_AREA_INFO_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_un32AreaID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = "0";
			Param[4] = "";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_INFO_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_SHOP_INFO_CFM message,Call back IT_MSG_GET_SHOP_INFO_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM message,Call back IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM message,Call back IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_NAVIGATION_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_HOME_NAVIGATION_CFM message,Call back IT_MSG_GET_HOME_NAVIGATION_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM message,Call back IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_CATEGORY_LIST_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_CATEGORY_LIST_CFM message,Call back IT_MSG_GET_CATEGORY_LIST_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM message,Call back IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32SellerID);
			SS_snprintf(sAreaID,sizeof(sAreaID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32AreaID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sAreaID;
			Param[3] = sShopID;
			Param[4] = "0";
			Param[5] = "";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_PACKAGE_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_PACKAGE_CFM message,Call back IT_MSG_GET_PACKAGE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_ORDER_REFUND_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_ORDER_REFUND_CFM message,Call back IT_MSG_ORDER_REFUND_CFM message");
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_s_OrderCode);
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32ShopID);
			SS_snprintf(sType,sizeof(sType),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32GoodsID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = sType;
			Param[4] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[5] = "0000";
			Param[6] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_ORDER_CODE_PAY_MODE_CFM,Param,6);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM message,Call back IT_MSG_GET_ORDER_CODE_PAY_MODE_CFM message");
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_s_OrderCode);
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = "0.0";
			Param[2] = "0";
			Param[3] = sSellerID;
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_CREDIT_BALANCE_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_GET_CREDIT_BALANCE_CFM message,Call back IT_MSG_GET_CREDIT_BALANCE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutRechargeIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutRechargeIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutRechargeIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutRechargeIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = "0000";
			Param[3] = "0000";
			Param[4] = "0000";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_RECHARGE_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_RECHARGE_CFM message,Call back IT_MSG_RECHARGE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UPDATE_BOUND_MOBILE_NUMBER_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_UPDATE_BOUND_MOBILE_NUMBER_CFM message,Call back IT_MSG_UPDATE_BOUND_MOBILE_NUMBER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutAboutIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = "";
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_IT_ABOUT_CFM message,Call back IT_MSG_IT_ABOUT_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutAboutHelp.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = "";
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_HELP_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_IT_ABOUT_HELP_CFM message,Call back IT_MSG_IT_ABOUT_HELP_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = "";
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_PROTOCOL_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_IT_ABOUT_PROTOCOL_CFM message,Call back IT_MSG_IT_ABOUT_PROTOCOL_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_IT_ABOUT_FEED_BACK_CFM,Param,1);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_IT_ABOUT_FEED_BACK_CFM message,Call back IT_MSG_IT_ABOUT_FEED_BACK_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UPDATE_REG_SHOP_CFM,Param,3);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_UPDATE_REG_SHOP_CFM message,Call back IT_MSG_UPDATE_REG_SHOP_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutReportTokenIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutReportTokenIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutReportTokenIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutReportTokenIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_REPORT_TOKEN_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_REPORT_TOKEN_CFM message,Call back IT_MSG_REPORT_TOKEN_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = "";
			Param[3] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_RED_PACKAGE_BALANCE_CFM,Param,3);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM message,Call back IT_MSG_GET_RED_PACKAGE_BALANCE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_un32SellerID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = "";
			Param[3] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_SELLER_ABOUT_CFM,Param,3);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_SELLER_ABOUT_CFM message,Call back IT_MSG_GET_SELLER_ABOUT_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_ABOUT_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_SHOP_ABOUT_CFM message,Call back IT_MSG_GET_SHOP_ABOUT_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_LOAD_RED_PACKAGE_CFM message,Call back IT_MSG_LOAD_RED_PACKAGE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32ShopID);
			SS_snprintf(sRedPackageID,sizeof(sRedPackageID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32RedPackageID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = sRedPackageID;
			Param[4] = "0.0";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_RECEIVE_RED_PACKAGE_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_RECEIVE_RED_PACKAGE_CFM message,Call back IT_MSG_RECEIVE_RED_PACKAGE_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "0.0";
			Param[4] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_USE_RED_PACKAGE_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_USE_RED_PACKAGE_CFM message,Call back IT_MSG_USE_RED_PACKAGE_CFM message");
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_s_OrderCode);
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM message,Call back IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "0000";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_ADD_ORDER_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_ADD_ORDER_CFM message,Call back IT_MSG_ADD_ORDER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "";
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UPDATE_ORDER_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_UPDATE_ORDER_CFM message,Call back IT_MSG_UPDATE_ORDER_CFM message");
		}
	}

	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pStr=&s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_s_OrderCode;
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = (SS_CHAR*)(s_pStr->m_s?s_pStr->m_s:"");
			Param[4] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_DEL_ORDER_CFM,Param,4);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_DEL_ORDER_CFM message,Call back IT_MSG_DEL_ORDER_CFM message");
			SS_DEL_str(s_pHandle->m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_s_OrderCode);
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = sShopID;
			Param[3] = "0";
			Param[4] = "";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_LOAD_ORDER_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_LOAD_ORDER_CFM message,Call back IT_MSG_LOAD_ORDER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag = SS_FALSE;
			SS_snprintf(sSellerID,sizeof(sSellerID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_un32SellerID);
			SS_snprintf(sShopID,sizeof(sShopID),"%u",s_pHandle->m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_un32ShopID);
			Param[0] = "1";
			Param[1] = sSellerID;
			Param[2] = "";
			Param[3] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_SHOP_INFO_CFM,Param,3);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_MALL_GET_AREA_SHOP_INFO_CFM message,Call back IT_MSG_GET_AREA_SHOP_INFO_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutRegister.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutRegister.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutRegister.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = "0";
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_REGISTER_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_REGISTER_CFM message,Call back IT_MSG_REGISTER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutUnregister.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutUnregister.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutUnregister.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UNREGISTER_CFM,Param,1);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_UNREGISTER_CFM message,Call back IT_MSG_UNREGISTER_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutLogin.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag = SS_FALSE;
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGIN_TIME_OUT);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_LOGIN_CFM message,Call back IT_STATUS_LOGIN_TIME_OUT message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutLogout.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutLogout.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutLogout.m_ubFlag = SS_FALSE;
			IT_UPDATE_LOGIN_STATUS(s_pHandle,IT_STATUS_LOGOUT_ERR);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_LOGOUT_CFM message,Call back IT_STATUS_LOGOUT_ERR message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutUpdatePassword.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutUpdatePassword.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutUpdatePassword.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UPDATE_PASSWORD,Param,1);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_UPDATE_PASSWORD_CFM message,Call back IT_MSG_UPDATE_PASSWORD message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutFindPassword.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutFindPassword.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutFindPassword.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_FIND_PASSWORD,Param,1);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_FIND_PASSWORD_CFM message,Call back IT_MSG_FIND_PASSWORD message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutReportVersionIND.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutReportVersionIND.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutReportVersionIND.m_ubFlag = SS_FALSE;
			Param[0] = "3";
			Param[1] = "0";
			Param[2] = "0";
			Param[3] = "0";
			Param[4] = "0";
			Param[5] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_REPORT_VERSION_CFM,Param,5);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_CUR_VERSION_CFM message,Call back IT_MSG_REPORT_VERSION_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_ubFlag = SS_FALSE;
			Param[0] = "0";
			Param[1] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_UPDATE_CPUID_CFM,Param,1);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_UPDATE_CPUID_CFM message,Call back IT_MSG_UPDATE_CPUID_CFM message");
		}
	}
	if (s_pHandle->m_s_TimeOut.m_s_TimeOutGetBalance.m_ubFlag)
	{
		if ((un32Time - s_pHandle->m_s_TimeOut.m_s_TimeOutGetBalance.m_time) >= g_s_ITLibHandle.m_un32APITimeOut)
		{
			s_pHandle->m_s_TimeOut.m_s_TimeOutGetBalance.m_ubFlag = SS_FALSE;
			Param[0] = "1";
			Param[1] = "0.0";
			Param[2] = NULL;
			s_pHandle->m_f_CallBack(IT_MSG_GET_BALANCE_CFM,Param,2);
			SS_Log_Printf(SS_ERROR_LOG,"Not recv ITREG_GET_BALANCE_CFM message,Call back IT_MSG_GET_BALANCE_CFM message");
		}
	}
	return  SS_SUCCESS;
}
SS_SHORT  IT_ProcRecvMessage(IN PIT_Handle s_pHandle)
{
    PIT_RecvData s_pRecvData=NULL;
    SS_str      *s_pMSG=NULL;
    SS_BYTE      ubCount=0;
    SS_CHAR      *p=NULL;
    SS_CHAR      sPCM[1024] = "";
    SS_UINT32    un32PCMLen=0;
    SS_CHAR      sBuf[512] = "";
    SS_UINT32    un32Len=0;
    SS_UINT32    un32=0;
    SS_UINT64    un64Milliseconds=0;
	SS_UINT32    un32Time=0;
	SS_UINT32    un32Count=0;
	SS_CHAR     *pParam = NULL;
	PIT_MSGTimeOutData s_pMSGTimeOutData=NULL;

	SS_GET_SECONDS(un32Time);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	IT_CheckTimeOutMessage(s_pHandle,un32Time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	/*if (un32Count = SS_LinkQueue_GetCount(&g_s_ITLibHandle.m_s_MSGTimeOutLinkQueue))
	{
		SS_GET_MILLISECONDS(un64Milliseconds);
		for (un32=0;un32<un32Count;un32++)
		{
			s_pMSGTimeOutData=NULL;
			if (SS_SUCCESS == SS_LinkQueue_ReadData(&s_pHandle->m_s_CallBackLinkQueue,(SS_VOID**)&s_pMSGTimeOutData))
			{
				if ((un64Milliseconds-s_pMSGTimeOutData->m_un64Time) < g_s_ITLibHandle.m_s_Config.m_un32MessageTimeOut)
				{
					SS_LinkQueue_WriteData(&s_pHandle->m_s_CallBackLinkQueue,(SS_VOID*)s_pMSGTimeOutData);
				}
				else
				{

				}
			}
		}
	}*/
	pParam=NULL;
	while (SS_SUCCESS == SS_LinkQueue_ReadData(&s_pHandle->m_s_CallBackLinkQueue,(SS_VOID**)&pParam))
	{
		if (NULL == pParam)
		{
			continue;
		}
		SS_ProcCallBackMessage(s_pHandle,pParam);
		SS_free(pParam);
	}
	while (SS_SUCCESS == SS_LinkQueue_ReadData(&s_pHandle->m_s_RecvLinkQueue,(SS_VOID**)&s_pRecvData))
    {
        if (NULL == s_pRecvData)
        {
            continue;
        }
        if (NULL == s_pRecvData->m_s_msg.m_s)
        {
            free(s_pRecvData);
            continue;
        }
        switch(s_pHandle->m_s_Config.m_e_Protocol)
        {
        case SS_PROTOCOL_SIP:
            {
                //SIP_ProcRecvMessage(s_pHandle,s_pRecvData);
            }break;
        case SS_PROTOCOL_SS:
            {
                SS_ProcRecvMessage(s_pHandle,s_pRecvData);
            }break;
        case SS_PROTOCOL_H323:
            {
            }break;
        }
        free(s_pRecvData->m_s_msg.m_s);
        free(s_pRecvData);
        s_pRecvData=NULL;
        ubCount++;
        if (ubCount>=20)
        {
            break;
        }
    }
    ubCount=0;
    s_pMSG=NULL;
    while (SS_SUCCESS == SS_LinkQueue_ReadData(&g_s_ITLibHandle.m_s_DBLinkQueue,(SS_VOID**)&s_pMSG))
    {
        if (NULL == s_pMSG)
        {
            continue;
        }
        if (0 == s_pMSG->m_len)
        {
            SS_free(s_pMSG);
            continue;
        }
        SS_ProcDBMessage(s_pHandle,s_pMSG);
        SS_free(s_pMSG->m_s);
        free(s_pMSG);
        s_pMSG=NULL;
        ubCount++;
        if (ubCount>=20)
        {
            break;
        }
    }

	//SS_GET_SECONDS(un32Time);
	if (un32Time-s_pHandle->m_un32SlowlyTreatmentTime)
	{
		s_pHandle->m_un32SlowlyTreatmentTime = un32Time;
		ubCount=0;
		s_pMSG=NULL;
		while (SS_SUCCESS == SS_LinkQueue_ReadData(&g_s_ITLibHandle.m_s_SlowlyTreatmentLinkQueue,(SS_VOID**)&s_pMSG))
		{
			if (NULL == s_pMSG)
			{
				continue;
			}
			if (0 == s_pMSG->m_len)
			{
				SS_free(s_pMSG);
				continue;
			}
			switch(s_pMSG->m_len)
			{
			case DB_MSG_UPDATE_USER:
				{
					SS_ProcDBMessage(s_pHandle,s_pMSG);
				}break;
			default:break;
			}
			SS_free(s_pMSG->m_s);
			free(s_pMSG);
			s_pMSG=NULL;
			ubCount++;
			if (ubCount>=10)
			{
				break;
			}
		}
	}	
    ubCount=0;
    s_pMSG=NULL;
    SS_GET_MILLISECONDS(un64Milliseconds);
    if ((un64Milliseconds-g_s_ITLibHandle.m_s_AudioConfig.m_un64Milliseconds) >= 15000)
    {
        g_s_ITLibHandle.m_s_AudioConfig.m_un64Milliseconds = un64Milliseconds;
        if (SS_SUCCESS == SS_LinkQueue_ReadData(&g_s_ITLibHandle.m_s_PCMLinkQueue,(SS_VOID**)&s_pMSG))
        {
            if (s_pMSG)
            {
                if (s_pMSG->m_len)
                {
                    if (SS_SOCKET_ERROR == g_s_ITLibHandle.m_s_AudioConfig.m_Socket)
                    {
                        SS_free(s_pMSG->m_s);
                        free(s_pMSG);
                        s_pMSG=NULL;
                    }
                    else
                    {
                        if (g_s_ITLibHandle.m_s_AudioConfig.m_usnRemotePort)
                        {
                            SendPCMToRemote(s_pMSG);
                        }
                        SS_free(s_pMSG->m_s);
                        free(s_pMSG);
                        s_pMSG=NULL;
                    }
                }
                else
                {
                    SS_free(s_pMSG);
                }
            }
        }
    }
    if (g_s_ITLibHandle.m_s_AudioConfig.m_ubPalyFlag)
    {
        un32Len = sizeof(sBuf);
        if (SS_SUCCESS == SS_RTPQueue_ReadData(&g_s_ITLibHandle.m_s_RTPQueue,sBuf,&un32Len))
        {
            p=sPCM;
            un32PCMLen=0;
            //gsm_decode(g_s_ITLibHandle.m_s_AudioConfig.m_s_gsm,(gsm_byte*)sBuf,(gsm_signal*)sPCM);
            un32PCMLen = 320;
            /*//PCMU
            for (un32=0;un32<un32Len;un32++)
            {
                *(SS_UINT16*)p = IT_ulaw2linear((SS_UINT8)sBuf[un32]);
                p+=2;
                un32PCMLen+=2;
            }*/
            if (g_s_ITLibHandle.m_f_PCMCallBack)
            {
                g_s_ITLibHandle.m_f_PCMCallBack(sPCM,un32PCMLen);
            }
        }
    }
    return  SS_SUCCESS;
}

SS_SHORT  IT_ScanCallStatus(IN PIT_Handle s_pHandle)
{
    return  SS_SUCCESS;
}
SS_SHORT  IT_ScanREGStatus(IN PIT_Handle s_pHandle)
{
    time_t    Time;
    SS_GET_SECONDS(Time);
    switch(s_pHandle->m_e_ITStatus)
    {
    case IT_STATUS_OFF_LINE :
    case IT_STATUS_IDLE     :
        {
            switch(s_pHandle->m_s_Config.m_e_Protocol)
            {
            case SS_PROTOCOL_SIP:
                {
                    //SIP_Login(s_pHandle);
                }break;
            case SS_PROTOCOL_SS:
                {
                }break;
            case SS_PROTOCOL_H323:
                {
                }break;
            }
        }break;
    case IT_STATUS_ON_LINE ://=  1, // 上线
    case IT_STATUS_DISTANCE://=  3, // 离开，暂时不在电脑旁边
    case IT_STATUS_BUSY    ://=  4, // 忙碌
    case IT_STATUS_CALL    ://=  5, // 通话中
    case IT_STATUS_STEALTH ://=  6, // 隐身
    case IT_STATUS_NOT_BOTHER://=7 // 请勿打扰
        {
            switch(s_pHandle->m_s_Config.m_e_Protocol)
            {
            case SS_PROTOCOL_SIP:
                {
                    if ((Time-s_pHandle->m_SIPTimeout)>=(s_pHandle->m_un32Expires-10))
                    {
                        s_pHandle->m_SIPTimeout=Time;
                        //SIP_Login(s_pHandle);
                    }
                }break;
            case SS_PROTOCOL_SS:
                {
                }break;
            case SS_PROTOCOL_H323:
                {
                }break;
            }
        }break;
    default:break;
    }
    return  SS_SUCCESS;
}


SS_SHORT  IT_FreeCallResource()
{
    //释放资源
    SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
    SS_closesocket(g_s_ITLibHandle.m_s_AudioConfig.m_Socket);
    g_s_ITLibHandle.m_s_AudioConfig.m_Socket = SS_SOCKET_ERROR;
    g_s_ITLibHandle.m_e_CallStatus= CALL_STATE_IDLE;
    g_s_ITLibHandle.m_e_Direction = DIRECTION_IDLE;
    g_s_ITLibHandle.m_un32CallCMD = 0;
    memset(g_s_ITLibHandle.m_s_AudioConfig.m_sRemoteIP,0,sizeof(g_s_ITLibHandle.m_s_AudioConfig.m_sRemoteIP));
    g_s_ITLibHandle.m_s_AudioConfig.m_usnRemotePort = 0;
    SS_RTPQueue_Destroy (&g_s_ITLibHandle.m_s_RTPQueue);
    SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

//////////////////////////////////////////////////////////////////////////

