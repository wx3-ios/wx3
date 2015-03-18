//
//  WXGuideMaskControl.m
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXGuideMaskControl.h"
#import "WXGuidMaskView.h"
#import "WXTipMaskOBJ.h"
#import "UIImage+iPhone5.h"

static NSString *g_imageFileArrays[E_GuideMaskPage_Invalid] ={
    //主界面
    @"homepage_0.png,homepage_1.png,homepage_2.png,homepage_3.png",
    @"sliderSetting_0.png",
    @"callPage_0.png",
    @"callPage_0.png",
    @"callPage_0.png",
};

@interface WXGuideMaskControl()
{
    NSMutableArray *_imageArrays;
}
@end

@implementation WXGuideMaskControl

- (void)dealloc{
    RELEASE_SAFELY(_imageArrays);
    [super dealloc];
}

+ (WXGuideMaskControl*)shared{
    static dispatch_once_t onceToken;
    static WXGuideMaskControl *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXGuideMaskControl alloc] init];
    });
    return sharedInstance;
}

//imageFile用','隔开
- (NSArray*)imagesFromFiles:(NSString*)imgFilesString{
    NSArray *array = [imgFilesString componentsSeparatedByString:@","];
    if(!array || [array count] == 0){
        return nil;
    }
    
    NSMutableArray *imageArray = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *file in array){
        UIImage *img = [UIImage imagePathed:file];
        if(img){
            [imageArray addObject:img];
        }
    }
    return imageArray;
}

- (BOOL)shouldShowGuide:(E_GuideMaskPage)page{
    BOOL ret = YES;
    WXTipMaskOBJ *tipMaskOBJ = [WXTipMaskOBJ sharedTipMaskOBJ];
    switch (page) {
        case E_GuideMask_Homepage:
            ret = ![tipMaskOBJ isHomePageTipMaskRead];
            break;
        case E_GuideMask_Slider_Setting:
            ret = ![tipMaskOBJ isSliderSettingTipMaskRead];
            break;
        case E_GuideMask_KeyBoard:
            ret = ![tipMaskOBJ isKeyPadTipMaskRead];
            break;
        case E_GuideMask_Resent:
            ret = ![tipMaskOBJ isResentTipMaskRead];
            break;
        case E_GuideMask_Contacters:
            ret = ![tipMaskOBJ isContacteTipMaskRead];
            break;
        default:
            break;
    }
    return ret;
}

- (void)showGuideMask:(E_GuideMaskPage)page atView:(UIView*)superView{
    if([self shouldShowGuide:page]){
        CGSize size = superView.bounds.size;
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        NSString *imageFiles = g_imageFileArrays[page];
        NSArray *images = [self imagesFromFiles:imageFiles];
        if(images && [images count] > 0){
            WXGuidMaskView *guideMaskView = [[WXGuidMaskView alloc] initWithFrame:rect guidMaskViewArray:images];
            guideMaskView.eGuideMaskPage = page;
            [superView addSubview:guideMaskView];
            [superView bringSubviewToFront:guideMaskView];
            RELEASE_SAFELY(guideMaskView);
        }
    }
}

@end
