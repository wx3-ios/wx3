// ss.cpp: implementation of the CSS class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ss.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////




SS_SHORT  SS_TCP_Send(
    IN  SS_Socket const Handle,
    IN  SS_CHAR  const*const pString,
    IN  SS_INT32   const n32Size,
    IN  SS_INT32  const n32Flags)
{
    SS_INT32 n32SendLength=n32Size;
    SS_INT32 n32Length=0;
    SS_CHAR const*pBuf=pString;
    if (SS_SOCKET_ERROR == Handle || NULL == pString || 0 == n32Size)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Handle=%X,String=%p,Size=%u",Handle,pString,n32Size);
#endif
        return SS_ERR_PARAM;
    }
    do{
        n32SendLength = n32SendLength-n32Length;
        pBuf += n32Length;
        if (-1 == (n32Length = send(Handle,pBuf,n32SendLength,n32Flags)))
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
    } while (n32SendLength > n32Length);
    return SS_SUCCESS;
}

SS_SHORT  SS_TCP_Recv(
    IN  SS_Socket const Handle,
    OUT PSS_CHAR    psBuf,
    IN  SS_INT32 const n32Size,
    IN  SS_INT32  const n32Flags)
{
    SS_INT32  n32RecvLength = 0;
    SS_INT32  n32Length = 0;
    while(n32Length < n32Size)
    {
        if (-1 == (n32RecvLength = recv(Handle,(psBuf+n32Length),(n32Size-n32Length),n32Flags)))
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
        if (0 == n32RecvLength)
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
        n32Length += n32RecvLength;
    }    
    return SS_SUCCESS;
}

SS_SHORT  SS_TCP_RecvTimeOut(
    IN  SS_Socket const Handle,
    OUT PSS_CHAR        psBuf,
    IN  SS_INT32  const n32BufSize,
    IN  SS_INT32  const n32Flags,
    IN  SS_UINT32 const un32Second)
{
    SS_INT32  n32RecvLength = 0;
    SS_INT32  n32Length = 0;
    SS_SHORT      snRetval;
    fd_set         s_ReadSet;
    struct timeval tv;
    while(n32Length < n32BufSize)
    {
        FD_ZERO(&s_ReadSet);
        FD_SET(Handle,&s_ReadSet);
        tv.tv_sec  = un32Second;
        tv.tv_usec = 2000;
        snRetval = select(Handle+1,&s_ReadSet,NULL,NULL,&tv);
        switch(snRetval)
        {
        case 0: return SS_ERR_TIME_OUT;
        case -1:
            {
                return SS_FAILURE;
            }
            break;
        default:break;
        }
#if defined(_MSC_VER)
        if (SOCKET_ERROR == (n32RecvLength = recv(Handle,(psBuf+n32Length),(n32BufSize-n32Length),n32Flags)))
#elif defined(__GNUC__)
        if (-1           == (n32RecvLength = recv(Handle,(psBuf+n32Length),(n32BufSize-n32Length),n32Flags)))
#else
#  error "Unknown compiler."
#endif
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
        if (0 == n32RecvLength)
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
        n32Length += n32RecvLength;
    }    
    return SS_SUCCESS;
}


SS_SHORT    SS_TCP_getRemoterHostIP (
    IN  SS_CHAR const *const psHostName,
    OUT PSS_CHAR       psAddress,
    IN  size_t          BufSize)
{
    if (0 == BufSize || NULL == psHostName || NULL == psAddress)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,HostName=%p,Address=%p,Size=%u",psHostName,psAddress,BufSize);
#endif
        return SS_FAILURE;
    }
#if defined(_MSC_VER)
    WSADATA wsaData;
    in_addr addr;
    hostent* pHost=NULL;
    int nIndex=0;
    if(WSAStartup(MAKEWORD(1,1),&wsaData)!=0)//
    {
        return SS_FAILURE;
    }
    
    if(NULL==(pHost=gethostbyname(psHostName)))
    {
        WSACleanup();
        return SS_FAILURE;
    }
    
    nIndex=sizeof(pHost->h_addr_list)/sizeof(char**);
    for(nIndex=0;pHost->h_addr_list[nIndex]!=NULL;nIndex++)
    {
        memcpy(&addr,pHost->h_addr_list[nIndex],pHost->h_length);
        SS_snprintf(psAddress,BufSize,"%s",inet_ntoa(addr));
        WSACleanup();
        return SS_SUCCESS;
    }
    WSACleanup();
#elif defined(__GNUC__)
    struct hostent *myhost;
    char ** pp;
    struct in_addr addr;
    if (NULL == psHostName || NULL == psAddress || BufSize < 64)
    {
        return SS_ERR_PARAM;
    }
    if((myhost = gethostbyname(psHostName)) == NULL)
    {
        return SS_FAILURE;
    }
    pp = myhost->h_addr_list;
    while(*pp!=NULL)
    {
        addr.s_addr = *((unsigned int *)*pp);
        snprintf(psAddress,BufSize,"%s",inet_ntoa(addr));
        return SS_SUCCESS;
        pp++;
    }
#else
#  error "Unknown compiler."
#endif
    return SS_FAILURE;
}
    
SS_SHORT    SS_TCP_getLocalHostIP (
    OUT PSS_CHAR       psAddress,
    IN  size_t          BufSize)
{
    char  sHostName[255] = "";
    if (NULL == psAddress || 0 == BufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Address=%p,Size=%u",psAddress,BufSize);
#endif
        return  SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    WSADATA wsaData;
    in_addr addr;
    hostent* pHost=NULL;
    int nIndex=0;
    if(WSAStartup(MAKEWORD(1,1),&wsaData)!=0)//
    {
        return SS_FAILURE;
    }
    if(gethostname(sHostName,sizeof(sHostName))== -1)
    {
        WSACleanup();
        return SS_FAILURE;
    }
    if(NULL==(pHost=gethostbyname(sHostName)))
    {
        WSACleanup();
        return SS_FAILURE;
    }
    
    nIndex=sizeof(pHost->h_addr_list)/sizeof(char**);
    for(nIndex=0;pHost->h_addr_list[nIndex]!=NULL;nIndex++)
    {
        memcpy(&addr,pHost->h_addr_list[nIndex],pHost->h_length);
        SS_snprintf(psAddress,BufSize,"%s",inet_ntoa(addr));
        if (0 != strcmp(psAddress,"127.0.0.1"))
        {
            WSACleanup();
            return SS_SUCCESS;
        }
        
    }
    WSACleanup();
#elif defined(__GNUC__)
    struct hostent *myhost;
    char ** pp;
    struct in_addr addr;
    if (NULL == psAddress || BufSize < 64)
    {
        return SS_ERR_PARAM;
    }
    if(gethostname(sHostName,sizeof(sHostName))== -1)
    {
        return SS_FAILURE;
    }
    if((myhost = gethostbyname(sHostName)) == NULL)
    {
        return SS_FAILURE;
    }
    pp = myhost->h_addr_list;
    while(*pp!=NULL)
    {
        addr.s_addr = *((unsigned int *)*pp);
        sprintf(psAddress,"%s",inet_ntoa(addr));
        if (0 != strcmp(psAddress,"127.0.0.1"))
        {
            return SS_SUCCESS;
        }
        pp++;
    }
#else
#  error "Unknown compiler."
#endif
    return SS_FAILURE;
}
    
SS_SHORT    SS_TCP_GetLocalIPAndPort(IN SS_Socket const Handle,OUT SS_SOCKADDR_IN*s_pAddr)
{
    int length = sizeof(SS_SOCKADDR_IN);
    if (SS_SOCKET_ERROR == Handle || NULL == s_pAddr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Handle=%X,Addr=%p",Handle,s_pAddr);
#endif
        return SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    if (INVALID_SOCKET == getsockname(Handle,(SOCKADDR*)s_pAddr,&length))
#elif defined(__GNUC__)
    if (-1 == getsockname(Handle,(struct sockaddr*)s_pAddr,(socklen_t*)&length))
#else
#  error "Unknown compiler."
#endif
    {
        return SS_FAILURE;
    }
    return SS_SUCCESS;
}
SS_SHORT    SS_TCP_GetRemoterIPAndPort(IN SS_Socket const Handle,OUT SS_SOCKADDR_IN*s_pAddr)
{
    int length = sizeof(SS_SOCKADDR_IN);  
    if (SS_SOCKET_ERROR == Handle || NULL == s_pAddr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Handle=%X,Addr=%p",Handle,s_pAddr);
#endif
        return SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    if (INVALID_SOCKET == getpeername(Handle,(SOCKADDR*)s_pAddr,&length))
#elif defined(__GNUC__)
    if (-1 == getpeername(Handle,(struct sockaddr*)s_pAddr,(socklen_t*)&length))
#else
#  error "Unknown compiler."
#endif
    {
        return SS_FAILURE;
    }
    return SS_SUCCESS;
}

SS_Socket   SS_TCP_Socket()
{
#if defined(_MSC_VER)
    WSADATA     wsaData;
    if (WSAStartup(MAKEWORD(2,2),&wsaData) != 0) 
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        return SS_SOCKET_ERROR;
    }
    if (LOBYTE(wsaData.wVersion)!=2||HIBYTE(wsaData.wVersion)!=2) 
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        WSACleanup();
        return SS_SOCKET_ERROR; 
    }
#endif
    return  socket(AF_INET,SOCK_STREAM,0);//0
}
SS_Socket   SS_TCP_Connect(IN SS_CHAR const*pIP,IN SS_USHORT const usnPort)
{
    SS_SOCKADDR_IN  s_Addr;
	unsigned long   ul = 1;
	int             n32Ret=SS_FALSE;
    if (NULL == pIP || 0 == usnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IP=%p,Port=%u",pIP,usnPort);
#endif
        return SS_ERR_PARAM;
    }
    SS_Socket socket=SS_TCP_Socket();
    if (SS_SOCKET_ERROR == socket)
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        return SS_SOCKET_ERROR;
    }
/*
#if defined(_MSC_VER)
	ioctlsocket(socket, FIONBIO, &ul); //设置为非阻塞模式
#else
	ioctl(socket,FIONBIO,&ul); //设置为非阻塞模式
#endif
	*/

    memset(&s_Addr,0,sizeof(SS_SOCKADDR_IN));
#if defined(_MSC_VER)
    s_Addr.sin_addr.S_un.S_addr = inet_addr(pIP);
#elif defined(__GNUC__)
    s_Addr.sin_addr.s_addr = inet_addr(pIP);
#else
#  error "Unknown compiler."
#endif
    s_Addr.sin_family = AF_INET;
    s_Addr.sin_port   = htons(usnPort);

#if defined(_MSC_VER)
    if (SOCKET_ERROR == connect(socket,(SOCKADDR*)&(s_Addr),sizeof(SS_SOCKADDR_IN)))
#elif defined(__GNUC__)
    if (SS_SOCKET_ERROR == connect(socket,(struct sockaddr*)&(s_Addr),sizeof(SS_SOCKADDR_IN)))
#else
#  error "Unknown compiler."
#endif
	{
		int n32Error=-1;
		int n32Len;
		SS_SHORT       snRetval=0;
		struct timeval s_tv;
		fd_set set;
		s_tv.tv_sec  = 3;
		s_tv.tv_usec = 0;
		FD_ZERO(&set);
		FD_SET(socket, &set);
		SS_SLEEP(1);
		if(select(socket+1, NULL, &set, NULL, &s_tv) > 0)
		{
#if defined(_MSC_VER)
			getsockopt(socket, SOL_SOCKET, SO_ERROR,(char*)&n32Error,&n32Len);
#elif defined(__GNUC__)
			getsockopt(socket, SOL_SOCKET, SO_ERROR, &n32Error, (socklen_t *)&n32Len);
#else
#  error "Unknown compiler."
#endif
			if(n32Error == 0)
			{
				n32Ret = SS_TRUE;
			}
			else
			{
				n32Ret = SS_FALSE;
			}
		}
		else
		{
			n32Ret = SS_FALSE;
		}
	}
	else
	{
		n32Ret = SS_TRUE;
	}
	ul = 0;
	/*
#if defined(_MSC_VER)
	ioctlsocket(socket, FIONBIO, &ul); //设置为阻塞模式
#else
	ioctl(socket, FIONBIO, &ul); //设置为阻塞模式
#endif
	*/

	if (!n32Ret)
	{
		//SS_ErrorCodec(SS_LOG_ERROR);
		SS_closesocket(socket);
		return SS_SOCKET_ERROR;
	}
	return socket;
}

SS_Socket SS_TCP_Listen(IN SS_CHAR const*pIP,IN SS_USHORT const usnPort,IN SS_USHORT const usnListenNumber)
{
    SS_SOCKADDR_IN  s_Addr;
    if (NULL==pIP||0==usnPort||0==usnListenNumber)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"IP=%p,Port=%u,ListenNumber=%u",pIP,usnPort,usnListenNumber);
#endif
        return  SS_ERR_PARAM;
    }
    SS_Socket socket=SS_TCP_Socket();
    if (SS_SOCKET_ERROR == socket)
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        return SS_SOCKET_ERROR;
    }
    memset(&s_Addr,0,sizeof(SS_SOCKADDR_IN));
    SS_SetAddr(&s_Addr,pIP,usnPort);
    int flag=1,len=sizeof(int); 
    if( setsockopt(socket, SOL_SOCKET, SO_REUSEADDR,(const char*)&flag, len) == -1) 
    { 
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"setsockopt socket SO_REUSEADDR fail,%s_%u",pIP,usnPort);
#endif
        SS_closesocket(socket);
        return  SS_SOCKET_ERROR;
    } 
    if (-1 == bind(socket,(struct sockaddr*)&(s_Addr),sizeof(SS_SOCKADDR_IN)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Bind socket fail,%s_%u",pIP,usnPort);
#endif
        SS_closesocket(socket);
        return SS_SOCKET_ERROR;
    }
    if (-1 == listen(socket,usnListenNumber))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"Listen socket fail,%s_%u",pIP,usnPort);
#endif
        SS_closesocket(socket);
        return SS_SOCKET_ERROR;
    }
    return socket;
}




//////////////////////////////////////////////////////////////////////////

SS_SHORT  SS_UDP_Send(
    IN  SS_Socket const Handle,
    IN  SS_CHAR   const*const pString,
    IN  SS_INT32  const n32Size,
    IN  SS_SOCKADDR_IN *s_Addr)
{
    SS_INT32 n32SendLength=n32Size;
    SS_INT32 n32Length=0;
    SS_CHAR const*pBuf=pString;
    if (SS_SOCKET_ERROR == Handle || NULL == pString || 0 == n32Size||NULL==s_Addr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Handle=%X,Addr=%p,String=%p,Size=%u",
            Handle,s_Addr,pString,n32Size);
#endif
        return SS_ERR_PARAM;
    }
    if (0 == s_Addr->sin_port)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,s_Addr->sin_port==0");
#endif
        return SS_ERR_PARAM;
    }
    do{
        n32SendLength = n32SendLength-n32Length;
        pBuf += n32Length;
#if defined(_MSC_VER)
        if (SOCKET_ERROR == (n32Length = sendto(Handle,pBuf,n32SendLength,0,(SOCKADDR*)(s_Addr),sizeof(SS_SOCKADDR_IN))))
#elif defined(__GNUC__)
        if (-1 == (n32Length = sendto(Handle,pBuf,n32SendLength,0,(struct sockaddr*)(s_Addr),sizeof(SS_SOCKADDR_IN))))
#else
#  error "Unknown compiler."
#endif
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
    } while (n32SendLength > n32Length);
    return SS_SUCCESS;
}


SS_SHORT  SS_UDP_Send_Ex(
    IN  SS_Socket const Handle,
    IN  SS_CHAR   const*const pString,
    IN  SS_INT32  const n32Size,
    IN  SS_CHAR   const*const pIP,
    IN  SS_USHORT const usnPort)
{
    SS_SOCKADDR_IN s_Addr;
    SS_INT32 n32SendLength=n32Size;
    SS_INT32 n32Length=0;
    SS_CHAR const*pBuf=pString;
    if (SS_SOCKET_ERROR == Handle || NULL == pString || 0 == n32Size || NULL == pIP || 0 == usnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Handle=%X,String=%p,Size=%u,IP=%p,Port=%u",
            Handle,pString,n32Size,pIP,usnPort);
#endif
        return SS_ERR_PARAM;
    }

#if defined(_MSC_VER)
    s_Addr.sin_addr.S_un.S_addr = inet_addr(pIP);
#elif defined(__GNUC__)
    s_Addr.sin_addr.s_addr = inet_addr(pIP);
#else
#  error "Unknown compiler."
#endif
    s_Addr.sin_family = AF_INET;
    s_Addr.sin_port   = htons(usnPort);
    do{
        n32SendLength = n32SendLength-n32Length;
        pBuf += n32Length;
#if defined(_MSC_VER)
        if (SOCKET_ERROR == (n32Length = sendto(Handle,pBuf,n32SendLength,0,(SOCKADDR*)&(s_Addr),sizeof(SS_SOCKADDR_IN))))
#elif defined(__GNUC__)
        if (-1 == (n32Length = sendto(Handle,pBuf,n32SendLength,0,(struct sockaddr*)&(s_Addr),sizeof(SS_SOCKADDR_IN))))
#else
#  error "Unknown compiler."
#endif
        {
            //SS_ErrorCodec(SS_LOG_ERROR);
            return SS_FAILURE;
        }
    } while (n32SendLength > n32Length);
    return SS_SUCCESS;
}

SS_Socket   SS_UDP_Socket()
{
#if defined(_MSC_VER)
    WSADATA     wsaData;
    if (WSAStartup(MAKEWORD(2,2),&wsaData) != 0) 
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        return -1;
    }
    if (LOBYTE(wsaData.wVersion)!=2||HIBYTE(wsaData.wVersion)!=2) 
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        WSACleanup();
        return -1; 
    }
#endif
    return  socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
}

SS_Socket   SS_UDP_Bind(IN SS_CHAR const*const pIP,IN SS_USHORT const usnPort)
{
    SS_SOCKADDR_IN  s_Addr;
    if (NULL == pIP || 0 == usnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IP=%p,Port=%u",pIP,usnPort);
#endif
        return SS_ERR_PARAM;
    }
    SS_Socket socket = SS_UDP_Socket();
    if (SS_SOCKET_ERROR == socket)
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        return socket;
    }
    memset(&s_Addr,0,sizeof(SS_SOCKADDR_IN));
#if defined(_MSC_VER)
    s_Addr.sin_addr.S_un.S_addr = inet_addr(pIP);
#elif defined(__GNUC__)
    s_Addr.sin_addr.s_addr = inet_addr(pIP);
#else
#  error "Unknown compiler."
#endif
    s_Addr.sin_family = AF_INET;
    s_Addr.sin_port   = htons(usnPort);

    if (-1 == bind(socket,(struct sockaddr*)&s_Addr,sizeof(SS_SOCKADDR_IN)))
    {
        //SS_ErrorCodec(SS_LOG_ERROR);
        SS_closesocket(socket);
        return  SS_SOCKET_ERROR;
    }
    return  socket;
}

SS_SHORT    SS_SetAddr(IN SS_SOCKADDR_IN  *s_pAddr,IN SS_CHAR const*const pIP,IN SS_USHORT const usnPort)
{
    if (NULL == s_pAddr || NULL == pIP || 0 == usnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Addr=%p,IP=%p,Port=%u",s_pAddr,pIP,usnPort);
#endif
        return SS_ERR_PARAM;
    }
    memset(s_pAddr,0,sizeof(SS_SOCKADDR_IN));
#if defined(_MSC_VER)
    s_pAddr->sin_addr.S_un.S_addr = inet_addr(pIP);
#elif defined(__GNUC__)
    s_pAddr->sin_addr.s_addr = inet_addr(pIP);
#else
#  error "Unknown compiler."
#endif
    s_pAddr->sin_family = AF_INET;
    s_pAddr->sin_port   = htons(usnPort);
    return  SS_SUCCESS;
}



//////////////////////////////////////////////////////////////////////////


SS_SHORT  SS_GetMaxFileName(
    IN  SS_CHAR const*pPath,
    IN  SS_CHAR const*pCurName,
    OUT SS_CHAR *pMaxName,
    IN  SS_UINT32 const un32MaxNameSize)
{
    SS_CHAR     sPath[2048] = "";
    int         n32Len=0;
    SS_UINT64   un64Old=0;
    SS_UINT64   un64Cur=SS_un64_max_value;
    SS_UINT64   un64New=0;

    if (NULL == pPath || NULL == pCurName || NULL == pMaxName || 0 == un32MaxNameSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p,CurName=%p,MaxName=%p,"
            "MaxNameSize=%u",pPath,pCurName,pMaxName,un32MaxNameSize);
#endif
        return SS_ERR_PARAM;
    }
    SS_aToun64(pCurName,un64Old);
#if defined(_MSC_VER)
    CFileFind   tempFind; 
    CString     str;
    str.Format("%s\\*.*",pPath);
    BOOL IsFinded=(BOOL)tempFind.FindFile(str); 
    while(IsFinded) 
    { 
        IsFinded=(BOOL)tempFind.FindNextFile(); 
        if(!tempFind.IsDots()) 
        { 
            memset(sPath,0,sizeof(sPath));
            if(tempFind.IsDirectory()) 
            { 
                n32Len=SS_snprintf(sPath,sizeof(sPath),"%s%s\\",pPath,tempFind.GetFileName().GetBuffer(256));
                if (SS_SUCCESS == SS_GetMaxFileName(sPath,pCurName,pMaxName,un32MaxNameSize))
                {
                    tempFind.Close();
                    return SS_SUCCESS;
                }
            } 
            else 
            {
                n32Len=SS_snprintf(sPath,sizeof(sPath),"%s",tempFind.GetFileName().GetBuffer(256));
                un64New=0;
                SS_aToun64(sPath,un64New);
                if (un64New>un64Old)
                {
                    if (un64New < un64Cur)
                    {
                        un64Cur=un64New;
                        memset(pMaxName,0,un32MaxNameSize-1);
                        strncpy(pMaxName,sPath,un32MaxNameSize);
                    }
                }
            } 
        } 
    }
    tempFind.Close();
#elif defined(__GNUC__)
    DIR *dir;
    struct dirent *ptr;
    SS_VOID*addr = (SS_VOID*)0x6;
    if (addr == (SS_VOID*)(dir = opendir(pPath)))
    {
        return  SS_FAILURE;
    }
    if (NULL == dir)
    {
        return  SS_FAILURE;
    }
    while(ptr = readdir(dir))
    {
        memset(sPath,0,sizeof(sPath));
        //Ŀ¼
        if(4 == ptr->d_type)// 8 == == ptr->d_type  // �ļ�
        {
            if (0 == strcmp(ptr->d_name,"." ) || 0 == strcmp(ptr->d_name,"..") )
            {
                continue;
            }
            n32Len=SS_snprintf(sPath,sizeof(sPath),"%s%s/",pPath,ptr->d_name);
            if (SS_SUCCESS == SS_GetMaxFileName(sPath,pCurName,pMaxName,un32MaxNameSize))
            {
                closedir(dir);
                return SS_SUCCESS;
            }
        }
        else
        {
            n32Len=SS_snprintf(sPath,sizeof(sPath),"%s",ptr->d_name);
            un64New=0;
            SS_aToun64(sPath,un64New);
            if (un64New>un64Old)
            {
                if (un64New < un64Cur)
                {
                    un64Cur=un64New;
                    memset(pMaxName,0,un32MaxNameSize-1);
                    strncpy(pMaxName,sPath,un32MaxNameSize);
                }
            }
        }
    }
    closedir(dir);
#else
#endif 
    return SS_SUCCESS;
}


static SS_UINT32 SS_GetFileCountEx(IN  SS_CHAR const*pPath,OUT SS_UINT32 *un32Count)
{
    SS_CHAR     sPath[2048] = "";
    if (NULL == pPath)
    {
        return SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    CFileFind   tempFind; 
    CString     str;
    str.Format("%s\\*.*",pPath);
    BOOL IsFinded=(BOOL)tempFind.FindFile(str); 
    while(IsFinded) 
    { 
        IsFinded=(BOOL)tempFind.FindNextFile(); 
        if(!tempFind.IsDots()) 
        { 
            memset(sPath,0,sizeof(sPath));
            if(tempFind.IsDirectory()) 
            { 
                SS_snprintf(sPath,sizeof(sPath),"%s%s\\",pPath,tempFind.GetFileName().GetBuffer(256));
                SS_GetFileCountEx(sPath,un32Count);
            } 
            else 
            {
                *un32Count = *un32Count+1;
            } 
        } 
    }
    tempFind.Close();
#elif defined(__GNUC__)
    DIR *dir;
    struct dirent *ptr;
    SS_VOID*addr = (SS_VOID*)0x6;
    if (addr == (SS_VOID*)(dir = opendir(pPath)))
    {
        return  SS_FAILURE;
    }
    if (NULL == dir)
    {
        return  SS_FAILURE;
    }
    while(ptr = readdir(dir))
    {
        memset(sPath,0,sizeof(sPath));
        //Ŀ¼
        if(4 == ptr->d_type)// 8 == == ptr->d_type  // �ļ�
        {
            if (0 == strcmp(ptr->d_name,"." ) || 0 == strcmp(ptr->d_name,"..") )
            {
                continue;
            }
            SS_snprintf(sPath,sizeof(sPath),"%s%s/",pPath,ptr->d_name);
            SS_GetFileCountEx(sPath,un32Count);
        }
        else
        {
            *un32Count = *un32Count+1;
        }
    }
    closedir(dir);
#else
#endif 
    return  0;
}

SS_UINT32 SS_GetFileCount(IN  SS_CHAR const*pPath)
{
    SS_UINT32 un32Count=0;
    if (NULL == pPath)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p",pPath);
#endif
        return 0;
    }
    SS_GetFileCountEx(pPath,&un32Count);
    return  un32Count;
}


SS_UINT32  SS_GetLastError()
{
    return errno;
}

SS_SHORT  SS_Rename(
        IN SS_CHAR const*const psOldName,
        IN SS_CHAR const*const psNewName)
{
    if (NULL == psOldName || NULL == psNewName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,OldName=%p,NewName=%p",psOldName,psNewName);
#endif
        return SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    if (!::rename(psOldName,psNewName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    if (!rename(psOldName,psNewName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#else
#endif 
    return SS_SUCCESS;
}
SS_SHORT  SS_DeleteDir(IN SS_CHAR const*const psDirName)
{
    if (NULL == psDirName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p",psDirName);
#endif
        return 0;
    }
#if defined(_MSC_VER)
    if (::RemoveDirectory(psDirName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    if (!rmdir(psDirName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#endif 
    return SS_SUCCESS;
}
SS_SHORT  SS_DeleteFile(IN SS_CHAR const*const psFileName)
{
    if (NULL == psFileName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p",psFileName);
#endif
        return 0;
    }
#if defined(_MSC_VER)
    if (::DeleteFile(psFileName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    if (-1 == remove(psFileName))
    {
        return  SS_FAILURE;
    }
#else
#endif 
    return SS_SUCCESS;
}
SS_SHORT  SS_CopyFile(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName)
{
    if (NULL == psSourceFileName || NULL == psDestinationFileName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SourceFileName=%p,"
            "DestinationFileName=%p",psSourceFileName,psDestinationFileName);
#endif
        return  SS_FAILURE;
    }
#if defined(_MSC_VER)
    if (::CopyFile(psSourceFileName,psDestinationFileName,FALSE))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    FILE *fp_r = NULL;
    FILE *fp_w = NULL;
    SS_CHAR     sBuf[4096] = "";
    SS_UINT32   un32Size=0;
    if (NULL == (fp_r = fopen(psSourceFileName,"rb")))
    {
        return  SS_FAILURE;
    }
    if (NULL == (fp_w = fopen(psDestinationFileName,"wb")))
    {
        fclose(fp_r);
        return  SS_FAILURE;
    }
    un32Size=fread(sBuf,1,4096,fp_r);
    while(0 != un32Size)
    {
        fwrite(sBuf,1,un32Size,fp_w);
        un32Size=fread(sBuf,1,4096,fp_r);
    }
    fclose(fp_r);
    fclose(fp_w);
#else
#endif 
    return SS_SUCCESS;
}

SS_SHORT  SS_MoveFile(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName)
{
    if (NULL == psSourceFileName || NULL == psDestinationFileName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SourceFileName=%p,"
            "DestinationFileName=%p",psSourceFileName,psDestinationFileName);
#endif
        return  SS_FAILURE;
    }
#if defined(_MSC_VER)
    if (::MoveFile(psSourceFileName,psDestinationFileName))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    if (SS_SUCCESS != SS_CopyFile(psSourceFileName,psDestinationFileName))
    {
        return SS_FAILURE;
    }
    if (SS_SUCCESS != SS_DeleteFile(psSourceFileName))
    {
        return SS_FAILURE;
    }
#else
#endif 
    return  SS_SUCCESS;
}
SS_SHORT  SS_CopyDirectory(
        IN SS_CHAR const*const psSourcePathName,
        IN SS_CHAR const*const psDestinationPathName)
{
    SS_BYTE    ubCreateDirectoryFlag=0;
    if (NULL == psSourcePathName || NULL == psDestinationPathName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SourcePathName=%p,"
            "DestinationPathName=%p",psSourcePathName,psDestinationPathName);
#endif
        return  SS_FAILURE;
    }
#if defined(_MSC_VER)
    CFileFind   tempFind; 
    CString     Source;
    CString     Destination;
    CString     str;

    str.Format("%s\\*.*",psSourcePathName);
    BOOL IsFinded=(BOOL)tempFind.FindFile(str); 
    
    while(IsFinded) 
    { 
        IsFinded=(BOOL)tempFind.FindNextFile(); 
        if(!tempFind.IsDots()) 
        { 
            Source.Empty();
            Source.Format("%s\\%s",psSourcePathName,
                tempFind.GetFileName().GetBuffer(256));
            
            Destination.Empty();
            Destination.Format("%s\\%s",psDestinationPathName,
                    tempFind.GetFileName().GetBuffer(256));
            if(tempFind.IsDirectory()) 
            { 
                SS_CreateDirectory(Destination.GetBuffer(0));
                SS_CopyDirectory(Source.GetBuffer(0),Destination.GetBuffer(0));
            } 
            else 
            { 
                ::CopyFile(Source,Destination,FALSE);
            } 
        } 
    }
    tempFind.Close(); 
#elif defined(__GNUC__)
    DIR *dir;
    struct dirent *ptr;
    SS_VOID*addr = (SS_VOID*)0x6;
    if (addr == (SS_VOID*)(dir = opendir(psSourcePathName)))
    {
        return  SS_FAILURE;
    }
    if (NULL == dir)
    {
        return  SS_FAILURE;
    }
    char  sSource[2048] = "";
    char  sDestination[2048] = "";

    while((ptr = readdir(dir)) != NULL)
    {
        memset(sSource,0,sizeof(sSource));
        memset(sDestination,0,sizeof(sDestination));
        //Ŀ¼
        if(4 == ptr->d_type)// 8 == == ptr->d_type  // �ļ�
        {
            if (0 == strcmp(ptr->d_name,"." ) ||
                0 == strcmp(ptr->d_name,"..") )
            {
                continue;
            }
            sprintf(sSource     ,"%s/%s",psSourcePathName,ptr->d_name);
            sprintf(sDestination,"%s/%s",psDestinationPathName,ptr->d_name);
            SS_CreateDirectory(sDestination);
            SS_CopyDirectory(sSource,sDestination);
        }
        else
        {
            /*if (!ubCreateDirectoryFlag)
            {
                SS_CreateDirectory(psDestinationPathName);
                ubCreateDirectoryFlag = 1;
            }*/
            sprintf(sSource     ,"%s/%s",psSourcePathName,ptr->d_name);
            sprintf(sDestination,"%s/%s",psDestinationPathName,ptr->d_name);
            if (SS_FAILURE == SS_CopyFile(sSource,sDestination))
            {
                return  SS_FAILURE;
            }
        }
    }
    closedir(dir);
#else
#endif 
    return SS_SUCCESS;
}

SS_SHORT  SS_MoveDirectory(
        IN SS_CHAR const*const psSourceFileName,
        IN SS_CHAR const*const psDestinationFileName)
{
    if (NULL == psSourceFileName || NULL == psDestinationFileName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SourceFileName=%p,"
            "DestinationFileName=%p",psSourceFileName,psDestinationFileName);
#endif
        return  SS_FAILURE;
    }
    if (SS_SUCCESS != SS_CopyDirectory(psSourceFileName,psDestinationFileName))
    {
        return SS_FAILURE;
    }
    if (SS_SUCCESS != SS_DeleteDirectory(psSourceFileName))
    {
        return SS_FAILURE;
    }
    return  SS_SUCCESS;
}
SS_SHORT  SS_DeleteDirectoryFiles(IN SS_CHAR const*const psDirName,IN SS_CHAR const*const psFileName)
{
	if (NULL == psDirName||NULL==psFileName)
	{
#ifdef  IT_LIB_DEBUG
		SS_Log_Printf(SS_ERROR_LOG,"param error,psDirName=%p,FileName=%p",psDirName,psFileName);
#endif
		return  SS_ERR_PARAM;
	}
	SS_UINT32 un32len=strlen(psFileName);
#if defined(_MSC_VER)
	CFileFind tempFind;
	CString   TempFile;
	TempFile.Format("%s\\*.*",psDirName);
	BOOL IsFinded = tempFind.FindFile(TempFile);
	while (IsFinded)
	{
		IsFinded = tempFind.FindNextFile();

		if (!tempFind.IsDots())
		{            
			if (tempFind.IsDirectory())
			{
				TempFile.Empty();
				TempFile.Format("%s\\%s",psDirName,tempFind.GetFileName().GetBuffer(200));
				SS_DeleteDirectoryFiles(TempFile.GetBuffer(0),psFileName);
			}
			else
			{
				if (0==strncmp(tempFind.GetFileName().GetBuffer(200),psFileName,un32len))
				{
					TempFile.Empty();
					TempFile.Format("%s\\%s",psDirName,tempFind.GetFileName().GetBuffer(200));
					::SetFileAttributes(TempFile,FILE_ATTRIBUTE_ARCHIVE);
					::DeleteFile(TempFile);
				}
			}
		}
	}
	tempFind.Close();
#elif defined(__GNUC__)
	DIR *dir;
	struct dirent *ptr;
	char  sBuf[4096] = "";
	if (NULL == (dir = opendir(psDirName)))
	{
		return  SS_ERR_ACTION;
	}
	while((ptr = readdir(dir)) != NULL)
	{
		memset(sBuf,0,sizeof(sBuf));
		//
		if(4 == ptr->d_type)// 8 == == ptr->d_type  //
		{
			if (0 == strcmp(ptr->d_name,"." ) || 0 == strcmp(ptr->d_name,".."))
			{
				continue;
			}
			snprintf(sBuf,sizeof(sBuf),"%s/%s",psDirName,ptr->d_name);
			SS_DeleteDirectoryFiles(sBuf,psFileName);
		}
		else
		{
			if (0==strncmp(ptr->d_name,psFileName,un32len))
			{
				snprintf(sBuf,sizeof(sBuf),"%s/%s",psDirName,ptr->d_name);
				if (-1 == remove(sBuf))
				{
					return  SS_FAILURE;
					//printf("move file failure : %s\n", ptr->d_name);
				}
			}
		}
	}
	closedir(dir);
#else
#endif 
	return SS_SUCCESS;
}

SS_SHORT  SS_DeleteDirectory(IN SS_CHAR const*const psDirName)
{
    if (NULL == psDirName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,psDirName=%p",psDirName);
#endif
        return  SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    CFileFind tempFind;
    CString   TempFile;
    TempFile.Format("%s\\*.*",psDirName);
    BOOL IsFinded = tempFind.FindFile(TempFile);
    while (IsFinded)
    {
        IsFinded = tempFind.FindNextFile();

        if (!tempFind.IsDots())
        {            
            if (tempFind.IsDirectory())
            {
                TempFile.Empty();
                TempFile.Format("%s\\%s",psDirName,tempFind.GetFileName().GetBuffer(200));
                SS_DeleteDirectory(TempFile.GetBuffer(0));
            }
            else
            {
                TempFile.Empty();
                TempFile.Format("%s\\%s",psDirName,tempFind.GetFileName().GetBuffer(200));
                ::SetFileAttributes(TempFile,FILE_ATTRIBUTE_ARCHIVE);
                ::DeleteFile(TempFile);
            }
        }
    }
    tempFind.Close();
    if(!::RemoveDirectory(psDirName))
    {
        return SS_FAILURE;
    }
    return SS_SUCCESS;
#elif defined(__GNUC__)
    DIR *dir;
    struct dirent *ptr;
	char  sBuf[4096] = "";
	if (NULL == (dir = opendir(psDirName)))
	{
		return  SS_ERR_ACTION;
	}
    while((ptr = readdir(dir)) != NULL)
    {
        memset(sBuf,0,sizeof(sBuf));
        //
        if(4 == ptr->d_type)// 8 == == ptr->d_type  //
        {
            if (0 == strcmp(ptr->d_name,"." ) ||
                0 == strcmp(ptr->d_name,"..") )
            {
                continue;
            }
            snprintf(sBuf,sizeof(sBuf),"%s/%s",psDirName,ptr->d_name);
            SS_DeleteDirectory(sBuf);
        }
        else
        {
            snprintf(sBuf,sizeof(sBuf),"%s/%s",psDirName,ptr->d_name);
            if (-1 == remove(sBuf))
            {
                return  SS_FAILURE;
                //printf("move file failure : %s\n", ptr->d_name);
            }
        }
    }
    closedir(dir);
    if (-1 == remove(psDirName))
    {
        return  SS_FAILURE;
        //printf("move dir failure : %s\n", pPath);
        //printf("%s\n",strerror(errno));
    }
#else
#endif 
    return SS_SUCCESS;
}
SS_SHORT  SS_CreateDirectory(IN SS_CHAR const*const psPathName)
{
    if (NULL == psPathName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,PathName=%p",psPathName);
#endif
        return  SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    if (0 != ::CreateDirectory(psPathName,NULL))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#elif defined(__GNUC__)
    if (0 == mkdir(psPathName,0755))
    {
        return SS_SUCCESS;
    }
    else
    {
        return SS_FAILURE;
    }
#else
#endif 
    return SS_FAILURE;
}
SS_SHORT  SS_GetFileSize(
        IN  SS_CHAR  const*const psFilePathName,
        OUT SS_UINT32             *un32FileSize)
{
    FILE *fp = NULL;    
    if (NULL == psFilePathName || NULL == un32FileSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,FilePathName=%p,FileSize=%p",psFilePathName,un32FileSize);
#endif
        return  SS_ERR_PARAM;
    }
    *un32FileSize = 0;
        if (NULL == (fp = fopen(psFilePathName,"rb")))
        {
            return SS_FAILURE;
        }
        fseek(fp,0,SEEK_END);
        *un32FileSize = ftell(fp);
        fclose(fp);
    return SS_SUCCESS;
}
SS_SHORT   SS_CreatePathFolder(
        IN  SS_CHAR  const*const psFilePathName,
        IN  SS_UINT32       const un32FileSize)
{
    SS_UINT32 un32=0;
    SS_CHAR   sPath[1024] = "";
    if (NULL == psFilePathName || un32FileSize < 3 || un32FileSize >= sizeof(sPath))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,PathName=%p,FileSize=%u,%u",
            psFilePathName,un32FileSize,sizeof(sPath));
#endif
        return  SS_ERR_PARAM;
    }
#if defined(_MSC_VER)
    //C:\aa\bb\cc.txt
    // .\aa\bb\cc.exe
    if ('.' == psFilePathName[0])
    {
        sPath[0] = psFilePathName[0];
        sPath[1] = psFilePathName[1];
        un32=2;
    }
    else
    {
        sPath[0] = psFilePathName[0];
        sPath[1] = psFilePathName[1];
        sPath[2] = psFilePathName[2];
        un32=3;
    }
    for (un32;un32<un32FileSize;un32++)
    {
        if ('\\' == psFilePathName[un32])
        {
            ::CreateDirectory(sPath,NULL);
        }
        sPath[un32] = psFilePathName[un32];
    }
#elif defined(__GNUC__)
    //./aa/bb/cc.cpp
    // /temp/aa/bb/cc.bak
    if ('.' == psFilePathName[0])
    {
        sPath[0] = psFilePathName[0];
        sPath[1] = psFilePathName[1];
        un32 = 2;
    }
    else
    {
        sPath[0] = psFilePathName[0];
        un32=1;
    }
    for (un32;un32<un32FileSize;un32++)
    {
        if ('/' == psFilePathName[un32])
        {
            mkdir(sPath,0755);
        }
        sPath[un32] = psFilePathName[un32];
    }
#else
#endif
    return  SS_SUCCESS;
}

SS_BYTE SS_GetOSBit()
{
#if defined(_MSC_VER)
    typedef BOOL (WINAPI *LPFN_ISWOW64PROCESS) (HANDLE, PBOOL);
    LPFN_ISWOW64PROCESS fnIsWow64Process;
    BOOL bIsWow64 = FALSE;
    fnIsWow64Process = (LPFN_ISWOW64PROCESS)GetProcAddress( GetModuleHandle("kernel32"),"IsWow64Process");
    if (NULL != fnIsWow64Process)
    {
        fnIsWow64Process(GetCurrentProcess(),&bIsWow64);
    }
    if (bIsWow64)
    {
        return OS_WIN_64;
    }
    else
    {
        return OS_WIN_32;
    }
    return OS_WIN_32;
#elif defined(__GNUC__)
    struct utsname testbuff;
    int fb=0;

    fb=uname(&testbuff);
    if(fb<0)
    {
        return OS_LINUX_32;
    }else
    {
        if (0 == strncmp(testbuff.machine,"x86_64",6))
        {
            return OS_LINUX_64;
        }
        else
        {
            return OS_LINUX_32;
        }
        /*printf(" sysname:%s\n nodename:%s\n release:%s\n version:%s\n machine:%s\n \n ",\
            testbuff.sysname,\
            testbuff.nodename,\
            testbuff.release,\
            testbuff.version,\
            testbuff.machine);*/
    }
    return OS_LINUX_32;
#else
    return 250;
#endif
}

//////////////////////////////////////////////////////////////////////////

SS_SHORT SS_IfMoney(IN SS_CHAR const *pMoney)
{
    SS_BYTE ubPoint = 0;
    if (NULL == pMoney)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pMoney=%p",pMoney);
#endif
        return SS_ERR_PARAM;
    }
    if ('-' == *pMoney)
    {
        pMoney++;
    }
    if ('.' == *pMoney)
    {
        return  SS_FAILURE;
    }
    while('\0' != *pMoney)
    {
        switch (*pMoney)
        {
        case '.':
            {
                ubPoint++;
                if (ubPoint > 1)
                {
                    return SS_FAILURE;
                }
            }break;
        case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
            {
            }break;
        default:
            {
                return SS_FAILURE;
            }break;
        }
        pMoney++;
    }
    return  SS_SUCCESS;
}

SS_SHORT SS_IfAndAppendPathEndSymbol(SS_str *s_pstr)
{
    if (NULL == s_pstr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str=%p",s_pstr);
#endif
        return SS_ERR_PARAM;
    }
    if (NULL == s_pstr->m_s || 0 == s_pstr->m_len)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str->m_s=%p,str->m_len=%u",s_pstr->m_s,s_pstr->m_len);
#endif
        return SS_ERR_PARAM;
    }
    if (s_pstr->m_len >= 2)
    {
        if ('\\' == s_pstr->m_s[s_pstr->m_len-1] || '/'  == s_pstr->m_s[s_pstr->m_len-1])
        {
        }
        else
        {
#ifdef  WIN32
            s_pstr->m_s[s_pstr->m_len]='\\';
#else
            s_pstr->m_s[s_pstr->m_len]='/';
#endif
            s_pstr->m_s[s_pstr->m_len+1] = 0;
            s_pstr->m_len++;
        }
    }
    return  SS_SUCCESS;
}


SS_SHORT SS_String_IfStrNumber(IN SS_CHAR const * pStr)
{
    if (NULL == pStr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str=%p",pStr);
#endif
        return SS_ERR_PARAM;
    }
    while(*pStr != '\0')
    {
        if(*pStr < '0' || *pStr > '9')
        {
            return SS_FAILURE;
        }
        pStr++;
    }
    return SS_SUCCESS;
}
SS_SHORT SS_String_CheckPhoneNumber(IN SS_CHAR const * pPhone)
{
	if (NULL == pPhone)
	{
		return SS_ERR_PARAM;
	}
	if (0 == strlen(pPhone))
	{
		return SS_ERR_PARAM;
	}
	if(*pPhone < '0' || *pPhone > '9')
	{
		if ('+' != *pPhone)
		{
			return SS_ERR_PARAM;
		}
	}
	if (SS_SUCCESS != SS_String_IfStrNumber(pPhone+1))
	{
		return SS_ERR_PARAM;
	}
	return SS_SUCCESS;
}
SS_SHORT SS_CheckCacheTime(IN SS_UINT32  const un32Time,IN SS_UINT32 const un32CheckDay)
{
	SS_UINT32 un32NewTime=0;
	SS_UINT32 un32NewDay=0;
	SS_UINT32 un32Day=0;
	SS_GET_SECONDS(un32NewTime);
	un32NewDay = (0 == un32NewTime)?0:un32NewTime/60/60/24;
	un32Day    = (0 == un32Time   )?0:un32Time/60/60/24;
	return  ((un32NewDay-un32Day)>=un32CheckDay)?SS_SUCCESS:SS_FAILURE;
}


SS_SHORT SS_String_UIntToIPv4(IN SS_UINT32 const un32IP,OUT PSS_CHAR   psIP,IN size_t IPSize)
{
    SS_BYTE ub1,ub2,ub3,ub4;
    if (NULL == psIP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IP=%p",psIP);
#endif
        return SS_ERR_PARAM;
    }
    ub1 = (SS_BYTE)un32IP;
    ub2 = (SS_BYTE)(un32IP >> 8);
    ub3 = (SS_BYTE)(un32IP >> 16);
    ub4 = (SS_BYTE)(un32IP >> 24);
#ifdef  WIN32
    sprintf(psIP,"%d.%d.%d.%d",ub1,ub2,ub3,ub4);
#else
    snprintf(psIP,IPSize,"%d.%d.%d.%d",ub1,ub2,ub3,ub4);
#endif
    return SS_SUCCESS;
}
  SS_SHORT SS_String_IPv4ToUInt(IN SS_CHAR const *const psIP,  OUT PSS_UINT32 pun32IP)
{
    SS_BYTE   ub1=0,ub2=0,ub3=0,ub4=0;
    SS_CHAR   sBuf[5] = "";
    SS_CHAR const *p= NULL;
    if (NULL == psIP || NULL == pun32IP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IP=%p,pun32IP=%p",psIP,pun32IP);
#endif
        return SS_ERR_PARAM;
    }
    memcpy(sBuf,psIP,SS_String_ChLength(psIP,'.')); 
    ub1 = atoi(sBuf);
    p= strchr(psIP,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    memcpy(sBuf,p,SS_String_ChLength(p,'.')); 
    ub2 = atoi(sBuf);
    p= strchr(p,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    memcpy(sBuf,p,SS_String_ChLength(p,'.')); 
    ub3 = atoi(sBuf);
    p= strchr(p,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    SS_strncpy(sBuf,p,sizeof(sBuf)); 
    ub4 = atoi(sBuf);
    *pun32IP = (SS_UINT32)(ub4<<24)+(SS_UINT32)(ub3<<16)+(SS_UINT32)(ub2<<8)+ub1;

    return SS_SUCCESS;
}

  SS_SHORT SS_String_UshortToByte(IN  SS_USHORT const  usnPort,
                                     OUT PSS_BYTE         pub1,
                                     OUT PSS_BYTE         pub2)
{
    *pub1 = (SS_BYTE)(usnPort>>8);
    *pub2 = (SS_BYTE)usnPort;
    return SS_SUCCESS;
}
  SS_SHORT SS_String_ByteToUshort(IN  SS_BYTE const  ub1,
                                     IN  SS_BYTE const  ub2,
                                     OUT PSS_USHORT     pusnPort)
{
    *pusnPort = (SS_USHORT)(ub1<<8)+(SS_USHORT)(ub2);
    return SS_SUCCESS;
}
  SS_SHORT SS_String_IPv4ToByte(IN  const PSS_CHAR     psIP,
                                   OUT PSS_BYTE pub1,
                                   OUT PSS_BYTE pub2,
                                   OUT PSS_BYTE pub3,
                                   OUT PSS_BYTE pub4)
{
    SS_CHAR  sBuf[5] = "";
    SS_CHAR *p= NULL;
    if(NULL == psIP )
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IP=%p",psIP);
#endif
        return 0;
    }
    memcpy(sBuf,psIP,SS_String_ChLength(psIP,'.')); 
    *pub1 = atoi(sBuf);
    p= strchr(psIP,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    memcpy(sBuf,p,SS_String_ChLength(p,'.')); 
    *pub2 = atoi(sBuf);
    p= strchr(p,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    memcpy(sBuf,p,SS_String_ChLength(p,'.')); 
    *pub3 = atoi(sBuf);
    p= strchr(p,'.');
    p++;

    memset(sBuf,0,sizeof(sBuf));    
    SS_strncpy(sBuf,p,sizeof(sBuf)); 
    *pub4 = atoi(sBuf);
    return SS_SUCCESS;
}
  SS_SHORT SS_String_ByteToIPv4(IN  SS_BYTE const ub1,
                                   IN  SS_BYTE const ub2,
                                   IN  SS_BYTE const ub3,
                                   IN  SS_BYTE const ub4,
                                   OUT PSS_CHAR  psIP,
                                   IN size_t IPSize)
{
#ifdef  WIN32
      sprintf(psIP,"%d.%d.%d.%d",ub1,ub2,ub3,ub4);
#else
    snprintf(psIP,IPSize,"%d.%d.%d.%d",ub1,ub2,ub3,ub4);
#endif
    return SS_SUCCESS;
}


  SS_INT32 SS_String_GetStringCharNumber(
    IN SS_CHAR const * psStr,
    IN SS_CHAR const  ch)
{
    SS_INT32 n32 = 0;
    if (NULL == psStr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Str=%p",psStr);
#endif
        return 0;
    }
    while('\0' != *psStr)
    {
        if(ch == *psStr)
        {
            n32++;
        }
        psStr++;
    }
    return n32;
}


SS_SHORT        SS_String_IfIPv4Address(IN SS_CHAR const *const  IPAddress)
{
    SS_CHAR  p[24] = "";
    if (NULL == IPAddress)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IPAddress=%p",IPAddress);
#endif
        return SS_ERR_PARAM;
    }
    if(3 != SS_String_GetStringCharNumber(IPAddress,'.'))
    {
        return SS_FAILURE;
    }
    SS_strncpy(p,IPAddress,sizeof(p));
    SS_String_DeleteChar(p,'.');
    if (SS_FAILURE == SS_String_IfStrNumber(p))
    {
        return SS_FAILURE;
    }
    return SS_SUCCESS;
}
SS_SHORT SS_String_IfHexNumber(IN SS_CHAR const * pHex)
{
    if (NULL == pHex)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Hex=%p",pHex);
#endif
        return SS_ERR_PARAM;
    }
    while(*pHex != '\0')
    {
        switch(*pHex)
        {
        case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
        case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
        case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
            {
            }break;
        default:
            {
                return SS_FAILURE;
            }
        }
        pHex++;
    }
    return SS_SUCCESS;
}
SS_SHORT SS_String_IfMACAddress(IN SS_CHAR const *const  MACAddress)
{
    SS_CHAR  p[24] = "";
    if (NULL == MACAddress)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,MACAddress=%p",MACAddress);
#endif
        return SS_FAILURE;
    }
    if(5 != SS_String_GetStringCharNumber(MACAddress,':'))
    {
        return SS_FAILURE;
    }
    SS_strncpy(p,MACAddress,sizeof(p));
    SS_String_DeleteChar(p,':');
    if (SS_FAILURE == SS_String_IfHexNumber(p))
    {
        return SS_FAILURE;
    }
    return SS_SUCCESS;
}

const SS_CHAR  *SS_String_GetIPv4AddreCSString(
        IN SS_CHAR const *const pStr,
        OUT SS_CHAR *pIPAddress,
        IN  size_t    IPAddressSize)
{
    SS_INT32 x=0,DotNumber=0,IPNumber=0,sIpNumber=0,j=0,Nonlicet = 0,Last=0,Number=0,Spacing = 0;
    SS_CHAR sBuf[64] = "";
    SS_CHAR sIp[6] = "";
    if (NULL == pStr || NULL == pIPAddress)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Str=%p,IPAddress=%p",pStr,pIPAddress);
#endif
        return "null";
    }
    while(1)
    {
        if('\0' == pStr[x])
        {
            break;
        }
        if('.' == pStr[x])
        {
            Nonlicet = 0;
            Last     = 0;
            if(isdigit(pStr[x-1]))
            {
                Last++;
                if(isdigit(pStr[x-2]))
                {
                    Last++;
                    if(isdigit(pStr[x-3]))
                    {
                        Last++;
                        sIp[sIpNumber++] = pStr[x-3];
                    }
                    else if(0 == DotNumber)
                    {
                    }
                    else if(0 < DotNumber && DotNumber < 3)
                    {
                        if('.' == pStr[x-3])
                        {
                        }
                        else
                        {
                            Nonlicet = 1;
                            DotNumber= 0;
                            IPNumber = 0;
                            sIpNumber= 0;
                            memset(sBuf,0,sizeof(sBuf));
                            memset(sIp,0,sizeof(sIp));
                        }
                    }
                    if(!Nonlicet)
                    {
                        sIp[sIpNumber++] = pStr[x-2];
                    }
                }
                else if ('.' == pStr[x-2])
                {
                }
                else
                {
                    if (DotNumber > 0)
                    {
                        Nonlicet = 1;
                        DotNumber= 0;
                        IPNumber = 0;
                        sIpNumber= 0;
                        memset(sBuf,0,sizeof(sBuf));
                        memset(sIp,0,sizeof(sIp));
                    }

                }
                if(!Nonlicet)
                {
                    j = 1;
                    sIp[sIpNumber++] = pStr[x-1];
                }
                Number = atoi(sIp);

                if(Number >= 256)
                {
                    Nonlicet = 1;
                    DotNumber= 0;
                    IPNumber = 0;
                    sIpNumber= 0;
                    memset(sBuf,0,sizeof(sBuf));
                    memset(sIp,0,sizeof(sIp));
                }
                else
                {
                    if (Last>0)
                    {
                        sBuf[IPNumber++] = sIp[0];
                    }
                    if (Last>1)
                    {
                        sBuf[IPNumber++] = sIp[1];
                    }
                    if (Last>2)
                    {
                        sBuf[IPNumber++] = sIp[2];
                    }
                    sBuf[IPNumber++] = pStr[x];
                    sIpNumber= 0;
                    memset(sIp,0,sizeof(sIp));
                    Number = 0;
                    Spacing = x;
                }

            }
            else
            {
                x++;
                if ((x - Spacing)>4 && DotNumber<3)
                {
                    Nonlicet = 1;
                    DotNumber= 0;
                    IPNumber = 0;
                    sIpNumber= 0;
                    memset(sBuf,0,sizeof(sBuf));
                    memset(sIp,0,sizeof(sIp));
                }
                continue;
            }
            if(!Nonlicet)
            {
                if(1 == j)
                {
                    j = 0;
                    DotNumber++;
                }
                if ((x - Spacing)>4 && DotNumber<3)
                {
                    Nonlicet = 1;
                    DotNumber= 0;
                    IPNumber = 0;
                    sIpNumber= 0;
                    memset(sBuf,0,sizeof(sBuf));
                    memset(sIp,0,sizeof(sIp));
                }
                if(3 == DotNumber)
                {
                    Nonlicet = 0;
                    Last     = 0;
                    if(isdigit(pStr[x+1]))
                    {
                        Last++;
                        sIp[sIpNumber++] = pStr[x+1];
                        if(isdigit(pStr[x+2]))
                        {
                            Last++;
                            sIp[sIpNumber++] = pStr[x+2];
                            if(isdigit(pStr[x+3]))
                            {
                                Last++;
                                sIp[sIpNumber++] = pStr[x+3];
                            }

                        }
                        Number = atoi(sIp);
                        if(Number >= 256)
                        {
                            Nonlicet = 1;
                            DotNumber= 0;
                            IPNumber = 0;
                            sIpNumber= 0;
                            memset(sBuf,0,sizeof(sBuf));
                            memset(sIp,0,sizeof(sIp));
                        }
                        else
                        {
                            if (Last>0)
                            {
                                sBuf[IPNumber++] = sIp[0];
                            }
                            if (Last>1)
                            {
                                sBuf[IPNumber++] = sIp[1];
                            }
                            if (Last>2)
                            {
                                sBuf[IPNumber++] = sIp[2];
                            }
                            sIpNumber= 0;
                            memset(sIp,0,sizeof(sIp));
                            Number = 0;
                            Spacing = x;
                        }

                    }
                    else
                    {
                        x++;
                        Nonlicet = 1;
                        DotNumber= 0;
                        IPNumber = 0;
                        sIpNumber= 0;
                        memset(sBuf,0,sizeof(sBuf));
                        memset(sIp,0,sizeof(sIp));
                        continue;
                    }

                }
                if(DotNumber>=4)
                {
                    Nonlicet = 1;
                    DotNumber= 0;
                    IPNumber = 0;
                    sIpNumber= 0;
                    memset(sBuf,0,sizeof(sBuf));
                    memset(sIp,0,sizeof(sIp));
                }
            }
        }
        else
        {
            if ((x - Spacing)>4 && DotNumber<3)
            {
                Nonlicet = 1;
                DotNumber= 0;
                IPNumber = 0;
                sIpNumber= 0;
                memset(sBuf,0,sizeof(sBuf));
                memset(sIp,0,sizeof(sIp));
            }
        }
        x++;
    }
    if ((strlen(sBuf))< 7  || (strlen(sBuf)) >15)
    {
        return  pIPAddress;
    }
    SS_strncpy(pIPAddress,sBuf,IPAddressSize);
    return pIPAddress;
}


SS_CHAR const * SS_String_ChrReplace(
        IN OUT PSS_CHAR      psSource, 
        IN     SS_CHAR const sub, 
        IN     SS_CHAR const rep)
{
    SS_CHAR *p = psSource;
    if (NULL == psSource)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,psSource=%p",psSource);
#endif
        return "";
    }
    while('\0' != *p)
    {
        if(*p == sub)
        {
            *p = rep;
        }
        p++;
    }
    return psSource;
}

SS_UINT32  SS_String_ChLength(IN SS_CHAR const *pString, IN const SS_CHAR cEndCharacterFlag)
{
    SS_UINT32 un32Length = 0;
    SS_BYTE  buFlag    = 0;
    if (NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p",pString);
#endif
        return 0;
    }
    while('\0' != *pString)
    {
        if((*(SS_BYTE*)pString) == ((SS_BYTE)cEndCharacterFlag))
        {
            buFlag = 1;
            break;
        }
        pString++;
        un32Length++;
    }
    if(buFlag)
    {
        return un32Length;
    }
    return 0;
}
SS_UINT32 SS_String_StrLength(IN const SS_CHAR *pString, IN const SS_CHAR *pEndStringFlag)
{
    SS_CHAR const *pEndStr  = NULL;
    if (NULL == pString || NULL == pEndStringFlag)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,EndStringFlag=%p",pString,pEndStringFlag);
#endif
        return 0;
    }
    pEndStr  = strstr(pString,pEndStringFlag);
    if (NULL == pEndStr)
    {
        return 0;
    }
    return pEndStr-pString;
}

const SS_CHAR  * SS_String_UpperCase(IN OUT SS_CHAR *pStr)
{
    PSS_CHAR p1 = pStr; 
    if (NULL == pStr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Str=%p",pStr);
#endif
        return "";
    }  
    while ('\0' != *p1)
    {
        if (*p1 >= 'a' && *p1 <= 'z')
        {
            *p1 = *p1-32;
            p1++;
            continue;
        }
        p1++;
    }
    return pStr;
}

const SS_CHAR  * SS_String_LowerCase(IN OUT SS_CHAR *pStr)      
{
    PSS_CHAR p1 = pStr; 
    if (NULL == pStr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Str=%p",pStr);
#endif
        return "";
    }  
    while ('\0' != *p1)
    {
        if (*p1 >= 'A' && *p1 <= 'Z')
        {
            *p1 = *p1+32;
            p1++;
            continue;
        }
        p1++;
    }
    return pStr;
}   

const SS_CHAR  * SS_String_HexCase(
    IN  SS_CHAR const *const  pstr1,
    IN  SS_INT32 const lnLength,
    OUT SS_CHAR       *pStr2,
    IN  size_t          StrSize) 
{
    int a=0;
    SS_CHAR * p = pStr2;
    if (NULL == pstr1 || NULL == pStr2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str1=%p,str2=%p",pstr1,pStr2);
#endif
        return "";
    }  
    for (a=0;a<lnLength;a++)
    {
        if (!((a)%16))
        {
            *pStr2 = '\n';
            pStr2++;
        }
        if (!((a)%8) && ((a)%16))
        {
            *pStr2 = ' ';
            pStr2++;
            *pStr2 = ' ';
            pStr2++;
        }
        if (*(SS_BYTE*)(pstr1+a) <= 0)
        {
            *pStr2 = '0';
            pStr2++;
            *pStr2 = '0';
            pStr2++;
        }
        else if (*(SS_BYTE*)(pstr1+a) <= 15)
        {
            *pStr2 = '0';
            pStr2++;
#ifdef  WIN32
            sprintf((pStr2),"%x",*(SS_BYTE*)(pstr1+a));
#else
            snprintf((pStr2),StrSize,"%x",*(SS_BYTE*)(pstr1+a));
#endif
            pStr2++;
        }
        else
        {
#ifdef  WIN32
            sprintf((pStr2),"%x",*(SS_BYTE*)(pstr1+a));
#else
            snprintf((pStr2),StrSize,"%x",*(SS_BYTE*)(pstr1+a));
#endif
            pStr2++;pStr2++;
        }
        *pStr2 = ' ';
        pStr2++;

    }
    return p;
}

const SS_CHAR  * SS_String_HexCaseString(
    IN  SS_CHAR const *const  pstr1,
    IN  SS_INT32 const lnLength,
    OUT SS_CHAR       *pStr2,
    IN  size_t          StrSize) 
{
    int a=0;
    SS_CHAR * p = pStr2;
    if (NULL == pstr1 || NULL == pStr2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str1=%p,str2=%p",pstr1,pStr2);
#endif
        return "";
    }  
    for (a=0;a<lnLength;a++)
    {
        if (!((a)%8) && ((a)%16))
        {
            *pStr2 = ' ';
            pStr2++;
            *pStr2 = ' ';
            pStr2++;
        }
        if (*(SS_BYTE*)(pstr1+a) <= 0)
        {
            *pStr2 = '0';
            pStr2++;
            *pStr2 = '0';
            pStr2++;
        }
        else if (*(SS_BYTE*)(pstr1+a) <= 15)
        {
            *pStr2 = '0';
            pStr2++;
#ifdef  WIN32
            sprintf((pStr2),"%x",*(SS_BYTE*)(pstr1+a));
#else
            snprintf((pStr2),StrSize,"%x",*(SS_BYTE*)(pstr1+a));
#endif
            pStr2++;
        }
        else
        {
#ifdef  WIN32
            sprintf((pStr2),"%x",*(SS_BYTE*)(pstr1+a));
#else
            snprintf((pStr2),StrSize,"%x",*(SS_BYTE*)(pstr1+a));
#endif
            pStr2++;pStr2++;
        }
        *pStr2 = ' ';
        pStr2++;

    }
    return p;
}


SS_CHAR const * SS_String_FilterASCIIChar(IN  OUT  SS_CHAR *pString,SS_INT32 const lnStringLength)
{
    SS_CHAR *Pstr = NULL;
    int i = 0,j = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    if (NULL == (Pstr =  (PSS_CHAR)malloc(lnStringLength+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(Pstr,0,lnStringLength);
    for(i=0;i<lnStringLength;i++)
    {
        if(isascii(pString[i]))
        {
            Pstr[j] = pString[i];
            j++;
        }
    }
    Pstr[j] = '\0';
    memset(pString,0,lnStringLength);
    memcpy(pString,Pstr,j);
    free(Pstr);
    return pString;
}
SS_CHAR const * SS_String_FilterChar_0_to_9(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 >= '0' && *p1 <= '9')
        {
            *p2 = *p1;
            p1++;
            p2++;
            continue;
        }
        p1++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_FilterChar_a_to_z(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if((*p1 >= 'a' && *p1 <= 'z'))
        {
            *p2 = *p1;
            p1++;
            p2++;
            continue;
        }
        p1++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_FilterChar_A_to_Z(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 >= 'A' && *p1 <= 'Z')
        {
            *p2 = *p1;
            p1++;
            p2++;
            continue;
        }
        p1++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_FilterCharCase(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if((*p1 >= 65 && *p1 <= 90) || (*p1 >= 97 && *p1 <= 122))
        {
            *p2 = *p1;
            p1++;
            p2++;
            continue;
        }
        p1++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_FilterChar(IN OUT SS_CHAR *pString,SS_CHAR const ch)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 == ch)
        {
            *p2 = *p1;
            p1++;
            p2++;
            continue;
        }
        p1++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}



SS_CHAR const * SS_String_DeleteChar_0_to_9(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 >= '0' && *p1 <= '9')
        {
            p1++;
            continue;
        }
        *p2 = *p1;
        p1++;
        p2++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_DeleteChar_a_to_z(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 >= 'a' && *p1 <= 'z')
        {
            p1++;
            continue;
        }
        *p2 = *p1;
        p1++;
        p2++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_DeleteChar_A_to_Z(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 >= 'A' && *p1 <= 'Z')
        {
            p1++;
            continue;
        }
        *p2 = *p1;
        p1++;
        p2++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_DeleteCharCase(IN OUT SS_CHAR *pString)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,(ln+1));
    p2 = pStr;
    while('\0' != *p1)
    {
        if((*p1 >= 65 && *p1 <= 90) || (*p1 >= 97 && *p1 <= 122))
        {
            p1++;
            continue;
        }
        *p2 = *p1;
        p1++;
        p2++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_CHAR const * SS_String_DeleteChar(IN OUT SS_CHAR *pString,SS_CHAR const ch)
{
    SS_CHAR *p1   = NULL;
    SS_CHAR *p2   = NULL;
    SS_CHAR *pStr = NULL;
    SS_INT32 ln    = 0;
    if(NULL == pString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pString=%p",pString);
#endif
        return "";
    }
    p1 = pString;
    ln = strlen(pString);
    if (NULL == (pStr = (PSS_CHAR)malloc(ln+1)))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"malloc fail");
#endif
        return "";
    }
    memset(pStr,0,ln+1);
    p2 = pStr;
    while('\0' != *p1)
    {
        if(*p1 == ch)
        {
            p1++;
            continue;
        }
        *p2 = *p1;
        p1++;
        p2++;
    }
    *p2 = '\0';
    memset(pString,0,ln);
    SS_strncpy(pString,pStr,ln);
    free(pStr);
    return pString;
}
SS_SHORT SS_GetCPUCount()
{
    SS_SHORT snCount = 0;
#ifdef  WIN32
    SYSTEM_INFO si;  
    ::GetSystemInfo(&si);  
    snCount = (SS_SHORT)si.dwNumberOfProcessors;  
#else
    FILE *fp = NULL;
    SS_CHAR *pbuf = NULL;
    SS_CHAR *p    = NULL;
    SS_UINT32 un32Size=1024*512;
    if (fp = fopen("/proc/cpuinfo","rb"))
    {
        //fseek(fp,0,SEEK_END);//
        //un32Size = ftell(fp);//
        //fseek(fp,0,SEEK_SET);//
        if (pbuf = (SS_CHAR *)SS_malloc(un32Size))
        {
            memset(pbuf,0,un32Size);
            fread(pbuf,un32Size,1,fp);
            fclose(fp);
            p = pbuf;
            snCount = 0;
            while(p = (strstr(p,"processor")))
            {
                snCount++;
                p = p+9;
            }
            SS_free(pbuf);
        }
        else
        {
            fclose(fp);
        }
    }
#endif
    return (0 == snCount)?1:snCount;
}

SS_SHORT SS_BitToHexEx(
    IN  SS_CHAR const * pBit,
    IN  SS_UINT32 const un32BitLength,
    OUT SS_CHAR * pHex,
    OUT SS_UINT32 const un32HexLength,
    OUT SS_UINT32 *un32Result)
{
    SS_UINT32 un32=0;
    SS_UINT32 un32Length = 0;
    SS_CHAR * p = pHex;
    if (NULL == pBit || un32BitLength <= 0 ||
        NULL == pHex || un32HexLength < ((un32BitLength*2)+(un32BitLength/8)+512))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pBit=%p,BitLength=%u,pHex=%p,"
            "HexLength=%u,%u",pBit,un32BitLength,pHex,un32HexLength,
            ((un32BitLength*2)+(un32BitLength/8)+512));
#endif
        return SS_ERR_PARAM;
    }
    SS_byte_to_hex_str(*(SS_BYTE*)(pBit),p);
    p += 2;un32Length = 2;
    for (un32=1;un32<un32BitLength;un32++)
    {
        SS_byte_to_hex_str(*(SS_BYTE*)(pBit+un32),p);
        p += 2;un32Length += 2;
        if (!(un32%8))
        {
            *p = ' ';p++;un32Length++;
        }
    }
    if (un32Result)
    {
        *un32Result = un32Length;
    }
    return  SS_SUCCESS;
}
SS_CHAR SS_BitToChar(SS_CHAR ch)
{
    switch (ch)
    {
    case 32 :return ' ';//Space
    case 33 :return '!';
    case 34 :return '"';
    case 35 :return '#';
    case 36 :return '$';
    case 37 :return '%';
    case 38 :return '&';
    case 39 :return '\'';
    case 40 :return '(';
    case 41 :return ')';
    case 42 :return '*';
    case 43 :return '+';
    case 44 :return ',';
    case 45 :return '-';
    case 46 :return '.';
    case 47 :return '/';
    case 48 :return '0';
    case 49 :return '1';
    case 50 :return '2';
    case 51 :return '3';
    case 52 :return '4';
    case 53 :return '5';
    case 54 :return '6';
    case 55 :return '7';
    case 56 :return '8';
    case 57 :return '9';
    case 58 :return ':';
    case 59 :return ';';
    case 60 :return '<';
    case 61 :return '=';
    case 62 :return '>';
    case 63 :return '?';
    case 64 :return '@';
    case 65 :return 'A';
    case 66 :return 'B';
    case 67 :return 'C';
    case 68 :return 'D';
    case 69 :return 'E';
    case 70 :return 'F';
    case 71 :return 'G';
    case 72 :return 'H';
    case 73 :return 'I';
    case 74 :return 'J';
    case 75 :return 'K';
    case 76 :return 'L';
    case 77 :return 'M';
    case 78 :return 'N';
    case 79 :return 'O';
    case 80 :return 'P';
    case 81 :return 'Q';
    case 82 :return 'R';
    case 83 :return 'S';
    case 84 :return 'T';
    case 85 :return 'U';
    case 86 :return 'V';
    case 87 :return 'W';
    case 88 :return 'X';
    case 89 :return 'Y';
    case 90 :return 'Z';
    case 91 :return '[';
    case 92 :return ' ';
    case 93 :return ']';
    case 94 :return '^';
    case 95 :return '_';
    case 96 :return '`';
    case 97 :return 'a';
    case 98 :return 'b';
    case 99 :return 'c';
    case 100:return 'd';
    case 101:return 'e';
    case 102:return 'f';
    case 103:return 'g';
    case 104:return 'h';
    case 105:return 'i';
    case 106:return 'j';
    case 107:return 'k';
    case 108:return 'l';
    case 109:return 'm';
    case 110:return 'n';
    case 111:return 'o';
    case 112:return 'p';
    case 113:return 'q';
    case 114:return 'r';
    case 115:return 's';
    case 116:return 't';
    case 117:return 'u';
    case 118:return 'v';
    case 119:return 'w';
    case 120:return 'x';
    case 121:return 'y';
    case 122:return 'z';
    case 123:return '{';
    case 124:return '|';
    case 125:return '}';
    case 126:return '~';
    default:return '.';
    }
    return '.';
}
SS_CHAR const * SS_String_GetStringToString(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const *const pBeginStringFlag,
    IN  SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR       *pBuf,
    IN  size_t         BufSize)
{
    SS_CHAR const *pBeginStr= NULL;
    SS_CHAR const *pEndStr  = NULL;
    size_t         Size=0;
    SS_UINT32      un32Len=0;
    if (NULL==pString||NULL==pBeginStringFlag||NULL==pEndStringFlag||NULL==pBuf)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,BeginStringFlag=%p,"
            "EndStringFlag=%p,Buf=%p",pString,pBeginStringFlag,pEndStringFlag,pBuf);
#endif
        return "";
    }
    pBeginStr= strstr(pString,pBeginStringFlag);
    pEndStr  = strstr(pString,pEndStringFlag);
    if (NULL == pBeginStr || NULL == pEndStr)
    {
        return "";
    }
    Size=pEndStringFlag-pBeginStringFlag;
    un32Len=+strlen(pBeginStringFlag);
    pBeginStr = pBeginStr+un32Len;
    Size      = Size-un32Len;
    memcpy(pBuf,pBeginStr,(Size>BufSize)?BufSize:Size);
    return pBuf;
}
SS_CHAR const * SS_String_GetStringToChar(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const *const pBeginStringFlag,
    IN  SS_CHAR const cEndCharFlag,
    OUT SS_CHAR       *pBuf,
    IN  size_t         BufSize)
{
    SS_CHAR const *pBeginStr= NULL;
    SS_CHAR const *pEndStr  = NULL;
    size_t         Size=0;
    SS_UINT32      un32Len=0;
    if (NULL==pString||NULL==pBeginStringFlag||NULL==pBuf)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,BeginStringFlag=%p,"
            "Buf=%p",pString,pBeginStringFlag,pBuf);
#endif
        return "";
    }
    pBeginStr= strstr(pString,pBeginStringFlag);
    pEndStr  = strchr(pString,cEndCharFlag);
    if (NULL == pBeginStr || NULL == pEndStr)
    {
        return "";
    }
    Size=pEndStr-pBeginStr;
    un32Len = strlen(pBeginStringFlag);
    pBeginStr+=un32Len;
    Size-=un32Len;
    memcpy(pBuf,pBeginStr,(Size>BufSize)?BufSize:Size);
    return pBuf;
}
SS_CHAR const * SS_String_GetCharToString(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const cBeginCharFlag,
    IN  SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR       *pBuf,
 IN OUT SS_UINT32  *un32BufSize)
{
    SS_CHAR const *pBeginStr= NULL;
    SS_CHAR const *pEndStr  = NULL;
    size_t         Size=0;
    SS_UINT32      un32Len=0;
    if (NULL==pString||NULL==pEndStringFlag||NULL==pBuf||NULL==un32BufSize||0==*un32BufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,EndStringFlag=%p,Buf=%p,"
            "BufSize=%p,*BufSize=%u",pString,pEndStringFlag,pBuf,un32BufSize,*un32BufSize);
#endif
        return "";
    }
    pBeginStr= strchr(pString,cBeginCharFlag);
    pEndStr  = strstr(pString,pEndStringFlag);
    if (NULL == pBeginStr || NULL == pEndStr)
    {
        return "";
    }
    Size=pEndStr-pBeginStr;
    Size--;
    pBeginStr++;
    *un32BufSize = (Size>*un32BufSize)?*un32BufSize:Size;
    memcpy(pBuf,pBeginStr,*un32BufSize);
    return pBuf;
}
SS_CHAR const * SS_String_GetCharToChar(
    IN  SS_CHAR const *const pString,
    IN  SS_CHAR const cBeginCharFlag,
    IN  SS_CHAR const cEndCharFlag,
    OUT SS_CHAR       *pBuf,
 IN OUT SS_UINT32  *un32BufSize)
{
    SS_CHAR const *pStr = NULL;
    SS_CHAR *p    = pBuf;
    size_t  tCount = 0;
    if (NULL==pString||NULL==pBuf||NULL==un32BufSize||0==*un32BufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,Buf=%p,"
            "BufSize=%p,*BufSize=%u",pString,pBuf,un32BufSize,*un32BufSize);
#endif
        return "";
    }
    if(NULL == (pStr = strchr(pString,cBeginCharFlag)))
    {
        return "";
    }
    pStr++;
    while ('\0' != *pStr)
    {
        if((*(SS_BYTE*)pStr) == ((SS_BYTE)cEndCharFlag))
        {
            break;
        }
        *p++ = *pStr++;
        tCount++;
        if (tCount>=*un32BufSize)
        {
            break;
        }
    }
    *un32BufSize=tCount;
    *p = '\0';
    return pBuf;
}
SS_CHAR const * SS_String_GetStringToEnd(
    IN SS_CHAR const *const pString,
    IN SS_CHAR const *const pBeginStringFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t        BufSize)
{
    SS_CHAR const *pStr = NULL;
    if (NULL==pString||NULL==pBuf||NULL==pBeginStringFlag)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,Buf=%p,"
            "BeginStringFlag=%p",pString,pBuf,pBeginStringFlag);
#endif
        return "";
    }
    if(NULL == (pStr = strstr(pString,pBeginStringFlag)))
    {
        return "";
    }
    SS_strncpy(pBuf,(pStr+strlen(pBeginStringFlag)),BufSize);
    return pBuf;
}
SS_CHAR const * SS_String_GetCharToEnd(
    IN SS_CHAR const *const pString,
    IN SS_CHAR const cBeginCharFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t         BufSize)
{
    SS_CHAR const *pStr = NULL;
    if (NULL==pString||NULL==pBuf)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,Buf=%p",pString,pBuf);
#endif
        return "";
    }
    if(NULL == (pStr = strchr(pString, cBeginCharFlag)))
    {
        return "";
    }
    SS_strncpy(pBuf,pStr+1,BufSize);
    return pBuf;
}

SS_CHAR const*SS_String_GetBeginToChar(
    IN SS_CHAR const * pString,
    IN SS_CHAR const cEndCharFlag,
    OUT SS_CHAR      *pBuf,
    IN OUT SS_UINT32  *un32BufSize)
{
    SS_CHAR  *p=pBuf;
    size_t  tCount = 0;
    if (NULL==pString||NULL==pBuf||NULL==un32BufSize||0==*un32BufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,Buf=%p,"
            "BufSize=%p,*BufSize=%u",pString,pBuf,un32BufSize,*un32BufSize);
#endif
        return "";
    }
    while('\0' != *pString)
    {
        if((*(SS_BYTE*)pString) == ((SS_BYTE)cEndCharFlag))
        {
            break;
        }
        *p++ = *pString++;
        tCount++;
        if (tCount >= *un32BufSize)
        {
            break;
        }
    }
    *p = '\0';
    *un32BufSize = tCount;
    return pBuf;
}
SS_CHAR const*SS_String_GetBeginToString(
    IN SS_CHAR const * pString,
    IN SS_CHAR const *const pEndStringFlag,
    OUT SS_CHAR      *pBuf,
    IN  size_t         BufSize)
{
    SS_CHAR *p     = pBuf;
    SS_CHAR const *pStr = NULL;
    if (NULL==pString||NULL==pBuf||NULL==pEndStringFlag)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,String=%p,Buf=%p,EndStringFlag=%p",pString,pBuf,pEndStringFlag);
#endif
        return "";
    }
    if(NULL == (pStr = strstr(pString, pEndStringFlag)))
    {
        return "";
    }
    while('\0' != *pString)
    {
        if(&(*pString) == &(*pStr))
        {
            break;
        }
        *p++ = *pString++;

    }
    *p = '\0';
    return SS_SUCCESS;
}
char const * SS_String_StrCaseChr(const char* src,char ch)
{
    if (NULL == src)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,src=%p",src);
#endif
        return NULL;
    }
    while(*src != '\0')
    {
        if (*src == ch || *src == (ch+32) || *src == (ch-32))
        {
            return src;
        }
        src++;
    }
    return NULL;
}


char const * SS_String_StrCaseStr(const char* src,const char* dst)
{
    int n32DstLength = 0;
    int n32SrcLength = 0;
    int n32=0;
    const char *pSrc = src;
    const char *pDst = dst;
    if (NULL == src || NULL == dst)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,src=%p,dst=%p",src,dst);
#endif
        return NULL;
    }
    n32DstLength = strlen(dst);
    n32SrcLength = strlen(src);
    if (n32DstLength > n32SrcLength)
    {
        return NULL;
    }
    while(1)
    {
        for (n32=0;n32<n32DstLength;n32++)
        {
            if (((*(pSrc+n32) >= 'A' && *(pSrc+n32) <= 'Z') ? ((*(pSrc+n32))+32):(*(pSrc+n32))) !=
                ((*(pDst+n32) >= 'A' && *(pDst+n32) <= 'Z') ? ((*(pDst+n32))+32):(*(pDst+n32))))
            {
                break;
            }
        }
        if (n32 == n32DstLength)
        {
            return pSrc;
        }
        pSrc++;
        n32SrcLength--;
        if (n32DstLength > n32SrcLength)
        {
            return NULL;
        }
        if ('\0' == *pSrc)
        {
            return NULL;
        }
    }
    return NULL;
}


SS_CHAR const * SS_GetCPUID(OUT SS_CHAR *pCPUID)
{
    if (NULL == pCPUID)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,CPUID=%p",pCPUID);
#endif
        return "";
    }
#ifdef  _WIN32

#ifndef  _WIN64
    SS_UINT32  un32Len=0;
    SS_UINT32  un32=0;
    unsigned long s1,s2;
  unsigned char vendor_id[]="------------";
    _asm
    {
        xor eax,eax
            cpuid
            mov dword ptr vendor_id,ebx
            mov dword ptr vendor_id[+4],edx
            mov dword ptr vendor_id[+8],ecx
    }
    un32Len = sprintf(pCPUID,"%s",(SS_CHAR*)vendor_id);
    _asm
    {
        mov eax,01h
            xor edx,edx
            cpuid
            mov s1,edx
            mov s2,eax
    }
    
    un32 = sprintf(pCPUID+un32Len,"%08X%08X",s1,s2);
    un32Len+=un32;
    _asm
    {
        mov eax,03h
            xor ecx,ecx
            xor edx,edx
            cpuid
            mov s1,edx
            mov s2,ecx
    }


    un32 = sprintf(pCPUID+un32Len,"%08X%08X",s1,s2);
#endif

#else
/*    unsigned long s1,s2,s3,s4;
    unsigned int eax = 0;
    unsigned int ebx,ecx,edx;
 asm volatile 
 (   "cpuid"
        : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
        : "0"(0) 
 );
 snprintf(pCPUID, 5, "%s", (char *)&ebx);
 snprintf(pCPUID+4, 5, "%s", (char *)&edx);
 snprintf(pCPUID+8, 5, "%s", (char *)&ecx);

 asm volatile   
 (   "movl $0x01 , %%eax ; \n\t"
  "xorl %%edx , %%edx ;\n\t"
  "cpuid ;\n\t"
  "movl %%edx ,%0 ;\n\t"
  "movl %%eax ,%1 ; \n\t"
  :"=m"(s1),"=m"(s2)
 ); 
 asm volatile
 (   "movl $0x03,%%eax ;\n\t"
  "xorl %%ecx,%%ecx ;\n\t"
  "xorl %%edx,%%edx ;\n\t"
  "cpuid ;\n\t"
  "movl %%edx,%0 ;\n\t"
  "movl %%ecx,%1 ;\n\t"
  :"=m"(s3),"=m"(s4)
 );
 sprintf(pCPUID+12,"%08X%08X%08X%08X",s1,s2,s3,s4);*/
#endif
    return  pCPUID;
}

SS_CHAR const* SS_GetPathFileName(IN SS_CHAR const *pPath,IN SS_UINT32 const un32PathLength,OUT SS_CHAR *pName)
{    
    SS_CHAR  sBuf[512]="";
    SS_UINT32 un32 = 0;
    SS_USHORT usn = 0;
    SS_USHORT usnCount = 0;
    if (NULL == pPath || 0 == un32PathLength||NULL == pName)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p,PathLength=%u,Name=%p",pPath,un32PathLength,pName);
#endif
        return "";
    }
    for (un32=un32PathLength-1;un32!=0;un32--)
    {
#ifdef  WIN32
        if ('\\' == pPath[un32])
#else
            if ('/' == pPath[un32])
#endif
            {
                break;
            }
            sBuf[usnCount] = pPath[un32];
            usnCount++;
    }
    usn = usnCount-1;
    for (un32=0;un32<usnCount;un32++)
    {
        pName[un32] = sBuf[usn];
        usn--;
    }
    return pName;
}
SS_CHAR const* SS_DelPathLastDir(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength)
{
    SS_UINT32 un32 = 0;
    if (NULL == pPath || 0 == un32PathLength)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p,PathLength=%u",pPath,un32PathLength);
#endif
        return "";
    }
    for (un32=un32PathLength-1;un32!=0;un32--)
    {
#ifdef  WIN32
        if ('\\' == pPath[un32])
#else
        if ('/' == pPath[un32])
#endif
        {
            break;
        }
        pPath[un32]=0;
    }
    pPath[un32]=0;
    return  pPath;
}
SS_CHAR const* SS_GetEXEPath(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength)
{
    if (NULL == pPath || 0 == un32PathLength)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p,PathLength=%u",pPath,un32PathLength);
#endif
        return "";
    }
#ifdef  WIN32
    ::GetModuleFileName(NULL,pPath,un32PathLength);
#else
    FILE *fp =NULL;
    SS_CHAR  sBuf[2048] = "";
    SS_CHAR  sPath[1024] = "";
    sprintf(sPath,"/proc/%u/cmdline",getpid());
    if (fp = fopen(sPath,"rb"))
    {
        fread(sBuf,sizeof(sBuf),1,fp);
        fclose(fp);
        strncpy(pPath,sBuf,un32PathLength);
    }
#endif
    return pPath;
}
SS_CHAR const* SS_GetModulePath(IN SS_CHAR *pPath,IN SS_UINT32 const un32PathLength)
{
    if (NULL == pPath || 0 == un32PathLength)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Path=%p,PathLength=%u",pPath,un32PathLength);
#endif
        return "";
    }
    SS_GetEXEPath(pPath,un32PathLength);
    SS_DelPathLastDir(pPath,strlen(pPath));
    return pPath;
}

SS_CHAR const * SS_GetSMSSendResult(IN SS_BYTE const ubState)
{
    switch(ubState)
    {
    case 0:return "";
    case 1:return "";
    default:return "";
    }
    return "";
}
#include <math.h>

SS_UINT32 IPtoHex_2(const char * ip)
{
    char          buf[80];
    int           p=0,i=0;
    int           pos=3;
    int           nIndex = 0;
    SS_UINT32     m_un32Ret=0;
    while(ip[p] != 0)
    {
        i=0;
        while(ip[p] != '.' && ip[p] != 0)
        {
            buf[i++]=ip[p++];
        }
        buf[i] = 0;
        m_un32Ret = (SS_UINT32)(m_un32Ret + atoi(buf) * pow((double)0x100,pos));
        pos--;
        if (ip[p] != 0)
        {
            p++;
        }
    }
    return m_un32Ret;
}

SS_BOOL SS_IsPrivateIPAddress(const char *sIPAddress)
{
    SS_UINT32 un32IPAddress;
    if(sIPAddress == NULL)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,IPAddress=%p",sIPAddress);
#endif
        return SS_TRUE;
    }
    if(strlen(sIPAddress)<7)
    {
        return SS_TRUE;
    }
    
    un32IPAddress = IPtoHex_2((const char*)sIPAddress);
    
    if(un32IPAddress==IPtoHex_2((const char*)"127.0.0.1"))
    {
        return SS_TRUE;
    }
    if(  (un32IPAddress>=IPtoHex_2((const char*)"192.168.0.0"))
        &&(un32IPAddress<=IPtoHex_2((const char*)"192.168.255.255")))
    {
        return SS_TRUE;
    }
    if(  (un32IPAddress>=IPtoHex_2((const char*)"172.16.0.0"))
        &&(un32IPAddress<=IPtoHex_2((const char*)"172.31.255.255")))
    {
        return SS_TRUE;
    }
    if(   (un32IPAddress>=IPtoHex_2((const char*)"10.0.0.0"))
        &&(un32IPAddress<=IPtoHex_2((const char*)"10.255.255.255")))
    {
        return SS_TRUE;
    }
    if(   (un32IPAddress>=IPtoHex_2((const char*)"169.254.0.0"))
        &&(un32IPAddress<=IPtoHex_2((const char*)"169.254.255.255")))
    {
        return SS_TRUE;
    }
    return SS_FALSE;
}

SS_CHAR SS_GetDTMFChar(IN SS_BYTE const ubKey)
{
    switch(ubKey)
    {
    case 0:return '0';
    case 1:return '1';
    case 2:return '2';
    case 3:return '3';
    case 4:return '4';
    case 5:return '5';
    case 6:return '6';
    case 7:return '7';
    case 8:return '8';
    case 9:return '9';
    case 10:return '*';
    case 11:return '#';
    case 12:return 'A';
    case 13:return 'B';
    case 14:return 'C';
    case 15:return 'D';
    case 16:return 'F';
    default:return  0;
    }
    return  0;
}

SS_BYTE SS_GetDTMFByte(IN SS_CHAR const *pKey)
{
    if (NULL == pKey)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Key=%p",pKey);
#endif
        return 18;
    }
    switch(*pKey)
    {
    case '0':return 0;
    case '1':
        {
            switch(*(pKey+1))
            {
            case '0' :{return 10;}
            case '1' :{return 11;}
            case '2' :{return 12;}
            case '3' :{return 13;}
            case '4' :{return 14;}
            case '5' :{return 15;}
            case '6' :{return 16;}
            default:  {return 1;}
            }
            return 1;
        }
    case '2':return 2;
    case '3':return 3;
    case '4':return 4;
    case '5':return 5;
    case '6':return 6;
    case '7':return 7;
    case '8':return 8;
    case '9':return 9;
    case '*':return 10;
    case '#':return 11;
    case 'A':
    case 'a':
        {
            return 12;
        }
    case 'B':
    case 'b':
        {
            return 13;
        }
    case 'C':
    case 'c':
        {
            return 14;
        }
    case 'D':
    case 'd':
        {
            return 15;
        }
    case 'F':
    case 'f': // Flash
        {
            return 16;
        }
    default:return 18;
    }
    return  18;
}



//////////////////////////////////////////////////////////////////////////

SS_BYTE  SS_Timeval_GetTheWeek(IN SS_Timeval *s_DateTime)
{
    if (NULL == s_DateTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime==NULL");
#endif
        return SS_ERR_PARAM;
    }

    SS_CHAR  sTime[64] = "";
    SS_CHAR  sC[4] = "";
    SS_CHAR  sY[4] = "";
    SS_CHAR  sM[4] = "";
    SS_CHAR  sD[4] = "";
    SS_UINT32 un32=0;
    SS_UINT32 fC=0;
    SS_UINT32 fY=0;
    SS_UINT32 fM=0;
    SS_UINT32 fD=0;
    SS_Timeval_FormatYearMonthDay(s_DateTime,sTime,sizeof(sTime));
    memcpy(sC,sTime,2);
    memcpy(sY,sTime+2,2);
    un32=4;
    SS_String_GetBeginToChar(sTime+5,'-',sM,&un32);
    sD[0] = sTime[5+un32+1];
    if (0 != sTime[5+un32+2])
    {
        sD[1] = sTime[5+un32+2];
    }
    fC = (SS_UINT32 )atol(sC);
    fY = (SS_UINT32 )atol(sY);
    fM = (SS_UINT32 )atol(sM);
    fD = (SS_UINT32 )atol(sD);

    SS_UINT32 fR= fY+(fY/4)+(fC/4)-2*fC+(26*(fM+1)/10)+fD-1;
    un32  = fR;
    un32  = un32%7;
    return (SS_BYTE)un32;
}


SS_SHORT  SS_Timeval_GetDateString_English(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
    static  const SS_CHAR *Week[] = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat",};
    static  const SS_CHAR *Month[] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",};
#ifdef _WIN32
    SS_snprintf(pstr,StrBufSize,"%s, %u %s %u %02u:%02u:%02u +0800", Week[pTimeval->wDayOfWeek],
        pTimeval->wDay, Month[pTimeval->wMonth - 1], pTimeval->wYear, pTimeval->wHour,
        pTimeval->wMinute,pTimeval->wSecond);
#else 
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%s, %u %s %u %02u:%02u:%02u +0800", Week[TM.m_n32Wday],
        TM.m_n32Mday, Month[TM.m_n32Mon], TM.m_n32Year + 1900, TM.m_n32Hour,
        TM.m_n32Min,TM.m_n32Sec);
#endif
    return   SS_SUCCESS;
}

SS_UINT32  SS_Timeval_IfHour(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2)
{
    if (NULL == pDateTime1 || NULL == pDateTime2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime1=%p,DateTime2=%p",pDateTime1,pDateTime2);
#endif
        return 0;
    }

#ifdef WIN32
    if (pDateTime1->wHour > pDateTime2->wHour)
    {
        return (pDateTime1->wHour - pDateTime2->wHour);
    }
#else
    SS_Time     TM1;
    SS_Time     TM2;
    memcpy(&(TM1),(void *)localtime(&(pDateTime1->m_Sec)), sizeof (SS_Time));
    memcpy(&(TM2),(void *)localtime(&(pDateTime2->m_Sec)), sizeof (SS_Time));
    if (TM1.m_n32Hour > TM2.m_n32Hour)
    {
        return (TM1.m_n32Hour - TM2.m_n32Hour);
    }
#endif
    return 0;
}
SS_UINT32  SS_Timeval_IfMinute(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2)
{
    if (NULL == pDateTime1 || NULL == pDateTime2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime1=%p,DateTime2=%p",pDateTime1,pDateTime2);
#endif
        return 0;
    }
#ifdef WIN32
    SS_UINT32    un321 = 0;
    SS_UINT32    un322 = 0;
    un321 = (pDateTime1->wHour*60+pDateTime1->wMinute);
    un322 = (pDateTime2->wHour*60+pDateTime2->wMinute);
    if (un321 > un322)
    {
        return (un321 - un322);
    }
#else
    SS_UINT32    un321 = 0;
    SS_UINT32    un322 = 0;
    SS_Time     TM;
    memcpy(&(TM),(void *)localtime(&(pDateTime1->m_Sec)), sizeof (SS_Time));
    un321 = ((TM.m_n32Hour*60)+TM.m_n32Min);
    memcpy(&(TM),(void *)localtime(&(pDateTime2->m_Sec)), sizeof (SS_Time));
    un322 = ((TM.m_n32Hour*60)+TM.m_n32Min);
    if (un321 > un322)
    {
        return (un321 - un322);
    }
#endif
    return 0;
}
SS_UINT64  SS_Timeval_IfSecond(
        IN SS_Timeval const * const pDateTime1,
        IN SS_Timeval const * const pDateTime2)
{
    if (NULL == pDateTime1 || NULL == pDateTime2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime1=%p,DateTime2=%p",pDateTime1,pDateTime2);
#endif
        return 0;
    }
#ifdef WIN32
    SS_UINT64    un64_1 = SS_Timeval_GetSecondCount(pDateTime1);
    SS_UINT64    un64_2 = SS_Timeval_GetSecondCount(pDateTime2);
    if (un64_1 > un64_2)
    {
        return (un64_1 - un64_2);
    }
#else
    if (pDateTime1->m_Sec > pDateTime2->m_Sec)
    {
        return (pDateTime1->m_Sec - pDateTime2->m_Sec);
    }
#endif
    return 0;
}

SS_SHORT  SS_Timeval_FormatStringToTimeval(
        IN  SS_CHAR const*pstr,
        IN  size_t       StrBufSize,
        OUT SS_Timeval *pTimeval)
{
    SS_CHAR const*p = NULL;
    if (NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,str=%p,Timeval=%p,StrBufSize=%u",pstr,pTimeval,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    pTimeval->wYear=atoi(pstr);
    if (NULL == (p = strchr(pstr,'-')))
    {
        return SS_FAILURE;
    }
    p++;
    pTimeval->wMonth=atoi(p);
    if (NULL == (p = strchr(p,'-')))
    {
        return SS_FAILURE;
    }
    p++;
    pTimeval->wDay=atoi(p);
    if (NULL == (p = strchr(p,' ')))
    {
        return SS_FAILURE;
    }
    p++;
    pTimeval->wHour=atoi(p);
    if (NULL == (p = strchr(p,':')))
    {
        return SS_FAILURE;
    }
    p++;
    pTimeval->wMinute=atoi(p);
    if (NULL == (p = strchr(p,':')))
    {
        return SS_FAILURE;
    }
    p++;
    pTimeval->wSecond=atoi(p);
#else
    return SS_FAILURE;
#endif
    return  SS_SUCCESS;
}


SS_UINT64  SS_Timeval_GetSecondCount(IN SS_Timeval const * const pTimeval)
{
    if (NULL == pTimeval)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pTimeval=%p",pTimeval);
#endif
        return 0;
    }
    SS_UINT64 un64Count = 0;
    SS_UINT64 un64Year=0;
    SS_UINT64 un64Month=0;
    SS_UINT32 un32Month_1=0;
    SS_UINT32 un32Month_2=0;
    SS_UINT32 un32Month_3=0;
    SS_UINT32 un32Month_4=0;
    SS_UINT32 un32Month_5=0;
    SS_UINT32 un32Month_6=0;
    SS_UINT32 un32Month_7=0;
    SS_UINT32 un32Month_8=0;
    SS_UINT32 un32Month_9=0;
    SS_UINT32 un32Month_10=0;
    SS_UINT32 un32Month_11=0;
    SS_BYTE   ubMonth_2;
    SS_UINT32 wYear=0;
    SS_UINT32 wMonth=0;
    SS_UINT32 wDay   =0;
    SS_UINT32 wHour  =0;
    SS_UINT32 wMinute=0;
    SS_UINT32 wSecond=0;

#ifdef WIN32
    wYear  =pTimeval->wYear;
    wMonth =pTimeval->wMonth;
    wDay   =pTimeval->wDay;
    wHour  =pTimeval->wHour;
    wMinute=pTimeval->wMinute;
    wSecond=pTimeval->wSecond;
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    wYear  =TM.m_n32Year + 1900;
    wMonth =TM.m_n32Mon + 1;
    wDay   =TM.m_n32Mday;
    wHour  =TM.m_n32Hour;
    wMinute=TM.m_n32Min;
    wSecond=TM.m_n32Sec;
#endif
    if (0 == (wYear/4))
    {
        un64Year=wYear*366*24*60*60;
        ubMonth_2 = 29;
    }
    else
    {
        un64Year=wYear*365*24*60*60;
        ubMonth_2 = 28;
    }
    switch(wMonth)
    {
    case 1:
        {
        }break;
    case 2:
        {
            un32Month_1 = 31*24*60*60;
        }break;
    case 3:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
        }break;
    case 4:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
        }break;
    case 5:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
        }break;
    case 6:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
        }break;
    case 7:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
        }break;
    case 8:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
            un32Month_7 = 31*24*60*60;
        }break;
    case 9:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
            un32Month_7 = 31*24*60*60;
            un32Month_8 = 31*24*60*60;
        }break;
    case 10:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
            un32Month_7 = 31*24*60*60;
            un32Month_8 = 31*24*60*60;
            un32Month_9 = 30*24*60*60;
        }break;
    case 11:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
            un32Month_7 = 31*24*60*60;
            un32Month_8 = 31*24*60*60;
            un32Month_9 = 30*24*60*60;
            un32Month_10 = 31*24*60*60;
        }break;
    case 12:
        {
            un32Month_1 = 31*24*60*60;
            un32Month_2 = ubMonth_2*24*60*60;
            un32Month_3 = 31*24*60*60;
            un32Month_4 = 30*24*60*60;
            un32Month_5 = 31*24*60*60;
            un32Month_6 = 30*24*60*60;
            un32Month_7 = 31*24*60*60;
            un32Month_8 = 31*24*60*60;
            un32Month_9 = 30*24*60*60;
            un32Month_10 = 31*24*60*60;
            un32Month_11 = 30*24*60*60;
        }break;
    default:break;
    }
    un64Month = un32Month_1+un32Month_2+un32Month_3+un32Month_4+un32Month_5+un32Month_6+
        un32Month_7+un32Month_8+un32Month_9+un32Month_10+un32Month_11;
    un64Count = un64Year+un64Month+wDay*24*60*60+wHour*60*60+wMinute*60+wSecond;
    return  un64Count;
}

SS_UINT32  SS_Timeval_GetMinuteCount(IN SS_Timeval const * const pTimeval)
{
    if (NULL == pTimeval)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pTimeval=%p",pTimeval);
#endif
        return 0;
    }
    SS_UINT32 un32Count = 0;
    SS_UINT32 un32Year=0;
    SS_UINT32 un32Month_1=0;
    SS_UINT32 un32Month_2=0;
    SS_UINT32 un32Month_3=0;
    SS_UINT32 un32Month_4=0;
    SS_UINT32 un32Month_5=0;
    SS_UINT32 un32Month_6=0;
    SS_UINT32 un32Month_7=0;
    SS_UINT32 un32Month_8=0;
    SS_UINT32 un32Month_9=0;
    SS_UINT32 un32Month_10=0;
    SS_UINT32 un32Month_11=0;
    SS_UINT32 un32Month=0;
    SS_BYTE   ubMonth_2;
    SS_UINT32 wYear=0;
    SS_UINT32 wMonth=0;
    SS_UINT32 wDay   =0;
    SS_UINT32 wHour  =0;
    SS_UINT32 wMinute=0;

#ifdef WIN32
    wYear  =pTimeval->wYear;
    wMonth =pTimeval->wMonth;
    wDay   =pTimeval->wDay;
    wHour  =pTimeval->wHour;
    wMinute=pTimeval->wMinute;
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    wYear  =TM.m_n32Year + 1900;
    wMonth =TM.m_n32Mon + 1;
    wDay   =TM.m_n32Mday;
    wHour  =TM.m_n32Hour;
    wMinute=TM.m_n32Min;
#endif
    if (0 == (wYear/4))
    {
        un32Year=wYear*366*24*60;
        ubMonth_2 = 29;
    }
    else
    {
        un32Year=wYear*365*24*60;
        ubMonth_2 = 28;
    }
    switch(wMonth)
    {
    case 1:
        {
        }break;
    case 2:
        {
            un32Month_1 = 31*24*60;
        }break;
    case 3:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
        }break;
    case 4:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
        }break;
    case 5:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
        }break;
    case 6:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
        }break;
    case 7:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
        }break;
    case 8:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
            un32Month_7 = 31*24*60;
        }break;
    case 9:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
            un32Month_7 = 31*24*60;
            un32Month_8 = 31*24*60;
        }break;
    case 10:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
            un32Month_7 = 31*24*60;
            un32Month_8 = 31*24*60;
            un32Month_9 = 30*24*60;
        }break;
    case 11:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
            un32Month_7 = 31*24*60;
            un32Month_8 = 31*24*60;
            un32Month_9 = 30*24*60;
            un32Month_10 = 31*24*60;
        }break;
    case 12:
        {
            un32Month_1 = 31*24*60;
            un32Month_2 = ubMonth_2*24*60;
            un32Month_3 = 31*24*60;
            un32Month_4 = 30*24*60;
            un32Month_5 = 31*24*60;
            un32Month_6 = 30*24*60;
            un32Month_7 = 31*24*60;
            un32Month_8 = 31*24*60;
            un32Month_9 = 30*24*60;
            un32Month_10 = 31*24*60;
            un32Month_11 = 30*24*60;
        }break;
    default:break;
    }
    un32Month = un32Month_1+un32Month_2+un32Month_3+un32Month_4+un32Month_5+un32Month_6+
        un32Month_7+un32Month_8+un32Month_9+un32Month_10+un32Month_11;
    un32Count = un32Year+un32Month+wDay*24*60+wHour*60+wMinute;
    return  un32Count;
}
SS_UINT32  SS_Timeval_GetHourCount(IN SS_Timeval const * const pTimeval)
{
    if (NULL == pTimeval)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pTimeval=%p",pTimeval);
#endif
        return 0;
    }
    SS_UINT32 un32Count = 0;
    SS_UINT32 un32Year=0;
    SS_UINT32 un32Month_1=0;
    SS_UINT32 un32Month_2=0;
    SS_UINT32 un32Month_3=0;
    SS_UINT32 un32Month_4=0;
    SS_UINT32 un32Month_5=0;
    SS_UINT32 un32Month_6=0;
    SS_UINT32 un32Month_7=0;
    SS_UINT32 un32Month_8=0;
    SS_UINT32 un32Month_9=0;
    SS_UINT32 un32Month_10=0;
    SS_UINT32 un32Month_11=0;
    SS_UINT32 un32Month=0;
    SS_BYTE   ubMonth_2;
    SS_UINT32 wYear=0;
    SS_UINT32 wMonth=0;
    SS_UINT32 wDay   =0;
    SS_UINT32 wHour  =0;

#ifdef WIN32
    wYear  =pTimeval->wYear;
    wMonth =pTimeval->wMonth;
    wDay   =pTimeval->wDay;
    wHour  =pTimeval->wHour;
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    wYear  =TM.m_n32Year + 1900;
    wMonth =TM.m_n32Mon + 1;
    wDay   =TM.m_n32Mday;
    wHour  =TM.m_n32Hour;
#endif
    if (0 == (wYear/4))
    {
        un32Year=wYear*366*24;
        ubMonth_2 = 29;
    }
    else
    {
        un32Year=wYear*365*24;
        ubMonth_2 = 28;
    }
    switch(wMonth)
    {
    case 1:
        {
        }break;
    case 2:
        {
            un32Month_1 = 31*24;
        }break;
    case 3:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
        }break;
    case 4:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
        }break;
    case 5:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
        }break;
    case 6:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
        }break;
    case 7:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
        }break;
    case 8:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
            un32Month_7 = 31*24;
        }break;
    case 9:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
            un32Month_7 = 31*24;
            un32Month_8 = 31*24;
        }break;
    case 10:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
            un32Month_7 = 31*24;
            un32Month_8 = 31*24;
            un32Month_9 = 30*24;
        }break;
    case 11:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
            un32Month_7 = 31*24;
            un32Month_8 = 31*24;
            un32Month_9 = 30*24;
            un32Month_10 = 31*24;
        }break;
    case 12:
        {
            un32Month_1 = 31*24;
            un32Month_2 = ubMonth_2*24;
            un32Month_3 = 31*24;
            un32Month_4 = 30*24;
            un32Month_5 = 31*24;
            un32Month_6 = 30*24;
            un32Month_7 = 31*24;
            un32Month_8 = 31*24;
            un32Month_9 = 30*24;
            un32Month_10 = 31*24;
            un32Month_11 = 30*24;
        }break;
    default:break;
    }
    un32Month = un32Month_1+un32Month_2+un32Month_3+un32Month_4+un32Month_5+un32Month_6+
        un32Month_7+un32Month_8+un32Month_9+un32Month_10+un32Month_11;
    un32Count = un32Year+un32Month+wDay*24+wHour;
    return  un32Count;
}
SS_UINT32  SS_Timeval_GetDayCount(IN SS_Timeval const * const pTimeval)
{
    if (NULL == pTimeval)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pTimeval=%p",pTimeval);
#endif
        return 0;
    }
    SS_UINT32 un32Count = 0;
    SS_UINT32 un32Year=0;
    SS_UINT32 un32Month_1=0;
    SS_UINT32 un32Month_2=0;
    SS_UINT32 un32Month_3=0;
    SS_UINT32 un32Month_4=0;
    SS_UINT32 un32Month_5=0;
    SS_UINT32 un32Month_6=0;
    SS_UINT32 un32Month_7=0;
    SS_UINT32 un32Month_8=0;
    SS_UINT32 un32Month_9=0;
    SS_UINT32 un32Month_10=0;
    SS_UINT32 un32Month_11=0;
    SS_UINT32 un32Month=0;
    SS_BYTE   ubMonth_2;
    SS_UINT32 wYear=0;
    SS_UINT32 wMonth=0;
    SS_UINT32 wDay   =0;

#ifdef WIN32
    wYear  =pTimeval->wYear;
    wMonth =pTimeval->wMonth;
    wDay   =pTimeval->wDay;
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    wYear  =TM.m_n32Year + 1900;
    wMonth =TM.m_n32Mon + 1;
    wDay   =TM.m_n32Mday;
#endif
    if (0 == (wYear/4))
    {
        un32Year=wYear*366;
        ubMonth_2 = 29;
    }
    else
    {
        un32Year=wYear*365;
        ubMonth_2 = 28;
    }
    switch(wMonth)
    {
    case 1:
        {
        }break;
    case 2:
        {
            un32Month_1 = 31;
        }break;
    case 3:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
        }break;
    case 4:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
        }break;
    case 5:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
        }break;
    case 6:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
        }break;
    case 7:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
        }break;
    case 8:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
            un32Month_7 = 31;
        }break;
    case 9:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
            un32Month_7 = 31;
            un32Month_8 = 31;
        }break;
    case 10:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
            un32Month_7 = 31;
            un32Month_8 = 31;
            un32Month_9 = 30;
        }break;
    case 11:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
            un32Month_7 = 31;
            un32Month_8 = 31;
            un32Month_9 = 30;
            un32Month_10 = 31;
        }break;
    case 12:
        {
            un32Month_1 = 31;
            un32Month_2 = ubMonth_2;
            un32Month_3 = 31;
            un32Month_4 = 30;
            un32Month_5 = 31;
            un32Month_6 = 30;
            un32Month_7 = 31;
            un32Month_8 = 31;
            un32Month_9 = 30;
            un32Month_10 = 31;
            un32Month_11 = 30;
        }break;
    default:break;
    }
    un32Month = un32Month_1+un32Month_2+un32Month_3+un32Month_4+un32Month_5+un32Month_6+
        un32Month_7+un32Month_8+un32Month_9+un32Month_10+un32Month_11;
    un32Count = un32Year+un32Month+wDay;
    return  un32Count;
}

SS_UINT32  SS_Timeval_IfMillisecond(
    IN SS_Timeval const * const pDateTime1,
    IN SS_Timeval const * const pDateTime2)
{
    if (NULL == pDateTime1 || NULL == pDateTime2)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime1=%p,DateTime2=%p",pDateTime1,pDateTime2);
#endif
        return 0;
    }

#ifdef WIN32
    SS_UINT32    un321 = 0;
    SS_UINT32    un322 = 0;
    un321 = (pDateTime1->wHour*3600+pDateTime1->wMinute*60+pDateTime1->wSecond)*1000000+pDateTime1->wMilliseconds*1000;
    un322 = (pDateTime2->wHour*3600+pDateTime2->wMinute*60+pDateTime2->wSecond)*1000000+pDateTime2->wMilliseconds*1000;
    if (un321 > un322)
    {
        return (un321 - un322);
    }
#else
    SS_UINT32    un321 = 0;
    SS_UINT32    un322 = 0;
    SS_Time     TM;
    memcpy(&(TM),(void *)localtime(&(pDateTime1->m_Sec)), sizeof (SS_Time));
    un321 = (TM.m_n32Hour*3600+TM.m_n32Min*60+TM.m_n32Sec)*1000000+pDateTime1->m_USec;
    memcpy(&(TM),(void *)localtime(&(pDateTime2->m_Sec)), sizeof (SS_Time));
    un322 = (TM.m_n32Hour*3600+TM.m_n32Min*60+TM.m_n32Sec)*1000000+pDateTime2->m_USec;
    if (un321 > un322)
    {
        return (un321 - un322);
    }
#endif
    return   0;
}

SS_SHORT  SS_Timeval_mktimeToHex(
    IN  SS_Timeval const * const pDateTime,
    OUT SS_CHAR  *pHexTime)
{
    if (NULL == pDateTime || NULL == pHexTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime=%p,HexTime=%p",pDateTime,pHexTime);
#endif
        return SS_ERR_PARAM;
    }
    SS_CHAR  sBuf[8] = "";
#ifdef  WIN32
        *(SS_USHORT*)(sBuf) = 
            (SS_USHORT)((pDateTime->wYear)<<4)+
            (SS_USHORT)pDateTime->wMonth;
        *(SS_BYTE*)(sBuf+2) = (SS_BYTE)pDateTime->wDay   ;
        *(SS_BYTE*)(sBuf+3) = (SS_BYTE)pDateTime->wHour  ;
        *(SS_BYTE*)(sBuf+4) = (SS_BYTE)pDateTime->wMinute;
        *(SS_BYTE*)(sBuf+5) = (SS_BYTE)pDateTime->wSecond;
#else
        SS_Time    TM;
        memcpy(&(TM),(void *)localtime(&(pDateTime->m_Sec)), sizeof (SS_Time));
        *(SS_USHORT*)(sBuf) = (SS_USHORT)((TM.m_n32Year+1900)<<4)+(SS_USHORT)(TM.m_n32Mon+1);
        *(SS_BYTE*)(sBuf+2) = (SS_BYTE)TM.m_n32Mday;
        *(SS_BYTE*)(sBuf+3) = (SS_BYTE)TM.m_n32Hour;
        *(SS_BYTE*)(sBuf+4) = (SS_BYTE)TM.m_n32Min ;
        *(SS_BYTE*)(sBuf+5) = (SS_BYTE)TM.m_n32Sec ;
#endif
        *(SS_USHORT*)(sBuf)  = htons(*(SS_USHORT*)(sBuf));
        *(SS_UINT32*)(sBuf+2) = htonl(*(SS_UINT32*) (sBuf+2));
        SS_short_to_hex_str(*(SS_USHORT*)(sBuf),pHexTime);
        SS_INT32_to_hex_str(*(SS_UINT32*)(sBuf+2),(pHexTime+4));
        return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_mkHexTotime(
    IN  SS_CHAR  const * const pHexTime,
    OUT SS_Timeval *pDateTime)
{
    if (NULL == pDateTime || NULL == pHexTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime=%p,HexTime=%p",pDateTime,pHexTime);
#endif
        return SS_ERR_PARAM;
    }
    SS_CHAR  sBuf[8] = "";
    SS_hex_str_to_short(pHexTime,*(SS_USHORT*)(sBuf));
    SS_hex_str_to_long((pHexTime+4),*(SS_UINT32*)(sBuf+2));
    *(SS_USHORT*)(sBuf)  = ntohs(*(SS_USHORT*)(sBuf));
    *(SS_UINT32*)(sBuf+2) = ntohl(*(SS_UINT32*) (sBuf+2));
#ifdef  WIN32
    pDateTime->wYear = (*(SS_USHORT*)(sBuf))>>4;
    pDateTime->wMonth= (*(SS_USHORT*)(sBuf))&0x000f;
    pDateTime->wDay   = *(SS_BYTE*)(sBuf+2);
    pDateTime->wHour  = *(SS_BYTE*)(sBuf+3);
    pDateTime->wMinute= *(SS_BYTE*)(sBuf+4);
    pDateTime->wSecond= *(SS_BYTE*)(sBuf+5);
#else
    SS_Time    TM;
    memset(&TM,0,sizeof(SS_Time));
    TM.m_n32Year = ((*(SS_USHORT*)(sBuf))>>4)-1900;
    TM.m_n32Mon  = ((*(SS_USHORT*)(sBuf))&0x000f)-1;
    TM.m_n32Mday = *(SS_BYTE*)(sBuf+2);
    TM.m_n32Hour = *(SS_BYTE*)(sBuf+3);
    TM.m_n32Min  = *(SS_BYTE*)(sBuf+4);
    TM.m_n32Sec  = *(SS_BYTE*)(sBuf+5);
    pDateTime->m_Sec = mktime((struct tm*)&TM);
    pDateTime->m_USec= 0;
#endif
    return SS_SUCCESS;
}


SS_SHORT  SS_Timeval_GetLocalDataTime(OUT PSS_Timeval pDateTime)
{
    if (NULL == pDateTime)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,DateTime=%p",pDateTime);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    GetLocalTime(pDateTime);
#else
    struct timeval tv;
    struct timezone tz;
    gettimeofday(&tv,&tz);
    pDateTime->m_Sec = (SS_INT32)tv.tv_sec;
    pDateTime->m_USec= (SS_INT32)tv.tv_usec;
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecondMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }

#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d %02d:%02d:%02d.%03d",pTimeval->wYear,pTimeval->wMonth,pTimeval->wDay,
        pTimeval->wHour,pTimeval->wMinute,pTimeval->wSecond,pTimeval->wMilliseconds);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d %02d:%02d:%02d.%06ld",
        TM.m_n32Year + 1900,
        TM.m_n32Mon + 1,
        TM.m_n32Mday,
        TM.m_n32Hour,
        TM.m_n32Min,
        TM.m_n32Sec,
        pTimeval->m_USec);
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecondMillisecondsEx(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d%02d%02d%02d%02d%02d%03d",pTimeval->wYear,pTimeval->wMonth,pTimeval->wDay,
        pTimeval->wHour,pTimeval->wMinute,pTimeval->wSecond,pTimeval->wMilliseconds);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d%02d%02d%02d%02d%02d%06ld",
        TM.m_n32Year + 1900,
        TM.m_n32Mon + 1,
        TM.m_n32Mday,
        TM.m_n32Hour,
        TM.m_n32Min,
        TM.m_n32Sec,
        pTimeval->m_USec);
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_FormatYearMonthDayHourMinuteSecond(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) 
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d %02d:%02d:%02d",pTimeval->wYear,pTimeval->wMonth,pTimeval->wDay,
        pTimeval->wHour,pTimeval->wMinute,pTimeval->wSecond);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d %02d:%02d:%02d",
        TM.m_n32Year + 1900,
        TM.m_n32Mon + 1,
        TM.m_n32Mday,
        TM.m_n32Hour,
        TM.m_n32Min,
        TM.m_n32Sec);
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_FormatHourMinuteSecondMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) 
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%02d:%02d:%02d.%03d",
        pTimeval->wHour,pTimeval->wMinute,pTimeval->wSecond,pTimeval->wMilliseconds);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%02d:%02d:%02d.%06ld",
        TM.m_n32Hour,
        TM.m_n32Min,
        TM.m_n32Sec,
        pTimeval->m_USec);
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_FormatYearMonthDay(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize) 
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d",pTimeval->wYear,pTimeval->wMonth,pTimeval->wDay);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d-%02d-%02d",TM.m_n32Year + 1900,TM.m_n32Mon + 1,TM.m_n32Mday);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatYearMonth(
    IN  SS_Timeval const *pTimeval,
    OUT PSS_CHAR          pstr,
    IN  size_t             StrBufSize) 
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d-%02d",pTimeval->wYear,pTimeval->wMonth);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d-%02d",TM.m_n32Year + 1900,TM.m_n32Mon + 1);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatYear(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%04d",pTimeval->wYear);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%04d",TM.m_n32Year + 1900);
#endif
    return SS_SUCCESS;
}


SS_SHORT  SS_Timeval_FormatMonth(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%02d",pTimeval->wMonth);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%02d",TM.m_n32Mon + 1);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatDay(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR          pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%02d",pTimeval->wDay);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%02d",TM.m_n32Mday);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatHourMinuteSecond(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR    pstr,
        IN  size_t             StrBufSize) 
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%02d:%02d:%02d",
        pTimeval->wHour,pTimeval->wMinute,pTimeval->wSecond);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%02d:%02d:%02d",
        TM.m_n32Hour,TM.m_n32Min,TM.m_n32Sec);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Timeval_FormatHour(
    IN  SS_Timeval const *pTimeval,
    OUT PSS_CHAR          pstr,
    IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%02d",pTimeval->wHour);
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    SS_snprintf(pstr,StrBufSize,"%02d",TM.m_n32Hour);
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_GetHour(
    IN  SS_Timeval const *pTimeval,
    OUT SS_BYTE           *pubHour)
{
    if (NULL == pTimeval|| NULL == pubHour)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,pubHour=%p",pTimeval,pubHour);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    *pubHour = (SS_BYTE)pTimeval->wHour;
#else
    SS_Time    TM;
    memcpy(&(TM),(void *)localtime(&(pTimeval->m_Sec)), sizeof (SS_Time));
    *pubHour = (SS_BYTE)TM.m_n32Hour;
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Timeval_FormatMilliseconds(
        IN  SS_Timeval const *pTimeval,
        OUT PSS_CHAR    pstr,
        IN  size_t             StrBufSize)
{
    if (NULL == pTimeval || NULL == pstr || 0 == StrBufSize)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Timeval=%p,str=%p,StrBufSize=%u",pTimeval,pstr,StrBufSize);
#endif
        return SS_ERR_PARAM;
    }
#ifdef WIN32
    SS_snprintf(pstr,StrBufSize,"%d03",pTimeval->wMilliseconds);
#else
    SS_snprintf(pstr,StrBufSize,"%06ld",pTimeval->m_USec);
#endif
    return SS_SUCCESS;
}



//////////////////////////////////////////////////////////////////////////

SS_SHORT   SS_LinkQueue_Init(IN SSLinkQueue*pSSLinkQueue)
{
    if (NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=NULL");
#endif
        return SS_ERR_PARAM;
    }
    if (SS_SUCCESS != SS_Mutex_Init(&pSSLinkQueue->m_Mutext))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"init mutex fail");
#endif
        return SS_FAILURE;
    }
    pSSLinkQueue->m_pHead=NULL;
    pSSLinkQueue->m_pTail=NULL;
    return  SS_SUCCESS;
}
SS_SHORT   SS_LinkQueue_Destroy(IN SSLinkQueue*pSSLinkQueue)
{
    PLink_Node pCur = NULL;
    if (NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=NULL");
#endif
        return SS_ERR_PARAM;
    }
    SS_Mutex_Lock(&pSSLinkQueue->m_Mutext);
    if (pCur = pSSLinkQueue->m_pHead)
    {
        do {
            pSSLinkQueue->m_pHead = pSSLinkQueue->m_pHead->m_pNext;
            free(pCur);
        } while (pCur = pSSLinkQueue->m_pHead);
    }
    pSSLinkQueue->m_pHead=NULL;
    pSSLinkQueue->m_pTail=NULL;
    SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
    SS_Mutex_Destroy(&pSSLinkQueue->m_Mutext);
    memset(&pSSLinkQueue->m_Mutext,0,sizeof(SS_THREAD_MUTEX_T));
    return  SS_SUCCESS;
}
SS_SHORT   SS_LinkQueue_ReadData(IN SSLinkQueue*pSSLinkQueue,OUT SS_VOID  **pData)
{
    PLink_Node pTmp = NULL;
    if (NULL == pData || NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=%p,Data=%p",pSSLinkQueue,pData);
#endif
        return SS_ERR_PARAM;
    }
    SS_Mutex_Lock(&pSSLinkQueue->m_Mutext);
    if (NULL == pSSLinkQueue->m_pHead)
    {
        SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
        return SS_FAILURE;
    }
    pTmp = pSSLinkQueue->m_pHead;
    *pData = pTmp->m_pData;  

    pSSLinkQueue->m_pHead = pSSLinkQueue->m_pHead->m_pNext;
    if (NULL == pSSLinkQueue->m_pHead)
    {
        pSSLinkQueue->m_pTail = NULL;
    }
    if (pTmp)
    {
        free(pTmp);
    }
    SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
    return SS_SUCCESS;
}
SS_SHORT   SS_LinkQueue_WriteData(IN SSLinkQueue*pSSLinkQueue,OUT SS_VOID *pData)
{
    PLink_Node pTmp = NULL;
    if (NULL == pData || NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=%p,Data=%p",pSSLinkQueue,pData);
#endif
        return SS_ERR_PARAM;
    }

    pTmp = (Link_Node*)malloc(sizeof(Link_Node));
    if (NULL == pTmp)
    {
        return SS_ERR_MEMORY;
    }
    pTmp->m_pData  = pData;
    pTmp->m_pNext  = NULL;

    SS_Mutex_Lock(&pSSLinkQueue->m_Mutext);
    if (NULL == pSSLinkQueue->m_pTail)
    {
        pSSLinkQueue->m_pTail = pTmp;
        if (NULL == pSSLinkQueue->m_pHead)
        {
            pSSLinkQueue->m_pHead = pSSLinkQueue->m_pTail;
        }
    }
    else
    {
        pSSLinkQueue->m_pTail->m_pNext = pTmp;
        pSSLinkQueue->m_pTail = pTmp;
    }
    SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
    return SS_SUCCESS;
}
SS_SHORT   SS_LinkQueue_FreeAllItem(IN SSLinkQueue*pSSLinkQueue,IN void (*f_del)(SS_VOID*))
{
    PLink_Node pTmp = NULL;
    if (NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=%p",pSSLinkQueue);
#endif
        return SS_ERR_PARAM;
    }
    SS_Mutex_Lock(&pSSLinkQueue->m_Mutext);
    while(pSSLinkQueue->m_pHead)
    {
        pTmp = pSSLinkQueue->m_pHead;
        pSSLinkQueue->m_pHead = pSSLinkQueue->m_pHead->m_pNext;
        if (pTmp)
        {
            if (pTmp->m_pData&&f_del)
            {
                f_del(pTmp->m_pData);
            }
            free(pTmp);
        }
    }
    pSSLinkQueue->m_pHead = NULL;
    pSSLinkQueue->m_pTail = NULL;    
    SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
    return SS_SUCCESS;
}
SS_UINT32  SS_LinkQueue_GetCount(IN SSLinkQueue*pSSLinkQueue)
{
    PLink_Node pTmp = NULL;
    SS_UINT32  un32  = 0;
    if (NULL == pSSLinkQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SSLinkQueue=%p",pSSLinkQueue);
#endif
        return SS_ERR_PARAM;
    }
    pTmp = pSSLinkQueue->m_pHead;
    SS_Mutex_Lock(&pSSLinkQueue->m_Mutext);
    while(pTmp)
    {
        pTmp = pTmp->m_pNext;
        un32++;

    }
    SS_Mutex_UnLock(&pSSLinkQueue->m_Mutext);
    return un32;
}
//////////////////////////////////////////////////////////////////////////

SS_SHORT   SS_RTPQueue_Init(
    IN SSRTPQueue*pSSRTPQueue,
    IN SS_UINT32 const un32QueueLen,
    IN SS_UINT32 const un32BufSize)
{
    SS_UINT32  un32=0;
    if (NULL == pSSRTPQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pSSRTPQueue=NULL");
#endif
        return SS_ERR_PARAM;
    }
    if (un32QueueLen < 65535 || un32BufSize < 35)
    {
        return  SS_ERR_PARAM;
    }
    pSSRTPQueue->m_un32BufSize=un32BufSize;
    pSSRTPQueue->m_un32ReadPointer=0;
    pSSRTPQueue->m_un32WaitingLen=0;
    if (SS_SUCCESS != SS_Mutex_Init(&pSSRTPQueue->m_Mutext))
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"init mutex fail");
#endif
        return SS_FAILURE;
    }
    pSSRTPQueue->m_un32QueueMaxLen=un32QueueLen;
    if (NULL == (pSSRTPQueue->m_pArrData = (SS_CHAR **)malloc(sizeof(SS_CHAR **)*(un32QueueLen+1))))
    {
        SS_Mutex_Destroy(&pSSRTPQueue->m_Mutext);
        return  SS_ERR_MEMORY;
    }
    memset(pSSRTPQueue->m_pArrData,0,sizeof(SS_CHAR **)*(un32QueueLen+1));
    for (un32=0;un32<un32QueueLen;un32++)
    {
        if (NULL == (pSSRTPQueue->m_pArrData[un32] = (SS_CHAR*)malloc(un32BufSize+6)))
        {
            SS_Mutex_Destroy(&pSSRTPQueue->m_Mutext);
            return  SS_ERR_MEMORY;
        }
        memset(pSSRTPQueue->m_pArrData[un32],0,un32BufSize+6);
    }
    return  SS_SUCCESS;
}
SS_SHORT   SS_RTPQueue_Destroy(IN SSRTPQueue*pSSRTPQueue)
{
    SS_UINT32  un32=0;
    if (NULL == pSSRTPQueue)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,pSSRTPQueue=NULL");
#endif
        return SS_ERR_PARAM;
    }
    if (pSSRTPQueue->m_pArrData)
    {
        SS_Mutex_Lock(&pSSRTPQueue->m_Mutext);
        for (un32=0;un32<pSSRTPQueue->m_un32QueueMaxLen;un32++)
        {
            SS_free(pSSRTPQueue->m_pArrData[un32]);
        }
        SS_free(pSSRTPQueue->m_pArrData);
        pSSRTPQueue->m_un32BufSize=0;
        pSSRTPQueue->m_un32ReadPointer=0;
        pSSRTPQueue->m_un32WaitingLen=0;
        pSSRTPQueue->m_un32QueueMaxLen=0;
        SS_Mutex_UnLock(&pSSRTPQueue->m_Mutext);
        SS_Mutex_Destroy(&pSSRTPQueue->m_Mutext);
    }
    return  SS_SUCCESS;
}


SS_SHORT  SS_RTPQueue_WriteData(
    IN SSRTPQueue*pSSRTPQueue,
    IN  SS_UINT32  const un32ID,
    IN  SS_CHAR const*const psBuf,
    IN  SS_UINT32  const un32BufSize)
{
    SS_CHAR *p = NULL;
    if (NULL==pSSRTPQueue||NULL==psBuf||0==un32BufSize)
    {
        return SS_ERR_PARAM;
    }
    if (un32BufSize >pSSRTPQueue->m_un32BufSize)
    {
        return  SS_ERR_PARAM;
    }
    if (un32ID >= pSSRTPQueue->m_un32QueueMaxLen)
    {
        return SS_ERR_PARAM;
    }
    SS_Mutex_Lock(&pSSRTPQueue->m_Mutext);
    p = pSSRTPQueue->m_pArrData[un32ID];
    *(SS_UINT32*)(p) = un32BufSize;
    memcpy(p+sizeof(SS_UINT32),psBuf,un32BufSize);
    pSSRTPQueue->m_un32WaitingLen++;
    SS_Mutex_UnLock(&pSSRTPQueue->m_Mutext);
    return SS_SUCCESS;
}


SS_SHORT  SS_RTPQueue_ReadData(
    IN SSRTPQueue*pSSRTPQueue,
    OUT    SS_CHAR   *psBuf,
    IN OUT SS_UINT32 *un32Size)
{
    SS_CHAR   *p = NULL;
    SS_UINT32  un32=0;
    if (NULL == pSSRTPQueue || NULL == psBuf || 0 == un32Size)
    {
        return  SS_ERR_PARAM;
    }
    if (pSSRTPQueue->m_un32WaitingLen <= 0)
    {
        return  SS_FAILURE;
    }
    if (*un32Size < pSSRTPQueue->m_un32BufSize)
    {
        return  SS_ERR_PARAM;
    }
    SS_Mutex_Lock(&pSSRTPQueue->m_Mutext);
    for (un32=0;un32<pSSRTPQueue->m_un32QueueMaxLen;un32++)
    {
        if (pSSRTPQueue->m_un32ReadPointer >= pSSRTPQueue->m_un32QueueMaxLen)
        {
            pSSRTPQueue->m_un32ReadPointer = 0;
        }
        p = pSSRTPQueue->m_pArrData[pSSRTPQueue->m_un32ReadPointer];
        if (0 == *(SS_UINT32*)p)//没有数据
        {
            pSSRTPQueue->m_un32ReadPointer++;
            continue;
        }
        *un32Size = *(SS_UINT32*)p;
        memcpy(psBuf,p+sizeof(SS_UINT32),*un32Size);
        pSSRTPQueue->m_un32ReadPointer++;
        pSSRTPQueue->m_un32WaitingLen--;
        *(SS_UINT32*)p = 0;
        SS_Mutex_UnLock(&pSSRTPQueue->m_Mutext);
        return SS_SUCCESS;
    }
    pSSRTPQueue->m_un32WaitingLen=0;
    SS_Mutex_UnLock(&pSSRTPQueue->m_Mutext);
    return SS_FAILURE;
}



//////////////////////////////////////////////////////////////////////////

SS_SHORT  SS_Mutex_Init(IN SS_THREAD_MUTEX_T *pMutex)
{
#ifdef WIN32
    InitializeCriticalSection(pMutex);
#else
    if (0 != pthread_mutex_init(pMutex,NULL))
    {
        return SS_FAILURE;
    }
#endif
    return SS_SUCCESS;
}


SS_SHORT  SS_Mutex_Destroy(IN SS_THREAD_MUTEX_T *pMutex)
{
#ifdef WIN32
    DeleteCriticalSection(pMutex);
#else
    pthread_mutex_destroy(pMutex);
#endif
    return SS_SUCCESS;
}

SS_SHORT  SS_Mutex_Lock(IN SS_THREAD_MUTEX_T *pMutex)
{
#ifdef WIN32
    EnterCriticalSection(pMutex);
#else
    if (0 != pthread_mutex_lock(pMutex))
    {
        return SS_FAILURE;
    }
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Mutex_TryLock(IN SS_THREAD_MUTEX_T *pMutex)
{
#ifdef WIN32
    EnterCriticalSection(pMutex);
#else
    if (0 != pthread_mutex_trylock(pMutex))
    {
        return SS_FAILURE;
    }
#endif
    return SS_SUCCESS;
}
SS_SHORT  SS_Mutex_UnLock(IN SS_THREAD_MUTEX_T *pMutex)
{
#ifdef WIN32
    LeaveCriticalSection(pMutex);
#else
    if (0 != pthread_mutex_unlock(pMutex))
    {
        return SS_FAILURE;
    }
#endif
    return SS_SUCCESS;    
}


//////////////////////////////////////////////////////////////////////////


int SS_snprintf(char *str, size_t size, const char *format, ...)
{
    int i  = 0;
    va_list paramList;
    va_start(paramList, format);
#if defined(_MSC_VER)

#if  _MSC_VER > 1400
    i = vsnprintf_s(str,size,_TRUNCATE,format, paramList);
#else
    i = _vsnprintf(str,size,format, paramList);
#endif

#else
    i = vsnprintf(str,size,format, paramList);
#endif

    va_end(paramList);
    return  i;
}

SS_SHORT  SS_GetPasswordContextString(
    IN  SS_CHAR const*pUserName,
    IN  SS_CHAR const*pPassword,
    OUT SS_CHAR *pRealm,
    OUT SS_CHAR *pNonce,
    OUT SS_CHAR *pUri,
    OUT SS_CHAR *pResponse,
    OUT SS_CHAR *pCnonce,
    OUT SS_CHAR *pNc,
    OUT SS_CHAR *pQop)
{
    SS_UINT32   un32 = 0;
    char        sBuf[512] = "";
    if (NULL==pUserName||NULL==pPassword||NULL==pRealm||NULL==pNonce||NULL==pUri||
        NULL==pResponse||NULL==pCnonce||NULL==pNc||NULL==pQop)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"UserName=%p,Password=%p,Realm=%p,Nonce=%p,Uri=%p,Response=%p,"
            "Cnonce=%p,Nc=%p,Qop=%p",pUserName,pPassword,pRealm,pNonce,pUri,pResponse,pCnonce,pNc,pQop);
#endif
        return  SS_ERR_PARAM;
    }
    *pQop     = 'a';
    *(pQop+1) = 'u';
    *(pQop+2) = 't';
    *(pQop+3) = 'o';
    *(pQop+4) = 0;

    srand((unsigned)time(NULL));
    un32 = rand();

    un32 = un32%10;
    SS_snprintf(pNc,10,"%08u",un32);

    SS_snprintf(sBuf,sizeof(sBuf),"%s%s",pNc,"shenpengmin");
    SS_md5_md5(sBuf,pCnonce);

    memset(sBuf,0,sizeof(sBuf));
    SS_snprintf(sBuf,sizeof(sBuf),"%s%s%s",pNc,"sunshine","shenpengmin");
    SS_md5_md5(sBuf,pUri);

    memset(sBuf,0,sizeof(sBuf));
    SS_snprintf(sBuf,sizeof(sBuf),"%s%s%s%s",pNc,pNonce,pUri,"REGISTER");
    SS_md5_md5(sBuf,pNonce);


    memset(sBuf,0,sizeof(sBuf));
    SS_snprintf(sBuf,sizeof(sBuf),"%s%s%s%s%s%s",pNc,pCnonce,pUri,"jl.com",pUserName,pPassword);
    SS_md5_md5(sBuf,pRealm);


    memset(sBuf,0,sizeof(sBuf));

    SS_snprintf(sBuf,sizeof(sBuf),"%s%s%s%s%s%s%s%s%s",
        pRealm,pNonce,pUri,pCnonce,pNc,pQop,pUserName,pPassword,"ABC");
    SS_md5_md5(sBuf,pResponse);
    return  SS_SUCCESS;
}
SS_SHORT  SS_CheckPassword(
    IN  SS_CHAR const*pUserName,
    IN  SS_CHAR const*pPassword,
    IN  SS_CHAR const*pRealm,
    IN  SS_CHAR const*pNonce,
    IN  SS_CHAR const*pUri,
    IN  SS_CHAR const*pResponse,
    IN  SS_CHAR const*pCnonce,
    IN  SS_CHAR const*pNc,
    IN  SS_CHAR const*pQop)
{
    char sresponse[128] = "";
    char sBuf[512] = "";
    if (NULL==pUserName||NULL==pPassword||NULL==pRealm||NULL==pNonce||NULL==pUri||
        NULL==pResponse||NULL==pCnonce||NULL==pNc||NULL==pQop)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"UserName=%p,Password=%p,Realm=%p,Nonce=%p,Uri=%p,Response=%p,"
            "Cnonce=%p,Nc=%p,Qop=%p",pUserName,pPassword,pRealm,pNonce,pUri,pResponse,pCnonce,pNc,pQop);
#endif
            return  SS_ERR_PARAM;
    }
    SS_snprintf(sBuf,sizeof(sBuf),"%s%s%s%s%s%s%s%sABC",pRealm,pNonce,pUri,pCnonce,pNc,pQop,pUserName,pPassword);
    SS_md5_md5(sBuf,sresponse);
    if (strcmp(sresponse,pResponse))
    {
        return  SS_FALSE;
    }
    return  SS_TRUE;
}

