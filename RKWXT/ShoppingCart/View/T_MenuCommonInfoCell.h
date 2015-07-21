//
//  T_MenuCommonInfoCell.h
//  Woxin3.0
//
//  Created by SHB on 15/1/24.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol deleteStoreGoods;

@interface T_MenuCommonInfoCell : WXUITableViewCell
@property (nonatomic,assign) id<deleteStoreGoods>delegate;
-(void)setGoodsInfo:(id)entity;
-(void)selectAllGoods:(BOOL)selectAll;
@end

@protocol deleteStoreGoods <NSObject>
-(void)goodsImgBtnClicked:(NSInteger)goodsID;
-(void)deleteGoods:(NSInteger)cart_id;
-(void)selectGoods;
-(void)cancelGoods;
-(void)minusBtnClicked;
-(void)plusBtnClicked;

@end
