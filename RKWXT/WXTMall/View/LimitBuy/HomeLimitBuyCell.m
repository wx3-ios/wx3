//
//  HomeLimitBuyCell.m
//  RKWXT
//
//  Created by SHB on 15/11/27.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "HomeLimitBuyCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeLimitBuyView.h"

@implementation HomeLimitBuyCell

- (NSInteger)xNumber{
    return LimitBuyShow;
}

- (CGFloat)cellHeight{
    return T_HomePageLimitBuyHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*xGap)/LimitBuyShow+LimitBuyShow-0.5,T_HomePageLimitBuyHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    HomeLimitBuyView *merchandiseView = [[HomeLimitBuyView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end