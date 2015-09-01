//
//  FTPManager.h
//  RKWXT
//
//  Created by SHB on 15/8/28.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_PostFtp_Succeed @"D_Notification_Name_PostFtp_Succeed"
#define D_Notification_Name_PostFtp_Failed  @"D_Notification_Name_PostFtp_Failed"

@interface FTPManager : NSObject

-(void)sendDocumentToFTPService:(NSString*)path;

@end
