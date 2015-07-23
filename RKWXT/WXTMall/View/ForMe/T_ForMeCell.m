//
//  T_ForMeCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_ForMeCell.h"
#import "NewHomePageCommonDef.h"
#import "T_ForMeView.h"

@implementation T_ForMeCell

- (NSInteger)xNumber{
    return ForMeShow;
}

- (CGFloat)cellHeight{
    return T_HomePageForMeHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-4*xGap)/ForMeShow+ForMeShow-0.5,T_HomePageForMeHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    T_ForMeView *merchandiseView = [[T_ForMeView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}


@end
