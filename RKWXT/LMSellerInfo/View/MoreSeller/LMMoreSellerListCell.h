//
//  LMMoreSellerListCell.h
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

#define LMMoreSellerListCellHeight (92)

@protocol LMMoreSellerListCellDelegate;
@interface LMMoreSellerListCell : WXMiltiViewCell
@property (nonatomic,assign)id<LMMoreSellerListCellDelegate>delegate;
@end

@protocol LMMoreSellerListCellDelegate <NSObject>
-(void)moreSellerListBtnClicked:(id)entity;

@end
