// it_lib_db.h: interface for the CITLibDB class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_DB_H__6D016745_F3E9_422D_8B3C_4FA5EB334CE8__INCLUDED_)
#define AFX_IT_LIB_DB_H__6D016745_F3E9_422D_8B3C_4FA5EB334CE8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



SS_SHORT      IT_DBSetLoginID(IN  SS_CHAR const*pLoginID);
SS_CHAR const*IT_DBGetLoginID(OUT SS_CHAR *pLoginID,IN SS_UINT32 const un32Size);
SS_SHORT      IT_DBSetLoginPassWord(IN  SS_CHAR const*pPassWord);
SS_CHAR const*IT_DBGetLoginPassWord(OUT SS_CHAR *pPassWord,IN SS_UINT32 const un32Size);
SS_SHORT      IT_DBSetPhoneNumber(IN  SS_CHAR const*pPhone);
SS_CHAR const*IT_DBGetPhoneNumber(OUT SS_CHAR *pPhone,IN SS_UINT32 const un32Size);
SS_SHORT      IT_DBSetSynchronousRemarkNameFlag(IN SS_UINT32 const un32RID,IN  SS_BYTE const ubFlag);
SS_BYTE       IT_DBGetSynchronousRemarkNameFlag(IN SS_UINT32 const un32RID);
SS_SHORT      IT_DBSetSynchronousFriendFlag    (IN SS_UINT32 const un32RID,IN  SS_BYTE const ubFlag);
SS_BYTE       IT_DBGetSynchronousFriendFlag    (IN SS_UINT32 const un32RID);
SS_SHORT      IT_DBSetFriendIcon               (IN  SS_UINT32 const un32RID,IN  SS_CHAR   const*pIconPath);
SS_SHORT      IT_DBDeleteFriend(IN SS_UINT32 const un32RID);
SS_SHORT      IT_DBSetLastBrowseShop          (IN  SS_UINT32 const un32SellerID,IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID);
//验证并上传同学录
SS_SHORT      IT_DBCheckUploadBook();



SS_SHORT  DB_ProcUpdateUserMessage      (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcUpdateRemarkNameMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcLoadFriendMessage      (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcLoadWoXinFriendMessage (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcLoadCallRecordMessage  (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcGetFriendIcon          (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcUploadMyIconMessage    (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcAddCallRecordMessage   (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcDelCallRecordMessage   (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcLoadUserInfoMessage    (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcUpdateUserInfoMessage  (IN PIT_Handle s_pHandle,IN SS_str const*s_pData);
SS_SHORT  DB_ProcGetLastBrowseShopMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData);


SS_SHORT  SS_ProcDBMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData);



//////////////////////////////////////////////////////////////////////////
//////////////////////////  Sqlite  //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
SS_SHORT IT_ConnectSqliteDB(IN PIT_Handle s_pHandle);
SS_SHORT IT_DisconnectSqliteDB(IN PIT_Handle s_pHandle);
SS_SHORT IT_GetConnectSqliteStatus(IN PIT_Handle s_pHandle);
SS_SHORT IT_SqliteExecute(IN  PIT_Handle s_pHandle,char const *  pSQL,PIT_SqliteRES* ppRecord);
SS_SHORT IT_ProcSqliteSQL(
    IN  PIT_Handle s_pHandle,
    IN  SS_CHAR const*pSQL,
    IN  SS_UINT32 un32,
    IN  SS_UINT64 un64,
    IN  SS_VOID  *ptr,
    IN  IT_DB_Record f_Record);//错误的原因

IT_SqliteROW IT_SqliteFetchRow (IN PIT_SqliteRES s_pResult);
SS_UINT32    IT_SqliteGetCount (IN PIT_SqliteRES s_pResult);
short        IT_SqliteMoveNext (IN PIT_SqliteRES s_pResult);
short        IT_SqliteMoveFirst(IN PIT_SqliteRES s_pResult);
short        IT_SqliteRelease  (IN PIT_SqliteRES *s_pList);

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////




//验证并更新数据库
SS_SHORT   IT_CheckUserDB(IN SS_BYTE  const ubLoadFlag);
//创建全新的数据库
SS_SHORT   IT_CreateUserDB();
//更新数据库
SS_SHORT   IT_UpdateUserDB();


extern SS_CHAR const *g_pAreaInfoTable;
extern SS_CHAR const *g_pShopInfoTable;
extern SS_CHAR const *g_pAreaShopInfoTable;
extern SS_CHAR const *g_pHomeTopBigPictureTable;
extern SS_CHAR const *g_pHomeTopBigPictureExTable;
extern SS_CHAR const *g_pHomeNavigationTable;
extern SS_CHAR const *g_pGuessYouLikeRandomGoodsTable;
extern SS_CHAR const *g_pCategoryListTable;
extern SS_CHAR const *g_pPackageTable;
extern SS_CHAR const *g_pGoodsAllTable;
extern SS_CHAR const *g_pSpecialPropertiesCategoryListTable;
extern SS_CHAR const *g_pGoodsInfoTable;

extern SS_CHAR const *g_pAboutTable;
extern SS_CHAR const *g_pAboutHelpTable;
extern SS_CHAR const *g_pAboutProtocolTable;
extern SS_CHAR const *g_pSellerAboutTable;
extern SS_CHAR const *g_pShopAboutTable;
extern SS_CHAR const *g_pRedPackageUseRulesTable;
extern SS_CHAR const *g_pDBTableCallRecord;
extern SS_CHAR const *g_pDBTableCallRecordIndex_Result;
extern SS_CHAR const *g_pRechargePreferentialRulesTable;
extern SS_CHAR const *g_pDBVersionTable;
extern SS_CHAR const *g_pDBTableIMGroup;
extern SS_CHAR const *g_pDBTableIMGroupMember;
extern SS_CHAR const *g_pDBTableUserSetting;
extern SS_CHAR const *g_pDBTableBookGroup;
extern SS_CHAR const *g_pDBTableBookGroupMember;
extern SS_CHAR const *g_pDBTableBook;
extern SS_CHAR const *g_pDBTableUserIm;
extern SS_CHAR const *g_pDBTableUserImIndexUser     ;
extern SS_CHAR const *g_pDBTableUserImIndexRead     ;
extern SS_CHAR const *g_pDBTableUserImIndexDirection;
extern SS_CHAR const *g_pDBTableUserImIndexRTime    ;
extern SS_CHAR const *g_pDBTableSysIm;
extern SS_CHAR const *g_pDBTableSysImIndexTitle     ;
extern SS_CHAR const *g_pDBTableSysImIndexRead      ;
extern SS_CHAR const *g_pDBTableSysImIndexDirection ;
extern SS_CHAR const *g_pDBTableSysImIndexRTime     ;
extern SS_CHAR const *g_pDBTableGroupIm;
extern SS_CHAR const *g_pDBTableGroupImIndexGroupID   ;
extern SS_CHAR const *g_pDBTableGroupImIndexRead      ;
extern SS_CHAR const *g_pDBTableGroupImIndexDirection ;
extern SS_CHAR const *g_pDBTableGroupImIndexRTime     ;

#endif // !defined(AFX_IT_LIB_DB_H__6D016745_F3E9_422D_8B3C_4FA5EB334CE8__INCLUDED_)
