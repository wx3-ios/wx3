//
//  LMGoodsView.h
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

typedef enum{
    LMGoodsView_Type_ShoppingCart = 0,
    LMGoodsView_Type_Buy,
}LMGoodsView_Type;

@interface LMGoodsView : WXUIView
@property (nonatomic,assign) LMGoodsView_Type goodsViewType;
-(void)loadGoodsStockInfo:(NSArray*)stockArr;

@end
