#import <UIKit/UIKit.h>
#import "UIImage+KIAdditions.h"

@class KICropImageMaskView;
@interface KICropImageView : UIView

- (void)setImage:(UIImage *)image;
- (void)setCropSize:(CGSize)size;
- (UIImage *)cropImage;
@end

@interface KICropImageMaskView : UIView {
    @private
    CGRect  _cropRect;
}
- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;
@end