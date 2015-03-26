//
//  WXTCallHistoryCell.h
//  RKWXT
//
//  Created by SHB on 15/3/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol CallHistoryDelegate;
@interface WXTCallHistoryCell : WXUITableViewCell
@property (nonatomic,assign) id<CallHistoryDelegate>delegate;
@end

@protocol CallHistoryDelegate <NSObject>
-(void)callHistoryName:(NSString*)nameStr andPhone:(NSString*)phoneStr;

@end
