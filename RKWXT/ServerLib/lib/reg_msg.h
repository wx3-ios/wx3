// reg_msg.h: interface for the CREGMSG class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REG_MSG_H__E76B244E_5773_43D3_AD11_F03D6DB9BE27__INCLUDED_)
#define AFX_REG_MSG_H__E76B244E_5773_43D3_AD11_F03D6DB9BE27__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


//////////////////////////////////////////////////////////////////////////
// Message create define
//////////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_MallGetOrderRefundInfoIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);

SS_SHORT ITREG_MallSendPayResultIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR   const*pOrderCode,
	IN SS_BYTE   const ubPayType,
	IN SS_BYTE   const ubResult);

SS_SHORT ITREG_MallLoadOrderSingleIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);

SS_SHORT ITREG_MallCancelOrderIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);
SS_SHORT ITREG_MallOrderRemindersIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);

SS_SHORT ITREG_MallGetOrderCodePayModeIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32Type,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);

SS_SHORT ITREG_MallOrderRefundIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode,
	IN SS_CHAR const *pGrounds);

SS_SHORT ITREG_MallOrderConfirmIND(
	IN SS_UINT64 const un64Source,
	IN SS_UINT64 const un64Dest,
	IN SS_UINT32 const un32SellerID,
	IN SS_UINT32 const un32ShopID,
	IN SS_CHAR const *pOrderCode);

SS_SHORT ITREG_SelectPhoneCheckCodeIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
	IN SS_CHAR    const*pPhone);

SS_SHORT ITREG_CallBackCDRCFM(
    IN  SS_UINT64  const un64Source,
    IN  SS_UINT64  const un64Dest,
	IN  SS_BYTE    const ubResult,
    IN  SS_UINT32  const un32RID);

SS_SHORT ITREG_GetCreditBalanceIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
    IN  SS_UINT32 const un32SellerID);
SS_SHORT ITREG_RechargeIND(
    IN SS_UINT64  const un64Source,
    IN SS_UINT64  const un64Dest,
    IN  SS_UINT32 const un32Type,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32Price,
    IN  SS_CHAR   const*pAccount,
    IN  SS_CHAR   const*pPassword);
SS_SHORT ITREG_GetRechargePreferentialRulesIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID);

SS_SHORT ITREG_UpdateBoundMobileNumberIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_CHAR   const*pPhone);

SS_SHORT ITREG_AboutIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr);
SS_SHORT ITREG_AboutHelpIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr);
SS_SHORT ITREG_AboutProtocolIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr);
SS_SHORT ITREG_AboutFeedBackIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_str    const*s_pStr,
    IN SS_CHAR const*pQQ,
    IN SS_CHAR const*pEMail,
    IN SS_CHAR const*pContent);

SS_SHORT ITREG_UpdateREGShopIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID);

SS_SHORT ITREG_ReportTokenIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN  SS_CHAR   const*pToken,
    IN  SS_CHAR   const*pUserID,
    IN  SS_UINT32 const un32CertsType,
    IN  SS_CHAR   const*pMachineID);

SS_SHORT ITREG_MallGetPushMessageInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_UINT32 const un32MSGType);
SS_SHORT ITREG_MallGetRedPackageBalanceIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID);
SS_SHORT ITREG_MallGetSellerAboutInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID);
SS_SHORT ITREG_MallGetShopAboutInfoIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT64 const un64WoXinID,
    IN SS_UINT32 const un32ShopID);


SS_SHORT  ITREG_MallPushMessageCFM  (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32SellerID,
    IN SS_UINT32 const un32ShopID,
    IN SS_UINT32 const un32MSGID,
    IN SS_USHORT const usnMSGType,
    IN SS_str    const*s_MSGArray);


SS_SHORT ITREG_MallLoadRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID);

SS_SHORT ITREG_MallReceiveRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_UINT32 const un32RedPackageID);

SS_SHORT ITREG_MallUseRedPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN SS_CHAR   const*pPrice,
    IN SS_CHAR   const*pOrderCode);

SS_SHORT ITREG_MallLoadRedPackageUseRulesIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID);



SS_SHORT ITREG_MallAddOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pJson);
SS_SHORT ITREG_MallUpdateOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pOrderCode,
    IN  SS_CHAR   const*pJson);
SS_SHORT ITREG_MallDelOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT64 const un64WoXinID,
    IN  SS_CHAR   const*pOrderCode);
SS_SHORT ITREG_MallLoadOrderIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID,
    IN  SS_UINT32 const un32ShopID,
	IN  SS_UINT64 const un64WoXinID,
	IN SS_UINT32 const un32OffSet,
	IN SS_UINT32 const un32Limit);

//////////////////////////////////////////////////////////////////////////

SS_SHORT ITREG_MallGetAreaInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID);
SS_SHORT ITREG_MallGetShopInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID);
SS_SHORT ITREG_MallGetAreaShopInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerID);
SS_SHORT ITREG_MallGetHomeTopBigPictureIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);
SS_SHORT ITREG_MallGetHomeTopBigPictureExIND(
	IN  SS_UINT64 const un64Source,
	IN  SS_UINT64 const un64Dest,
	IN  SS_UINT32 const un32SellerRID,
	IN  SS_UINT32 const un32AreaID,
	IN  SS_UINT32 const un32ShopID);
SS_SHORT ITREG_MallGetHomeNavigationIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);
SS_SHORT ITREG_MallGetGuessYouLikeRandomGoodsIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);
SS_SHORT ITREG_MallGetCategoryListIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);

SS_SHORT ITREG_MallGetPackageIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);

SS_SHORT ITREG_MallGetGoodsAllIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);


SS_SHORT ITREG_MallGetSpecialPropertiesCategoryListIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID);
SS_SHORT ITREG_MallGetGoodsInfoIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_UINT32 const un32AreaID,
    IN  SS_UINT32 const un32ShopID,
    IN  SS_UINT32 const un32GoodsID);
SS_SHORT ITREG_MallReportMyLocationIND(
    IN  SS_UINT64 const un64Source,
    IN  SS_UINT64 const un64Dest,
    IN  SS_UINT32 const un32SellerRID,
    IN  SS_CHAR   const*pLatitude,
    IN  SS_CHAR   const*pLongitude);


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
    IN  SS_CHAR const*pArea);


SS_SHORT ITREG_BookUserAdd(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32RID,
    IN SS_CHAR  const*pRecordID,
    IN SS_CHAR  const*pName,
    IN SS_CHAR  const*pPhone,
    IN SS_UINT32 un32CreateTime,
    IN SS_UINT32 un32ModifyTime);

SS_SHORT ITREG_BookUserDelete(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32RID);

SS_SHORT ITREG_BookUserUpdateRemarkName(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 un32RID,
    IN SS_CHAR  const*pRemark);

SS_SHORT ITREG_BookUserUploadMyIcon(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pIcon,
    IN SS_UINT32 const un32IconSize);

SS_SHORT ITREG_BookUserFriendIconModifyCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID);

SS_SHORT ITREG_UploadPhoneInfo(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_USHORT const usnSysType,
    IN SS_CHAR   const*pPhoneModel,
    IN SS_UINT32 const un32PhoneModelLen,
    IN SS_CHAR   const*pSysVersion,
    IN SS_UINT32 const un32SysVersionLen);

SS_SHORT ITREG_BookUserFriendModifyWoXinUserCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID);

SS_SHORT ITREG_BookUserFriendModifyNameCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32RID,
    IN SS_UINT64 const un64WoXinID);


//////////////////////////////////////////////////////////////////////////
SS_SHORT ITREG_GetPhoneCheckCode(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pPhone);

SS_SHORT ITREG_Login(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_USHORT const usnPhoneModel,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword,
	IN SS_CHAR   const*pPhoneID);

SS_SHORT ITREG_Logout(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword);

SS_SHORT ITREG_Register(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword,
    IN SS_CHAR   const*pCode);
SS_SHORT ITREG_Unregister(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pPassword);
SS_SHORT ITREG_UpdatePassword(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pOld,
    IN SS_CHAR   const*pNew);
SS_SHORT ITREG_FindPassword(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pPhone,
    IN SS_CHAR   const*pSMSPhone);

SS_SHORT ITREG_UpdateLoginState(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_BYTE   const ubStatus);

SS_SHORT ITREG_ReportVersionIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_UINT32 const un32ID,
    IN SS_CHAR   const*pVersion);

SS_SHORT ITREG_UpdateCPUID(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID,
    IN SS_CHAR   const*pID);

SS_SHORT ITREG_GetBalance(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID);

SS_SHORT ITREG_GetUserData(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pWoXinID);

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
    IN SS_USHORT const usnVideoPort);

SS_SHORT  ITREG_SendCall180IND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32Status,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode);

SS_SHORT  ITREG_SendCallAlertingCFM  (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode);

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
    IN SS_USHORT const usnVideoPort);


SS_SHORT  ITREG_SendCallConnectCFM   (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode);

SS_SHORT  ITREG_SendCallDisconnectCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode);

SS_SHORT  ITREG_SendCallMakeCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode,
    IN SS_BYTE   const ubResult);

SS_SHORT  ITREG_SendCallDTMF_IND     (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubKey,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode);

SS_SHORT  ITREG_SendCallBeyIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CallMSNode,
    IN SS_UINT32 const un32CallREGNode,
    IN SS_UINT32 const un32CallITNode);
//主叫撤销呼叫
SS_SHORT  ITREG_SendCallRepealIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CalldMSNode,
    IN SS_UINT32 const un32CalldREGNode,
    IN SS_UINT32 const un32CalldITNode);

SS_SHORT  ITREG_SendCallCancelCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode);

SS_SHORT  ITREG_SendCallRejectIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_UINT32 const un32ReasonCode,
    IN SS_UINT32 const un32CallerMSNode,
    IN SS_UINT32 const un32CallerREGNode,
    IN SS_UINT32 const un32CallerITNode);

SS_SHORT  ITREG_SendCallBackIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled,
    IN SS_BYTE const ubCallMode,
    IN SS_BYTE const ubRateMode,
	IN SS_UINT32 const un32AppHandle);
SS_SHORT  ITREG_SendCallBackHookIND(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pWoXinID,
    IN SS_CHAR const*pCaller,
    IN SS_CHAR const*pCalled);


SS_SHORT  ITREG_SendCallRefuseCFM(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_BYTE   const ubResult,
    IN SS_UINT32 const un32CalledMSNode,
    IN SS_UINT32 const un32CalledREGNode,
    IN SS_UINT32 const un32CalledITNode);

//////////////////////////////////////////////////////////////////////////

SS_SHORT  ITREG_SendIMMessage(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pUser,
    IN SS_CHAR   const*pFriend,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubDirection,  //方向，接收或发送
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties);  //字体的特效
SS_SHORT  ITREG_GetIMNewMessage (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pUser,
    IN SS_UINT32 const un32RID);
SS_SHORT  ITREG_GetIMSynchronous(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pUser,
    IN SS_CHAR const*pDateTime);


SS_SHORT  ITREG_SendIMGroupMessage(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR   const*pUser,
    IN SS_CHAR   const*pMember,//成员
    IN SS_UINT32 const un32MemberCount,//成员数
    IN SS_UINT64 const un64GroupID,
    IN SS_CHAR   const*pContent,//消息的内容
    IN SS_UINT32 const un32ContentLen,//内容长度
    IN  SS_BYTE  const ubLanguage,  //语言
    IN  SS_BYTE  const ubFontCodec, //字体的编码
    IN  SS_BYTE  const ubFontStyle, //字体的样式，比如：正方，斜体。。。。
    IN  SS_BYTE  const ubFontColor, //字体的颜色
    IN  SS_BYTE  const ubFontSpecialties);  //字体的特效
SS_SHORT  ITREG_GetIMGroupNewMessage (
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pUser,
    IN SS_UINT64 const un64GroupID,
    IN SS_UINT32 const un32RID);
SS_SHORT  ITREG_GetIMGroupSynchronous(
    IN SS_UINT64 const un64Source,
    IN SS_UINT64 const un64Dest,
    IN SS_CHAR const*pUser,
    IN SS_UINT64 const un64GroupID,
    IN SS_CHAR const*pDateTime);





//////////////////////////////////////////////////////////////////////////


#define  SS_MSG_HEART_BEAT         1
#define  SS_MSG_HEART_BEAT_CFM     2
#define  SS_MSG_INIT_COMM          3
#define  SS_MSG_INIT_COMM_CFM      4


#define  SS_MSG                    100


#define SS_MSG_HEADER_LEN   27  /*Message handle size*/

typedef struct SSMSG
{
    //消息长度
    SS_UINT32 m_un32Len;
    //加密方法
    SS_BYTE   m_ubEncrypt;
    //消息版本
    SS_BYTE  m_ubVersion;
    //消息编号
    SS_UINT32 m_un32MSGNumber;
    //源地址
    SS_UINT64 m_un64Source;
    //目标地址
    SS_UINT64 m_un64Dest;
    //参数总个数
    SS_BYTE   m_ubMSGCount;
}SSMSG,*PSSMSG;

#define  SSMSG_INIT(_SSMSG_)\
{\
    (_SSMSG_).m_un32Len=0;\
    (_SSMSG_).m_ubEncrypt=0;\
    (_SSMSG_).m_ubVersion=0;\
    (_SSMSG_).m_un32MSGNumber=0;\
    (_SSMSG_).m_un64Source=0;\
    (_SSMSG_).m_un64Dest=0;\
    (_SSMSG_).m_ubMSGCount=0;\
}

#define  SSMSG_INIT_P(_SSMSG_)\
{\
    (_SSMSG_)->m_un32Len=0;\
    (_SSMSG_)->m_ubEncrypt=0;\
    (_SSMSG_)->m_ubVersion=0;\
    (_SSMSG_)->m_un32MSGNumber=0;\
    (_SSMSG_)->m_un64Source=0;\
    (_SSMSG_)->m_un64Dest=0;\
    (_SSMSG_)->m_ubMSGCount=0;\
}


//添加消息长度
#define  SSMSG_SetLength(MSGBuf,un32Len) *(SS_UINT32*)(MSGBuf)     = htonl(un32Len)
//添加加密方法
#define  SSMSG_SetEncrypt(MSGBuf,ubEncrypt) *(SS_BYTE*)((MSGBuf)+4)  = ubEncrypt
//添加消息版本
#define  SSMSG_SetVersion(MSGBuf,ubVersion) *(SS_BYTE*)((MSGBuf)+5) = ubVersion

//添加消息编号
#define  SSMSG_SetMSGNumber(MSGBuf,un32MSGNumber) *(SS_UINT32*)((MSGBuf)+6) = htonl(un32MSGNumber)
//添加源地址
#define  SSMSG_SetSource(MSGBuf,un64Source) SS_un64ToBuf(un64Source,((MSGBuf)+10))
//添加目标地址
#define  SSMSG_SetDest(MSGBuf,un64Dest) SS_un64ToBuf(un64Dest,((MSGBuf)+18))
//添加参数总个数
#define  SSMSG_SetMSGCount(MSGBuf,ubMSGCount) *(SS_BYTE*)((MSGBuf)+26) = ubMSGCount


#define  SSMSG_CreateMessageHeader(MSGBuf,_SSMSG)\
{\
    SSMSG_SetLength(MSGBuf,_SSMSG.m_un32Len);\
    SSMSG_SetEncrypt(MSGBuf,_SSMSG.m_ubEncrypt);\
    SSMSG_SetVersion(MSGBuf,_SSMSG.m_ubVersion);\
    SSMSG_SetMSGNumber(MSGBuf,_SSMSG.m_un32MSGNumber);\
    SSMSG_SetSource(MSGBuf,_SSMSG.m_un64Source);\
    SSMSG_SetDest(MSGBuf,_SSMSG.m_un64Dest);\
    SSMSG_SetMSGCount(MSGBuf,_SSMSG.m_ubMSGCount);\
}

//获得消息长度
#define  SSMSG_GetLength(MSGBuf,un32Len)  un32Len = ntohl(*(SS_UINT32*)(MSGBuf))
#define  SSMSG_GetLengthEx(MSGBuf)  (ntohl(*(SS_UINT32*)(MSGBuf)))

//获得加密方法
#define  SSMSG_GetEncrypt(MSGBuf,ubEncrypt)  ubEncrypt = *(SS_BYTE*)((MSGBuf)+4)
#define  SSMSG_GetEncryptEx(MSGBuf)  (*(SS_BYTE*)((MSGBuf)+4))

//获得消息版本
#define  SSMSG_GetVersion(MSGBuf,ubVersion) ubVersion = (*(SS_BYTE*)((MSGBuf)+5))
#define  SSMSG_GetVersionEx(MSGBuf) (*(SS_BYTE*)((MSGBuf)+5))

//获得消息编号
#define  SSMSG_GetMSGNumber(MSGBuf,un32MSGNumber)    un32MSGNumber = ntohl(*(SS_UINT32*)((MSGBuf)+6))
#define  SSMSG_GetMSGNumberEx(MSGBuf)    (ntohl(*(SS_UINT32*)((MSGBuf)+6)))

//获得源地址
#define  SSMSG_GetSource(MSGBuf,un64Source)  SS_BufToun64((MSGBuf)+10,un64Source)
//#define  SSMSG_GetSourceEx(MSGBuf)  (*(SS_UINT64*)((MSGBuf)+10))


//获得目标地址
#define  SSMSG_GetDest(MSGBuf,un64Dest) SS_BufToun64((MSGBuf)+18,un64Dest)
//#define  SSMSG_GetDestEx(MSGBuf)      (*(SS_UINT64*)((MSGBuf)+18))


//获得参数总个数
#define  SSMSG_GetMSGCount(MSGBuf,usnMSGCount) usnMSGCount = (*(SS_BYTE*)((MSGBuf)+26))
#define  SSMSG_GetMSGCountEx(MSGBuf)   (*(SS_BYTE*)((MSGBuf)+26))



#define  SSMSG_DivideMessageHeader(MSGBuf,_SSMSG)\
{\
    SSMSG_GetLength(MSGBuf,_SSMSG.m_un32Len);\
    SSMSG_GetEncrypt(MSGBuf,_SSMSG.m_ubEncrypt);\
    SSMSG_GetVersion(MSGBuf,_SSMSG.m_ubVersion);\
    SSMSG_GetMSGNumber(MSGBuf,_SSMSG.m_un32MSGNumber);\
    SSMSG_GetSource(MSGBuf,_SSMSG.m_un64Source);\
    SSMSG_GetDest(MSGBuf,_SSMSG.m_un64Dest);\
    SSMSG_GetMSGCount(MSGBuf,_SSMSG.m_ubMSGCount);\
}

#define  SSMSG_DivideMessageHeaderToBuf(IN_MSGBuf,OUT_MSGBuf,OUT_MSGBufSize)\
{\
    SSMSG  SSMSGHander;\
    SSMSG_DivideMessageHeader(IN_MSGBuf,SSMSGHander);\
    SS_snprintf(OUT_MSGBuf,OUT_MSGBufSize,"(L=%x,E=%x,V=%x,N=%x,S=" SS_Print64x",D=" SS_Print64x",C=%x)",\
    SSMSGHander.m_un32Len,SSMSGHander.m_ubEncrypt,SSMSGHander.m_ubVersion,SSMSGHander.m_un32MSGNumber,\
    SSMSGHander.m_un64Source,SSMSGHander.m_un64Dest,SSMSGHander.m_ubMSGCount);\
}

#define  SSMSG_SetByteMessageParam(pPoint,usnType,ubValue)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons(1);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    *(SS_BYTE*)pPoint = ubValue;\
    pPoint++;\
}

#define  SSMSG_SetShortMessageParam(pPoint,usnType,usnValue)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons(2);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnValue);\
    pPoint+=2;\
}

#define  SSMSG_Setint32MessageParam(pPoint,usnType,n32Value)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons(4);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    *(SS_UINT32*)(pPoint)=htonl((SS_UINT32)n32Value);\
    pPoint+=4;\
}

#define  SSMSG_Setint64MessageParam(pPoint,usnType,n64Value)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons(8);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    SS_un64ToBuf(n64Value,pPoint);\
    pPoint+=8;\
}

#define  SSMSG_SetMessageParam(pPoint,usnType,psParmaValue,usnLen)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnLen);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    memcpy(pPoint,psParmaValue,usnLen); \
    pPoint+=(usnLen);\
}

#define  SSMSG_SetMessageParamEx(pPoint,usnType,psParmaValue,usnLen)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnLen);\
    pPoint+=2;\
    /*把第的参数的值放到BUFFER中*/\
    memcpy(pPoint,psParmaValue,usnLen); \
    pPoint+=(usnLen);\
    *pPoint=0;pPoint++;\
}

#define  SSMSG_SetBigMessageParam(pPoint,usnType,psParmaValue,un32Len)\
{\
    *(SS_USHORT*)(pPoint)=htons((SS_USHORT)usnType);\
    pPoint+=2;\
    /*给参数的地址偏移量赋值*/\
    *(SS_UINT32*)(pPoint)=htonl(un32Len);\
    pPoint+=4;\
    /*把第的参数的值放到BUFFER中*/\
    memcpy(pPoint,psParmaValue,un32Len); \
    pPoint+=un32Len;\
    *pPoint=0;pPoint++;\
}

#define  SSMSG_GetByteMessageParam(pPoint,usnType,ubValue)\
{\
    usnType   = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    SS_USHORT usnLen = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    ubValue = *(SS_BYTE*)pPoint;\
    pPoint+=usnLen;\
}

#define  SSMSG_GetShortMessageParam(pPoint,usnType,usnValue)\
{\
    usnType   = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    SS_USHORT usnLen = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    usnValue  = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=usnLen;\
}

#define  SSMSG_Getint32MessageParam(pPoint,usnType,n32Value)\
{\
    usnType   = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    SS_USHORT usnLen = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    n32Value  = ntohl(*(SS_UINT32*)(pPoint));\
    pPoint+=usnLen;\
}

#define  SSMSG_Getint64MessageParam(pPoint,usnType,un64Value)\
{\
    usnType   = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    SS_USHORT usnLen = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    SS_BufToun64(pPoint,un64Value);\
    pPoint+=usnLen;\
}

#define  SSMSG_GetMessageParam(pPoint,usnType,str)\
{\
    usnType   = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    str.m_len = ntohs(*(SS_USHORT*)(pPoint));\
    pPoint+=2;\
    str.m_s=NULL;\
    if (str.m_s = (SS_CHAR*)malloc(str.m_len+1))\
{\
    str.m_s[str.m_len] = 0;\
    memcpy(str.m_s,pPoint,str.m_len);\
}\
    pPoint+=str.m_len;\
}

#define  SSMSG_GetMessageParamEx(_pPoint_,_usnType_,_str_)\
{\
    _usnType_= ntohs(*(SS_USHORT*)(_pPoint_));\
    _pPoint_+=2;\
    _str_.m_len = ntohs(*(SS_USHORT*)(_pPoint_));\
    _pPoint_+=2;\
    _str_.m_s=(SS_CHAR*)_pPoint_;\
    _pPoint_+=(_str_.m_len+1);\
}

#define  SSMSG_GetBigMessageParam(_pPoint_,_usnType_,_str_)\
{\
    _usnType_= ntohs(*(SS_USHORT*)(_pPoint_));\
    _pPoint_+=2;\
    _str_.m_len = ntohl(*(SS_UINT32*)(_pPoint_));\
    _pPoint_+=4;\
    _str_.m_s=(SS_CHAR*)_pPoint_;\
    _pPoint_+=(_str_.m_len+1);\
}



#endif // !defined(AFX_REG_MSG_H__E76B244E_5773_43D3_AD11_F03D6DB9BE27__INCLUDED_)
