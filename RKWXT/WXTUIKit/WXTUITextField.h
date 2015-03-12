//
//  WXTUITextField.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTUITextField : UITextField

- (void)setLeftView:(UIView*)leftView leftGap:(CGFloat)leftGap rightGap:(CGFloat)rightGap;
- (void)setPlaceHolder:(NSString*)placeHolder color:(UIColor*)color;

@end
