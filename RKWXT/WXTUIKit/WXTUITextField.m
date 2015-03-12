//
//  WXTUITextField.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUITextField.h"

@interface WXTUITextField()
{
    CGFloat _leftViewGap;
    CGFloat _textGap;
}
@end

@implementation WXTUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return self;
}

- (void)setPlaceHolder:(NSString*)placeHolder color:(UIColor*)color{
    if(!color || !placeHolder){
        return;
    }
    if([self respondsToSelector:@selector(setAttributedPlaceholder:)]){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        NSDictionary *attributes = @{NSForegroundColorAttributeName:color, NSFontAttributeName: self.font,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:attributes];
    }
}

- (void)setLeftView:(UIView*)leftView leftGap:(CGFloat)leftGap rightGap:(CGFloat)rightGap{
    if(leftGap > 0 || rightGap > 0){
        CGRect rect = leftView.bounds;
        rect.size.width += leftGap + rightGap;
        UIView *aLeftView = [[UIView alloc] initWithFrame:rect];
        rect = leftView.bounds;
        rect.origin.x = leftGap;
        [leftView setFrame:rect];
        [aLeftView addSubview:leftView];
        [self setLeftView:aLeftView];
    }
}

@end
