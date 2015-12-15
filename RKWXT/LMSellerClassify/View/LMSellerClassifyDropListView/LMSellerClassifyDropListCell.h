//
//  LMSellerClassifyDropListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol LMSellerClassifyDropListCellDelegate;
@interface LMSellerClassifyDropListCell : WXMiltiViewCell
@property (nonatomic,assign) id<LMSellerClassifyDropListCellDelegate>delegate;
@end

@protocol LMSellerClassifyDropListCellDelegate <NSObject>
-(void)lmSellerListBtnClicked:(id)sender;

@end
