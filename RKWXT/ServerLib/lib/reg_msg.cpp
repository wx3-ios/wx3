// reg_msg.cpp: implementation of the CREGMSG class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "reg_msg.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_CallBackCDRCFM(
    IN  SS_UINT64  const un64Source,
    IN  SS_UINT64  const un64Dest,
	IN  SS_BYTE    const ubResult,
    IN  SS_UINT32  const un32RID)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =2;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+5;
	s_msg.m_un32MSGNumber=ITREG_CALL_BACK_CDR_CFM;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_SetByteMessageParam (p,ITREG_CALL_BACK_CDR_CFM_TYPE_RESULT,ubResult);
	SSMSG_Setint32MessageParam(p,ITREG_CALL_BACK_CDR_CFM_TYPE_RID   ,un32RID);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_BACK_CDR_CFM message,%s,"
			"RID=%u,Result=%u",sHeader,un32RID,ubResult);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_BACK_CDR_CFM message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	return  SS_SUCCESS;
}
SS_SHORT ITREG_MallSendPayResultIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR   const*pOrderCode,
	IN SS_BYTE   const ubPayType,
	IN SS_BYTE   const ubResult)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =5;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+10;
	s_msg.m_un32MSGNumber=ITREG_MALL_SEND_PAY_RESULT_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);
	SSMSG_SetByteMessageParam(p,ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_RESULT,ubResult);
	SSMSG_SetByteMessageParam(p,ITREG_MALL_SEND_PAY_RESULT_IND_TYPE_PAY_TYPE,ubPayType);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_SEND_PAY_RESULT_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s,Result=%u,PayType=%u",sHeader,un32SellerID,un32ShopID,
			pOrderCode,ubResult,ubPayType);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_SEND_PAY_RESULT_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutSendPayResultIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetOrderRefundInfoIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8;
	s_msg.m_un32MSGNumber=ITREG_MALL_GET_ORDER_REFUND_INFO_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_GET_ORDER_REFUND_INFO_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_ORDER_REFUND_INFO_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,un32SellerID,un32ShopID,pOrderCode);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_ORDER_REFUND_INFO_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetOrderRefundInfoIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_MallLoadOrderSingleIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8;
	s_msg.m_un32MSGNumber=ITREG_MALL_LOAD_ORDER_SINGLE_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_LOAD_ORDER_SINGLE_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_LOAD_ORDER_SINGLE_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,un32SellerID,un32ShopID,pOrderCode);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_LOAD_ORDER_SINGLE_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLoadOrderSingleIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT ITREG_MallOrderRemindersIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR   sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8;
	s_msg.m_un32MSGNumber=ITREG_MALL_ORDER_REMINDERS_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_REMINDERS_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_REMINDERS_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_ORDER_REMINDERS_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_ORDER_REMINDERS_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,un32SellerID,un32ShopID,pOrderCode);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_ORDER_REMINDERS_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRemindersIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_MallCancelOrderIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8;
	s_msg.m_un32MSGNumber=ITREG_MALL_ORDER_CANCEL_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_CANCEL_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_CANCEL_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_ORDER_CANCEL_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_ORDER_CANCEL_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,un32SellerID,un32ShopID,pOrderCode);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_ORDER_CANCEL_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderCancelIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_MallOrderConfirmIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8;
	s_msg.m_un32MSGNumber=ITREG_MALL_ORDER_CONFIRM_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_CONFIRM_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_CONFIRM_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_ORDER_CONFIRM_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_ORDER_CONFIRM_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s",sHeader,un32SellerID,un32ShopID,pOrderCode);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_ORDER_CONFIRM_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderConfirmIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_MallOrderRefundIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode,
	IN SS_CHAR const *pGrounds)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnOrderCodeLen=strlen(pOrderCode);
	SS_USHORT usnGroundsLen  =strlen(pGrounds);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =4;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnOrderCodeLen+1+8+usnGroundsLen+1;
	s_msg.m_un32MSGNumber=ITREG_MALL_ORDER_REFUND_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_REFUND_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_ORDER_REFUND_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_ORDER_REFUND_IND_TYPE_ORDER_CODE,pOrderCode,usnOrderCodeLen);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_ORDER_REFUND_IND_TYPE_GROUNDS,pGrounds,usnGroundsLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_ORDER_REFUND_IND message,%s,SellerID=%u,"
			"ShopID=%u,OrderCode=%s,Grounds=%s",sHeader,un32SellerID,un32ShopID,pOrderCode,pGrounds);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_ORDER_REFUND_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutOrderRefundIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_MallGetOrderCodePayModeIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32Type,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR   const *pOrderCode)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnLen=strlen(pOrderCode);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =4;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnLen+1+12;
	s_msg.m_un32MSGNumber=ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_SELLER_ID,un32SellerID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_SHOP_ID,un32ShopID);
	SSMSG_SetMessageParamEx(p,ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE_ORDER_CODE,pOrderCode,usnLen);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND_TYPE,un32Type);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND message,%s,"
			"SellerID=%u,ShopID=%u,OrderCode=%s,Type=%u",sHeader,un32SellerID,un32ShopID,pOrderCode,un32Type);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_UNIONPAY_SERIAL_NUMBER_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32ShopID   = un32ShopID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_un32GoodsID  = un32Type;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetUnionpaySerialNumberIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}

SS_SHORT ITREG_SelectPhoneCheckCodeIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
	IN SS_CHAR    const*pPhone)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;
	SS_USHORT usnLen=strlen(pPhone);
	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =1;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnLen+1;
	s_msg.m_un32MSGNumber=ITREG_SELECT_PHONE_CHECK_CODE_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_SetMessageParamEx(p,ITREG_SELECT_PHONE_CHECK_CODE_IND_TYPE_PHONE,pPhone,usnLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_SELECT_PHONE_CHECK_CODE_IND message,%s,Phone=%s",sHeader,pPhone);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_SELECT_PHONE_CHECK_CODE_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	return  SS_SUCCESS;
}
SS_SHORT ITREG_GetCreditBalanceIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
    IN  SS_UINT32 const un32SellerID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_GET_CREDIT_BALANCE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_GET_CREDIT_BALANCE_IND_TYPE_SELLER_ID,un32SellerID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_GET_CREDIT_BALANCE_IND message,%s,"
            "SellerID=%u",sHeader,un32SellerID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_GET_CREDIT_BALANCE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetCreditBalanceIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_RechargeIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
    IN  SS_UINT32 const un32Type,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32Price,
    IN  SS_CHAR   const*pAccount,
    IN  SS_CHAR   const*pPassword)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32AccountLen = strlen(pAccount);
    SS_UINT32  un32PasswordLen =strlen(pPassword);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =5;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12+un32AccountLen+1+un32PasswordLen+1;
    s_msg.m_un32MSGNumber=ITREG_RECHARGE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_RECHARGE_IND_TYPE,un32Type);
    SSMSG_Setint32MessageParam(p,ITREG_RECHARGE_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_RECHARGE_IND_TYPE_PRICE,un32Price);
    SSMSG_SetMessageParamEx   (p,ITREG_RECHARGE_IND_TYPE_ACCOUNT,pAccount,un32AccountLen);
    SSMSG_SetMessageParamEx   (p,ITREG_RECHARGE_IND_TYPE_PASSWORD,pPassword,un32PasswordLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_RECHARGE_IND message,%s,Type=%u,SellerID=%u,Price=%u,"
            "Account=%s,pPassword=%s",sHeader,un32Type,un32SellerID,un32Price,pAccount,pPassword);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_RECHARGE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRechargeIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRechargeIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRechargeIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_GetRechargePreferentialRulesIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND_TYPE_SELLER_ID,un32SellerID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND message,%s,"
            "SellerID=%u",sHeader,un32SellerID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_GET_RECHARGE_PREFERENTIAL_RULES_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_UpdateBoundMobileNumberIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN SS_CHAR   const*pPhone)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32Len = strlen(pPhone);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+un32Len+1;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_SetMessageParamEx   (p,ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND_TYPE_PHONE,pPhone,un32Len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND message,%s,"
            "SellerID=%u,Phone=%s",sHeader,un32SellerID,pPhone);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_BOUND_MOBILE_NUMBER_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateBoundMobileNumberIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_AboutIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+s_pStr->m_len+1;
    s_msg.m_un32MSGNumber=ITREG_IT_ABOUT_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_IND_TYPE_STRING,s_pStr->m_s,s_pStr->m_len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IT_ABOUT_IND message,%s,StrLen=%u",sHeader,s_pStr->m_len);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IT_ABOUT_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_AboutHelpIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+s_pStr->m_len+1;
    s_msg.m_un32MSGNumber=ITREG_IT_ABOUT_HELP_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_HELP_IND_TYPE_STRING,s_pStr->m_s,s_pStr->m_len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IT_ABOUT_HELP_IND message,%s,StrLen=%u",sHeader,s_pStr->m_len);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IT_ABOUT_HELP_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutHelp.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_AboutProtocolIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+s_pStr->m_len+1;
    s_msg.m_un32MSGNumber=ITREG_IT_ABOUT_PROTOCOL_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_PROTOCOL_IND_TYPE_STRING,s_pStr->m_s,s_pStr->m_len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IT_ABOUT_PROTOCOL_IND message,%s,StrLen=%u",sHeader,s_pStr->m_len);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IT_ABOUT_PROTOCOL_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutProtocolIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_AboutFeedBackIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr,
    IN SS_CHAR const*pQQ,
    IN SS_CHAR const*pEMail,
    IN SS_CHAR const*pContent)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32 un32QQLen     = strlen(pQQ);
    SS_UINT32 un32EMailLen  = strlen(pEMail);
    SS_UINT32 un32ContentLen= strlen(pContent);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+
        s_pStr->m_len+1+un32QQLen+1+un32EMailLen+1+un32ContentLen+1;
    s_msg.m_un32MSGNumber=ITREG_IT_ABOUT_FEED_BACK_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_STRING,s_pStr->m_s,s_pStr->m_len);
    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_QQ,pQQ,un32QQLen);
    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_EMAIL,pEMail,un32EMailLen);
    SSMSG_SetMessageParamEx(p,ITREG_IT_ABOUT_FEED_BACK_IND_TYPE_CONTENT,pContent,un32ContentLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IT_ABOUT_FEED_BACK_IND message,%s,StrLen=%u,"
            "QQ=%s,EMail=%s,Content=%s",sHeader,s_pStr->m_len,pQQ,pEMail,pContent);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IT_ABOUT_FEED_BACK_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutAboutFeedBackIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_UpdateREGShopIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+8;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_REG_SHOP_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_UPDATE_REG_SHOP_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_UPDATE_REG_SHOP_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_REG_SHOP_IND message,%s,"
            "SellerID=%u,ShopID=%u",sHeader,un32SellerID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_REG_SHOP_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateREGShopIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_ReportTokenIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN  SS_CHAR   const*pToken,
    IN  SS_CHAR   const*pUserID,
    IN  SS_UINT32 const un32CertsType,
    IN  SS_CHAR   const*pMachineID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32TokenLen =strlen(pToken);
    SS_UINT32  un32UserIDLen=strlen(pUserID);
    SS_UINT32  un32MachineLen =strlen(pMachineID);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =5;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+8+
        un32TokenLen+1+un32UserIDLen+1+un32MachineLen+1;
    s_msg.m_un32MSGNumber=ITREG_REPORT_TOKEN_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_REPORT_TOKEN_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_REPORT_TOKEN_IND_TYPE_CERTS_TYPE,un32CertsType);
    SSMSG_SetMessageParamEx   (p,ITREG_REPORT_TOKEN_IND_TYPE_TOKEN,pToken,un32TokenLen);
    SSMSG_SetMessageParamEx   (p,ITREG_REPORT_TOKEN_IND_TYPE_USER_ID,pUserID,un32UserIDLen);
    SSMSG_SetMessageParamEx   (p,ITREG_REPORT_TOKEN_IND_TYPE_MACHINE_ID,pMachineID,un32MachineLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_REPORT_TOKEN_IND message,%s,SellerID=%u,"
            "CertsType=%u,Token=%s,UserID=%s,MachineID=%s",sHeader,un32SellerID,un32CertsType,
            pToken,pUserID,pMachineID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_REPORT_TOKEN_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportTokenIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportTokenIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportTokenIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_MallGetPushMessageInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_UINT32 const un32MSGType)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_MSG_ID,un32MSGID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND_TYPE_MSG_TYPE,un32MSGType);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND message,%s,SellerID=%u,"
            "ShopID=%u,MSGID=%u,MSGType=%u",sHeader,un32SellerID,un32ShopID,un32MSGID,un32MSGType);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_PUSH_MESSAGE_INFO_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallGetRedPackageBalanceIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND_TYPE_SELLER_ID,un32SellerID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND message,%s,"
            "SellerID=%u",sHeader,un32SellerID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_RED_PACKAGE_BALANCE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetRedPackageBalanceIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetSellerAboutInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_SELLER_ABOUT_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SELLER_ABOUT_IND_TYPE_SELLER_ID,un32SellerID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_SELLER_ABOUT_IND message,%s,"
            "SellerID=%u",sHeader,un32SellerID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_SELLER_ABOUT_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetSellerAboutInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetShopAboutInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID,
    IN SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+8;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_SHOP_ABOUT_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SHOP_ABOUT_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SHOP_ABOUT_IND_TYPE_SHOP_ID  ,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_SHOP_ABOUT_IND message,%s,"
            "SellerID=%u,ShopID=%u",sHeader,un32SellerID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_SHOP_ABOUT_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetShopAboutInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_MallPushMessageCFM  (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_USHORT const usnMSGType,
    IN SS_str    const*s_MSGArray)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =6;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+15+s_MSGArray->m_len+1;
    s_msg.m_un32MSGNumber=ITREG_MALL_PUSH_MESSAGE_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_MSG_ID,un32MSGID);
    SSMSG_SetShortMessageParam(p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_TYPE,usnMSGType);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_PUSH_MESSAGE_CFM_TYPE_MSG_ARRAY,s_MSGArray->m_s,s_MSGArray->m_len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_PUSH_MESSAGE_CFM message,%s,Result=%u,SellerID=%u,"
            "ShopID=%u,MSGID=%u,MSGType=%u,MSGArrayLen=%u",sHeader,ubResult,un32SellerID,un32ShopID,
            un32MSGID,usnMSGType,s_MSGArray->m_len);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_PUSH_MESSAGE_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallLoadRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_MALL_LOAD_RED_PACKAGE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_IND_TYPE_WOXIN_ID,un64WoXinID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_LOAD_RED_PACKAGE_IND message,%s,SellerID=%u,"
            ",WoXinID=" SS_Print64u ",ShopID=%u",sHeader,un32SellerID,un64WoXinID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_LOAD_RED_PACKAGE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallReceiveRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_UINT32 const un32RedPackageID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+20;
    s_msg.m_un32MSGNumber=ITREG_MALL_RECEIVE_RED_PACKAGE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_SHOP_ID  ,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_WOXIN_ID ,un64WoXinID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_RECEIVE_RED_PACKAGE_IND_TYPE_RED_PACKAGE_ID,un32RedPackageID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_RECEIVE_RED_PACKAGE_IND message,%s,SellerID="
            SS_Print64u ",WoXinID=" SS_Print64u ",ShopID=" SS_Print64u ",RedPackageID=%u",sHeader,
            un32SellerID,un64WoXinID,un32ShopID,un32RedPackageID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_RECEIVE_RED_PACKAGE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32ShopID   = un32ShopID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_un32RedPackageID=un32RedPackageID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallReceiveRedPackageIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallUseRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN SS_CHAR   const*pPrice,
    IN SS_CHAR   const*pOrderCode)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32PriceLen=strlen(pPrice);
    SS_UINT32  un32OrderCodeLen=strlen(pOrderCode);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =5;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16+un32PriceLen+1+un32OrderCodeLen+1;
    s_msg.m_un32MSGNumber=ITREG_MALL_USE_RED_PACKAGE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_WOXIN_ID,un64WoXinID);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_USE_RED_PACKAGE_IND_TYPE_PRICE,pPrice,un32PriceLen);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_USE_RED_PACKAGE_IND_ORDER_CODE,pOrderCode,un32OrderCodeLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_USE_RED_PACKAGE_IND message,%s,SellerID=%u,"
            ",WoXinID=" SS_Print64u ",ShopID=%u,Price=%s,OrderCode=%s",sHeader,un32SellerID,
            un64WoXinID,un32ShopID,pPrice,pOrderCode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_USE_RED_PACKAGE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUseRedPackageIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallLoadRedPackageUseRulesIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND_TYPE_WOXIN_ID,un64WoXinID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND message,%s,SellerID=%u,"
            ",WoXinID=" SS_Print64u ",ShopID=%u",sHeader,un32SellerID,un64WoXinID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_LOAD_RED_PACKAGE_USE_RULES_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadRedPackageUseRulesIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_MallAddOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pJson)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[10240] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32Len = strlen(pJson);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16+un32Len+3;
    s_msg.m_un32MSGNumber=ITREG_MALL_ADD_ORDER_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_ADD_ORDER_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_ADD_ORDER_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_ADD_ORDER_IND_TYPE_WOXIN_ID,un64WoXinID);
    SSMSG_SetBigMessageParam  (p,ITREG_MALL_ADD_ORDER_IND_TYPE_JSON,pJson,un32Len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_ADD_ORDER_IND message,%s,SellerRID=%u,ShopID=%u,"
            "Json=%s,WoXinID=" SS_Print64u,sHeader,un32SellerID,un32ShopID,pJson,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_ADD_ORDER_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAddOrderIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallUpdateOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pOrderCode,
    IN  SS_CHAR   const*pJson)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[10240] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32Len = strlen(pJson);
    SS_UINT32  un32OrderCodeLen= strlen(pOrderCode);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =5;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16+un32Len+3+un32OrderCodeLen+1;
    s_msg.m_un32MSGNumber=ITREG_MALL_UPDATE_ORDER_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_UPDATE_ORDER_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_UPDATE_ORDER_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_UPDATE_ORDER_IND_TYPE_WOXIN_ID,un64WoXinID);
    SSMSG_SetBigMessageParam  (p,ITREG_MALL_UPDATE_ORDER_IND_TYPE_JSON,pJson,un32Len);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_UPDATE_ORDER_IND_TYPE_ORDER_CODE,pOrderCode,un32OrderCodeLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_UPDATE_ORDER_IND message,%s,SellerRID=%u,ShopID=%u,"
            "Json=%s,OrderCode=%s,WoXinID=" SS_Print64u,sHeader,un32SellerID,un32ShopID,pJson,pOrderCode,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_UPDATE_ORDER_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallUpdateOrderIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallDelOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pOrderCode)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32Len = strlen(pOrderCode);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16+un32Len+1;
    s_msg.m_un32MSGNumber=ITREG_MALL_DEL_ORDER_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_DEL_ORDER_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_DEL_ORDER_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_DEL_ORDER_IND_TYPE_WOXIN_ID,un64WoXinID);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_DEL_ORDER_IND_TYPE_ORDER_CODE,pOrderCode,un32Len);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_DEL_ORDER_IND message,%s,SellerRID=%u,ShopID=%u,"
            "OrderCode=%s,WoXinID=" SS_Print64u,sHeader,un32SellerID,un32ShopID,pOrderCode,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_DEL_ORDER_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_time);
	SS_DEL_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_s_OrderCode);
	SS_ADD_str(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallDelOrderIND.m_s_OrderCode,pOrderCode);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallLoadOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
	IN  SS_UINT64 const un64WoXinID,
	IN SS_UINT32 const un32OffSet,
	IN SS_UINT32 const un32Limit)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =5;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+24;
    s_msg.m_un32MSGNumber=ITREG_MALL_LOAD_ORDER_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_IND_TYPE_SELLER_ID,un32SellerID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint64MessageParam(p,ITREG_MALL_LOAD_ORDER_IND_TYPE_WOXIN_ID,un64WoXinID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_IND_TYPE_OFF_SET,un32OffSet);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_LOAD_ORDER_IND_TYPE_LIMIT,un32Limit);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_LOAD_ORDER_IND message,%s,SellerRID=%u,"
            "ShopID=%u,OffSet=%u,Limit=%u,WoXinID=" SS_Print64u,sHeader,un32SellerID,un32ShopID,
			un32OffSet,un32Limit,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_LOAD_ORDER_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_un32SellerID = un32SellerID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallLoadOrderIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}



//////////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_MallGetAreaInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerRID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_AREA_INFO_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_AREA_INFO_IND_TYPE_SELLER_ID,un32SellerRID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_AREA_INFO_IND message,%s,SellerRID=%u",sHeader,un32SellerRID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_AREA_INFO_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_un32SellerID = un32SellerRID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallAreaInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetShopInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+8;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_SHOP_INFO_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SHOP_INFO_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SHOP_INFO_IND_TYPE_AREA_ID,un32AreaID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_SHOP_INFO_IND message,%s,SellerRID=%u,"
            "AreaID=%u",sHeader,un32SellerRID,un32AreaID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_SHOP_INFO_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_un32AreaID   = un32AreaID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallShopInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetAreaShopInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;

	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =1;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
	s_msg.m_un32MSGNumber=ITREG_MALL_GET_AREA_SHOP_INFO_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_AREA_SHOP_INFO_IND_TYPE_SELLER_ID,un32SellerID);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_AREA_SHOP_INFO_IND message,%s,Seller=%u",sHeader,un32SellerID);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_AREA_SHOP_INFO_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_un32SellerID = un32SellerID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetAreaShopInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}


SS_SHORT ITREG_MallGetHomeTopBigPictureIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetHomeTopBigPictureExIND(
	IN  SS_UINT64 const un64Source,
	IN  SS_UINT64 const un64Dest,
	IN  SS_UINT32 const un32SellerRID,
	IN  SS_UINT32 const un32AreaID,
	IN  SS_UINT32 const un32ShopID)
{
	SSMSG     s_msg;
	SS_CHAR sMSG[1024] = "";
	SS_CHAR   *p=NULL;

	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
	s_msg.m_un32MSGNumber=ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_SELLER_ID,un32SellerRID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_AREA_ID,un32AreaID);
	SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND message,%s,"
			"SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_HOME_TOP_BIG_PICTURE_EX_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeTopBigPictureExIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetHomeNavigationIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_HOME_NAVIGATION_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_HOME_NAVIGATION_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_HOME_NAVIGATION_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_HOME_NAVIGATION_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallHomeNavigationIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetGuessYouLikeRandomGoodsIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_GUESS_YOU_LIKE_RANDOM_GOODS_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGuessYouLikeRandomGoodsIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetCategoryListIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_CATEGORY_LIST_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_CATEGORY_LIST_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_CATEGORY_LIST_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_CATEGORY_LIST_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallCategoryListIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_PACKAGE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PACKAGE_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PACKAGE_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_PACKAGE_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_PACKAGE_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_PACKAGE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_ubFlag = SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32SellerID = un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32AreaID   = un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_un32ShopID   = un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallPackageIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetGoodsAllIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_GOODS_ALL_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_ALL_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_ALL_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_ALL_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_GOODS_ALL_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_GOODS_ALL_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_ubFlag=SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32SellerID=un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32AreaID  =un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_un32ShopID  =un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsAllIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallGetSpecialPropertiesCategoryListIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND_TYPE_SHOP_ID,un32ShopID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND message,%s,"
            "SellerRID=%u,AreaID=%u,ShopID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_ubFlag=SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32SellerID=un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32AreaID  =un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_un32ShopID  =un32ShopID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallSpecialPropertiesCategoryListIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_MallGetGoodsInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT32 const un32GoodsID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_MALL_GET_GOODS_INFO_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_INFO_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_INFO_IND_TYPE_AREA_ID,un32AreaID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_INFO_IND_TYPE_SHOP_ID,un32ShopID);
    SSMSG_Setint32MessageParam(p,ITREG_MALL_GET_GOODS_INFO_IND_TYPE_GOODS_ID,un32GoodsID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_GET_GOODS_INFO_IND message,%s,SellerRID=%u,"
            "AreaID=%u,ShopID=%u,GoodsID=%u",sHeader,un32SellerRID,un32AreaID,un32ShopID,un32GoodsID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_GET_GOODS_INFO_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_ubFlag=SS_TRUE;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32SellerID=un32SellerRID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32AreaID  =un32AreaID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32ShopID  =un32ShopID;
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_un32GoodsID =un32GoodsID;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutMallGetGoodsInfoIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_MallReportMyLocationIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_CHAR   const*pLatitude,
    IN  SS_CHAR   const*pLongitude)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;
    SS_UINT32  un32Latitudelen=strlen(pLatitude);
    SS_UINT32  un32Longitudelen=strlen(pLongitude);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+un32Latitudelen+1+un32Longitudelen+1;
    s_msg.m_un32MSGNumber=ITREG_MALL_REPORT_MY_LOCATION_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_SELLER_ID,un32SellerRID);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_LATITUDE,pLatitude,un32Latitudelen);
    SSMSG_SetMessageParamEx   (p,ITREG_MALL_REPORT_MY_LOCATION_IND_TYPE_LONGITUDE,pLongitude,un32Longitudelen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_MALL_REPORT_MY_LOCATION_IND message,%s,SellerRID=%u,"
            "Latitude=%s,Longitude=%s",sHeader,un32SellerRID,pLatitude,pLongitude);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_MALL_REPORT_MY_LOCATION_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
//////////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_UpdateUserInfo(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
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
    SS_USHORT  usnNameLen=0;
    SS_USHORT  usnVNameLen=0;
    SS_USHORT  usnPhoneLen=0;
    SS_USHORT  usnBirthdayLen=0;
    SS_USHORT  usnQQLen=0;
    SS_USHORT  usnCharacterSignatureLen=0;
    SS_USHORT  usnStreetLen=0;
    SS_USHORT  usnAreaLen=0;

    SSMSG     s_msg;
    SS_CHAR   sMSG[8192] = "";
    SS_CHAR   *p=NULL;

    usnNameLen    =(NULL==pName)?0:strlen(pName);
    usnVNameLen   =(NULL==pVName)?0:strlen(pVName);
    usnPhoneLen   =(NULL==pPhone)?0:strlen(pPhone);
    usnBirthdayLen=(NULL==pBirthday)?0:strlen(pBirthday);
    usnQQLen      =(NULL==pQQ)?0:strlen(pQQ);
    usnCharacterSignatureLen=(NULL==pCharacterSignature)?0:strlen(pCharacterSignature);
    usnStreetLen  =(NULL==pStreet)?0:strlen(pStreet);
    usnAreaLen    =(NULL==pArea)?0:strlen(pArea);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =9;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+1+usnNameLen+1+usnVNameLen+1+
        usnPhoneLen+1+usnBirthdayLen+1+usnQQLen+1+usnCharacterSignatureLen+1+usnStreetLen+1+usnAreaLen+1;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_USER_INFO;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam(p,ITREG_UPDATE_USER_INFO_TYPE_SEX,ubSex);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_NAME,pName,usnNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_VNAME,pVName,usnVNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_PHONE,pPhone,usnPhoneLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_BIRTHBAY,pBirthday,usnBirthdayLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_QQ,pQQ,usnQQLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_CHARACTER_SIGNATURE,pCharacterSignature,usnCharacterSignatureLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_STREET,pStreet,usnStreetLen);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_USER_INFO_TYPE_AREA,pArea,usnAreaLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_USER_INFO message,%s,Name=%s,VName=%s,"
            "Phone=%s,Sex=%u,Birthday=%s,QQ=%s,CharacterSignature=%s,Street=%s,Area=%s",sHeader,
            pName,pVName,pPhone,ubSex,pBirthday,pQQ,pCharacterSignature,pStreet,pArea);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_USER_INFO message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_BookUserAdd(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32RID,
    IN SS_CHAR  const*pRecordID,
    IN SS_CHAR  const*pName,
    IN SS_CHAR  const*pPhone,
    IN SS_UINT32 un32CreateTime,
    IN SS_UINT32 un32ModifyTime)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[2048] = "";
    SS_USHORT usnNameLen=0;
    SS_USHORT usnRecordIDLen=0;
    SS_USHORT usnPhoneLen=0;
    SS_CHAR   *p=NULL;

    if (NULL == pRecordID || NULL == pName || NULL == pPhone)
    {
        return  SS_ERR_PARAM;
    }

    usnRecordIDLen=strlen(pRecordID);
    usnNameLen    =strlen(pName);
    usnPhoneLen   =strlen(pPhone);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =6;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+12+
        usnPhoneLen+1+usnNameLen+1+usnRecordIDLen+1;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_ADD;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_BOOK_USER_ADD_TYPE_RECORD_ID,pRecordID,usnRecordIDLen);
    SSMSG_SetMessageParamEx(p,ITREG_BOOK_USER_ADD_TYPE_NAME,pName,usnNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_BOOK_USER_ADD_TYPE_PHONE,pPhone,usnPhoneLen);
    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_ADD_TYPE_CREATE_TIME,un32CreateTime);
    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_ADD_TYPE_MODIFY_TIME,un32ModifyTime);
    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_ADD_TYPE_RID,un32RID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_ADD message,%s,RecordID=%s,"
            "Name=%s,Phone=%s,CreateTime=%u,ModifyTime=%u,RID=%u",sHeader,pRecordID,
            pName,pPhone,un32CreateTime,un32ModifyTime,un32RID);
    }
#endif

/*	if (NULL == (p = (SS_CHAR *)SS_malloc(s_msg.m_un32Len)))
	{
		return  SS_ERR_MEMORY;
	}
	p[s_msg.m_un32Len] = 0;
	memcpy(p,sMSG,s_msg.m_un32Len);
	if(SS_SUCCESS != SS_LinkQueue_WriteData(&g_s_ITLibHandle.m_s_SlowlyTreatmentLinkQueue,(SS_VOID**)p))
	{
		SS_Log_Printf(SS_ERROR_LOG,"Add data to slowly treatment fail");
		SS_free(p);
		return  SS_ERR_MEMORY;
	}*/


    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_ADD message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT ITREG_BookUserDelete(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32RID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_DELETE;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_DELETE_TYPE_RID,un32RID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_DELETE message,%s,RID=%u",sHeader,un32RID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_DELETE message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_BookUserUpdateRemarkName(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 un32RID,
    IN SS_CHAR  const*pRemark)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_USHORT usnRemarkLen=0;
    SS_CHAR   *p=NULL;

    usnRemarkLen=strlen(pRemark);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+usnRemarkLen+1;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_UPDATE_REMARK_NAME;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_UPDATE_REMARK_NAME_TYPE_RID,un32RID);
    SSMSG_SetMessageParamEx(p,ITREG_BOOK_USER_UPDATE_REMARK_NAME_TYPE_REMARK_NAME,pRemark,usnRemarkLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_UPDATE_REMARK_NAME message,%s,"
            "Remark=%s,RID=%u",sHeader,pRemark,un32RID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_UPDATE_REMARK_NAME message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_BookUserUploadMyIcon(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pIcon,
    IN SS_UINT32 const un32IconSize)
{
    SSMSG     s_msg;
    SS_CHAR *pMSG = NULL;
    SS_CHAR   *p=NULL;

    if (NULL == (pMSG = (SS_CHAR *)SS_malloc(un32IconSize+SS_MSG_HEADER_LEN+100)))
    {
        return  SS_ERR_MEMORY;
    }
    memset(pMSG,0,un32IconSize+SS_MSG_HEADER_LEN+100);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+un32IconSize+3;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_UPLOAD_MY_ICON;

    SSMSG_CreateMessageHeader(pMSG,s_msg);
    p = pMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetBigMessageParam(p,ITREG_BOOK_USER_UPLOAD_MY_ICON_TYPE_IOCN,pIcon,un32IconSize);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_UPLOAD_MY_ICON message,%s,"
            "IconSize=%u",sHeader,un32IconSize);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,pMSG,s_msg.m_un32Len,0))
    {
        free(pMSG);
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_UPLOAD_MY_ICON message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    free(pMSG);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_BookUserFriendIconModifyCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_RID,un32RID);
    SSMSG_SetByteMessageParam (p,ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint64MessageParam(p,ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM_TYPE_WO_XIN_ID,un64WoXinID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM message,%s,"
            "Result=%u,RID=%u,WoXinID=" SS_Print64u,sHeader,ubResult,un32RID,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_FRIEND_ICON_MODIFY_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_UploadPhoneInfo(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_USHORT const usnSysType,
    IN SS_CHAR   const*pPhoneModel,
    IN SS_UINT32 const un32PhoneModelLen,
    IN SS_CHAR   const*pSysVersion,
    IN SS_UINT32 const un32SysVersionLen)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+2+un32PhoneModelLen+1+un32SysVersionLen+1;
    s_msg.m_un32MSGNumber=ITREG_UPLOAD_PHONE_INFO;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetShortMessageParam(p,ITREG_UPLOAD_PHONE_INFO_TYPE_SYS_TYPE   ,usnSysType);
    SSMSG_SetMessageParamEx   (p,ITREG_UPLOAD_PHONE_INFO_TYPE_PHONE_MODEL,pPhoneModel,un32PhoneModelLen);
    SSMSG_SetMessageParamEx   (p,ITREG_UPLOAD_PHONE_INFO_TYPE_SYS_VERSION,pSysVersion,un32SysVersionLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPLOAD_PHONE_INFO message,%s,"
            "SysType=%u,PhoneModel=%s,pSysVersion=%s",sHeader,usnSysType,pPhoneModel,pSysVersion);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPLOAD_PHONE_INFO message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_BookUserFriendModifyWoXinUserCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_RID,un32RID);
    SSMSG_SetByteMessageParam (p,ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint64MessageParam(p,ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM_TYPE_WO_XIN_ID,un64WoXinID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM message,%s,"
            "Result=%u,RID=%u,WoXinID=" SS_Print64u,sHeader,ubResult,un32RID,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_BookUserFriendModifyNameCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_CHAR   *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_RID,un32RID);
    SSMSG_SetByteMessageParam (p,ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint64MessageParam(p,ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM_TYPE_WO_XIN_ID,un64WoXinID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM message,%s,"
            "Result=%u,RID=%u,WoXinID=" SS_Print64u,sHeader,ubResult,un32RID,un64WoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_BOOK_USER_FRIEND_MODIFY_NAME_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_GetPhoneCheckCode(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pPhone)
{
    SSMSG     s_msg;
    SS_CHAR sMSG[1024] = "";
    SS_USHORT usnPhoneLen=0;
    SS_CHAR   *p=NULL;
    if (NULL == pPhone)
    {
        SS_Log_Printf(SS_ERROR_LOG,"Param error,Phone=%p",pPhone);
        return SS_ERR_PARAM;
    }
    if (0 == strlen(pPhone))
    {
        SS_Log_Printf(SS_ERROR_LOG,"Param Content,Phone=\"\"");
        return SS_ERR_PARAM;
    }

    usnPhoneLen=strlen(pPhone);
    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnPhoneLen+1;
    s_msg.m_un32MSGNumber=ITREG_GET_PHONE_CHECK_CODE;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_GET_PHONE_CHECK_CODE_TYPE_PHONE_NUMBER,pPhone,usnPhoneLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_GET_PHONE_CHECK_CODE message,%s,Phone=%s",sHeader,pPhone);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_GET_PHONE_CHECK_CODE message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT ITREG_Login(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_USHORT const usnPhoneModel,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword,
	IN SS_CHAR   const*pPhoneID)
{
    SS_CHAR sRealm[256] = "";
    SS_CHAR sNonce[256] = "";
    SS_CHAR sUri[256] = "";
    SS_CHAR sResponse[256] = "";
    SS_CHAR sCnonce[256] = "";
    SS_CHAR sNc[256] = "";
    SS_CHAR sQop[256] = "";
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;

    SS_USHORT usnPhone=0;
    SS_USHORT usnUserName=0;
    SS_USHORT usnRealm=0;
    SS_USHORT usnNonce=0;
    SS_USHORT usnUri=0;
    SS_USHORT usnResponse=0;
    SS_USHORT usnCnonce=0;
    SS_USHORT usnNc=0;
    SS_USHORT usnQop=0;
	SS_USHORT usnPhoneID=0;
	PIT_MSGTimeOutData s_pMSGTimeOutData=NULL;
    SS_CHAR  *p=NULL;

    if (NULL == pWoXinID||NULL == pPassword||NULL==pPhone||NULL==pPhoneID)
    {
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Password=%p,Phone=%p,PhoneID=%p",
			pWoXinID,pPassword,pPhone,pPhoneID);
        return SS_ERR_PARAM;
    }

    if (SS_SUCCESS != SS_GetPasswordContextString(pWoXinID,pPassword,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop))
    {
        return SS_FAILURE;
    }
	if (NULL == (s_pMSGTimeOutData = (PIT_MSGTimeOutData)malloc(sizeof(IT_MSGTimeOutData))))
	{
		return SS_ERR_MEMORY;
	}

    usnUserName=strlen(pWoXinID);
    usnRealm   =strlen(sRealm);
    usnNonce   =strlen(sNonce);
    usnUri     =strlen(sUri);
    usnResponse=strlen(sResponse);
    usnCnonce  =strlen(sCnonce);
    usnNc      =strlen(sNc);
    usnQop     =strlen(sQop);
    usnPhone   =strlen(pPhone);
	usnPhoneID =strlen(pPhoneID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =12;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+6+usnUserName+1+
        usnRealm+1+usnNonce+1+usnUri+1+usnResponse+1+usnCnonce+1+usnNc+1+usnQop+1+usnPhone+1+usnPhoneID+1;
    s_msg.m_un32MSGNumber=ITREG_LOGIN;
	s_pMSGTimeOutData->m_un32MSGID=ITREG_LOGIN;
	SS_GET_MILLISECONDS(s_pMSGTimeOutData->m_un64Time);

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_NO       ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_REALM    ,sRealm,usnRealm);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_NONCE    ,sNonce,usnNonce);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_URI      ,sUri,usnUri);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_RESPONSE ,sResponse,usnResponse);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_CNONCE   ,sCnonce,usnCnonce);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_NC       ,sNc,usnNc);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_QOP      ,sQop,usnQop);
    SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_PHOND    ,pPhone,usnPhone);
    SSMSG_Setint32MessageParam(p,ITREG_LOGIN_TYPE_ID,un32ID);
    SSMSG_SetShortMessageParam(p,ITREG_LOGIN_TYPE_PHONE_MODEL,usnPhoneModel);
	SSMSG_SetMessageParamEx(p,ITREG_LOGIN_TYPE_PHONE_ID,pPhoneID,usnPhoneID);


#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_LOGIN message,%s,Password=%s,UserName=%s,Realm=%s,"
            "Nonce=%s,Uri=%s,Response=%s,Cnonce=%s,Nc=%s,Qop=%s,Phone=%s,ID=%u,PhoneID=%s",sHeader,
			pPassword,pWoXinID,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop,pPhone,un32ID,pPhoneID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_LOGIN message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		SS_free(s_pMSGTimeOutData);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_free(s_pMSGTimeOutData);
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogin.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	//IT_MSG_TIME_OUT_CALL_BACK(s_pMSGTimeOutData);
    return  SS_SUCCESS;
}
SS_SHORT ITREG_Logout(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword)
{
    SS_CHAR sRealm[256] = "";
    SS_CHAR sNonce[256] = "";
    SS_CHAR sUri[256] = "";
    SS_CHAR sResponse[256] = "";
    SS_CHAR sCnonce[256] = "";
    SS_CHAR sNc[256] = "";
    SS_CHAR sQop[256] = "";
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;

    SS_USHORT usnPhone=0;
    SS_USHORT usnUserName=0;
    SS_USHORT usnRealm=0;
    SS_USHORT usnNonce=0;
    SS_USHORT usnUri=0;
    SS_USHORT usnResponse=0;
    SS_USHORT usnCnonce=0;
    SS_USHORT usnNc=0;
    SS_USHORT usnQop=0;

    SS_CHAR  *p=NULL;

    if (NULL == pWoXinID||NULL == pPassword||NULL==pPhone)
    {
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Password=%p,Phone=%p",pWoXinID,pPassword,pPhone);
        return SS_ERR_PARAM;
    }

    if (SS_SUCCESS != SS_GetPasswordContextString(pWoXinID,pPassword,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop))
    {
        return SS_FAILURE;
    }
    usnUserName=strlen(pWoXinID);
    usnRealm   =strlen(sRealm);
    usnNonce   =strlen(sNonce);
    usnUri     =strlen(sUri);
    usnResponse=strlen(sResponse);
    usnCnonce  =strlen(sCnonce);
    usnNc      =strlen(sNc);
    usnQop     =strlen(sQop);
    usnPhone   =strlen(pPhone);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =10;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+usnUserName+1+
        usnRealm+1+usnNonce+1+usnUri+1+usnResponse+1+usnCnonce+1+usnNc+1+usnQop+1+usnPhone+1;
    s_msg.m_un32MSGNumber=ITREG_LOGOUT;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_NO       ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_REALM    ,sRealm,usnRealm);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_NONCE    ,sNonce,usnNonce);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_URI      ,sUri,usnUri);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_RESPONSE ,sResponse,usnResponse);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_CNONCE   ,sCnonce,usnCnonce);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_NC       ,sNc,usnNc);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_QOP      ,sQop,usnQop);
    SSMSG_SetMessageParamEx(p,ITREG_LOGOUT_TYPE_PHOND    ,pPhone,usnPhone);
    SSMSG_Setint32MessageParam(p,ITREG_LOGOUT_TYPE_ID,un32ID);
    

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_LOGOUT message,%s,UserName=%s,Realm=%s,"
            "Nonce=%s,Uri=%s,Response=%s,Cnonce=%s,Nc=%s,Qop=%s,Phone=%s,ID=%u",sHeader,
            pWoXinID,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop,pPhone,un32ID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_LOGOUT message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogout.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutLogout.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_Register(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword,
    IN SS_CHAR   const*pCode)
{
    SS_CHAR sMSG[1024] = "";
    SSMSG       s_msg;
    
    SS_UINT32 usnPhoneLen=0;
    SS_UINT32 usnPasswordLen=0;
    SS_UINT32 usnCodeLen=0;

    SS_CHAR  *p=NULL;

    if (NULL == pPhone||NULL == pPassword||NULL==pCode)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,Phone=%p,Password=%p,Code=%p",pPhone,pPassword,pCode);
#endif
        return SS_ERR_PARAM;
    }
    if (0 == strlen(pPhone))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param Content,Phone=\"\"");
#endif
        return SS_ERR_PARAM;
    }
    if (0 == strlen(pPassword))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param Content,Password=\"\"");
#endif
        return SS_ERR_PARAM;
    }

    if (0 == strlen(pCode))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param Content,Code=\"\"");
#endif
        return SS_ERR_PARAM;
    }

    usnPhoneLen=strlen(pPhone);
    usnPasswordLen   =strlen(pPassword);
    usnCodeLen   =strlen(pCode);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+usnPhoneLen+1+
        usnPasswordLen+1+usnCodeLen+1;
    s_msg.m_un32MSGNumber=ITREG_REGISTER;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_REGISTER_TYPE_PHONE   ,pPhone,usnPhoneLen);
    SSMSG_SetMessageParamEx(p,ITREG_REGISTER_TYPE_PASSWORD,pPassword,usnPasswordLen);
    SSMSG_SetMessageParamEx(p,ITREG_REGISTER_TYPE_CODE    ,pCode,usnCodeLen);
    SSMSG_Setint32MessageParam(p,ITREG_REGISTER_TYPE_ID   ,un32ID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_REGISTER message,%s,ID=%u,Phone=%s,"
            "Password=%s,Code=%s",sHeader,un32ID,pPhone,pPassword,pCode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_REGISTER message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRegister.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutRegister.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_Unregister(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword)
{
    SS_CHAR sRealm[256] = "";
    SS_CHAR sNonce[256] = "";
    SS_CHAR sUri[256] = "";
    SS_CHAR sResponse[256] = "";
    SS_CHAR sCnonce[256] = "";
    SS_CHAR sNc[256] = "";
    SS_CHAR sQop[256] = "";
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;

    SS_USHORT usnPhone=0;
    SS_USHORT usnUserName=0;
    SS_USHORT usnRealm=0;
    SS_USHORT usnNonce=0;
    SS_USHORT usnUri=0;
    SS_USHORT usnResponse=0;
    SS_USHORT usnCnonce=0;
    SS_USHORT usnNc=0;
    SS_USHORT usnQop=0;

    SS_CHAR  *p=NULL;

    if (NULL == pWoXinID||NULL == pPassword||NULL==pPhone)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Password=%p,Phone=%p",pWoXinID,pPassword,pPhone);
#endif
        return SS_ERR_PARAM;
    }

    if (SS_SUCCESS != SS_GetPasswordContextString(pWoXinID,pPassword,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop))
    {
        return SS_FAILURE;
    }


    usnUserName=strlen(pWoXinID);
    usnRealm   =strlen(sRealm);
    usnNonce   =strlen(sNonce);
    usnUri     =strlen(sUri);
    usnResponse=strlen(sResponse);
    usnCnonce  =strlen(sCnonce);
    usnNc      =strlen(sNc);
    usnQop     =strlen(sQop);
    usnPhone   =strlen(pPhone);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =10;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+4+usnUserName+1+
        usnRealm+1+usnNonce+1+usnUri+1+usnResponse+1+usnCnonce+1+usnNc+1+usnQop+1+usnPhone+1;
    s_msg.m_un32MSGNumber=ITREG_UNREGISTER;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_NO       ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_REALM    ,sRealm,usnRealm);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_NONCE    ,sNonce,usnNonce);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_URI      ,sUri,usnUri);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_RESPONSE ,sResponse,usnResponse);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_CNONCE   ,sCnonce,usnCnonce);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_NC       ,sNc,usnNc);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_QOP      ,sQop,usnQop);
    SSMSG_SetMessageParamEx(p,ITREG_UNREGISTER_TYPE_PHOND    ,pPhone,usnPhone);
    SSMSG_Setint32MessageParam(p,ITREG_UNREGISTER_TYPE_ID    ,un32ID);
    


#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UNREGISTER message,%s,ID=%u,UserName=%s,"
            "Realm=%s,Nonce=%s,Uri=%s,Response=%s,Cnonce=%s,Nc=%s,Qop=%s,Phone=%s",sHeader,
            un32ID,pWoXinID,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop,pPhone);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UNREGISTER message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUnregister.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUnregister.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_UpdatePassword(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pOld,
    IN SS_CHAR   const*pNew)
{
    SS_CHAR sRealm[256] = "";
    SS_CHAR sNonce[256] = "";
    SS_CHAR sUri[256] = "";
    SS_CHAR sResponse[256] = "";
    SS_CHAR sCnonce[256] = "";
    SS_CHAR sNc[256] = "";
    SS_CHAR sQop[256] = "";
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;

    SS_USHORT usnUserName=0;
    SS_USHORT usnRealm=0;
    SS_USHORT usnNonce=0;
    SS_USHORT usnUri=0;
    SS_USHORT usnResponse=0;
    SS_USHORT usnCnonce=0;
    SS_USHORT usnNc=0;
    SS_USHORT usnQop=0;
    SS_USHORT usnNewLen=0;

    SS_CHAR  *p=NULL;

    if (NULL == pWoXinID||NULL == pOld||NULL == pNew)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Old=%p,New=%p",pWoXinID,pOld,pNew);
#endif
        return SS_ERR_PARAM;
    }
    if (SS_SUCCESS != SS_GetPasswordContextString(pWoXinID,pOld,sRealm,sNonce,sUri,sResponse,sCnonce,sNc,sQop))
    {
        return SS_FAILURE;
    }

    usnUserName=strlen(pWoXinID);
    usnRealm   =strlen(sRealm);
    usnNonce   =strlen(sNonce);
    usnUri     =strlen(sUri);
    usnResponse=strlen(sResponse);
    usnCnonce  =strlen(sCnonce);
    usnNc      =strlen(sNc);
    usnQop     =strlen(sQop);
    usnNewLen  =strlen(pNew);


    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =9;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1+
        usnRealm+1+usnNonce+1+usnUri+1+usnResponse+1+usnCnonce+1+usnNc+1+usnQop+1+usnNewLen+1;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_PASSWORD;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_NO       ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_REALM    ,sRealm,usnRealm);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_NONCE    ,sNonce,usnNonce);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_URI      ,sUri,usnUri);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_RESPONSE ,sResponse,usnResponse);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_CNONCE   ,sCnonce,usnCnonce);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_NC       ,sNc,usnNc);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_QOP      ,sQop,usnQop);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_PASSWORD_TYPE_NEW_PASSWORD,pNew,usnNewLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_PASSWORD message,%s,UserName=%s,Realm=%s,"
            "Nonce=%s,Uri=%s,Response=%s,Cnonce=%s,Nc=%s,Qop=%s,New=%s",sHeader,pWoXinID,sRealm,
            sNonce,sUri,sResponse,sCnonce,sNc,sQop,pNew);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_PASSWORD message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdatePassword.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdatePassword.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_FindPassword(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pSMSPhone)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnSMSLen=0;
    SS_USHORT usnPhoneLen=0;

    usnSMSLen=strlen(pSMSPhone);
    usnPhoneLen=strlen(pPhone);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnSMSLen+1+usnPhoneLen+1;
    s_msg.m_un32MSGNumber=ITREG_FIND_PASSWORD_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_FIND_PASSWORD_IND_TYPE_SMS_PHONE,pSMSPhone,usnSMSLen);
    SSMSG_SetMessageParamEx(p,ITREG_FIND_PASSWORD_IND_TYPE_PHONE    ,pPhone,usnPhoneLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_FIND_PASSWORD_IND message,%s,"
            "SMSPhone=%s,Phone=%s",sHeader,pSMSPhone,pPhone);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_FIND_PASSWORD_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutFindPassword.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutFindPassword.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_UpdateLoginState(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_BYTE   const ubStatus)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;

    if (NULL == pWoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p",pWoXinID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1+1;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_LOGIN_STATE;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_LOGIN_STATE_TYPE_NO   ,pWoXinID,usnUserName);
    SSMSG_SetByteMessageParam(p,ITREG_UPDATE_LOGIN_STATE_TYPE_STATUS,ubStatus);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_LOGIN_STATE message,%s,"
            "UserName=%s,Status=%u",sHeader,pWoXinID,ubStatus);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_LOGIN_STATE message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


SS_SHORT ITREG_ReportVersionIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pVersion)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;
    SS_USHORT usnVersion=0;

    if (NULL == pWoXinID||NULL == pVersion)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Version=%p",pWoXinID,pVersion);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);
    usnVersion =strlen(pVersion);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnVersion+1+usnUserName+1+4;
    s_msg.m_un32MSGNumber=ITREG_CUR_VERSION_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_CUR_VERSION_IND_TYPE_NO     ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_CUR_VERSION_IND_TYPE_VERSION,pVersion,usnVersion);
    SSMSG_Setint32MessageParam(p,ITREG_CUR_VERSION_IND_TYPE_ID,un32ID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CUR_VERSION_IND message,%s,"
            "UserName=%s,Version=%s,ID=%u",sHeader,pWoXinID,pVersion,un32ID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CUR_VERSION_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportVersionIND.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutReportVersionIND.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}

SS_SHORT ITREG_UpdateCPUID(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pID)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;
    SS_USHORT usnIDLen=0;

    if (NULL == pWoXinID||NULL == pID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,ID=%p",pWoXinID,pID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);
    usnIDLen=strlen(pID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1+usnIDLen+1;
    s_msg.m_un32MSGNumber=ITREG_UPDATE_CPUID_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_CPUID_IND_TYPE_NO   ,pWoXinID,usnUserName);
    SSMSG_SetMessageParamEx(p,ITREG_UPDATE_CPUID_IND_TYPE_CPUID,pID  ,usnIDLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_UPDATE_CPUID_IND message,%s,UserName=%s,ID=%s",sHeader,pWoXinID,pID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_UPDATE_CPUID_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutUpdateCPUID.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_GetBalance(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;

    if (NULL == pWoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p",pWoXinID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1;
    s_msg.m_un32MSGNumber=ITREG_GET_BALANCE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_GET_BALANCE_IND_TYPE_NO   ,pWoXinID,usnUserName);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_GET_BALANCE_IND message,%s,UserName=%s",sHeader,pWoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_GET_BALANCE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
	g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetBalance.m_ubFlag = SS_TRUE;
	SS_GET_SECONDS(g_s_ITLibHandle.m_s_TimeOut.m_s_TimeOutGetBalance.m_time);
	SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
    return  SS_SUCCESS;
}


SS_SHORT ITREG_GetUserData(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;

    if (NULL == pWoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p",pWoXinID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =1;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1;
    s_msg.m_un32MSGNumber=ITREG_GET_USER_INFO;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_GET_USER_INFO_TYPE_NO   ,pWoXinID,usnUserName);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_GET_USER_INFO message,%s,UserName=%s",sHeader,pWoXinID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_GET_USER_INFO message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
	g_s_ITLibHandle.m_ubGetUserDataFlag=SS_FALSE;
    return  SS_SUCCESS;
}

//////////////////////////////////////////////////////////////////////////



SS_SHORT   ITREG_SendCallInviteIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_UINT32 const un32WoXinIDlen,
    IN SS_CHAR const*pPhone,
    IN SS_UINT32 const un32Phonelen,
    IN SS_CHAR const*pCaller,
    IN SS_UINT32 const un32Callerlen,
    IN SS_CHAR const*pCallerName,
    IN SS_UINT32 const un32CallerNamelen,
    IN SS_CHAR const*pCalled,
    IN SS_UINT32 const un32Calledlen,
    IN SS_CHAR const*pCalledName,
    IN SS_UINT32 const un32CalledNamelen,
    IN SS_UINT64 const un64AudioCode,
    IN SS_UINT32 const un32VideoCode,
    IN SS_CHAR const*pAudioIP,
    IN SS_UINT32 const un32AudioIPlen,
    IN SS_CHAR const*pVideoIP,
    IN SS_UINT32 const un32VideoIPlen,
    IN SS_USHORT const usnAudioPort,
    IN SS_USHORT const usnVideoPort)
{
    SS_CHAR sMSG[4096] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =12;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16+un32Calledlen+1+
        un32Callerlen+1+un32Phonelen+1+un32WoXinIDlen+1+un32CallerNamelen+1+un32CalledNamelen+1+
        un32AudioIPlen+1+un32VideoIPlen+1;
    s_msg.m_un32MSGNumber=ITREG_CALL_INVITE_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_WO_XIN_ID    ,pWoXinID,un32WoXinIDlen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_PHONE        ,pPhone,un32Phonelen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_CALLER       ,pCaller,un32Callerlen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_CALLER_NAME  ,pCallerName,un32CallerNamelen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_CALLED       ,pCalled,un32Calledlen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_CALLED_NAME  ,pCalledName,un32CalledNamelen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_AUDIO_IP     ,pAudioIP,un32AudioIPlen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_INVITE_IND_TYPE_VIDEO_IP     ,pVideoIP,un32VideoIPlen);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_INVITE_IND_TYPE_VIDEO_CODE,un32VideoCode);
    SSMSG_Setint64MessageParam(p,ITREG_CALL_INVITE_IND_TYPE_AUDIO_CODE,un64AudioCode);
    SSMSG_SetShortMessageParam(p,ITREG_CALL_INVITE_IND_TYPE_AUDIO_PORT,usnAudioPort);
    SSMSG_SetShortMessageParam(p,ITREG_CALL_INVITE_IND_TYPE_VIDEO_PORT,usnVideoPort);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_INVITE_IND message,%s,WoXinID=%s,"
            "Phone=%s,Caller=%s,Called=%s,CallerName=%s,CalledName=%s,AudioIP=%s,VideoIP=%s,"
            "VideoCode=%x,AudioCode=" SS_Print64x ",AudioPort=%u,VideoPort=%u",sHeader,pWoXinID,
            pPhone,pCaller,pCalled,pCallerName,pCalledName,pAudioIP,pVideoIP,un32VideoCode,
            un64AudioCode,usnAudioPort,usnVideoPort);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_INVITE_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


SS_SHORT  ITREG_SendCall180IND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32Status,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_CALL_180_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_CALL_180_IND_TYPE_STATUS,un32Status);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_180_IND_TYPE_CALLER_MS_NODE,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_180_IND_TYPE_CALLER_IT_NODE,un32CallerITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_180_IND_TYPE_CALLER_REG_NODE,un32CallerREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_180_IND message,%s,Status=%u,"
            "CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,un32Status,
            un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_180_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_SendCallAlertingCFM  (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_ALERTING_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_ALERTING_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_ALERTING_CFM_TYPE_CALLED_MS_NODE,un32CalledMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_ALERTING_CFM_TYPE_CALLED_IT_NODE,un32CalledITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_ALERTING_CFM_TYPE_CALLED_REG_NODE,un32CalledREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_ALERTING_CFM message,%s,Result=%u,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_ALERTING_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT   ITREG_SendCall200IND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode,
    IN SS_UINT64 const un64AudioCode,
    IN SS_UINT32 const un32VideoCode,
    IN SS_CHAR const*pAudioIP,
    IN SS_UINT32 const un32AudioIPlen,
    IN SS_CHAR const*pVideoIP,
    IN SS_UINT32 const un32VideoIPlen,
    IN SS_USHORT const usnAudioPort,
    IN SS_USHORT const usnVideoPort)
{
    SS_CHAR sMSG[4096] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =9;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+28+un32AudioIPlen+1+un32VideoIPlen+1;
    s_msg.m_un32MSGNumber=ITREG_CALL_200_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx   (p,ITREG_CALL_200_IND_TYPE_AUDIO_IP  ,pAudioIP,un32AudioIPlen);
    SSMSG_SetMessageParamEx   (p,ITREG_CALL_200_IND_TYPE_VIDEO_IP  ,pVideoIP,un32VideoIPlen);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_200_IND_TYPE_VIDEO_CODE,un32VideoCode);
    SSMSG_Setint64MessageParam(p,ITREG_CALL_200_IND_TYPE_AUDIO_CODE,un64AudioCode);
    SSMSG_SetShortMessageParam(p,ITREG_CALL_200_IND_TYPE_AUDIO_PORT,usnAudioPort);
    SSMSG_SetShortMessageParam(p,ITREG_CALL_200_IND_TYPE_VIDEO_PORT,usnVideoPort);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_200_IND_TYPE_CALLER_MS_NODE,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_200_IND_TYPE_CALLER_REG_NODE,un32CallerREGNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_200_IND_TYPE_CALLER_IT_NODE,un32CallerITNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_200_IND message,%s,AudioIP=%s,VideoIP=%s,"
            "VideoCode=%x,AudioCode=" SS_Print64x ",AudioPort=%u,VideoPort=%u,CallerMSNode=%u,"
            "CallerREGNode=%u,CallerITNode=%u,",sHeader,pAudioIP,pVideoIP,un32VideoCode,
            un64AudioCode,usnAudioPort,usnVideoPort,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_200_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_SendCallConnectCFM   (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_CONNECT_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_CONNECT_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CONNECT_CFM_TYPE_CALLED_MS_NODE,un32CalledMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CONNECT_CFM_TYPE_CALLED_IT_NODE,un32CalledITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CONNECT_CFM_TYPE_CALLED_REG_NODE,un32CalledREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_CONNECT_CFM message,%s,Result=%u,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_CONNECT_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_SendCallDisconnectCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_DISCONNECT_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_DISCONNECT_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_MS_NODE,un32CalledMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_IT_NODE,un32CalledITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DISCONNECT_CFM_TYPE_CALLED_REG_NODE,un32CalledREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_DISCONNECT_CFM message,%s,Result=%u,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,un32CalledMSNode,un32CalledREGNode,un32CalledITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_DISCONNECT_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_SendCallMakeCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode,
    IN SS_BYTE   const ubResult)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_MAKE_CALL_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_MAKE_CALL_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_MS_NODE,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_IT_NODE,un32CallerITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_MAKE_CALL_CFM_TYPE_CALLER_REG_NODE,un32CallerREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_MAKE_CALL_CFM message,%s,Result=%u,CallerMSNode=%u,"
            "CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_MAKE_CALL_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_SendCallBeyIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CallMSNode,
    IN SS_UINT32 const un32CallREGNode,
    IN SS_UINT32 const un32CallITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_CALL_BEY_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_BEY_IND_TYPE_REASON_CODE,un32ReasonCode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_BEY_IND_TYPE_CALLER_MS_NODE,un32CallMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_BEY_IND_TYPE_CALLER_IT_NODE,un32CallITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_BEY_IND_TYPE_CALLER_REG_NODE,un32CallREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_BEY_IND message,%s,ReasonCode=%u,CallMSNode=%u,"
            "CallREGNode=%u,CallITNode=%u",sHeader,un32ReasonCode,un32CallMSNode,un32CallREGNode,un32CallITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_BEY_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_SendCallRepealIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_CALL_REPEAL_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_REPEAL_IND_TYPE_REASON_CODE  ,un32ReasonCode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REPEAL_IND_TYPE_CALL_MS_NODE ,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REPEAL_IND_TYPE_CALL_IT_NODE ,un32CallerITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REPEAL_IND_TYPE_CALL_REG_NODE,un32CallerREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_REPEAL_IND message,%s,ReasonCode=%u,"
            "CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,un32ReasonCode,
            un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_REPEAL_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_SendCallCancelCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_CANCEL_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_CANCEL_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CANCEL_CFM_TYPE_CALL_MS_NODE,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CANCEL_CFM_TYPE_CALL_IT_NODE,un32CallerITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_CANCEL_CFM_TYPE_CALL_REG_NODE,un32CallerREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_CANCEL_CFM message,%s,Result=%u,CallerMSNode=%u,"
            "CallerREGNode=%u,CallerITNode=%u",sHeader,ubResult,un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_MAKE_CALL_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


SS_SHORT  ITREG_SendCallDTMF_IND     (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubKey,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_DTMF_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_DTMF_IND_TYPE_KEY,ubKey);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DTMF_IND_TYPE_CALL_MS_NODE,un32CalledMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DTMF_IND_TYPE_CALL_IT_NODE,un32CalledITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_DTMF_IND_TYPE_CALL_REG_NODE,un32CalledREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_DTMF_IND message,%s,Key=%u,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u",sHeader,ubKey,un32CalledMSNode,un32CalledREGNode,
            un32CalledITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_DTMF_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}

SS_SHORT  ITREG_SendCallRejectIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+16;
    s_msg.m_un32MSGNumber=ITREG_CALL_REJECT_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_Setint32MessageParam(p,ITREG_CALL_REJECT_IND_TYPE_REASON_CODE,un32ReasonCode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REJECT_IND_TYPE_CALLER_MS_NODE,un32CallerMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REJECT_IND_TYPE_CALLER_IT_NODE,un32CallerITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REJECT_IND_TYPE_CALLER_REG_NODE,un32CallerREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_REJECT_IND message,%s,ReasonCode=%u,"
            "CallerMSNode=%u,CallerREGNode=%u,CallerITNode=%u",sHeader,un32ReasonCode,
            un32CallerMSNode,un32CallerREGNode,un32CallerITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_REJECT_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


SS_SHORT  ITREG_SendCallBackIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pUser,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled,
    IN SS_BYTE const ubCallMode,
    IN SS_BYTE const ubRateMode,
	IN SS_UINT32 const un32AppHandle)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnCallerLen=0;
    SS_USHORT usnCalledLen=0;
    SS_USHORT usnUserLen  =0;

    if (NULL == pCaller||NULL==pUser||NULL==pCalled)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,Caller=%p,Called=%p,User=%p",pCaller,pCalled,pUser);
#endif
        return SS_ERR_PARAM;
    }

    usnCallerLen=strlen(pCaller);
    usnCalledLen=strlen(pCalled);
    usnUserLen  =strlen(pUser);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =6;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnCallerLen+1+usnCalledLen+1+6+usnUserLen+1;
    s_msg.m_un32MSGNumber=ITREG_CALL_BACK_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_IND_TYPE_CALLER   ,pCaller,usnCallerLen);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_IND_TYPE_CALLED   ,pCalled,usnCalledLen);
    SSMSG_SetByteMessageParam(p,ITREG_CALL_BACK_IND_TYPE_CALL_MODE,ubCallMode);
    SSMSG_SetByteMessageParam(p,ITREG_CALL_BACK_IND_TYPE_RATE_MODE,ubRateMode);
    SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_IND_TYPE_USER     ,pUser,usnUserLen);
	SSMSG_Setint32MessageParam(p,ITREG_CALL_BACK_IND_TYPE_APP_HANDLE,un32AppHandle);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_BACK_IND message,%s,User=%s,Caller=%s,"
            "Called=%s,CallMode=%u,RateMode=%u,AppHandle=%u",sHeader,pUser,pCaller,pCalled,
			ubCallMode,ubRateMode,un32AppHandle);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_BACK_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_SendCallBackHookIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled)
{
	SS_CHAR sMSG[2048] = "";
	SSMSG       s_msg;
	SS_CHAR  *p=NULL;

	SS_USHORT usnCallerLen=0;
	SS_USHORT usnCalledLen=0;
	SS_USHORT usnUserLen  =0;

	usnCallerLen=strlen(pCaller);
	usnCalledLen=strlen(pCalled);
	usnUserLen  =strlen(pWoXinID);

	SSMSG_INIT(s_msg);
	s_msg.m_ubMSGCount   =3;
	s_msg.m_un64Source   =un64Source;
	s_msg.m_un64Dest     =un64Dest;
	s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnCallerLen+1+usnCalledLen+1+usnUserLen+1;
	s_msg.m_un32MSGNumber=ITREG_CALL_BACK_HOOK_IND;

	SSMSG_CreateMessageHeader(sMSG,s_msg);
	p = sMSG+SS_MSG_HEADER_LEN;

	SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_HOOK_IND_TYPE_CALLER,pCaller,usnCallerLen);
	SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_HOOK_IND_TYPE_CALLED,pCalled,usnCalledLen);
	SSMSG_SetMessageParamEx(p,ITREG_CALL_BACK_HOOK_IND_TYPE_WO_XIN_ID  ,pWoXinID,usnUserLen);

#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
		SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
		SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_BACK_HOOK_IND message,%s,User=%s,"
			"Caller=%s,Called=%s",sHeader,pWoXinID,pCaller,pCalled);
	}
#endif
	if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_BACK_HOOK_IND message to IT REG Server fail");
#endif
		IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
		return SS_ERR_NETWORK_DISCONNECT;
	}
	return  SS_SUCCESS;
}


SS_SHORT  ITREG_SendCallRefuseCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =4;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+13;
    s_msg.m_un32MSGNumber=ITREG_CALL_REFUSE_CFM;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetByteMessageParam (p,ITREG_CALL_REFUSE_CFM_TYPE_RESULT,ubResult);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REFUSE_CFM_TYPE_CALLED_MS_NODE,un32CalledMSNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REFUSE_CFM_TYPE_CALLED_IT_NODE,un32CalledITNode);
    SSMSG_Setint32MessageParam(p,ITREG_CALL_REFUSE_CFM_TYPE_CALLED_REG_NODE,un32CalledREGNode);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_CALL_REFUSE_CFM message,%s,Result=%u,CalledMSNode=%u,"
            "CalledREGNode=%u,CalledITNode=%u",sHeader,ubResult,un32CalledMSNode,un32CalledREGNode,
            un32CalledITNode);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_CALL_REFUSE_CFM message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////

SS_SHORT  ITREG_SendIMMessage(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pFriend,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubDirection,  //方向，接收或发送
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties)  //字体的特效
{
    SS_CHAR *pMSG=NULL;
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserNameLen=0;
    SS_USHORT usnFriendeLen=0;

    if (NULL == pWoXinID||NULL==pFriend||NULL==pContent)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Friend=%p,Content=%p",pWoXinID,pFriend,pContent);
#endif
        return SS_ERR_PARAM;
    }
    if (NULL == (pMSG = (SS_CHAR*)SS_malloc(un32ContentLen+2048)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return  SS_ERR_MEMORY;
    }
    memset(pMSG,0,un32ContentLen+2048);
    usnUserNameLen=strlen(pWoXinID);
    usnFriendeLen=strlen(pFriend);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =9;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserNameLen+1+6+
        usnFriendeLen+1+un32ContentLen+3;
    s_msg.m_un32MSGNumber=ITREG_IM_UPLINK_IND;

    SSMSG_CreateMessageHeader(pMSG,s_msg);
    p = pMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_UPLINK_IND_TYPE_USER       ,pWoXinID,usnUserNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_IM_UPLINK_IND_TYPE_FRIEND     ,pFriend,usnFriendeLen);
    SSMSG_SetBigMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_CONTENT   ,pContent,un32ContentLen);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_DIRECTION,ubDirection);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_LANGUAGE,ubLanguage);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_FONT_CODEC,ubFontCodec);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_FONT_STYLE,ubFontStyle);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_FONT_COLOR,ubFontColor);
    SSMSG_SetByteMessageParam(p,ITREG_IM_UPLINK_IND_TYPE_FONT_SPECIALTIES,ubFontSpecialties);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_UPLINK_IND message,%s,UserName=%s,Friend=%s,"
            "Content=%s,Direction=%u,Language=%u,FontCodec=%u,FontStyle=%u,FontColor=%u,"
            "FontSpecialties=%u",sHeader,pWoXinID,pFriend,pContent,ubDirection,ubLanguage,
            ubFontCodec,ubFontStyle,ubFontColor,ubFontSpecialties);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,pMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_UPLINK_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        SS_free(pMSG);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    SS_free(pMSG);
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_GetIMNewMessage (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_UINT32 const un32RID)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;

    if (NULL == pWoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p",pWoXinID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1+4;
    s_msg.m_un32MSGNumber=ITREG_IM_GET_NEW_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_GET_NEW_IND_TYPE_NO        ,pWoXinID,usnUserName);
    SSMSG_Setint32MessageParam(p,ITREG_IM_GET_NEW_IND_TYPE_CUR_RID,un32RID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_GET_NEW_IND message,%s,"
            "UserName=%s,RID=%u",sHeader,pWoXinID,un32RID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_GET_NEW_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_GetIMSynchronous(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_CHAR const*pDateTime)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserNameLen=0;
    SS_USHORT usnDateTimeLen=0;

    if (NULL == pWoXinID||NULL==pDateTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,pDateTime=%p",pWoXinID,pDateTime);
#endif
        return SS_ERR_PARAM;
    }

    usnUserNameLen=strlen(pWoXinID);
    usnDateTimeLen=strlen(pDateTime);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserNameLen+1+usnDateTimeLen+1;
    s_msg.m_un32MSGNumber=ITREG_IM_SYNCHRONOUS_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_SYNCHRONOUS_IND_TYPE_NO       ,pWoXinID ,usnUserNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_IM_SYNCHRONOUS_IND_TYPE_DATE_TIME,pDateTime,usnDateTimeLen);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_SYNCHRONOUS_IND message,%s,"
            "UserName=%s,DateTime=%s",sHeader,pWoXinID,pDateTime);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_SYNCHRONOUS_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}


SS_SHORT  ITREG_SendIMGroupMessage(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pMember,//成员
    IN SS_UINT32 const un32MemberCount,//成员数
    IN SS_UINT64 const un64GroupID,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties)  //字体的特效
{
    SS_CHAR *pMSG=NULL;
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserNameLen=0;
    SS_USHORT usnMemberLen=0;

    if (NULL == pWoXinID||NULL==pMember||NULL==pContent)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,Member=%p,Content=%p",pWoXinID,pMember,pContent);
#endif
        return SS_ERR_PARAM;
    }
    if (NULL == (pMSG = (SS_CHAR*)SS_malloc(un32ContentLen+2048)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return  SS_ERR_MEMORY;
    }
    memset(pMSG,0,un32ContentLen+2048);
    usnUserNameLen=strlen(pWoXinID);
    usnMemberLen=strlen(pMember);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =10;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserNameLen+1+17+
        usnMemberLen+1+un32ContentLen+3;
    s_msg.m_un32MSGNumber=ITREG_IM_GROUP_UPLINK_IND;

    SSMSG_CreateMessageHeader(pMSG,s_msg);
    p = pMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_USER       ,pWoXinID,usnUserNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_MEMBER     ,pMember,usnMemberLen);
    SSMSG_SetBigMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_CONTENT   ,pContent,un32ContentLen);
    SSMSG_Setint32MessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_MEMBER_COUNT,un32MemberCount);
    SSMSG_Setint64MessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_GROUP_ID,un64GroupID);
    SSMSG_SetByteMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_LANGUAGE,ubLanguage);
    SSMSG_SetByteMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_CODEC,ubFontCodec);
    SSMSG_SetByteMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_STYLE,ubFontStyle);
    SSMSG_SetByteMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_COLOR,ubFontColor);
    SSMSG_SetByteMessageParam(p,ITREG_IM_GROUP_UPLINK_IND_TYPE_FONT_SPECIALTIES,ubFontSpecialties);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_GROUP_UPLINK_IND message,%s,UserName=%s,Member=%s,"
            "Content=%s,Language=%u,FontCodec=%u,FontStyle=%u,FontColor=%u,FontSpecialties=%u,"
            "MemberCount=%u,GroupID="  SS_Print64u,sHeader,pWoXinID,pMember,pContent,ubLanguage,
            ubFontCodec,ubFontStyle,ubFontColor,ubFontSpecialties,un32MemberCount,un64GroupID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,pMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_GROUP_UPLINK_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        SS_free(pMSG);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    SS_free(pMSG);
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_GetIMGroupNewMessage (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_UINT64 const un64GroupID,
    IN SS_UINT32 const un32RID)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserName=0;

    if (NULL == pWoXinID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p",pWoXinID);
#endif
        return SS_ERR_PARAM;
    }

    usnUserName=strlen(pWoXinID);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =2;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserName+1+4;
    s_msg.m_un32MSGNumber=ITREG_IM_GROUP_GET_NEW_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_GROUP_GET_NEW_IND_TYPE_NO        ,pWoXinID,usnUserName);
    SSMSG_Setint32MessageParam(p,ITREG_IM_GROUP_GET_NEW_IND_TYPE_CUR_RID,un32RID);
    SSMSG_Setint64MessageParam(p,ITREG_IM_GROUP_GET_NEW_IND_TYPE_GROUP_ID,un64GroupID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_GROUP_GET_NEW_IND message,%s,"
            "UserName=%s,RID=%u,GroupID="  SS_Print64u,sHeader,pWoXinID,un32RID,un64GroupID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_GROUP_GET_NEW_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}
SS_SHORT  ITREG_GetIMGroupSynchronous(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_UINT64 const un64GroupID,
    IN SS_CHAR const*pDateTime)
{
    SS_CHAR sMSG[2048] = "";
    SSMSG       s_msg;
    SS_CHAR  *p=NULL;

    SS_USHORT usnUserNameLen=0;
    SS_USHORT usnDateTimeLen=0;

    if (NULL == pWoXinID||NULL==pDateTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Param error,WoXinID=%p,pDateTime=%p",pWoXinID,pDateTime);
#endif
        return SS_ERR_PARAM;
    }

    usnUserNameLen=strlen(pWoXinID);
    usnDateTimeLen=strlen(pDateTime);

    SSMSG_INIT(s_msg);
    s_msg.m_ubMSGCount   =3;
    s_msg.m_un64Source   =un64Source;
    s_msg.m_un64Dest     =un64Dest;
    s_msg.m_un32Len      =SS_MSG_HEADER_LEN+(s_msg.m_ubMSGCount*4)+usnUserNameLen+1+usnDateTimeLen+1+8;
    s_msg.m_un32MSGNumber=ITREG_IM_GROUP_SYNCHRONOUS_IND;

    SSMSG_CreateMessageHeader(sMSG,s_msg);
    p = sMSG+SS_MSG_HEADER_LEN;

    SSMSG_SetMessageParamEx(p,ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_NO       ,pWoXinID ,usnUserNameLen);
    SSMSG_SetMessageParamEx(p,ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_DATE_TIME,pDateTime,usnDateTimeLen);
    SSMSG_Setint64MessageParam(p,ITREG_IM_GROUP_SYNCHRONOUS_IND_TYPE_GROUP_ID,un64GroupID);

#ifdef  IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR   sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(sMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Send ITREG_IM_GROUP_SYNCHRONOUS_IND message,%s,UserName=%s,"
            "DateTime=%s,GroupID="  SS_Print64u,sHeader,pWoXinID,pDateTime,un64GroupID);
    }
#endif
    if (SS_SUCCESS != SS_TCP_Send(g_s_ITLibHandle.m_SignalScoket,sMSG,s_msg.m_un32Len,0))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Send ITREG_IM_GROUP_SYNCHRONOUS_IND message to IT REG Server fail");
#endif
        IT_UPDATE_LOGIN_STATUS(&g_s_ITLibHandle,IT_STATUS_REG_SERVER_DISCONNECT_OK);
        return SS_ERR_NETWORK_DISCONNECT;
    }
    return  SS_SUCCESS;
}



