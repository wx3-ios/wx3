//
//  LMHomeHotGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMHomeHotGoodsCell.h"
#import "WXShopUnionDef.h"
#import "LMHomeHotGoodsView.h"

@implementation LMHomeHotGoodsCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return ShopUnionHotGoodsListHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,ShopUnionHotGoodsListHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMHomeHotGoodsView *merchandiseView = [[LMHomeHotGoodsView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
