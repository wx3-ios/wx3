// it_lib_audio.h: interface for the CITLibAudio class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_IT_LIB_AUDIO_H__0ADAB5DD_F0E1_492A_AC99_33FC4104F3A1__INCLUDED_)
#define AFX_IT_LIB_AUDIO_H__0ADAB5DD_F0E1_492A_AC99_33FC4104F3A1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000





typedef void (* IT_WaveRecordData)(
    char const*pBuffer,
    int const n32Len,
    void *pContext);

//Windows 录音和放音
#if defined(_MSC_VER)

#define WINWAVE_WOSA_POOR    8000
#define WINWAVE_WOSA_LOW    11025
#define WINWAVE_WOSA_NORMAL    22050
#define WINWAVE_WOSA_HIGH    44100

#define WINWAVE_PLAY_DELAY 10


class CWavePlay  
{
public:
    static DWORD WINAPI AudioOutThreadProc(LPVOID lpParameter);
public:
    short SetFormatByFile(CString file);
    short Play(IN char const* buf,UINT uSize);

    short StartPlay();
    short StopPlay();    

    inline int GetBufferNum();
    inline void BufferSub();
    inline void BufferAdd();

    inline DWORD GetInstance();
    inline WORD GetBit();
    inline DWORD GetSample();
    inline WORD GetChannel();

    inline void SetBit(WORD wBit);
    inline void SetSample(DWORD dwSample);
    inline void SetChannel(WORD wChannel);

    inline MMRESULT GetLastMMError();
    CString GetLastErrorString();
public:
    CWavePlay();
    virtual ~CWavePlay();
protected:
    short OpenDev();
    short CloseDev();

    short StopThread();
    short StartThread();
protected:
    static DWORD s_dwInstance;
protected:
    WORD m_wChannel;
    DWORD m_dwSample;
    WORD m_wBit;
protected:
    MMRESULT m_mmr;
    HWAVEOUT m_hOut;
    HANDLE m_hAudioOut;
    DWORD m_dwAudioOutId;

    int m_iBufferNum;
    CCriticalSection m_csLock;

    BOOL m_bThreadStart;
    BOOL m_bDevOpen;
};



#define WINWAVE_WISA_POOR    8000
#define WINWAVE_WISA_LOW    11025
#define WINWAVE_WISA_NORMAL    22050
#define WINWAVE_WISA_HIGH    44100

#define WINWAVE_NUM_BUF 10
#define WINWAVE_SIZE_AUDIO_FRAME 960
#define WINWAVE_SIZE_AUDIO_PACKED 60


class CWaveRecord  
{
public:    
    virtual void ProcessData(
        char * pBuffer,
        int const iLen,
        void *pContext)=0;
public:
    SS_SHORT Run(LPVOID lpParameter);
public:
    SS_SHORT SetCallBack(IN SS_VOID* pCallBack,void *pContext);
    SS_SHORT StartRecord();
    SS_SHORT StopRecord();

    //SS_TRUE 录音运行中  SS_FALSE 录音没有运行
    SS_SHORT GetRecordStatus();

    inline DWORD GetInstance();
    inline WORD  GetBit();
    inline DWORD GetSample();
    inline WORD  GetChannel();

    inline void  SetBit(WORD wBit);
    inline void  SetSample(DWORD dwSample);
    inline void  SetChannel(WORD wChannel);

    inline MMRESULT GetLastMMError();
    CString GetLastErrorString();
public:
    CWaveRecord();
    virtual ~CWaveRecord();
protected:
    SS_SHORT OpenDev();
    SS_SHORT CloseDev();

    SS_SHORT StopThread();
    SS_SHORT StartThread();

    SS_SHORT PerPareBuffer();
    SS_SHORT FreeBuffer();

    SS_SHORT OpenRecord();
    SS_SHORT CloseRecord();
protected:
    static DWORD s_dwInstance;
protected:
    WORD m_wChannel;
    DWORD m_dwSample;
    WORD m_wBit;
    IT_WaveRecordData m_CallBake;
    void *m_pContext ;
protected:
    HWAVEIN m_hIn;
    MMRESULT m_mmr;
    DWORD m_dwAudioInId;
    HANDLE m_hAudioIn;
    WAVEHDR* m_pHdr;

    BOOL m_bThreadStart;
    BOOL m_bDevOpen;
    BOOL m_bAllocBuffer;
    BOOL m_bRecord;
};


class CWaveRecordEx  :  public  CWaveRecord
{
public:    
    virtual void ProcessData(
        char * pBuffer,
        int const iLen,
        void *pContext);
public:

public:
    CWaveRecordEx();
    virtual ~CWaveRecordEx();
protected:
};


class IT_API  CSpeakerTest  :  public  CWaveRecord
{
public:    

    SS_SHORT    TestG729_a(char * pBuffer,int const iLen);
    SS_SHORT    TestG726_16(char * pBuffer,int const iLen);
    SS_SHORT    TestG726_24(char * pBuffer,int const iLen);
    SS_SHORT    TestG726_32(char * pBuffer,int const iLen);
    SS_SHORT    TestG726_40(char * pBuffer,int const iLen);
    SS_SHORT    TestADPCM(char * pBuffer,int const iLen);
    SS_SHORT    TestG722(char * pBuffer,int const iLen);
    SS_SHORT    TestG723(char * pBuffer,int const iLen);
    SS_SHORT    TestG723_40(char * pBuffer,int const iLen);
    SS_SHORT    TestG723_24(char * pBuffer,int const iLen);
    SS_SHORT    TestG721(char * pBuffer,int const iLen);
    SS_SHORT    TestLPC10(char * pBuffer,int const iLen);
    SS_SHORT    TestLPC(char * pBuffer,int const iLen);
    SS_SHORT    TestSpeex(char * pBuffer,int const iLen);
    SS_SHORT    TestiLBC13(char * pBuffer,int const iLen);
    SS_SHORT    TestiLBC15(char * pBuffer,int const iLen);
    SS_SHORT    TestGSM(char * pBuffer,int const iLen);
    SS_SHORT    TestAlaw64k(char * pBuffer,int const iLen);
    SS_SHORT    TestUlaw64k(char * pBuffer,int const iLen);

public:    
    SS_SHORT    InitSpeaker();
    SS_SHORT    FreeSpeaker();
    virtual void ProcessData(
        char * pBuffer,
        int const iLen,
        void *pContext);
    //gsm         s_gsm;
    //lpc10_encoder_state  m_s_lpc10_encoder_state;
    //lpc10_decoder_state  m_s_lpc10_decoder_state;
    // 
    //g722_encode_state_t  m_s_g722_encode_state_t;
    //g722_decode_state_t  m_s_g722_decode_state_t;
    // 
    // 
    //     g726_state           m_s_g726_state_16;
    //     g726_state           m_s_g726_state_24;
    //     g726_state           m_s_g726_state_32;
    //     g726_state           m_s_g726_state_40;
public:

public:
    CSpeakerTest();
    virtual ~CSpeakerTest();
protected:

//    iLBC_Enc_Inst_t  g_m_audio_s_EiLBC_Inst_t_13;
//    iLBC_Dec_Inst_t  g_m_audio_s_DiLBC_Inst_t_13;
//    iLBC_Enc_Inst_t  g_m_audio_s_EiLBC_Inst_t_15;
//    iLBC_Dec_Inst_t  g_m_audio_s_DiLBC_Inst_t_15;
protected:
    CWavePlay m_c_play;
protected:

protected:

};

//Linux 录音和放音
#elif defined(__GNUC__)


#else

#  error "Unknown compiler."

#endif


#ifdef __cplusplus
extern "C" 
{
#endif
    IT_API SS_SHORT  IT_StartWaveRecord(IN IT_WaveRecordData f_WaveRecordData,IN void *pContext);
    IT_API SS_SHORT  IT_StartWavePlay  ();
    IT_API SS_SHORT  IT_WavePlay  (IN char const* buf,IN SS_UINT32 un32Size);
    IT_API SS_SHORT  IT_StopWaveRecord();
    IT_API SS_SHORT  IT_StopWavePlay  ();

#ifdef __cplusplus
}  /* end extern "C" */
#endif






//////////////////////////////////////////////////////////////////////////

/*
reference document : RFC 1889


0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|V=2|P|X|  CC   |M|     PT      |       sequence number         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           timestamp                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           synchronization source (SSRC) identifier            |
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
|            contributing source (CSRC) identifiers             |
|                             ....                              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/
   /*
    * Current protocol version.
    */
   #define RTP_VERSION    2

   #define RTP_SEQ_MOD (1<<16)
   #define RTP_MAX_SDES 255      /* maximum text length for SDES */

//////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////

#define   SS_RTP_GET_PAYLOAD(_RTPPackage_) (SS_BYTE)*((_RTPPackage_)+1)


typedef struct SSRTPData
{
    unsigned int m_Version:2;   /* protocol version */
    unsigned int m_p:1;         /* padding flag */
    unsigned int m_x:1;         /* header extension flag */
    unsigned int m_cc:4;        /* CSRC count */
    unsigned int m_m:1;         /* marker bit */
    unsigned int m_pt:7;        /* payload type */
    unsigned short m_usnseq;    /* sequence number */
    unsigned int m_un32ts;      /* timestamp */
    unsigned int m_un32ssrc;    /* synchronization source */
}SSRTPData,*PSSRTPData;

typedef struct SSRTPHandle
{
    SS_USHORT m_usnSequenceNumber;
    SS_UINT32 m_un32ts;
    SS_UINT32 m_un32ssrc;
    SSRTPData m_s_RTPData;
    SS_BYTE   m_ubTimeStampFlag;
    SS_Timeval m_s_StampFlag1;
    SS_Timeval m_s_StampFlag2;
}SSRTPHandle,*PSSRTPHandle;






#define SS_AUDIO_CODEC_ALAW       0x1                 //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_ULAW       0x2                 //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_G729       0x4                 //1<<2
#define SS_AUDIO_CODEC_G729A      0x8                 //1<<3
#define SS_AUDIO_CODEC_G729B      0x10                //1<<4
#define SS_AUDIO_CODEC_G729AB     0x20                //1<<5
#define SS_AUDIO_CODEC_G723_63    0x40                //1<<6 6.3kps
#define SS_AUDIO_CODEC_G723_53    0x80                //1<<7 5.3kps
#define SS_AUDIO_CODEC_CELT_32    0x100               //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_CODEC_CELT_48    0x200               //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_CODEC_ILBC_30    0x400               //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_CODEC_ILBC_20    0x800               //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_CODEC_G722_16    0x1000              //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_G7221_16   0x2000              //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_CODEC_G7221_32   0x4000              //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_CODEC_G726_16    0x8000              //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_G726_24    0x10000             //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_G726_32    0x20000             //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_G726_40    0x40000             //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_DVI4_8     0x80000             //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_DVI4_16    0x100000            //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_CODEC_SPEEX_8    0x200000            //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_CODEC_SPEEX_16   0x400000            //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_CODEC_SPEEX_32   0x800000            //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_CODEC_BV16       0x1000000           //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_CODEC_BV32       0x2000000           //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_CODEC_GSM        0x4000000           //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_CODEC_LPC        0x8000000           //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_CODEC_L16        0x10000000          //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_CODEC_AMR        0x20000000          //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_CODEC_G728       0x40000000          //1<<30
#define SS_AUDIO_CODEC_SILK_8     0x80000000          //1<<31 8kHz
#define SS_AUDIO_CODEC_SILK_12    0x100000000         //1<<32 12kHz
#define SS_AUDIO_CODEC_SILK_16    0x200000000         //1<<33 16kHz
#define SS_AUDIO_CODEC_SILK_24    0x400000000         //1<<34 24kHz
#define SS_AUDIO_CODEC_SPEEX_FEC_8 0x800000000        //1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_CODEC_SPEEX_FEC_16 0x1000000000      //1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_CODEC_BV32_FEC   0x2000000000        //1<<37 a=rtpmap:119 BV32-FEC/16000

/*
#define SS_AUDIO_CODEC_ 0x4000000000        //1<<38
#define SS_AUDIO_CODEC_ 0x8000000000        //1<<39
#define SS_AUDIO_CODEC_ 0x10000000000       //1<<40
#define SS_AUDIO_CODEC_ 0x20000000000       //1<<41
#define SS_AUDIO_CODEC_ 0x40000000000       //1<<42
#define SS_AUDIO_CODEC_ 0x80000000000       //1<<43
#define SS_AUDIO_CODEC_ 0x100000000000      //1<<44
#define SS_AUDIO_CODEC_ 0x200000000000      //1<<45
#define SS_AUDIO_CODEC_ 0x400000000000      //1<<46
#define SS_AUDIO_CODEC_ 0x800000000000      //1<<47
#define SS_AUDIO_CODEC_ 0x1000000000000     //1<<48
#define SS_AUDIO_CODEC_ 0x2000000000000     //1<<49
#define SS_AUDIO_CODEC_ 0x4000000000000     //1<<50
#define SS_AUDIO_CODEC_ 0x8000000000000     //1<<51
#define SS_AUDIO_CODEC_ 0x10000000000000    //1<<52
#define SS_AUDIO_CODEC_ 0x20000000000000    //1<<53
#define SS_AUDIO_CODEC_ 0x40000000000000    //1<<54
#define SS_AUDIO_CODEC_ 0x80000000000000    //1<<55
#define SS_AUDIO_CODEC_ 0x100000000000000   //1<<56
#define SS_AUDIO_CODEC_ 0x200000000000000   //1<<57
#define SS_AUDIO_CODEC_ 0x400000000000000   //1<<58
#define SS_AUDIO_CODEC_ 0x800000000000000   //1<<59
#define SS_AUDIO_CODEC_ 0x1000000000000000  //1<<60
#define SS_AUDIO_CODEC_ 0x2000000000000000  //1<<61
#define SS_AUDIO_CODEC_ 0x4000000000000000  //1<<62
*/
#define SS_AUDIO_CODEC_TELEPHONE_EVENT 0x8000000000000000  //1<<63   101



//AAL2-G726-16     - Same as G726-16 but using AAL2 packing. (multiples of 10)
//AAL2-G726-24     - Same as G726-24 but using AAL2 packing. (multiples of 10)
//AAL2-G726-32     - Same as G726-32 but using AAL2 packing. (multiples of 10)
//AAL2-G726-40     - Same as G726-40 but using AAL2 packing. (multiples of 10)


#define SS_AUDIO_UNMBER_ALAW     1   //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_ULAW     2   //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_G729     3   //1<<2
#define SS_AUDIO_UNMBER_G729A    4   //1<<3
#define SS_AUDIO_UNMBER_G729B    5   //1<<4
#define SS_AUDIO_UNMBER_G729AB   6   //1<<5
#define SS_AUDIO_UNMBER_G723_63  7   //1<<6 6.3kps
#define SS_AUDIO_UNMBER_G723_53  8   //1<<7 5.3kps
#define SS_AUDIO_UNMBER_CELT_32  9   //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_UNMBER_CELT_48  10  //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_UNMBER_ILBC_30  11  //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_UNMBER_ILBC_20  12  //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_UNMBER_G722_16  13  //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_G7221_16 14  //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_UNMBER_G7221_32 15  //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_UNMBER_G726_16  16  //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_G726_24  17  //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_G726_32  18  //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_G726_40  19  //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_DVI4_8   20  //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_DVI4_16  21  //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_UNMBER_SPEEX_8  22  //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_UNMBER_SPEEX_16 23  //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_UNMBER_SPEEX_32 24  //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_UNMBER_BV16     25  //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_UNMBER_BV32     26  //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_UNMBER_GSM      27  //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_UNMBER_LPC      28  //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_UNMBER_L16      29  //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_UNMBER_AMR      30  //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_UNMBER_G728     31  //1<<30
#define SS_AUDIO_UNMBER_SILK_8   32  //1<<31 8kHz
#define SS_AUDIO_UNMBER_SILK_12  33  //1<<32 12kHz
#define SS_AUDIO_UNMBER_SILK_16  34  //1<<33 16kHz
#define SS_AUDIO_UNMBER_SILK_24  35  //1<<34 24kHz
#define SS_AUDIO_UNMBER_SPEEX_FEC_8 36//1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_UNMBER_SPEEX_FEC_16 37//1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_UNMBER_BV32_FEC  38 //1<<37 a=rtpmap:119 BV32-FEC/16000

#define SS_AUDIO_UNMBER_TELEPHONE_EVENT 63  //1<<63   101


#define SS_AUDIO_STR_ALAW     "PCMA"   //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_ULAW     "PCMU"   //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_G729     "G729"   //1<<2
#define SS_AUDIO_STR_G729A    "G729"   //1<<3
#define SS_AUDIO_STR_G729B    "G729"   //1<<4
#define SS_AUDIO_STR_G729AB   "G729"   //1<<5
#define SS_AUDIO_STR_G723_63  "G723"   //1<<6 6.3kps
#define SS_AUDIO_STR_G723_53  "G723"   //1<<7 5.3kps
#define SS_AUDIO_STR_CELT_32  "CELT"   //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_STR_CELT_48  "CELT"   //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_STR_ILBC_30  "iLBC"   //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_STR_ILBC_20  "iLBC"   //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_STR_G722_16  "G722"   //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_G7221_16 "G7221"   //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_STR_G7221_32 "G7221"   //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_STR_G726_16  "G726"   //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_G726_24  "G726"   //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_G726_32  "G726"   //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_G726_40  "G726"   //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_DVI4_8   "DVI4"   //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_STR_DVI4_16  "DVI4"   //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_STR_SPEEX_8  "SPEEX"  //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_STR_SPEEX_16 "SPEEX"  //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_STR_SPEEX_32 "SPEEX"  //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_STR_BV16     "BV16"   //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_STR_BV32     "BV32"   //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_STR_GSM      "GSM"    //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_STR_LPC      "LPC10"  //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_STR_L16      "L16"    //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_STR_AMR      "AMR"    //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_STR_G728     "G728"   //1<<30
#define SS_AUDIO_STR_SILK_8   "SILK"   //1<<31 8kHz
#define SS_AUDIO_STR_SILK_12  "SILK"   //1<<32 12kHz
#define SS_AUDIO_STR_SILK_16  "SILK"   //1<<33 16kHz
#define SS_AUDIO_STR_SILK_24  "SILK"   //1<<34 24kHz
#define SS_AUDIO_STR_SPEEX_FEC_8 "SPEEX-FEC" //1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_STR_SPEEX_FEC_16 "SPEEX-FEC" //1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_STR_BV32_FEC   "BV32-FEC" //1<<37 a=rtpmap:119 BV32-FEC/16000
#define SS_AUDIO_STR_TELEPHONE_EVENT "telephone-event"   //1<<63   101

#define SS_AUDIO_RATE_ALAW     8000   //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_ULAW     8000   //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_G729     8000   //1<<2
#define SS_AUDIO_RATE_G729A    8000   //1<<3
#define SS_AUDIO_RATE_G729B    8000   //1<<4
#define SS_AUDIO_RATE_G729AB   8000   //1<<5
#define SS_AUDIO_RATE_G723_63  8000   //1<<6 6.3kps
#define SS_AUDIO_RATE_G723_53  8000   //1<<7 5.3kps
#define SS_AUDIO_RATE_CELT_32  8000   //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_RATE_CELT_48  8000   //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_RATE_ILBC_30  8000   //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_RATE_ILBC_20  8000   //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_RATE_G722_16  16000  //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_G7221_16 16000  //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_RATE_G7221_32 32000  //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_RATE_G726_16  8000   //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_G726_24  8000   //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_G726_32  8000   //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_G726_40  8000   //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_DVI4_8   8000   //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_DVI4_16  16000   //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_SPEEX_8  8000   //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_RATE_SPEEX_16 16000  //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_RATE_SPEEX_32 32000  //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_RATE_BV16     16000  //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_RATE_BV32     32000  //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_RATE_GSM      8000   //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_RATE_LPC      8000   //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_RATE_L16      8000   //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_RATE_AMR      8000   //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_RATE_G728     8000   //1<<30
#define SS_AUDIO_RATE_SILK_8   8000   //1<<31 8kHz
#define SS_AUDIO_RATE_SILK_12  8000   //1<<32 12kHz
#define SS_AUDIO_RATE_SILK_16  8000   //1<<33 16kHz
#define SS_AUDIO_RATE_SILK_24  8000   //1<<34 24kHz
#define SS_AUDIO_RATE_SPEEX_FEC_8 8000 //1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_RATE_SPEEX_FEC_16 16000 //1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_RATE_BV32_FEC   16000 //1<<37 a=rtpmap:119 BV32-FEC/16000

#define SS_AUDIO_RATE_TELEPHONE_EVENT 8000   //1<<63   101

#define SS_AUDIO_RATE_STR_ALAW     "8000"   //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_ULAW     "8000"   //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_G729     "8000"   //1<<2
#define SS_AUDIO_RATE_STR_G729A    "8000"   //1<<3
#define SS_AUDIO_RATE_STR_G729B    "8000"   //1<<4
#define SS_AUDIO_RATE_STR_G729AB   "8000"   //1<<5
#define SS_AUDIO_RATE_STR_G723_63  "8000"   //1<<6 6.3kps
#define SS_AUDIO_RATE_STR_G723_53  "8000"   //1<<7 5.3kps
#define SS_AUDIO_RATE_STR_CELT_32  "8000"   //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_RATE_STR_CELT_48  "8000"   //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_RATE_STR_ILBC_30  "8000"   //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_RATE_STR_ILBC_20  "8000"   //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_RATE_STR_G722_16  "16000"  //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_G7221_16 "16000"  //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_RATE_STR_G7221_32 "32000"  //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_RATE_STR_G726_16  "8000"   //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_G726_24  "8000"   //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_G726_32  "8000"   //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_G726_40  "8000"   //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_DVI4_8   "8000"   //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_DVI4_16  "16000"   //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_RATE_STR_SPEEX_8  "8000"   //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_RATE_STR_SPEEX_16 "16000"  //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_RATE_STR_SPEEX_32 "32000"  //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_RATE_STR_BV16     "16000"  //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_RATE_STR_BV32     "16000"  //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_RATE_STR_GSM      "8000"   //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_RATE_STR_LPC      "8000"   //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_RATE_STR_L16      "8000"   //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_RATE_STR_AMR      "8000"   //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_RATE_STR_G728     "8000"   //1<<30
#define SS_AUDIO_RATE_STR_SILK_8   "8000"   //1<<31 8kHz
#define SS_AUDIO_RATE_STR_SILK_12  "8000"   //1<<32 12kHz
#define SS_AUDIO_RATE_STR_SILK_16  "8000"   //1<<33 16kHz
#define SS_AUDIO_RATE_STR_SILK_24  "8000"   //1<<34 24kHz
#define SS_AUDIO_RATE_STR_SPEEX_FEC_8 "8000" //1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_RATE_STR_SPEEX_FEC_16 "16000" //1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_RATE_STR_BV32_FEC   "16000" //1<<37 a=rtpmap:119 BV32-FEC/16000
#define SS_AUDIO_RATE_STR_TELEPHONE_EVENT "8000"   //1<<63   101


#define SS_AUDIO_PT_ALAW     8   //1<<0 G711 8kHz alaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_ULAW     0   //1<<1 G711 8kHz ulaw using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_G729     18   //1<<2
#define SS_AUDIO_PT_G729A    18   //1<<3
#define SS_AUDIO_PT_G729B    18   //1<<4
#define SS_AUDIO_PT_G729AB   18   //1<<5
#define SS_AUDIO_PT_G723_63  4   //1<<6 6.3kps
#define SS_AUDIO_PT_G723_53  4   //1<<7 5.3kps
#define SS_AUDIO_PT_CELT_32  50   //1<<8 CELT 32kHz, only 10ms supported
#define SS_AUDIO_PT_CELT_48  51   //1<<9 CELT 48kHz, only 10ms supported
#define SS_AUDIO_PT_ILBC_30  97   //1<<10 iLBC using mode=30 which will win in all cases. 13.3kps
#define SS_AUDIO_PT_ILBC_20  98   //1<<11 iLBC using mode=20 which will win in all cases. 15.5kps
#define SS_AUDIO_PT_G722_16  9  //1<<12 G722 16kHz using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_G7221_16 52  //1<<13 G722.1 16kHz (aka Siren 7)
#define SS_AUDIO_PT_G7221_32 53  //1<<14 G722.1C 32kHz (aka Siren 14)
#define SS_AUDIO_PT_G726_16  54   //1<<15 G726 16kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_G726_24  55  //1<<16 G726 24kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_G726_32  56  //1<<17 G726 32kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_G726_40  57  //1<<18 G726 40kbit adpcm using default 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_DVI4_8   58  //1<<19 IMA ADPCM 8kHz using 20ms ptime. (multiples of 10)
#define SS_AUDIO_PT_DVI4_16  59  //1<<20 IMA ADPCM 16kHz using 40ms ptime. (multiples of 10)
#define SS_AUDIO_PT_SPEEX_8  60  //1<<21 Speex 8kHz using 20ms ptime.
#define SS_AUDIO_PT_SPEEX_16 61  //1<<22 Speex 16kHz using 20ms ptime.
#define SS_AUDIO_PT_SPEEX_32 62  //1<<23 Speex 32kHz using 20ms ptime.
#define SS_AUDIO_PT_BV16     63  //1<<24 BroadVoice 16kb/s narrowband, 8kHz
#define SS_AUDIO_PT_BV32     64  //1<<25 BroadVoice 32kb/s wideband, 16kHz
#define SS_AUDIO_PT_GSM      65  //1<<26 GSM 8kHz using 40ms ptime. (GSM is done in multiples of 20, Default is 20ms)
#define SS_AUDIO_PT_LPC      66  //1<<27 LPC10 using 90ms ptime (only supports 90ms at this time in FreeSWITCH)
#define SS_AUDIO_PT_L16      67  //1<<28 L16 isn't recommended for VoIP but you can do it. L16 can exceed the MTU rather quickly.
#define SS_AUDIO_PT_AMR      68  //1<<29 AMR in passthru mode. (mod_amr)
#define SS_AUDIO_PT_G728     69  //1<<30
#define SS_AUDIO_PT_SILK_8   70  //1<<31 8kHz
#define SS_AUDIO_PT_SILK_12  71  //1<<32 12kHz
#define SS_AUDIO_PT_SILK_16  72  //1<<33 16kHz
#define SS_AUDIO_PT_SILK_24  73  //1<<34 24kHz
#define SS_AUDIO_PT_SPEEX_FEC_8 74 //1<<35 a=rtpmap:105 SPEEX-FEC/8000
#define SS_AUDIO_PT_SPEEX_FEC_16 75 //1<<36 a=rtpmap:106 SPEEX-FEC/16000
#define SS_AUDIO_PT_BV32_FEC    76 //1<<37 a=rtpmap:119 BV32-FEC/16000
#define SS_AUDIO_PT_TELEPHONE_EVENT 101   //1<<63   101

typedef struct SS_Audio
{
    SS_UINT64   m_un64Audio;
    
    SS_BYTE     m_ubAlaw_PT;//payload type ID
    SS_UINT32   m_un32AlawRate;
    
    SS_BYTE     m_ubUlaw_PT;//payload type ID
    SS_UINT32   m_un32UlawRate;
    
    SS_BYTE     m_ubG729_PT;//payload type ID
    SS_UINT32   m_un32G729Rate;
    SS_BYTE     m_ubG729Mode;//g729a  g729b  g729ab
    
    SS_BYTE     m_ubG723_PT;//payload type ID
    SS_UINT32   m_un32G723Rate;
    SS_BYTE     m_ubG723Mode;//模式 6.3kbit/s  5.3kbit/s
    
    SS_BYTE     m_ubCELT_PT;//payload type ID
    SS_UINT32   m_un32CELTRate;
    SS_BYTE     m_ubCELTMode;
    
    SS_BYTE     m_ubiLBC_PT;//payload type ID
    SS_UINT32   m_un32iLBCRate;
    SS_BYTE     m_ubiLBCMode;//模式 20==20ms   30==30ms
    
    SS_BYTE     m_ubG722_PT;//payload type ID
    SS_UINT32   m_un32G722Rate;
    
    SS_BYTE     m_ubG7221_PT;//payload type ID
    SS_UINT32   m_un32G7221Rate;
    
    SS_BYTE     m_ubG726_16_PT;//payload type ID
    SS_UINT32   m_un32G726_16Rate;
    
    SS_BYTE     m_ubG726_24_PT;//payload type ID
    SS_UINT32   m_un32G726_24Rate;
    
    SS_BYTE     m_ubG726_32_PT;//payload type ID
    SS_UINT32   m_un32G726_32Rate;
    
    SS_BYTE     m_ubG726_40_PT;//payload type ID
    SS_UINT32   m_un32G726_40Rate;
    
    SS_BYTE     m_ubDVI4_PT;//payload type ID
    SS_UINT32   m_un32DVI4Rate;
    
    SS_BYTE     m_ubSpeex_8PT;//payload type ID
    SS_UINT32   m_un32Speex_8Rate;
    
    SS_BYTE     m_ubSpeex_16PT;//payload type ID
    SS_UINT32   m_un32Speex_16Rate;

    SS_BYTE     m_ubSpeex_32PT;//payload type ID
    SS_UINT32   m_un32Speex_32Rate;

    SS_BYTE     m_ubGSM_PT;//payload type ID
    SS_UINT32   m_un32GSMRate;
    
    SS_BYTE     m_ubLPC_PT;//payload type ID
    SS_UINT32   m_un32LPCRate; 
    
    SS_BYTE     m_ubL16_PT;//payload type ID
    SS_UINT32   m_un32L16Rate; 
    
    SS_BYTE     m_ubAMR_PT;//payload type ID
    SS_UINT32   m_un32AMRRate; 
    
    SS_BYTE     m_ubG728_PT;//payload type ID
    SS_UINT32   m_un32G728Rate; 
    
    SS_BYTE     m_ubSILK_8_PT;//payload type ID
    SS_UINT32   m_un32SILK_8Rate;
    
    SS_BYTE     m_ubSILK_12_PT;//payload type ID
    SS_UINT32   m_un32SILK_12Rate;
    
    SS_BYTE     m_ubSILK_16_PT;//payload type ID
    SS_UINT32   m_un32SILK_16Rate;
    
    SS_BYTE     m_ubSILK_24_PT;//payload type ID
    SS_UINT32   m_un32SILK_24Rate;
    
    SS_BYTE     m_ubTelephoneEvent_PT;//payload type ID
    SS_UINT32   m_un32TelephoneEventRate;

    SS_BYTE     m_ubBV16_PT;
    SS_USHORT   m_usnBV16Rate;

    SS_BYTE     m_ubBV32_PT;
    SS_USHORT   m_usnBV32Rate;


    SS_BYTE     m_ubBV32FEC_PT;
    SS_USHORT   m_usnBV32FECRate;

    SS_BYTE     m_ubSpeexFEC_8PT;//payload type ID
    SS_UINT32   m_un32SpeexFEC_8Rate;

    SS_BYTE     m_ubSpeexFEC_16PT;//payload type ID
    SS_UINT32   m_un32SpeexFEC_16Rate;

    SS_SDPDirection m_eSDPDirection;
/*

    SS_BYTE     m_ubBV32_FEC;
    SS_USHORT   m_usnBV32_FECRate;

    SS_BYTE     m_ubSPEEX;
    SS_USHORT   m_usnSPEEXRate;

    SS_BYTE     m_ubSPEEX_FEC_16000;
    SS_USHORT   m_usnSPEEX_FECRate_16000;

    SS_BYTE     m_ubSPEEX_FEC_8000;
    SS_USHORT   m_usnSPEEX_FECRate_8000;
*/
}SS_Audio,*PSS_Audio;

typedef struct SS_Video
{
    SS_UINT32   m_un32Video;
    SS_BYTE     m_ubH261;
    SS_BYTE     m_ubH263;
    SS_BYTE     m_ubH263_1998;
    SS_BYTE     m_ubH263_2000;
    SS_BYTE     m_ubH264;
    SS_BYTE     m_ubH265;
    SS_BYTE     m_ubMPEG4;
    SS_SDPDirection m_eSDPDirection;
}SS_Video,*PSS_Video;


#define SS_VIDEO_CODEC_H261          (1<<0) //H.261 Video
#define SS_VIDEO_CODEC_H263          (1<<1) //H.263 Video
#define SS_VIDEO_CODEC_H263_1998     (1<<2) //H.263-1998 Video
#define SS_VIDEO_CODEC_H263_2000     (1<<3) //H.263-2000 Video
#define SS_VIDEO_CODEC_H264          (1<<4) //H.264 Video
#define SS_VIDEO_CODEC_H265          (1<<5) //H.265 Video
#define SS_VIDEO_CODEC_MPEG4         (1<<6) //


#define SS_VIDEO_STR_H261             "H261"
#define SS_VIDEO_STR_H263             "H263"
#define SS_VIDEO_STR_H263_1998        "H263-1998"
#define SS_VIDEO_STR_H263_2000        "H263-2000"
#define SS_VIDEO_STR_H264             "H264"
#define SS_VIDEO_STR_H265             "H265"
#define SS_VIDEO_STR_MPEG4            "MPEG4"


#define SS_VIDEO_UNMBER_H263          (1)
#define SS_VIDEO_UNMBER_H263_1998     (2)
#define SS_VIDEO_UNMBER_H263_2000     (3)
#define SS_VIDEO_UNMBER_H264          (4)
#define SS_VIDEO_UNMBER_H265          (5)
#define SS_VIDEO_UNMBER_MPEG4         (6)
#define SS_VIDEO_UNMBER_H261          (7)


#define SS_VIDEO_PT_H261          (100)
#define SS_VIDEO_PT_H263          (101)
#define SS_VIDEO_PT_H263_1998     (102)
#define SS_VIDEO_PT_H263_2000     (103)
#define SS_VIDEO_PT_H264          (104)
#define SS_VIDEO_PT_H265          (105)
#define SS_VIDEO_PT_MPEG4         (106)


#define SS_VIDEO_RATE_H261          (90000)
#define SS_VIDEO_RATE_H263          (90000)
#define SS_VIDEO_RATE_H263_1998     (90000)
#define SS_VIDEO_RATE_H263_2000     (90000)
#define SS_VIDEO_RATE_H264          (90000)
#define SS_VIDEO_RATE_H265          (90000)
#define SS_VIDEO_RATE_MPEG4         (90000)



SS_SHORT RTP_InitRFC2833List(IN SS_str ***s_pRTP,IN SS_UINT32 const un32MaxList);
SS_SHORT RTP_FreeRFC2833List(IN SS_str ***s_pRTP,IN SS_UINT32 const un32MaxList);
SS_SHORT RTP_CreateRFC2833Packet(
    IN SS_str **s_pRTP,
    IN SS_UINT32 const un32MaxList,
    IN SS_BYTE   const ubKey,
    IN SS_BYTE   const ubKeyPayload);

#define  RTP_CreateSynchronizationSource(s_pRTPHandle) srand((unsigned)time(NULL));(s_pRTPHandle)->m_un32ssrc=rand();(s_pRTPHandle)->m_un32ssrc+=rand()

SS_SHORT RTP_SuctPacket(
    IN  PSSRTPHandle s_pRTPHandle,
    IN  SS_CHAR const*const psInBuf,
    IN  SS_UINT32     const un32InLen,
    OUT SS_CHAR   *         psOutBuf,
    OUT SS_UINT32           *pun32OutLen);
SS_SHORT RTP_ParsePacket(
    IN  PSSRTPHandle s_pRTPHandle,
    IN  SS_CHAR const*const psInBuf,
    IN  SS_UINT32      const un32InLen,
    OUT SSRTPData      *s_RTPData,
    OUT SS_CHAR     *psOutBuf,
    OUT SS_UINT32    *pun32OutLen);
#define   RTP_SetPayload(s_pRTPHandle,ubPayload) (s_pRTPHandle)->m_s_RTPData.m_pt = ubPayload
#define   RTP_Reset(s_pRTPHandle) RTP_CreateSynchronizationSource(s_pRTPHandle); (s_pRTPHandle)->m_s_RTPData.m_un32ssrc= (s_pRTPHandle)->m_un32ssrc
#define   RTP_UpdateTimeStamp(s_pRTPHandle)\
{\
    if (SS_TRUE == (s_pRTPHandle)->m_ubTimeStampFlag)\
    {\
        SS_GET_NONCE_DATETIME((s_pRTPHandle)->m_s_StampFlag1);\
        (s_pRTPHandle)->m_ubTimeStampFlag = SS_FALSE;\
    }\
    else\
    {\
        SS_GET_NONCE_DATETIME((s_pRTPHandle)->m_s_StampFlag2);\
        (s_pRTPHandle)->m_ubTimeStampFlag = SS_TRUE;\
    }\
}

#define   RTP_SetTimeStamp(s_pRTPHandle,usnTimeStamp) (s_pRTPHandle)->m_un32ts += usnTimeStamp



//////////////////////////////////////////////////////////////////////////



//判断有没有编码 如果有返回 SS_TRUE  没有返回SS_FALSE
#define  RTPA_isCodec(_s_pAudio,_un64Code)     (((_un64Code)&(_s_pAudio)->m_un64Audio)?SS_TRUE:SS_FALSE)

//转换一个语音编码，有字符串描述到二进制描述 例如：GSM/8000 G726-16/8000 G721/16000
SS_UINT64 RTPA_TransformCodecStr2int(IN  SS_CHAR const*const psCodecString);
//转换一个语音编码，有二进制描述到字符串描述
SS_CHAR const*RTPA_TransformCodecint2Str(IN SS_UINT64 const un64Code);
SS_SHORT  RTPA_AddCodec(
    IN SS_Audio *s_pAudio,
    IN SS_UINT64 const un64Code,
    IN SS_BYTE   const ubPTID);//payload type ID

SS_SHORT  RTPA_DeleteCodec(IN SS_Audio *s_pAudio,IN SS_UINT64 const un64Code);
SS_BYTE   RTPA_GetPayloadID(IN  SS_Audio const *s_pAudio,IN SS_UINT64 const un64Code);
SS_BYTE   RTPA_GetDefaultPayloadID(IN SS_UINT64 const un64Code);
SS_UINT32 RTPA_GetRate(IN  SS_Audio const *s_pAudio,IN SS_UINT64 const un64Code);
SS_CHAR const*RTPA_GetCodecStr(IN SS_UINT64 const un64Code);
SS_BYTE   RTPA_GetCodecNumber(IN SS_UINT64 const un64Code);
SS_CHAR const*RTPA_GetCodecSuffixName(IN SS_UINT64 const un64Code);

//返回最终协商的结果，0 表示没有结果发生
SS_UINT64 RTPA_CapabilityNegotiatory(
    IN SS_Audio const *s_pAudioA,
    IN SS_Audio const *s_pAudioB);
//获得最优的编码
SS_UINT64 RTPA_GetOptimalCodec(IN SS_Audio const *s_pAudio);
SS_CHAR const*RTPA_GetAllCodecString(IN SS_Audio const *s_pAudio,IN SS_CHAR *pCodec);
SS_SHORT  RTPA_ParseAudioSDPInfo(
    IN  SS_CHAR const *psSDPStr,
    OUT SS_Audio *s_pAudio,
    OUT SS_CHAR *pIP,
 IN OUT SS_UINT32*pun32IPLen,
    OUT SS_USHORT*pusnPort);
    //构造SD信息到字符串
SS_CHAR const*RTPA_CreateAudioSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen);




//判断有没有编码 如果有返回 SS_TRUE  没有返回SS_FALSE
#define  RTPV_isCodec(_s_pVideo,_un32Code) (((_un32Code)&(_s_pVideo)->m_un32Video)?SS_TRUE:SS_FALSE)

//判断这个编码有没有
SS_UINT32 RTPV_TransformCodecStr2int(IN  SS_CHAR const*const psCodecString);
SS_CHAR const*RTPV_TransformCodecint2Str(IN SS_UINT32 const un32Code);
SS_SHORT  RTPV_AddCodec(IN SS_Video *s_pVideo,   IN SS_UINT32 const un32Code);
SS_SHORT  RTPV_DeleteCodec(IN SS_Video *s_pVideo,IN SS_UINT32 const un32Code);
SS_BYTE   RTPV_GetPayloadID(IN  SS_Video const *s_pVideo,IN SS_UINT32 const un32Code);
//返回最终协商的结果，0 表示没有结果发生
SS_UINT32 RTPV_CapabilityNegotiatory(
    IN SS_Video const *s_pVideoA,
    IN SS_Video const *s_pVideoB);
//获得最优的编码
SS_UINT32 RTPV_GetOptimalCodec(IN SS_Video const *s_pVideo);
SS_CHAR const*RTPV_GetAllCodecString(IN SS_Video const *s_pVideo,IN SS_CHAR *pCodec);
SS_SHORT  RTPV_ParseVideoSDPInfo(
    IN  SS_CHAR const *psSDPStr,
    OUT SS_Video *s_pVideo,
    OUT SS_CHAR *pIP,
 IN OUT SS_UINT32*pun32IPLen,
    OUT SS_USHORT*pusnPort);

    //构造SD信息到字符串
SS_CHAR const*RTPV_CreateVideoSDPStr(
    IN  SS_Video const *s_pVideo,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen);

SS_CHAR const*RTP_CreateAudioSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen);
SS_CHAR const*RTP_CreateVideoSDPStr(
    IN  SS_Video const *s_pVideo,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen);

SS_CHAR const*RTP_CreateAudioVideoSDPStr(
    IN  SS_Audio const *s_pAudio,
    IN  SS_Video const *s_pVideo,
    IN  SS_CHAR const  *pIP,
    IN  SS_USHORT const usnAudioPort,
    IN  SS_USHORT const usnVideoPort,
    OUT SS_CHAR * psSDP,
 IN OUT SS_UINT32*pun32SDPLen);


#endif // !defined(AFX_IT_LIB_AUDIO_H__0ADAB5DD_F0E1_492A_AC99_33FC4104F3A1__INCLUDED_)
