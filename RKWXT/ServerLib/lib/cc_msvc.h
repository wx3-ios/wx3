/* $Id: cc_msvc.h 4624 2013-10-21 06:37:30Z ming $ */
/* 
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
#ifndef __IT_COMPAT_CC_MSVC_H__
#define __IT_COMPAT_CC_MSVC_H__

/**
 * @file cc_msvc.h
 * @brief Describes Microsoft Visual C compiler specifics.
 */

#ifndef _MSC_VER
#  error "This header file is only for Visual C compiler!"
#endif


#define VC_EXTRALEAN        // Exclude rarely-used stuff from Windows headers

#include <afx.h>
#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxdtctl.h>        // MFC support for Internet Explorer 4 Common Controls
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>            // MFC support for Windows Common Controls

#endif // _AFX_NO_AFXCMN_SUPPORT


#include <wtypes.h>
#include <iostream>
#include <io.h>
#include <time.h>
#include <afxmt.h>
#include <tchar.h>
#include <wchar.h>
#include <memory.h>
#include <afxdisp.h>
#include <wininet.h>
#include <winsock2.h>
#include <conio.h>
#include <MSWSOCK.H>
#include <windows.h>
#include <windef.h>
#include <winbase.h>
#include <BASETSD.H>
#include <BASETYPS.H>
#include <mmsystem.h>
#include "tlhelp32.h"
#include "winnt.h"
#include <WINSVC.H>
#include <mmsystem.h>
#include <afxmt.h>
#include <vfw.h>
#include <afxole.h>
#include <afxpriv.h>
#include <afxcview.h>
#include <afxadv.h>             // recent file list
#include <afxcmn.h>            // MFC support for Windows 95 Common Controls
#include <afxcview.h>            // MFC support for Windows 95 Common Controls
#include <afxhtml.h>            // MFC support for Windows 95 Common Controls
#include <afxmt.h>
#include <atlbase.h>

#pragma comment(lib,"ws2_32.lib" )
#pragma comment(lib,"Kernel32.lib")
#pragma comment(lib,"winmm.lib" )
#pragma comment(lib,"Wininet.lib" )
#pragma comment(lib,"Winmm")
#pragma comment(lib,"vfw32")
#pragma comment(lib,"sqlite.lib")

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
//#include <iconv.h>
#include <search.h>
#include <sys/timeb.h>
//#include <sched.h>
//#include <semaphore.h>
#include <ctype.h>
#include <errno.h>
#include <float.h>
#include <limits.h>
#include <locale.h>
#include <math.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wchar.h>
#include <wctype.h>
 /*
#include <algorithm>
#include <bitset>
#include <cctype>
#include <cerrno>
#include <cfloat>
#include <ciso646>
#include <climits>
#include <clocale>
#include <cmath>
#include <complex>
#include <csignal>
#include <csetjmp>
#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <cwchar>
#include <cwctype>
#include <deque>
#include <exception>
#include <fstream>
#include <functional>
#include <limits>
#include <list>
#include <locale>
#include <map>
#include <memory>
#include <new>
#include <numeric>
#include <iomanip>
#include <ios>
#include <iosfwd>
#include <iostream>
#include <istream>
#include <iterator>
#include <ostream>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <streambuf>
#include <string>
#include <typeinfo>
#include <utility>
#include <valarray>
#include <vector>*/



//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////




#define IT_CC_NAME        "msvc"
#define IT_CC_VER_1        (_MSC_VER/100)
#define IT_CC_VER_2        (_MSC_VER%100)
#define IT_CC_VER_3        0

/* Disable CRT deprecation warnings. */
#if IT_CC_VER_1 >= 8 && !defined(_CRT_SECURE_NO_DEPRECATE)
#   define _CRT_SECURE_NO_DEPRECATE
#endif
#if IT_CC_VER_1 >= 8 && !defined(_CRT_SECURE_NO_WARNINGS)
#   define _CRT_SECURE_NO_WARNINGS
    /* The above doesn't seem to work, at least on VS2005, so lets use
     * this construct as well.
     */
#   pragma warning(disable: 4996)
#endif

#pragma warning(disable: 4127) // conditional expression is constant
#pragma warning(disable: 4611) // not wise to mix setjmp with C++
#pragma warning(disable: 4514) // unref. inline function has been removed
#ifdef NDEBUG
#  pragma warning(disable: 4702) // unreachable code
#  pragma warning(disable: 4710) // function is not inlined.
#  pragma warning(disable: 4711) // function selected for auto inline expansion
#endif

#ifdef __cplusplus
#  define IT_INLINE_SPECIFIER    inline
#else
#  define IT_INLINE_SPECIFIER    static __inline
#endif

#define IT_EXPORT_DECL_SPECIFIER    __declspec(dllexport)
#define IT_EXPORT_DEF_SPECIFIER        __declspec(dllexport)
#define IT_IMPORT_DECL_SPECIFIER    __declspec(dllimport)

#define IT_THREAD_FUNC    
#define IT_NORETURN        __declspec(noreturn)
#define IT_ATTR_NORETURN    
#define IT_ATTR_MAY_ALIAS    

#define IT_HAS_INT64    1

typedef __int64          SS_INT64,*PSS_INT64;
typedef unsigned __int64 SS_UINT64,*PSS_UINT64;

#define IT_INT64(val)        val##i64
#define IT_UINT64(val)        val##ui64
#define IT_INT64_FMT        "I64"

#define IT_UNREACHED(x)            

#define IT_ALIGN_DATA(declaration, alignment) __declspec(align(alignment)) declaration

#define IT_API __declspec(dllexport)

typedef struct
{
    time_t         m_Sec;         /* seconds */
    unsigned short m_USec;        /* microseconds */
}                          SS_Times,        *PSS_Times;

typedef SYSTEMTIME        SS_Timeval,        *PSS_Timeval;
typedef HANDLE            SS_THREAD_T,       *PSS_THREAD_T;
typedef HANDLE            SS_THREAD_ATTR_T,  *PSS_THREAD_ATTR_T;
typedef CRITICAL_SECTION  SS_THREAD_MUTEX_T, *PSS_THREAD_MUTEX_T;

/*Socket*/
typedef SOCKET            SS_Socket,         *PSS_Socket;     
typedef SOCKADDR_IN       SS_SOCKADDR_IN,    *PSS_SOCKADDR_IN;
typedef WORD              SS_WORD,           *PSS_WORD;
typedef WSADATA           SS_WSADATA,        *PSS_WSADATA;


#if  _MSC_VER <= 1200
#define    __FUNCTION__     ""
#endif


#define  SS_ADDR_HANDEL (SOCKADDR*)
#define  SS_ADDR_LEN_HANDEL (int*)


#define   SS_PATH "\\"
#define   SS_Print64d "%I64d"
#define   SS_Print64u "%I64u"
#define   SS_Print64x "%I64x"
#define   SS_GETUintIPV4Value(_s_Addr_) (_s_Addr_).sin_addr.S_un.S_addr
#define   SS_GETUintIPV4Value_p(_s_Addr_p_) (_s_Addr_p_)->sin_addr.S_un.S_addr
#define   SS_SETUintIPV4Value(_s_Addr_,_Value_) (_s_Addr_).sin_addr.S_un.S_addr=_Value_


#define   SS_closesocket ::closesocket


#define SS_GET_TIMES_P(_Time_)\
do{\
    struct _timeb tstruct;\
    _ftime( &tstruct );\
    (_Time_)->m_Sec =tstruct.time;\
    (_Time_)->m_USec=tstruct.millitm;\
} while (0)

#define SS_GET_TIMES(_Time_)\
do{\
    struct _timeb tstruct;\
    _ftime( &tstruct );\
    (_Time_).m_Sec =tstruct.time;\
    (_Time_).m_USec=tstruct.millitm;\
} while (0)

#define SS_GET_SECONDS_P(_un32Seconds_)\
do {\
    struct _timeb tstruct;\
    _ftime( &tstruct );\
    *(_un32Seconds_)= tstruct.time; \
} while (0)

#define SS_GET_SECONDS(_un32Seconds_)\
do {\
    struct _timeb tstruct;\
    _ftime( &tstruct );\
    _un32Seconds_= tstruct.time; \
} while (0)


#define SS_GET_MILLISECONDS_P(_un64Milliseconds_) \
do {\
    struct _timeb tstruct;\
    _ftime(&tstruct);\
    *(_un64Milliseconds_) = tstruct.time;\
    *(_un64Milliseconds_)=((*(_un64Milliseconds_))*1000000)+(1000*tstruct.millitm);\
} while (0)

#define SS_GET_MILLISECONDS(_un64Milliseconds_) \
do {\
    struct _timeb tstruct;\
    _ftime(&tstruct);\
    _un64Milliseconds_= tstruct.time;\
    _un64Milliseconds_=(_un64Milliseconds_*1000000)+(1000*tstruct.millitm);\
} while (0)

#define SS_SLEEP(__second)                ::Sleep((__second)*1000)
#define SS_USLEEP(__microseconds)\
do {\
    SS_UINT32 un32 = ((__microseconds)*1000)/1000000;\
    ::Sleep(un32?un32:1);\
} while (0)


#define SS_GET_NONCE_DATETIME_P(DateTime) GetLocalTime(DateTime)
#define SS_GET_NONCE_DATETIME(DateTime)   GetLocalTime(&(DateTime))


#if  _MSC_VER > 1400

#define   SS_strcasestr                SS_String_StrCaseStr
#define   SS_strcasecmp                _stricmp
#define   SS_strncasecmp               _strnicmp
#define   SS_strcasechr                SS_String_StrCaseChr

#define   SS_aTo64(sBuf)               _atoi64(sBuf)
#define   SS_aToun64(sBuf,_un64_)\
do {\
    if(sBuf)\
    {\
        char const*_p_ = sBuf;\
        _un64_ = 0;\
        while (' ' == *_p_)_p_++;\
        while (*_p_ >= '0' && *_p_ <= '9')\
        {\
            _un64_ = (_un64_*10)+(*_p_-'0');\
            _p_++;\
        }\
    }\
} while (0)

#define   SS_un64Toa(un64,sBuf)        _ui64toa_s(un64,sBuf,22,10)
#define   SS_64Toa(un64,sBuf)          _i64toa_s(un64,sBuf,sizeof(sBuf),10)
#define   SS_64Toa_16(un64,sBuf)       _i64toa_s(un64,sBuf,sizeof(sBuf),16)

#define   SS_32Toa(n32,sBuf)           sprintf(sBuf,"%d",n32)
#define   SS_un32Toa(un32,sBuf)        sprintf(sBuf,"%u",un32)
#define   SS_ato32(sBuf,n32)           n32 = atoi(sBuf)
#define   SS_atoun32(sBuf,un32)        un32= atol(sBuf)


#define   SS_un64ToBuf(un64,sBuf)  memcpy(sBuf,&un64,8);
#define   SS_BufToun64(sBuf,un64)  memcpy(&un64,sBuf,8);

//un64 = *(SS_UINT64*)(sBuf);

#else

#define   SS_strcasestr                SS_String_StrCaseStr
#define   SS_strcasecmp                _stricmp
#define   SS_strncasecmp               _strnicmp
#define   SS_strcasechr                SS_String_StrCaseChr

#define   SS_aTo64(sBuf)               _atoi64(sBuf)
#define   SS_aToun64(sBuf,_un64_)\
do {\
    if(sBuf)\
    {\
        char const*_p_ = sBuf;\
        _un64_ = 0;\
        while (' ' == *_p_)_p_++;\
        while (*_p_ >= '0' && *_p_ <= '9')\
        {\
            _un64_ = (_un64_*10)+(*_p_-'0');\
            _p_++;\
        }\
    }\
} while (0)
#define   SS_un64Toa(un64,sBuf)        _i64toa(un64,sBuf,10)
#define   SS_un64ToDString(un64,c_str)\
do {\
    SS_CHAR  sBuf[32] = "";\
    SS_INT32 n32=sprintf(sBuf,"%llu",un64);\
    c_str.Copy(sBuf,n32);\
} while (0)
#define   SS_64Toa(un64,sBuf)          _i64toa(un64,sBuf,10)
#define   SS_64Toa_16(un64,sBuf)       _i64toa(un64,sBuf,16)


#define   SS_32Toa(n32,sBuf)           sprintf(sBuf,"%d",n32)
#define   SS_un32Toa(un32,sBuf)        sprintf(sBuf,"%u",un32)
#define   SS_ato32(sBuf,n32)           n32 = atoi(sBuf)
#define   SS_atoun32(sBuf,un32)        un32= atol(sBuf)

#define   SS_un64ToBuf(un64,sBuf)  memcpy(sBuf,&un64,8);
#define   SS_BufToun64(sBuf,un64)  memcpy(&un64,sBuf,8);

//un64 = *(SS_UINT64*)(sBuf);

#endif

typedef HINSTANCE  SS_DLLHandle; 
typedef LPVOID     SS_DLLErrorHandle; 

#define   RTLD_LAZY      1
#define   RTLD_NOW       2
#define   RTLD_GLOBAL    3
#define   RTLD_LOCAL     4
#define   RTLD_NODELETE  5
#define   RTLD_NOLOAD    6 
#define   RTLD_DEEPBIND  7
 
#define   SS_DLLOpen(handle,filename,flag) handle = ::LoadLibrary(filename)
#define   SS_DLLClose(handle)                 ::FreeLibrary(handle)
#define   SS_DLLGetFunAddr(handle,FunName)    ::GetProcAddress(handle,FunName)
#define   SS_DLLGetError()                    "::GetLastError()=DLL"
#define   SS_DLLFreeErrorHandle(ErrorHandle)  ::LocalFree(ErrorHandle)







#endif    /* __IT_COMPAT_CC_MSVC_H__ */

