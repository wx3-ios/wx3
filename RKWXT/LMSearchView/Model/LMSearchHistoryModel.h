//
//  LMSearchHistoryModel.h
//  RKWXT
//
//  Created by SHB on 15/12/10.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_LMSearchHistoryLoadSucceed @"D_Notification_Name_LMSearchHistoryLoadSucceed"
#define D_Notification_Name_LMSearchHistoryDelOnRecordSucceed @"D_Notification_Name_LMSearchHistoryDelOnRecordSucceed"

@interface LMSearchHistoryModel : NSObject
@property (nonatomic,strong) NSArray *listArr;
-(void)loadLMSearchHistoryList;
-(void)deleteLMSearchRecordWith:(NSString*)recordName;
-(void)deleteAll;

@end
