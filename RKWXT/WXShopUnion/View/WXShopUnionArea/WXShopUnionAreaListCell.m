//
//  WXShopUnionAreaListCell.m
//  RKWXT
//
//  Created by SHB on 15/11/25.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopUnionAreaListCell.h"
#import "WXShopUnionAreaListView.h"

@implementation WXShopUnionAreaListCell

- (NSInteger)xNumber{
    return 3;
}

- (CGFloat)cellHeight{
    return 44;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*10)/3,44);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    WXShopUnionAreaListView *merchandiseView = [[WXShopUnionAreaListView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end