//
//  WXTFindCommmonCell.h
//  RKWXT
//
//  Created by SHB on 15/4/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol WXTFindCommonCellCellDelegate;
@interface WXTFindCommonCell : WXUITableViewCell
@property (nonatomic,assign)id<WXTFindCommonCellCellDelegate>delegate;

@end

@protocol WXTFindCommonCellCellDelegate <NSObject>
- (void)clickClassifyBtnAtIndex:(NSInteger)index;

@end
