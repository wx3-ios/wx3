/* $Id: cc_mwcc.h 4624 2013-10-21 06:37:30Z ming $ */
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
#ifndef __IT_COMPAT_CC_MWCC_H__
#define __IT_COMPAT_CC_MWCC_H__

/**
 * @file cc_mwcc.h
 * @brief Describes MWCC compiler specifics.
 */

#ifndef __CW32__
#  error "This file is only for mwcc!"
#endif

#define IT_CC_NAME        "mwcc32sym"
#define IT_CC_VER_1        1
#define IT_CC_VER_2        0
#define IT_CC_VER_3        0


#define IT_INLINE_SPECIFIER    static inline
#define IT_THREAD_FUNC    
#define IT_NORETURN        
#define IT_ATTR_NORETURN    __attribute__ ((noreturn))
#define IT_ATTR_MAY_ALIAS    

#define IT_HAS_INT64        1

typedef long long          SS_INT64,*PSS_INT64;
typedef unsigned long long SS_UINT64,*PSS_UINT64;

#define IT_INT64(val)        val##LL
#define IT_UINT64(val)        val##LLU
#define IT_INT64_FMT        "L"

#define IT_UNREACHED(x)            

#define IT_API 

#endif    /* __IT_COMPAT_CC_MWCC_H__ */

