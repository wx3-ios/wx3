//
//  WXTProductDetailViewController.h
//  RKWXT
//
//  Created by app on 5/28/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

enum WXGoodsDetailCellOption{
    WXGoodsDetail_TopDisplay = 0,
    WXGoodsDetail_Default ,//
    WXGoodsDetail_Invalid
};
@class WXHomeTopGoodCell;
@interface WXTGoodsDetailViewController : WXUIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    WXHomeTopGoodCell * _topProDisplay;
}

@end
