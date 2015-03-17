// it_lib_sms.cpp: implementation of the CITLibSMS class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_sms.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT SMS_NormalSendIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_NormalSendCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_NormalGroupSendIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_NormalGroupSendCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_NormalGetResultIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_NormalGetResultCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_BrtchSendIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_BrtchSendCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_BrtchGetResultIND (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT SMS_BrtchGetResultCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}

