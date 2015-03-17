//
//  URLDownloadOBJ.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLNetNotificationOBJ.h"

//用kvo的形式通知界面
#define kURLDownloadOBJProcessChanged  @"kURLDownloadOBJProcessChanged"
#define kURLDownloadOBJFinished @"kURLDownloadOBJFinished"
#define kURLDownloadOBJError @"kURLDownloadOBJError"

@interface URLDownloadOBJ : NSObject

+ (URLDownloadOBJ*)sharedURLDownloadOBJ;

//key定位用的~
- (void)downloadRemotionFile:(NSString*)urlString key:(id)key;
@end