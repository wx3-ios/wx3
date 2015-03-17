//
//  WXSingleSelectVC.h
//  CallTesting
//
//  Created by le ting on 5/26/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUIViewController.h"

@protocol WXSingleSelectVCDelegate;
@interface WXSingleSelectVC : WXUIViewController
@property (nonatomic,retain)NSString *cstTitle;
@property (nonatomic,retain)NSArray *textArray;
@property (nonatomic,retain)NSArray *iconArray;
@property (nonatomic,assign)NSInteger defaultSelectedIndex;
@property (nonatomic,assign)id<WXSingleSelectVCDelegate>delegate;

@end

@protocol  WXSingleSelectVCDelegate <NSObject>
- (void)didSelectedAtIndex:(NSInteger)index;
@end
