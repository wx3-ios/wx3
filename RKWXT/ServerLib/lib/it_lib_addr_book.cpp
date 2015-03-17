// it_lib_addr_book.cpp: implementation of the CITLibAddrBook class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_addr_book.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


SS_SHORT Book_UserFriendModefyNameIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_UINT64   un64WoXinID=0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_UINT32   un32RID=0;
    SS_CHAR  sPath[4096]="";
    SS_CHAR  sWoXinID[64] = "";
    SS_CHAR  *Param[8];
    SS_CHAR  sRID[8] = "";
    SS_str   s_Name;

    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);

    SS_INIT_str(s_Name);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_WO_XIN_ID:
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64WoXinID);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND_TYPE_NAME:
        {
            SSMSG_GetMessageParamEx(pParam,usnType,s_Name);
            goto Divide_GOTO;
        }break;
    default:break;
    }

    SS_un64Toa(un64WoXinID,sWoXinID);
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_FRIEND_MODIFY_NAME_IND "
            "message,%s,RID=%u,WoXinID=%s,Name=%s",sHeader,un32RID,sWoXinID,s_Name.m_s);
    }
#endif

    ITREG_BookUserFriendModifyNameCFM(un64Source,un64Dest,SS_SUCCESS,un32RID,un64WoXinID);


    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET name='%s' WHERE RID=%u",s_Name.m_s,un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);

    memset(sSQL,0,sizeof(sSQL));
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT phone,name,remark_name,phone_record_id,wo_xin_id,"
        "icon_path FROM book WHERE RID=%u",un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (NULL == s_pRecord)
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_SqliteMoveFirst(s_pRecord))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == (s_ROW = IT_SqliteFetchRow(s_pRecord)))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == s_ROW[0])
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }

    SS_snprintf(sRID,sizeof(sRID),"%u",un32RID);
    Param[0] = sRID;
    Param[1] = s_ROW[0];
    Param[2] = s_ROW[1];
    Param[3] = s_ROW[2];
    Param[4] = s_ROW[3];
    Param[5] = s_ROW[4];
    Param[6] = s_ROW[5];
    Param[7] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_FRIEND_MODIFY_NAME_IND,Param,7);
    IT_SqliteRelease(&s_pRecord);
    return  SS_SUCCESS;
}
SS_SHORT Book_UserFriendModefyWoXinUserIND(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_UINT64   un64WoXinID=0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_UINT32   un32RID=0;
    SS_CHAR  sWoXinID[64] = "";
    SS_CHAR  *Param[20];
    SS_CHAR  sRID[18] = "";
	SS_CHAR  sPath[1024] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND_TYPE_WO_XIN_ID:
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64WoXinID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

    SS_un64Toa(un64WoXinID,sWoXinID);
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_FRIEND_MODIFY_WOXIN_USER_IND "
            "message,%s,RID=%u,WoXinID=%s",sHeader,un32RID,sWoXinID);
    }
#endif

    ITREG_BookUserFriendModifyWoXinUserCFM(un64Source,un64Dest,SS_SUCCESS,un32RID,un64WoXinID);


    memset(sSQL,0,sizeof(sSQL));
    SS_snprintf(sSQL,sizeof(sSQL),"UPDATE book SET wo_xin_id=%s WHERE RID=%u",sWoXinID,un32RID);
    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    
    SS_snprintf(sSQL,sizeof(sSQL),"SELECT phone,name,remark_name,phone_record_id,wo_xin_id,"
        "icon_path FROM book WHERE RID=%u",un32RID);

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (NULL == s_pRecord)
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_SqliteMoveFirst(s_pRecord))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == (s_ROW = IT_SqliteFetchRow(s_pRecord)))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == s_ROW[0])
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    SS_snprintf(sRID,sizeof(sRID),"%u",un32RID);
    Param[0] = sRID;
    Param[1] = s_ROW[0];
    Param[2] = s_ROW[1];
    Param[3] = s_ROW[2];
    Param[4] = s_ROW[3];
    Param[5] = s_ROW[4];
	Param[6] = s_ROW[5];
	//有大头像
	if (s_ROW[5])
	{
		SS_snprintf(sPath,sizeof(sPath),"%s%s",g_s_ITLibHandle.m_s_IconPath.m_s,s_ROW[5]);
		Param[6] = sPath;
	}
    Param[7] = "1";
    Param[8] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_FRIEND_MODIFY_WOXIN_USER_IND,Param,8);
    IT_SqliteRelease(&s_pRecord);
    return  SS_SUCCESS;
}

SS_SHORT Book_UserFriendIconModefyIND     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    FILE  *fp = NULL;
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW    =NULL;
    SS_CHAR  sSQL[1024] = "";
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_UINT64   un64WoXinID=0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_UINT32   un32RID=0;
    SS_CHAR  sPhone[128]="";
    SS_CHAR  sPath[4096]="";
    SS_CHAR  sWoXinID[64] = "";
    SS_CHAR  *Param[8];
    SS_CHAR  sRID[8] = "";
    SS_str   s_Icon;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
    SS_INIT_str(s_Icon);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_IOCN:
        {
            SSMSG_GetBigMessageParam(pParam,usnType,s_Icon);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND_TYPE_WO_XIN_ID:
        {
            SSMSG_Getint64MessageParam(pParam,usnType,un64WoXinID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

    SS_un64Toa(un64WoXinID,sWoXinID);
#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_FRIEND_ICON_MODIFY_IND message,%s,"
            "IconSzie=%u,RID=%u,WoXinID=%s",sHeader,s_Icon.m_len,un32RID,sWoXinID);
    }
#endif

    if (NULL == s_Icon.m_s || 0 == s_Icon.m_len||NULL == g_s_ITLibHandle.m_s_IconPath.m_s)
    {
        return ITREG_BookUserFriendIconModifyCFM(un64Source,un64Dest,SS_FAILURE,un32RID,un64WoXinID);
    }

    SS_snprintf(sPath,sizeof(sPath),"%s%s.icon",g_s_ITLibHandle.m_s_IconPath.m_s,sWoXinID);
    if (NULL == (fp = fopen(sPath,"wb")))
    {
        return ITREG_BookUserFriendIconModifyCFM(un64Source,un64Dest,SS_FAILURE,un32RID,un64WoXinID);
    }
    fwrite(s_Icon.m_s,s_Icon.m_len,1,fp);
    fclose(fp);
    fp = NULL;
	memset(sPath,0,sizeof(sPath));
	SS_snprintf(sPath,sizeof(sPath),"%s.icon",sWoXinID);
    IT_DBSetFriendIcon(un32RID,sPath);
    ITREG_BookUserFriendIconModifyCFM(un64Source,un64Dest,SS_SUCCESS,un32RID,un64WoXinID);


    SS_snprintf(sSQL,sizeof(sSQL),"SELECT phone FROM book WHERE RID=%u",un32RID);

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (NULL == s_pRecord)
    {
        return  SS_SUCCESS;
    }
    if (SS_SUCCESS != IT_SqliteMoveFirst(s_pRecord))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == (s_ROW = IT_SqliteFetchRow(s_pRecord)))
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    if (NULL == s_ROW[0])
    {
        IT_SqliteRelease(&s_pRecord);
        return  SS_SUCCESS;
    }
    strncpy(sPhone,s_ROW[0],sizeof(sPhone));
    IT_SqliteRelease(&s_pRecord);


    SS_snprintf(sRID,sizeof(sRID),"%u",un32RID);
    Param[0] = sRID;
    Param[1] = sPath;
    Param[2] = sPhone;
    Param[3] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_FRIEND_ICON_MODIFY_IND,Param,3);
    return  SS_SUCCESS;
}
SS_SHORT Book_UserUpdateRemarkNameCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32RID=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[8] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_UPDATE_REMARK_NAME_CFM "
            "message,%s,Result=%u,RID=%u",sHeader,ubResult,un32RID);
    }
#endif
    
    if (SS_SUCCESS == ubResult)
    {
        IT_DBSetSynchronousRemarkNameFlag(un32RID,SS_TRUE);
    }

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    Param[0] = sResult;
    Param[1] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_UPDATE_FRIEND_REMARK_NAME_CFM,Param,1);
    return  SS_SUCCESS;
}
SS_SHORT Book_UserUploadMyIconCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_CHAR  *Param[8];
    SS_CHAR  sResult[8] = "";
    SS_CHAR  sIconPath[1024] = "";
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_UPLOAD_MY_ICON_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_UPLOAD_MY_ICON_CFM "
            "message,%s,Result=%u",sHeader,ubResult);
    }
#endif

    SS_CHAR  sSQL[1024] = "";
    PIT_SqliteRES s_pRecord=NULL;
    IT_SqliteROW  s_ROW=NULL;

    SS_snprintf(sSQL,sizeof(sSQL),"SELECT icon_path FROM user_setting ");

    IT_SqliteExecute(&g_s_ITLibHandle,sSQL,&s_pRecord);
    if (s_pRecord)
    {
        if (SS_SUCCESS == IT_SqliteMoveFirst(s_pRecord))
        {
            if (s_ROW = IT_SqliteFetchRow(s_pRecord))
            {
                if (s_ROW[0])
                {
                    strncpy(sIconPath,s_ROW[0],sizeof(sIconPath));
                }
            }
        }
        IT_SqliteRelease(&s_pRecord);
    }

    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    Param[0] = sResult;
    Param[1] = sIconPath;
    Param[2] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_UPLOAD_MY_ICON_CFM,Param,2);
    return  SS_SUCCESS;
}
SS_SHORT Book_UserAddCFM                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32RID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_ADD_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_ADD_CFM_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_ADD_CFM message,%s,"
            "Result=%u,RID=%u",sHeader,ubResult,un32RID);
    }
#endif
    if (SS_SUCCESS == ubResult)
    {
        IT_DBSetSynchronousFriendFlag(un32RID,SS_TRUE);
    }
    return  SS_SUCCESS;
}

SS_SHORT Book_UserDeleteCFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    SS_CHAR const*pMSG = s_pRecvData->m_s_msg.m_s;
    SS_UINT64   un64Source=0;
    SS_UINT64   un64Dest  =0;
    SS_CHAR const*pParam = pMSG+SS_MSG_HEADER_LEN;
    SS_USHORT   usnType=0;
    SS_BYTE     ubResult=0;
    SS_UINT32   un32RID=0;
    SSMSG_GetSource(pMSG,un64Source);
    SSMSG_GetDest  (pMSG,un64Dest);
Divide_GOTO:
    switch(ntohs(*(SS_USHORT*)(pParam)))
    {
    case ITREG_BOOK_USER_DELETE_CFM_TYPE_RESULT:
        {
            SSMSG_GetByteMessageParam(pParam,usnType,ubResult);
            goto Divide_GOTO;
        }break;
    case ITREG_BOOK_USER_DELETE_CFM_TYPE_RID:
        {
            SSMSG_Getint32MessageParam(pParam,usnType,un32RID);
            goto Divide_GOTO;
        }break;
    default:break;
    }

#ifdef   IT_LIB_DEBUG
    if(SS_Log_If(SS_LOG_TRACE))
    {
        SS_CHAR     sHeader[SS_MSG_HEADER_SIZE] = "";
        SSMSG_DivideMessageHeaderToBuf(pMSG,sHeader,sizeof(sHeader));
        SS_Log_Printf(SS_TRACE_LOG,"Recv ITREG_BOOK_USER_DELETE_CFM message,%s,"
            "Result=%u,RID=%u",sHeader,ubResult,un32RID);
    }
#endif

    if (SS_SUCCESS == ubResult)
    {
        IT_DBDeleteFriend(un32RID);
    }

    SS_CHAR  *Param[8];
    SS_CHAR  sResult[32] = "";
    SS_CHAR  sRID[32] = "";
    SS_snprintf(sResult,sizeof(sResult),"%u",ubResult);
    SS_snprintf(sRID,sizeof(sRID),"%u",un32RID);
    Param[0] = sResult;
    Param[1] = sRID;
    Param[2] = NULL;
    s_pHandle->m_f_CallBack(IT_MSG_DELETE_FRIEND_CFM,Param,2);
    return  SS_SUCCESS;
}
SS_SHORT Book_UserUpdate                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_UserUpdateCFM               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_SynchronousIND              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_SynchronousCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupAdd                  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupAdd_CFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupDelete               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupDeleteCFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdate               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdateCFM            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberAdd            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberAdd_CFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberDelete         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberDeleteCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberUpdate         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberUpdateCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupSynchronousIND       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupSynchronousCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberSynchronousIND (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberSynchronousCFM (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdateCallBoard      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdateCallBoardCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupAddMemberIND         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupDeleteMemberIND      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupDeleteMemberALLIND   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupAddIND               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupDeleteIND            (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupNnmeUpdate           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupCallBoardUpdate      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupMemberExitIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdateMemberName     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}
SS_SHORT Book_IMGroupUpdateMemberCapaIND  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData)
{
    return  SS_SUCCESS;
}



