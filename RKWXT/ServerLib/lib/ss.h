// ss.h: interface for the CSS class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SS_H__9602DE4F_179E_44D9_97A3_97115FE6CED7__INCLUDED_)
#define AFX_SS_H__9602DE4F_179E_44D9_97A3_97115FE6CED7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000




SS_SHORT  SS_TCP_Send(
    IN  SS_Socket const Handle,
    IN  SS_CHAR  const*const pString,
    IN  SS_INT32   const n32Size,
    IN  SS_INT32  const n32Flags);
SS_SHORT  SS_TCP_Recv(
    IN  SS_Socket const Handle,
    OUT PSS_CHAR    pString,
    IN  SS_INT32 const n32Size,
    IN  SS_INT32 const n32Flags);
SS_SHORT  SS_TCP_RecvTimeOut(
    IN  SS_Socket const Handle,
    OUT PSS_CHAR        psBuf,
    IN  SS_INT32  const n32BufSize,
    IN  SS_INT32  const n32Flags,
    IN  SS_UINT32 const un32Second);

    //psHostName  域名 : www.baidu.com
SS_SHORT    SS_TCP_getRemoterHostIP (
    IN  SS_CHAR const *const psHostName,
    OUT PSS_CHAR       psAddress,
    IN  size_t          BufSize);
    
SS_SHORT    SS_TCP_getLocalHostIP (
    OUT PSS_CHAR       psAddress,
    IN  size_t          BufSize);
    
SS_SHORT    SS_TCP_GetLocalIPAndPort(IN SS_Socket const Handle,OUT SS_SOCKADDR_IN*s_pAddr);
SS_SHORT    SS_TCP_GetRemoterIPAndPort(IN SS_Socket const Handle,OUT SS_SOCKADDR_IN*s_pAddr);

SS_Socket   SS_TCP_Socket();
SS_Socket   SS_TCP_Connect(IN SS_CHAR const*pIP,IN SS_USHORT const usnPort);
SS_Socket   SS_TCP_Listen (IN SS_CHAR const*pIP,IN SS_USHORT const usnPort,IN SS_USHORT const usnListenNumber);


//////////////////////////////////////////////////////////////////////////

SS_SHORT  SS_UDP_Send(
    IN  SS_Socket const Handle,
    IN  SS_CHAR   const*const pString,
    IN  SS_INT32  const n32Size,
    IN  SS_SOCKADDR_IN *s_Addr);

SS_SHORT  SS_UDP_Send_Ex(
    IN  SS_Socket const Handle,
    IN  SS_CHAR   const*const pString,
    IN  SS_INT32  const n32Size,
    IN  SS_CHAR   const*const pIP,
    IN  SS_USHORT const usnPort);

SS_Socket   SS_UDP_Socket();
SS_Socket   SS_UDP_Bind(IN SS_CHAR const*const pIP,IN SS_USHORT const usnPort);
SS_SHORT    SS_SetAddr(IN SS_SOCKADDR_IN  *s_pAddr,IN SS_CHAR const*const pIP,IN SS_USHORT const usnPort);

#define  SS_UDP_RecvFrom(_Socket_,_Buf_,_n32BufSize_,_s_pAddr_)\
{\
    SS_INT32  n32AddrLength=sizeof(SS_SOCKADDR_IN);\
    _n32BufSize_ = recvfrom(_Socket_,_Buf_,_n32BufSize_,0,SS_ADDR_HANDEL(_s_pAddr_),SS_ADDR_LEN_HANDEL&n32AddrLength);\
}

#define  SS_UDP_RecvFrom_unip(_Socket_,_Buf_,_n32BufSize_,_un32Address_,_usnPort_)\
{\
    SS_SOCKADDR_IN  s_Addr;\
    SS_INT32  n32AddrLength=sizeof(SS_SOCKADDR_IN);\
    _n32BufSize_ = recvfrom(_Socket_,_Buf_,_n32BufSize_,0,SS_ADDR_HANDEL(&s_Addr),SS_ADDR_LEN_HANDEL&n32AddrLength);\
    _un32Address_= SS_GETUintIPV4Value(s_Addr);\
    _usnPort_ = s_Addr.sin_port;\
}

#define  SS_UDP_RecvFrom_strip(_Socket_,_Buf_,_n32BufSize_,_pIPv4_,_usnPort_)\
{\
    SS_SOCKADDR_IN  s_Addr;\
    SS_INT32  n32AddrLength=sizeof(SS_SOCKADDR_IN);\
    _n32BufSize_ = recvfrom(_Socket_,_Buf_,_n32BufSize_,0,SS_ADDR_HANDEL(&s_Addr),SS_ADDR_LEN_HANDEL&n32AddrLength);\
    SS_uintToIPv4(SS_GETUintIPV4Value(s_Addr),_pIPv4_);\
    _usnPort_ = ntohs(s_Addr.sin_port);\
}



//////////////////////////////////////////////////////////////////////////

//比对文件名，获得比当前名字大一点的那个文件，比如：当前文件名为：2_.txt,那么会找到3.txt或4_.txt
SS_SHORT  SS_GetMaxFileName(
    IN  SS_CHAR const*pPath,
    IN  SS_CHAR const*pCurName,
    OUT SS_CHAR *pMaxName,
    IN  SS_UINT32 const un32MaxNameSize);
//计算这个文件夹内有多少个文件
SS_UINT32 SS_GetFileCount(IN  SS_CHAR const*pPath);

/*得到执行最后一次错误的原因*/
SS_UINT32  SS_GetLastError();
/*重命名*/
SS_SHORT  SS_Rename(
        IN SS_CHAR const*const psOldName,
        IN SS_CHAR const*const psNewName);
/*删除一个空目录*/
SS_SHORT  SS_DeleteDir(IN SS_CHAR const*const psDirName);
/*删除一个文件*/
SS_SHORT  SS_DeleteFile(IN SS_CHAR const*const psFileName);
/*复制一个文件*/
SS_SHORT  SS_CopyFile(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName);
/*移动一个文件*/
SS_SHORT  SS_MoveFile(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName);
/*复制整个目录下的所有文件，包括子目录*/
SS_SHORT  SS_CopyDirectory(
        IN SS_CHAR const*const psSourcePathName,
        IN SS_CHAR const*const psDestinationPathName);
/*移动一个目录下的所有文件，包括子目录*/
SS_SHORT  SS_MoveDirectory(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName);
/*删除整个目录下的所有文件，包括子目录*/
SS_SHORT  SS_DeleteDirectory(IN SS_CHAR const*const psDirName);
//有选择性的删除文件
SS_SHORT  SS_DeleteDirectoryFiles(IN SS_CHAR const*const psDirName,IN SS_CHAR const*const psFileName);
/*创建一个新目录*/
SS_SHORT  SS_CreateDirectory(IN SS_CHAR const*const psDirName);
/*得到一个文件的大小*/
SS_SHORT  SS_GetFileSize(
        IN  SS_CHAR  const*const psFilePathName,
        OUT SS_UINT32             *un32FileSize);
//创建路径所有的文件夹,路径一定是绝对路径
SS_SHORT   SS_CreatePathFolder(
        IN  SS_CHAR  const*const psFilePathName,
        IN  SS_UINT32       const un32FileSize);

//获得操作系统的类型 返回值 0  WIN_32  1  WIN_64  2  Linux_32  3  Linux_64
SS_BYTE SS_GetOSBit();

//////////////////////////////////////////////////////////////////////////

//判断这个字符串是不是有效的金额
SS_SHORT SS_IfMoney(IN SS_CHAR const *pMoney);


//判断并追加结尾符号 linux 追加 '/'  windows 追加 '\'
SS_SHORT SS_IfAndAppendPathEndSymbol(SS_str *s_pPath);


SS_SHORT SS_String_UIntToIPv4(IN SS_UINT32 const un32IP,OUT PSS_CHAR   psIP,IN size_t IPSize);
SS_SHORT SS_String_IPv4ToUInt(IN SS_CHAR const *const  psIP,  OUT PSS_UINT32 pun32IP);
SS_SHORT SS_String_UshortToByte(
    IN  SS_USHORT const  usnPort,
    OUT PSS_BYTE         pub1,
    OUT PSS_BYTE         pub2);
SS_SHORT SS_String_ByteToUshort(
    IN  SS_BYTE const  ub1,
    IN  SS_BYTE const  ub2,
    OUT PSS_USHORT     pusnPort);
SS_SHORT SS_String_IPv4ToByte(
    IN  const PSS_CHAR     psIP,
    OUT PSS_BYTE pub1,
    OUT PSS_BYTE pub2,
    OUT PSS_BYTE pub3,
    OUT PSS_BYTE pub4);
SS_SHORT SS_String_ByteToIPv4(
    IN  SS_BYTE const ub1,
    IN  SS_BYTE const ub2,
    IN  SS_BYTE const ub3,
    IN  SS_BYTE const ub4,
    OUT PSS_CHAR  psIP,
    IN size_t IPSize);

SS_SHORT SS_String_IfHexNumber(IN SS_CHAR const * pHex);
SS_SHORT SS_String_IfStrNumber(IN SS_CHAR const * pStr);
SS_SHORT SS_String_IfIPv4Address(IN SS_CHAR const *const  IPAddress);
SS_SHORT SS_String_IfMACAddress(IN SS_CHAR const *const  MACAddress);
const SS_CHAR  *SS_String_GetIPv4AddreCSString(
    IN SS_CHAR const *const pStr,
    OUT SS_CHAR *pIPAddress,
    IN  size_t    IPAddressSize);
//验证手机号码
SS_SHORT SS_String_CheckPhoneNumber(IN SS_CHAR const * pPhone);
//验证缓存更新的时间 return SS_SUCCESS表示时间到，更新缓存数据，其他为不需要更新缓存
SS_SHORT SS_CheckCacheTime(IN SS_UINT32  const un32Time,IN SS_UINT32 const un32CheckDay);

//替换一个字符串中指定的字符串
/*SS_CHAR const * SS_String_StrReplace(
  IN OUT PSS_CHAR      psSource, 
    IN   SS_CHAR const *const sub, 
    IN   SS_CHAR const *const rep);*/
//替换一个字符串中指定的字符
SS_CHAR const * SS_String_ChrReplace(
    IN OUT PSS_CHAR      psSource, 
    IN     SS_CHAR const sub, 
    IN     SS_CHAR const rep);
//不区分大小写的字符串查找，其他和strstr一样
/*  SS_CHAR const * SS_String_StrCaseStr(
    IN SS_CHAR const * str1,
    IN SS_CHAR const * str2);*/
//平台无关的字符串比较
//  SS_SHORT        SS_String_StrCaseCMP(IN SS_CHAR const *const pString1, 
//                                          IN SS_CHAR const *const pString2);
//在一个串中查找从开始到给定字符的第一个匹配之处的长度,没有找到返回 0
SS_UINT32        SS_String_ChLength(
    IN SS_CHAR const * pString, 
    IN const SS_CHAR cEndCharacterFlag);
//在一个串中查找从开始到给定字符串的第一次匹配之处的长度,没有找到返回 0
SS_UINT32        SS_String_StrLength(
    IN SS_CHAR const *const pString, 
    IN SS_CHAR const *const pEndStringFlag);

//全部转换成大写
const SS_CHAR  * SS_String_UpperCase(IN OUT SS_CHAR *pStr);
//全部转换成小写
const SS_CHAR  * SS_String_LowerCase(IN OUT SS_CHAR *pStr);    
//全部转换成十六进制
const SS_CHAR  * SS_String_HexCase(
    IN  SS_CHAR const *const  pstr1,
    IN  SS_INT32 const lnLength,
    OUT SS_CHAR       *pStr2,
    IN  size_t          StrSize);
//全部转换成十六进制
const SS_CHAR  * SS_String_HexCaseString(
    IN  SS_CHAR const *const  pstr1,
    IN  SS_INT32 const lnLength,
    OUT SS_CHAR       *pStr2,
    IN  size_t          StrSize);

SS_INT32 SS_String_GetStringCharNumber(
    IN SS_CHAR const * psStr,
    IN SS_CHAR const  ch);
//过滤掉不是标准的ASCII的字符，如果过滤失败不会改变原始的字符串
SS_CHAR const * SS_String_FilterASCIIChar(IN  OUT  SS_CHAR *pString,
                                               SS_INT32 const lnStringLength);
SS_CHAR const * SS_String_FilterChar_0_to_9(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_FilterChar_a_to_z(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_FilterChar_A_to_Z(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_FilterCharCase(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_FilterChar(IN OUT SS_CHAR *pStr,SS_CHAR const ch);



SS_CHAR const * SS_String_DeleteChar_0_to_9(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_DeleteChar_a_to_z(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_DeleteChar_A_to_Z(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_DeleteCharCase(IN OUT SS_CHAR *pStr);
SS_CHAR const * SS_String_DeleteChar(IN OUT SS_CHAR *pStr,SS_CHAR const ch);



SS_CHAR const * SS_String_GetStringToString(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const *const pBeginStringFlag,
    IN  SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR       *pBuf,
    IN  size_t         BufSize);
SS_CHAR const * SS_String_GetStringToChar(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const *const pBeginStringFlag,
    IN  SS_CHAR const cEndCharFlag,
    OUT SS_CHAR       *pBuf,
    IN  size_t         BufSize);
SS_CHAR const * SS_String_GetCharToString(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const cBeginCharFlag,
    IN  SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR       *pBuf,
 IN OUT SS_UINT32  *un32BufSize);
SS_CHAR const * SS_String_GetCharToChar(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const cBeginCharFlag,
    IN  SS_CHAR const cEndCharFlag,
    OUT SS_CHAR       *pBuf,
 IN OUT SS_UINT32  *un32BufSize);
SS_CHAR const * SS_String_GetStringToEnd(
    IN SS_CHAR const *const pString,
    IN SS_CHAR const *const pBeginStringFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t         BufSize);
SS_CHAR const * SS_String_GetCharToEnd(
    IN SS_CHAR const *const pString,
    IN SS_CHAR const cBeginCharFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t         BufSize);


SS_CHAR const*SS_String_GetBeginToChar(
    IN SS_CHAR const * pString,
    IN SS_CHAR const cEndCharFlag,
    OUT SS_CHAR      *pBuf,
    IN OUT SS_UINT32  *un32BufSize);

SS_CHAR const*SS_String_GetBeginToString(
    IN SS_CHAR const * pString,
    IN SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t         BufSize);
char const * SS_String_StrCaseChr(const char* src,char ch);
char const * SS_String_StrCaseStr(const char* src,const char* dst);


SS_CHAR const * SS_GetCPUID(OUT SS_CHAR *pCPUID);
SS_SHORT SS_GetCPUCount();

//获得路径下面的文件名 如：/aaa/bbb/ccc/a.cpp 或 E:\aaa\bbb\ccc\a.cpp 返回 a.cpp 的文件名
SS_CHAR const* SS_GetPathFileName(IN SS_CHAR const *pPath,IN SS_UINT32 const un32PathLength,OUT SS_CHAR *pName);
//删除文件路径的最后一个目录名
SS_CHAR const* SS_DelPathLastDir(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength);
//获得应用程序的路径 如：/aaa/bbb/ccc/gioas   c:\aaa\bbb\ccc\gioas
SS_CHAR const* SS_GetEXEPath(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength);
//获得应用程序所在目录的路径 如：/aaa/bbb/ccc   c:\aaa\bbb\ccc
SS_CHAR const* SS_GetModulePath(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength);
//获得短信的发送结果
SS_CHAR const * SS_GetSMSSendResult(IN SS_BYTE const ubState);
//SS_TRUE 是内网IP SS_FALSE 不是内网IP
SS_BOOL SS_IsPrivateIPAddress(const char *sIPAddress);

SS_CHAR SS_GetDTMFChar(IN SS_BYTE const ubKey); 
SS_BYTE SS_GetDTMFByte(IN SS_CHAR const *pKey); 

//把字符串颠倒过来
#define  SS_String_Invert(_sur_,_det_)\
do {\
    SS_UINT32 un32=0;\
    SS_UINT32 un32Count=strlen(_sur_);\
    SS_UINT32 un32ID=un32Count-1;\
    for (un32=0;un32<un32Count;un32++)\
    {\
        _det_[un32] = _sur_[un32ID--];\
    }\
} while (0)



//////////////////////////////////////////////////////////////////////////

//获得当天是星期几
SS_BYTE  SS_Timeval_GetTheWeek(IN SS_Timeval *s_DateTime);


//输出的样式 Wed, 5 May 2010 14:35:06 +0800
SS_SHORT  SS_Timeval_GetDateString_English(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize);


/*时间比较，如果pDateTime1大于pDateTime2返回大于的小时数，否着返回 0,秒数和分钟或略不计*/
SS_UINT32  SS_Timeval_IfHour(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2);
/*时间比较，如果pDateTime1大于pDateTime2返回大于的分钟数，否着返回 0,秒数或略不计*/
SS_UINT32  SS_Timeval_IfMinute(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2);

/*时间比较，如果pDateTime1大于pDateTime2返回大于的秒数，否着返回 0*/
SS_UINT64  SS_Timeval_IfSecond(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2);

/*时间比较，如果pDateTime1大于pDateTime2返回大于的毫秒数，否着返回 0*/
SS_UINT32  SS_Timeval_IfMillisecond(
    IN SS_Timeval const * const pDateTime1,
    IN SS_Timeval const * const pDateTime2);

/*将字符串时间转化为时间结构*/
//一定是标准的格式 2012-10-17 20:50:50
SS_SHORT  SS_Timeval_FormatStringToTimeval(
        IN  SS_CHAR const*pstr,
        IN  size_t       StrBufSize,
        OUT SS_Timeval *pTimeval);

//获得秒数
SS_UINT64  SS_Timeval_GetSecondCount(IN SS_Timeval const * const pDateTime1);
//获得分钟数
SS_UINT32  SS_Timeval_GetMinuteCount(IN SS_Timeval const * const pDateTime1);
//获得小时数
SS_UINT32  SS_Timeval_GetHourCount(IN SS_Timeval const * const pDateTime1);
//获得天数
SS_UINT32  SS_Timeval_GetDayCount(IN SS_Timeval const * const pDateTime1);

//将时间转换成一个  
SS_SHORT  SS_Timeval_mktimeToHex(
    IN  SS_Timeval const * const pDateTime,
    OUT SS_CHAR  *pHexTime);
SS_SHORT  SS_Timeval_mkHexTotime(
    IN  SS_CHAR  const * const pHexTime,
    OUT SS_Timeval *pDateTime);
/*获得当前时间*/
SS_SHORT  SS_Timeval_GetLocalDataTime(OUT PSS_Timeval pDateTime);

/*格式化年月日时分秒毫秒到一个字符串*/
SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecondMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize);
//为了创建文件设计的设个函数
SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecondMillisecondsEx(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize);
/*格式化年月日时分秒到一个字符串*/
SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecond(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;
/*格式化年月日时分秒到一个字符串*/

#define  SS_Time_FormatYearMonthDayHourMinuteSecond(_time_t,_pTime_,_TimeSize_)\
{\
    SS_Time    s_TM;\
    memcpy(&s_TM,(void *)localtime((const time_t*)&(_time_t)), sizeof (SS_Time));\
    SS_snprintf(_pTime_,_TimeSize_,"%04d-%02d-%02d %02d:%02d:%02d",\
        s_TM.m_n32Year + 1900,\
        s_TM.m_n32Mon + 1,\
        s_TM.m_n32Mday,\
        s_TM.m_n32Hour,\
        s_TM.m_n32Min,\
        s_TM.m_n32Sec);\
}

#define  SS_Time_FormatYearMonthDayHourMinuteSecondEx(_time_t,_pTime_,_TimeSize_)\
{\
    SS_Time    s_TM;\
    memcpy(&s_TM,(void *)localtime((const time_t*)&(_time_t)), sizeof (SS_Time));\
    SS_snprintf(_pTime_,_TimeSize_,"%04d_%02d_%02d_%02d_%02d_%02d",\
    s_TM.m_n32Year + 1900,\
    s_TM.m_n32Mon + 1,\
    s_TM.m_n32Mday,\
    s_TM.m_n32Hour,\
    s_TM.m_n32Min,\
    s_TM.m_n32Sec);\
}

#define  SS_Time_FormatYearMonthDayHourMinuteSecond_un64(_un64_,_pTime_,_TimeSize_)\
{\
    time_t _t_ = _un64_/1000000;\
    SS_Time_FormatYearMonthDayHourMinuteSecond(_t_,_pTime_,_TimeSize_);\
}


#define  SS_Time_FormatYearMonthDayHourMinuteSecondEx_un64(_un64_,_pTime_,_TimeSize_)\
{\
    time_t _t_ = _un64_/1000000;\
    SS_Time_FormatYearMonthDayHourMinuteSecondEx(_t_,_pTime_,_TimeSize_);\
}

/*格式化时分秒毫秒到一个字符串*/
SS_SHORT  SS_Timeval_FormatHourMinuteSecondMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;
/*格式化年月日到一个字符串*/
SS_SHORT  SS_Timeval_FormatYearMonthDay(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;

/*格式化年月到一个字符串*/
SS_SHORT  SS_Timeval_FormatYearMonth(
    IN  SS_Timeval const *pTimeval,
    OUT PSS_CHAR          pstr,
    IN  size_t             StrBufSize) ;

/*格式化年到一个字符串*/
SS_SHORT  SS_Timeval_FormatYear(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;

/*格式化月到一个字符串*/
SS_SHORT  SS_Timeval_FormatMonth(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;

/*格式化日到一个字符串*/
SS_SHORT  SS_Timeval_FormatDay(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;

/*格式化时分秒到一个字符串*/
SS_SHORT  SS_Timeval_FormatHourMinuteSecond(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) ;

/*格式化时到一个字符串*/
SS_SHORT  SS_Timeval_FormatHour(
    IN  SS_Timeval const *pTimeval,
    OUT PSS_CHAR          pstr,
    IN  size_t             StrBufSize) ;

/*格式化时到一个字符串*/
SS_SHORT  SS_Timeval_GetHour(
    IN  SS_Timeval const *pTimeval,
    OUT SS_BYTE           *pubHour);
/*格式化毫秒到一个字符串*/
SS_SHORT  SS_Timeval_FormatMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize);



//////////////////////////////////////////////////////////////////////////

typedef struct Link_Node
{
    SS_VOID     *m_pData;
    struct Link_Node*m_pNext;
}Link_Node,*PLink_Node;



typedef struct SSLinkQueue
{
    PLink_Node m_pHead;//头指针
    PLink_Node m_pTail;//尾指针
    SS_THREAD_MUTEX_T m_Mutext;//锁
}SSLinkQueue,*PSSLinkQueue;


SS_SHORT   SS_LinkQueue_Init(IN SSLinkQueue*pSSLinkQueue);
SS_SHORT   SS_LinkQueue_Destroy(IN SSLinkQueue*pSSLinkQueue);
SS_SHORT   SS_LinkQueue_ReadData(IN SSLinkQueue*pSSLinkQueue,OUT SS_VOID  **pData);
SS_SHORT   SS_LinkQueue_WriteData(IN SSLinkQueue*pSSLinkQueue,OUT SS_VOID *pData);
SS_SHORT   SS_LinkQueue_FreeAllItem(IN SSLinkQueue*pSSLinkQueue,IN void (*f_del)(SS_VOID*));
SS_UINT32  SS_LinkQueue_GetCount(IN SSLinkQueue*pSSLinkQueue);

//////////////////////////////////////////////////////////////////////////


typedef struct SSRTPQueue
{
    SS_CHAR  **m_pArrData;//保存数据的二维表
    SS_UINT32  m_un32BufSize;//保存最大的BUF的长度
    SS_UINT32  m_un32QueueMaxLen;//队列最大的长度,默认是65535
    SS_UINT32  m_un32ReadPointer;//当前写的那个BUF的位置
    SS_UINT32  m_un32WaitingLen;//有多少个为处理的BUF
    SS_THREAD_MUTEX_T m_Mutext;//锁
}SSRTPQueue,*PSSRTPQueue;

SS_SHORT   SS_RTPQueue_Init(
    IN SSRTPQueue*pSSRTPQueue,
    IN SS_UINT32 const un32QueueLen,
    IN SS_UINT32 const un32BufSize);
SS_SHORT   SS_RTPQueue_Destroy(IN SSRTPQueue*pSSRTPQueue);
SS_SHORT  SS_RTPQueue_ReadData(
    IN SSRTPQueue*pSSRTPQueue,
    OUT    SS_CHAR   *psBuf,
    IN OUT SS_UINT32 *un32Size);
SS_SHORT  SS_RTPQueue_WriteData(
    IN SSRTPQueue*pSSRTPQueue,
    IN  SS_UINT32  const un32ID,
    IN  SS_CHAR const*const psBuf,
    IN  SS_UINT32  const un32BufSize);




//////////////////////////////////////////////////////////////////////////


SS_SHORT  SS_Mutex_Init(IN SS_THREAD_MUTEX_T *pMutex);
SS_SHORT  SS_Mutex_Destroy(IN SS_THREAD_MUTEX_T *pMutex);
SS_SHORT  SS_Mutex_Lock(IN SS_THREAD_MUTEX_T *pMutex);
SS_SHORT  SS_Mutex_TryLock(IN SS_THREAD_MUTEX_T *pMutex);
SS_SHORT  SS_Mutex_UnLock(IN SS_THREAD_MUTEX_T *pMutex);

int       SS_snprintf(char *str, size_t size, const char *format, ...);


SS_SHORT  SS_GetPasswordContextString(
    IN  SS_CHAR const*pUserName,
    IN  SS_CHAR const*pPassword,
    OUT SS_CHAR *pRealm,
    OUT SS_CHAR *pNonce,
    OUT SS_CHAR *pUri,
    OUT SS_CHAR *pResponse,
    OUT SS_CHAR *pCnonce,
    OUT SS_CHAR *pNc,
    OUT SS_CHAR *pQop);
SS_SHORT  SS_CheckPassword(
    IN  SS_CHAR const*pUserName,
    IN  SS_CHAR const*pPassword,
    IN  SS_CHAR const*pRealm,
    IN  SS_CHAR const*pNonce,
    IN  SS_CHAR const*pUri,
    IN  SS_CHAR const*pResponse,
    IN  SS_CHAR const*pCnonce,
    IN  SS_CHAR const*pNc,
    IN  SS_CHAR const*pQop);  




#endif // !defined(AFX_SS_H__9602DE4F_179E_44D9_97A3_97115FE6CED7__INCLUDED_)
