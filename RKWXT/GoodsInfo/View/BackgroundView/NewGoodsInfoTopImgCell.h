//
//  NewGoodsInfoTopImgCell.h
//  RKWXT
//
//  Created by SHB on 15/8/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define TopImgViewHeight 50

@protocol NewGoodsInfotopImgCellDelegate;

@interface NewGoodsInfoTopImgCell : WXUITableViewCell
@property (nonatomic,assign) id<NewGoodsInfotopImgCellDelegate>delegate;

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier imgNameArray:(NSArray*)imgNameArray;
-(void)load;

@end

@protocol NewGoodsInfotopImgCellDelegate <NSObject>
-(void)clickTopImgView;

@end
