//
//  LMMoreSellerListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMMoreSellerListCell.h"
#import "LMMoreSellerListView.h"

@implementation LMMoreSellerListCell

- (NSInteger)xNumber{
    return 3;
}

- (CGFloat)cellHeight{
    return LMMoreSellerListCellHeight;
}

- (CGFloat)sideGap{
    return 8;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*8)/3,LMMoreSellerListCellHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMMoreSellerListView *merchandiseView = [[LMMoreSellerListView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
