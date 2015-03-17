// it_lib_im.cpp: implementation of the CITLibIM class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_im.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT IM_UplinkIND          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_UplinkCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_DownLinkIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_DownLinkCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GetNewIND          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GetNewCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_SynchronousIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_SynchronousCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupUplinkIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupUplinkCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupDownLinkIND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupDownLinkCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupGetNewIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupGetNewCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupSynchronousIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT IM_GroupSynchronousCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}

//////////////////////////////////////////////////////////////////////////


SS_SHORT Shop_GET_AREA_INFO_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	SS_BYTE     ubFlag = SS_FALSE;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_AREA_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_AREA_INFO_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_AREA_INFO_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_AREA_INFO_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_AREA_INFO_CFM message,%s,Result=%u,"
            "SellerID=%u,Number=%u,Info=%s",sHeader,ubResult,un32SellerID,un32Number,s_Info.m_s);
    }
#endif
	
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM AreaInfo;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM AreaInfo;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO AreaInfo(count,context,time) VALUES(%u,'%s',%u);",
				un32Number,pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM AreaInfo;");
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
						Param[1] = sSellerID;
						Param[2] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[3] = pInfo;
						Param[4] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_INFO_CFM,Param,4);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag)
	{
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sNumber;
		Param[3] = s_Info.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_INFO_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_AREA_SHOP_INFO_CFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR     sResult[32] = "";
	SS_CHAR     sSellerID[32] = "";
	SS_CHAR    *Param[20];
	SS_str      s_Info;
	SS_UINT32   un32SellerID=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
	SS_INIT_str(s_Info);
Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_AREA_SHOP_INFO_CFM_TYPE_JSON:
		{
			SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_AREA_SHOP_INFO_CFM message,%s,"
			"Result=%u,SellerID=%u,Info=%s",sHeader,ubResult,un32SellerID,s_Info.m_s);
	}
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM AreaShopInfo;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM AreaShopInfo;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO AreaShopInfo(context,time) "
				"VALUES('%s',%u);",pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM AreaShopInfo;");
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
						Param[1] = sSellerID;
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[2] = pInfo;
						Param[3] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_SHOP_INFO_CFM,Param,3);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = s_Info.m_s;
		Param[3] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_AREA_SHOP_INFO_CFM,Param,3);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_GET_UNIONPAY_SERIAL_NUMBER_CFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_UINT32  un32Type=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";
	SS_CHAR    sType[128] = "";

	SS_str     s_OrderCode;
	SS_str     s_SerialNumber;
	SS_INIT_str(s_OrderCode);
	SS_INIT_str(s_SerialNumber);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32Type);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM_TYPE_SERIAL_NUMBER:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_SerialNumber);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_CFM message,%s,"
			"Result=%u,SellerID=%u,ShopID=%u,OrderCode=%s,SerialNumber=%s,Type=%u",sHeader,ubResult,
			un32SellerID,un32ShopID,s_OrderCode.m_s,s_SerialNumber.m_s,un32Type);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		SS_snprintf(sType,sizeof(sType),"%u",un32Type);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = sType;
		Param[4] = s_OrderCode.m_s;
		Param[5] = s_SerialNumber.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_ORDER_CODE_PAY_MODE_CFM,Param,6);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_ORDER_REFUND_CFM                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";

	SS_str     s_OrderCode;
	SS_INIT_str(s_OrderCode);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_ORDER_REFUND_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REFUND_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REFUND_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REFUND_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_ORDER_REFUND_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_ORDER_REFUND_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_ORDER_CONFIRM_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";

	SS_str     s_OrderCode;
	SS_INIT_str(s_OrderCode);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CONFIRM_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_ORDER_CONFIRM_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_ORDER_CONFIRM_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_ORDER_CANCEL_CFM                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";

	SS_str     s_OrderCode;
	SS_INIT_str(s_OrderCode);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_ORDER_CANCEL_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CANCEL_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CANCEL_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_CANCEL_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_ORDER_CANCEL_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_CANCEL_ORDER_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_LOAD_ORDER_SINGLE_CFM                   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR     sResult[32] = "";
	SS_CHAR     sSellerID[32] = "";
	SS_CHAR     sShopID[32] = "";
	SS_CHAR    *Param[20];
	SS_str      s_Info;
	SS_str      s_OrderCode;
	SS_UINT32   un32SellerID=0;
	SS_UINT32   un32ShopID=0;
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
	SS_INIT_str(s_Info);
	SS_INIT_str(s_OrderCode);
Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_LOAD_ORDER_SINGLE_CFM_TYPE_JSON:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Info);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_LOAD_ORDER_SINGLE_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s,Info=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s,s_Info.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = s_Info.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_LOAD_ORDER_SINGLE_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_GET_ORDER_REFUND_INFO_CFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_USHORT   usnType=0;
	SS_BYTE     ubResult=0;
	SS_CHAR     sResult[32] = "";
	SS_CHAR     sSellerID[32] = "";
	SS_CHAR     sShopID[32] = "";
	SS_CHAR    *Param[20];
	SS_str      s_Info;
	SS_str      s_OrderCode;
	SS_UINT32   un32SellerID=0;
	SS_UINT32   un32ShopID=0;
	SSMSG_GetSource(pMSG,un64Source);
	SSMSG_GetDest  (pMSG,un64Dest);
	SS_INIT_str(s_Info);
	SS_INIT_str(s_OrderCode);
Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_GET_ORDER_REFUND_INFO_CFM_TYPE_JSON:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_Info);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_ORDER_REFUND_INFO_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s,Info=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s,s_Info.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = s_Info.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_ORDER_REFUND_INFO_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_ORDER_REMINDERS_CFM                     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";

	SS_str     s_OrderCode;
	SS_INIT_str(s_OrderCode);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_ORDER_REMINDERS_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_ORDER_REMINDERS_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_ORDER_REMINDERS_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_SEND_PAY_RESULT_CFM                     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
	SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
	SS_UINT64   un64Source=0;
	SS_UINT64   un64Dest  =0;
	SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
	SS_UINT32  un32SellerID=0;
	SS_UINT32  un32ShopID=0;
	SS_BYTE    ubResult=0;
	SS_USHORT  usnType=0;
	SS_CHAR    *Param[20];
	SS_CHAR    sResult[8] = "";
	SS_CHAR    sSellerID[128]="";
	SS_CHAR    sShopID[128] = "";

	SS_str     s_OrderCode;
	SS_INIT_str(s_OrderCode);

Divide_GOTO:
	switch(ntohs(*(SS_USHORT*)(pParam)))
	{
	case ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_RESULT:
		{
			SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_SELLER_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_SHOP_ID:
		{
			SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
			goto Divide_GOTO;
		}break;
	case ITREG_MALL_SEND_PAY_RESULT_CFM_TYPE_ORDER_CODE:
		{
			SSMSG_GetMessageParamEx(pParam,usnType,s_OrderCode);
			goto Divide_GOTO;
		}break;
	default:break;
	}

#ifdef   IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_SEND_PAY_RESULT_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
	}
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_SEND_PAY_RESULT_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT Shop_GET_SHOP_INFO_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_INFO_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_SHOP_INFO_CFM message,%s,Result=%u,"
            "SellerID=%u,AreaID=%u,Number=%u,Info=%s",sHeader,ubResult,un32SellerID,un32AreaID,
            un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM ShopInfo WHERE AreaID=%u;",un32AreaID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag=SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM ShopInfo WHERE AreaID=%u;",un32AreaID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO ShopInfo(AreaID,context,time,count) "
				"VALUES(%u,'%s',%u,%u);",un32AreaID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM ShopInfo WHERE AreaID=%u;",un32AreaID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			memset(sSQL,0,sizeof(sSQL));
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag=SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[4] = pInfo;
						Param[5] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_INFO_CFM,Param,5);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sNumber;
		Param[4] = s_Info.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_INFO_CFM,Param,5);
	}
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_HOME_TOP_BIG_PICTURE_CFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_CFM message,%s,"
            "Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",sHeader,ubResult,
            un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeTopBigPicture "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM HomeTopBigPicture WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO HomeTopBigPicture(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeTopBigPicture "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_HOME_TOP_BIG_PICTURE_EX_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_CFM message,%s,"
            "Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",sHeader,ubResult,
            un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeTopBigPictureEx "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM HomeTopBigPictureEx WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO HomeTopBigPictureEx(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeTopBigPictureEx "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_TOP_BIG_PICTURE_EX_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_HOME_NAVIGATION_CFM                 (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_HOME_NAVIGATION_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_HOME_NAVIGATION_CFM message,%s,"
            "Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",sHeader,ubResult,
            un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeNavigation "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM HomeNavigation WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO HomeNavigation(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM HomeNavigation "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_NAVIGATION_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_HOME_NAVIGATION_CFM,Param,6);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
}
SS_SHORT Shop_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM "
            "message,%s,Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",
            sHeader,ubResult,un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM GuessYouLikeRandomGoods "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM GuessYouLikeRandomGoods WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO GuessYouLikeRandomGoods(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM GuessYouLikeRandomGoods "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_CATEGORY_LIST_CFM                   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_CATEGORY_LIST_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_CATEGORY_LIST_CFM "
            "message,%s,Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",
            sHeader,ubResult,un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM CategoryList "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag=SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM CategoryList WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO CategoryList(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM CategoryList "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag=SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_CATEGORY_LIST_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_CATEGORY_LIST_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM "
            "message,%s,Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",
            sHeader,ubResult,un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM SpecialPropertiesCategoryList "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag=SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM SpecialPropertiesCategoryList WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO SpecialPropertiesCategoryList(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM SpecialPropertiesCategoryList "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag=SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag=SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag=SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_GOODS_INFO_CFM                      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sGoodsID[32] = "";
    SS_CHAR     sGroupID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR     sLikeCount[32] = "";
	SS_CHAR    *pCache= NULL;
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_str      s_Description;//商品描述
    SS_str      s_Name;//商品名
    SS_str      s_MarketPrice;//市场价格
    SS_str      s_OURPrice;//本店价格
	SS_str      s_MeterageName;

	SS_CHAR  sDescription[2048] = "";
	SS_CHAR  sName[2048] = "";
	SS_CHAR  sMarketPrice[2048] = "";
	SS_CHAR  sOURPrice[2048] = "";
	SS_CHAR  sInfo[2048] = "";
	SS_CHAR  sMeterageName[2048] = "";
	SS_BYTE  ubFlag=SS_FALSE;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32GoodsID=0;
    SS_UINT32   un32GroupID=0;
    SS_UINT32   un32Number=0;
    SS_UINT32   un32LikeCount=0;
	SS_UINT32   un32Len=0;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
    SS_INIT_str(s_Description);
    SS_INIT_str(s_Name);
    SS_INIT_str(s_MarketPrice);
    SS_INIT_str(s_OURPrice);
	SS_INIT_str(s_MeterageName);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_GOODS_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32GoodsID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_GROUP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32GroupID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_PICTURE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_INFO:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_DESCRIPTION:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Description);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_NAME:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Name);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_MARKET_PRICE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_MarketPrice);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_OUR_PRICE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_OURPrice);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_TYPE_LIKE_COUNT:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32LikeCount);
            goto Divide_GOTO;
        }break;
	case ITREG_MALL_GET_GOODS_INFO_CFM_TYPE_TYPE_METERAGE_NAME:
		{
			SSMSG_GetMessageParamEx (pParam,usnType,s_MeterageName);
			goto Divide_GOTO;
		}break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_GOODS_INFO_CFM message,%s,Result=%u,"
            "SellerID=%u,AreaID=%u,ShopID=%u,GoodsID=%u,GroupID=%u,Description=%s,Name=%s,"
            "MarketPrice=%s,OURPrice=%s,Number=%u,Info=%s,MeterageName=%s,LikeCount=%u",
			sHeader,ubResult,un32SellerID,un32AreaID,un32ShopID,un32GoodsID,un32GroupID,
			s_Description.m_s,s_Name.m_s,s_MarketPrice.m_s,s_OURPrice.m_s,un32Number,
			s_Info.m_s,s_MeterageName.m_s,un32LikeCount);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	SS_snprintf(sGoodsID,sizeof(sGoodsID),"%u",un32GoodsID);

	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT GroupID,Description,Name,MarketPrice,OURPrice,"
			"Number,Info,LikeCount,MeterageName,time FROM GoodsInfo WHERE AreaID=%u AND "
			"ShopID=%u AND GoodsID=%u;",un32AreaID,un32ShopID,un32GoodsID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag=SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM GoodsInfo WHERE AreaID=%u AND ShopID=%u AND GoodsID=%u;",
				un32AreaID,un32ShopID,un32GoodsID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		un32Len=s_Info.m_len+s_Description.m_len+s_Name.m_len+s_MarketPrice.m_len+s_OURPrice.m_len+s_MeterageName.m_len+1024;
		if (pCache = (SS_CHAR *)SS_malloc(un32Len*2))
		{
			SS_CHAR *pDescription =base64_encode(s_Description.m_s,s_Description.m_len);
			SS_CHAR *pName        =base64_encode(s_Name.m_s,s_Name.m_len);
			SS_CHAR *pInfo        =base64_encode(s_Info.m_s,s_Info.m_len);
			SS_CHAR *pMeterageName=base64_encode(s_MeterageName.m_s,s_MeterageName.m_len);
			SS_snprintf(pCache,un32Len*2,"INSERT INTO GoodsInfo(AreaID,ShopID,GoodsID,GroupID,Description,Name,"
				"MarketPrice,OURPrice,Number,Info,LikeCount,MeterageName,time) VALUES(%u,%u,%u,'%u','%s','%s',"
				"'%s','%s','%u','%s','%u','%s',%u);",un32AreaID,un32ShopID,un32GoodsID,un32GroupID,
				pDescription?pDescription:"",pName?pName:"",(NULL==s_MarketPrice.m_s)?"":s_MarketPrice.m_s,
				(NULL==s_OURPrice.m_s)?"":s_OURPrice.m_s,un32Number,pInfo?pInfo:"",un32LikeCount,
				pMeterageName?pMeterageName:"",un32Time);
			SS_free(pMeterageName);
			SS_free(pName);
			SS_free(pInfo);
			SS_free(pMeterageName);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		SS_snprintf(sSQL,sizeof(sSQL),"SELECT GroupID,Description,Name,MarketPrice,OURPrice,"
			"Number,Info,LikeCount,MeterageName,time FROM GoodsInfo WHERE AreaID=%u AND "
			"ShopID=%u AND GoodsID=%u;",un32AreaID,un32ShopID,un32GoodsID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		sSQL[0] = 0;
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				if (s_ROW = IT_SqliteFetchRow(s_pRecord))
				{
					ubFlag=SS_TRUE;
					strncpy(sGroupID,SS_IfROWString(s_ROW[0]),sizeof(sGroupID));
					
					SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[1]),strlen(SS_IfROWString(s_ROW[1])));
					strncpy(sDescription,SS_IfROWString(pInfo),sizeof(sDescription));
					SS_free(pInfo);
					
					pInfo=base64_decode(SS_IfROWString(s_ROW[2]),strlen(SS_IfROWString(s_ROW[2])));
					strncpy(sName,SS_IfROWString(pInfo),sizeof(sName));
					SS_free(pInfo);
					
					strncpy(sMarketPrice,SS_IfROWString(s_ROW[3]),sizeof(sMarketPrice));
					strncpy(sOURPrice,SS_IfROWString(s_ROW[4]),sizeof(sOURPrice));
					strncpy(sNumber,SS_IfROWString(s_ROW[5]),sizeof(sNumber));
					
					pInfo=base64_decode(SS_IfROWString(s_ROW[6]),strlen(SS_IfROWString(s_ROW[6])));
					strncpy(sInfo,SS_IfROWString(pInfo),sizeof(sInfo));
					SS_free(pInfo);
					
					strncpy(sLikeCount,SS_IfROWString(s_ROW[7]),sizeof(sLikeCount));
					
					pInfo=base64_decode(SS_IfROWString(s_ROW[8]),strlen(SS_IfROWString(s_ROW[8])));
					strncpy(sMeterageName,SS_IfROWString(pInfo),sizeof(sMeterageName));
					SS_free(pInfo);

					un32Time=SS_IfROWNumber(s_ROW[9]);
				}
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{
			if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag)
			{
				Param[0] = "0";
				Param[1] = sSellerID;
				Param[2] = sAreaID;
				Param[3] = sShopID;
				Param[4] = sGoodsID;
				Param[5] = sGroupID;
				Param[6] = sDescription;
				Param[7] = sName;
				Param[8] = sMarketPrice;
				Param[9] = sOURPrice;
				Param[10] = sNumber;
				Param[11]= sInfo;
				Param[12]= sLikeCount;
				Param[13]= sMeterageName;
				Param[14]= NULL;
				s_pHandle->m_f_CallBack(IT_MSG_GET_GOODS_INFO_CFM,Param,14);
			}
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag=SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag)
	{
		SS_snprintf(sGroupID,sizeof(sGroupID),"%u",un32GroupID);
		SS_snprintf(sLikeCount,sizeof(sLikeCount),"%u",un32LikeCount);
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sGoodsID;
		Param[5] = sGroupID;
		Param[6] = s_Description.m_s;
		Param[7] = s_Name.m_s;
		Param[8] = s_MarketPrice.m_s;
		Param[9] = s_OURPrice.m_s;
		Param[10]= sNumber;
		Param[11]= s_Info.m_s;
		Param[12]= sLikeCount;
		Param[13]= s_MeterageName.m_s;
		Param[14]= NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_GOODS_INFO_CFM,Param,14);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag=SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_REPORT_MY_LOCATION_CFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_REPORT_MY_LOCATION_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_REPORT_MY_LOCATION_CFM message,%s,"
            "Result=%u,SellerID=%u,Json=%s",sHeader,ubResult,un32SellerID,s_Json.m_s);
    }
#endif

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
    Param[0] = sResult;
    Param[1] = sSellerID;
    Param[2] = s_Json.m_s;
    Param[3] = NULL;

    s_pHandle->m_f_CallBack(IT_MSG_REPORT_MY_LOCATION_CFM,Param,3);

    return  SS_SUCCESS;
}

SS_SHORT Shop_GET_PACKAGE_CFM                         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PACKAGE_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_PACKAGE_CFM "
            "message,%s,Result=%u,SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Info=%s",
            sHeader,ubResult,un32SellerID,un32AreaID,un32ShopID,un32Number,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM Package "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM Package WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Info.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,s_Info.m_len*2+1024,"INSERT INTO Package(AreaID,ShopID,context,time,count) "
				"VALUES(%u,%u,'%s',%u,%u);",un32AreaID,un32ShopID,pBase64?pBase64:"",un32Time,un32Number);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count FROM Package "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			sSQL[0] = 0;
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_PACKAGE_CFM,Param,6);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_PACKAGE_CFM,Param,6);
	}
    IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_GET_GOODS_ALL_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sAreaID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
	SS_CHAR     sDomain[256] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_str      s_Domain;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32AreaID = 0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
	SS_CHAR    *pCache= NULL;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	SS_UINT32   un32Len=0;
	SS_BYTE     ubFlag=SS_FALSE;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
    SS_INIT_str(s_Domain);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_AREA_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32AreaID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_GOODS_ALL_CFM_TYPE_DOMAIN:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Domain);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_GOODS_ALL_CFM message,%s,Result=%u,"
            "SellerID=%u,AreaID=%u,ShopID=%u,Number=%u,Domain=%s,InfoLen=%u,Info=%s",sHeader,ubResult,
            un32SellerID,un32AreaID,un32ShopID,un32Number,s_Domain.m_s,s_Info.m_len,s_Info.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sAreaID,sizeof(sAreaID),"%u",un32AreaID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count,Domain FROM GoodsAll "
			"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM GoodsAll WHERE AreaID=%u AND ShopID=%u;",
				un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		un32Len=(s_Info.m_len*2)+s_Domain.m_len+1024;
		if (pCache = (SS_CHAR*)SS_malloc(un32Len))
		{
			SS_CHAR *pBase64=base64_encode(s_Info.m_s,s_Info.m_len);
			SS_snprintf(pCache,un32Len,"INSERT INTO GoodsAll(AreaID,ShopID,context,time,count,Domain) "
				"VALUES(%u,%u,'%s',%u,%u,'%s');",un32AreaID,un32ShopID,(pBase64)?pBase64:"",
				un32Time,un32Number,s_Domain.m_s);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,count,Domain FROM GoodsAll "
				"WHERE AreaID=%u AND ShopID=%u;",un32AreaID,un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					if (s_ROW = IT_SqliteFetchRow(s_pRecord))
					{
						ubFlag = SS_TRUE;
						Param[0] = "0";
						Param[1] = sSellerID;
						Param[2] = sAreaID;
						Param[3] = sShopID;
						Param[4] = (SS_CHAR*)SS_IfROWString(s_ROW[1]);
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[5] = pInfo;
						Param[6] = (SS_CHAR*)SS_IfROWString(s_ROW[2]);
						Param[7] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_GOODS_ALL_CFM,Param,7);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag=SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sAreaID;
		Param[3] = sShopID;
		Param[4] = sNumber;
		Param[5] = s_Info.m_s;
		Param[6] = s_Domain.m_s;
		Param[7] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_GOODS_ALL_CFM,Param,7);
	}
	IT_DBSetLastBrowseShop(un32SellerID,un32AreaID,un32ShopID);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag=SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_ADD_ORDER_CFM    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_OrderCode;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_OrderCode);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_ADD_ORDER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_ADD_ORDER_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_ADD_ORDER_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_ADD_ORDER_CFM_TYPE_ORDER_CODE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_OrderCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_ADD_ORDER_CFM message,%s,Result=%u,SellerID=%u,"
            "ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_ADD_ORDER_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_UPDATE_ORDER_CFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_OrderCode;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_OrderCode);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_UPDATE_ORDER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_UPDATE_ORDER_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_UPDATE_ORDER_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_UPDATE_ORDER_CFM_TYPE_ORDER_CODE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_OrderCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_UPDATE_ORDER_CFM message,%s,Result=%u,SellerID=%u,"
            "ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_UPDATE_ORDER_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_DEL_ORDER_CFM    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_OrderCode;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_OrderCode);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_DEL_ORDER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_DEL_ORDER_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_DEL_ORDER_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_DEL_ORDER_CFM_TYPE_ORDER_CODE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_OrderCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_DEL_ORDER_CFM message,%s,Result=%u,SellerID=%u,"
            "ShopID=%u,OrderCode=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_OrderCode.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_OrderCode.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_DEL_ORDER_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_LOAD_ORDER_CFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sNumber[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Info;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32Number=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Info);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_LOAD_ORDER_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_ORDER_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_ORDER_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_ORDER_CFM_TYPE_NUMBER:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32Number);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_ORDER_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Info);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_LOAD_ORDER_CFM message,%s,Result=%u,SellerID=%u,"
			"ShopID=%u,Number=%u,Info=%u_%s",sHeader,ubResult,un32SellerID,un32ShopID,un32Number,
			s_Info.m_len,s_Info.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sNumber,sizeof(sNumber),"%u",un32Number);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = sNumber;
		Param[4] = s_Info.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_LOAD_ORDER_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_LOAD_RED_PACKAGE_CFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_LOAD_RED_PACKAGE_CFM message,%s,Result=%u,"
            "SellerID=%u,ShopID=%u,Json=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_Json.m_s);
    }
#endif
    if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_ubFlag)
    {
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_Json.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_CFM,Param,4);
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_RECEIVE_RED_PACKAGE_CFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[32] = "";
    SS_CHAR     sShopID[32] = "";
    SS_CHAR     sRedPackageID[32] = "";
    SS_CHAR    *Param[20];
    SS_str      s_TotalMoney;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32RedPackageID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_TotalMoney);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_RED_PACKAGE_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RedPackageID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_RECEIVE_RED_PACKAGE_CFM_TYPE_TOTAL_MONEY:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_TotalMoney);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_RECEIVE_RED_PACKAGE_CFM message,%s,Result=%u,"
            "SellerID=%u,ShopID=%u,RedPackageID=%u,TotalMoney=%s",sHeader,ubResult,un32SellerID,
            un32ShopID,un32RedPackageID,s_TotalMoney.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sRedPackageID,sizeof(sRedPackageID),"%u",un32RedPackageID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = sRedPackageID;
		Param[4] = s_TotalMoney.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_RECEIVE_RED_PACKAGE_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_USE_RED_PACKAGE_CFM           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR    *Param[20];
    
    SS_str      s_Json;
    SS_str      s_Totalmoney;
    SS_str      s_OrderCode;

    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_INIT_str(s_Json);
    SS_INIT_str(s_Totalmoney);
    SS_INIT_str(s_OrderCode);

Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_USE_RED_PACKAGE_CFM_TYPE_TOTAL_MONEY:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Totalmoney);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_USE_RED_PACKAGE_CFM_ORDER_CODE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_OrderCode);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_USE_RED_PACKAGE_CFM message,%s,"
            "Result=%u,SellerID=%u,ShopID=%u,Totalmoney=%s,OrderCode=%s",sHeader,
            ubResult,un32SellerID,un32ShopID,s_Totalmoney.m_s,s_OrderCode.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_Totalmoney.m_s;
		Param[4] = s_OrderCode.m_s;
		Param[5] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_USE_RED_PACKAGE_CFM,Param,5);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_ubFlag = SS_FALSE;
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_s_OrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_LOAD_RED_PACKAGE_USE_RULES_CFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[20480] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_CFM message,%s,Result=%u,"
            "SellerID=%u,ShopID=%u,Json=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_Json.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM RedPackageUseRules WHERE ShopID=%u;",un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM RedPackageUseRules WHERE ShopID=%u;",un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO RedPackageUseRules(ShopID,context,time) VALUES(%u,'%s',%u);",
			un32ShopID,s_Json.m_s,un32Time);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM RedPackageUseRules WHERE ShopID=%u;",un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				if (s_ROW = IT_SqliteFetchRow(s_pRecord))
				{
					SS_snprintf(sSQL,sizeof(sSQL),"%s",SS_IfROWString(s_ROW[0]));
				}
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (sSQL[0])
		{
			if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag)
			{
				Param[0] = "0";
				Param[1] = sSellerID;
				Param[2] = sShopID;
				Param[3] = sSQL;
				Param[4] = NULL;
				s_pHandle->m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM,Param,4);
			}
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_Json.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_LOAD_RED_PACKAGE_USE_RULES_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_PUSH_MESSAGE_IND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sMSG[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_str      s_MSGArray;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SS_UINT32   un32MSGID=0;
    SS_USHORT   usnMSGType=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
    SS_INIT_str(s_MSGArray);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_MSG_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32MSGID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_TYPE:
        {
            SSMSG_GetShortMessageParam(pParam,usnType,usnMSGType);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_PUSH_MESSAGE_IND_TYPE_MSG_ARRAY:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_MSGArray);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_PUSH_MESSAGE_IND message,%s,MSGID=%u,SellerID=%u,"
            "ShopID=%u,Json=%s,MSGType=%u,MSGArrayLen=%u",sHeader,un32MSGID,un32SellerID,un32ShopID,
            s_Json.m_s,usnMSGType,s_MSGArray.m_len);
    }
#endif

    SS_snprintf(sMSG,sizeof(sMSG),"%u",un32MSGID);
    SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
    SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
    Param[0] = sSellerID;
    Param[1] = sShopID;
    Param[2] = sMSG;
    Param[3] = s_Json.m_s;
    Param[4] = NULL;

    ITREG_MallPushMessageCFM(un64Source,un64Dest,SS_SUCCESS,un32SellerID,un32ShopID,un32MSGID,
        usnMSGType,&s_MSGArray);
    s_pHandle->m_f_CallBack(IT_MSG_PUSH_MESSAGE_IND,Param,4);

    return  SS_SUCCESS;
}

SS_SHORT Shop_GET_RED_PACKAGE_BALANCE_CFM             (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Balance;
    SS_UINT32   un32SellerID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Balance);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM_TYPE_BALANCE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Balance);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_RED_PACKAGE_BALANCE_CFM message,%s,"
            "Result=%u,SellerID=%u,Balance=%s",sHeader,ubResult,un32SellerID,s_Balance.m_s);
    }
#endif
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_ubFlag)
	{
		SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = s_Balance.m_s;
		Param[3] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_RED_PACKAGE_BALANCE_CFM,Param,3);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_SELLER_ABOUT_CFM                    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SELLER_ABOUT_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_SELLER_ABOUT_CFM message,%s,Result=%u,"
            "SellerID=%u,Json=%s",sHeader,ubResult,un32SellerID,s_Json.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM SellerAbout;");
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete from SellerAbout;");
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Json.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Json.m_s,s_Json.m_len);
			SS_snprintf(pCache,s_Json.m_len*2+1024,"INSERT INTO SellerAbout(context,time) "
				"VALUES('%s',%u);",pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context,time FROM SellerAbout;");
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
						Param[1] = sSellerID;
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[2] = pInfo;
						Param[3] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_SELLER_ABOUT_CFM,Param,3);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = s_Json.m_s;
		Param[3] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_SELLER_ABOUT_CFM,Param,3);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT Shop_GET_SHOP_ABOUT_CFM                      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
	SS_CHAR    *pCache= NULL;
	SS_BYTE     ubFlag=SS_FALSE;
	SS_CHAR     sSQL[2048] = "";
	SS_UINT32   un32Time=0;
	PIT_SqliteRES s_pRecord=NULL;
	IT_SqliteROW  s_ROW    =NULL;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Json);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_SHOP_ABOUT_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_SHOP_ABOUT_CFM message,%s,Result=%u,"
            "SellerID=%u,ShopID=%u,Json=%s",sHeader,ubResult,un32SellerID,un32ShopID,s_Json.m_s);
    }
#endif
	SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
	SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
	if (0 == ubResult)
	{
		/*SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM ShopAbout WHERE ShopID=%u;",un32ShopID);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
		memset(sSQL,0,sizeof(sSQL));
		if (s_pRecord)
		{
			if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
			{
				ubFlag = SS_TRUE;
			}
			IT_SqliteRelease(&s_pRecord);
		}
		if (ubFlag)
		{*/
			SS_snprintf(sSQL,sizeof(sSQL),"delete FROM ShopAbout WHERE ShopID=%u;",un32ShopID);
			IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		//}
		SS_GET_SECONDS(un32Time);
		if (pCache = (SS_CHAR *)SS_malloc(s_Json.m_len*2+1024))
		{
			SS_CHAR *pBase64=base64_encode(s_Json.m_s,s_Json.m_len);
			SS_snprintf(pCache,s_Json.m_len*2+1024,"INSERT INTO ShopAbout(ShopID,context,time) "
				"VALUES(%u,'%s',%u);",un32ShopID,pBase64?pBase64:"",un32Time);
			SS_free(pBase64);
			IT_SqliteExecute(&g_s_ITLibHandle,pCache,NULL);
			SS_free(pCache);
		}
		/*if (ubFlag)
		{
			return  SS_SUCCESS;
		}*/
	}
	else
	{
		if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag)
		{
			SS_snprintf(sSQL,sizeof(sSQL),"SELECT context FROM ShopAbout WHERE ShopID=%u;",un32ShopID);
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
						Param[1] = sSellerID;
						Param[2] = sShopID;
						SS_CHAR *pInfo=base64_decode(SS_IfROWString(s_ROW[0]),strlen(SS_IfROWString(s_ROW[0])));
						Param[3] = pInfo;
						Param[4] = NULL;
						s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_ABOUT_CFM,Param,4);
						SS_free(pInfo);
					}
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		if (ubFlag)
		{
			SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
			g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag = SS_FALSE;
			SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
			return  SS_SUCCESS;
		}
	}
	if (g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag)
	{
		SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
		Param[0] = sResult;
		Param[1] = sSellerID;
		Param[2] = sShopID;
		Param[3] = s_Json.m_s;
		Param[4] = NULL;
		s_pHandle->m_f_CallBack(IT_MSG_GET_SHOP_ABOUT_CFM,Param,4);
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag = SS_FALSE;
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT Shop_GET_PUSH_MESSAGE_INFO_CFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR     sResult[32] = "";
    SS_CHAR     sSellerID[64] = "";
    SS_CHAR     sShopID[64] = "";
    SS_CHAR     sMSGID[64] = "";
    SS_CHAR     sMSGType[64] = "";
    SS_CHAR    *Param[20];
    SS_str      s_Json;
    SS_UINT32   un32SellerID=0;
    SS_UINT32   un32ShopID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_UINT32   un32MSGID=0;//消息ID
    SS_UINT32   un32MSGType=0;//消息类型
    SS_str      s_ShopName;    //分店名称
    SS_str      s_Title;       //标题
    SS_str      s_ImageURL;    //图片的URL
    SS_str      s_HtmlURL;     //消息的ULR
    SS_str      s_Abstract;    //消息概要

    SS_INIT_str(s_ShopName);
    SS_INIT_str(s_Title);
    SS_INIT_str(s_ImageURL);
    SS_INIT_str(s_HtmlURL);
    SS_INIT_str(s_Abstract);
    SS_INIT_str(s_Json);


Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SELLER_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32SellerID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SHOP_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32ShopID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_MSG_ID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32MSGID);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_MSG_TYPE:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32MSGType);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_JSON:
        {
            SSMSG_GetBigMessageParam (pParam,usnType,s_Json);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_SHOP_NAME:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_ShopName);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_TITLE:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Title);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_IMAGE_URL:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_ImageURL);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_HTML_URL:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_HtmlURL);
            goto Divide_GOTO;
        }break;
    case ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM_TYPE_ABSTRACT:
        {
            SSMSG_GetMessageParamEx (pParam,usnType,s_Abstract);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_MALL_GET_PUSH_MESSAGE_INFO_CFM message,%s,Result=%u,"
            "SellerID=%u,ShopID=%u,MSGID=%u,MSGType=%u,Json=%s,ShopName=%s,Title=%s,ImageURL=%s,"
            "HtmlURL=%s,Abstract=%s",sHeader,ubResult,un32SellerID,un32ShopID,un32MSGID,un32MSGType,
            s_Json.m_s,s_ShopName.m_s,s_Title.m_s,s_ImageURL.m_s,s_HtmlURL.m_s,s_Abstract.m_s);
    }
#endif

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    SS_snprintf(sSellerID,sizeof(sSellerID),"%u",un32SellerID);
    SS_snprintf(sShopID,sizeof(sShopID),"%u",un32ShopID);
    SS_snprintf(sMSGID,sizeof(sMSGID),"%u",un32MSGID);
    SS_snprintf(sMSGType,sizeof(sMSGType),"%u",un32MSGType);

    Param[0] = sResult;
    Param[1] = sSellerID;
    Param[2] = sShopID;
    Param[3] = sMSGID;
    Param[4] = sMSGType;
    Param[5] = s_ShopName.m_s;
    Param[6] = s_Title.m_s;
    Param[7] = s_ImageURL.m_s;
    Param[8] = s_HtmlURL.m_s;
    Param[9] = s_Abstract.m_s;
    Param[10] = s_Json.m_s;
    Param[11] = NULL;

    s_pHandle->m_f_CallBack(IT_MSG_GET_PUSH_MESSAGE_INFO_CFM,Param,11);

    return  SS_SUCCESS;
}




