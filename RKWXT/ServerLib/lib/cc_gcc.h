/* $Id: cc_gcc.h 4704 2014-01-16 05:30:46Z ming $ */
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
#ifndef __IT_COMPAT_CC_GCC_H__
#define __IT_COMPAT_CC_GCC_H__

/**
 * @file cc_gcc.h
 * @brief Describes GCC compiler specifics.
 */

#ifndef __GNUC__
#  error "This file is only for gcc!"
#endif

#include <pthread.h>
//#include <curses.h>
#include <dirent.h>
#include <unistd.h>
//#include <utmp.h>
#include <signal.h>
#include <stddef.h>
#include <stdarg.h>
#include <syslog.h>
#include <setjmp.h>
#include <dlfcn.h>
#include <pwd.h>
#include <limits.h>
#include <locale.h>
#include <termios.h>
//#include <term.h>
#include <assert.h>
#include <pthread.h>
#include <netdb.h>
//#include <ncurses.h>
#include <grp.h>
#include <getopt.h>
#include <regex.h>
#include <time.h>
#include <netinet/tcp.h>
#include <sys/wait.h>
#include <sys/mman.h>
//#include <sys/msg.h>
#include <sys/un.h>
#include <sys/ipc.h>
#include <sys/ioctl.h>
//#include <sys/sem.h>
//#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/socket.h>
//#include <sys/signal.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/time.h>
#include <sys/timeb.h>
#include <sys/resource.h>
#include <sys/utsname.h>
//#include <sys/dir.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/param.h>
#include <sys/ioctl.h>  
#include <net/if.h>
//#include <net/if_arp.h>

#ifdef SOLARIS 
#include <sys/sockio.h> 
#endif 


#include <assert.h>
#include <dirent.h>
#include <ctype.h>
#include <errno.h>
#include <getopt.h>



#include <dirent.h>
#include <fcntl.h>
#include <fnmatch.h>
//#include <glob.h>
#include <grp.h>
#include <pwd.h>
#include <regex.h>
//#include <tar.h>
#include <termios.h>
#include <unistd.h>
#include <utime.h>
//#include <wordexp.h>


#include <net/if.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/mman.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/times.h>
#include <sys/types.h>
#include <sys/un.h>
#include <sys/utsname.h>
#include <sys/wait.h>
//#include <cpio.h>
#include <dlfcn.h>
//#include <fmtmsg.h>
//#include <ftw.h>
//#include <iconv.h>
//#include <langinfo.h>
#include <libgen.h>
//#include <monetary.h>
//#include <nl_types.h>
#include <poll.h>
//#include <search.h>
#include <strings.h>
#include <syslog.h>
//#include <ucontext.h>
//#include <ulimit.h>
//#include <utmpx.h>
#include <sys/ipc.h>
//#include <sys/msg.h>
#include <sys/resource.h>
//#include <sys/sem.h>
//#include <sys/shm.h>
//#include <sys/statvfs.h>
#include <sys/time.h>
#include <sys/timeb.h>
#include <sys/uio.h>
//#include <aio.h>
//#include <mqueue.h>
#include <sched.h>
#include <semaphore.h>
//#include <spawn.h>
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <float.h>
#include <iso646.h>
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
//#include <algorithm>
//#include <bitset>
#include <cctype>
#include <cerrno>
#include <cfloat>
//#include <ciso646>
#include <climits>
//#include <clocale>
#include <cmath>
//#include <complex>
#include <csignal>
#include <csetjmp>
//#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <cwchar>
//#include <cwctype>
//#include <deque>
//#include <exception>
//#include <fstream>
//#include <functional>
//#include <limits>
//#include <list>
//#include <locale>
//#include <map>
//#include <memory>
#include <new>
//#include <numeric>
//#include <iomanip>
//#include <ios>
//#include <iosfwd>
//#include <iostream>
//#include <istream>
//#include <iterator>
//#include <ostream>
//#include <queue>
//#include <set>
//#include <sstream>
//#include <stack>
//#include <stdexcept>
//#include <streambuf>
//#include <string>
#include <typeinfo>
#include <utility>
//#include <valarray>
//#include <vector>

*/




//////////////////////////////////////////////////////////////////////////


#define IT_CC_NAME        "gcc"
#define IT_CC_VER_1        __GNUC__
#define IT_CC_VER_2        __GNUC_MINOR__

/* __GNUC_PATCHLEVEL__ doesn't exist in gcc-2.9x.x */
#ifdef __GNUC_PATCHLEVEL__
#   define IT_CC_VER_3        __GNUC_PATCHLEVEL__
#else
#   define IT_CC_VER_3        0
#endif



#define IT_THREAD_FUNC    
#define IT_NORETURN        

#define IT_HAS_INT64        1

#ifdef __STRICT_ANSI__
  #include <inttypes.h> 
  typedef int64_t        SS_INT64,*PSS_INT64;
  typedef uint64_t        SS_UINT64,*PSS_UINT64;
  #define IT_INLINE_SPECIFIER    static __inline
  #define IT_ATTR_NORETURN    
  #define IT_ATTR_MAY_ALIAS    
#else
  typedef long long                SS_INT64,*PSS_INT64;
  typedef unsigned long long    SS_UINT64,*PSS_UINT64;
  #define IT_INLINE_SPECIFIER    static inline
  #define IT_ATTR_NORETURN    __attribute__ ((noreturn))
  #define IT_ATTR_MAY_ALIAS    __attribute__((__may_alias__))
#endif

#define IT_INT64(val)        val##LL
#define IT_UINT64(val)        val##ULL
#define IT_INT64_FMT        "L"


#ifdef __GLIBC__
#   define IT_HAS_BZERO        1
#endif

#define IT_UNREACHED(x)            

#define IT_ALIGN_DATA(declaration, alignment) declaration __attribute__((aligned (alignment)))

#define IT_API 


typedef struct
{
    time_t      m_Sec;         /* seconds */
    suseconds_t m_USec;        /* microseconds */
}                          SS_Times,        *PSS_Times;

typedef SS_Times           SS_Timeval,        *PSS_Timeval;
typedef pthread_t          SS_THREAD_T,       *PSS_THREAD_T;
typedef pthread_attr_t     SS_THREAD_ATTR_T,  *PSS_THREAD_ATTR_T;
typedef pthread_mutex_t    SS_THREAD_MUTEX_T, *PSS_THREAD_MUTEX_T;

/*Socket*/
typedef SS_UINT32           SS_Socket,        *PSS_Socket;
typedef struct sockaddr_in  SS_SOCKADDR_IN,   *PSS_SOCKADDR_IN;
typedef SS_UINT32           SS_WORD,          *PSS_WORD;
typedef SS_UINT32           SS_WSADATA,       *PSS_WSADATA;


#define  SS_ADDR_HANDEL (struct sockaddr*)
#define  SS_ADDR_LEN_HANDEL (socklen_t*)


#define   SS_PATH "/"
#define   SS_Print64d "%lld"
#define   SS_Print64u "%llu"
#define   SS_Print64x "%llx"
#define   SS_GETUintIPV4Value(_s_Addr_) (_s_Addr_).sin_addr.s_addr
#define   SS_GETUintIPV4Value_p(_s_Addr_p_) (_s_Addr_p_)->sin_addr.s_addr
#define   SS_SETUintIPV4Value(_s_Addr_,_Value_) (_s_Addr_).sin_addr.s_addr=_Value_

#define   SS_closesocket close


#define SS_GET_NONCE_DATETIME_P(DateTime) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    (DateTime)->m_Sec  = tv.tv_sec; \
    (DateTime)->m_USec = tv.tv_usec; \
} while (0)

#define SS_GET_NONCE_DATETIME(DateTime) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    (DateTime).m_Sec  = tv.tv_sec; \
    (DateTime).m_USec = tv.tv_usec; \
} while (0)

#define SS_GET_TIMES_P(DateTime) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    (DateTime)->m_Sec  = tv.tv_sec; \
    (DateTime)->m_USec = tv.tv_usec; \
} while (0)

#define SS_GET_TIMES(DateTime) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    (DateTime).m_Sec  = tv.tv_sec; \
    (DateTime).m_USec = tv.tv_usec; \
} while (0)

#define SS_GET_SECONDS_P(_un32Seconds_)\
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    *(_un32Seconds_)= tv.tv_sec; \
} while (0)

#define SS_GET_SECONDS(_un32Seconds_)\
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    _un32Seconds_= tv.tv_sec; \
} while (0)

#define SS_GET_MILLISECONDS_P(_un64Milliseconds_) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    *(_un64Milliseconds_) = tv.tv_sec;\
    *(_un64Milliseconds_)=((*(_un64Milliseconds_))*1000000)+tv.tv_usec;\
} while (0)

#define SS_GET_MILLISECONDS(_un64Milliseconds_) \
do {\
    struct timeval tv; \
    struct timezone tz; \
    gettimeofday(&tv,&tz); \
    _un64Milliseconds_= tv.tv_sec;\
    _un64Milliseconds_=(_un64Milliseconds_*1000000)+tv.tv_usec;\
} while (0)


#define SS_SLEEP(__TIME) sleep(__TIME)
#define SS_USLEEP(__TIME) usleep(__TIME)



#define   SS_strcasestr                strcasestr
#define   SS_strcasecmp                strcasecmp
#define   SS_strncasecmp               strncasecmp
#define   SS_strcasechr                SS_String_StrCaseChr

#define   SS_aTo64(sBuf)               atoll(sBuf)
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

#define   SS_un64Toa(un64,sBuf)        sprintf(sBuf,"%llu",un64)
#define   SS_64Toa(un64,sBuf)          sprintf(sBuf,"%llu",un64)
#define   SS_64Toa_16(un64,sBuf)       sprintf(sBuf,"%llX",un64)

#define   SS_32Toa(n32,sBuf)           sprintf(sBuf,"%d",n32)
#define   SS_un32Toa(un32,sBuf)        sprintf(sBuf,"%u",un32)
#define   SS_ato32(sBuf,n32)           n32 = atoi(sBuf)
#define   SS_atoun32(sBuf,un32)        un32= atol(sBuf)


#define   SS_un64ToBuf(un64,sBuf)      memcpy(sBuf,&un64,8);
#define   SS_BufToun64(sBuf,un64)      memcpy(&un64,sBuf,8);

//un64 = *(SS_UINT64*)(sBuf);

typedef SS_VOID*  SS_DLLHandle;
typedef SS_CHAR*  SS_DLLErrorHandle; 

#define   SS_DLLOpen(handle,filename,flag) handle = dlopen(filename,flag)
#define   SS_DLLClose(handle)                 dlclose(handle)
#define   SS_DLLGetFunAddr(handle,FunName)    dlsym(handle,FunName)
#define   SS_DLLGetError()                    dlerror()
#define   SS_DLLFreeErrorHandle(ErrorHandle)      




#endif    /* __IT_COMPAT_CC_GCC_H__ */

