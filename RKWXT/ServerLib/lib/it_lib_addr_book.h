// it_lib_addr_book.h: interface for the CITLibAddrBook class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_ADDR_BOOK_H__A0B2BE9F_B2E5_4CF8_B223_AFBC3C2FF88C__INCLUDED_)
#define AFX_IT_LIB_ADDR_BOOK_H__A0B2BE9F_B2E5_4CF8_B223_AFBC3C2FF88C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

SS_SHORT Book_UserFriendModefyNameIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserFriendModefyWoXinUserIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserFriendIconModefyIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserUpdateRemarkNameCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserUploadMyIconCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserAddCFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserDeleteCFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserUpdate                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_UserUpdateCFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_SynchronousIND              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_SynchronousCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupAdd                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupAdd_CFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupDelete               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupDeleteCFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdate               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdateCFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberAdd            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberAdd_CFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberDelete         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberDeleteCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberUpdate         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberUpdateCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupSynchronousIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupSynchronousCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberSynchronousIND (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberSynchronousCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdateCallBoard      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdateCallBoardCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupAddMemberIND         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupDeleteMemberIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupDeleteMemberALLIND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupAddIND               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupDeleteIND            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupNnmeUpdate           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupCallBoardUpdate      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupMemberExitIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdateMemberName     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT Book_IMGroupUpdateMemberCapaIND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);

#endif // !defined(AFX_IT_LIB_ADDR_BOOK_H__A0B2BE9F_B2E5_4CF8_B223_AFBC3C2FF88C__INCLUDED_)
