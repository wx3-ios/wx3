//
//  LMShopInfoNewGoodsCell.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoNewGoodsCell.h"
#import "LMShopInfoNewGoodsView.h"

@implementation LMShopInfoNewGoodsCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return LMShopInfoNewGoodsViewHeight;
}

- (CGFloat)sideGap{
    return 10;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*10)/2,LMShopInfoNewGoodsViewHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    LMShopInfoNewGoodsView *merchandiseView = [[LMShopInfoNewGoodsView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
