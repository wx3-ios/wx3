//
//  WinningView.h
//  RKWXT
//
//  Created by SHB on 15/11/12.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

@protocol WinningViewBtnDelegate;

@interface WinningView : WXUIView
@property (nonatomic,assign) id<WinningViewBtnDelegate>delegate;
@property (nonatomic,strong) UIViewController *parentVC;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *name;

+ (instancetype)defaultPopupView;
-(void)initial;
@end

@protocol WinningViewBtnDelegate <NSObject>
-(void)winningViewCloseBtnClicked;
-(void)winningViewSeeGoodsBtnClicked;

@end
