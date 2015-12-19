//
//  LMGoodsView.h
//  RKWXT
//
//  Created by SHB on 15/12/11.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

#define K_Notification_Name_UserBuyGoods @"K_Notification_Name_UserBuyGoods"
#define K_Notification_Name_UserAddShoppingCart @"K_Notification_Name_UserAddShoppingCart"

typedef enum{
    LMGoodsView_Type_ShoppingCart = 0,
    LMGoodsView_Type_Buy,
}LMGoodsView_Type;

@interface LMGoodsView : WXUIView
@property (nonatomic,assign) LMGoodsView_Type goodsViewType;
@property (nonatomic,assign) NSInteger buyNum;
@property (nonatomic,assign) NSInteger stockID;
@property (nonatomic,strong) NSString *stockName;
@property (nonatomic,assign) CGFloat stockPrice;
-(void)loadGoodsStockInfo:(NSArray*)stockArr;

@end
