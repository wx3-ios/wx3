//
//  ClassifyHistoryModel.h
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_ClassifyHistoryLoadSucceed @"D_Notification_Name_ClassifyHistoryLoadSucceed"
#define D_Notification_Name_ClassifyHistoryDelOnRecordSucceed @"D_Notification_Name_ClassifyHistoryDelOnRecordSucceed"

@interface ClassifyHistoryModel : NSObject
@property (nonatomic,strong) NSArray *listArr;
-(void)loadClassifyHistoryList;
-(void)deleteClassifyRecordWith:(NSString*)recordName;
-(void)deleteAll;

@end
