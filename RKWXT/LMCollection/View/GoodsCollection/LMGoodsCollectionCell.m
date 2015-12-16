//
//  LMGoodsCollectionCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsCollectionCell.h"
#import "LMGoodsCollectionView.h"

@implementation LMGoodsCollectionCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return LMGoodsCollectionCellheight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,LMGoodsCollectionCellheight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMGoodsCollectionView *merchandiseView = [[LMGoodsCollectionView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
