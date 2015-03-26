//
//  WXTCallHistoryCell.h
//  RKWXT
//
//  Created by SHB on 15/3/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@class CallHistoryEntity;
@protocol CallHistoryDelegate;
@interface WXTCallHistoryCell : WXUITableViewCell
@property (nonatomic, strong) CallHistoryEntity * callHistoryEntity;
@property (nonatomic,assign) id<CallHistoryDelegate>delegate;
-(void)load:(CallHistoryEntity*)callHistoryEntity;
@end

@protocol CallHistoryDelegate <NSObject>
-(void)callHistoryName:(NSString*)nameStr andPhone:(NSString*)phoneStr;

@end
