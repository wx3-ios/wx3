//
//  WXShopUnionHotShopCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionHotShopCell.h"
#import "WXShopUnionDef.h"
#import "WXShopUnionHotShopView.h"

@implementation WXShopUnionHotShopCell

- (NSInteger)xNumber{
    return 3;
}

- (CGFloat)cellHeight{
    return ShopUnionHotShopListHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*10)/3,ShopUnionHotShopListHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    WXShopUnionHotShopView *merchandiseView = [[WXShopUnionHotShopView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end