//
//  ToSnapUpTopCell.h
//  RKWXT
//
//  Created by app on 15/11/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeardGoodsView,ToSnapUpTopCell;

@protocol ToSnapUpTopCellDelegate  <NSObject>

- (void)toSnapUpToCellWithTouch:(ToSnapUpTopCell*)cell index:(NSInteger)index;

@end


typedef NS_ENUM(NSInteger, ToSnapUpTopType) {
    ToSnapUpTopTypeIndexOne = 0,
    ToSnapUpTopTypeIndexTwo,
    ToSnapUpTopTypeIndexThree,
};



@interface ToSnapUpTopCell : UITableViewCell
@property (nonatomic,strong)HeardGoodsView *goods;
@property (nonatomic,strong)NSArray *goodsArray;
@property (nonatomic,strong)NSMutableArray *childArray;
@property (nonatomic,weak)id<ToSnapUpTopCellDelegate> delegate;

+ (CGFloat)cellHeight;

+ (instancetype)toSnapTopCellCreate:(UITableView*)tableview  goodsArray:(NSArray*)goodsArray;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  goodsArray:(NSArray*)goodsArray;
@end
