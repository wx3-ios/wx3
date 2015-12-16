//
//  LMShopCollectionCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionCell.h"
#import "LMShopCollectionView.h"

@implementation LMShopCollectionCell

- (NSInteger)xNumber{
    return 3;
}

- (CGFloat)cellHeight{
    return LMGoodsCollectionCellheight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*10)/3,LMGoodsCollectionCellheight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMShopCollectionView *merchandiseView = [[LMShopCollectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
