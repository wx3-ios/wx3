//
//  ShareView.m
//  test
//
//  Created by app on 16/4/20.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ShareView.h"

#define Size [UIScreen mainScreen].bounds.size
#define MenHeight (160)
#define LabelH  (40)

@interface ShareView ()
{
    UIView *_shellView;
    UIButton *_backMengView;
}
@end
@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _shellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
        _shellView.backgroundColor = [UIColor blackColor];
        _shellView.alpha = 0.0;
        [self addSubview:_shellView];
        
        _backMengView = [[UIButton alloc]initWithFrame:CGRectMake(0, Size.height + MenHeight, Size.width, MenHeight)];
        _backMengView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backMengView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _backMengView.frame.size.width, LabelH)];
        label.text = @"分享";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [_backMengView addSubview:label];
        
        
     NSArray *imgArr = @[[UIImage imageNamed:@"ShareWxFriendImg.png"],[UIImage imageNamed:@"ShareQqImg.png"],[UIImage imageNamed:@"ShareWxCircleImg.png"],[UIImage imageNamed:@"ShareQzoneImg.png"]];
       NSArray *titArr = @[@"微信",@"QQ好友",@"朋友圈",@"QQ空间"];
        
        CGFloat width = 45;
        CGFloat margin = (Size.width - (width * [titArr count]) ) / ([titArr count] + 1);
        for (int i = 0; i < [imgArr count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(margin + ((width + margin) * i), LabelH, width, width);
            [button setImage:imgArr[i] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
            [_backMengView addSubview:button];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height, button.frame.size.width, 15)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titArr[i];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor blackColor];
            [_backMengView addSubview:label];
        }
        
        UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(0, LabelH + width + 15 + 5, Size.width, 0.5)];
        didView.alpha = 0.5;
        didView.backgroundColor = [UIColor grayColor];
        [_backMengView addSubview:didView];
        
        
        CGFloat disY = didView.frame.origin.y + didView.frame.size.height;
        UIButton *missBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, disY, Size.width, MenHeight - disY)];
        [missBtn setTitle:@"取消" forState:UIControlStateNormal];
        [missBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [missBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchDown];
        [_backMengView  addSubview:missBtn];
    }
    return self;
}

- (void)addSuperView:(UIView*)supView{
    [UIView animateWithDuration:0.5 animations:^{
         [supView addSubview:self];
        _shellView.alpha = 0.6;
        _backMengView.frame = CGRectMake(0, Size.height - MenHeight, Size.width, MenHeight);
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self unShowView];
}

- (void)clickBtn:(UIButton*)btn{
    [self unShowView];
    if (_delegate && [_delegate respondsToSelector:@selector(shareViewClickBtnTag:)]) {
        [self.delegate shareViewClickBtnTag:btn.tag];
    }
    
}

- (void)cancelBtn{
    [self unShowView];
}


- (void)unShowView{
    [UIView animateWithDuration:0.5 animations:^{
        _backMengView.frame = CGRectMake(0, Size.height + MenHeight, Size.width, MenHeight);
        _shellView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
}
@end
