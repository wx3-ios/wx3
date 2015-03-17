// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__99DC076C_431F_41F0_A2A0_960CBB87E80D__INCLUDED_)
#define AFX_STDAFX_H__99DC076C_431F_41F0_A2A0_960CBB87E80D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define VC_EXTRALEAN        // Exclude rarely-used stuff from Windows headers



#if defined(_MSC_VER)

#include <afx.h>
#include <afxwin.h>

#endif

#include "cc.h"

#if defined(_MSC_VER)

#  include "cc_msvc.h"
#pragma comment(lib,"ilbc.lib")
#pragma comment(lib,"gsm.lib")
#pragma comment(lib,"silk.lib")




#elif defined(__GNUC__)
#  include "cc_gcc.h"
#elif defined(__CW32__)
#  include "cc_mwcc.h"
#elif defined(__MWERKS__)
#  include "cc_codew.h"
#elif defined(__GCCE__)
#  include "cc_gcce.h"
#elif defined(__ARMCC__)
#  include "cc_armcc.h"
#else
#  error "Unknown compiler."
#endif


#include "it_lib_macro_def.h"
#include "sqlite3.h"

//#include "SKP_Silk_SDK_API.h"
//#include "./ilbc/iLBC_encode.h"
//#include "./ilbc/iLBC_decode.h"
//#include "./gsm/gsm.h"


#if defined(_MSC_VER)
void IT_Gb2312_2_Unicode(unsigned short* dst, const char * src);
void IT_Unicode_2_UTF8(char* dst, unsigned short* src);
int  IT_GB2312_2_UTF8(char * buf, int buf_len, const char * src, int src_len);
#endif




#include "ss.h"
#include "ss_md5.h"
#include "ss_g711.h"
#include "it_lib_audio.h"
#include "it_lib_context.h"
#include "reg_msg.h"
#include "it_lib_db.h"
#include "it_lib_files.h"
#include "it_lib_im.h"
#include "it_lib_sms.h"
#include "it_lib_addr_book.h"
#include "it_lib_call.h"
#include "it_lib_log.h"

extern  IT_Handle  g_s_ITLibHandle;


SS_SHORT  IT_Connect();
SS_SHORT  IT_SendHeartBeat();


SS_SHORT IT_RegisterCFM           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UnregisterCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UpdatePasswordCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_FindPasswordCFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UpdateLoginStateCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_FriendLoginStateChange(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_CurVersionCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UpdateCPUID_CFM       (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_RemoteLoginIND        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_SYS_MSG               (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_SYSMerchantMSG        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_SYSEnterpriseMSG      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_SYSPersonalMSG        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_WindowShock           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_GetBalanceCFM         (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_GetUserInfoCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_GetPhoneCheckCodeCFM  (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);

SS_SHORT IT_LoginCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_LogoutCFM             (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UploadPhoneInfoCFM    (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UploadUserInfoCFM     (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_ReportTokenCFM        (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UpdateREGShopCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_AboutCFM              (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_AboutHelpCFM          (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_AboutProtocolCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_AboutFeedBackCFM      (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_RechargeCFM           (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_GetRechargePreferentialCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_UpdateBoundMobileNumberCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_GetCreditBalanceCFM   (IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);
SS_SHORT IT_SelectPhoneCheckCodeCFM(IN PIT_Handle s_pHandle,IN PIT_RecvData const s_pRecvData);


SS_SHORT IT_CharProc(IN SS_CHAR const*pSrc,OUT SS_CHAR *pDest);

SS_SHORT IT_BindRTPAddr(
    IN  SS_CHAR   const*pIP,
    IN  SS_USHORT const usnMinPort,
    IN  SS_USHORT const usnMaxPort,
    IN  SS_USHORT *usnCurPort,
    IN  SS_USHORT *usnPort,
    IN  SS_Socket *Socket);
SS_CHAR const* IT_GetCallStatusString(IN SS_CallStatus const e_CallStatus);


// TODO: reference additional headers your program requires here

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__99DC076C_431F_41F0_A2A0_960CBB87E80D__INCLUDED_)
