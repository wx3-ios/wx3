//
//  ButtonWithTitleView.h
//  CallUITest
//
//  Created by Elty.Le on 12/19/13.
//  Copyright (c) 2013 Elty.Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PingponeButtonDelegate <NSObject>
- (void)touchUpInside:(id)sender;
@end
@interface PingponeButton : UIView{
    id<PingponeButtonDelegate> mDelegate;
    //是否为乒乓按钮
    BOOL mbPingpongButton;
}
@property (nonatomic,assign)id<PingponeButtonDelegate> delegate;
@property (nonatomic,assign)BOOL bPingpongButton;
@property (nonatomic,retain)id buttonInfo;

//图片+文字
- (void)setNormalImage:(UIImage*)normalImage selectImage:(UIImage*)selectImage disableImage:(UIImage*)disableImage
                 title:(NSString*)title font:(UIFont*)font
           normalColor:(UIColor*)normalColor selectColor:(UIColor*)selectColor disableColor:(UIColor*)disableColor;
//图片,没有文字
- (void)setNormalImage:(UIImage*)normalImage selectImage:(UIImage*)selectImage disableImage:(UIImage*)disableImage;
- (BOOL)isSelected;
- (void)setEnable:(BOOL)enable;
- (void)setSelected:(BOOL)selected;
@end
