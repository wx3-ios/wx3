//
//  PersonDatePickerVC.m
//  RKWXT
//
//  Created by SHB on 15/6/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "PersonDatePickerVC.h"

@interface PersonDatePickerVC(){
    UIDatePicker *_datePicker;
}
@end

@implementation PersonDatePickerVC
@synthesize delegate = _delegate;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"日期选择"];
    
    CGSize size = self.bounds.size;
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 40;
    
    WXUIButton *selectBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake((size.width-btnWidth)/2, size.height-btnHeight-100, btnWidth, btnHeight);
    [selectBtn setBorderRadian:10.0 width:0.5 color:[UIColor greenColor]];
    [selectBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [selectBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(saveDateInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    
    [self loadDatePicker];
}

-(void)loadDatePicker{
    CGFloat pickerWidth = 280;
    CGFloat pickerHeight = 216;
    CGFloat xOffset = 15;
    CGFloat yOffset = 10;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(xOffset, yOffset, pickerWidth, pickerHeight)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if(_dateString.length != 0){
        NSDate *endDate = [dateFormatter dateFromString:_dateString];
        [_datePicker setDate:endDate];
    }
    NSDate *minDate = [dateFormatter dateFromString:@"1950-01-01"];
    NSDate *maxDate = [dateFormatter dateFromString:@"2099-01-01"];
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    [self addSubview:_datePicker];
}

-(void)saveDateInfo{
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectDate:)]){
        [_delegate didSelectDate:strDate];
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
