//
//  UIImage+Extend.m
//  UIVoice
//
//  Created by lab on 13-4-23.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import "UIImage+Extend.h"
#import <QuartzCore/CALayer.h>

@implementation UIImage (Extend)


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

-(UIImage *)makeRoundWithcornerWidth:(int)cornerWidth cornerHeight:(int)cornerHeight
{
	UIImage * newImage = nil;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    [pool drain];
    
    newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return newImage;
}

- (UIImage*)makeRoundImage{
    return [self makeRoundWithcornerWidth:self.size.width*0.5 cornerHeight:self.size.height*0.5];
}

//染色
- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor {
        UIImage *image;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
        }
#else
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
            UIGraphicsBeginImageContext([self size]);
        }
#endif
        CGRect rect = CGRectZero;
        rect.size = [self size];
        [tintColor set];
        UIRectFill(rect);
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef)/2, CGImageGetHeight(subImageRef)/2);
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

//最长边自适应
- (UIImage*)longerSideFitTo:(CGFloat)len
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    if(width <= len && height <= len)
    {
        return self;
    }
    
    CGFloat rat = 1;
    if(width > height)
    {
        rat = len/width;
    }else
    {
        rat = len/height;
    }
    
    width*=rat;
    height*=rat;
    
    int xPos = 0;
    int yPos = 0;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}




//最短边自适应
- (UIImage *)shorterSideFitTo:(CGFloat )lenght
{
    CGSize size = self.size;
    CGFloat min = MIN(size.width, size.height);
    CGFloat rate = size.width / size.height;

    if (min > ImgMaxLen) {
        if (rate <= ImageMaxRate && rate >= ImageMinRate) {
            
//            return [self longerSideFitTo:lenght];
            CGSize newSize;
            if (rate > 1.0) {
                newSize = CGSizeMake(ImgMaxLen * rate, ImgMaxLen);
            } else {
                newSize = CGSizeMake(ImgMaxLen, ImgMaxLen / rate);
            }
            return [self scaleToSize:newSize];
            
        } else {
            
            CGSize newSize;
            if (rate > ImageMaxRate) 
                newSize = CGSizeMake(ImgMaxLen * rate, ImgMaxLen);
             else 
                newSize = CGSizeMake(ImgMaxLen , ImgMaxLen / rate);
            
            UIImage *newImage = [self scaleToSize:newSize];
            
            CGRect r;
            size = newImage.size;
            if (rate > ImageMaxRate)
                r = CGRectMake((size.width - size.height * ImageMaxRate) * 0.5, 0, size.height * ImageMaxRate, size.height);
             else 
                r = CGRectMake(0, (size.height - size.width * ImageMaxRate) * 0.5, size.width, size.width * ImageMaxRate);
            
            return [newImage cropImageInRect:r];
            
        }
        
    } else {
        CGFloat max = MAX(size.width, size.height);
        if (max <= ImageMaxRate * min) {
            return self;
        } else {
            CGRect r;
            if (rate > 1.0) {
                r = CGRectMake((size.width - size.height * ImageMaxRate) * 0.5, 0, size.height * ImageMaxRate, size.height);
            } else {
                r = CGRectMake(0, (size.height - size.width * ImageMaxRate) * 0.5, size.width, size.width * ImageMaxRate);
            }
            
            return [self cropImageInRect:r];

        }
    }
    
}


//等比例缩放
-(UIImage*)scaleToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#define MAXSize CGSizeMake(960, 640)
#define MAXK   200.0

- (UIImage*)scaleTo:(CGFloat)rat
{
    CGFloat width = self.size.width*rat;
    CGFloat height = self.size.height*rat;
    
    int iWidth = (int)width;
    int iHeight = (int)height;
    
    return [self scaleToSize:CGSizeMake(iWidth, iHeight)];
}

- (BOOL)shouldCompressSize
{
    CGFloat curWidth = self.size.width;
    CGFloat curHeight = self.size.height;
    if(curWidth *curHeight > MAXSize.width*MAXSize.height)
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (NSData*)compress
{
    //先将尺寸缩放
    if([self shouldCompressSize])
    {
        CGSize size = self.size;
        double originSize = size.width*size.height;
        double rat = (MAXSize.width*MAXSize.height)/originSize;
        rat = sqrt(rat);
        self = [self scaleTo:rat];
    }
    //再压缩图片
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    CGFloat currentImgK = (float)data.length/1024.0;
    CGFloat rat = MAXK/currentImgK;
    if (rat < 1)
    {
        NSData *newData = UIImageJPEGRepresentation(self, rat);
        return newData;
    }
    return data;
}

+(UIImage *)cropImageFrom:(UIView *)aView inRect:(CGRect)rect
{
    CGSize cropImageSize = rect.size;
    UIGraphicsBeginImageContext(cropImageSize);
    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -(rect.origin.x), -(rect.origin.y));
    [aView.layer renderInContext:resizedContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)cropImageInRect:(CGRect)rect {
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}


@end
