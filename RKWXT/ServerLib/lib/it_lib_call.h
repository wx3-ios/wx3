// it_lib_call.h: interface for the CITLibCall class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_CALL_H__47FB4B85_6C9B_4F20_B8B4_A52F52468564__INCLUDED_)
#define AFX_IT_LIB_CALL_H__47FB4B85_6C9B_4F20_B8B4_A52F52468564__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


SS_SHORT  Call_INVITE_CFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_ALERTING_IND    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_ALERTING_SDP_IND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_CONNECT_IND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_DISCONNECT_IND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_REPEAL_CFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_DTMF_CFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_MAKE_CALL_IND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_180_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_180_SDP_CFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_200_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_BEY_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_CANCEL_IND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_CALL_BACK_STATUS(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_RejectCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_RefuseIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_CallBackHookCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT  Call_CallBackCDRIND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);


SS_SHORT  SS_ProcRecvMessage(
    IN PIT_Handle s_pHandle,
    IN PIT_RecvData const s_pRecvData);


SS_SHORT  CallBack_GetRechargePreferentialRulesCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_ITAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_ITAboutHelpCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_ITAboutProtocolCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetSellerAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetShopAboutCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_LoadRedPackageUseRulesCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetAreaInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetShopInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetAreaShopInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetHomeTopBigPictureCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetHomeTopBigPictureExCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetHomeNavigationCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetGuessYouLikeRandomGoodsCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetCategoryListCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetPackageCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetGoodsAllCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetSpecialPropertiesCategoryListCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);
SS_SHORT  CallBack_GetGoodsInfoCFM(IN PIT_Handle s_pHandle,IN SS_CHAR const *pParam);

SS_SHORT  SS_ProcCallBackMessage(
    IN PIT_Handle s_pHandle,
    IN SS_CHAR const *pParam);

#endif // !defined(AFX_IT_LIB_CALL_H__47FB4B85_6C9B_4F20_B8B4_A52F52468564__INCLUDED_)
