//
//  WXMiltiViewCell.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCpxBaseView.h"

@interface WXMiltiViewCell : WXUITableViewCell

- (NSInteger)xNumber;
- (CGFloat)sideGap;
- (CGFloat)cellHeight;
- (CGSize)cpxViewSize;
- (WXCpxBaseView*)createSubCpxView;

- (void)loadCpxViewInfos:(NSArray*)cpxViewInfos;
@end
