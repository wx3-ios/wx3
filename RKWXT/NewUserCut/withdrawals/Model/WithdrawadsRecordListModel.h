//
//  WithdrawadsRecordListModel.h
//  RKWXT
//
//  Created by SHB on 15/9/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    AliMoney_RecordList_Normal = 0,
    AliMoney_RecordList_Loading,
    AliMoney_RecordList_Refresh,
}AliMoney_RecordList;

@protocol WithdrawadsRecordListModelDelegate;

@interface WithdrawadsRecordListModel : NSObject
@property (nonatomic,strong) NSArray *recordListArr;
@property (nonatomic,assign) AliMoney_RecordList type;
@property (nonatomic,assign) id<WithdrawadsRecordListModelDelegate>delegate;

-(void)loadUserWithdrawadlsRecordList:(NSInteger)startItem With:(NSInteger)length;
@end

@protocol WithdrawadsRecordListModelDelegate <NSObject>
-(void)loadUserWithdrawadlsRecordListSucceed;
-(void)loadUserWithdrawadlsRecordListFailed:(NSString*)errorMsg;

@end
