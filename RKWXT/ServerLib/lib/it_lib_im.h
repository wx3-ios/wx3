// it_lib_im.h: interface for the CITLibIM class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_IM_H__E0955689_D221_4DCD_85F9_97E2F7035B6F__INCLUDED_)
#define AFX_IT_LIB_IM_H__E0955689_D221_4DCD_85F9_97E2F7035B6F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

SS_SHORT IM_UplinkIND          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_UplinkCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_DownLinkIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_DownLinkCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GetNewIND          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GetNewCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_SynchronousIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_SynchronousCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupUplinkIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupUplinkCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupDownLinkIND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupDownLinkCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupGetNewIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupGetNewCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupSynchronousIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IM_GroupSynchronousCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);


SS_SHORT Shop_GET_AREA_INFO_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_SHOP_INFO_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_HOME_TOP_BIG_PICTURE_CFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_HOME_TOP_BIG_PICTURE_EX_CFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_HOME_NAVIGATION_CFM                 (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_GUESS_YOU_LIKE_RANDOM_GOODS_CFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_CATEGORY_LIST_CFM                   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_SPECIAL_PROPERTIES_CATEGORY_LIST_CFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_GOODS_INFO_CFM                      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_REPORT_MY_LOCATION_CFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_PACKAGE_CFM                         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_GOODS_ALL_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_ADD_ORDER_CFM                           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_UPDATE_ORDER_CFM                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_DEL_ORDER_CFM                           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_LOAD_ORDER_CFM                          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_LOAD_RED_PACKAGE_CFM                    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_RECEIVE_RED_PACKAGE_CFM                 (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_USE_RED_PACKAGE_CFM                     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_LOAD_RED_PACKAGE_USE_RULES_CFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_PUSH_MESSAGE_IND                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_RED_PACKAGE_BALANCE_CFM             (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_SELLER_ABOUT_CFM                    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_SHOP_ABOUT_CFM                      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_PUSH_MESSAGE_INFO_CFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_AREA_SHOP_INFO_CFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_UNIONPAY_SERIAL_NUMBER_CFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_ORDER_REFUND_CFM                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_ORDER_CONFIRM_CFM                       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_ORDER_CANCEL_CFM                        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_LOAD_ORDER_SINGLE_CFM                   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_ORDER_REMINDERS_CFM                     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_SEND_PAY_RESULT_CFM                     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Shop_GET_ORDER_REFUND_INFO_CFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);



#endif // !defined(AFX_IT_LIB_IM_H__E0955689_D221_4DCD_85F9_97E2F7035B6F__INCLUDED_)
