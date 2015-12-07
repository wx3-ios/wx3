//
//  LMShopInfoTopImgCell.h
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol LMShopInfoTopImgCellDelegate;

@interface LMShopInfoTopImgCell : WXUITableViewCell
@property (nonatomic,assign) id<LMShopInfoTopImgCellDelegate>delegate;
@end

@protocol LMShopInfoTopImgCellDelegate <NSObject>
-(void)shopCallBtnClicked:(NSString*)phone;

@end
