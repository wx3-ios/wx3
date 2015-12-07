//
//  LMShopInfoSalesCell.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoSalesCell.h"
#import "LMShopInfoSalesView.h"

@implementation LMShopInfoSalesCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return LMShopInfoSalesViewHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,LMShopInfoSalesViewHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMShopInfoSalesView *merchandiseView = [[LMShopInfoSalesView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end