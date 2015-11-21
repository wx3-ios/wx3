//
//  HeardTopView.m
//  RKWXT
//
//  Created by app on 15/11/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HeardTopView.h"
#import "ToSnapUp.h"

@interface HeardTopView ()
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *hourLabel;
@property (nonatomic,strong)UILabel *mainuteLabel;
@property (nonatomic,strong)UILabel *secodeLabel;
@end

@implementation HeardTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat widch = self.frame.size.width / 2 ;
        CGFloat heifht = self.frame.size.height;
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, widch, heifht)];
        titlelabel.font = [UIFont systemFontOfSize:15];
        titlelabel.textAlignment = NSTextAlignmentLeft;
        titlelabel.text = @"提前抢";
        
        [self addSubview:titlelabel];
        
//        UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(widch , 0, widch, heifht)];
//        timelabel.font = [UIFont systemFontOfSize:15];
//        timelabel.textAlignment = NSTextAlignmentLeft;
//        timelabel.text = @"       剩余";
//        [self addSubview:timelabel];
//        self.timeLabel = timelabel;
//        
//        CGSize size = [NSString sizeWithString:timelabel.text font:[UIFont systemFontOfSize:15]];
//        CGFloat timeH =( heifht - size.height ) / 2;
//        //        UIView *timeView = [[UIView alloc]init];
//        //        timeView.center = timelabel.center;
//        //        timeView.width = 150;
//        //        timeView.height = 20;
//        //        timeView.backgroundColor = [UIColor redColor];
//        //        [timelabel addSubview:timeView];
//        
//        
//        UILabel *hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(widch - 80, timeH, 20, 20)];
//        hourLabel.backgroundColor = [UIColor blackColor];
//        hourLabel.textColor = [UIColor whiteColor];
//        hourLabel.layer.cornerRadius = 2;
//        hourLabel.layer.masksToBounds = YES;
//        [self.timeLabel addSubview:hourLabel];
//        self.hourLabel = hourLabel;
//        
//        UILabel *mainute = [[UILabel alloc]initWithFrame:CGRectMake(hourLabel.right, timeH,10, 20)];
//        mainute.backgroundColor = [UIColor whiteColor];
//        mainute.tintColor = [UIColor blackColor];
//        mainute.textAlignment = NSTextAlignmentCenter;
//        mainute.text = @":";
//        [self.timeLabel addSubview:mainute];
//        
//        UILabel *mainuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainute.right, timeH, 20, 20)];
//        mainuteLabel.backgroundColor = [UIColor blackColor];
//        mainuteLabel.textColor = [UIColor whiteColor];
//        mainuteLabel.layer.cornerRadius = 2;
//        mainuteLabel.layer.masksToBounds = YES;
//        [self.timeLabel addSubview:mainuteLabel];
//        self.mainuteLabel = mainuteLabel;
//        
//        UILabel *secode = [[UILabel alloc]initWithFrame:CGRectMake(mainuteLabel.right, timeH,10, 20)];
//        secode.backgroundColor = [UIColor whiteColor];
//        secode.tintColor = [UIColor blackColor];
//        secode.textAlignment = NSTextAlignmentCenter;
//        secode.text = @":";
//        [self.timeLabel addSubview:secode];
//        
//        UILabel *secodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(secode.right, timeH, 20, 20)];
//        secodeLabel.backgroundColor = [UIColor blackColor];
//        secodeLabel.textColor = [UIColor whiteColor];
//        secodeLabel.layer.cornerRadius = 2;
//        secodeLabel.layer.masksToBounds = YES;
//        [self.timeLabel addSubview:secodeLabel];
//        self.secodeLabel = secodeLabel;
//        
//        
//        //倒计时
//        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(OpenTime) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop]addTimer:time forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)OpenTime{
    NSString *str = @"2015/11/30 14:22:00";
    NSDateFormatter *mat = [[NSDateFormatter alloc]init];
    mat.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate *olddate = [mat dateFromString:str];
    
    NSDate *now = [NSDate date];
    //创建日历对象
    NSCalendar *dar = [NSCalendar currentCalendar];
    //获取比较参数 枚举
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comp =  [dar components:unit fromDate:now toDate:olddate options:0];
    self.hourLabel.text = [NSString stringWithFormat:@"%ld",(long)comp.hour];
    self.mainuteLabel.text = [NSString stringWithFormat:@"%ld",(long)comp.minute];
    self.secodeLabel.text = [NSString stringWithFormat:@"%ld",(long)comp.second];
}



@end
