//
//  T_TopicalCell.m
//  Woxin3.0
//
//  Created by SHB on 15/1/15.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "T_TopicalCell.h"
#import "NewHomePageCommonDef.h"
#import "T_TopicalView.h"

@implementation T_TopicalCell

- (NSInteger)xNumber{
    return TopicalShow;
}

- (CGFloat)cellHeight{
    return T_HomePageTopicalHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*xGap)/2+TopicalShow-0.5,T_HomePageTopicalHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    T_TopicalView *merchandiseView = [[T_TopicalView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
