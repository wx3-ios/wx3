//
//  StoreListInfoCell.h
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#import "StoreListData.h"
@class PhotoView,StoreListInfoCell;
@protocol StoreListInfoCellDelegate <NSObject>
@end

@interface StoreListInfoCell : WXUITableViewCell
@property (nonatomic,strong)StoreListData *data;
@property (nonatomic,strong)PhotoView *photoView;
+ (CGFloat)cellHeightForRow;
@end
