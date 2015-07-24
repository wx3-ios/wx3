//
//  ShareBrowserView.h
//  RKWXT
//
//  Created by SHB on 15/7/24.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXUIView.h"

enum{
    Share_Type_Qq,
    Share_Type_Qzone,
    Share_Type_WxFriends,
    Share_Type_WxCircle,
    
    Share_Type_Invalid,
};

@protocol ShareBrowserViewDelegate;

@interface ShareBrowserView : WXUIView
@property (nonatomic,assign) id<ShareBrowserViewDelegate>delegate;

-(void)showShareThumbView:(UIView*)thumbView toDestview:(UIView*)destView withImage:(UIImage*)image;
@end

@protocol ShareBrowserViewDelegate <NSObject>
-(void)sharebtnClicked:(NSInteger)index;

@end
