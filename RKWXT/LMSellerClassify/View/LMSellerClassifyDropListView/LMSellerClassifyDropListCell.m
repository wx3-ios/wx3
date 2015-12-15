//
//  LMSellerClassifyDropListCell.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSellerClassifyDropListCell.h"
#import "SellerDropListView.h"

@implementation LMSellerClassifyDropListCell

- (NSInteger)xNumber{
    return 4;
}

- (CGFloat)cellHeight{
    return 40;
}

- (CGFloat)sideGap{
    return 15;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-5*15)/4,40);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    SellerDropListView *merchandiseView = [[SellerDropListView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
