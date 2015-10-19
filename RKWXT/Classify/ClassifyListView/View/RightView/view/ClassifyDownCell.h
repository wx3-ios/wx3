//
//  ClassifyDownCell.h
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
#import "WXCpxBaseView.h"

@interface ClassifyDownCell : WXUITableViewCell
- (NSInteger)xNumber;
- (CGFloat)sideGap;
- (CGFloat)cellHeight;
- (CGSize)cpxViewSize;
- (WXCpxBaseView*)createSubCpxView;

- (void)loadCpxViewInfos:(NSArray*)cpxViewInfos;

@end
