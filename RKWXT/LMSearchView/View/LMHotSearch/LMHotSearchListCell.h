//
//  LMHotSearchListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/9.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol LMHotSearchListCellDelegate;

@interface LMHotSearchListCell : WXUITableViewCell
@property (nonatomic,assign) id<LMHotSearchListCellDelegate>delegate;
@end

@protocol LMHotSearchListCellDelegate <NSObject>
-(void)lmHotSearchlistBtnClicked:(NSInteger)index;

@end
