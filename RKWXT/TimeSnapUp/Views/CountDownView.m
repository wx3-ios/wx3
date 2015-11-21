//
//  CountDownView.m
//  RKWXT
//
//  Created by app on 15/11/18.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CountDownView.h"
#import "ToSnapUp.h"
@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat height = self.height;
        UILabel *hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, 20, 20)];
        hourLabel.backgroundColor = [UIColor blackColor];
        hourLabel.textColor = [UIColor whiteColor];
        hourLabel.layer.cornerRadius = 2;
        hourLabel.layer.masksToBounds = YES;
        [self addSubview:hourLabel];
        self.hourLabel = hourLabel;
        
        UILabel *mainute = [[UILabel alloc]initWithFrame:CGRectMake(hourLabel.right, height,10, 20)];
        mainute.backgroundColor = [UIColor whiteColor];
        mainute.tintColor = [UIColor blackColor];
        mainute.textAlignment = NSTextAlignmentCenter;
        mainute.text = @":";
        [self addSubview:mainute];
        
        UILabel *mainuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainute.right, height, 20, 20)];
        mainuteLabel.backgroundColor = [UIColor blackColor];
        mainuteLabel.textColor = [UIColor whiteColor];
        mainuteLabel.layer.cornerRadius = 2;
        mainuteLabel.layer.masksToBounds = YES;
        [self addSubview:mainuteLabel];
        self.mainuteLabel = mainuteLabel;
        
        UILabel *secode = [[UILabel alloc]initWithFrame:CGRectMake(mainuteLabel.right, height,10, 20)];
        secode.backgroundColor = [UIColor whiteColor];
        secode.tintColor = [UIColor blackColor];
        secode.textAlignment = NSTextAlignmentCenter;
        secode.text = @":";
        [self addSubview:secode];
        
        UILabel *secodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(secode.right, height, 20, 20)];
        secodeLabel.backgroundColor = [UIColor blackColor];
        secodeLabel.textColor = [UIColor whiteColor];
        secodeLabel.layer.cornerRadius = 2;
        secodeLabel.layer.masksToBounds = YES;
        [self addSubview:secodeLabel];
        self.secodeLabel = secodeLabel;
        
    }
    return self;
}
@end
