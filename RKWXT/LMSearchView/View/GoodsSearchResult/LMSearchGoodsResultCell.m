//
//  LMSearchGoodsResultCell.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchGoodsResultCell.h"
#import "LMSearchGoodsResultView.h"

@implementation LMSearchGoodsResultCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return LMSearchGoodsResultCellHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,LMSearchGoodsResultCellHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMSearchGoodsResultView *merchandiseView = [[LMSearchGoodsResultView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end