//
//  WXImageClipeOBJ.m
//  Woxin2.0
//
//  Created by le ting on 6/17/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXImageClipOBJ.h"
#import "WXImageClipVC.h"
#import "UIImage+KIAdditions.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <math.h>


#define kImageDataMaxLength (1000*180) //400k
#define kMaxScale (3.0)
enum{
    E_ImagePickerMode_Camera,
    E_ImagePickerMode_PhoneLabrary,
};
@interface WXImageClipOBJ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WXImageClipVCDelegate>
{
}
@end

@implementation WXImageClipOBJ
@synthesize parentVC = _parentVC;
@synthesize tagInfo = _tagInfo;
@synthesize clipImageType = _clipImageType;
@synthesize delegate = _delegate;

- (void)dealloc{
    _delegate = nil;
}

- (CGSize)clipImageSize:(E_Image_Type)type{
    CGSize size = CGSizeMake(IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    CGSize sizeRequired = CGSizeZero;
    switch (type) {
        case E_ImageType_Good_Top:
            sizeRequired = kGoodTopImageSize;
            break;
        case E_ImageType_Good_Icon:
            sizeRequired = kGoodIconSize;
            break;
        case E_ImageType_Good_DetailTop:
            sizeRequired = kGoodImageDetailTop;
            break;
        case E_ImageType_Message_Image:
            sizeRequired = kMessageImage;
            break;
        case E_ImageType_Personal_Img:
            sizeRequired = kPersonalHeadImgSize;
            break;
        default:
            break;
    }
    if(size.width < sizeRequired.width){
        size.height = (size.width/sizeRequired.width)*sizeRequired.height;
    }else{
        size = sizeRequired;
    }
    return size;
}

- (CGRect)clipImageFrame:(E_Image_Type)type{
    CGSize size = [self clipImageSize:type];
    CGSize parentSize = _parentVC.view.bounds.size;
    return CGRectMake(0.5*(parentSize.width-size.width), 0.5*(parentSize.height-size.height),size.width,size.height);
}

- (void)beginChooseAndClipeImage{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:_parentVC.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case E_ImagePickerMode_Camera:
            // 拍照
            if ([WXUIImagePickerController isCameraAvailable] && [WXUIImagePickerController doesCameraSupportTakingPhotos]) {
                WXUIImagePickerController *imagePickerController = [[WXUIImagePickerController alloc] init];
                [imagePickerController setDelegate:self];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                imagePickerController.mediaTypes = mediaTypes;
                [_parentVC presentViewController:imagePickerController animated:YES completion:^{
                }];
            }
            break;
        case E_ImagePickerMode_PhoneLabrary:
            // 从相册中选取
            if ([WXUIImagePickerController isPhotoLibraryAvailable]) {
                WXUIImagePickerController *imagePickerController = [[WXUIImagePickerController alloc] init];
                [imagePickerController setDelegate:self];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                imagePickerController.mediaTypes = mediaTypes;
                [_parentVC presentViewController:imagePickerController animated:YES completion:^{
                }];
            }
            break;
        default:
            break;
    }
}

#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [_parentVC showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@"准备图片裁剪"];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        image = [UIImage imageWithData:data];
        image = [image fixOrientation];
        WXImageClipVC *imageClipeVC = [[WXImageClipVC alloc] init];
        [imageClipeVC setDelegate:self];
        [imageClipeVC setClipSize:[self clipImageSize:_clipImageType]];
        [imageClipeVC setImage:image];
        [_parentVC presentViewController:imageClipeVC animated:YES completion:^{
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if(_delegate && [_delegate respondsToSelector:@selector(imageClipeCanceled:)]){
            [_delegate imageClipeCanceled:self];
        }
    }];
}

#pragma mark VPImageCropperDelegate

- (CGFloat)maxSizeOfImageType:(E_Image_Type)imageType{
    CGFloat imageLength = kImageDataMaxLength;
    switch (imageType) {
        case E_ImageType_Personal_Img:
            imageLength = 64*1024;
            break;
        default:
            break;
    }
    return imageLength;
}

- (void)imageClipFinshed:(WXImageClipVC*)imageClipVC image:(UIImage*)image{
    if(_delegate && [_delegate respondsToSelector:@selector(imageClipeFinished:finalImageData:)]){
        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
        NSInteger imgDataLength = imgData.length;
        CGFloat rat = ((CGFloat)[self maxSizeOfImageType:_clipImageType])/(CGFloat)imgDataLength;
        if(rat < 1.0){
            imgData = UIImageJPEGRepresentation(image, sqrtf(rat));
            //            image = [UIImage imageWithData:imgData];
        }
        KFLog_Normal(YES, @"cliped image size = %d",(int)imgData.length);
        [_delegate imageClipeFinished:self finalImageData:imgData];
    }
    [imageClipVC dismissViewControllerAnimated:YES completion:^{
        [_parentVC unShowWaitView];
    }];
}

- (void)imageClipCanceled:(WXImageClipVC*)imageClipVC{
    if(_delegate && [_delegate respondsToSelector:@selector(imageClipeCanceled:)]){
        [_delegate imageClipeCanceled:self];
    }
    [imageClipVC dismissViewControllerAnimated:YES completion:^{
        [_parentVC unShowWaitView];
    }];
}
- (void)imageClipFailed:(WXImageClipVC*)imageClipVC{
    if(_delegate && [_delegate respondsToSelector:@selector(imageClipeFailed:)]){
        [_delegate imageClipeFailed:self];
    }
    [imageClipVC dismissViewControllerAnimated:YES completion:^{
        [_parentVC unShowWaitView];
    }];
}
@end
