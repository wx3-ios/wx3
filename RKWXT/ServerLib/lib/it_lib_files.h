// it_lib_files.h: interface for the CITLibFiles class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_FILES_H__8948270D_6711_49B6_95E1_B51AF4AEA0A8__INCLUDED_)
#define AFX_IT_LIB_FILES_H__8948270D_6711_49B6_95E1_B51AF4AEA0A8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

SS_SHORT File_OffLineUpIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineUpCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineDownIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineDownCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineGetIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineGetCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineDelete_IND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OffLineDelete_CFM  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineSendIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineSendCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineRecvIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineRecvCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineCancelSendIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineCancelSendCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineCancelRecvIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineCancelRecvCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_OnLineRecvResult   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupUpIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupUpCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupDownIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupDownCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupDeleteIND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupDeleteCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupGetIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT File_IMGroupGetCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);

#endif // !defined(AFX_IT_LIB_FILES_H__8948270D_6711_49B6_95E1_B51AF4AEA0A8__INCLUDED_)
