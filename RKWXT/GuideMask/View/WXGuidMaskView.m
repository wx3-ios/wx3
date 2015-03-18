//
//  WXGuidMaskView.m
//  CallTesting
//
//  Created by le ting on 5/24/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXGuidMaskView.h"
#import "WXTapGuideView.h"
#import "WXMultiGuideView.h"
#import "WXTipMaskOBJ.h"

@interface WXGuidMaskView()<WXMultiGuideViewDelegate,WXMaskViewDelegate>
{
    BOOL _finished;
}
@end

@implementation WXGuidMaskView
@synthesize eGuideMaskPage = _eGuideMaskPage;

- (void)dealloc{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame guidMaskViewArray:(NSArray*)imageArray{
    if(self = [super initWithFrame:frame]){
        
        CGSize size = frame.size;
        CGRect guideFrame = CGRectMake(0, 0, size.width, size.height);
//        
//        WXUIView *maskView = [[WXUIView alloc] initWithFrame:guideFrame];
//        [maskView setBackgroundColor:[UIColor blackColor]];
//        [maskView setAlpha:0.6];
//        [self addSubview:maskView];
        
        NSInteger guideCount = [imageArray count];
        WXUIView *guideView = nil;
        if(guideCount > 1){
            WXMultiGuideView *aGuideView = [[WXMultiGuideView alloc] initWithFrame:guideFrame
                                    guideArray:[self imageViewsWithImages:imageArray]];
            [aGuideView setDelegate:self];
            guideView = aGuideView;
        }else if(guideCount == 1){
            WXTapGuideView *aGuideView = [[WXTapGuideView alloc] initWithFrame:guideFrame image:[imageArray objectAtIndex:0]];
            [aGuideView setDelegate:self];
            guideView = aGuideView;
        }
        if(guideView){
           [self addSubview:guideView];
            RELEASE_SAFELY(guideView);
        }
    }
    return self;
}

//最后一页
- (WXUIView *)lastPage:(UIImage*)image{
    CGSize size = self.bounds.size;
    WXUIView *lastPage = [[[WXUIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    CGSize imgSize = image.size;
    WXUIImageView *imgView = [[[WXUIImageView alloc] initWithFrame:CGRectMake((size.width-imgSize.width)*0.5,
                             0.5*(size.height-imgSize.height), imgSize.width, imgSize.height)] autorelease];
    [imgView setImage:image];
    [lastPage addSubview:imgView];
    return lastPage;
}

- (NSArray*)imageViewsWithImages:(NSArray*)imageArray{
    NSInteger count = [imageArray count];
    NSMutableArray *imgViewArray = [NSMutableArray array];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(int i = 0; i < count; i++){
        UIImage *img = [imageArray objectAtIndex:i];
        if(i != count - 1){
            CGSize imgSize = img.size;
            WXUIImageView *imgView = [[[WXUIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)] autorelease];
            [imgView setImage:img];
            [imgViewArray addObject:imgView];
        }else{
            
            WXUIView *lastView = [self lastPage:img];
            [imgViewArray addObject:lastView];
        }
    }
    [pool drain];
    return imgViewArray;
}

- (void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)guidefinished{
//    if(!_finished){
//        [UtilTool showAlertView:nil message:nil delegate:self tag:0 cancelButtonTitle:@"下次提示" otherButtonTitles:@"不再显示"];
//        _finished = YES;
//    }
    
    WXTipMaskOBJ *tipMaskOBJ = [WXTipMaskOBJ sharedTipMaskOBJ];
    [self disappear];
    switch (_eGuideMaskPage) {
        case E_GuideMask_Homepage:
            [tipMaskOBJ setHomepageTipMaskRead:YES];
            break;
        case E_GuideMask_Slider_Setting:
            [tipMaskOBJ setSliderSettingTipMaskRead:YES];
            break;
        case E_GuideMask_KeyBoard:
            [tipMaskOBJ setKeyPadTipMaskRead:YES];
            break;
        case E_GuideMask_Resent:
            [tipMaskOBJ setResentTipMaskRead:YES];
            break;
        case E_GuideMask_Contacters:
            [tipMaskOBJ setContacteTipMaskRead:YES];
            break;
        default:
            break;
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//}

#pragma mark delegate

- (void)guideDidScrollToEnd{
    [self guidefinished];
}

- (void)maskViewIsClicked{
    [self guidefinished];
}
@end
