// it_lib_sms.h: interface for the CITLibSMS class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_SMS_H__AEF3E85A_03A9_4DF3_8E89_072B4559121B__INCLUDED_)
#define AFX_IT_LIB_SMS_H__AEF3E85A_03A9_4DF3_8E89_072B4559121B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

//短信处理相关的处理
SS_SHORT SMS_NormalSendIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_NormalSendCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_NormalGroupSendIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_NormalGroupSendCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_NormalGetResultIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_NormalGetResultCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_BrtchSendIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_BrtchSendCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_BrtchGetResultIND (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT SMS_BrtchGetResultCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);

#endif // !defined(AFX_IT_LIB_SMS_H__AEF3E85A_03A9_4DF3_8E89_072B4559121B__INCLUDED_)
