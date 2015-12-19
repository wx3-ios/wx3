//
//  ShopInfAllGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/2.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ShopInfAllGoodsCell.h"
#import "LMShopInfoDef.h"
#import "ShopInfoAllGoodsView.h"

@implementation ShopInfAllGoodsCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return LMShopInfoHotGoodsHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,LMShopInfoHotGoodsHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    ShopInfoAllGoodsView *merchandiseView = [[ShopInfoAllGoodsView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end