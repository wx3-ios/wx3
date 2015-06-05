//
//  MerchantImageCell.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

//商家图片的Cell
@protocol MerchantImageCellDelegate;
@interface MerchantImageCell : WXUITableViewCell
@property (nonatomic,assign)id<MerchantImageCellDelegate>delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray*)imageArray;
- (void)load;
@end

@protocol MerchantImageCellDelegate <NSObject>
- (void)clickTopGoodAtIndex:(NSInteger)index;
@end
