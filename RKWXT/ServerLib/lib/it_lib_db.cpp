// it_lib_db.cpp: implementation of the CITLibDB class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_db.h"
#include "it_lib.h"
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT IT_DBSetLoginID(IN  SS_CHAR const*pLoginID)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET LoginID='%s'",pLoginID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_CHAR const*IT_DBGetLoginID(OUT SS_CHAR *pLoginID,IN SS_UINT32 const un32Size)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT LoginID FROM user_setting");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if(s_ROW[0])
                {
                    strncpy(pLoginID,s_ROW[0],un32Size);
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  pLoginID;
}

SS_SHORT IT_DBSetLoginPassWord(IN  SS_CHAR const*pPassWord)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET LoginPwd='%s'",pPassWord);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_CHAR const*IT_DBGetLoginPassWord(OUT SS_CHAR *pPassWord,IN SS_UINT32 const un32Size)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT LoginPwd FROM user_setting");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if(s_ROW[0])
                {
                    strncpy(pPassWord,s_ROW[0],un32Size);
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  pPassWord;
}

SS_SHORT      IT_DBSetPhoneNumber(IN  SS_CHAR const*pPhone)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET Phone='%s'",pPhone);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_SHORT      IT_DBSetLastBrowseShop          (IN  SS_UINT32 const un32SellerID,IN  SS_UINT32 const un32AreaID,IN  SS_UINT32 const un32ShopID)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET last_seller_id=%u,last_area_id=%u,last_shop_id=%u",un32SellerID,un32AreaID,un32ShopID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}

SS_CHAR const*IT_DBGetPhoneNumber(OUT SS_CHAR *pPhone,IN SS_UINT32 const un32Size)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT Phone FROM user_setting");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if(s_ROW[0])
                {
                    strncpy(pPhone,s_ROW[0],un32Size);
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  pPhone;
}


SS_SHORT      IT_DBSetSynchronousRemarkNameFlag(IN SS_UINT32 const un32RID,IN  SS_BYTE const ubFlag)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET synchronous_remark_name_flag=%u WHERE RID=%u",ubFlag,un32RID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_BYTE       IT_DBGetSynchronousRemarkNameFlag(IN SS_UINT32 const un32RID)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_BYTE ubFlag = SS_FALSE;
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT synchronous_remark_name_flag FROM book WHERE RID=%u",un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                ubFlag = SS_IfROWNumber(s_ROW[0]);
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  ubFlag;
}
SS_SHORT      IT_DBSetSynchronousFriendFlag    (IN SS_UINT32 const un32RID,IN  SS_BYTE const ubFlag)
{
    SS_CHAR  sSQL[512] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET synchronous_friend_flag=%u WHERE RID=%u",ubFlag,un32RID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_BYTE       IT_DBGetSynchronousFriendFlag    (IN SS_UINT32 const un32RID)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_BYTE ubFlag = SS_FALSE;
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT synchronous_friend_flag FROM book WHERE RID=%u",un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                ubFlag = SS_IfROWNumber(s_ROW[0]);
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  ubFlag;
}

SS_SHORT      IT_DBSetFriendIcon               (IN  SS_UINT32 const un32RID,IN  SS_CHAR   const*pIconPath)
{
    SS_CHAR  sSQL[4096] = "";
    if (NULL == pIconPath)
    {
        return SS_ERR_PARAM;
    }
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET icon_path='%s' WHERE RID=%u",pIconPath,un32RID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}
SS_SHORT      IT_DBDeleteFriend(IN SS_UINT32 const un32RID)
{
    SS_CHAR  sSQL[4096] = "";
    if (0 == un32RID)
    {
        return SS_ERR_PARAM;
    }
    SS_snprintf(sSQL,sizeof(sSQL),"DELETE FROM book WHERE RID=%u",un32RID);
    return  IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
}

SS_SHORT      IT_DBCheckUploadBook()
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[256] = "";
    SS_UINT32     un32RID=0;
    SS_UINT32     un32CreateTime=0;
    SS_UINT32     un32ModifyTime=0;
    SS_BYTE       ubsex=0;

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT Name,VName,Phone,sex,birthday,qq,character_signature,"
        "street,area FROM user_setting WHERE synchronous_update_flag=1");

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            s_ROW = IT_SqliteFetchRow(s_pRecord);
            ubsex = atoi(s_ROW[3]);
            ITREG_UpdateUserInfo(g_s_ITLibHandle.m_un64WoXinID,0,s_ROW[0],s_ROW[1],
                s_ROW[2],ubsex,s_ROW[4],s_ROW[5],s_ROW[6],s_ROW[7],s_ROW[8]);
        }
        IT_SqliteRelease(&s_pRecord);
    }

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,phone_record_id,create_time,"
        "modify_time,name,phone FROM book WHERE synchronous_friend_flag=0");

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            do 
            {
                s_ROW = IT_SqliteFetchRow(s_pRecord);
                un32RID = atol(s_ROW[0]);
                un32CreateTime = atol(s_ROW[2]);
                un32ModifyTime = atol(s_ROW[3]);
                ITREG_BookUserAdd(g_s_ITLibHandle.m_un64WoXinID,0,un32RID,s_ROW[1],
                    s_ROW[4],s_ROW[5],un32CreateTime,un32ModifyTime);

            } while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
        }
        IT_SqliteRelease(&s_pRecord);
    }

    return  SS_SUCCESS;
}
//////////////////////////////////////////////////////////////////////////

short IT_SqliteRelease(IN PIT_SqliteRES *s_pList)
{
    PIT_SqliteNode pListNode=NULL;
    IT_SqliteRES *pList = *s_pList;
    int n32Index=0;
    while(pList->m_pHead)
    {
        pListNode=pList->m_pHead;
        pList->m_pHead=pList->m_pHead->m_pNextNode;
        for(n32Index=0; n32Index<pListNode->m_n32CollectCount ; n32Index++)
        {
            sqlite3_free(pListNode->m_pCollectValue[n32Index]);
        }
        sqlite3_free((char*)pListNode->m_pCollectValue);
        sqlite3_free((char*)pListNode);
    }
    free(*s_pList);
    *s_pList=NULL;
    return SS_SUCCESS;
}
short   IT_SqliteMoveFirst(IN PIT_SqliteRES s_pResult)
{
    if(s_pResult->m_pHead==NULL)
    {
        return SS_ERR_NOTFOUND;
    }
    s_pResult->m_pCurrent=s_pResult->m_pHead;
    return  SS_SUCCESS;
}
short   IT_SqliteMoveNext(IN PIT_SqliteRES s_pResult)
{
    if(s_pResult->m_pCurrent==NULL)
    {
        return SS_ERR_NOTFOUND;
    }
    if(s_pResult->m_pCurrent->m_pNextNode==NULL)
    {
        return SS_ERR_NOTFOUND;
    }
    s_pResult->m_pCurrent=s_pResult->m_pCurrent->m_pNextNode;
    return  SS_SUCCESS;
}
SS_UINT32 IT_SqliteGetCount(IN PIT_SqliteRES s_pResult)
{
    return  s_pResult->m_n32Count;
}
//获得一行数据的集合
IT_SqliteROW   IT_SqliteFetchRow(IN PIT_SqliteRES s_pResult)
{
    if(NULL == s_pResult->m_pCurrent)
    {
        return NULL;
    }
    return (IT_SqliteROW)(s_pResult->m_pCurrent->m_pCollectValue);
}

short   IT_SqliteConnect(IN PIT_Handle s_pHandle,IN SS_CHAR const*pPath)
{
    SS_Mutex_Lock(&s_pHandle->m_s_Mutex);
    if (0 != sqlite3_open(pPath,&s_pHandle->m_s_SqliteDB.m_hDB))
    {
        /*if (s_pHandle->m_s_Config.m_f_FormatLog)
        {
            s_pHandle->m_s_Config.m_f_FormatLog(SS_ERROR_LOG,"DB Open faild,%p,code=%u_%s,"
                "Path=%s",s_pHandle,sqlite3_errcode(s_pHandle->m_s_SqliteDB.m_hDB),
                sqlite3_errmsg(s_pHandle->m_s_SqliteDB.m_hDB),pPath);
        }*/
        sqlite3_close(s_pHandle->m_s_SqliteDB.m_hDB);
        s_pHandle->m_s_SqliteDB.m_hDB = NULL;
        SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
        return  SS_ERR_ACTION;
    }
    SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
    return  SS_SUCCESS;
}
short   IT_SqliteDisconnect(IN  IN PIT_Handle s_pHandle)
{
    SS_Mutex_Lock(&s_pHandle->m_s_Mutex);
    if(s_pHandle->m_s_SqliteDB.m_hDB)
    {
        sqlite3_close(s_pHandle->m_s_SqliteDB.m_hDB);
    }
    s_pHandle->m_s_SqliteDB.m_hDB = NULL;
    SS_Mutex_UnLock(&s_pHandle->m_s_Mutex);
    return  SS_SUCCESS;
}

short    IT_SqliteAddNode(IT_SqliteRES* pList,PIT_SqliteNode pNode)
{
    if(pList->m_pHead==NULL)
    {
        pList->m_n32Count=1;
        pList->m_pHead=pNode;
        pList->m_pLast=pNode;
        pList->m_pCurrent=pList->m_pHead;
        pNode->m_pNextNode=NULL;
        pNode->m_pPreNode=NULL;
    }
    else
    {
        //当前节点的指针变换
        pNode->m_pNextNode=NULL;
        pNode->m_pPreNode=pList->m_pLast;
        //当前最后节点指针变换
        pList->m_pLast->m_pNextNode=pNode;
        //重设最后节点
        pList->m_pLast=pNode;
        (pList->m_n32Count)+=1;
    }
    return SS_SUCCESS;
}

int   IT_SqliteCallBack(
    void*   pParam,
    int     argc, 
    char**  argv,
    char**  azColName)
{
    if(NULL==pParam)
    {
        return 0;
    }
    int  n32Index=0;
    int  n32Size=0;
    IT_SqliteRES*s_pResult=(IT_SqliteRES*)pParam;
    IT_SqliteNode* pRecord=(IT_SqliteNode*)sqlite3_malloc(sizeof(IT_SqliteNode));
    if (NULL == pRecord)
    {
        return 0;
    }
    pRecord->m_n32CollectCount=argc;
    pRecord->m_pCollectValue=(char**)sqlite3_malloc(sizeof(char*)*(argc+1));
    for(n32Index=0;n32Index<argc;n32Index++)
    {
        if(argv[n32Index]!=NULL)
        {
            n32Size=strlen(argv[n32Index]);
            pRecord->m_pCollectValue[n32Index]=(char*)sqlite3_malloc(n32Size+2);
            pRecord->m_pCollectValue[n32Index][n32Size] = 0;
            memcpy(pRecord->m_pCollectValue[n32Index],argv[n32Index],n32Size);
        }
        else
        {
            n32Size=2;
            pRecord->m_pCollectValue[n32Index]=(char*)sqlite3_malloc(n32Size);
            pRecord->m_pCollectValue[n32Index][0] = 0;
            pRecord->m_pCollectValue[n32Index][1] = 0;
        }
    }
    IT_SqliteAddNode(s_pResult,pRecord);
    return 0;
}

SS_SHORT IT_SqliteExecute(IN  PIT_Handle s_pHandle,char const *  pSQL,PIT_SqliteRES* ppRecord)
{
    char *pError = NULL;
    PIT_SqliteRES s_pResult = NULL;
    if (NULL == (s_pResult = (PIT_SqliteRES)malloc(sizeof(IT_SqliteRES))))
    {
        return  SS_ERR_MEMORY;
    }
    memset(s_pResult,0,sizeof(IT_SqliteRES));
#ifdef IT_LIB_DEBUG
	if (SS_Log_If(SS_LOG_DB))
	{
		SS_Log_Printf(SS_DB_LOG,"DB %p,%s",s_pHandle,pSQL);
	}
#endif
    if(0 != sqlite3_exec(s_pHandle->m_s_SqliteDB.m_hDB,pSQL,IT_SqliteCallBack,(void*)s_pResult,&pError))
    {
        if (pError)
        {
#ifdef IT_LIB_DEBUG
            SS_Log_Printf(SS_ERROR_LOG,"DB %p,%s,%s",s_pHandle,pError,pSQL);
#endif
            //释放数据库错误
            sqlite3_free(pError);
        }
        return  SS_ERR_ACTION;
    }
    if (ppRecord)
    {
        *ppRecord = s_pResult;
        return  SS_SUCCESS;
    }
    IT_SqliteRelease(&s_pResult);
    return  SS_SUCCESS;
}
SS_SHORT IT_ProcSqliteSQL(
    IN  PIT_Handle s_pHandle,
    IN  SS_CHAR const*pSQL,
    IN  SS_UINT32 un32,
    IN  SS_UINT64 un64,
    IN  SS_VOID  *ptr,
    IN  IT_DB_Record f_Record)
{
    char *pError = NULL;
    PIT_SqliteRES s_pResult = NULL;
    if (NULL == (s_pResult = (PIT_SqliteRES)malloc(sizeof(IT_SqliteRES))))
    {
        if (f_Record)
        {
            f_Record(s_pHandle,NULL,ptr,un32,un64);
        }
        return  SS_ERR_MEMORY;
    }
    memset(s_pResult,0,sizeof(IT_SqliteRES));

    if(0 != sqlite3_exec(s_pHandle->m_s_SqliteDB.m_hDB,pSQL,IT_SqliteCallBack,(void*)s_pResult,&pError))
    {
        if (pError)
        {
            SS_Log_Printf(SS_ERROR_LOG,"DB %p,%s,%s",s_pHandle,pError,pSQL);
            //释放数据库错误
            sqlite3_free(pError);
        }
        if (f_Record)
        {
            f_Record(s_pHandle,NULL,ptr,un32,un64);
        }
        return  SS_ERR_ACTION;
    }
    if (f_Record)
    {
        f_Record(s_pHandle,s_pResult,ptr,un32,un64);
    }
    IT_SqliteRelease(&s_pResult);
    return  SS_SUCCESS;
}

SS_SHORT IT_ConnectSqliteDB(IN PIT_Handle s_pHandle)
{
    if(NULL==s_pHandle||NULL==s_pHandle->m_s_Config.m_s_DBFilesPath.m_s)
    {
        return SS_ERR_PARAM;
    }
#ifdef  _WIN32
    SS_CHAR  sBuf[8192] = "";
    IT_GB2312_2_UTF8(sBuf,4090,s_pHandle->m_s_Config.m_s_DBFilesPath.m_s,s_pHandle->m_s_Config.m_s_DBFilesPath.m_len);
    return  IT_SqliteConnect(s_pHandle,sBuf);
#else
    return  IT_SqliteConnect(s_pHandle,s_pHandle->m_s_Config.m_s_DBFilesPath.m_s);
#endif
}

SS_SHORT IT_DisconnectSqliteDB(IN PIT_Handle s_pHandle)
{
    return  IT_SqliteDisconnect(s_pHandle);
}
SS_SHORT IT_GetConnectSqliteStatus(IN PIT_Handle s_pHandle)
{
    return s_pHandle->m_s_SqliteDB.m_hDB?SS_TRUE:SS_FALSE;
}


SS_SHORT   IT_UpdateUserDB()
{
    SS_CHAR   sSQL[4096] ="";
    SS_UINT32 un32Len=0;
    SS_UINT32 un32Version=0;
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  ROW=NULL;

    if (SS_SUCCESS != IT_ConnectSqliteDB(&g_s_ITLibHandle))
    {
        SS_Log_Printf(SS_ERROR_LOG,"Connect db fail,%s",g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s);
        //IT_InitFail();
        return SS_ERR_ACTION;
    }

    un32Len=SS_snprintf(sSQL,sizeof(sSQL),"SELECT version FROM db_version");
    if (SS_SUCCESS != IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord))
    {
        SS_Log_Printf(SS_ERROR_LOG,"Update db fail,%s",sSQL);
        //IT_InitFail();
        return SS_ERR_ACTION;
    }
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            ROW = IT_SqliteFetchRow(s_pRecord);
            un32Version = SS_IfROWNumber(ROW[0]);
        }
        IT_SqliteRelease(&s_pRecord);
    }
    s_pRecord = NULL;
	if (un32Version<IT_LIB_DB_VERSION)
	{
		SS_CHAR    *Param[20];
		Param[0] = g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s;
		Param[1] = NULL;
		g_s_ITLibHandle.m_f_CallBack(IT_MSG_UPDATE_DB_IND,Param,1);
		SS_str  s_LoginID;
		SS_str  s_LoginPwd;
		SS_str  s_Name;
		SS_str  s_VName;
		SS_str  s_Phone;
		SS_str  s_sex;
		SS_str  s_birthday;
		SS_str  s_qq;
		SS_str  s_character_signature;
		SS_str  s_street;
		SS_str  s_area;
		SS_str  s_last_seller_id;
		SS_str  s_last_area_id;
		SS_str  s_last_shop_id;
		SS_str  s_DoMain1;
		SS_str  s_DoMain2;
		SS_str  s_DoMain3;
		SS_str  s_DoMain4;
		SS_str  s_DoMain5;
		SS_str  s_DoMain6;
		SS_str  s_icon_path;

		SS_INIT_str(s_LoginID);
		SS_INIT_str(s_LoginPwd);
		SS_INIT_str(s_Name);
		SS_INIT_str(s_VName);
		SS_INIT_str(s_Phone);
		SS_INIT_str(s_sex);
		SS_INIT_str(s_birthday);
		SS_INIT_str(s_qq);
		SS_INIT_str(s_character_signature);
		SS_INIT_str(s_street);
		SS_INIT_str(s_area);
		SS_INIT_str(s_last_seller_id);
		SS_INIT_str(s_last_area_id);
		SS_INIT_str(s_last_shop_id);
		SS_INIT_str(s_DoMain1);
		SS_INIT_str(s_DoMain2);
		SS_INIT_str(s_DoMain3);
		SS_INIT_str(s_DoMain4);
		SS_INIT_str(s_DoMain5);
		SS_INIT_str(s_DoMain6);
		SS_INIT_str(s_icon_path);


		un32Len=SS_snprintf(sSQL,sizeof(sSQL),"SELECT LoginID,LoginPwd,Name,VName,Phone,sex,birthday,qq,"
			"character_signature,street,area,last_seller_id,last_area_id,last_shop_id,DoMain1,DoMain2,"
			"DoMain3,DoMain4,DoMain5,DoMain6,icon_path FROM user_setting");


		if (SS_SUCCESS == IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord))
		{
			if (s_pRecord)
			{
				if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
				{
					ROW = IT_SqliteFetchRow(s_pRecord);
					SS_ADD_str(s_LoginID,  SS_IfROWString(ROW[0]));
					SS_ADD_str(s_LoginPwd,SS_IfROWString(ROW[1]));
					SS_ADD_str(s_Name,    SS_IfROWString(ROW[2]));
					SS_ADD_str(s_VName,   SS_IfROWString(ROW[3]));
					SS_ADD_str(s_Phone,   SS_IfROWString(ROW[4]));
					SS_ADD_str(s_sex,     SS_IfROWString(ROW[5]));
					SS_ADD_str(s_birthday,SS_IfROWString(ROW[6]));
					SS_ADD_str(s_qq,      SS_IfROWString(ROW[7]));
					SS_ADD_str(s_character_signature,SS_IfROWString(ROW[8]));
					SS_ADD_str(s_street,  SS_IfROWString(ROW[9]));
					SS_ADD_str(s_area,    SS_IfROWString(ROW[10]));
					SS_ADD_str(s_last_seller_id,SS_IfROWString(ROW[11]));
					SS_ADD_str(s_last_area_id,SS_IfROWString(ROW[12]));
					SS_ADD_str(s_last_shop_id,SS_IfROWString(ROW[13]));
					SS_ADD_str(s_DoMain1,     SS_IfROWString(ROW[14]));
					SS_ADD_str(s_DoMain2,     SS_IfROWString(ROW[15]));
					SS_ADD_str(s_DoMain3,     SS_IfROWString(ROW[16]));
					SS_ADD_str(s_DoMain4,     SS_IfROWString(ROW[17]));
					SS_ADD_str(s_DoMain5,     SS_IfROWString(ROW[18]));
					SS_ADD_str(s_DoMain6,     SS_IfROWString(ROW[19]));
					SS_ADD_str(s_icon_path,   SS_IfROWString(ROW[20]));
				}
				IT_SqliteRelease(&s_pRecord);
			}
		}
		s_pRecord = NULL;

		IT_DisconnectSqliteDB(&g_s_ITLibHandle);
		SS_Log_Printf(SS_STATUS_LOG,"update db files,%s",g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s);
		SS_DeleteFile(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s);
		IT_CheckUserDB(SS_FALSE);

		un32Len=SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET LoginID='%s',LoginPwd='%s',Name='%s',"
			"VName='%s',Phone='%s',sex=%s,birthday='%s',qq=%s,character_signature='%s',street='%s',area='%s',"
			"last_seller_id=%s,last_area_id=%s,last_shop_id=%s,DoMain1='%s',DoMain2='%s',DoMain3='%s',"
			"DoMain4='%s',DoMain5='%s',DoMain6='%s',icon_path='%s'",
			s_LoginID.m_s,s_LoginPwd.m_s,s_Name.m_s,s_VName.m_s,s_Phone.m_s,s_sex.m_s,s_birthday.m_s,s_qq.m_s,
			s_character_signature.m_s,s_street.m_s,s_area.m_s,s_last_seller_id.m_s,s_last_area_id.m_s,
			s_last_shop_id.m_s,s_DoMain1.m_s,s_DoMain2.m_s,s_DoMain3.m_s,s_DoMain4.m_s,s_DoMain5.m_s,s_DoMain6.m_s,
			s_icon_path.m_s);
		IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
		SS_DEL_str(s_LoginID);
		SS_DEL_str(s_LoginPwd);
		SS_DEL_str(s_Name);
		SS_DEL_str(s_VName);
		SS_DEL_str(s_Phone);
		SS_DEL_str(s_sex);
		SS_DEL_str(s_birthday);
		SS_DEL_str(s_qq);
		SS_DEL_str(s_character_signature);
		SS_DEL_str(s_street);
		SS_DEL_str(s_area);
		SS_DEL_str(s_last_seller_id);
		SS_DEL_str(s_last_area_id);
		SS_DEL_str(s_last_shop_id);
		SS_DEL_str(s_DoMain1);
		SS_DEL_str(s_DoMain2);
		SS_DEL_str(s_DoMain3);
		SS_DEL_str(s_DoMain4);
		SS_DEL_str(s_DoMain5);
		SS_DEL_str(s_DoMain6);
		SS_DEL_str(s_icon_path);
	}
    return  SS_SUCCESS;
}

SS_SHORT   IT_CreateUserDB()
{
    SS_CHAR   sSQL[4096] ="";
    SS_UINT32 un32Len=0;
    time_t    time=0;
	if (SS_SUCCESS != IT_ConnectSqliteDB(&g_s_ITLibHandle))
    {
#ifdef IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Connect db faild,%s",g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s);
#endif
        //IT_InitFail();
        return SS_ERR_ACTION;
    }
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBVersionTable,NULL);
	SS_GET_SECONDS(time);
    un32Len=SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO db_version(version,datetime) VALUES(%u,%u);",
		IT_LIB_DB_VERSION,time);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pRechargePreferentialRulesTable,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableIMGroup,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableIMGroupMember,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserSetting,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableBookGroup,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableBookGroupMember,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableBook,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserIm,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserImIndexUser     ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserImIndexRead     ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserImIndexDirection,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableUserImIndexRTime    ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableSysIm,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableSysImIndexTitle    ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableSysImIndexRead     ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableSysImIndexDirection,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableSysImIndexRTime    ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableGroupIm,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableGroupImIndexGroupID  ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableGroupImIndexRead     ,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableGroupImIndexDirection,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableGroupImIndexRTime    ,NULL);

    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableCallRecord,NULL);
    IT_SqliteExecute(&g_s_ITLibHandle,g_pDBTableCallRecordIndex_Result,NULL);

	IT_SqliteExecute(&g_s_ITLibHandle,g_pAboutTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pAboutHelpTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pAboutProtocolTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pSellerAboutTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pShopAboutTable,NULL);

	IT_SqliteExecute(&g_s_ITLibHandle,g_pAreaInfoTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pShopInfoTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pAreaShopInfoTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pRedPackageUseRulesTable,NULL);

	IT_SqliteExecute(&g_s_ITLibHandle,g_pHomeTopBigPictureTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pHomeTopBigPictureExTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pHomeNavigationTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pGuessYouLikeRandomGoodsTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pCategoryListTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pPackageTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pGoodsAllTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pSpecialPropertiesCategoryListTable,NULL);
	IT_SqliteExecute(&g_s_ITLibHandle,g_pGoodsInfoTable,NULL);


    memset(sSQL,0,sizeof(sSQL));
    un32Len=SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO user_setting(LoginID,LoginPwd,Phone) "
        "VALUES('0','000000','0');");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    return  SS_SUCCESS;
}
SS_SHORT   IT_CheckUserDB(IN SS_BYTE  const ubLoadFlag)
{
    FILE *fp=NULL;
    SS_SHORT  usn = 0;
    SS_CHAR   sBuf[1024] ="";
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"Check user sqlite DB");
#endif
    if (NULL == g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s)
    {
#ifdef IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"DB path is NULL");
#endif
        return  SS_ERR_PARAM;
    }
    if (NULL == (fp = fopen(g_s_ITLibHandle.m_s_Config.m_s_DBFilesPath.m_s,"rb")))
    {
        //没有这个库文件
        if (SS_SUCCESS != (usn = IT_CreateUserDB()))
        {
            return  usn;
        }
        //加载用户的信息
        IT_GetUserData(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s);
    }
    else
    {
        fclose(fp);
        if (SS_SUCCESS != (usn = IT_UpdateUserDB()))
        {
            return  usn;
        }
    }
	IT_DBGetLoginID(sBuf,sizeof(sBuf));
	if ('0' != sBuf[0])
	{
		SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
		SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserNo,sBuf);
		SS_aToun64(sBuf,g_s_ITLibHandle.m_un64WoXinID);
		SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
	}
    if (ubLoadFlag)
    {
        memset(sBuf,0,sizeof(sBuf));
        IT_DBGetPhoneNumber(sBuf,sizeof(sBuf));
        if ('0' != sBuf[0])
        {
            SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
            SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_Phone,sBuf);
            SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        }
        memset(sBuf,0,sizeof(sBuf));
        IT_DBGetLoginPassWord(sBuf,sizeof(sBuf));
        if ('0' != sBuf[0])
        {
            SS_Mutex_Lock(&g_s_ITLibHandle.m_s_Mutex);
            SS_ADD_str(g_s_ITLibHandle.m_s_Config.m_s_UserPassword,sBuf);
            SS_Mutex_UnLock(&g_s_ITLibHandle.m_s_Mutex);
        }
    }
    g_s_ITLibHandle.m_un32DB_BookRID=1;
    memset(sBuf,0,sizeof(sBuf));
    SS_snprintf(sBuf,sizeof(sBuf),"SELECT MAX(RID) FROM book");
    IT_SqliteExecute(&g_s_ITLibHandle,sBuf,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                g_s_ITLibHandle.m_un32DB_BookRID= SS_IfROWNumber(s_ROW[0])+1;
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }


    g_s_ITLibHandle.m_un32DB_CallRecordRID=1;
    memset(sBuf,0,sizeof(sBuf));
    SS_snprintf(sBuf,sizeof(sBuf),"SELECT MAX(RID) FROM CallRecord");
    IT_SqliteExecute(&g_s_ITLibHandle,sBuf,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                g_s_ITLibHandle.m_un32DB_CallRecordRID= SS_IfROWNumber(s_ROW[0])+1;
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }


    //memset(sBuf,0,sizeof(sBuf));
    //SS_snprintf(sBuf,sizeof(sBuf),"UPDATE book SET icon_path='a:\\a.icon' WHERE RID=2");
    //IT_SqliteExecute(&g_s_ITLibHandle,sBuf,NULL);

    return  SS_SUCCESS;
}

SS_SHORT  DB_ProcUpdateUserMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_UINT32     un32RID=0;
    SS_CHAR  *p = (SS_CHAR  *)s_pData->m_s;
    SS_CHAR  const*pRecordID=s_pData->m_s;
    SS_CHAR  const*pName=NULL;
    SS_CHAR  const*pPhone=NULL;
    SS_UINT32 un32CreateTime=0;
    SS_UINT32 un32ModifyTime=0;

    while('\r' != *p){p++;}*p=0;p++;
    pName = p;
    while('\r' != *p){p++;}*p=0;p++;
    pPhone = p;
    while('\r' != *p){p++;}*p=0;p++;
    un32CreateTime = atol(p);
    while('\r' != *p){p++;}*p=0;p++;
    un32ModifyTime = atol(p);

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,phone_name FROM book WHERE phone_record_id='%s' "
		"AND phone='%s'",pRecordID,pPhone);

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if(s_ROW[1])
                {
                    if (0 == strcmp(pName,s_ROW[1]))
                    {
                        IT_SqliteRelease(&s_pRecord);
                        return   SS_SUCCESS;
                    }
					else
					{
						un32RID = SS_IfROWNumber(s_ROW[0]);
						SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET phone_name='%s' "
							"WHERE RID=%u",pName,un32RID);
					}
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
	if (0 == un32RID)
	{
		un32RID=g_s_ITLibHandle.m_un32DB_BookRID++;
		SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO book(RID,phone_record_id,create_time,"
			"modify_time,phone_name,phone) VALUES(%u,'%s',%u,%u,'%s','%s')",un32RID,pRecordID,
			un32CreateTime,un32ModifyTime,pName,pPhone);
	}
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    IT_DBSetSynchronousFriendFlag(un32RID,SS_FALSE);
    return   ITREG_BookUserAdd(g_s_ITLibHandle.m_un64WoXinID,0,un32RID,pRecordID,
        pName,pPhone,un32CreateTime,un32ModifyTime);
}
SS_SHORT  DB_ProcUpdateRemarkNameMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR   const*pRemark=NULL;
    SS_CHAR  *p = (SS_CHAR  *)s_pData->m_s;
    SS_UINT32 const un32RID = atol(s_pData->m_s);
    while('\r' != *p){p++;}*p=0;p++;
    pRemark = p;
    while('\r' != *p){p++;}*p=0;p++;
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET remark_name='%s' WHERE RID=%u",pRemark,un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    IT_DBSetSynchronousRemarkNameFlag(un32RID,SS_FALSE);
    return  ITREG_BookUserUpdateRemarkName(g_s_ITLibHandle.m_un64WoXinID,0,un32RID,pRemark);
}
SS_SHORT  DB_ProcLoadFriendMessage      (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  *Param[20];
    Param[0] = "BEGIN";
    Param[1] = NULL;
    Param[2] = NULL;
    Param[3] = NULL;
    Param[4] = NULL;
    Param[5] = NULL;
    Param[6] = NULL;
    Param[7] = NULL;
    Param[8] = NULL;
    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_FRIEND_CFM,Param,1);
#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_Log_Printf(SS_TRACE_LOG,"BEGIN");
	}
#endif

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,phone,phone_name,remark_name,phone_record_id,wo_xin_id,icon_path FROM book");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
#ifdef  IT_LIB_DEBUG
		if(SS_Log_If(SS_LOG_TRACE))
		{
			SS_Log_Printf(SS_TRACE_LOG,"s_pRecord=%p",s_pRecord);
		}
#endif
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
#ifdef  IT_LIB_DEBUG
			if(SS_Log_If(SS_LOG_TRACE))
			{
				SS_Log_Printf(SS_TRACE_LOG,"IT_SqliteMoveFirst is OK");
			}
#endif
            do 
            {
                if (s_ROW = IT_SqliteFetchRow(s_pRecord))
                {
					memset(sSQL,0,sizeof(sSQL));
					SS_snprintf(sSQL,sizeof(sSQL),"%s%s",g_s_ITLibHandle.m_s_IconPath.m_s,SS_IfROWString(s_ROW[6]));
					Param[0] = s_ROW[0];
					Param[1] = s_ROW[1];
					Param[2] = s_ROW[2];
					Param[3] = s_ROW[3];
					Param[4] = s_ROW[4];
					Param[5] = s_ROW[5];
					Param[6] = sSQL;
					Param[7] = NULL;
                    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_FRIEND_CFM,Param,7);
                }
            } while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
        }
#ifdef  IT_LIB_DEBUG
		else
		{
			if(SS_Log_If(SS_LOG_TRACE))
			{
				SS_Log_Printf(SS_TRACE_LOG,"IT_SqliteMoveFirst is fail");
			}
		}
#endif
        IT_SqliteRelease(&s_pRecord);
    }
    Param[0] = "END";
	Param[1] = NULL;
	Param[2] = NULL;
	Param[3] = NULL;
	Param[4] = NULL;
	Param[5] = NULL;
	Param[6] = NULL;
	Param[7] = NULL;
	Param[8] = NULL;
    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_FRIEND_CFM,Param,1);
#ifdef  IT_LIB_DEBUG
	if(SS_Log_If(SS_LOG_TRACE))
	{
		SS_Log_Printf(SS_TRACE_LOG,"END");
	}
#endif
    return  SS_SUCCESS;
}

SS_SHORT  DB_ProcLoadWoXinFriendMessage (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  *Param[20];
    Param[0] = "BEGIN";
    Param[1] = NULL;
    Param[2] = NULL;
    Param[3] = NULL;
    Param[4] = NULL;
    Param[5] = NULL;
    Param[6] = NULL;
    Param[7] = NULL;
    Param[8] = NULL;

    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_WOXIN_FRIEND_CFM,Param,1);

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,phone,name,remark_name,phone_record_id,wo_xin_id,icon_path FROM book");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            do 
            {
                if (s_ROW = IT_SqliteFetchRow(s_pRecord))
                {
                    if ('0' != s_ROW[5][0])
                    {
						memset(sSQL,0,sizeof(sSQL));
						SS_snprintf(sSQL,sizeof(sSQL),"%s%s",g_s_ITLibHandle.m_s_IconPath.m_s,SS_IfROWString(s_ROW[6]));
						Param[0] = s_ROW[0];
						Param[1] = s_ROW[1];
						Param[2] = s_ROW[2];
						Param[3] = s_ROW[3];
						Param[4] = s_ROW[4];
						Param[5] = s_ROW[5];
						Param[6] = sSQL;
						Param[7] = NULL;
						g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_WOXIN_FRIEND_CFM,Param,7);
                    }
                }
            } while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
        }
        IT_SqliteRelease(&s_pRecord);
    }
    Param[0] = "END";
	Param[1] = NULL;
	Param[2] = NULL;
	Param[3] = NULL;
	Param[4] = NULL;
	Param[5] = NULL;
	Param[6] = NULL;
	Param[7] = NULL;
	Param[8] = NULL;

    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_WOXIN_FRIEND_CFM,Param,1);
    return  SS_SUCCESS;
}


SS_SHORT  DB_ProcGetFriendIcon          (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  *p = (SS_CHAR  *)s_pData->m_s;
    SS_UINT32 const un32RID = atol(s_pData->m_s);
    while('\r' != *p){p++;}*p=0;p++;

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,icon_path FROM book WHERE RID=%u",un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_FRIEND_ICON_CFM,(SS_CHAR**)s_ROW,2);
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcUploadMyIconMessage    (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    SS_CHAR  sSQL[4096] = "";
    SS_CHAR   const*pPath=s_pData->m_s;
    SS_CHAR  *p = (SS_CHAR  *)s_pData->m_s;
    
    while('\r' != *p){p++;}*p=0;p++;
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET icon_path='%s'",pPath);
#ifdef IT_LIB_DEBUG
	SS_Log_Printf(SS_STATUS_LOG,"SQL=%s",sSQL);
#endif
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcLoadCallRecordMessage  (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR  *Param[20];

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT RID,Phone,Result,Time,TalkTime FROM CallRecord");

    Param[0] = "BEGIN";
    Param[1] = NULL;
    Param[2] = NULL;
    Param[3] = NULL;
    Param[4] = NULL;
    Param[5] = NULL;
    Param[6] = NULL;
    Param[7] = NULL;
    Param[8] = NULL;

    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_CALL_RECORD_CFM,Param,1);

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            do 
            {
                if (s_ROW = IT_SqliteFetchRow(s_pRecord))
                {
                    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_CALL_RECORD_CFM,(SS_CHAR**)s_ROW,5);
                }
            } while (SS_SUCCESS == IT_SqliteMoveNext(s_pRecord));
        }
        IT_SqliteRelease(&s_pRecord);
    }

    Param[0] = "END";
    g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_CALL_RECORD_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcAddCallRecordMessage   (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    SS_CHAR  sSQL[2048] = "";
    SS_CHAR *p = s_pData->m_s;
    SS_CHAR const*pResult=NULL;
    SS_CHAR const*pTime=NULL;
    SS_CHAR const*pTalkTime=NULL;
    SS_CHAR const*pPhone=NULL;

    pResult=p;
    p = strchr(p,'\r');*p = 0;p++;
    pTime=p;
    p = strchr(p,'\r');*p = 0;p++;
    pTalkTime=p;
    p = strchr(p,'\r');*p = 0;p++;
    pPhone=p;
    SS_snprintf(sSQL,sizeof(sSQL),"INSERT INTO CallRecord(RID,Phone,Result,Time,TalkTime) "
        "VALUES(%u,'%s',%s,%s,%s)",g_s_ITLibHandle.m_un32DB_CallRecordRID++,pPhone,
        pResult,pTime,pTalkTime);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcDelCallRecordMessage   (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    SS_CHAR  sSQL[1024] = "";
    SS_snprintf(sSQL,sizeof(sSQL),"DELETE FROM CallRecord WHERE RID=%s",s_pData->m_s);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    return  SS_SUCCESS;
}

SS_SHORT  DB_ProcLoadUserInfoMessage    (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
	SS_CHAR  sPath[1024] = "";
	SS_CHAR  *Param[20];
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT Name,VName,Phone,sex,birthday,qq,character_signature,"
        "street,area,icon_path,LoginID FROM user_setting");

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
				memset(sPath,0,sizeof(sPath));
				SS_snprintf(sPath,sizeof(sPath),"%s%s",
					g_s_ITLibHandle.m_s_IconPath.m_s,SS_IfROWString(s_ROW[9]));
				Param[0] = s_ROW[0];
				Param[1] = s_ROW[1];
				Param[2] = s_ROW[2];
				Param[3] = s_ROW[3];
				Param[4] = s_ROW[4];
				Param[5] = s_ROW[5];
				Param[6] = s_ROW[6];
				Param[7] = s_ROW[7];
				Param[8] = s_ROW[8];
				Param[9] = sPath;
				Param[10]= s_ROW[10];
                Param[11]= NULL;
				g_s_ITLibHandle.m_f_CallBack(IT_MSG_LOAD_USER_INFO_CFM,Param,11);
#ifdef IT_LIB_DEBUG
				SS_Log_Printf(SS_STATUS_LOG,"call back IT_MSG_LOAD_USER_INFO_CFM message,"
					"Name=%s,VName=%s,Phone=%s,sex=%s,birthday=%s,qq=%s,character_signature=%s,"
					"street=%s,area=%s,icon_path=%s,LoginID=%s",s_ROW[0],s_ROW[1],s_ROW[2],s_ROW[3],
					s_ROW[4],s_ROW[5],s_ROW[6],s_ROW[7],s_ROW[8],sPath,s_ROW[10]);
#endif
            }
			else
			{
				//加载用户的信息
				IT_GetUserData(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s);
			}
        }
		else
		{
			//加载用户的信息
			IT_GetUserData(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s);
		}
        IT_SqliteRelease(&s_pRecord);
    }
	else
	{
		//加载用户的信息
		IT_GetUserData(g_s_ITLibHandle.m_s_Config.m_s_Phone.m_s);
	}
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcUpdateUserInfoMessage  (IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    SS_CHAR sSQL[8192] = "";
    SS_CHAR sQQ[128] = "";
    SS_UINT64  un64QQ=0;
    SS_CHAR *p=s_pData->m_s;
    SS_CHAR const*pName=NULL;
    SS_CHAR const*pVName=NULL;
    SS_CHAR const*pPhone=NULL;
    SS_BYTE ubSex = atoi(p);
    SS_CHAR const*pBirthday=NULL;
    SS_CHAR const*pQQ=NULL;
    SS_CHAR const*pCharacterSignature=NULL;
    SS_CHAR const*pStreet=NULL;
    SS_CHAR const*pArea=NULL;

    p = strchr(p,'\r');*p=0;p++;
    pName=p;
    p = strchr(p,'\r');*p=0;p++;
    pVName=p;
    p = strchr(p,'\r');*p=0;p++;
    pPhone=p;
    p = strchr(p,'\r');*p=0;p++;
    pBirthday=p;
    p = strchr(p,'\r');*p=0;p++;
    pQQ=p;
    p = strchr(p,'\r');*p=0;p++;
    pCharacterSignature=p;
    p = strchr(p,'\r');*p=0;p++;
    pStreet=p;
    p = strchr(p,'\r');*p=0;p++;
    pArea=p;

    SS_aToun64(pQQ,un64QQ);
    SS_snprintf(sQQ,sizeof(sQQ),SS_Print64u,un64QQ);

    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE user_setting SET Name='%s',VName='%s',Phone='%s',sex=%u,"
        "birthday='%s',qq=%s,character_signature='%s',street='%s',area='%s',synchronous_update_flag=1 ",
        pName,pVName,pPhone,ubSex,pBirthday,sQQ,pCharacterSignature,pStreet,pArea);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,NULL);
    ITREG_UpdateUserInfo(g_s_ITLibHandle.m_un64WoXinID,0,pName,pVName,pPhone,ubSex,pBirthday,
        sQQ,pCharacterSignature,pStreet,pArea);
    return  SS_SUCCESS;
}
SS_SHORT  DB_ProcGetLastBrowseShopMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT last_seller_id,last_area_id,last_shop_id FROM user_setting");
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                g_s_ITLibHandle.m_f_CallBack(IT_MSG_GET_LAST_BROWSE_SHOP_CFM,(SS_CHAR**)s_ROW,3);
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }
    return  SS_SUCCESS;
}
SS_SHORT  SS_ProcDBMessage(IN PIT_Handle s_pHandle,IN SS_str const*s_pData)
{
    switch(s_pData->m_len)
    {
    case DB_MSG_UPDATE_USER       :{return DB_ProcUpdateUserMessage      (s_pHandle,s_pData);}break;
    case DB_MSG_UPDATE_REMARK_NAME:{return DB_ProcUpdateRemarkNameMessage(s_pHandle,s_pData);}break;
    case DB_MSG_LOAD_FRIEND       :{return DB_ProcLoadFriendMessage      (s_pHandle,s_pData);}break;
    case DB_MSG_GET_FRIEND_ICON   :{return DB_ProcGetFriendIcon          (s_pHandle,s_pData);}break;
    case DB_MSG_UPLOAD_MY_ICON    :{return DB_ProcUploadMyIconMessage    (s_pHandle,s_pData);}break;
    case DB_MSG_LOAD_WOXIN_FRIEND :{return DB_ProcLoadWoXinFriendMessage (s_pHandle,s_pData);}break;
    case DB_MSG_LOAD_CALL_RECORD  :{return DB_ProcLoadCallRecordMessage  (s_pHandle,s_pData);}break;
    case DB_MSG_ADD_CALL_RECORD   :{return DB_ProcAddCallRecordMessage   (s_pHandle,s_pData);}break;
    case DB_MSG_DEL_CALL_RECORD   :{return DB_ProcDelCallRecordMessage   (s_pHandle,s_pData);}break;
    case DB_MSG_LOAD_USER_INFO    :{return DB_ProcLoadUserInfoMessage    (s_pHandle,s_pData);}break;
    case DB_MSG_UPDATE_USER_INFO  :{return DB_ProcUpdateUserInfoMessage  (s_pHandle,s_pData);}break;
    case DB_MSG_GET_LAST_BROWSE_SHOP:{return DB_ProcGetLastBrowseShopMessage(s_pHandle,s_pData);}break;

    default:
        {
        }break;
    }
    return  SS_SUCCESS;
}




SS_CHAR const*g_pDBTableMallArea = "CREATE TABLE MallArea("
"AreaID      INT UNSIGNED Not NULL,"//地区的ID
"AreaName    VARCHAR(30) DEFAULT  NULL,"//地区名称,比如：广州、深圳、上海、北京、纽约
"PRIMARY KEY (AreaID))";

//分店信息保存表，这个商家在这个地区有多少个分店
SS_CHAR const*g_pDBTableMallShop = "CREATE TABLE MallShop("
"AreaID      INT UNSIGNED Not NULL,"//地区的ID
"ShopID      INT UNSIGNED Not NULL,"//分店的ID
"ShopName    VARCHAR(30) DEFAULT  NULL,"//分店名称,比如：龙华店、福田店、宝安店、罗湖店
"PictureUrl  VARCHAR(128) DEFAULT  NULL,"//图片的路径
"PRIMARY KEY (AreaID,ShopID))";


//分店商品信息保存表
SS_CHAR const*g_pDBTableMallGoods = "CREATE TABLE MallGoods("
"goods_id    INT UNSIGNED NOT NULL,"    //商品ID
"shop_id    INT UNSIGNED NOT NULL,"    //分店ID
"goods_name    varchar(60)  NOT NULL,"    //商品名
"cat_id        INT UNSIGNED DEFAULT 0,"//分类id 组ID  关联category表
"home_img    varchar(60) NOT NULL,"    //列表图片 单张图片 460*460  名称加m_ 为180*180的缩略图
"main_img    varchar(60) NOT NULL,"    //主详情图 单张图片 1080*720
"info_img    varchar(240) DEFAULT NULL,"    //详情图 多张图片时用逗号隔开 1080*720
"shop_price        varchar(32) DEFAULT NULL,"    //本地价格
"market_price    varchar(32) DEFAULT NULL,"    //市场价格
"Description    varchar(200) DEFAULT NULL,"    //描述
"is_home    TINYINT  UNSIGNED DEFAULT  0,"    //首页商品 1代表是首页商品  0代表非首页商品
"is_hot        TINYINT  UNSIGNED DEFAULT  0,"    //热卖商品 1代表是热卖商品  0代表非热卖商品
"is_puls    TINYINT  UNSIGNED DEFAULT  0,"    //推荐商品 1代表是推荐商品  0代表非推荐商品
"is_delete    TINYINT  UNSIGNED DEFAULT  0,"    //是否已删除  0代表为未删除 1代表已逻辑删除商家还可以通过回收站还原 2代表彻底删除
"PRIMARY KEY (goods_id,shop_id))";


//CREATE TABLE Mall(boss_id INT UNSIGNED Not NULL,boss_name VARCHAR(30) NOT NULL,PRIMARY KEY (boss_id));
//CREATE TABLE Area(boss_id INT UNSIGNED Not NULL,area_id INT UNSIGNED Not NULL,area_name VARCHAR(30) NOT NULL,PRIMARY KEY (boss_id,area_id));


//通话记录
SS_CHAR const*g_pDBTableCallRecord = "CREATE TABLE CallRecord("
"RID      INT UNSIGNED Not NULL,"
"Phone    VARCHAR(30) DEFAULT  NULL,"//号码，主叫或被叫
"Result    TINYINT  UNSIGNED DEFAULT  0,"// 1 呼入 2 呼入未接 3 呼入拒接  4 呼出  5 呼出未接 6 呼出拒接 7 回拨  8 回拨主叫拒接 9 回拨被叫忙/被叫拒接
"Time      INT UNSIGNED DEFAULT 0,"//通话开始的时间
"TalkTime  INT UNSIGNED DEFAULT  0,"//单位  秒
"PRIMARY KEY (RID))";
//索引
SS_CHAR const*g_pDBTableCallRecordIndex_Result = "CREATE INDEX idx_CallRecord_Result ON CallRecord(Result)";



SS_CHAR const *g_pDBTableUserSetting =
"CREATE TABLE user_setting("
"LoginID  Varchar(50) Not NULL,"/*登录号*/
"LoginPwd varchar(30) Not NULL,"/*登录密码*/
"Name     varchar(30) NULL," //昵称
"VName     varchar(30) NULL,"//真实姓名
"Phone    varchar(30) Not NULL,"
"sex      TINYINT UNSIGNED DEFAULT 2,"  /*性别 0 女性 1 男性 2 未知*/
"birthday Datetime    NULL,"  /*生日*/
"qq       BIGINT DEFAULT 0," /**/
"character_signature varchar(255)  NULL,"/*个性签名*/
"street   varchar(255) NULL,"  /*街道/住址*/
"area     varchar(255) NULL,"  /*地区*/
"last_seller_id INT UNSIGNED DEFAULT 0,"//商家ID
"last_area_id   INT UNSIGNED DEFAULT 0,"//地区ID
"last_shop_id   INT UNSIGNED DEFAULT 0,"//分店ID
"synchronous_update_flag  TINYINT UNSIGNED DEFAULT 0,"/*更新用户信息的同步标记*/
"DoMain1      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"DoMain2      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"DoMain3      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"DoMain4      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"DoMain5      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"DoMain6      VARCHAR(64) DEFAULT  NULL,"/*登陆的域名，根据域名解析IP地址*/
"icon_path VARCHAR(256) NULL)"; //大头像文件的保存路径


/*通讯录组*/
SS_CHAR const *g_pDBTableBookGroup=
"CREATE TABLE IF NOT EXISTS book_group(GroupID  INT UNSIGNED DEFAULT 0," /*组号*/
"ParentID INT UNSIGNED DEFAULT 0," /*父节点组号*/
"GroupName Varchar(50) Not Null," /*组名*/
"PRIMARY KEY (GroupID));";


/*通讯录组成员*/
SS_CHAR const *g_pDBTableBookGroupMember=
"CREATE TABLE IF NOT EXISTS book_group_member(RID      INT UNSIGNED Not Null,"
"GroupID INT UNSIGNED Not Null," /*组号*/
"PRIMARY KEY (RID,GroupID));";


SS_CHAR const*g_pDBTableBook=
"CREATE TABLE IF NOT EXISTS book(RID       INT UNSIGNED NOT Null," /*JL号*/
"wo_xin_id BIGINT DEFAULT 0," /**/
"phone_record_id Varchar(50) NOT NULL,"//
"create_time INT UNSIGNED DEFAULT 0,"//
"modify_time INT UNSIGNED DEFAULT 0,"//
"name     Varchar(50) NULL,"  /*姓名*/
"phone_name  Varchar(50) NULL,"/*手机通讯录的姓名*/
"sex      TINYINT UNSIGNED DEFAULT 0,"  /*性别*/
"age      TINYINT UNSIGNED DEFAULT 0,"  /*年龄*/
"type     TINYINT UNSIGNED DEFAULT 0,"  /*类型 IT JLPS SIP PSTN VOIP FAX 等*/
"synchronous_remark_name_flag  TINYINT UNSIGNED DEFAULT 0,"
"synchronous_friend_flag       TINYINT UNSIGNED DEFAULT 0,"
"birthday Datetime    NULL,"  /*生日*/
"blood_type TINYINT UNSIGNED DEFAULT 0,"   /*血型*/
"company  Varchar(255) NULL,"  /*公司*/
"department Varchar(255) NULL,"/*部门*/
"position Varchar(255) NULL,"  /*职务*/
"vocation TINYINT UNSIGNED DEFAULT 0,"  /*行业*/
"country  varchar(255) NULL,"  /*国家*/
"province varchar(255) NULL,"  /*省*/
"city     Varchar(255) NULL,"  /*市*/
"counties Varchar(255) NULL,"  /*县*/
"township Varchar(255) NULL,"  /*乡镇*/
"village  Varchar(255) NULL,"  /*村庄*/
"postalcode varchar(10) NULL," /*邮政编码 */
"street   varchar(255) NULL,"  /*街道/住址*/
"id_card   varchar(40)  NULL,"  /*身份证*/
"education TINYINT UNSIGNED DEFAULT 0,"/*学历*/
"blog     varchar(255) NULL,"  /*博客*/
"character_signature varchar(255)  NULL,"/*个性签名*/
"interest_hobby varchar(255) NULL,"/*兴趣爱好*/
"remark_name  varchar(24) NULL,"   /*备注名*/
"remark  TEXT NULL,"   /*备注*/
"mobile  VARCHAR(20) NULL," //手机
"phone   VARCHAR(20) NULL," //绑定的手机号码
"icon_path VARCHAR(256) NULL," //大头像文件的保存路径
"PRIMARY KEY (RID));";


//可以全球范围内通讯的组的定义
SS_CHAR const *g_pDBTableIMGroup = 
"CREATE TABLE IF NOT EXISTS im_group("
"GroupID  BIGINT Not NULL,"
"AdminNo  BIGINT Not NULL,"/*拥有添加、删除、修改组成员的权利的分机号码*/
"GroupName  VARCHAR(30) Not NULL,"
"GroupSpell VARCHAR(30) DEFAULT NULL,"
"CallBoard  TEXT DEFAULT NULL," /*公告*/
"Remark  TEXT DEFAULT NULL,"/*备注*/
"PRIMARY KEY (GroupID,AdminNo))";

SS_CHAR const *g_pDBTableIMGroupMember =
"CREATE TABLE IF NOT EXISTS im_group_member("
"GroupID  INT UNSIGNED Not NULL,"
"MemberNo VARCHAR(30)  Not NULL,"/*组成员的分机号码*/
"MemberName VARCHAR(30) Not NULL,"/*组成员的名字*/
"MemberCapa INT UNSIGNED DEFAULT 0,"/*组成员的权限*/
"MemberSpell VARCHAR(30) DEFAULT NULL,"/*名字的拼音字母*/
"PRIMARY KEY (GroupID,MemberNo))";



SS_CHAR const *g_pDBTableUserIm = 
"CREATE TABLE IF NOT EXISTS user_im("
"RID INT UNSIGNED NOT NULL,"/*记录编号*/
"User Varchar(30) Not NULL,"/*用户的标识*/
"Language TINYINT UNSIGNED DEFAULT 0,"/*语言 0 是中文*/
"Codec TINYINT UNSIGNED DEFAULT 0,"/*0 文本  1 图片*/
"Style TINYINT UNSIGNED DEFAULT 0,"
"Color INT UNSIGNED DEFAULT 0,"
"Specialties TINYINT UNSIGNED DEFAULT 0,"
"Read Char(1) DEFAULT 'N',"/*N 未读  Y已读*/
"Direction Char(1) DEFAULT ' ',"/* S 发送  R 接收*/
"RTime Datetime NOT NULL,"
"Content TEXT NOT NULL,"/*如果是图片，在这个字段保存图片的路径*/
"PRIMARY KEY (RID))";

//索引
SS_CHAR const *g_pDBTableUserImIndexUser      = "CREATE INDEX idx_im_User ON user_im(User)";
SS_CHAR const *g_pDBTableUserImIndexRead      = "CREATE INDEX idx_im_Read ON user_im(Read)";
SS_CHAR const *g_pDBTableUserImIndexDirection = "CREATE INDEX idx_im_Direction ON user_im(Direction)";
SS_CHAR const *g_pDBTableUserImIndexRTime     = "CREATE INDEX idx_im_RTime ON user_im(RTime)";


SS_CHAR const *g_pDBTableSysIm = 
"CREATE TABLE IF NOT EXISTS sys_im("
"RID INT UNSIGNED NOT NULL,"/*记录编号*/
"Title Varchar(30) Not NULL,"/*标题*/
"Language TINYINT UNSIGNED DEFAULT 0,"/*语言 0 是中文*/
"Codec TINYINT UNSIGNED DEFAULT 0,"/*0 文本  1 图片*/
"Style TINYINT UNSIGNED DEFAULT 0,"
"Color INT UNSIGNED DEFAULT 0,"
"Specialties TINYINT UNSIGNED DEFAULT 0,"
"Read Char(1) DEFAULT 'N',"/*N 未读  Y已读*/
"Direction Char(1) DEFAULT ' ',"/* S 发送  R 接收*/
"RTime Datetime NOT NULL,"
"Content TEXT NOT NULL,"/*如果是图片，在这个字段保存图片的路径*/
"PRIMARY KEY (RID))";

//索引
SS_CHAR const *g_pDBTableSysImIndexTitle     ="CREATE INDEX idx_sys_im_Title ON sys_im(Title)";
SS_CHAR const *g_pDBTableSysImIndexRead      ="CREATE INDEX idx_sys_im_Read ON sys_im(Read)";
SS_CHAR const *g_pDBTableSysImIndexDirection ="CREATE INDEX idx_sys_im_Direction ON sys_im(Direction)";
SS_CHAR const *g_pDBTableSysImIndexRTime     ="CREATE INDEX idx_sys_im_RTime ON sys_im(RTime)";

SS_CHAR const *g_pDBTableGroupIm = 
"CREATE TABLE IF NOT EXISTS group_im("
"RID INT UNSIGNED NOT NULL,"/*记录编号*/
"GroupID  BIGINT Not NULL,"
"Language TINYINT UNSIGNED DEFAULT 0,"/*语言 0 是中文*/
"Codec TINYINT UNSIGNED DEFAULT 0,"/*0 文本  1 图片*/
"Style TINYINT UNSIGNED DEFAULT 0,"
"Color INT UNSIGNED DEFAULT 0,"
"Specialties TINYINT UNSIGNED DEFAULT 0,"
"Read Char(1) DEFAULT 'N',"/*N 未读  Y已读*/
"Direction Char(1) DEFAULT ' ',"/* S 发送  R 接收*/
"RTime Datetime NOT NULL,"
"Content TEXT NOT NULL,"/*如果是图片，在这个字段保存图片的路径*/
"PRIMARY KEY (RID,GroupID))";

//索引
SS_CHAR const *g_pDBTableGroupImIndexGroupID   ="CREATE INDEX idx_group_im_GroupID ON group_im(GroupID)";
SS_CHAR const *g_pDBTableGroupImIndexRead      ="CREATE INDEX idx_group_im_Read ON group_im(Read)";
SS_CHAR const *g_pDBTableGroupImIndexDirection ="CREATE INDEX idx_group_im_Direction ON group_im(Direction)";
SS_CHAR const *g_pDBTableGroupImIndexRTime     ="CREATE INDEX idx_group_im_RTime ON group_im(RTime)";


SS_CHAR const *g_pRechargePreferentialRulesTable =
"CREATE TABLE IF NOT EXISTS RechargePreferentialRules("
"Top Varchar(30) DEFAULT ' ',"
"equals Varchar(30) DEFAULT ' ',"
"desc Varchar(30) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";

SS_CHAR const *g_pAboutTable ="CREATE TABLE IF NOT EXISTS About(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";
SS_CHAR const *g_pAboutHelpTable ="CREATE TABLE IF NOT EXISTS AboutHelp(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";
SS_CHAR const *g_pAboutProtocolTable ="CREATE TABLE IF NOT EXISTS AboutProtocol(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";
SS_CHAR const *g_pSellerAboutTable ="CREATE TABLE IF NOT EXISTS SellerAbout(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";
SS_CHAR const *g_pShopAboutTable ="CREATE TABLE IF NOT EXISTS ShopAbout(ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,PRIMARY KEY (ShopID))";
SS_CHAR const *g_pRedPackageUseRulesTable ="CREATE TABLE IF NOT EXISTS RedPackageUseRules(ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,PRIMARY KEY (ShopID))";

SS_CHAR const *g_pAreaInfoTable ="CREATE TABLE IF NOT EXISTS AreaInfo(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0)";
SS_CHAR const *g_pShopInfoTable ="CREATE TABLE IF NOT EXISTS ShopInfo(AreaID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID))";
SS_CHAR const *g_pAreaShopInfoTable ="CREATE TABLE IF NOT EXISTS AreaShopInfo(context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0)";


SS_CHAR const *g_pHomeTopBigPictureTable             ="CREATE TABLE IF NOT EXISTS HomeTopBigPicture(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pHomeTopBigPictureExTable           ="CREATE TABLE IF NOT EXISTS HomeTopBigPictureEx(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pHomeNavigationTable                ="CREATE TABLE IF NOT EXISTS HomeNavigation(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pGuessYouLikeRandomGoodsTable       ="CREATE TABLE IF NOT EXISTS GuessYouLikeRandomGoods(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pCategoryListTable                  ="CREATE TABLE IF NOT EXISTS CategoryList(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pPackageTable                       ="CREATE TABLE IF NOT EXISTS Package(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pGoodsAllTable                      ="CREATE TABLE IF NOT EXISTS GoodsAll(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,Domain Varchar(256) DEFAULT ' ',PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pSpecialPropertiesCategoryListTable ="CREATE TABLE IF NOT EXISTS SpecialPropertiesCategoryList(AreaID INT UNSIGNED NOT NULL,ShopID INT UNSIGNED NOT NULL,context Varchar(2048) DEFAULT ' ',time INT UNSIGNED DEFAULT 0,count INT UNSIGNED DEFAULT 0,PRIMARY KEY (AreaID,ShopID))";
SS_CHAR const *g_pGoodsInfoTable                     =
"CREATE TABLE IF NOT EXISTS GoodsInfo("
"AreaID INT UNSIGNED NOT NULL,"
"ShopID INT UNSIGNED NOT NULL,"
"GoodsID INT UNSIGNED NOT NULL,"
"GroupID Varchar(256) DEFAULT ' ',"
"Description Varchar(256) DEFAULT ' ',"
"Name Varchar(256) DEFAULT ' ',"
"MarketPrice Varchar(256) DEFAULT ' ',"
"OURPrice Varchar(256) DEFAULT ' ',"
"Number Varchar(256) DEFAULT ' ',"
"Info Varchar(256) DEFAULT ' ',"
"LikeCount Varchar(256) DEFAULT ' ',"
"MeterageName Varchar(256) DEFAULT ' ',"
"time INT UNSIGNED DEFAULT 0,"
"PRIMARY KEY (AreaID,ShopID,GoodsID))";



SS_CHAR const *g_pDBVersionTable =
"CREATE TABLE IF NOT EXISTS db_version("
"version INT UNSIGNED Not NULL,"
"datetime INT UNSIGNED Not NULL,"
"PRIMARY KEY (version))";



