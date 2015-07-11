//
//  AboutShopTopImgCell.h
//  Woxin2.0
//
//  Created by qq on 14-9-1.
//  Copyright (c) 2014年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"

//商家图片的Cell
@protocol AboutShopTopImgCellDelegate;
@interface AboutShopTopImgCell : WXUITableViewCell
@property (nonatomic,assign)id<AboutShopTopImgCellDelegate>delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray*)imageArray;
- (void)load;
@end

@protocol AboutShopTopImgCellDelegate <NSObject>
- (void)clickTopGoodAtIndex:(NSInteger)index;

@end
