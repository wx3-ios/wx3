//
//  URLDownloadOBJ.m
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "URLDownloadOBJ.h"
#import "ASIHTTPRequest.h"
#import "URLNetOperation.h"

@interface URLDownloadOBJ()<ASIHTTPRequestDelegate,ASIProgressDelegate>

@end

@implementation URLDownloadOBJ

- (void)dealloc{
}

+ (NSOperationQueue*)sharedURLDownloadQueue{
    static dispatch_once_t onceToken;
    static NSOperationQueue *sharedURLDownloadOperationQueue = nil;
    dispatch_once(&onceToken, ^{
        sharedURLDownloadOperationQueue = [[NSOperationQueue alloc] init];
    });
    return sharedURLDownloadOperationQueue;
}

+ (URLDownloadOBJ*)sharedURLDownloadOBJ{
    static dispatch_once_t onceToken;
    static URLDownloadOBJ *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[URLDownloadOBJ alloc] init];
    });
    return sharedInstance;
}

- (NSString*)urlStringFromRequest:(URLNetOperation*)request{
    return request.originalURL.absoluteString;
}

- (URLNetOperation *)downloadThreadOf:(NSString*)urlString{
    NSOperationQueue *queue = [[self class] sharedURLDownloadQueue];
    NSArray *opts = [queue operations];
    for(URLNetOperation *request in opts){
        if([[self urlStringFromRequest:request] isEqualToString:urlString]){
            return request;
        }
    }
    return nil;
}

- (BOOL)existInDownloadQueue:(NSString*)urlString{
    if([self downloadThreadOf:urlString]){
        return YES;
    }
    return NO;
}

- (void)downloadRemotionFile:(NSString*)urlString key:(id)key{
//    NSAssert(urlString, @"download url string cannot be empty");
	if(urlString == nil){
		KFLog_Normal(YES, @"download url string cannot be empty");
		return;
	}
    //避免重复下载
    if([self existInDownloadQueue:urlString]){
        KFLog_Normal(YES, @"队列里面已经有了该文件的下载");
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    URLNetOperation *request = [URLNetOperation requestWithURL:url];
    [request setKey:key];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:self];
    [[[self class] sharedURLDownloadQueue] addOperation:request];
}

#pragma mark DownloadProgressDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    long long content = request.contentLength;
    CGFloat progress = (float)bytes/(float)content;
    
    URLNetOperation *operation = (URLNetOperation*)request;
    URLNetNotificationOBJ *obj = [[URLNetNotificationOBJ alloc] init];
    [obj setObject:[NSNumber numberWithFloat:progress]];
    [obj setKey:operation.key];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kURLDownloadOBJProcessChanged object:obj userInfo:nil];
    [obj release];
}

#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data = [request responseData];
    URLNetOperation *operation = (URLNetOperation*)request;
    
    URLNetNotificationOBJ *obj = [[URLNetNotificationOBJ alloc] init];
    [obj setObject:data];
    [obj setKey:operation.key];
    NSString *url = [self urlStringFromRequest:operation];
    [obj setUrlString:url];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kURLDownloadOBJFinished object:obj userInfo:nil];
    [obj release];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    URLNetOperation *operation = (URLNetOperation*)request;
    URLNetNotificationOBJ *obj = [[URLNetNotificationOBJ alloc] init];
    [obj setObject:error];
    [obj setKey:operation.key];
    [obj setUrlString:[self urlStringFromRequest:operation]];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kURLDownloadOBJError object:obj userInfo:nil];
    [obj release];
    KFLog_Normal(YES, @"download error = %@ url=%@",error,[self urlStringFromRequest:operation]);
}

@end
