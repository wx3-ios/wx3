//
//  KFLoger.mm
//  navi
//
//  Created by zhujuzhang on 11/1/12.
//
//

#import "KFLoger.h"


#define   FILENAME_LEN    50
#define   FUNCNAME_LEN    100

static KFLoger*   g_KFLoger = nil;      //全局的单例

#pragma mark ---- logInfo,保存日志信息
@implementation KFLogInfo

@synthesize curSourceFileName = _curSourceFileName;
@synthesize curFuncName = _curFuncName;
@synthesize logTextContent = _logTextContent;
@synthesize curSourceLineNum = _curSourceLineNum;
@synthesize logTime = _logTime;
@synthesize logType = _logType;
@synthesize isNeedSaveFile = _isNeedSaveFile;


- (id)init
{
    if (self = [super init])
    {
        _curSourceFileName = (char*)malloc(FILENAME_LEN);
        memset(_curSourceFileName, 0, FILENAME_LEN);
        
        _curFuncName = (char*)malloc(FUNCNAME_LEN);
        memset(_curFuncName, 0, FUNCNAME_LEN);
        
        _logTime = (struct tm*)malloc(sizeof(struct tm));
    }
    return self;
}

@end




#pragma mark —— KFLoger类的实现
@implementation KFLoger

+(KFLoger*)GetInstance
{
    if(g_KFLoger == nil)
    {
        g_KFLoger = [[KFLoger alloc] init];
    }
    
    return g_KFLoger;
}


- (id)init
{
    if (self = [super init])
    {
        
        _logArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        NSArray* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _filePath = [path objectAtIndex:0];
        _logWriteQueue = dispatch_queue_create("log_wirte_file_queue", NULL);
    }
    
    return self;
}


//获取日志类型字符串
+ (NSString*)getLogTypeString:(NSInteger)logType
{
    NSString* strLogType = nil;
    
    switch (logType) {
        case LogType_Normal:
            strLogType = @"NORMAL";
            break;
        case LogType_Debug:
            strLogType = @"DEBUG";
            break;
        case LogType_Warning:
            strLogType = @"WARNING";
            break;
        case LogType_Error:
            strLogType = @"ERROR";
            break;
        case LogType_Dev_Level0:
            strLogType = @"DEV_0";
            break;
        case LogType_Dev_Level1:
            strLogType = @"DEV_1";
            break;
        case LogType_Dev_Level2:
            strLogType = @"DEV_2";
            break;
        default:
            break;
    }
    
    return strLogType;
}



//获取当前时间，采用C的库函数，返回值不需要外部释放
- (struct tm*)getCurTime
{
    //时间格式
    struct timeval ticks;
    gettimeofday(&ticks, nil);
    time_t now;
    struct tm* timeNow;
    time(&now);
    timeNow = localtime(&now);
    timeNow->tm_gmtoff = ticks.tv_usec/1000;  //毫秒
    
    timeNow->tm_year += 1900;    //tm中的tm_year是从1900至今数
    timeNow->tm_mon  += 1;       //tm_mon范围是0-11
    
    return timeNow;
}



//创建log文件名, 通过日期来对日志命名
- (NSString*)createLogFile
{
    struct tm* timeNow = [self getCurTime];
    
    //生成文件名,保存到caches文件目录
    
    NSString* logFileName = [NSString stringWithFormat:@"%@/Log_%d_%d_%d.dat",_filePath,
                             timeNow->tm_year,
                             timeNow->tm_mon,
                             timeNow->tm_mday];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFileName])
    {
        //加个同步锁
        @synchronized(_fileHandle)
        {
            [_fileHandle closeFile];
            _fileHandle = nil;
        }
        
        [[NSFileManager defaultManager] createFileAtPath:logFileName contents:nil attributes:nil];
    }
    
    return logFileName;
}


//单条log的写文件
- (void)writeOneLog:(KFLogInfo*)logInfo
{
    if (logInfo == nil)
        return;
    
    NSString* logFileName = [self createLogFile];
    
    @synchronized(_fileHandle)
    {
        if (_fileHandle == nil)
        {
            _fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFileName];
        }
        
        if (_fileHandle)
        {
            //日志数据写入文件
            NSString* logFormat = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d.%ld File:%s %s Line:%d %@ %@\n",
                                   logInfo.logTime->tm_year,
                                   logInfo.logTime->tm_mon,
                                   logInfo.logTime->tm_mday,
                                   logInfo.logTime->tm_hour,
                                   logInfo.logTime->tm_min,
                                   logInfo.logTime->tm_sec,
                                   logInfo.logTime->tm_gmtoff,
                                   logInfo.curSourceFileName,
                                   logInfo.curFuncName,
                                   logInfo.curSourceLineNum,
                                   [KFLoger getLogTypeString:logInfo.logType],
                                   logInfo.logTextContent];
            
            [_fileHandle seekToEndOfFile];
            [_fileHandle writeData:[logFormat dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}


//log队列写到指定文件
- (void)saveLogs2File:(id)logArray
{
    
    if ([logArray count] == 0)
        return;
    
    for (KFLogInfo* info in logArray)
    {
        [self writeOneLog:info];
    }
    
    [logArray removeAllObjects];
    
    
    @synchronized(_fileHandle)
    {
        [_fileHandle closeFile];
        _fileHandle = nil;
    }
}




//app退出或者需要强制写文件时调用
- (void)flushLogs
{
    @synchronized(_logArray)
    {
        [self saveLogs2File:_logArray];
    }
}



//用于开发log的过滤
- (BOOL)devLogFilter:(NSInteger)logType
{
    if (LogType_Dev_Level0 == logType)
    {
#ifdef kOPEN_DEV_0
        return YES;
#else
        return NO;
#endif
    }
    else if (LogType_Dev_Level1 == logType)
    {
#ifdef kOPEN_DEV_1
        return YES;
#else
        return NO;
#endif
    }
    else if (LogType_Dev_Level2 == logType)
    {
#ifdef kOPEN_DEV_2
        return YES;
#else
        return NO;
#endif
    }
    
    return YES;
}



//只是获取文件名, 使用纯C代码，效率提升明显
- (char*)getFileName:(const char*)filePath
{
    
    int len = strlen(filePath);    //传入路径的总长度
    int fileLen = 0;               //只是文件名的长度
    char* fileName = nil;
    char* p = (char*)filePath+len-1;
    
    //从后往前找，一直找到文件夹分隔符
    for (int i=len; i>0; i--)
    {
        if ((*p) == '/')
        {
            fileLen = len-i;
            break;
        }
        
        p--;
    }
    
    if (fileLen > 0)
    {
        fileName = (char*)malloc(fileLen+1);
        memset(fileName, 0, fileLen+1);
        memcpy(fileName, p+1, fileLen);
        return fileName;
    }
    
    return nil;
    
}



/**
 * 添加一条log
 *       log格式: 年-月-日 时:分:秒 文件名 模块名 Line:行数  日志类型: 日志内容
 *        eg: 2012-11-1 13:20:28 File:TestApp.mm Line:29  NORMAL:  测试测试
 * logContent: 日志内容
 * logType: 日志的类型
 * isNeedSave: 是否需要写文件
 */
- (void)addLog:(NSString*)txtContent sourceName:(const char*)sourceName funcName:(const char*)funcName lineNum:(int)lineNum logType:(NSInteger)logType isNeedSave:(BOOL)isNeedSave
{
    
    //先过滤关闭的log
    if (![self devLogFilter:logType])
    {
        return;
    }
    
    KFLogInfo*  logInfo = [[KFLogInfo alloc] init];
    
    
    logInfo.logType = logType;
    logInfo.isNeedSaveFile = isNeedSave;
    
    //文件名
    char* fileName = [self getFileName:sourceName];
    if (fileName != nil)
    {
        int fileLen = strlen(fileName);
        fileLen = (fileLen > FILENAME_LEN)?FILENAME_LEN:fileLen;
        memcpy(logInfo.curSourceFileName, fileName, fileLen);
    }
    
    //函数名
    int funcLen = strlen(funcName);
    funcLen = (funcLen > FUNCNAME_LEN)?FUNCNAME_LEN:funcLen;
    memcpy(logInfo.curFuncName, (char*)funcName, funcLen);
    free(fileName);
    
    logInfo.curSourceLineNum = lineNum;
    logInfo.logTextContent = txtContent;
    
    
    //时间格式
    struct tm* timeNow = [self getCurTime];
    memcpy(logInfo.logTime, timeNow, sizeof(struct tm));
    
    //控制台打印日志
#ifdef kDEBUG
#ifdef KFLOG_PRINT_CONSOLE
    
    printf("%d-%d-%d %d:%d:%d.%ld File:%s %s Line:%d %s %s\n",
           timeNow->tm_year,
           timeNow->tm_mon,
           timeNow->tm_mday,
           timeNow->tm_hour,
           timeNow->tm_min,
           timeNow->tm_sec,
           timeNow->tm_gmtoff,
           logInfo.curSourceFileName,
           logInfo.curFuncName,
           logInfo.curSourceLineNum,
           [[KFLoger getLogTypeString:logInfo.logType] UTF8String],
           [logInfo.logTextContent UTF8String]);
    
#endif
#endif
    
    
    
    // 这种情况是所有的日志都写文件
#ifdef KFLOG_ALL_WRITE_FILE
    isNeedSave = YES;
#endif
    
    if (isNeedSave)
    {
        // 加个锁，多线程保护
        @synchronized(_logArray)
        {
            [_logArray addObject:logInfo];     //加入到log队列
            
            if ([_logArray count] >= kMAX_CACHE_LOG_COUNT)
            {
                //开启线程去写log
                //                NSMutableArray*  saveLogArray = [NSMutableArray arrayWithArray:_logArray];
                NSMutableArray*  saveLogArray = [[NSMutableArray alloc]initWithArray:_logArray];
                //做下保护
                if (saveLogArray == nil)
                {
                    return;
                }
                //异步对列写文件
                dispatch_async(_logWriteQueue, ^{
                    [self saveLogs2File:saveLogArray];
                });
                //                NSInvocationOperation* saveLogOper = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveLogs2File:) object:saveLogArray] autorelease];
                //                [saveLogOper start];
                
                [_logArray removeAllObjects];
            }
        }
        
    }
}


@end
