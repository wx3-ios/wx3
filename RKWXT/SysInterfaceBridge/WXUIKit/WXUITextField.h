//
//  WXUITextField.h
//  CallTesting
//
//  Created by le ting on 5/13/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXUITextField : UITextField

- (void)setLeftView:(UIView*)leftView leftGap:(CGFloat)leftGap rightGap:(CGFloat)rightGap;
- (void)setPlaceHolder:(NSString*)placeHolder color:(UIColor*)color;
@end
