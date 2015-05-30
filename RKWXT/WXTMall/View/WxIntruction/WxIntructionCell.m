//
//  WxIntructionCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "WxIntructionCell.h"
#import "WxIntructionView.h"
#import "NewHomePageCommonDef.h"

@implementation WxIntructionCell

- (NSInteger)xNumber{
    return WxIntructionShow;
}

- (CGFloat)cellHeight{
    return T_HomePageWXIntructionHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*xGap)/2,T_HomePageWXIntructionHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    WxIntructionView *merchandiseView = [[WxIntructionView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
