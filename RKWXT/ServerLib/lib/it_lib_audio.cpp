// it_lib_audio.cpp: implementation of the CITLibAudio class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "it_lib_audio.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


#if defined(_MSC_VER)

DWORD CWavePlay::s_dwInstance = 0;

DWORD WINAPI CWavePlay::AudioOutThreadProc(LPVOID lpParameter)
{
    CWavePlay *pWavePlay=NULL;
    pWavePlay = (CWavePlay *)lpParameter;
    MSG msg;
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread start,Parameter=%p",lpParameter);
#endif
    try
    {
        while(GetMessage(&msg,0,0,0))
        {
            switch(msg.message )
            {
            case WOM_OPEN:
                {
#ifdef  IT_LIB_DEBUG
                    SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread WOM_OPEN,Parameter=%p",lpParameter);
#endif
                }break;
            case WOM_CLOSE:
                {
#ifdef  IT_LIB_DEBUG
                    SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread WOM_CLOSE,Parameter=%p",lpParameter);
#endif
                }break;
            case WOM_DONE:
                {
                    WAVEHDR* pwh=(WAVEHDR*)msg.lParam;
                    waveOutUnprepareHeader((HWAVEOUT)msg.wParam,pwh,sizeof(WAVEHDR));
                    pWavePlay->BufferSub ();
                    delete []pwh->lpData;//删除Play调用时分配的内存
                    delete pwh;
                }break;
            default:
                {
                }break;
            }
        }
    }
    catch (...)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread catch a error,Parameter=%p",lpParameter);
#endif
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread exit,Parameter=%p",lpParameter);
#endif
    return msg.wParam;
}

CWavePlay::CWavePlay():
     m_wChannel(1),
     m_dwSample (WINWAVE_WOSA_POOR),
     m_wBit(8)
{
    m_hOut = 0;
    m_hAudioOut = 0;
    m_dwAudioOutId = 0;
    m_iBufferNum = 0;
    m_bThreadStart = FALSE;
    m_bDevOpen = FALSE;
    s_dwInstance ++;
}

CWavePlay::~CWavePlay()
{
    StopPlay();
}

short CWavePlay::StartThread()
{
    if (m_bThreadStart)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread has run");
#endif
        return SS_FAILURE;
    }

    m_hAudioOut=CreateThread(0,0,AudioOutThreadProc,this,0,&m_dwAudioOutId);
    if(!m_hAudioOut)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"start windows wave paly thread fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    m_bThreadStart = TRUE;
    return SS_SUCCESS;
}
short CWavePlay::StopThread()
{
    if (!m_bThreadStart)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave paly thread Not run");
        return SS_FAILURE;
    }
    if(m_hAudioOut)
    {
        int t=50;
        DWORD ExitCode;
        BOOL bEnd=FALSE;
        PostThreadMessage(m_dwAudioOutId,WM_QUIT,0,0);
        while(t)
        {
            GetExitCodeThread(m_hAudioOut,&ExitCode);
            if(ExitCode!= STILL_ACTIVE)
            {
                bEnd=TRUE;
                break;
            }
            else
                ::Sleep(10);
            t--;
        }
        if(!bEnd)
        {
            //SS_Log_Printf(SS_STATUS_LOG,"Terminate windows wave paly thread");
            TerminateThread(m_hAudioOut,0);
        }
        m_hAudioOut=0;
    }
    m_bThreadStart = FALSE;
    return SS_SUCCESS;
}

short CWavePlay::OpenDev()
{
    if (m_bDevOpen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play device has open");
#endif
        return SS_FAILURE;
    }
    WAVEFORMATEX wfx;
//     wfx.wFormatTag = WAVE_FORMAT_PCM;
//     wfx.nChannels = m_wChannel;
//     wfx.nSamplesPerSec = m_dwSample;
//     wfx.nAvgBytesPerSec = m_wChannel * m_dwSample * m_wBit / 8;
//     wfx.nBlockAlign = m_wBit * m_wChannel / 8;
//     wfx.wBitsPerSample = m_wBit;
//     wfx.cbSize = 0;

//  PCMA PCMU
    wfx.wFormatTag = WAVE_FORMAT_PCM;
    wfx.nChannels = 1;
    wfx.nSamplesPerSec = 8000;
    wfx.nAvgBytesPerSec = ((1 * 8000) * 16) / 8;
    wfx.nBlockAlign = (16* 1) / 8;
    wfx.wBitsPerSample = 16;
    wfx.cbSize = 0;

    
//     wfx.wFormatTag = WAVE_FORMAT_PCM;
//     wfx.nChannels = 1;
//     wfx.nSamplesPerSec = 8000;
//     wfx.nAvgBytesPerSec = ((1 * 8000) * 8) / 8;
//     wfx.nBlockAlign = (8* 1) / 8;
//     wfx.wBitsPerSample = 8;
//     wfx.cbSize = 0;

    m_mmr=waveOutOpen (0,WAVE_MAPPER,&wfx,0,0,WAVE_FORMAT_QUERY);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play device open 1 fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }

    m_mmr=waveOutOpen(&m_hOut,WAVE_MAPPER,&wfx,m_dwAudioOutId,20,CALLBACK_THREAD);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play device open 2 fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    m_bDevOpen = TRUE;
    m_iBufferNum = 0;
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutOpen success");
#endif
    return SS_SUCCESS;
}

short CWavePlay::CloseDev()
{
    if (!m_bDevOpen)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave play device not open 1");
        return SS_FAILURE;
    }

    if(!m_hOut)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave play device not open 2");
        return SS_FAILURE;
    }
    m_mmr=waveOutReset(m_hOut);
    if(m_mmr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutReset fail");
        return SS_FAILURE;
    }
    ::Sleep(100);
    m_mmr=waveOutClose(m_hOut);
    if(m_mmr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutClose fail,%u",GetLastError());
        return SS_FAILURE;
    }
    m_hOut=0;
    m_bDevOpen = FALSE;
    //SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutClose success");
    return SS_SUCCESS;
}

short CWavePlay::StartPlay()
{
    BOOL bRet=FALSE;
    if (SS_SUCCESS != StartThread())           
    {
        return SS_FAILURE;
    }
    if (SS_SUCCESS != OpenDev())
    {
        StopThread ();
        return SS_FAILURE;
    }
    bRet = TRUE;
    return SS_SUCCESS;
}

short CWavePlay::StopPlay()
{
    CloseDev();
    StopThread ();
    return TRUE;
}

MMRESULT CWavePlay::GetLastMMError()
{
    return m_mmr;
}

CString CWavePlay::GetLastErrorString()
{
    char buffer[256];
    memset(buffer,0,256);
    waveOutGetErrorText(m_mmr,buffer,256);
    return buffer;
}


void CWavePlay::SetChannel(WORD wChannel)
{
    m_wChannel = (m_wChannel == wChannel) ? 2:1;
}

void CWavePlay::SetSample(DWORD dwSample)
{
    m_dwSample = dwSample;
}

void CWavePlay::SetBit(WORD wBit)
{
    m_wBit = (wBit == 8) ? 8:16;
}

DWORD CWavePlay::GetInstance()
{
    return s_dwInstance;
}

WORD CWavePlay::GetBit()
{
    return m_wBit;
}

DWORD CWavePlay::GetSample()
{
    return m_dwSample;
}

WORD CWavePlay::GetChannel()
{
    return m_wChannel;
}

short CWavePlay::Play(IN char const* buf,UINT uSize)
{
    if (!m_bDevOpen)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave play Device hasn't been open");
        return SS_FAILURE;
    }
    if (GetBufferNum () > WINWAVE_PLAY_DELAY)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play too big pass over");
#endif
        return SS_SUCCESS;
    }
    char* p;
    LPWAVEHDR pwh=new WAVEHDR;
    if(!pwh)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play alloc WAVEHDR memoyr error");
#endif
        return SS_FAILURE;
    }
    
    p=new char[uSize];
    if(!p)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play alloc data memoyr error");
#endif
        return SS_FAILURE;
    }

    CopyMemory(p,buf,uSize);
    ZeroMemory(pwh,sizeof(WAVEHDR));
    pwh->dwBufferLength=uSize;
    pwh->lpData=p;
    m_mmr=waveOutPrepareHeader(m_hOut,pwh,sizeof(WAVEHDR));
      if (m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutPrepareHeader fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }

    m_mmr=waveOutWrite(m_hOut,pwh,sizeof(WAVEHDR));
      if (m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave play waveOutWrite fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    m_iBufferNum ++;
    return SS_SUCCESS;
}

void CWavePlay::BufferAdd()
{
    m_csLock.Lock ();
    m_iBufferNum ++;
    m_csLock.Unlock ();
}

void CWavePlay::BufferSub()
{
    m_csLock.Lock ();
    m_iBufferNum --;
    m_csLock.Unlock ();
}

int CWavePlay::GetBufferNum()
{
    int iTemp;
    m_csLock.Lock ();
    iTemp = m_iBufferNum;
    m_csLock.Unlock ();
    return iTemp;

}

short CWavePlay::SetFormatByFile(CString file)
{
    #pragma pack(push, 1)
    struct FileHeader
    {
        char cFlagFiff[4];
        unsigned __int32 iFileLen;
        char cFlagWave[4];
        char cFlagFmt[4];
        char cResove[4];
        unsigned __int16 cFormat;
        unsigned __int16 cChannel;
        unsigned __int32 cSample;
        unsigned __int32 cBytePerSec;
        unsigned __int16 cByteprocess;
        unsigned __int16 cBit;
        char cFlagDat[4];
        unsigned __int32 iLenData;
    };
    #pragma pack(pop)

    CFile fi;
    if (!fi.Open(file,CFile::modeRead,NULL))
    {
        return SS_FAILURE;
    };
    struct FileHeader head;
    fi.Read ((void *)&head,sizeof (head));
    fi.Close ();

    this->SetChannel (head.cChannel);
    this->SetSample (head.cSample);
    this->SetBit (head.cBit);
    return SS_SUCCESS;
}


//////////////////////////////////////////////////////////////////////////




DWORD WINAPI CWaveRecordThread(LPVOID lpParameter)
{
    CWaveRecord *pHandle = (CWaveRecord*)lpParameter;
    return  pHandle->Run(lpParameter);
}
DWORD CWaveRecord::s_dwInstance = 0;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

SS_SHORT CWaveRecord::OpenDev()
{
    if (m_bDevOpen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record device is open");
#endif
        return SS_FAILURE;
    }
    WAVEFORMATEX wfx;
//     wfx.wFormatTag = WAVE_FORMAT_PCM;
//     wfx.nChannels = m_wChannel;
//     wfx.nSamplesPerSec = m_dwSample;
//     wfx.nAvgBytesPerSec = m_wChannel * m_dwSample * m_wBit / 8;
//     wfx.nBlockAlign = m_wBit * m_wChannel / 8;
//     wfx.wBitsPerSample = m_wBit;
//     wfx.cbSize = 0;

    
    //  PCMA PCMU
    wfx.wFormatTag = WAVE_FORMAT_PCM;
    wfx.nChannels = 1;
    wfx.nSamplesPerSec = 8000;
    wfx.nAvgBytesPerSec = ((1 * 8000) * 16) / 8;
    wfx.nBlockAlign = (16* 1) / 8;
    wfx.wBitsPerSample = 16;
    wfx.cbSize = 0;
    
    m_mmr=waveInOpen(0,WAVE_MAPPER,&wfx,0,0,WAVE_FORMAT_QUERY);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInOpen 1 fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    
    m_mmr=waveInOpen(&m_hIn,WAVE_MAPPER,&wfx,m_dwAudioInId,1,CALLBACK_THREAD);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInOpen 2 fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInOpen success");
#endif
    m_bDevOpen = TRUE;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::CloseDev()
{
    if (!m_bDevOpen)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record device hasn't open 1");
        return SS_FAILURE;
    }
    if(!m_hIn)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record device hasn't open 2");
        return SS_FAILURE;
    }
    m_mmr=waveInClose(m_hIn);
    if(m_mmr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInClose fail,%u",GetLastError());
        m_hIn=0;
        m_bDevOpen = FALSE;
        return SS_FAILURE;
    }
    m_hIn=0;
    m_bDevOpen = FALSE;
    return SS_SUCCESS;
}

SS_SHORT CWaveRecord::StopThread()
{
    if (!m_bThreadStart)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread hasn't run");
#endif
        return SS_FAILURE;
    }
    if(m_hAudioIn)
    {
        int t=50;
        DWORD ExitCode;
        BOOL bEnd=FALSE;
        PostThreadMessage(m_dwAudioInId,WM_QUIT,0,0);
        while(t)
        {
            GetExitCodeThread(m_hAudioIn,&ExitCode);
            if(ExitCode!= STILL_ACTIVE)
            {
                bEnd=TRUE;
                break;
            }
            else
                Sleep(10);
            t--;
        }
        if(!bEnd)
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_STATUS_LOG,"Terminate windows wave record thread");
#endif
            TerminateThread(m_hAudioIn,0);
        }
        m_hAudioIn=0;
    }
    m_bThreadStart = FALSE;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::StartThread()
{
    if (m_bThreadStart)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread has run");
#endif
        return SS_FAILURE;
    }
    m_hAudioIn=CreateThread(0,0,CWaveRecordThread,this,0,&m_dwAudioInId);
    if(!m_hAudioIn)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"Start windows wave record thread fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    m_bThreadStart = TRUE;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::GetRecordStatus()
{
    return m_bThreadStart?SS_TRUE:SS_FALSE;
}
SS_SHORT CWaveRecord::PerPareBuffer()
{
    if (m_bAllocBuffer)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record Buffer has been alloc");
#endif
        return FALSE;
    }
    m_mmr=waveInReset(m_hIn);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInReset fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    
    UINT i;
    m_pHdr=new WAVEHDR[WINWAVE_NUM_BUF];
    if (NULL == m_pHdr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record new fail,%u",GetLastError());
#endif
        return  SS_ERR_MEMORY;
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave record m_pHdr new %p",m_pHdr);
#endif
    for(i=0;i<WINWAVE_NUM_BUF;i++)
    {
        ZeroMemory(&m_pHdr[i],sizeof(WAVEHDR));
        m_pHdr[i].lpData=new char[WINWAVE_SIZE_AUDIO_FRAME];
        m_pHdr[i].dwBufferLength= WINWAVE_SIZE_AUDIO_FRAME;
        if (NULL == m_pHdr[i].lpData)
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_STATUS_LOG,"windows wave record new data fail,%u",GetLastError());
#endif
            return SS_ERR_MEMORY;
        }
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record new data %p,size=%u",
            m_pHdr[i].lpData,WINWAVE_SIZE_AUDIO_FRAME);
#endif
        m_mmr=waveInPrepareHeader(m_hIn,&m_pHdr[i],sizeof(WAVEHDR));
        if(m_mmr)
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInPrepareHeader fail,%u",GetLastError());
#endif
            return SS_FAILURE;
        }
        m_mmr=waveInAddBuffer(m_hIn,&m_pHdr[i],sizeof(WAVEHDR));
        if(m_mmr)
        {
#ifdef  IT_LIB_DEBUG
            SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInAddBuffer fail,%u",GetLastError());
#endif
            return SS_FAILURE;
        }
    }
    m_bAllocBuffer = TRUE;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::FreeBuffer()
{
    UINT i;
    if (!m_bAllocBuffer)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record Buffer hasn't been alloc");
        return SS_FAILURE;
    }
    if(!m_pHdr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record m_pHdr is NULL");
        return SS_FAILURE;
    }
    for(i=0;i<WINWAVE_NUM_BUF;i++)
    {
        m_mmr = waveInUnprepareHeader(m_hIn,&m_pHdr[i],sizeof(WAVEHDR));
        if(m_mmr)
        {
            ::Sleep(100);
            //SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInUnprepareHeader fail,%u",GetLastError());
            continue;
        }
        if(m_pHdr[i].lpData)
        {
            //SS_Log_Printf(SS_STATUS_LOG,"windows wave record free data %p,size=%u",m_pHdr[i].lpData,WINWAVE_SIZE_AUDIO_FRAME);
            delete [] m_pHdr[i].lpData;
        }
    }
    //SS_Log_Printf(SS_STATUS_LOG,"windows wave record m_pHdr free %p",m_pHdr);
    delete []m_pHdr;
    m_pHdr = NULL;
    m_bAllocBuffer = FALSE;
    return SS_SUCCESS;
}

SS_SHORT CWaveRecord::OpenRecord()
{
    if (m_bRecord)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record device has open");
#endif
        return SS_FAILURE;
    }
    if(!m_hIn)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record device hasn't opened");
#endif
        return SS_FAILURE;
    }
    
    m_mmr=waveInStart(m_hIn);
    if(m_mmr)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInStart fail,%u",GetLastError());
#endif
        return SS_FAILURE;
    }
    m_bRecord = TRUE;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::CloseRecord()
{
    if (!m_bRecord)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record,You may be hasn't begun recored");
        return SS_FAILURE;
    }
    if(!m_hIn)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record,Device hasn't opened");
        return SS_FAILURE;
    }
    m_mmr=waveInStop(m_hIn);
    if(m_mmr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInStop fail,%u",GetLastError());
        return SS_FAILURE;
    }
    
    //SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInStop success");
    ::Sleep(100);
    m_mmr=waveInReset(m_hIn);
    if(m_mmr)
    {
        //SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInReset fail,%u",GetLastError());
        return SS_FAILURE;
    }
    /*m_mmr=waveInClose(m_hIn);
    if(m_mmr)
    {
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInClose fail,%u",GetLastError());
        return SS_FAILURE;
    }
    SS_Log_Printf(SS_STATUS_LOG,"windows wave record waveInClose success");*/

    m_bRecord = FALSE;

    return SS_SUCCESS;
}

SS_SHORT CWaveRecord::StartRecord()
{
    if (SS_SUCCESS != StartThread())           
    {
        return SS_FAILURE;
    };
    if (SS_SUCCESS != OpenDev())
    {
        StopThread ();
        return SS_FAILURE;
    };
    if (SS_SUCCESS != PerPareBuffer())
    {
        CloseDev ();
        StopThread ();
        return SS_FAILURE;
    }
    if (SS_SUCCESS != OpenRecord())
    {
        FreeBuffer();
        CloseDev ();
        StopThread ();
        return SS_FAILURE;
    }
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::StopRecord()
{
    CloseRecord ();    
    ::Sleep(800);
    //notice delete
    FreeBuffer();
    if (SS_SUCCESS == CloseDev())
    {
        StopThread ();
    }
    return SS_SUCCESS;
}
CWaveRecord::CWaveRecord() :
    m_wChannel(1),
    m_dwSample (WINWAVE_WISA_POOR),
    m_wBit(16)
{
        m_hIn=0;
        m_bThreadStart = FALSE;
        m_bDevOpen = FALSE;
        m_bAllocBuffer = FALSE;
        m_bRecord = FALSE;
        
        m_pHdr = NULL;
        m_dwAudioInId = 0;
        s_dwInstance ++;
        m_CallBake = NULL;
    m_pContext = NULL;
}

CWaveRecord::~CWaveRecord()
{
    StopRecord();
}
SS_SHORT CWaveRecord::SetCallBack(
        IN SS_VOID* pCallBack,
        void *pContext)
{
    m_CallBake = (IT_WaveRecordData)pCallBack;
    m_pContext = pContext;
    return SS_SUCCESS;
}
SS_SHORT CWaveRecord::Run(LPVOID lpParameter)
{
    CWaveRecord *pWaveRecord=NULL;
    pWaveRecord = (CWaveRecord*)lpParameter;
    char buffer[1024]="";
    MSG msg;
    SS_UINT32 uln = 0;

#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread start,Parameter=%p",lpParameter);
#endif
    try
    {
        while(GetMessage(&msg,0,0,0))
        {
            switch(msg.message )
            {
            case MM_WIM_OPEN:
                {
#ifdef  IT_LIB_DEBUG
                    SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread MM_WIM_OPEN,Parameter=%p",lpParameter);
#endif
                    break;
                }
            case MM_WIM_CLOSE:
                {
#ifdef  IT_LIB_DEBUG
                    SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread MM_WIM_CLOSE,Parameter=%p",lpParameter);
#endif
                    break;
                }
            case MM_WIM_DATA:
                {
                    WAVEHDR* pWH=(WAVEHDR*)msg.lParam;
                    waveInUnprepareHeader((HWAVEIN)msg.wParam,pWH,sizeof(WAVEHDR));
                    
                    if(pWH->dwBytesRecorded!=WINWAVE_SIZE_AUDIO_FRAME)
                        break;
                    memcpy(buffer,pWH->lpData,pWH->dwBytesRecorded);
                    ProcessData(buffer,pWH->dwBytesRecorded,m_pContext);
                    waveInPrepareHeader((HWAVEIN)msg.wParam,pWH,sizeof(WAVEHDR));
                    waveInAddBuffer((HWAVEIN)msg.wParam,pWH,sizeof(WAVEHDR));
                    break;
                }
            }
        }
    }
    catch (...)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread catch a error,Parameter=%p",lpParameter);
#endif
    }
#ifdef  IT_LIB_DEBUG
    SS_Log_Printf(SS_STATUS_LOG,"windows wave record thread exit,Parameter=%p",lpParameter);
#endif
    return msg.wParam;
}
MMRESULT CWaveRecord::GetLastMMError()
{
    return m_mmr;
}
CString CWaveRecord::GetLastErrorString()
{
    char buffer[256];
    memset(buffer,0,256);
    waveInGetErrorText(m_mmr,buffer,256);
    return buffer;
}

void CWaveRecord::SetChannel(WORD wChannel)
{
    m_wChannel = (m_wChannel == wChannel) ? 2:1;
}

void CWaveRecord::SetSample(DWORD dwSample)
{
    m_dwSample = dwSample;
}

void CWaveRecord::SetBit(WORD wBit)
{
    m_wBit = (wBit == 8) ? 8:16;
}

DWORD CWaveRecord::GetInstance()
{
    return s_dwInstance;
}

WORD CWaveRecord::GetBit()
{
    return m_wBit;
}

DWORD CWaveRecord::GetSample()
{
    return m_dwSample;
}

WORD CWaveRecord::GetChannel()
{
    return m_wChannel;
}
//////////////////////////////////////////////////////////////////////////
void    CWaveRecordEx::ProcessData(
        char * pBuffer,
        int const iLen,
        void *pContext)
{
    if (m_CallBake)
    {
        m_CallBake (pBuffer,iLen,pContext);
    }
}
CWaveRecordEx::CWaveRecordEx()
{
}
CWaveRecordEx::~CWaveRecordEx()
{
}


//////////////////////////////////////////////////////////////////////////


CSpeakerTest::CSpeakerTest()
{
    /*m_s_lpc10_encoder_state = NULL;
    m_s_lpc10_decoder_state = NULL;
    
    m_s_g722_encode_state_t = NULL;
    m_s_g722_decode_state_t = NULL;*/

/*    init_lpc10_encoder_state(&m_s_lpc10_encoder_state);
    init_lpc10_decoder_state(&m_s_lpc10_decoder_state);

    MDAudioAPI_g722_encode_init_lin16(&m_s_g722_encode_state_t);
    MDAudioAPI_g722_decode_init_lin16(&m_s_g722_decode_state_t);

    MDAudioAPI_InitiLBC13(&g_m_audio_s_EiLBC_Inst_t_13,&g_m_audio_s_DiLBC_Inst_t_13);
    MDAudioAPI_InitiLBC15(&g_m_audio_s_EiLBC_Inst_t_15,&g_m_audio_s_DiLBC_Inst_t_15);
    */
}

CSpeakerTest::~CSpeakerTest()
{
}

SS_SHORT    CSpeakerTest::InitSpeaker()
{
    if (SS_SUCCESS != StartRecord())
    {
        return SS_FAILURE;
    }
    
/*    m_s_lpc10_encoder_state = MDAudioAPI_lpc10_create_encoder_state();
    m_s_lpc10_decoder_state = MDAudioAPI_lpc10_create_decoder_state();
    MDAudioAPI_lpc10_init_encoder_state(m_s_lpc10_encoder_state);
    MDAudioAPI_lpc10_init_decoder_state(m_s_lpc10_decoder_state);


    g726_init_state(&m_s_g726_state_16);
    g726_init_state(&m_s_g726_state_24);
    g726_init_state(&m_s_g726_state_32);
    g726_init_state(&m_s_g726_state_40);
*/

    return m_c_play.StartPlay();
}
SS_SHORT    CSpeakerTest::FreeSpeaker()
{
    StopRecord();
    //MDAudioAPI_gsm_destroy(s_gsm);
    //s_gsm = NULL;

    //MDAudioAPI_g722_encode_release(m_s_g722_encode_state_t);
    //MDAudioAPI_g722_decode_release(m_s_g722_decode_state_t);
    //m_s_g722_encode_state_t = NULL;
    //m_s_g722_decode_state_t = NULL;
    return m_c_play.StopPlay();
}
void CSpeakerTest::ProcessData(
        char * pBuffer,
        int const iLen,
        void *pContext)
{
    if (NULL == pBuffer)
    {
        return;
    }

    m_c_play.Play(pBuffer,iLen);

    //TestG729_a(pBuffer,iLen);
    //TestG726_16(pBuffer,iLen);
    //TestG726_24(pBuffer,iLen);
    //TestG726_32(pBuffer,iLen);
    //TestG726_40(pBuffer,iLen);
    //TestADPCM(pBuffer,iLen);
    //TestG722(pBuffer,iLen);
    //TestG723(pBuffer,iLen);
    //TestG723_40(pBuffer,iLen);
    //TestG723_24(pBuffer,iLen);
    //TestG721(pBuffer,iLen);
    //TestLPC10(pBuffer,iLen);
    //TestLPC(pBuffer,iLen);
    //TestSpeex(pBuffer,iLen);
    //TestiLBC13(pBuffer,iLen);
    //TestiLBC15(pBuffer,iLen);
    //TestGSM(pBuffer,iLen);
    //TestAlaw64k(pBuffer,iLen);
    //TestUlaw64k(pBuffer,iLen);

}



SS_SHORT    CSpeakerTest::TestG729_a(char * pBuffer,int const iLen)
{
/*    SS_CHAR  sEBuf[1024] = "";
    SS_CHAR  sDBuf[1024] = "";
    SS_UINT32 len = 0;
    
    IT_g729a_Encode(pBuffer,0,sEBuf,&len);
    IT_g729a_Encode((pBuffer+160),0,sEBuf+10,&len);
    IT_g729a_Encode((pBuffer+320),0,sEBuf+20,&len);
    IT_g729a_Encode((pBuffer+480),0,sEBuf+30,&len);
    IT_g729a_Encode((pBuffer+640),0,sEBuf+40,&len);
    IT_g729a_Encode((pBuffer+800),0,sEBuf+50,&len);
    
    IT_g729a_Decode(sEBuf,0,(sDBuf),&len);
    IT_g729a_Decode(sEBuf+10,0,(sDBuf+160),&len);
    IT_g729a_Decode(sEBuf+20,0,(sDBuf+320),&len);
    IT_g729a_Decode(sEBuf+30,0,(sDBuf+480),&len);
    IT_g729a_Decode(sEBuf+40,0,(sDBuf+640),&len);
    IT_g729a_Decode(sEBuf+50,0,(sDBuf+800),&len);
    m_c_play.Play(sDBuf,960);
    */
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG726_16(char * pBuffer,int const iLen)
{
    SS_CHAR  sEBuf[1024] = "";
    SS_CHAR  sDBuf[1024] = "";
    SS_UINT32 len = 0;
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG726_24(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG726_32(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG726_40(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestADPCM(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG722(char * pBuffer,int const iLen)
{
/*    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  un32 = 0;

    MDAudioAPI_g722_encode(&m_s_g722_encode_state_t,pBuffer,160,sEBuf,&un32);
    MDAudioAPI_g722_encode(&m_s_g722_encode_state_t,pBuffer+320,160,sEBuf+80,&un32);
    MDAudioAPI_g722_encode(&m_s_g722_encode_state_t,pBuffer+640,160,sEBuf+160,&un32);
    //uln = MDAudioAPI_g722_encode(m_s_g722_encode_state_t,(SS_BYTE*)sEBuf+(80*1),(SS_USHORT*)pBuffer+(320*1),160);
    //uln = MDAudioAPI_g722_encode(m_s_g722_encode_state_t,(SS_BYTE*)sEBuf+(80*2),(SS_USHORT*)pBuffer+(320*2),160);
    MDAudioAPI_g722_decode(&m_s_g722_decode_state_t,sEBuf    ,80,sDBuf,&un32);
    MDAudioAPI_g722_decode(&m_s_g722_decode_state_t,sEBuf+80 ,80,sDBuf+320,&un32);
    MDAudioAPI_g722_decode(&m_s_g722_decode_state_t,sEBuf+160,80,sDBuf+640,&un32);
    //uln = MDAudioAPI_g722_decode(m_s_g722_decode_state_t,(SS_USHORT*)sDBuf+(320*1),(SS_BYTE*)sEBuf+(80*1),80);
    //uln = MDAudioAPI_g722_decode(m_s_g722_decode_state_t,(SS_USHORT*)sDBuf+(320*1),(SS_BYTE*)sEBuf+(80*2),80);
    m_c_play.Play(sDBuf,960);
    */
    return   SS_SUCCESS;
}
SS_CHAR  g_s_Bug[256] = "";
SS_SHORT    CSpeakerTest::TestG723(char * pBuffer,int const iLen)
{
/*    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  uln = 0;
    MDAudioAPI_Suct_g723_Package(pBuffer,480,sEBuf,&uln);
    MDAudioAPI_Parse_g723_Package(sEBuf,uln,sDBuf,&uln);
    m_c_play.Play(sDBuf,480);
    memset(sEBuf,0,sizeof(sEBuf));
    memset(sDBuf,0,sizeof(sDBuf));
    MDAudioAPI_Suct_g723_Package(pBuffer+480,480,sEBuf,&uln);
    MDAudioAPI_Parse_g723_Package(sEBuf,uln,sDBuf,&uln);
    m_c_play.Play(sDBuf,480);*/
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG723_40(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG723_24(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestG721(char * pBuffer,int const iLen)
{
    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  uln = 0;
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestLPC10(char * pBuffer,int const iLen)
{
/*    //lpc10_encoder_state  *m_s_lpc10_encoder_state;
    //lpc10_decoder_state  *m_s_lpc10_decoder_state;
    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  uln = 0;
    //uln = MDAudioAPI_lpc10_encode((float*)pBuffer,(int*)sEBuf,m_s_lpc10_encoder_state);
    //uln = MDAudioAPI_lpc10_decode((int*)sEBuf,(float*)sDBuf,m_s_lpc10_decoder_state);
    m_c_play.Play(sDBuf,960);*/
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestLPC(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestSpeex(char * pBuffer,int const iLen)
{
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestiLBC13(char * pBuffer,int const iLen)
{
    /*
    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  uln = 0;
    MDAudioAPI_SuctiLBC13Package(&g_m_audio_s_EiLBC_Inst_t_13,pBuffer,480,sEBuf,&uln);
    MDAudioAPI_SuctiLBC13Package(&g_m_audio_s_EiLBC_Inst_t_13,pBuffer+480,480,sEBuf+(50*1),&uln);
    MDAudioAPI_ParseiLBC13Package(&g_m_audio_s_DiLBC_Inst_t_13,sEBuf,50,sDBuf,&uln);
    MDAudioAPI_ParseiLBC13Package(&g_m_audio_s_DiLBC_Inst_t_13,sEBuf+(50*1),50,sDBuf+480,&uln);
    m_c_play.Play(sDBuf,960);*/
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestiLBC15(char * pBuffer,int const iLen)
{
/*    SS_CHAR   sEBuf[1024] = "";
    SS_CHAR   sDBuf[1024] = "";
    SS_UINT32  uln = 0;
    MDAudioAPI_SuctiLBC15Package(&g_m_audio_s_EiLBC_Inst_t_15,pBuffer,320,sEBuf,&uln);
    MDAudioAPI_SuctiLBC15Package(&g_m_audio_s_EiLBC_Inst_t_15,pBuffer+320,320,sEBuf+(38*1),&uln);
    MDAudioAPI_SuctiLBC15Package(&g_m_audio_s_EiLBC_Inst_t_15,pBuffer+640,320,sEBuf+(38*2),&uln);
    
    MDAudioAPI_ParseiLBC15Package(&g_m_audio_s_DiLBC_Inst_t_15,sEBuf,38,sDBuf,&uln);
    MDAudioAPI_ParseiLBC15Package(&g_m_audio_s_DiLBC_Inst_t_15,sEBuf+(38*1),38,sDBuf+320,&uln);
    MDAudioAPI_ParseiLBC15Package(&g_m_audio_s_DiLBC_Inst_t_15,sEBuf+(38*2),38,sDBuf+640,&uln);
    m_c_play.Play(sDBuf,960);*/
    return   SS_SUCCESS;
}
//extern gsm g_s_gsm;
SS_SHORT    CSpeakerTest::TestGSM(char * pBuffer,int const iLen)
{
/*    SS_CHAR       sEBuf[1024] = "";
    SS_CHAR       sDBuf[1024] = "";

    MDAudioAPI_gsm_encode(g_s_gsm,(SS_SHORT*)pBuffer,(SS_BYTE*)sEBuf);
    MDAudioAPI_gsm_encode(g_s_gsm,(SS_SHORT*)pBuffer+(160*1),(SS_BYTE*)sEBuf+(33*1));
    MDAudioAPI_gsm_encode(g_s_gsm,(SS_SHORT*)pBuffer+(160*2),(SS_BYTE*)sEBuf+(33*2));
    
    MDAudioAPI_gsm_decode(g_s_gsm,(SS_BYTE*)sEBuf,(SS_SHORT*)sDBuf);
    MDAudioAPI_gsm_decode(g_s_gsm,(SS_BYTE*)sEBuf+(33*1),(SS_SHORT*)sDBuf+(160*1));
    MDAudioAPI_gsm_decode(g_s_gsm,(SS_BYTE*)sEBuf+(33*2),(SS_SHORT*)sDBuf+(160*2));

    m_c_play.Play(sDBuf,960);*/
    return   SS_SUCCESS;
}

SS_SHORT    CSpeakerTest::TestAlaw64k(char * pBuffer,int const iLen)
{
/*    SS_UINT32 uln = 0;
    SS_UINT32 ulnLength = 0;
    //SS_USHORT usnTimeStamp;
    SS_CHAR       sEBuf[1024] = "";
    SS_CHAR       sDBuf[1024] = "";
    SS_UINT32      ulnBufSize = sizeof(sEBuf);
    MDAudioAPI_SuctAlaw64kPackage(pBuffer,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseAlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(sDBuf,uln);
    
    memset(sDBuf,0,sizeof(sDBuf));
    memset(sEBuf,0,sizeof(sEBuf));
    MDAudioAPI_SuctAlaw64kPackage(pBuffer+320,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseAlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(sDBuf,uln);

    memset(sDBuf,0,sizeof(sDBuf));
    memset(sEBuf,0,sizeof(sEBuf));
    MDAudioAPI_SuctAlaw64kPackage(pBuffer+640,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseAlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(pBuffer,uln);*/
    return   SS_SUCCESS;
}
SS_SHORT    CSpeakerTest::TestUlaw64k(char * pBuffer,int const iLen)
{
/*    SS_UINT32 uln = 0;
    SS_UINT32 ulnLength = 0;
    //SS_USHORT usnTimeStamp;
    SS_CHAR       sEBuf[1024] = "";
    SS_CHAR       sDBuf[1024] = "";
    SS_UINT32      ulnBufSize = sizeof(sEBuf);
    MDAudioAPI_SuctUlaw64kPackage(pBuffer,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseUlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(sDBuf,uln);
    
    memset(sDBuf,0,sizeof(sDBuf));
    memset(sEBuf,0,sizeof(sEBuf));
    MDAudioAPI_SuctUlaw64kPackage(pBuffer+320,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseUlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(sDBuf,uln);

    memset(sDBuf,0,sizeof(sDBuf));
    memset(sEBuf,0,sizeof(sEBuf));
    MDAudioAPI_SuctUlaw64kPackage(pBuffer+640,320,sEBuf,&ulnBufSize);
    MDAudioAPI_ParseUlaw64kPackage(sEBuf,ulnBufSize,sDBuf,&uln);
    m_c_play.Play(pBuffer,uln);*/
    return   SS_SUCCESS;
}

CWaveRecordEx  g_c_winWaveRecord;
CWavePlay      g_c_winWavePlay;

#elif defined(__GNUC__)

#else
#  error "Unknown compiler."
#endif

//////////////////////////////////////////////////////////////////////////


SS_SHORT  IT_StartWaveRecord(IN IT_WaveRecordData f_WaveRecordData,IN void *pContext)
{
#if defined(_MSC_VER)
    if (g_c_winWaveRecord.GetRecordStatus())
    {
        return  SS_FAILURE;
    }
    g_c_winWaveRecord.SetCallBack((SS_VOID*)f_WaveRecordData,pContext);

    if (SS_SUCCESS != g_c_winWaveRecord.StartRecord())
    {
        g_c_winWaveRecord.SetCallBack(NULL,NULL);
        return  SS_FAILURE;
    }
#elif defined(__GNUC__)
#else
#  error "Unknown compiler."
#endif
    return  SS_SUCCESS;
}
SS_SHORT  IT_StartWavePlay  ()
{
#if defined(_MSC_VER)
    return  g_c_winWavePlay.StartPlay();
#elif defined(__GNUC__)
#else
#  error "Unknown compiler."
#endif
    return  SS_SUCCESS;
}
SS_SHORT  IT_WavePlay  (IN char const* buf,IN SS_UINT32 un32Size)
{
#if defined(_MSC_VER)
    return  g_c_winWavePlay.Play(buf,un32Size);
#elif defined(__GNUC__)
#else
#  error "Unknown compiler."
#endif
    return  SS_SUCCESS;
}
SS_SHORT  IT_StopWaveRecord()
{
#if defined(_MSC_VER)
    if (SS_SUCCESS != g_c_winWaveRecord.StopRecord())
    {
        return  SS_FAILURE;
    }
    g_c_winWaveRecord.SetCallBack(NULL,NULL);
#elif defined(__GNUC__)
#else
#  error "Unknown compiler."
#endif
    return  SS_SUCCESS;
}
SS_SHORT  IT_StopWavePlay  ()
{
#if defined(_MSC_VER)
    return  g_c_winWavePlay.StopPlay();
#elif defined(__GNUC__)
#else
#  error "Unknown compiler."
#endif
    return  SS_SUCCESS;
}




//////////////////////////////////////////////////////////////////////////

/*
80 e5 03 93 06 1c 24 20   12 c4 e5 7e 08 00 00 00 
80 e5 03 94 06 1c 24 20   12 c4 e5 7e 08 00 00 00 
80 e5 03 95 06 1c 24 20   12 c4 e5 7e 08 00 00 00 
80 65 03 96 06 1c 24 20   12 c4 e5 7e 08 02 00 50 
80 65 03 97 06 1c 24 20   12 c4 e5 7e 08 02 00 a0 
80 65 03 98 06 1c 24 20   12 c4 e5 7e 08 02 00 f0 
80 65 03 99 06 1c 24 20   12 c4 e5 7e 08 02 01 40 
80 65 03 9a 06 1c 24 20   12 c4 e5 7e 08 02 01 90 
80 65 03 9b 06 1c 24 20   12 c4 e5 7e 08 02 01 e0 
80 65 03 9c 06 1c 24 20   12 c4 e5 7e 08 02 02 30 
80 65 03 9d 06 1c 24 20   12 c4 e5 7e 08 02 02 80 
80 65 03 9e 06 1c 24 20   12 c4 e5 7e 08 02 02 d0 
80 65 03 9f 06 1c 24 20   12 c4 e5 7e 08 02 03 20 
80 65 03 a0 06 1c 24 20   12 c4 e5 7e 08 82 03 c0 
80 65 03 a1 06 1c 24 20   12 c4 e5 7e 08 82 03 c0  
80 65 03 a2 06 1c 24 20   12 c4 e5 7e 08 80 03 c0 */

SS_SHORT RTP_CreateRFC2833Packet(
    IN SS_str **s_pRTP,
    IN SS_UINT32 const un32MaxList,
    IN SS_BYTE   const ubKey,
    IN SS_BYTE   const ubKeyPayload)
{
    SS_UINT32 un32=0;
    SS_CHAR   sBuf[24] = "";
    SS_USHORT usnseq=0;
    SS_BYTE   ubID = 0;
    SS_BYTE   ub1 = 0;
    SS_BYTE   ub2 = 0;
    SS_UINT32 un32TimesTamp = 0;
    SS_UINT32 un32SSRC      = 0;
    SS_str *s_RTP = NULL;
    if (NULL == s_pRTP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,RTP=%p",s_pRTP);
#endif
        return SS_ERR_PARAM;
    }
    srand((unsigned)time(NULL));

    un32TimesTamp = rand()+rand();
    un32SSRC      = rand()+rand();
    usnseq        = rand()+rand();
    ubID = rand();
    if (un32MaxList < 16)
    {
        return  SS_ERR_PARAM;
    }
    for (un32=0;un32<un32MaxList;un32++)
    {
        memset(sBuf,0,sizeof(sBuf));
        *(SS_BYTE*)(sBuf) = 0x80;
        if (un32 <= 2)
        {
            *(SS_BYTE*)(sBuf+1) = 0xe5;
            *(SS_USHORT*)(sBuf+2) = usnseq++;
            *(SS_UINT32*)(sBuf+4) = un32TimesTamp;
            *(SS_UINT32*)(sBuf+8) = un32SSRC;
            *(SS_BYTE*)(sBuf+12)  = ubKey;
            *(SS_BYTE*)(sBuf+13)  = 0;
            *(SS_BYTE*)(sBuf+14)  = 0;
            *(SS_BYTE*)(sBuf+15)  = 0;
        }
        else
        {
            *(SS_BYTE*)(sBuf+1) = ubKeyPayload;
            *(SS_USHORT*)(sBuf+2) = usnseq++;
            *(SS_UINT32*)(sBuf+4) = un32TimesTamp;
            *(SS_UINT32*)(sBuf+8) = un32SSRC;
            *(SS_BYTE*)(sBuf+12)  = ubKey;
            *(SS_BYTE*)(sBuf+13)  = ubID;
            *(SS_BYTE*)(sBuf+14)  = ub1++;
            *(SS_BYTE*)(sBuf+15)  = ub2++;
        }
        s_RTP = s_pRTP[un32];
        SS_ADD_str_p_len(s_RTP,sBuf,16);
    }
    return  SS_SUCCESS;
}

SS_SHORT RTP_InitRFC2833List(IN SS_str ***s_pRTP,IN SS_UINT32 const un32MaxList)
{
    SS_UINT32  un32=0;
    SS_str **s_str;
    if (NULL == s_pRTP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,RTP=%p",s_pRTP);
#endif
        return SS_ERR_PARAM;
    }
    if (NULL == (s_str = (SS_str**)malloc(sizeof(SS_str**)*(un32MaxList+1))))
    {
        return  SS_ERR_MEMORY;
    }
    *s_pRTP=s_str;
    memset(s_str,0,sizeof(SS_str**)*(un32MaxList+1));
    for (un32=0;un32<un32MaxList;un32++)
    {
        if (NULL == (s_str[un32] = (SS_str*)malloc(sizeof(SS_str))))
        {
            return  SS_ERR_MEMORY;
        }
        s_str[un32]->m_len=0;
        s_str[un32]->m_s=NULL;
    }
    return  SS_SUCCESS;
}

SS_SHORT RTP_FreeRFC2833List(IN SS_str ***s_pRTP,IN SS_UINT32 const un32MaxList)
{
    SS_UINT32  un32=0;
    SS_str **s_str = NULL;
    if (NULL == s_pRTP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,RTP=%p",s_pRTP);
#endif
        return SS_ERR_PARAM;
    }
    s_str = *s_pRTP;
    for (un32=0;un32<un32MaxList;un32++)
    {
        SS_DEL_str_p(s_str[un32]);
        free(s_str[un32]);
        s_str[un32]=NULL;
    }
    free(s_str);
    *s_pRTP=NULL;
    return  SS_SUCCESS;
}


SS_UINT64 RTPA_TransformCodecStr2int(IN  SS_CHAR const*const psCodecString)
{
    SS_CHAR const*p = psCodecString;
    if (NULL == psCodecString)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,CodecString=%p",psCodecString);
#endif
        return SS_ERR_PARAM;
    }
    while(' ' == *p)p++;
    switch(*p)
    {
    case 'A': case 'a'://AMR
        {
            if (0 == SS_strncasecmp(p+1,"MR",2))
            {
                return SS_AUDIO_CODEC_AMR;
            }
            return 0;
        }break;
    case 'B': case 'b'://BV
        {
            if (('V'==*(p+1)) || ('v'==*(p+1)))
            {
                return SS_AUDIO_CODEC_BV16;
            }
            return 0;
        }break;
    case 'C': case 'c'://CELT
        {
            if (0 == SS_strncasecmp(p+1,"ELT",3))
            {
                return SS_AUDIO_CODEC_CELT_32;
            }
            return 0;
        }break;
    case 'S': case 's':
        {
            if (0 == SS_strncasecmp(p+1,"peex",4))//Speex
            {
                return SS_AUDIO_CODEC_SPEEX_8;
            }
            else if (0 == SS_strncasecmp(p+1,"ILK",3))//SILK
            {
                return SS_AUDIO_CODEC_SILK_8;
            }
            return 0;
        }break;
    case 'i': case 'I': //iLBC
        {
            if (0 == SS_strncasecmp(p+1,"LBC",3))
            {
                return SS_AUDIO_CODEC_ILBC_30;
            }
            return 0;
        }break;
    case 'D': case 'd': //DVI4
        {
            if (0 == SS_strncasecmp(p+1,"VI4",3))
            {
                return SS_AUDIO_CODEC_DVI4_8;
            }
            return 0;
        }break;
    case 't': case 'T'://telephone-event
        {
            if (0 == SS_strncasecmp(p+1,"elephone-event",14))
            {
                return SS_AUDIO_CODEC_TELEPHONE_EVENT;
            }
            return 0;
        }break;
    case 'L': case 'l':
        {
            switch(*(p+1))
            {
            case 'p': case 'P'://LPC10
                {
                    if (0 == SS_strncasecmp(p+2,"C10",3))
                    {
                        return SS_AUDIO_CODEC_LPC;
                    }
                    return 0;
                }break;
            case '1':
                {
                    if ('6'==*(p+2))//L16
                    {
                        return SS_AUDIO_CODEC_L16;
                    }
                    return 0;
                }break;
            default:return 0;
            }
        }break;
    case 'P': case 'p':
        {
            switch(*(p+1))
            {
            case 'C': case 'c':
                {
                    switch(*(p+2))
                    {
                    case 'M': case 'm':
                        {
                            switch(*(p+3))
                            {
                            case 'A': case 'a':
                                {
                                    return SS_AUDIO_CODEC_ALAW;
                                }break;
                            case 'U': case 'u':
                                {
                                    return SS_AUDIO_CODEC_ULAW;
                                }break;
                            default:return 0;
                            }
                        }break;
                    default:return 0;
                    }
                }break;
            default:return 0;
            }
        }break;
    case 'G': case 'g':
        {
            switch(*(p+1))
            {
            case 'S': case 's'://GSM
                {
                    if (('M'==*(p+2)) || ('m'==*(p+2)))
                    {
                        return SS_AUDIO_CODEC_GSM;
                    }
                    return 0;
                }break;
            case '7'://G722 G723 G726 G728 G729
                {
                    if ('2' != *(p+2))
                    {
                        return 0;
                    }
                    switch(*(p+3))
                    {
                    case '2':return SS_AUDIO_CODEC_G722_16;
                    case '3':return SS_AUDIO_CODEC_G723_63;
                    case '6':return SS_AUDIO_CODEC_G726_16;
                    case '8':return SS_AUDIO_CODEC_G728;
                    case '9':return SS_AUDIO_CODEC_G729;
                    default:return 0;
                    }

                }break;
            default: return 0;
            }
        }break;
    default:return 0;
    }
    return 0;
}
SS_CHAR const*RTPA_TransformCodecint2Str(IN SS_UINT64 const un64Code)
{
    if(un64Code&SS_AUDIO_CODEC_ALAW    ) return SS_AUDIO_STR_ALAW    "/" SS_AUDIO_RATE_STR_ALAW    ;
    if(un64Code&SS_AUDIO_CODEC_ULAW    ) return SS_AUDIO_STR_ULAW    "/" SS_AUDIO_RATE_STR_ULAW    ;
    if(un64Code&SS_AUDIO_CODEC_G729    ) return SS_AUDIO_STR_G729    "/" SS_AUDIO_RATE_STR_G729    ;
    if(un64Code&SS_AUDIO_CODEC_G729A   ) return SS_AUDIO_STR_G729A   "/" SS_AUDIO_RATE_STR_G729A   ;
    if(un64Code&SS_AUDIO_CODEC_G729B   ) return SS_AUDIO_STR_G729B   "/" SS_AUDIO_RATE_STR_G729B   ;
    if(un64Code&SS_AUDIO_CODEC_G729AB  ) return SS_AUDIO_STR_G729AB  "/" SS_AUDIO_RATE_STR_G729AB  ;
    if(un64Code&SS_AUDIO_CODEC_G723_63 ) return SS_AUDIO_STR_G723_63 "/" SS_AUDIO_RATE_STR_G723_63 ;
    if(un64Code&SS_AUDIO_CODEC_G723_53 ) return SS_AUDIO_STR_G723_53 "/" SS_AUDIO_RATE_STR_G723_53 ;
    if(un64Code&SS_AUDIO_CODEC_CELT_32 ) return SS_AUDIO_STR_CELT_32 "/" SS_AUDIO_RATE_STR_CELT_32 ;
    if(un64Code&SS_AUDIO_CODEC_CELT_48 ) return SS_AUDIO_STR_CELT_48 "/" SS_AUDIO_RATE_STR_CELT_48 ;
    if(un64Code&SS_AUDIO_CODEC_ILBC_30 ) return SS_AUDIO_STR_ILBC_30 "/" SS_AUDIO_RATE_STR_ILBC_30 ;
    if(un64Code&SS_AUDIO_CODEC_ILBC_20 ) return SS_AUDIO_STR_ILBC_20 "/" SS_AUDIO_RATE_STR_ILBC_20 ;
    if(un64Code&SS_AUDIO_CODEC_G722_16 ) return SS_AUDIO_STR_G722_16 "/" SS_AUDIO_RATE_STR_G722_16 ;
    if(un64Code&SS_AUDIO_CODEC_G7221_16) return SS_AUDIO_STR_G7221_16"/" SS_AUDIO_RATE_STR_G7221_16;
    if(un64Code&SS_AUDIO_CODEC_G7221_32) return SS_AUDIO_STR_G7221_32"/" SS_AUDIO_RATE_STR_G7221_32;
    if(un64Code&SS_AUDIO_CODEC_G726_16 ) return SS_AUDIO_STR_G726_16 "/" SS_AUDIO_RATE_STR_G726_16 ;
    if(un64Code&SS_AUDIO_CODEC_G726_24 ) return SS_AUDIO_STR_G726_24 "/" SS_AUDIO_RATE_STR_G726_24 ;
    if(un64Code&SS_AUDIO_CODEC_G726_32 ) return SS_AUDIO_STR_G726_32 "/" SS_AUDIO_RATE_STR_G726_32 ;
    if(un64Code&SS_AUDIO_CODEC_G726_40 ) return SS_AUDIO_STR_G726_40 "/" SS_AUDIO_RATE_STR_G726_40 ;
    if(un64Code&SS_AUDIO_CODEC_DVI4_8  ) return SS_AUDIO_STR_DVI4_8  "/" SS_AUDIO_RATE_STR_DVI4_8  ;
    if(un64Code&SS_AUDIO_CODEC_DVI4_16 ) return SS_AUDIO_STR_DVI4_16 "/" SS_AUDIO_RATE_STR_DVI4_16 ;
    if(un64Code&SS_AUDIO_CODEC_SPEEX_8 ) return SS_AUDIO_STR_SPEEX_8 "/" SS_AUDIO_RATE_STR_SPEEX_8 ;
    if(un64Code&SS_AUDIO_CODEC_SPEEX_16) return SS_AUDIO_STR_SPEEX_16"/" SS_AUDIO_RATE_STR_SPEEX_16;
    if(un64Code&SS_AUDIO_CODEC_SPEEX_32) return SS_AUDIO_STR_SPEEX_32"/" SS_AUDIO_RATE_STR_SPEEX_32;
    if(un64Code&SS_AUDIO_CODEC_BV16    ) return SS_AUDIO_STR_BV16    "/" SS_AUDIO_RATE_STR_BV16    ;
    if(un64Code&SS_AUDIO_CODEC_BV32    ) return SS_AUDIO_STR_BV32    "/" SS_AUDIO_RATE_STR_BV32    ;
    if(un64Code&SS_AUDIO_CODEC_BV32_FEC) return SS_AUDIO_STR_BV32_FEC"/" SS_AUDIO_RATE_STR_BV32_FEC;
    if(un64Code&SS_AUDIO_CODEC_GSM     ) return SS_AUDIO_STR_GSM     "/" SS_AUDIO_RATE_STR_GSM     ;
    if(un64Code&SS_AUDIO_CODEC_LPC     ) return SS_AUDIO_STR_LPC     "/" SS_AUDIO_RATE_STR_LPC     ;
    if(un64Code&SS_AUDIO_CODEC_L16     ) return SS_AUDIO_STR_L16     "/" SS_AUDIO_RATE_STR_L16     ;
    if(un64Code&SS_AUDIO_CODEC_AMR     ) return SS_AUDIO_STR_AMR     "/" SS_AUDIO_RATE_STR_AMR     ;
    if(un64Code&SS_AUDIO_CODEC_G728    ) return SS_AUDIO_STR_G728    "/" SS_AUDIO_RATE_STR_G728    ;
    if(un64Code&SS_AUDIO_CODEC_SILK_8  ) return SS_AUDIO_STR_SILK_8  "/" SS_AUDIO_RATE_STR_SILK_8  ;
    if(un64Code&SS_AUDIO_CODEC_SILK_12 ) return SS_AUDIO_STR_SILK_12 "/" SS_AUDIO_RATE_STR_SILK_12 ;
    if(un64Code&SS_AUDIO_CODEC_SILK_16 ) return SS_AUDIO_STR_SILK_16 "/" SS_AUDIO_RATE_STR_SILK_16 ;
    if(un64Code&SS_AUDIO_CODEC_SILK_24 ) return SS_AUDIO_STR_SILK_24 "/" SS_AUDIO_RATE_STR_SILK_24 ;
    if(un64Code&SS_AUDIO_CODEC_SPEEX_FEC_8 ) return SS_AUDIO_STR_SPEEX_FEC_8 "/" SS_AUDIO_RATE_STR_SPEEX_FEC_8 ;
    if(un64Code&SS_AUDIO_CODEC_SPEEX_FEC_16) return SS_AUDIO_STR_SPEEX_FEC_16"/" SS_AUDIO_RATE_STR_SPEEX_FEC_16;
    return "";
}
SS_CHAR const*RTPA_GetCodecStr(IN SS_UINT64 const un64Code)
{
      switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return SS_AUDIO_STR_ALAW    ;
    case SS_AUDIO_CODEC_ULAW    :return SS_AUDIO_STR_ULAW    ;
    case SS_AUDIO_CODEC_G729    :return SS_AUDIO_STR_G729    ;
    case SS_AUDIO_CODEC_G729A   :return SS_AUDIO_STR_G729A   ;
    case SS_AUDIO_CODEC_G729B   :return SS_AUDIO_STR_G729B   ;
    case SS_AUDIO_CODEC_G729AB  :return SS_AUDIO_STR_G729AB  ;
    case SS_AUDIO_CODEC_G723_63 :return SS_AUDIO_STR_G723_63 ;
    case SS_AUDIO_CODEC_G723_53 :return SS_AUDIO_STR_G723_53 ;
    case SS_AUDIO_CODEC_CELT_32 :return SS_AUDIO_STR_CELT_32 ;
    case SS_AUDIO_CODEC_CELT_48 :return SS_AUDIO_STR_CELT_48 ;
    case SS_AUDIO_CODEC_ILBC_30 :return SS_AUDIO_STR_ILBC_30 ;
    case SS_AUDIO_CODEC_ILBC_20 :return SS_AUDIO_STR_ILBC_20 ;
    case SS_AUDIO_CODEC_G722_16 :return SS_AUDIO_STR_G722_16 ;
    case SS_AUDIO_CODEC_G7221_16:return SS_AUDIO_STR_G7221_16;
    case SS_AUDIO_CODEC_G7221_32:return SS_AUDIO_STR_G7221_32;
    case SS_AUDIO_CODEC_G726_16 :return SS_AUDIO_STR_G726_16 ;
    case SS_AUDIO_CODEC_G726_24 :return SS_AUDIO_STR_G726_24 ;
    case SS_AUDIO_CODEC_G726_32 :return SS_AUDIO_STR_G726_32 ;
    case SS_AUDIO_CODEC_G726_40 :return SS_AUDIO_STR_G726_40 ;
    case SS_AUDIO_CODEC_DVI4_8  :return SS_AUDIO_STR_DVI4_8  ;
    case SS_AUDIO_CODEC_DVI4_16 :return SS_AUDIO_STR_DVI4_16 ;
    case SS_AUDIO_CODEC_SPEEX_8 :return SS_AUDIO_STR_SPEEX_8 ;
    case SS_AUDIO_CODEC_SPEEX_16:return SS_AUDIO_STR_SPEEX_16;
    case SS_AUDIO_CODEC_SPEEX_32:return SS_AUDIO_STR_SPEEX_32;
    case SS_AUDIO_CODEC_BV16    :return SS_AUDIO_STR_BV16    ;
    case SS_AUDIO_CODEC_BV32    :return SS_AUDIO_STR_BV32    ;
    case SS_AUDIO_CODEC_BV32_FEC:return SS_AUDIO_STR_BV32_FEC;
    case SS_AUDIO_CODEC_GSM     :return SS_AUDIO_STR_GSM     ;
    case SS_AUDIO_CODEC_LPC     :return SS_AUDIO_STR_LPC     ;
    case SS_AUDIO_CODEC_L16     :return SS_AUDIO_STR_L16     ;
    case SS_AUDIO_CODEC_AMR     :return SS_AUDIO_STR_AMR     ;
    case SS_AUDIO_CODEC_G728    :return SS_AUDIO_STR_G728    ;
    case SS_AUDIO_CODEC_SILK_8  :return SS_AUDIO_STR_SILK_8  ;
    case SS_AUDIO_CODEC_SILK_12 :return SS_AUDIO_STR_SILK_12 ;
    case SS_AUDIO_CODEC_SILK_16 :return SS_AUDIO_STR_SILK_16 ;
    case SS_AUDIO_CODEC_SILK_24 :return SS_AUDIO_STR_SILK_24 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_8:return SS_AUDIO_STR_SPEEX_FEC_8;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return SS_AUDIO_STR_SPEEX_FEC_16;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return SS_AUDIO_STR_TELEPHONE_EVENT;
    default:break;
    }
    return "";
}

SS_UINT32 RTPA_GetRate(IN  SS_Audio const *s_pAudio,IN SS_UINT64 const un64Code)
{
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return SS_AUDIO_RATE_ALAW    ;
    case SS_AUDIO_CODEC_ULAW    :return SS_AUDIO_RATE_ULAW    ;
    case SS_AUDIO_CODEC_G729    :return SS_AUDIO_RATE_G729    ;
    case SS_AUDIO_CODEC_G729A   :return SS_AUDIO_RATE_G729A   ;
    case SS_AUDIO_CODEC_G729B   :return SS_AUDIO_RATE_G729B   ;
    case SS_AUDIO_CODEC_G729AB  :return SS_AUDIO_RATE_G729AB  ;
    case SS_AUDIO_CODEC_G723_63 :return SS_AUDIO_RATE_G723_63 ;
    case SS_AUDIO_CODEC_G723_53 :return SS_AUDIO_RATE_G723_53 ;
    case SS_AUDIO_CODEC_CELT_32 :return SS_AUDIO_RATE_CELT_32 ;
    case SS_AUDIO_CODEC_CELT_48 :return SS_AUDIO_RATE_CELT_48 ;
    case SS_AUDIO_CODEC_ILBC_30 :return SS_AUDIO_RATE_ILBC_30 ;
    case SS_AUDIO_CODEC_ILBC_20 :return SS_AUDIO_RATE_ILBC_20 ;
    case SS_AUDIO_CODEC_G722_16 :return SS_AUDIO_RATE_G722_16 ;
    case SS_AUDIO_CODEC_G7221_16:return SS_AUDIO_RATE_G7221_16;
    case SS_AUDIO_CODEC_G7221_32:return SS_AUDIO_RATE_G7221_32;
    case SS_AUDIO_CODEC_G726_16 :return SS_AUDIO_RATE_G726_16 ;
    case SS_AUDIO_CODEC_G726_24 :return SS_AUDIO_RATE_G726_24 ;
    case SS_AUDIO_CODEC_G726_32 :return SS_AUDIO_RATE_G726_32 ;
    case SS_AUDIO_CODEC_G726_40 :return SS_AUDIO_RATE_G726_40 ;
    case SS_AUDIO_CODEC_DVI4_8  :return SS_AUDIO_RATE_DVI4_8  ;
    case SS_AUDIO_CODEC_DVI4_16 :return SS_AUDIO_RATE_DVI4_16 ;
    case SS_AUDIO_CODEC_SPEEX_8 :return SS_AUDIO_RATE_SPEEX_8 ;
    case SS_AUDIO_CODEC_SPEEX_16:return SS_AUDIO_RATE_SPEEX_16;
    case SS_AUDIO_CODEC_SPEEX_32:return SS_AUDIO_RATE_SPEEX_32;
    case SS_AUDIO_CODEC_BV16    :return SS_AUDIO_RATE_BV16    ;
    case SS_AUDIO_CODEC_BV32    :return SS_AUDIO_RATE_BV32    ;
    case SS_AUDIO_CODEC_BV32_FEC:return SS_AUDIO_RATE_BV32_FEC;
    case SS_AUDIO_CODEC_GSM     :return SS_AUDIO_RATE_GSM     ;
    case SS_AUDIO_CODEC_LPC     :return SS_AUDIO_RATE_LPC     ;
    case SS_AUDIO_CODEC_L16     :return SS_AUDIO_RATE_L16     ;
    case SS_AUDIO_CODEC_AMR     :return SS_AUDIO_RATE_AMR     ;
    case SS_AUDIO_CODEC_G728    :return SS_AUDIO_RATE_G728    ;
    case SS_AUDIO_CODEC_SILK_8  :return SS_AUDIO_RATE_SILK_8  ;
    case SS_AUDIO_CODEC_SILK_12 :return SS_AUDIO_RATE_SILK_12 ;
    case SS_AUDIO_CODEC_SILK_16 :return SS_AUDIO_RATE_SILK_16 ;
    case SS_AUDIO_CODEC_SILK_24 :return SS_AUDIO_RATE_SILK_24 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :return SS_AUDIO_RATE_SPEEX_FEC_8 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return SS_AUDIO_RATE_SPEEX_FEC_16;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return SS_AUDIO_RATE_TELEPHONE_EVENT;
    default:break;
    }
    return 0;
}
SS_CHAR const*RTPA_GetCodecSuffixName(IN SS_UINT64 const un64Code)
{
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return ".puma";
    case SS_AUDIO_CODEC_ULAW    :return ".pumu";
    case SS_AUDIO_CODEC_G729    :return ".g729";
    case SS_AUDIO_CODEC_G729A   :return ".g729a";
    case SS_AUDIO_CODEC_G729B   :return ".g729b";
    case SS_AUDIO_CODEC_G729AB  :return ".g729ab";
    case SS_AUDIO_CODEC_G723_63 :return ".g723_63";
    case SS_AUDIO_CODEC_G723_53 :return ".g723_53";
    case SS_AUDIO_CODEC_CELT_32 :return ".celt_32";
    case SS_AUDIO_CODEC_CELT_48 :return ".celt_48";
    case SS_AUDIO_CODEC_ILBC_30 :return ".ilbc_30";
    case SS_AUDIO_CODEC_ILBC_20 :return ".ilbc_20";
    case SS_AUDIO_CODEC_G722_16 :return ".g722_16";
    case SS_AUDIO_CODEC_G7221_16:return ".g7221_16";
    case SS_AUDIO_CODEC_G7221_32:return ".g7221_32";
    case SS_AUDIO_CODEC_G726_16 :return ".g726_16";
    case SS_AUDIO_CODEC_G726_24 :return ".g726_24";
    case SS_AUDIO_CODEC_G726_32 :return ".g726_32";
    case SS_AUDIO_CODEC_G726_40 :return ".g726_40";
    case SS_AUDIO_CODEC_DVI4_8  :return ".dvi4_8";
    case SS_AUDIO_CODEC_DVI4_16 :return ".dvi4_16";
    case SS_AUDIO_CODEC_SPEEX_8 :return ".speex_8";
    case SS_AUDIO_CODEC_SPEEX_16:return ".speex_16";
    case SS_AUDIO_CODEC_SPEEX_32:return ".speex_32";
    case SS_AUDIO_CODEC_BV16    :return ".bv16";
    case SS_AUDIO_CODEC_BV32    :return ".bv32";
    case SS_AUDIO_CODEC_BV32_FEC:return ".bv32_fec";
    case SS_AUDIO_CODEC_GSM     :return ".gsm";
    case SS_AUDIO_CODEC_LPC     :return ".lpc";
    case SS_AUDIO_CODEC_L16     :return ".l16";
    case SS_AUDIO_CODEC_AMR     :return ".amr";
    case SS_AUDIO_CODEC_G728    :return ".g728";
    case SS_AUDIO_CODEC_SILK_8  :return ".silk_8";
    case SS_AUDIO_CODEC_SILK_12 :return ".silk_12";
    case SS_AUDIO_CODEC_SILK_16 :return ".silk_16";
    case SS_AUDIO_CODEC_SILK_24 :return ".silk_24";
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :return ".speex_fec_8";
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return ".speex_fec_16";
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return ".dtmf";
    default:break;
    }
    return  ".audio";
}

SS_BYTE   RTPA_GetCodecNumber(IN SS_UINT64 const un64Code)
{
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return SS_AUDIO_UNMBER_ALAW    ;
    case SS_AUDIO_CODEC_ULAW    :return SS_AUDIO_UNMBER_ULAW    ;
    case SS_AUDIO_CODEC_G729    :return SS_AUDIO_UNMBER_G729    ;
    case SS_AUDIO_CODEC_G729A   :return SS_AUDIO_UNMBER_G729A   ;
    case SS_AUDIO_CODEC_G729B   :return SS_AUDIO_UNMBER_G729B   ;
    case SS_AUDIO_CODEC_G729AB  :return SS_AUDIO_UNMBER_G729AB  ;
    case SS_AUDIO_CODEC_G723_63 :return SS_AUDIO_UNMBER_G723_63 ;
    case SS_AUDIO_CODEC_G723_53 :return SS_AUDIO_UNMBER_G723_53 ;
    case SS_AUDIO_CODEC_CELT_32 :return SS_AUDIO_UNMBER_CELT_32 ;
    case SS_AUDIO_CODEC_CELT_48 :return SS_AUDIO_UNMBER_CELT_48 ;
    case SS_AUDIO_CODEC_ILBC_30 :return SS_AUDIO_UNMBER_ILBC_30 ;
    case SS_AUDIO_CODEC_ILBC_20 :return SS_AUDIO_UNMBER_ILBC_20 ;
    case SS_AUDIO_CODEC_G722_16 :return SS_AUDIO_UNMBER_G722_16 ;
    case SS_AUDIO_CODEC_G7221_16:return SS_AUDIO_UNMBER_G7221_16;
    case SS_AUDIO_CODEC_G7221_32:return SS_AUDIO_UNMBER_G7221_32;
    case SS_AUDIO_CODEC_G726_16 :return SS_AUDIO_UNMBER_G726_16 ;
    case SS_AUDIO_CODEC_G726_24 :return SS_AUDIO_UNMBER_G726_24 ;
    case SS_AUDIO_CODEC_G726_32 :return SS_AUDIO_UNMBER_G726_32 ;
    case SS_AUDIO_CODEC_G726_40 :return SS_AUDIO_UNMBER_G726_40 ;
    case SS_AUDIO_CODEC_DVI4_8  :return SS_AUDIO_UNMBER_DVI4_8  ;
    case SS_AUDIO_CODEC_DVI4_16 :return SS_AUDIO_UNMBER_DVI4_16 ;
    case SS_AUDIO_CODEC_SPEEX_8 :return SS_AUDIO_UNMBER_SPEEX_8 ;
    case SS_AUDIO_CODEC_SPEEX_16:return SS_AUDIO_UNMBER_SPEEX_16;
    case SS_AUDIO_CODEC_SPEEX_32:return SS_AUDIO_UNMBER_SPEEX_32;
    case SS_AUDIO_CODEC_BV16    :return SS_AUDIO_UNMBER_BV16    ;
    case SS_AUDIO_CODEC_BV32    :return SS_AUDIO_UNMBER_BV32    ;
    case SS_AUDIO_CODEC_BV32_FEC:return SS_AUDIO_UNMBER_BV32_FEC;
    case SS_AUDIO_CODEC_GSM     :return SS_AUDIO_UNMBER_GSM     ;
    case SS_AUDIO_CODEC_LPC     :return SS_AUDIO_UNMBER_LPC     ;
    case SS_AUDIO_CODEC_L16     :return SS_AUDIO_UNMBER_L16     ;
    case SS_AUDIO_CODEC_AMR     :return SS_AUDIO_UNMBER_AMR     ;
    case SS_AUDIO_CODEC_G728    :return SS_AUDIO_UNMBER_G728    ;
    case SS_AUDIO_CODEC_SILK_8  :return SS_AUDIO_UNMBER_SILK_8  ;
    case SS_AUDIO_CODEC_SILK_12 :return SS_AUDIO_UNMBER_SILK_12 ;
    case SS_AUDIO_CODEC_SILK_16 :return SS_AUDIO_UNMBER_SILK_16 ;
    case SS_AUDIO_CODEC_SILK_24 :return SS_AUDIO_UNMBER_SILK_24 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :return SS_AUDIO_UNMBER_SPEEX_FEC_8 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return SS_AUDIO_UNMBER_SPEEX_FEC_16;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return SS_AUDIO_UNMBER_TELEPHONE_EVENT;
    default:break;
    }
    return 0;
}

SS_SHORT  RTPA_AddCodec(
    IN SS_Audio *s_pAudio,
    IN SS_UINT64 const un64Code,
    IN SS_BYTE   const ubPTID)
{
    if (NULL == s_pAudio)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p",s_pAudio);
#endif
        return SS_ERR_PARAM;
    }
    if (s_pAudio->m_un64Audio&un64Code)//已经存在的语音编码
    {
        return SS_SUCCESS;
    }
    s_pAudio->m_un64Audio+=un64Code;//添加语音编码
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :{s_pAudio->m_ubAlaw_PT=ubPTID;s_pAudio->m_un32AlawRate=SS_AUDIO_RATE_ALAW    ;}break;
    case SS_AUDIO_CODEC_ULAW    :{s_pAudio->m_ubUlaw_PT=ubPTID;s_pAudio->m_un32UlawRate=SS_AUDIO_RATE_ULAW    ;}break;
    case SS_AUDIO_CODEC_G729    :{s_pAudio->m_ubG729_PT=ubPTID;s_pAudio->m_un32G729Rate=SS_AUDIO_RATE_G729    ;}break;
    case SS_AUDIO_CODEC_G729A   :{s_pAudio->m_ubG729_PT=ubPTID;s_pAudio->m_un32G729Rate=SS_AUDIO_RATE_G729A   ;}break;
    case SS_AUDIO_CODEC_G729B   :{s_pAudio->m_ubG729_PT=ubPTID;s_pAudio->m_un32G729Rate=SS_AUDIO_RATE_G729B   ;}break;
    case SS_AUDIO_CODEC_G729AB  :{s_pAudio->m_ubG729_PT=ubPTID;s_pAudio->m_un32G729Rate=SS_AUDIO_RATE_G729AB  ;}break;
    case SS_AUDIO_CODEC_G723_63 :{s_pAudio->m_ubG723_PT=ubPTID;s_pAudio->m_un32G723Rate=SS_AUDIO_RATE_G723_63 ;}break;
    case SS_AUDIO_CODEC_G723_53 :{s_pAudio->m_ubG723_PT=ubPTID;s_pAudio->m_un32G723Rate=SS_AUDIO_RATE_G723_53 ;}break;
    case SS_AUDIO_CODEC_CELT_32 :{s_pAudio->m_ubCELT_PT=ubPTID;s_pAudio->m_un32CELTRate=SS_AUDIO_RATE_CELT_32 ;}break;
    case SS_AUDIO_CODEC_CELT_48 :{s_pAudio->m_ubCELT_PT=ubPTID;s_pAudio->m_un32CELTRate=SS_AUDIO_RATE_CELT_48 ;}break;
    case SS_AUDIO_CODEC_ILBC_30 :{s_pAudio->m_ubiLBC_PT=ubPTID;s_pAudio->m_un32iLBCRate=SS_AUDIO_RATE_ILBC_30 ;}break;
    case SS_AUDIO_CODEC_ILBC_20 :{s_pAudio->m_ubiLBC_PT=ubPTID;s_pAudio->m_un32iLBCRate=SS_AUDIO_RATE_ILBC_20 ;}break;
    case SS_AUDIO_CODEC_G722_16 :{s_pAudio->m_ubG722_PT=ubPTID;s_pAudio->m_un32G722Rate=SS_AUDIO_RATE_G722_16 ;}break;
    case SS_AUDIO_CODEC_G7221_16:{s_pAudio->m_ubG7221_PT=ubPTID;s_pAudio->m_un32G7221Rate=SS_AUDIO_RATE_G7221_16;}break;
    case SS_AUDIO_CODEC_G7221_32:{s_pAudio->m_ubG7221_PT=ubPTID;s_pAudio->m_un32G7221Rate=SS_AUDIO_RATE_G7221_32;}break;
    case SS_AUDIO_CODEC_G726_16 :{s_pAudio->m_ubG726_16_PT=ubPTID;s_pAudio->m_un32G726_16Rate=SS_AUDIO_RATE_G726_16 ;}break;
    case SS_AUDIO_CODEC_G726_24 :{s_pAudio->m_ubG726_24_PT=ubPTID;s_pAudio->m_un32G726_24Rate=SS_AUDIO_RATE_G726_24 ;}break;
    case SS_AUDIO_CODEC_G726_32 :{s_pAudio->m_ubG726_32_PT=ubPTID;s_pAudio->m_un32G726_32Rate=SS_AUDIO_RATE_G726_32 ;}break;
    case SS_AUDIO_CODEC_G726_40 :{s_pAudio->m_ubG726_40_PT=ubPTID;s_pAudio->m_un32G726_40Rate=SS_AUDIO_RATE_G726_40 ;}break;
    case SS_AUDIO_CODEC_DVI4_8  :{s_pAudio->m_ubDVI4_PT=ubPTID;s_pAudio->m_un32DVI4Rate=SS_AUDIO_RATE_DVI4_8  ;}break;
    case SS_AUDIO_CODEC_DVI4_16 :{s_pAudio->m_ubDVI4_PT=ubPTID;s_pAudio->m_un32DVI4Rate=SS_AUDIO_RATE_DVI4_16 ;}break;
    case SS_AUDIO_CODEC_SPEEX_8 :{s_pAudio->m_ubSpeex_8PT =ubPTID;s_pAudio->m_un32Speex_8Rate=SS_AUDIO_RATE_SPEEX_8 ;}break;
    case SS_AUDIO_CODEC_SPEEX_16:{s_pAudio->m_ubSpeex_16PT=ubPTID;s_pAudio->m_un32Speex_16Rate=SS_AUDIO_RATE_SPEEX_16;}break;
    case SS_AUDIO_CODEC_SPEEX_32:{s_pAudio->m_ubSpeex_32PT=ubPTID;s_pAudio->m_un32Speex_32Rate=SS_AUDIO_RATE_SPEEX_32;}break;
    case SS_AUDIO_CODEC_BV16    :{s_pAudio->m_ubBV16_PT=ubPTID;s_pAudio->m_usnBV16Rate=SS_AUDIO_RATE_BV16    ;}break;
    case SS_AUDIO_CODEC_BV32    :{s_pAudio->m_ubBV32_PT=ubPTID;s_pAudio->m_usnBV32Rate=SS_AUDIO_RATE_BV32    ;}break;
    case SS_AUDIO_CODEC_BV32_FEC:{s_pAudio->m_ubBV32FEC_PT=ubPTID;s_pAudio->m_usnBV32FECRate=SS_AUDIO_RATE_BV32_FEC;}break;
    case SS_AUDIO_CODEC_GSM     :{s_pAudio->m_ubGSM_PT=ubPTID;s_pAudio->m_un32GSMRate=SS_AUDIO_RATE_GSM     ;}break;
    case SS_AUDIO_CODEC_LPC     :{s_pAudio->m_ubLPC_PT=ubPTID;s_pAudio->m_un32LPCRate=SS_AUDIO_RATE_LPC     ;}break;
    case SS_AUDIO_CODEC_L16     :{s_pAudio->m_ubL16_PT=ubPTID;s_pAudio->m_un32L16Rate=SS_AUDIO_RATE_L16     ;}break;
    case SS_AUDIO_CODEC_AMR     :{s_pAudio->m_ubAMR_PT=ubPTID;s_pAudio->m_un32AMRRate=SS_AUDIO_RATE_AMR     ;}break;
    case SS_AUDIO_CODEC_G728    :{s_pAudio->m_ubG728_PT=ubPTID;s_pAudio->m_un32G728Rate=SS_AUDIO_RATE_G728    ;}break;
    case SS_AUDIO_CODEC_SILK_8  :{s_pAudio->m_ubSILK_8_PT=ubPTID;s_pAudio->m_un32SILK_8Rate=SS_AUDIO_RATE_SILK_8  ;}break;
    case SS_AUDIO_CODEC_SILK_12 :{s_pAudio->m_ubSILK_12_PT=ubPTID;s_pAudio->m_un32SILK_12Rate=SS_AUDIO_RATE_SILK_12 ;}break;
    case SS_AUDIO_CODEC_SILK_16 :{s_pAudio->m_ubSILK_16_PT=ubPTID;s_pAudio->m_un32SILK_16Rate=SS_AUDIO_RATE_SILK_16 ;}break;
    case SS_AUDIO_CODEC_SILK_24 :{s_pAudio->m_ubSILK_24_PT=ubPTID;s_pAudio->m_un32SILK_24Rate=SS_AUDIO_RATE_SILK_24 ;}break;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :{s_pAudio->m_ubSpeexFEC_8PT =ubPTID;s_pAudio->m_un32SpeexFEC_8Rate=SS_AUDIO_RATE_SPEEX_FEC_8 ;}break;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:{s_pAudio->m_ubSpeexFEC_16PT=ubPTID;s_pAudio->m_un32SpeexFEC_16Rate=SS_AUDIO_RATE_SPEEX_FEC_16;}break;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :{s_pAudio->m_ubTelephoneEvent_PT=ubPTID;s_pAudio->m_un32TelephoneEventRate=SS_AUDIO_RATE_SILK_24 ;}break;
    default:return SS_FAILURE;
    }
    return SS_SUCCESS;
}
SS_SHORT  RTPA_DeleteCodec(IN SS_Audio *s_pAudio,IN SS_UINT64 const un64Code)
{
    if (NULL == s_pAudio)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p",s_pAudio);
#endif
		return SS_ERR_PARAM;
    }
    if(!(s_pAudio->m_un64Audio&un64Code))//没有这个语音编码
    {
        return  SS_SUCCESS;
    }
    s_pAudio->m_un64Audio -= un64Code;//删除这个语音编码
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :{s_pAudio->m_ubAlaw_PT=0;s_pAudio->m_un32AlawRate=0;}break;
    case SS_AUDIO_CODEC_ULAW    :{s_pAudio->m_ubUlaw_PT=0;s_pAudio->m_un32UlawRate=0;}break;
    case SS_AUDIO_CODEC_G729    :{s_pAudio->m_ubG729_PT=0;s_pAudio->m_un32G729Rate=0;}break;
    case SS_AUDIO_CODEC_G729A   :{s_pAudio->m_ubG729_PT=0;s_pAudio->m_un32G729Rate=0;}break;
    case SS_AUDIO_CODEC_G729B   :{s_pAudio->m_ubG729_PT=0;s_pAudio->m_un32G729Rate=0;}break;
    case SS_AUDIO_CODEC_G729AB  :{s_pAudio->m_ubG729_PT=0;s_pAudio->m_un32G729Rate=0;}break;
    case SS_AUDIO_CODEC_G723_63 :{s_pAudio->m_ubG723_PT=0;s_pAudio->m_un32G723Rate=0;}break;
    case SS_AUDIO_CODEC_G723_53 :{s_pAudio->m_ubG723_PT=0;s_pAudio->m_un32G723Rate=0;}break;
    case SS_AUDIO_CODEC_CELT_32 :{s_pAudio->m_ubCELT_PT=0;s_pAudio->m_un32CELTRate=0;}break;
    case SS_AUDIO_CODEC_CELT_48 :{s_pAudio->m_ubCELT_PT=0;s_pAudio->m_un32CELTRate=0;}break;
    case SS_AUDIO_CODEC_ILBC_30 :{s_pAudio->m_ubiLBC_PT=0;s_pAudio->m_un32iLBCRate=0;}break;
    case SS_AUDIO_CODEC_ILBC_20 :{s_pAudio->m_ubiLBC_PT=0;s_pAudio->m_un32iLBCRate=0;}break;
    case SS_AUDIO_CODEC_G722_16 :{s_pAudio->m_ubG722_PT=0;s_pAudio->m_un32G722Rate=0;}break;
    case SS_AUDIO_CODEC_G7221_16:{s_pAudio->m_ubG7221_PT=0;s_pAudio->m_un32G7221Rate=0;}break;
    case SS_AUDIO_CODEC_G7221_32:{s_pAudio->m_ubG7221_PT=0;s_pAudio->m_un32G7221Rate=0;}break;
    case SS_AUDIO_CODEC_G726_16 :{s_pAudio->m_ubG726_16_PT=0;s_pAudio->m_un32G726_16Rate=0;}break;
    case SS_AUDIO_CODEC_G726_24 :{s_pAudio->m_ubG726_24_PT=0;s_pAudio->m_un32G726_24Rate=0;}break;
    case SS_AUDIO_CODEC_G726_32 :{s_pAudio->m_ubG726_32_PT=0;s_pAudio->m_un32G726_32Rate=0;}break;
    case SS_AUDIO_CODEC_G726_40 :{s_pAudio->m_ubG726_40_PT=0;s_pAudio->m_un32G726_40Rate=0;}break;
    case SS_AUDIO_CODEC_DVI4_8  :{s_pAudio->m_ubDVI4_PT=0;s_pAudio->m_un32DVI4Rate=0;}break;
    case SS_AUDIO_CODEC_DVI4_16 :{s_pAudio->m_ubDVI4_PT=0;s_pAudio->m_un32DVI4Rate=0;}break;
    case SS_AUDIO_CODEC_SPEEX_8 :{s_pAudio->m_ubSpeex_8PT=0 ;s_pAudio->m_un32Speex_8Rate=0;}break;
    case SS_AUDIO_CODEC_SPEEX_16:{s_pAudio->m_ubSpeex_16PT=0;s_pAudio->m_un32Speex_16Rate=0;}break;
    case SS_AUDIO_CODEC_SPEEX_32:{s_pAudio->m_ubSpeex_32PT=0;s_pAudio->m_un32Speex_32Rate=0;}break;
    case SS_AUDIO_CODEC_BV16    :{s_pAudio->m_ubBV16_PT=0;s_pAudio->m_usnBV16Rate=0;}break;
    case SS_AUDIO_CODEC_BV32    :{s_pAudio->m_ubBV32_PT=0;s_pAudio->m_usnBV32Rate=0;}break;
    case SS_AUDIO_CODEC_BV32_FEC:{s_pAudio->m_ubBV32FEC_PT=0;s_pAudio->m_usnBV32FECRate=0;}break;
    case SS_AUDIO_CODEC_GSM     :{s_pAudio->m_ubGSM_PT=0;s_pAudio->m_un32GSMRate=0;}break;
    case SS_AUDIO_CODEC_LPC     :{s_pAudio->m_ubLPC_PT=0;s_pAudio->m_un32LPCRate=0;}break;
    case SS_AUDIO_CODEC_L16     :{s_pAudio->m_ubL16_PT=0;s_pAudio->m_un32L16Rate=0;}break;
    case SS_AUDIO_CODEC_AMR     :{s_pAudio->m_ubAMR_PT=0;s_pAudio->m_un32AMRRate=0;}break;
    case SS_AUDIO_CODEC_G728    :{s_pAudio->m_ubG728_PT   =0;s_pAudio->m_un32G728Rate   =0;}break;
    case SS_AUDIO_CODEC_SILK_8  :{s_pAudio->m_ubSILK_8_PT =0;s_pAudio->m_un32SILK_8Rate =0;}break;
    case SS_AUDIO_CODEC_SILK_12 :{s_pAudio->m_ubSILK_12_PT=0;s_pAudio->m_un32SILK_12Rate=0;}break;
    case SS_AUDIO_CODEC_SILK_16 :{s_pAudio->m_ubSILK_16_PT=0;s_pAudio->m_un32SILK_16Rate=0;}break;
    case SS_AUDIO_CODEC_SILK_24 :{s_pAudio->m_ubSILK_24_PT=0;s_pAudio->m_un32SILK_24Rate=0;}break;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :{s_pAudio->m_ubSpeexFEC_8PT=0 ;s_pAudio->m_un32SpeexFEC_8Rate=0;}break;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:{s_pAudio->m_ubSpeexFEC_16PT=0;s_pAudio->m_un32SpeexFEC_16Rate=0;}break;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :{s_pAudio->m_ubTelephoneEvent_PT=0;s_pAudio->m_un32TelephoneEventRate=0;}break;
    default:break;
    }
    return SS_SUCCESS;
}
//返回最终协商的结果，0 表示没有结果发生
SS_UINT64 RTPA_CapabilityNegotiatory(
    IN SS_Audio const *s_pAudioA,
    IN SS_Audio const *s_pAudioB)
{
    if (NULL == s_pAudioA || NULL == s_pAudioB)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,AudioA=%p,AudioB=%p",s_pAudioA,s_pAudioB);
#endif
        return SS_AUDIO_CODEC_TELEPHONE_EVENT-1;
    }
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_ILBC_30 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_ILBC_30 )) return SS_AUDIO_CODEC_ILBC_30 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_ILBC_20 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_ILBC_20 )) return SS_AUDIO_CODEC_ILBC_20 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G729    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G729    )) return SS_AUDIO_CODEC_G729    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G729A   )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G729A   )) return SS_AUDIO_CODEC_G729A   ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G729B   )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G729B   )) return SS_AUDIO_CODEC_G729B   ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G729AB  )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G729AB  )) return SS_AUDIO_CODEC_G729AB  ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G723_63 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G723_63 )) return SS_AUDIO_CODEC_G723_63 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G723_53 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G723_53 )) return SS_AUDIO_CODEC_G723_53 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_GSM     )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_GSM     )) return SS_AUDIO_CODEC_GSM     ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_ULAW    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_ULAW    )) return SS_AUDIO_CODEC_ULAW    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_ALAW    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_ALAW    )) return SS_AUDIO_CODEC_ALAW    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_CELT_32 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_CELT_32 )) return SS_AUDIO_CODEC_CELT_32 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_CELT_48 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_CELT_48 )) return SS_AUDIO_CODEC_CELT_48 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G722_16 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G722_16 )) return SS_AUDIO_CODEC_G722_16 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G7221_16)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G7221_16)) return SS_AUDIO_CODEC_G7221_16;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G7221_32)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G7221_32)) return SS_AUDIO_CODEC_G7221_32;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G726_16 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G726_16 )) return SS_AUDIO_CODEC_G726_16 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G726_24 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G726_24 )) return SS_AUDIO_CODEC_G726_24 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G726_32 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G726_32 )) return SS_AUDIO_CODEC_G726_32 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G726_40 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G726_40 )) return SS_AUDIO_CODEC_G726_40 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_DVI4_8  )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_DVI4_8  )) return SS_AUDIO_CODEC_DVI4_8  ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_DVI4_16 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_DVI4_16 )) return SS_AUDIO_CODEC_DVI4_16 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SPEEX_8 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SPEEX_8 )) return SS_AUDIO_CODEC_SPEEX_8 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SPEEX_16)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SPEEX_16)) return SS_AUDIO_CODEC_SPEEX_16;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SPEEX_32)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SPEEX_32)) return SS_AUDIO_CODEC_SPEEX_32;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_BV16    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_BV16    )) return SS_AUDIO_CODEC_BV16    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_BV32    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_BV32    )) return SS_AUDIO_CODEC_BV32    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_BV32_FEC)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_BV32_FEC)) return SS_AUDIO_CODEC_BV32_FEC;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_LPC     )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_LPC     )) return SS_AUDIO_CODEC_LPC     ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_L16     )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_L16     )) return SS_AUDIO_CODEC_L16     ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_AMR     )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_AMR     )) return SS_AUDIO_CODEC_AMR     ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_G728    )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_G728    )) return SS_AUDIO_CODEC_G728    ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SILK_8  )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SILK_8  )) return SS_AUDIO_CODEC_SILK_8  ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SILK_12 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SILK_12 )) return SS_AUDIO_CODEC_SILK_12 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SILK_16 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SILK_16 )) return SS_AUDIO_CODEC_SILK_16 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SILK_24 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SILK_24 )) return SS_AUDIO_CODEC_SILK_24 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_8 )&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_8 )) return SS_AUDIO_CODEC_SPEEX_FEC_8 ;
    if((s_pAudioA->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_16)&&(s_pAudioB->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_16)) return SS_AUDIO_CODEC_SPEEX_FEC_16;
    return 0;
}
//获得最优的编码
SS_UINT64 RTPA_GetOptimalCodec(IN SS_Audio const *s_pAudio)
{
    if (NULL == s_pAudio)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p",s_pAudio);
#endif
        return SS_AUDIO_CODEC_TELEPHONE_EVENT-1;
    }
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ALAW    ) return SS_AUDIO_CODEC_ALAW    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ULAW    ) return SS_AUDIO_CODEC_ULAW    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729    ) return SS_AUDIO_CODEC_G729    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729A   ) return SS_AUDIO_CODEC_G729A   ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729B   ) return SS_AUDIO_CODEC_G729B   ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729AB  ) return SS_AUDIO_CODEC_G729AB  ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G723_63 ) return SS_AUDIO_CODEC_G723_63 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G723_53 ) return SS_AUDIO_CODEC_G723_53 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_CELT_32 ) return SS_AUDIO_CODEC_CELT_32 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_CELT_48 ) return SS_AUDIO_CODEC_CELT_48 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ILBC_30 ) return SS_AUDIO_CODEC_ILBC_30 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ILBC_20 ) return SS_AUDIO_CODEC_ILBC_20 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G722_16 ) return SS_AUDIO_CODEC_G722_16 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G7221_16) return SS_AUDIO_CODEC_G7221_16;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G7221_32) return SS_AUDIO_CODEC_G7221_32;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_16 ) return SS_AUDIO_CODEC_G726_16 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_24 ) return SS_AUDIO_CODEC_G726_24 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_32 ) return SS_AUDIO_CODEC_G726_32 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_40 ) return SS_AUDIO_CODEC_G726_40 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_DVI4_8  ) return SS_AUDIO_CODEC_DVI4_8  ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_DVI4_16 ) return SS_AUDIO_CODEC_DVI4_16 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_8 ) return SS_AUDIO_CODEC_SPEEX_8 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_16) return SS_AUDIO_CODEC_SPEEX_16;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_32) return SS_AUDIO_CODEC_SPEEX_32;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV16    ) return SS_AUDIO_CODEC_BV16    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV32    ) return SS_AUDIO_CODEC_BV32    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV32_FEC) return SS_AUDIO_CODEC_BV32_FEC;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_GSM     ) return SS_AUDIO_CODEC_GSM     ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_LPC     ) return SS_AUDIO_CODEC_LPC     ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_L16     ) return SS_AUDIO_CODEC_L16     ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_AMR     ) return SS_AUDIO_CODEC_AMR     ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G728    ) return SS_AUDIO_CODEC_G728    ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_8  ) return SS_AUDIO_CODEC_SILK_8  ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_12 ) return SS_AUDIO_CODEC_SILK_12 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_16 ) return SS_AUDIO_CODEC_SILK_16 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_24 ) return SS_AUDIO_CODEC_SILK_24 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_8 ) return SS_AUDIO_CODEC_SPEEX_FEC_8 ;
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_16) return SS_AUDIO_CODEC_SPEEX_FEC_16;
    return 0;
}
SS_CHAR const*RTPA_GetAllCodecString(IN SS_Audio const *s_pAudio,IN SS_CHAR *pCodec)
{
    SS_CHAR *p= pCodec;
    SS_UINT32 un32Len=0;
    if (NULL == s_pAudio || NULL == pCodec)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p,Codec=%p",s_pAudio,pCodec);
#endif
        return "";
    }
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ALAW    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_ALAW    );memcpy(p,SS_AUDIO_STR_ALAW    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ULAW    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_ULAW    );memcpy(p,SS_AUDIO_STR_ULAW    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G729    );memcpy(p,SS_AUDIO_STR_G729    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729A   ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G729A   );memcpy(p,SS_AUDIO_STR_G729A   ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729B   ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G729B   );memcpy(p,SS_AUDIO_STR_G729B   ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729AB  ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G729AB  );memcpy(p,SS_AUDIO_STR_G729AB  ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G723_63 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G723_63 );memcpy(p,SS_AUDIO_STR_G723_63 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G723_53 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G723_53 );memcpy(p,SS_AUDIO_STR_G723_53 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_CELT_32 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_CELT_32 );memcpy(p,SS_AUDIO_STR_CELT_32 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_CELT_48 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_CELT_48 );memcpy(p,SS_AUDIO_STR_CELT_48 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ILBC_30 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_ILBC_30 );memcpy(p,SS_AUDIO_STR_ILBC_30 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ILBC_20 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_ILBC_20 );memcpy(p,SS_AUDIO_STR_ILBC_20 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G722_16 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G722_16 );memcpy(p,SS_AUDIO_STR_G722_16 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G7221_16){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G7221_16);memcpy(p,SS_AUDIO_STR_G7221_16,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G7221_32){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G7221_32);memcpy(p,SS_AUDIO_STR_G7221_32,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_16 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G726_16 );memcpy(p,SS_AUDIO_STR_G726_16 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_24 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G726_24 );memcpy(p,SS_AUDIO_STR_G726_24 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_32 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G726_32 );memcpy(p,SS_AUDIO_STR_G726_32 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G726_40 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G726_40 );memcpy(p,SS_AUDIO_STR_G726_40 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_DVI4_8  ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_DVI4_8  );memcpy(p,SS_AUDIO_STR_DVI4_8  ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_DVI4_16 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_DVI4_16 );memcpy(p,SS_AUDIO_STR_DVI4_16 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_8 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SPEEX_8 );memcpy(p,SS_AUDIO_STR_SPEEX_8 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_16){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SPEEX_16);memcpy(p,SS_AUDIO_STR_SPEEX_16,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_32){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SPEEX_32);memcpy(p,SS_AUDIO_STR_SPEEX_32,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV16    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_BV16    );memcpy(p,SS_AUDIO_STR_BV16    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV32    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_BV32    );memcpy(p,SS_AUDIO_STR_BV32    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_BV32_FEC){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_BV32_FEC);memcpy(p,SS_AUDIO_STR_BV32_FEC,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_GSM     ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_GSM     );memcpy(p,SS_AUDIO_STR_GSM     ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_LPC     ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_LPC     );memcpy(p,SS_AUDIO_STR_LPC     ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_L16     ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_L16     );memcpy(p,SS_AUDIO_STR_L16     ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_AMR     ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_AMR     );memcpy(p,SS_AUDIO_STR_AMR     ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G728    ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_G728    );memcpy(p,SS_AUDIO_STR_G728    ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_8  ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SILK_8  );memcpy(p,SS_AUDIO_STR_SILK_8  ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_12 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SILK_12 );memcpy(p,SS_AUDIO_STR_SILK_12 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_16 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SILK_16 );memcpy(p,SS_AUDIO_STR_SILK_16 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SILK_24 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SILK_24 );memcpy(p,SS_AUDIO_STR_SILK_24 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_8 ){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SPEEX_FEC_8 );memcpy(p,SS_AUDIO_STR_SPEEX_FEC_8 ,un32Len);p+=un32Len;}
    if(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_SPEEX_FEC_16){if(*pCodec){*p=',';p++;}un32Len=strlen(SS_AUDIO_STR_SPEEX_FEC_16);memcpy(p,SS_AUDIO_STR_SPEEX_FEC_16,un32Len);p+=un32Len;}
    return pCodec;
}
/*
v=0
o=- 8 2 IN IP4 192.168.0.101
s=CounterPath X-Lite 3.0
c=IN IP4 192.168.0.101
t=0 0
m=audio 3052 RTP/AVP 107 119 100 106 0 105 98 8 3 101
a=alt:1 3 : mrrX3lm+ Vd/VABj2 192.168.0.101 3052
a=alt:2 2 : jrTODZQS 0QH4saVg 192.168.152.1 3052
a=alt:3 1 : 0Mw/wL1z vux6RT3E 192.168.172.1 3052
a=fmtp:101 0-15
a=rtpmap:107 BV32/16000
a=rtpmap:119 BV32-FEC/16000
a=rtpmap:100 SPEEX/16000
a=rtpmap:106 SPEEX-FEC/16000
a=rtpmap:105 SPEEX-FEC/8000
a=rtpmap:98 iLBC/8000
a=rtpmap:101 telephone-event/8000
a=sendrecv
m=video 3054 RTP/AVP 115 34
a=alt:1 3 : +Sto08q4 odhrEx7y 192.168.0.101 3054
a=alt:2 2 : rqz5rIof ykoLuyUQ 192.168.152.1 3054
a=alt:3 1 : nR00KSJE SoMlFZM0 192.168.172.1 3054
a=fmtp:115 QCIF=1 CIF=1 I=1 J=1 T=1 MaxBR=4520
a=fmtp:34 QCIF=1 CIF=1 MaxBR=4520
a=rtpmap:115 H263-1998/90000
a=rtpmap:34 H263/90000
a=sendrecv    
*/

static  SS_SHORT  ParseAudioCodecInfo(IN  SS_Audio *s_pAudio,IN  SS_CHAR const *psCodec,IN SS_UINT32 const un32Len)
{
    SS_CHAR const *p=NULL;
    SS_BYTE  ubCodec = 0;
    if (NULL == s_pAudio || NULL == psCodec)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p,Codec=%p",s_pAudio,psCodec);
#endif
        return SS_ERR_PARAM;
    }
    ubCodec = atoi(psCodec);
    if (NULL == (p = strchr(psCodec,' ')))
    {
        return  SS_FAILURE;
    }
    while(' ' == *p)p++;//去掉空格
    if (0 == SS_strcasecmp(p,"iLBC/8000"))
    {
        if (!(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ILBC_20))
        {
            s_pAudio->m_un64Audio+=SS_AUDIO_CODEC_ILBC_20;
            s_pAudio->m_ubiLBC_PT = ubCodec;
        }
    }
    return  SS_SUCCESS;
}

SS_SHORT  RTPA_ParseAudioSDPInfo(
    IN  SS_CHAR const *psSDPStr,
    OUT SS_Audio *s_pAudio,
    OUT SS_CHAR *pIP,
 IN OUT SS_UINT32*pun32IPLen,
    OUT SS_USHORT*pusnPort)
{
    SS_CHAR const *p   =NULL;
    SS_CHAR const *pCap=NULL;
    SS_CHAR sBuf[512] = "";
    SS_CHAR sCode[256] = "";
    SS_UINT32 un32Len=0;
    SS_UINT32 un32CodeLen=0;
    if (NULL==psSDPStr||NULL==s_pAudio||NULL==pIP||NULL==pun32IPLen||NULL==pusnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SDPStr=%p,Audio=%p,IP=%p,pun32IPLen=%p,"
            "pusnPort=%p",psSDPStr,s_pAudio,pIP,pun32IPLen,pusnPort);
#endif
        return SS_ERR_PARAM;
    }

    if (pIP&&*pun32IPLen>=64)
    {
        if (p = strstr(psSDPStr,"c="))
        {
            un32Len = sizeof(sBuf);
            SS_String_GetBeginToChar(p+2,'\r',sBuf,&un32Len);
            if (p = strstr(sBuf,"IP4"))
            {
                p+=3;
                while(' ' == *p)p++;//去掉空格
                *pun32IPLen = strlen(p);
                memcpy(pIP,p,*pun32IPLen);
            }
        }
    }
    if (NULL ==(pCap = strstr(psSDPStr,"m=audio")))
    {
        return SS_FAILURE;
    }
    if (pusnPort)
    {
        *pusnPort = atoi(pCap+8);
    }
    pCap+=10;
    if (NULL == (p = strstr(pCap,"RTP/AVP")))
    {
        return SS_FAILURE;
    }
    p+=8;
    memset(sBuf,0,sizeof(sBuf));
    un32Len = sizeof(sBuf);
    SS_String_GetBeginToChar(p,'\r',sBuf,&un32Len);
    p = sBuf;
    pCap += (un32Len+8);
    while('\0' != *p)
    {
        switch (*p)
        {
        case '0':
            {
                if(!(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ULAW))
                {
                    s_pAudio->m_un64Audio+=SS_AUDIO_CODEC_ULAW;
                }
            }break;
        case '1':
            {
                if ('8' == *(p+1))//18
                {
                    if(!(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G729))
                    {
                        s_pAudio->m_un64Audio+=SS_AUDIO_CODEC_G729;
                    }
                    p++;
                }
            }break;
        case '4':
            {
                if(!(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_G723_53))
                {
                    s_pAudio->m_un64Audio+=SS_AUDIO_CODEC_G723_53;
                }
            }break;
        case '8':
            {
                if(!(s_pAudio->m_un64Audio&SS_AUDIO_CODEC_ALAW))
                {
                    s_pAudio->m_un64Audio+=SS_AUDIO_CODEC_ALAW;
                }
            }break;
        default:break;
        }
        p++;
    }

    if (NULL == (p = strstr(pCap,"a=")))
    {
        return SS_FAILURE;
    }
    p+=2;
    do 
    {
        while(' ' == *p)p++;//去掉空格
        memset(sBuf,0,sizeof(sBuf));
        un32Len = sizeof(sBuf);
        memset(sCode,0,sizeof(sCode));
        un32CodeLen = sizeof(sCode);
        switch(*p)
        {
        //rtpmap:107 BV32/16000
        case 'r':
            {
                if(SS_strncasecmp(p,"rtpmap",6))
                {
                    return  SS_FAILURE;
                }
                pCap = p+6;
                SS_String_GetBeginToChar(pCap,'\r',sBuf,&un32Len);//获得这一行的信息
                if (NULL == (p = strchr(sBuf,':')))
                {
                    return SS_FAILURE;
                }
                p++;
                while(' ' == *p)p++;//去掉空格
                SS_String_GetBeginToChar(p,'\r',sCode,&un32CodeLen);//获得CODEC的信息 (107 BV32/16000)
                if (SS_SUCCESS != ParseAudioCodecInfo(s_pAudio,sCode,un32CodeLen))
                {
                    return SS_FAILURE;
                }
                p = pCap+un32Len;
            }break;
        //a=fmtp:101 0-15
        case 'f':break;
        //a=sendrecv
        case 's':break;
        //a=alt:1 3 : mrrX3lm+ Vd/VABj2 192.168.0.101 3052
        case 'a':break;
        default:break;
        }
        if (NULL == (p = strstr(p,"a=")))
        {
            break;
        }
        p+=2;
    } while ('\0' != *p);
    return SS_SUCCESS;
}
SS_BYTE   RTPA_GetDefaultPayloadID(IN SS_UINT64 const un64Code)
{
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return SS_AUDIO_PT_ALAW    ;
    case SS_AUDIO_CODEC_ULAW    :return SS_AUDIO_PT_ULAW    ;
    case SS_AUDIO_CODEC_G729    :return SS_AUDIO_PT_G729    ;
    case SS_AUDIO_CODEC_G729A   :return SS_AUDIO_PT_G729A   ;
    case SS_AUDIO_CODEC_G729B   :return SS_AUDIO_PT_G729B   ;
    case SS_AUDIO_CODEC_G729AB  :return SS_AUDIO_PT_G729AB  ;
    case SS_AUDIO_CODEC_G723_63 :return SS_AUDIO_PT_G723_63 ;
    case SS_AUDIO_CODEC_G723_53 :return SS_AUDIO_PT_G723_53 ;
    case SS_AUDIO_CODEC_CELT_32 :return SS_AUDIO_PT_CELT_32 ;
    case SS_AUDIO_CODEC_CELT_48 :return SS_AUDIO_PT_CELT_48 ;
    case SS_AUDIO_CODEC_ILBC_30 :return SS_AUDIO_PT_ILBC_30 ;
    case SS_AUDIO_CODEC_ILBC_20 :return SS_AUDIO_PT_ILBC_20 ;
    case SS_AUDIO_CODEC_G722_16 :return SS_AUDIO_PT_G722_16 ;
    case SS_AUDIO_CODEC_G7221_16:return SS_AUDIO_PT_G7221_16;
    case SS_AUDIO_CODEC_G7221_32:return SS_AUDIO_PT_G7221_32;
    case SS_AUDIO_CODEC_G726_16 :return SS_AUDIO_PT_G726_16 ;
    case SS_AUDIO_CODEC_G726_24 :return SS_AUDIO_PT_G726_24 ;
    case SS_AUDIO_CODEC_G726_32 :return SS_AUDIO_PT_G726_32 ;
    case SS_AUDIO_CODEC_G726_40 :return SS_AUDIO_PT_G726_40 ;
    case SS_AUDIO_CODEC_DVI4_8  :return SS_AUDIO_PT_DVI4_8  ;
    case SS_AUDIO_CODEC_DVI4_16 :return SS_AUDIO_PT_DVI4_16 ;
    case SS_AUDIO_CODEC_SPEEX_8 :return SS_AUDIO_PT_SPEEX_8 ;
    case SS_AUDIO_CODEC_SPEEX_16:return SS_AUDIO_PT_SPEEX_16;
    case SS_AUDIO_CODEC_SPEEX_32:return SS_AUDIO_PT_SPEEX_32;
    case SS_AUDIO_CODEC_BV16    :return SS_AUDIO_PT_BV16;
    case SS_AUDIO_CODEC_BV32    :return SS_AUDIO_PT_BV32;
    case SS_AUDIO_CODEC_BV32_FEC:return SS_AUDIO_PT_BV32_FEC;
    case SS_AUDIO_CODEC_GSM     :return SS_AUDIO_PT_GSM    ;
    case SS_AUDIO_CODEC_LPC     :return SS_AUDIO_PT_LPC    ;
    case SS_AUDIO_CODEC_L16     :return SS_AUDIO_PT_L16    ;
    case SS_AUDIO_CODEC_AMR     :return SS_AUDIO_PT_AMR    ;
    case SS_AUDIO_CODEC_G728    :return SS_AUDIO_PT_G728   ;
    case SS_AUDIO_CODEC_SILK_8  :return SS_AUDIO_PT_SILK_8 ;
    case SS_AUDIO_CODEC_SILK_12 :return SS_AUDIO_PT_SILK_12;
    case SS_AUDIO_CODEC_SILK_16 :return SS_AUDIO_PT_SILK_16;
    case SS_AUDIO_CODEC_SILK_24 :return SS_AUDIO_PT_SILK_24;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return SS_AUDIO_PT_TELEPHONE_EVENT;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :return SS_AUDIO_PT_SPEEX_FEC_8 ;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return SS_AUDIO_PT_SPEEX_FEC_16;
    default:break;
    }
    return  0;
}
SS_BYTE RTPA_GetPayloadID(IN  SS_Audio const *s_pAudio,IN SS_UINT64 const un64Code)
{
    switch (un64Code)
    {
    case SS_AUDIO_CODEC_ALAW    :return s_pAudio->m_ubAlaw_PT;
    case SS_AUDIO_CODEC_ULAW    :return s_pAudio->m_ubUlaw_PT;
    case SS_AUDIO_CODEC_G729    :return s_pAudio->m_ubG729_PT;
    case SS_AUDIO_CODEC_G729A   :return s_pAudio->m_ubG729_PT;
    case SS_AUDIO_CODEC_G729B   :return s_pAudio->m_ubG729_PT;
    case SS_AUDIO_CODEC_G729AB  :return s_pAudio->m_ubG729_PT;
    case SS_AUDIO_CODEC_G723_63 :return s_pAudio->m_ubG723_PT;
    case SS_AUDIO_CODEC_G723_53 :return s_pAudio->m_ubG723_PT;
    case SS_AUDIO_CODEC_CELT_32 :return s_pAudio->m_ubCELT_PT;
    case SS_AUDIO_CODEC_CELT_48 :return s_pAudio->m_ubCELT_PT;
    case SS_AUDIO_CODEC_ILBC_30 :return s_pAudio->m_ubiLBC_PT;
    case SS_AUDIO_CODEC_ILBC_20 :return s_pAudio->m_ubiLBC_PT;
    case SS_AUDIO_CODEC_G722_16 :return s_pAudio->m_ubG722_PT;
    case SS_AUDIO_CODEC_G7221_16:return s_pAudio->m_ubG7221_PT;
    case SS_AUDIO_CODEC_G7221_32:return s_pAudio->m_ubG7221_PT;
    case SS_AUDIO_CODEC_G726_16 :return s_pAudio->m_ubG726_16_PT;
    case SS_AUDIO_CODEC_G726_24 :return s_pAudio->m_ubG726_24_PT;
    case SS_AUDIO_CODEC_G726_32 :return s_pAudio->m_ubG726_32_PT;
    case SS_AUDIO_CODEC_G726_40 :return s_pAudio->m_ubG726_40_PT;
    case SS_AUDIO_CODEC_DVI4_8  :return s_pAudio->m_ubDVI4_PT;
    case SS_AUDIO_CODEC_DVI4_16 :return s_pAudio->m_ubDVI4_PT;
    case SS_AUDIO_CODEC_SPEEX_8 :return s_pAudio->m_ubSpeex_8PT;
    case SS_AUDIO_CODEC_SPEEX_16:return s_pAudio->m_ubSpeex_16PT;
    case SS_AUDIO_CODEC_SPEEX_32:return s_pAudio->m_ubSpeex_32PT;
    case SS_AUDIO_CODEC_BV16    :return s_pAudio->m_ubBV16_PT;
    case SS_AUDIO_CODEC_BV32    :return s_pAudio->m_ubBV32_PT;
    case SS_AUDIO_CODEC_BV32_FEC:return s_pAudio->m_ubBV32FEC_PT;
    case SS_AUDIO_CODEC_GSM     :return s_pAudio->m_ubGSM_PT;
    case SS_AUDIO_CODEC_LPC     :return s_pAudio->m_ubLPC_PT;
    case SS_AUDIO_CODEC_L16     :return s_pAudio->m_ubL16_PT;
    case SS_AUDIO_CODEC_AMR     :return s_pAudio->m_ubAMR_PT;
    case SS_AUDIO_CODEC_G728    :return s_pAudio->m_ubG728_PT   ;
    case SS_AUDIO_CODEC_SILK_8  :return s_pAudio->m_ubSILK_8_PT ;
    case SS_AUDIO_CODEC_SILK_12 :return s_pAudio->m_ubSILK_12_PT;
    case SS_AUDIO_CODEC_SILK_16 :return s_pAudio->m_ubSILK_16_PT;
    case SS_AUDIO_CODEC_SILK_24 :return s_pAudio->m_ubSILK_24_PT;
    case SS_AUDIO_CODEC_SPEEX_FEC_8 :return s_pAudio->m_ubSpeexFEC_8PT;
    case SS_AUDIO_CODEC_SPEEX_FEC_16:return s_pAudio->m_ubSpeexFEC_16PT;
    case SS_AUDIO_CODEC_TELEPHONE_EVENT :return s_pAudio->m_ubTelephoneEvent_PT;
    default:break;
    }
    return  253;
}
//构造SDP信息到字符串
SS_CHAR const*RTPA_CreateAudioSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen)
{
    SS_CHAR   sAudio[512] = "";
    SS_BYTE   ubPayloadID = 0;

    SS_CHAR   sALAW[64] = "";
    SS_CHAR   sALAW_ID[6]=""; 
    
    SS_CHAR   sULAW[64] = "";
    SS_CHAR   sULAW_ID[6]="";

    SS_CHAR   siLBC_30[64] = "";
    SS_CHAR   siLBC_30_ID[6]="";

    SS_CHAR   siLBC_20[64] = "";
    SS_CHAR   siLBC_20_ID[6]="";

    SS_CHAR   sg722[64] = "";
    SS_CHAR   sg722_ID[6]="";

    SS_CHAR   sg723[64] = "";
    SS_CHAR   sg723_ID[6]="";

    SS_CHAR   sg729[64] = "";
    SS_CHAR   sg729_ID[6]="";

    SS_CHAR   sBV32[64] = "";
    SS_CHAR   sBV32_ID[6]="";

    SS_CHAR   sBV32FEC[64] = "";
    SS_CHAR   sBV32FEC_ID[6]="";

    SS_CHAR   sSpeex_16[64] = "";
    SS_CHAR   sSpeex_16_ID[6]="";

    SS_CHAR   sgSpeexFEC_8[64] = "";
    SS_CHAR   sgSpeexFEC_8_ID[6]="";

    SS_CHAR   sSpeexFEC_16[64] = "";
    SS_CHAR   sSpeexFEC_16_ID[6]="";

    SS_CHAR   sTelephoneEvent[128] = "";
    SS_CHAR   sTelephoneEvent_ID[6]="";
    
    if (NULL==psSDP||NULL==s_pAudio||NULL==pun32SDPLen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SDP=%p,Audio=%p,pun32SDPLen=%p",psSDP,s_pAudio,pun32SDPLen);
#endif
        return "";
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_BV32))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_BV32);
        SS_snprintf(sBV32,sizeof(sBV32),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_BV32),s_pAudio->m_usnBV32Rate);
        SS_snprintf(sBV32_ID,sizeof(sBV32_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_BV32_FEC))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_BV32_FEC);
        SS_snprintf(sBV32FEC,sizeof(sBV32FEC),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_BV32_FEC),s_pAudio->m_usnBV32FECRate);
        SS_snprintf(sBV32FEC_ID,sizeof(sBV32FEC_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_SPEEX_16))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_SPEEX_16);
        SS_snprintf(sSpeex_16,sizeof(sSpeex_16),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_SPEEX_16),s_pAudio->m_un32Speex_16Rate);
        SS_snprintf(sSpeex_16_ID,sizeof(sSpeex_16_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_SPEEX_FEC_8))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_SPEEX_FEC_8);
        SS_snprintf(sgSpeexFEC_8,sizeof(sgSpeexFEC_8),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_SPEEX_FEC_8),s_pAudio->m_un32SpeexFEC_8Rate);
        SS_snprintf(sgSpeexFEC_8_ID,sizeof(sgSpeexFEC_8_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_SPEEX_FEC_16))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_SPEEX_FEC_16);
        SS_snprintf(sSpeexFEC_16,sizeof(sSpeexFEC_16),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_SPEEX_FEC_16),s_pAudio->m_un32SpeexFEC_16Rate);
        SS_snprintf(sSpeexFEC_16_ID,sizeof(sSpeexFEC_16_ID)," %u",ubPayloadID);
    }


    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_ULAW))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_ULAW);
        SS_snprintf(sULAW,sizeof(sULAW),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_ULAW),s_pAudio->m_un32UlawRate);
        SS_snprintf(sULAW_ID,sizeof(sULAW_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_ALAW))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_ALAW);
        SS_snprintf(sALAW,sizeof(sALAW),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_ALAW),s_pAudio->m_un32AlawRate);
        SS_snprintf(sALAW_ID,sizeof(sALAW_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_G729))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_G729);
        SS_snprintf(sg729,sizeof(sg729),"a=rtpmap:%u %s/%u\r\na=fmtp:%u annexb=no\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_G729),s_pAudio->m_un32G729Rate,ubPayloadID);
        SS_snprintf(sg729_ID,sizeof(sg729_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_ILBC_30))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_ILBC_30);
        SS_snprintf(siLBC_30,sizeof(siLBC_30),"a=rtpmap:%u %s/%u\r\na=fMtp:%u mode=30ms\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_ILBC_30),s_pAudio->m_un32iLBCRate,ubPayloadID);
        SS_snprintf(siLBC_30_ID,sizeof(siLBC_30_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_ILBC_20))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_ILBC_20);
        SS_snprintf(siLBC_20,sizeof(siLBC_20),"a=rtpmap:%u %s/%u\r\na=fMtp:%u mode=20ms\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_ILBC_20),s_pAudio->m_un32iLBCRate,ubPayloadID);
        SS_snprintf(siLBC_20_ID,sizeof(siLBC_20_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_G723_63)||RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_G723_53))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_G723_63);
        SS_snprintf(sg723,sizeof(sg723),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_G723_63),s_pAudio->m_un32G723Rate);
        SS_snprintf(sg723_ID,sizeof(sg723_ID)," %u",ubPayloadID);
    }
    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_G722_16))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_G722_16);
        SS_snprintf(sg722,sizeof(sg722),"a=rtpmap:%u %s/%u\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_G722_16),s_pAudio->m_un32G722Rate);
        SS_snprintf(sg722_ID,sizeof(sg722_ID)," %u",ubPayloadID);
    }

    if (RTPA_isCodec(s_pAudio,SS_AUDIO_CODEC_TELEPHONE_EVENT))
    {
        ubPayloadID=RTPA_GetPayloadID(s_pAudio,SS_AUDIO_CODEC_TELEPHONE_EVENT);
        SS_snprintf(sTelephoneEvent,sizeof(sTelephoneEvent),"a=rtpmap:%u %s/%u\r\na=fmtp:101 0-15\r\n",
            ubPayloadID,RTPA_GetCodecStr(SS_AUDIO_CODEC_TELEPHONE_EVENT),s_pAudio->m_un32TelephoneEventRate);
        SS_snprintf(sTelephoneEvent_ID,sizeof(sTelephoneEvent_ID)," %u",ubPayloadID);
    }

    SS_snprintf(sAudio,sizeof(sAudio),"m=audio %u RTP/AVP"
        "%s%s%s%s%s%s%s%s%s%s%s%s%s\r\n",usnPort,sULAW_ID,sALAW_ID,sg723_ID,sg729_ID,sg722_ID,
        siLBC_30_ID,siLBC_20_ID,sBV32_ID,sBV32FEC_ID,sSpeex_16_ID,sgSpeexFEC_8_ID,sSpeexFEC_16_ID,
        sTelephoneEvent_ID);
    
    
    *pun32SDPLen = (SS_USHORT)SS_snprintf(psSDP,*pun32SDPLen,"%s"
        "%s%s%s%s%s%s%s%s%s%s%s%s%s"
        "a=%s\r\n",sAudio,sULAW,sALAW,sg723,sg729,sg722,siLBC_30,siLBC_20,sBV32,sBV32FEC,sSpeex_16,sgSpeexFEC_8,sSpeexFEC_16,
        sTelephoneEvent,
        (SIP_SDP_SEND_ONLY==s_pAudio->m_eSDPDirection)?"sendonly":
        (SIP_SDP_RECV_ONLY==s_pAudio->m_eSDPDirection)?"recvonly":"sendrecv");

    return psSDP;
}

/*
v=0
o=- 8 2 IN IP4 192.168.0.101
s=CounterPath X-Lite 3.0
c=IN IP4 192.168.0.101
t=0 0
m=audio 3052 RTP/AVP 107 119 100 106 0 105 98 8 3 101
a=alt:1 3 : mrrX3lm+ Vd/VABj2 192.168.0.101 3052
a=alt:2 2 : jrTODZQS 0QH4saVg 192.168.152.1 3052
a=alt:3 1 : 0Mw/wL1z vux6RT3E 192.168.172.1 3052
a=fmtp:101 0-15
a=rtpmap:107 BV32/16000
a=rtpmap:119 BV32-FEC/16000
a=rtpmap:100 SPEEX/16000
a=rtpmap:106 SPEEX-FEC/16000
a=rtpmap:105 SPEEX-FEC/8000
a=rtpmap:98 iLBC/8000
a=rtpmap:101 telephone-event/8000
a=sendrecv
*/
SS_CHAR const*RTP_CreateAudioSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen)
{
    SS_CHAR  sAudioSDP[2048] = "";
    SS_UINT32 un32Len=sizeof(sAudioSDP);
    if (NULL==psSDP||NULL==s_pAudio||NULL==pun32SDPLen||NULL==pIP)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SDP=%p,Audio=%p,pun32SDPLen=%p,IP=%p",psSDP,s_pAudio,pun32SDPLen,pIP);
#endif
        return "";
    }

    RTPA_CreateAudioSDPStr(s_pAudio,usnPort,sAudioSDP,&un32Len);
    *pun32SDPLen = (SS_USHORT)SS_snprintf(psSDP,*pun32SDPLen,
        "v=0\r\n"
        "o=sunshine 8 2 IN IP4 %s\r\n"
        "s=sunshine SIP stack %s\r\n"
        "c=IN IP4 %s\r\n"
        "t=0 0\r\n"
        "%s",pIP,IT_VERSION,pIP,sAudioSDP);
    return  psSDP;
}


//////////////////////////////////////////////////////////////////////////


//判断这个编码有没有
SS_UINT32 RTPV_TransformCodecStr2int(IN  SS_CHAR const*const psCodecString)
{
    return 0;
}
SS_CHAR const*RTPV_TransformCodecint2Str(IN SS_UINT32 const un32Code)
{
    return "";
}
SS_SHORT  RTPV_AddCodec(IN SS_Video *s_pVideo,   IN SS_UINT32 const un32Code)
{
    return 0;
}
SS_SHORT  RTPV_DeleteCodec(IN SS_Video *s_pVideo,IN SS_UINT32 const un32Code)
{
    return 0;
}
//返回最终协商的结果，0 表示没有结果发生
SS_UINT32 RTPV_CapabilityNegotiatory(
    IN SS_Video const *s_pVideoA,
    IN SS_Video const *s_pVideoB)
{
    return 0;
}
//获得最优的编码
SS_UINT32 RTPV_GetOptimalCodec(IN SS_Video const *s_pVideo)
{
    return 0;
}
SS_CHAR const*RTPV_GetAllCodecString(IN SS_Video const *s_pVideo,IN SS_CHAR *pCodec)
{
    return 0;
}

/*
v=0
o=- 8 2 IN IP4 192.168.0.101
s=CounterPath X-Lite 3.0
c=IN IP4 192.168.0.101
t=0 0
m=audio 3052 RTP/AVP 107 119 100 106 0 105 98 8 3 101
a=alt:1 3 : mrrX3lm+ Vd/VABj2 192.168.0.101 3052
a=alt:2 2 : jrTODZQS 0QH4saVg 192.168.152.1 3052
a=alt:3 1 : 0Mw/wL1z vux6RT3E 192.168.172.1 3052
a=fmtp:101 0-15
a=rtpmap:107 BV32/16000
a=rtpmap:119 BV32-FEC/16000
a=rtpmap:100 SPEEX/16000
a=rtpmap:106 SPEEX-FEC/16000
a=rtpmap:105 SPEEX-FEC/8000
a=rtpmap:98 iLBC/8000
a=rtpmap:101 telephone-event/8000
a=sendrecv
m=video 3054 RTP/AVP 115 34
a=alt:1 3 : +Sto08q4 odhrEx7y 192.168.0.101 3054
a=alt:2 2 : rqz5rIof ykoLuyUQ 192.168.152.1 3054
a=alt:3 1 : nR00KSJE SoMlFZM0 192.168.172.1 3054
a=fmtp:115 QCIF=1 CIF=1 I=1 J=1 T=1 MaxBR=4520
a=fmtp:34 QCIF=1 CIF=1 MaxBR=4520
a=rtpmap:115 H263-1998/90000
a=rtpmap:34 H263/90000
a=sendrecv    
*/
SS_SHORT  RTPV_ParseVideoSDPInfo(
    IN  SS_CHAR const *psSDPStr,
    OUT SS_Video *s_pVideo,
    OUT SS_CHAR *pIP,
 IN OUT SS_UINT32*pun32IPLen,
    OUT SS_USHORT*pusnPort)
{
    SS_CHAR const *p   =NULL;
    SS_CHAR const *pCap=NULL;
    SS_CHAR sBuf[512] = "";
    SS_UINT32 un32Len=0;
    if (NULL==psSDPStr||NULL==s_pVideo||NULL==pIP||NULL==pun32IPLen||NULL==pusnPort)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,SDPStr=%p,Video=%p,IP=%p,IPLen=%p,Port=%p",
            psSDPStr,s_pVideo,pIP,pun32IPLen,pusnPort);
#endif
        return SS_ERR_PARAM;
    }
    if (pIP&&*pun32IPLen>=64)
    {
        if (p = strstr(psSDPStr,"c="))
        {
            un32Len = sizeof(sBuf);
            SS_String_GetBeginToChar(p+2,'\r',sBuf,&un32Len);
            if (p = strstr(sBuf,"IP4"))
            {
                p+=3;
                while(' ' == *p)p++;//去掉空格
                memcpy(pIP,p,strlen(p));
            }
        }
    }
    if (NULL ==(pCap = strstr(psSDPStr,"m=video")))
    {
        return SS_FAILURE;
    }
    if (pusnPort)
    {
        *pusnPort = atoi(pCap+8);
    }
    pCap+=10;
    return SS_SUCCESS;
}

SS_BYTE   RTPV_GetPayloadID(IN  SS_Video const *s_pVideo,IN SS_UINT32 const un32Code)
{
    if (NULL==s_pVideo)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Video=%p",s_pVideo);
#endif
        return 253;
    }
    switch(un32Code)
    {
    case SS_VIDEO_CODEC_H261     :return s_pVideo->m_ubH261;//     (1<<0) //H.261 Video
    case SS_VIDEO_CODEC_H263     :return s_pVideo->m_ubH263;//     (1<<1) //H.263 Video
    case SS_VIDEO_CODEC_H263_1998:return s_pVideo->m_ubH263_1998;//     (1<<2) //H.263-1998 Video
    case SS_VIDEO_CODEC_H263_2000:return s_pVideo->m_ubH263_2000;//     (1<<3) //H.263-2000 Video
    case SS_VIDEO_CODEC_H264     :return s_pVideo->m_ubH264;//     (1<<4) //H.264 Video
    case SS_VIDEO_CODEC_H265     :return s_pVideo->m_ubH265;//     (1<<5) //H.265 Video
    case SS_VIDEO_CODEC_MPEG4    :return s_pVideo->m_ubMPEG4;//    (1<<6) //
    default:break;
    }
    return 253;
}
//构造SD信息到字符串
SS_CHAR const*RTPV_CreateVideoSDPStr(
    IN  SS_Video const *s_pVideo,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen)
{
    return 0;
}

SS_CHAR const*RTP_CreateVideoSDPStr(
    IN  SS_Video const *s_pVideo,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen)
{
    SS_CHAR  sVideoSDP[2048] = "";
    SS_UINT32 un32Len=sizeof(sVideoSDP);
    if (NULL==s_pVideo||NULL==pIP||NULL==psSDP||NULL==pun32SDPLen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Video=%p,IP=%p,SDP=%p,SDPLen=%p",s_pVideo,pIP,psSDP,pun32SDPLen);
#endif
        return "";
    }
    RTPV_CreateVideoSDPStr(s_pVideo,usnPort,sVideoSDP,&un32Len);
    *pun32SDPLen = (SS_USHORT)SS_snprintf(psSDP,*pun32SDPLen,
        "v=0\r\n"
        "o=- 8 2 IN IP4 %s\r\n"
        "s=DNL SIP stack %s\r\n"
        "c=IN IP4 %s\r\n"
        "t=0 0\r\n"
        "%s",pIP,IT_VERSION,pIP,sVideoSDP);
    return  psSDP;
}


SS_CHAR const*RTP_CreateAudioVideoSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_Video const *s_pVideo,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnAudioPort,
    IN  SS_USHORT const usnVideoPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen)
{
    SS_CHAR  sAudioSDP[2048] = "";
    SS_CHAR  sVideoSDP[2048] = "";
    SS_UINT32 un32Len=sizeof(sAudioSDP);
    if (NULL==s_pAudio||NULL==s_pVideo||NULL==pIP||NULL==psSDP||NULL==pun32SDPLen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,Audio=%p,Video=%p,IP=%p,SDP=%p,"
            "SDPLen=%p",s_pAudio,s_pVideo,pIP,psSDP,pun32SDPLen);
#endif
        return "";
    }
    RTPA_CreateAudioSDPStr(s_pAudio,usnAudioPort,sAudioSDP,&un32Len);
    un32Len=sizeof(sVideoSDP);
    RTPV_CreateVideoSDPStr(s_pVideo,usnVideoPort,sVideoSDP,&un32Len);
    *pun32SDPLen = (SS_USHORT)SS_snprintf(psSDP,*pun32SDPLen,
        "v=0\r\n"
        "o=- 8 2 IN IP4 %s\r\n"
        "s=DNL SIP stack %s\r\n"
        "c=IN IP4 %s\r\n"
        "t=0 0\r\n"
        "%s%s",pIP,IT_VERSION,pIP,sAudioSDP,sVideoSDP);
    return psSDP;
}


//////////////////////////////////////////////////////////////////////////


/*SS_SHORT RTP_CreateSynchronizationSource(IN PSSRTPHandle s_pRTPHandle)
{
    srand((unsigned)time(NULL));
    s_pRTPHandle->m_un32ssrc = rand();
    s_pRTPHandle->m_un32ssrc += rand();
    return  SS_SUCCESS;
}*/
SS_SHORT RTP_SuctPacket(
    IN  PSSRTPHandle s_pRTPHandle,
    IN  SS_CHAR const*const psInBuf,
    IN  SS_UINT32     const un32InLen,
    OUT PSS_CHAR            psOutBuf,
    OUT SS_UINT32           *pun32OutLen)
{
    SS_BYTE ub1=0,ub2=0,ub3=0,ub4=0;
    if (NULL==s_pRTPHandle||NULL==psInBuf||NULL==psOutBuf||NULL==pun32OutLen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,RTPHandle=%p,InBuf=%p,psOutBuf=%p,"
            "pun32OutLen=%p",s_pRTPHandle,psInBuf,psOutBuf,pun32OutLen);
#endif
        return SS_ERR_PARAM;
    }

    s_pRTPHandle->m_usnSequenceNumber++;
    if (s_pRTPHandle->m_usnSequenceNumber >= 65535)
    {
        s_pRTPHandle->m_usnSequenceNumber = 0;
    }
    s_pRTPHandle->m_s_RTPData.m_usnseq  = s_pRTPHandle->m_usnSequenceNumber;
    s_pRTPHandle->m_s_RTPData.m_un32ts  = s_pRTPHandle->m_un32ts;

    *(SS_BYTE*)(psOutBuf) = 0x80;
    *(SS_BYTE*)(psOutBuf+1) = (s_pRTPHandle->m_s_RTPData.m_m)?0x80:0x00 + s_pRTPHandle->m_s_RTPData.m_pt;
    SS_ShortToByte(s_pRTPHandle->m_s_RTPData.m_usnseq,ub1,ub2);
    *(SS_BYTE*)(psOutBuf+2) = ub1;
    *(SS_BYTE*)(psOutBuf+3) = ub2;
    SS_uintToByte(s_pRTPHandle->m_s_RTPData.m_un32ts,ub1,ub2,ub3,ub4);
    *(SS_BYTE*)(psOutBuf+4) = ub4;
    *(SS_BYTE*)(psOutBuf+5) = ub3;
    *(SS_BYTE*)(psOutBuf+6) = ub2;
    *(SS_BYTE*)(psOutBuf+7) = ub1;
    SS_uintToByte(s_pRTPHandle->m_s_RTPData.m_un32ssrc,ub1,ub2,ub3,ub4);
    *(SS_BYTE*)(psOutBuf+8) = ub4;
    *(SS_BYTE*)(psOutBuf+9) = ub3;
    *(SS_BYTE*)(psOutBuf+10) = ub2;
    *(SS_BYTE*)(psOutBuf+11) = ub1;
    memcpy((psOutBuf+12),psInBuf,un32InLen);
    *pun32OutLen = 12+un32InLen;
    return  SS_SUCCESS;
}
SS_SHORT RTP_ParsePacket(
    IN  PSSRTPHandle s_pRTPHandle,
    IN  SS_CHAR const*const psInBuf,
    IN  SS_UINT32      const un32InLen,
    OUT SSRTPData      *s_RTPData,
    OUT PSS_CHAR     psOutBuf,
    OUT SS_UINT32    *pun32OutLen)
{
    if (NULL==s_pRTPHandle||NULL==psInBuf||NULL==psOutBuf||NULL==pun32OutLen)
    {
#ifdef  IT_LIB_DEBUG
        SS_Log_Printf(SS_ERROR_LOG,"param error,RTPHandle=%p,InBuf=%p,psOutBuf=%p,"
            "pun32OutLen=%p",s_pRTPHandle,psInBuf,psOutBuf,pun32OutLen);
#endif
        return SS_ERR_PARAM;
    }
    *pun32OutLen = un32InLen-sizeof(SSRTPData);
    memcpy(&s_RTPData,psInBuf,sizeof(SSRTPData));
    memcpy(psOutBuf,(psInBuf+sizeof(SSRTPData)),*pun32OutLen);
    return  SS_SUCCESS;
}
/*SS_SHORT RTP_SetPayload(IN PSSRTPHandle s_pRTPHandle,SS_BYTE const ubPayload)
{
    s_pRTPHandle->m_s_RTPHandle.m_pt = ubPayload;
    return  SS_SUCCESS;
}*/
/*SS_SHORT RTP_Reset(IN PSSRTPHandle s_pRTPHandle)
{
    RTP_CreateSynchronizationSource(s_pRTPHandle);
    s_pRTPHandle->m_s_RTPHandle.m_un32ssrc= s_pRTPHandle->m_un32ssrc;
    return  SS_SUCCESS;
}*/
/*SS_SHORT RTP_UpdateTimeStamp(IN PSSRTPHandle s_pRTPHandle,IN PSSRTPHandle s_pRTPHandle)
{
    if (SS_TRUE == s_pRTPHandle->m_ubTimeStampFlag)
    {
        SS_GET_NONCE_DATETIME(s_pRTPHandle->m_s_StampFlag1);
        s_pRTPHandle->m_ubTimeStampFlag = SS_FALSE;
    }
    else
    {
        SS_GET_NONCE_DATETIME(s_pRTPHandle->m_s_StampFlag2);
        s_pRTPHandle->m_ubTimeStampFlag = SS_TRUE;
    }
    return  SS_SUCCESS;
}*/
/*SS_SHORT RTP_SetTimeStamp(IN PSSRTPHandle s_pRTPHandle,IN SS_USHORT const usnTimeStamp)
{
    s_pRTPHandle->m_un32ts += usnTimeStamp;
    return  SS_SUCCESS;
}*/




