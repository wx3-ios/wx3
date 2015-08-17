//
//  NewGoodsInfoVC.h
//  RKWXT
//
//  Created by SHB on 15/6/4.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

typedef enum{
    GoodsInfo_Normal = 0,
    GoodsInfo_LuckyGoods,
}GoodsInfo_Type;

@interface NewGoodsInfoVC : WXUIViewController
@property (nonatomic,assign) GoodsInfo_Type goodsInfo_type;
@property (nonatomic,assign) NSInteger goodsId;

@end
