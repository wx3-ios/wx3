//
//  T_ChangeCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_ChangeCell.h"
#import "NewHomePageCommonDef.h"
#import "T_ChangeView.h"

@implementation T_ChangeCell

- (NSInteger)xNumber{
    return ChangeInfoShow;
}

- (CGFloat)cellHeight{
    return T_HomePageChangeInfoHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*xGap)/2+ChangeInfoShow-0.5,T_HomePageChangeInfoHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    T_ChangeView *merchandiseView = [[T_ChangeView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}


@end
