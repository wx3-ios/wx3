//
//  NewGoodsInfoZoomImgItem.h
//  RKWXT
//
//  Created by SHB on 15/9/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
#import "GoodsInfoImageZoomView.h"

@interface NewGoodsInfoZoomImgItem : WXUITableViewCell{
    GoodsInfoImageZoomView *imageView;
}

@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, assign)CGSize size;

@end
