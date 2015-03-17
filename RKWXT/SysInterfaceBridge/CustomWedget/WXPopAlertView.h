//
//  WXPopAlertView.h
//  CallTesting
//
//  Created by le ting on 5/12/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

/*只是一个提示~ 点击就会消失*/
#import "WXUIView.h"

typedef enum {
    //从上面显示
    WXPopAlertDirection_Up,
    //从中间显示 默认值
    WXPopAlertDirection_Center,
    
    //自定义位置
    WXPopAlertDirection_Custom,
}WXPopAlertDirection;

@interface WXPopAlertView : WXUIView
@property (nonatomic,assign)WXPopAlertDirection direction;
@property (nonatomic,retain)UIFont *tipFont;
@property (nonatomic,retain)UIColor *tipColor;
@property (nonatomic,assign)CGFloat showTime;

- (id)initWithTip:(NSString*)tip;
- (void)show;
@end
