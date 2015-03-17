//
//  LoadingCell.h
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"
#import "LoadingEntity.h"

#define kLoadingCellHeight (20.0)
@protocol LoadingCellDelegate;
@interface LoadingCell : WXUITableViewCell
@property (nonatomic,assign)id<LoadingCellDelegate>delegate;

@end

@protocol LoadingCellDelegate <NSObject>
- (void)reload:(LoadingEntity *)loadingEntity;
@end
