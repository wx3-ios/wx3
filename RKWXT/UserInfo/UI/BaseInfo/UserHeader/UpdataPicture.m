//
//  UpdataPicture.m
//  RKWXT
//
//  Created by SHB on 15/10/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UpdataPicture.h"
#import "NetworkManager.h"
#include <CFNetwork/CFNetwork.h>
#import "UserHeaderModel.h"
#import "UserHeaderImgModel.h"

#define FtpUrl @"ftp://wx3.67call.com"
#define UserName @"picuser"
#define UserPwd @"KoYYooop7728###"

enum {
    kSendBufferSize = 32768
};

@interface UpdataPicture()<NSStreamDelegate>{
    
}
@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
@end

@implementation UpdataPicture
{
    uint8_t                     _buffer[kSendBufferSize];
}

#pragma mark 上传头像
- (uint8_t *)buffer{
    return self->_buffer;
}

- (BOOL)isSending{
    return (self.networkStream != nil);
}

- (void)startSend:(NSString *)filePath{
    [UtilTool showTipView:@"头像上传中..."];
    BOOL                    success;
    NSURL *                 url;
    url = [[NetworkManager sharedInstance] smartURLForString:FtpUrl];
    success = (url != nil);
    if (success) {
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    if (!success){
    } else {
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        [self.fileStream open];
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        success = [self.networkStream setProperty:UserName forKey:(id)kCFStreamPropertyFTPUserName];
        success = [self.networkStream setProperty:UserPwd forKey:(id)kCFStreamPropertyFTPPassword];
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    [[UserHeaderModel shareUserHeaderModel] updateUserHeaderSucceed:[NSString stringWithFormat:@"%@userIcon.png",userObj.wxtID]];
    [UtilTool showAlertView:@"上传头像成功"];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    assert(aStream == self.networkStream);
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened connection");
        } break;
        case NSStreamEventHasBytesAvailable: {
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"Sending");
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [UtilTool showAlertView:@"上传头像失败"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [UtilTool showAlertView:@"上传头像失败"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [UtilTool showAlertView:@"上传头像失败"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * Actions
-(void)sendDocumentToFTPService{
    if (!self.isSending ) {
        NSString * filePath;
        filePath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
        [self startSend:filePath];
    }
}

@end
