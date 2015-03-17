//
//  UIImage+Extend.h
//  UIVoice
//
//  Created by lab on 13-4-23.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define   ImageMaxRate    1.5
#define   ImageMinRate    0.66


#ifndef ImgMaxLen
#define ImgMaxLen 120
#endif

@interface UIImage (Extend)
- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;
- (UIImage*)longerSideFitTo:(CGFloat)len;
- (UIImage *)shorterSideFitTo:(CGFloat )lenght;
- (UIImage *)fixOrientation;
- (NSData*)compress;
- (UIImage *)makeRoundWithcornerWidth:(int)cornerWidth cornerHeight:(int)cornerHeight;
- (UIImage*)makeRoundImage;
- (UIImage *)cropImageInRect:(CGRect)rect;
//截取指定区域视图,并将该区域视图转换成UIImage对象
+(UIImage *)cropImageFrom:(UIView *)aView inRect:(CGRect)rect;
@end
