//
//  WXCpxBaseView.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIView.h"

@interface WXCpxBaseView : WXUIView
@property (nonatomic,retain)id cpxViewInfo;

#pragma mark 虚函数 在子类执行
- (void)load;
- (void)unLoad;
@end
