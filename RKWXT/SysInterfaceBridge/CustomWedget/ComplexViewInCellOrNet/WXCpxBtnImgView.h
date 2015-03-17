//
//  WXCpxBtnImgView.h
//  CallTesting
//
//  Created by le ting on 4/23/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXCpxBaseView.h"

@interface WXCpxBtnImgView : WXCpxBaseView

#pragma mark 虚函数 在子类执行
- (void)buttonClicked;
//设置是否支持点击
- (void)setButtonEnable:(BOOL)enable;


#pragma mark 实函数
- (void)setImage:(UIImage*)image;
- (void)setIcon:(UIImage*)icon;
@end
