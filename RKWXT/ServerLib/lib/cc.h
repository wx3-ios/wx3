/* $Id: cc_gcc.h 4704 2014-01-16 05:30:46Z ming $ */
/* 
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
#ifndef __IT_COMPAT_CC_H__
#define __IT_COMPAT_CC_H__



typedef unsigned char        SS_BOOL,*PSS_BOOL;
typedef char                 SS_CHAR,*PSS_CHAR;
typedef unsigned char        SS_BYTE,*PSS_BYTE;
typedef signed short         SS_SHORT,*PSS_SHORT;
typedef unsigned short       SS_USHORT,*PSS_USHORT;
typedef signed char          SS_INT8,*PSS_INT8;
typedef unsigned char        SS_UINT8,*PSS_UINT8;
typedef signed short         SS_INT16,*PSS_INT16;
typedef unsigned short       SS_UINT16,*PSS_UINT16;
typedef signed int           SS_INT32,*PSS_INT32;
typedef unsigned int         SS_UINT32,*PSS_UINT32;
typedef float                SS_FLOAT,*PSS_FLOAT;
typedef double               SS_DOUBLE,*PSS_DOUBLE;
typedef void                 SS_VOID,*PSS_VOID;

typedef struct SS_str{
    SS_CHAR*  m_s;   /**< string as char array */
    SS_INT32  m_len; /**< string length, not including null-termination */
}SS_str,*PSS_str;


typedef struct
{
    SS_INT32 m_n32Sec;          /* seconds */
    SS_INT32 m_n32Min;          /* minutes */
    SS_INT32 m_n32Hour;         /* hours */
    SS_INT32 m_n32Mday;         /* day of the month */
    SS_INT32 m_n32Mon;          /* month */
    SS_INT32 m_n32Year;         /* year */
    SS_INT32 m_n32Wday;         /* day of the week */
    SS_INT32 m_n32Yday;         /* day in the year */
    SS_INT32 m_n32Isdst;        /* daylight saving time */
}SS_Time,*PSS_Time;


#define   SS_un64_max_value   0xffffffffffffffff
#define   SS_un32_max_value   0xffffffff
#define   SS_un16_max_value   0xffff 
#define   SS_un8_max_value    0xff
#define   LOG_MAX_BUF  (1024*100)



#define SS_PROCESSES_STATE_IDLE          0
#define SS_PROCESSES_STATE_START         1
#define SS_PROCESSES_STATE_STOP          2
#define SS_PROCESSES_STATE_REBOOT        3
#define SS_PROCESSES_STATE_RUNING        4
#define SS_PROCESSES_STATE_WAIT          5
#define SS_PROCESSES_STATE_EXIT          6
#define SS_PROCESSES_STATE_CATCH_EXIT    7


#define SS_THREAD_STATE_IDLE          0
#define SS_THREAD_STATE_START         1
#define SS_THREAD_STATE_STOP          2
#define SS_THREAD_STATE_REBOOT        3
#define SS_THREAD_STATE_RUNING        4
#define SS_THREAD_STATE_WAIT          5
#define SS_THREAD_STATE_EXIT          6
#define SS_THREAD_STATE_CATCH_EXIT    7



#define  SS_malloc(size)  malloc((size)+4)
#define  SS_free(p)       if (p) free(p);p=NULL
#define  SS_sizeof(Buf)   (sizeof(Buf))
#define  SS_new(obj)      new obj
#define  SS_delete(obj)   if (obj) delete obj


#ifndef   SS_PATH_MAX
#define   SS_PATH_MAX 256
#endif

#ifndef   SS_PATH_MAX
#define   SS_PATH_MAX 256
#endif

#define   SS_IP_SIZE         40
#define   SS_PASSWORD_SIZE   32
#define   SS_MSG_HEADER_SIZE 100


#define   SS_INBOUND   'I'
#define   SS_OUTBOUND  'O'
#define   SS_INCOMING  'I'
#define   SS_OUTGOING  'O'
#define   SS_INGRESS   'I'
#define   SS_EGRESS    'O'

#define   SS_IP_SIZE   40

#ifndef IN
#define IN
#endif

#ifndef OUT
#define OUT
#endif

#ifndef SS_FALSE
#define SS_FALSE 0
#endif

#ifndef SS_TRUE
#define SS_TRUE 1 
#endif

#ifndef SS_NO
#define SS_NO 0
#endif

#ifndef SS_OK
#define SS_OK 1 
#endif


#define  OS_WIN_32   0  //WIN 32
#define  OS_WIN_64   1  //WIN 64
#define  OS_LINUX_32 2  //Linux 32
#define  OS_LINUX_64 3  //Linux 64


#define   SS_SUCCESS       0    //成功
#define   SS_FAILURE       1    //未知的原因
#define   SS_ERR_PARAM     2    //参数错误
#define   SS_ERR_MEMORY    3    //内存分配出错
#define   SS_ERR_STATE     4    //状态错误
#define   SS_ERR_ACTION    5    //执行错误
#define   SS_ERR_PARSE     6    //解析错误
#define   SS_ERR_TIME_OUT  7    //超时
#define   SS_ERR_NETWORK_IDLE        8  //网络连接一直都没有建立
#define   SS_ERR_NETWORK_DISCONNECT  9  //网络连接断开
#define   SS_ERR_NOTFOUND  10
#define   SS_ERR_NO_INIT_DB 11  //调用这个函数前没有初始化数据库
#define   SS_ERR_CALL       12  //通话中，或通话还没有结束
#define   SS_ERR_NOT_LOGIN  13  //没有登录，至少登录成功一次才能调用这个API
#define   SS_ERR_NO_ACCOUNT 250




#define   SS_RECV          1
#define   SS_SEND          2
#define   SS_SENDRECV      3

#define   SS_IN            1
#define   SS_OUT           2

#define   LTD_NAME   "woxin"


typedef enum {
    SIP_SDP_IDLE=0,
    SIP_SDP_SEND_RECV=1,
    SIP_SDP_SEND_ONLY=2,
    SIP_SDP_RECV_ONLY=3,
    SIP_SDP_INACTIVE =4//inactive 不活跃 待用
}SS_SDPDirection;



#define   SS_strncat strncat 


#define   SS_SOCKET_ERROR -1


#define SS_INIT_str(_str_)  (_str_).m_s=NULL;(_str_).m_len=0

#define SS_ADD_str_ex(_Result_,_str_1,_str_2)\
do {\
    (_Result_).m_len=(_str_1).m_len+(_str_2).m_len;\
    if ((_Result_).m_s = (SS_CHAR*)SS_malloc((_Result_).m_len))\
    {\
        (_Result_).m_s[(_Result_).m_len] = 0;\
        memcpy((_Result_).m_s,(_str_1).m_s,(_str_1).m_len);\
        memcpy((_Result_).m_s+(_str_1).m_len,(_str_2).m_s,(_str_2).m_len);\
    }\
}while (0)


#define SS_ADD_str(_str_,_Source_)\
do {\
    (_str_).m_len=strlen(_Source_);\
    if ((_str_).m_s = (SS_CHAR*)SS_malloc((_str_).m_len))\
    {\
        (_str_).m_s[(_str_).m_len] = 0;\
        memcpy((_str_).m_s,_Source_,(_str_).m_len);\
    }\
}while (0)

#define SS_ADD_str_len(_str_,_Source_,_len_)\
do {\
    (_str_).m_len=_len_;\
    if ((_str_).m_s = (SS_CHAR*)SS_malloc((_str_).m_len))\
    {\
        (_str_).m_s[(_str_).m_len] = 0;\
        memcpy((_str_).m_s,_Source_,(_str_).m_len);\
    }\
}while (0)

#define SS_COPY_str(_str_,_Source_)\
do {\
    (_str_).m_len=(_Source_).m_len;\
    if ((_str_).m_s = (SS_CHAR*)SS_malloc((_str_).m_len))\
    {\
        (_str_).m_s[(_str_).m_len] = 0;\
        memcpy((_str_).m_s,(_Source_).m_s,(_str_).m_len);\
    }\
}while (0)


#define SS_DEL_str(_str_)\
do {\
    (_str_).m_len=0;\
    SS_free((_str_).m_s);\
    (_str_).m_s=NULL;\
}while (0)

#define SS_ADD_str_p(_str_p,_Source_)\
do {\
    (_str_p)->m_len=strlen(_Source_);\
    if ((_str_p)->m_s = (SS_CHAR*)SS_malloc((_str_p)->m_len))\
    {\
        (_str_p)->m_s[(_str_p)->m_len] = 0;\
        memcpy((_str_p)->m_s,_Source_,(_str_p)->m_len);\
    }\
}while (0)

#define SS_ADD_str_p_len(_str_p,_Source_,_len_)\
do {\
    (_str_p)->m_len=_len_;\
    if ((_str_p)->m_s = (SS_CHAR*)SS_malloc((_str_p)->m_len))\
    {\
        (_str_p)->m_s[(_str_p)->m_len] = 0;\
        memcpy((_str_p)->m_s,_Source_,(_str_p)->m_len);\
    }\
}while (0)


#define SS_COPY_str_p(_str_p,_Source_)\
do {\
    (_str_p)->m_len=(_Source_)->m_len;\
    if ((_str_p)->m_s = (SS_CHAR*)SS_malloc((_str_p)->m_len))\
    {\
        (_str_p)->m_s[(_str_p)->m_len] = 0;\
        memcpy((_str_p)->m_s,(_Source_)->m_s,(_str_p)->m_len);\
    }\
}while (0)


#define SS_DEL_str_p(_str_)\
do {\
    (_str_)->m_len=0;\
    SS_free((_str_)->m_s);\
    (_str_)->m_s=NULL;\
}while (0)


#define   SS_hex_num_to_hex_capital_char(ub)\
   ((0 == (SS_BYTE)(ub)) ? '0' :\
    (1 == (SS_BYTE)(ub)) ? '1' :\
    (2 == (SS_BYTE)(ub)) ? '2' :\
    (3 == (SS_BYTE)(ub)) ? '3' :\
    (4 == (SS_BYTE)(ub)) ? '4' :\
    (5 == (SS_BYTE)(ub)) ? '5' :\
    (6 == (SS_BYTE)(ub)) ? '6' :\
    (7 == (SS_BYTE)(ub)) ? '7' :\
    (8 == (SS_BYTE)(ub)) ? '8' :\
    (9 == (SS_BYTE)(ub)) ? '9' :\
    (10== (SS_BYTE)(ub)) ? 'A' :\
    (11== (SS_BYTE)(ub)) ? 'B' :\
    (12== (SS_BYTE)(ub)) ? 'C' :\
    (13== (SS_BYTE)(ub)) ? 'D' :\
    (14== (SS_BYTE)(ub)) ? 'E' :\
    (15== (SS_BYTE)(ub)) ? 'F' : '0')

#define   SS_hex_num_to_hex_lower_char(ub)\
   ((0 == (SS_BYTE)(ub)) ? '0' :\
    (1 == (SS_BYTE)(ub)) ? '1' :\
    (2 == (SS_BYTE)(ub)) ? '2' :\
    (3 == (SS_BYTE)(ub)) ? '3' :\
    (4 == (SS_BYTE)(ub)) ? '4' :\
    (5 == (SS_BYTE)(ub)) ? '5' :\
    (6 == (SS_BYTE)(ub)) ? '6' :\
    (7 == (SS_BYTE)(ub)) ? '7' :\
    (8 == (SS_BYTE)(ub)) ? '8' :\
    (9 == (SS_BYTE)(ub)) ? '9' :\
    (10== (SS_BYTE)(ub)) ? 'a' :\
    (11== (SS_BYTE)(ub)) ? 'b' :\
    (12== (SS_BYTE)(ub)) ? 'c' :\
    (13== (SS_BYTE)(ub)) ? 'd' :\
    (14== (SS_BYTE)(ub)) ? 'e' :\
    (15== (SS_BYTE)(ub)) ? 'f' : '0')

#define   SS_hex_char_to_hex_num(ch)\
   (('0'==(SS_CHAR)(ch)) ? 0  :\
    ('1'==(SS_CHAR)(ch)) ? 1  :\
    ('2'==(SS_CHAR)(ch)) ? 2  :\
    ('3'==(SS_CHAR)(ch)) ? 3  :\
    ('4'==(SS_CHAR)(ch)) ? 4  :\
    ('5'==(SS_CHAR)(ch)) ? 5  :\
    ('6'==(SS_CHAR)(ch)) ? 6  :\
    ('7'==(SS_CHAR)(ch)) ? 7  :\
    ('8'==(SS_CHAR)(ch)) ? 8  :\
    ('9'==(SS_CHAR)(ch)) ? 9  :\
    ('a'==(SS_CHAR)(ch)) ? 10 :\
    ('A'==(SS_CHAR)(ch)) ? 10 :\
    ('b'==(SS_CHAR)(ch)) ? 11 :\
    ('B'==(SS_CHAR)(ch)) ? 11 :\
    ('c'==(SS_CHAR)(ch)) ? 12 :\
    ('C'==(SS_CHAR)(ch)) ? 12 :\
    ('d'==(SS_CHAR)(ch)) ? 13 :\
    ('D'==(SS_CHAR)(ch)) ? 13 :\
    ('e'==(SS_CHAR)(ch)) ? 14 :\
    ('E'==(SS_CHAR)(ch)) ? 14 :\
    ('f'==(SS_CHAR)(ch)) ? 15 :\
    ('F'==(SS_CHAR)(ch)) ? 15 :0)

#define   SS_byte_to_hex_str(ub,pbuf)\
do{\
    *(pbuf) = SS_hex_num_to_hex_capital_char((ub)>>4);/*高4位*/\
    *((pbuf)+1) = SS_hex_num_to_hex_capital_char((ub)&0x0f);/*低4位*/\
} while (0)

#define   SS_hex_str_to_byte(pbuf,ub) ub = ((SS_BYTE)((SS_hex_char_to_hex_num(*(pbuf)))<<4))+SS_hex_char_to_hex_num(*(pbuf+1))

#define   SS_short_to_hex_str(usn,pbuf)\
do{\
    SS_byte_to_hex_str(((SS_BYTE)((usn)>>8)),pbuf);\
    SS_byte_to_hex_str(((SS_BYTE)(usn)),pbuf+2);\
} while (0)

#define   SS_hex_str_to_short(pbuf,usn)\
do{\
    SS_BYTE ub1;\
    SS_BYTE ub2;\
    SS_hex_str_to_byte(pbuf  ,ub1);\
    SS_hex_str_to_byte(pbuf+2,ub2);\
    usn = (SS_USHORT)((ub1)<<8)+(SS_USHORT)((ub2));\
} while (0)

#define   SS_INT32_to_hex_str(un32,pbuf)\
do{\
    SS_byte_to_hex_str(((SS_BYTE)((un32)>>24)),pbuf);\
    SS_byte_to_hex_str(((SS_BYTE)((un32)>>16)),pbuf+2);\
    SS_byte_to_hex_str(((SS_BYTE)((un32)>>8)),pbuf+4);\
    SS_byte_to_hex_str(((SS_BYTE)(un32)),pbuf+6);\
} while (0)


#define   SS_hex_str_to_long(pbuf,un32)\
do{\
    SS_BYTE ub1;\
    SS_BYTE ub2;\
    SS_BYTE ub3;\
    SS_BYTE ub4;\
    SS_hex_str_to_byte(pbuf  ,ub1);\
    SS_hex_str_to_byte(pbuf+2,ub2);\
    SS_hex_str_to_byte(pbuf+4,ub3);\
    SS_hex_str_to_byte(pbuf+6,ub4);\
    un32 = (SS_UINT32)((ub1)<<24)+(SS_UINT32)((ub2)<<16)+(SS_UINT32)((ub3)<<8)+(ub4);\
} while (0)



#define   SS_char_to_num(ch)\
    (('0'==(SS_CHAR)(ch)) ? 0  :\
    ('1'==(SS_CHAR)(ch)) ? 1  :\
    ('2'==(SS_CHAR)(ch)) ? 2  :\
    ('3'==(SS_CHAR)(ch)) ? 3  :\
    ('4'==(SS_CHAR)(ch)) ? 4  :\
    ('5'==(SS_CHAR)(ch)) ? 5  :\
    ('6'==(SS_CHAR)(ch)) ? 6  :\
    ('7'==(SS_CHAR)(ch)) ? 7  :\
    ('8'==(SS_CHAR)(ch)) ? 8  :\
    ('9'==(SS_CHAR)(ch)) ? 9  :0)

#define   SS_num_to_char(_no_)\
    ((0==(_no_)) ? '0'  :\
    (1==(_no_)) ? '1'  :\
    (2==(_no_)) ? '2'  :\
    (3==(_no_)) ? '3'  :\
    (4==(_no_)) ? '4'  :\
    (5==(_no_)) ? '5'  :\
    (6==(_no_)) ? '6'  :\
    (7==(_no_)) ? '7'  :\
    (8==(_no_)) ? '8'  :\
    (9==(_no_)) ? '9'  :' ')




//标准化日期 2012-2-2 标准化为 2012-02-02
#define  SS_StandardizationData(sSourceData,sDestData)\
{\
    SS_CHAR *p=sSourceData+5;\
    sDestData[0] = sSourceData[0];\
    sDestData[1] = sSourceData[1];\
    sDestData[2] = sSourceData[2];\
    sDestData[3] = sSourceData[3];\
    sDestData[4] = '-';\
    if ('-' == *(p+1))\
    {\
        sDestData[5] = '0';\
        sDestData[6] = *p;p++;\
        sDestData[7] = '-';p++;\
    }\
    else\
    {\
        sDestData[5] = *p;p++;\
        sDestData[6] = *p;p++;\
        sDestData[7] = '-';p++;\
    }\
    if (0 == *(p+1)||' ' == *(p+1))\
    {\
        sDestData[8] = '0';\
        sDestData[9] = *p;\
    }\
    else\
    {\
        sDestData[8] = *p;p++;\
        sDestData[9] = *p;p++;\
    }\
}

//
// 时间转换
//2020-02-28
#define  SS_YearMonthDayToInt(_String_,_un32_) \
do {\
    char s[3] = "";\
    s[0] = *(_String_);\
    s[1] = *((_String_)+1);\
    _un32_ = (SS_UINT32)((atol(s))<<24)+(SS_UINT32)((atol((_String_)+2))<<16)+(SS_UINT32)((atol((_String_)+5))<<8)+(atol((_String_)+8));\
} while (0)

#define  SS_IntToYearMonthDay(_un32_,_String_) sprintf(_String_,"%02u%02u-%02u-%02u",(SS_BYTE)((_un32_)>>24),(SS_BYTE)((_un32_)>>16),(SS_BYTE)((_un32_)>>8),(SS_BYTE)(_un32_))
// 22:50:30   01:01:05
#define  SS_HourMinuteSecondToInt(_String_,_un32_) _un32_ = (SS_UINT32)((atol(_String_))<<24)+(SS_UINT32)((atol((_String_)+3))<<16)+(atol((_String_)+6)<<8)
#define  SS_IntToHourMinuteSecond(_un32_,_String_) sprintf(_String_,"%02u:%02u:%02u",(SS_BYTE)((_un32_)>>24),(SS_BYTE)((_un32_)>>16),(SS_BYTE)((_un32_)>>8))

// 2020-02-28 22:50:30   01:01:05
#define  SS_YearMonthDayHourMinuteSecondToInt64(_String_,_pun64_)\
do {\
    SS_UINT32 un32_1=0,un32_2=0;\
    char *p=(char*)_pun64_;\
    char sYear[11] = "";\
    memcpy(sYear,_String_,10);\
    SS_YearMonthDayToInt(sYear,un32_1);\
    SS_HourMinuteSecondToInt(_String_+11,un32_2);\
    *(SS_UINT32*)p = htonl(un32_1);\
    *(SS_UINT32*)(p+4) = htonl(un32_2);\
} while (0)

#define  SS_Int64ToYearMonthDayHourMinuteSecond(_pun64_,_String_)\
do {\
    char *p=(char*)_pun64_;\
    SS_UINT32 un32_1=ntohl(*(SS_UINT32*)p),un32_2=ntohl(*(SS_UINT32*)(p+4));\
    SS_IntToYearMonthDay(un32_1,_String_);\
    *((_String_)+10) = ' ';\
    SS_IntToHourMinuteSecond(un32_2,(_String_)+11);\
} while (0)

   

#define  SS_IPv4ToByte(_IPv4Buf_,_ub1_,_ub2_,_ub3_,_ub4_)\
{\
    SS_CHAR const*p = _IPv4Buf_;\
    _ub1_=atoi(p);\
    while('.' != *p)p++;\
    while('.' == *p)p++;\
    _ub2_=atoi(p);\
    while('.' != *p)p++;\
    while('.' == *p)p++;\
    _ub3_=atoi(p);\
    while('.' != *p)p++;\
    while('.' == *p)p++;\
    _ub4_=atoi(p);\
}

#define  SS_IPv4Touint(IPv4Buf,un32) un32 = inet_addr(IPv4Buf)
#define  SS_uintToIPv4(un32,IPv4Buf) SS_snprintf(IPv4Buf,16,"%d.%d.%d.%d",(SS_BYTE)(un32),(SS_BYTE)((un32)>>8),(SS_BYTE)((un32)>>16),(SS_BYTE)((un32)>>24))
#define  SS_uintToByte(un32,ub1,ub2,ub3,ub4) ub1=(SS_BYTE)(un32);ub2=(SS_BYTE)((un32)>>8);ub3=(SS_BYTE)((un32)>>16);ub4=(SS_BYTE)((un32)>>24)
#define  SS_ByteTouint(ub1,ub2,ub3,ub4,un32) (un32)=(SS_UINT32)((ub4)<<24)+(SS_UINT32)((ub3)<<16)+(SS_UINT32)((ub2)<<8)+(ub1)
#define  SS_ShortToByte(usn,ub1,ub2) ub1=(SS_BYTE)((usn)>>8); ub2=(SS_BYTE)(usn)
#define  SS_ByteToShort(ub1,ub2,usn) (usn) = (SS_USHORT)((ub1)<<8)+(SS_USHORT)((ub2))
#define  SS_ByteToIPv4(ub1,ub2,ub3,ub4,psIPv4) SS_snprintf(psIPv4,16,"%d.%d.%d.%d",ub1,ub2,ub3,ub4)
#define  SS_uintToVersion(un32Version,psVersion,size) SS_snprintf((psVersion),size,"%d.%d.%d.%d",(SS_BYTE)((un32Version)>>24),(SS_BYTE)((un32Version)>>16),(SS_BYTE)((un32Version)>>8),(SS_BYTE)(un32Version))
#define  SS_VersionTouint(psVersion,un32Version)\
do {\
    SS_BYTE ub1,ub2,ub3,ub4;\
    SS_CHAR *p = psVersion;\
    ub1 = atoi(p);\
    p = strchr(p,'.');\
    p++;\
    ub2 = atoi(p);\
    p = strchr(p,'.');\
    p++;\
    ub3 = atoi(p);\
    p = strchr(p,'.');\
    p++;\
    ub4 = atoi(p);\
    (un32Version) = (SS_UINT32)(ub1<<24)+(SS_UINT32)(ub2<<16)+(SS_UINT32)(ub3<<8)+(ub4);\
} while (0)


#define   SS_strncpy   strncpy


#define        SS_IfROWString(row) ((NULL == row) ? "" : row)
#define        SS_IfROWNumber(row) ((NULL == row) ? 0 : atoi(row))
#define        SS_MAX(__a__,__b__)  (((__a__)>(__b__))? (__a__) : (__b__))
#define        SS_MIN(__a__,__b__)  (((__a__)<(__b__))? (__a__) : (__b__))
#define        SS_UNUSED_ARG(_arg) if (_arg) {}

#define   SS_TOUPPER (_c_) ((_c_) >= 'a' && (_c_) <= 'z') ? ((_c_)-32):(_c_);
#define   SS_TOLOWER (_c_) ((_c_) >= 'A' && (_c_) <= 'Z') ? ((_c_)+32):(_c_);


typedef enum {
    IT_STATUS_IDLE    =  0, // 未知,初始化
    IT_STATUS_ON_LINE =  1, // 上线
    IT_STATUS_OFF_LINE=  2, // 离线
    IT_STATUS_DISTANCE=  3, // 离开，暂时不在电脑旁边
    IT_STATUS_BUSY    =  4, // 忙碌
    IT_STATUS_CALL    =  5, // 通话中
    IT_STATUS_STEALTH =  6, // 隐身
    IT_STATUS_NOT_BOTHER=7, // 请勿打扰
    IT_STATUS_LOGIN   =  8, // 登录过程中
    IT_STATUS_LOGIN_OK=  9, // 登录成功
    IT_STATUS_LOGIN_ERR =10, // 登录失败
    IT_STATUS_LOGOUT    =11,  // 退出登录过程中
    IT_STATUS_LOGOUT_OK =12,  // 退出登录成功
    IT_STATUS_LOGOUT_ERR=13,  // 退出登录失败
    IT_STATUS_REG_SERVER_CONNECT_OK=14,  // 连接注册服务器成功
    IT_STATUS_REG_SERVER_DISCONNECT_OK=15,
	IT_STATUS_CONNECT_REG_SERVER_OK=16,
	IT_STATUS_LOGIN_NOT_ACCOUNT=17, // 登录帐号不存在
	IT_STATUS_LOGIN_TIME_OUT=18 // 登录超时
}SS_ITStatus;


typedef enum {
    SS_PROTOCOL_IDLE=0,//初始化状态
    SS_PROTOCOL_SIP =1,//SIP 协议
    SS_PROTOCOL_SS=2,//私有协议
    SS_PROTOCOL_H323=3 //H323协议
}SS_Protocol;






#endif    /* __IT_COMPAT_CC_H__ */

