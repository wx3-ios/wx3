//
//  ClassifyRightCell.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyRightCell.h"
#import "ClassifyRightDef.h"
#import "ClassifyRightView.h"

@implementation ClassifyRightCell

- (NSInteger)xNumber{
    return showNumber;
}

- (CGFloat)cellHeight{
    return EveryCellHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-ClassifyLeftViewWidth-4*xGap)/showNumber,EveryCellHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    ClassifyRightView *merchandiseView = [[ClassifyRightView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
