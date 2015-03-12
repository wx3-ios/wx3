
#import "CalendarView.h"

#define Size self.bounds.size
#define Year   (2015)
#define Month  (01)
#define Day    (18)
#define xGap   (10)
#define yGap   (40)

@interface CalendarView(){
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
}
@end
@implementation CalendarView

-(void)dealloc{
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        [self setBackgroundColor:WXColorWithInteger(0x5B4A4D)];
//        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
//        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
//        [self addGestureRecognizer:swipeleft];
//        UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
//        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
//        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self setCalendarParameters];
    _weekNames = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    int weekday = (int)[comps weekday];
    weekday  = weekday - 2;
    
    if(weekday < 0){
        weekday += 7;
    }
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = 40;
    NSInteger originX = 20;
    NSInteger originY = 60;
    NSInteger monthLength = days.length;
    
    CGFloat xgap = 110;
    UIImageView *_imgview = [[UIImageView alloc] init];
    _imgview.frame = CGRectMake(xgap, 20, 15, 15);
    [_imgview setImage:[UIImage imageNamed:@"kalendarSIcon.png"]];
    [self addSubview:_imgview];
    
    xgap += 20;
    UILabel *titleText = [[UILabel alloc]initWithFrame:CGRectMake(xgap, 15, 100, 25)];
    titleText.textAlignment = NSTextAlignmentLeft;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MMMM"];
    NSString *dateString = [format stringFromDate:self.calendarDate];
    NSString *chineseStr = [[self class] englishChangeToChineseWithStr:dateString];
    [titleText setText:chineseStr];
    [titleText setFont:[UIFont systemFontOfSize:14.0]];
    [titleText setTextColor:[UIColor whiteColor]];
    [self addSubview:titleText];
    
    CGFloat xOffset = 15;
    CGFloat yOffset = 15;
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHeight);
    [leftBtn setImage:[UIImage imageNamed:@"signLeftP.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(swiperight:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Size.width-2*xGap-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [rightBtn setImage:[UIImage imageNamed:@"signRightP.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(swipeleft:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(originX/2, originY, self.bounds.size.width-2*originX/2, 275);
    [label setBackgroundColor:WXColorWithInteger(0xFEFEFE)];
    [self addSubview:label];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.frame = CGRectMake(originX/2, 275+originY, self.bounds.size.width-2*originX/2, 2);
    [lineImg setImage:[UIImage imageNamed:@"kalendarDown.png"]];
    [self addSubview:lineImg];
    
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setBackgroundColor:WXColorWithInteger(0xF4E7EB)];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setFrame:CGRectMake(originX/2+(width*(i%columns)), originY, width, 25)];
        [weekNameLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
    }
    
    for (int i= 0; i<monthLength; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.titleLabel.text = [NSString stringWithFormat:@"%d",i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, width-20, width-24)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setEnabled:NO];
//        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width*((i+weekday)/columns));
        [button setFrame:CGRectMake(originX/2+offsetX, originY+25+offsetY, width, width)];
        [button.layer setBorderColor:[WXColorWithInteger(0xE2E2E2) CGColor]];
        [button.layer setBorderWidth:0.7];
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:WXColorWithInteger(0xE2E2E2)];
        if(((i+weekday)/columns)==0){
            [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 0)];
            [button addSubview:lineView];
        }

        if(((i+weekday)/columns)==((monthLength+weekday-1)/columns)){
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 0)];
            [button addSubview:lineView];
        }
        
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor redColor]];
        if((i+weekday)%7==0){
            [columnView setFrame:CGRectMake(0, 0, 0, button.frame.size.width)];
            [button addSubview:columnView];
        }
        else if((i+weekday)%7==6){
            [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 0, button.frame.size.width)];
            [button addSubview:columnView];
        }
        
        UIImageView *imgIcon = [[UIImageView alloc] init];
        imgIcon.frame = CGRectMake(originX/2+offsetX+10, originY+25+offsetY+15, width-20, width-20);
        [imgIcon setImage:[UIImage imageNamed:@"waitSignIcon.png"]];
        [imgIcon setHidden:YES];
        [self addSubview:imgIcon];
        BOOL show = [self showSignIconWithYear:components.year withMonth:components.month withDay:i+1];
        if(show){
            [imgIcon setHidden:NO];
        }
        
        //当天
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear){
            NSString *monthStr = [self changeMonth:_selectedMonth];
            NSString *dayStr = [self changechangeDay:_selectedDate];
            [titleText setText:[NSString stringWithFormat:@"%d-%@-%@",_selectedYear,monthStr,dayStr]];
        }
        if(i+1 == Day && components.month == Month && components.year == Year){
            CGRect rect = imgIcon.frame;
            rect.size.width = 20;
            rect.size.height = 20;
            [imgIcon setFrame:rect];
            [imgIcon setImage:[UIImage imageNamed:@"signed.png"]];
        }
        [self addSubview:button];
    }
    
    NSDateComponents *previousMonthComponents = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
//    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
//    NSRange previousMonthDays = [c rangeOfUnit:NSDayCalendarUnit
//                   inUnit:NSMonthCalendarUnit
//                  forDate:previousMonthDate];
//    NSInteger maxDate = previousMonthDays.length - weekday;
    
    
    for (int i=0; i<weekday; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)(maxDate+i+1)];
//        [button setTitle:[NSString stringWithFormat:@"%ld",(long)(maxDate+i+1)] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width *(i/columns));
        [button setFrame:CGRectMake(originX/2+offsetX, originY+25+offsetY, width, width)];
        [button.layer setBorderWidth:0.7];
        [button.layer setBorderColor:[WXColorWithInteger(0xE2E2E2) CGColor]];
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:WXColorWithInteger(0xE2E2E2)];
        if(i == 0){
            [columnView setFrame:CGRectMake(0, 0, 0.7, button.frame.size.width)];
            [button addSubview:columnView];
        }

        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:WXColorWithInteger(0xE2E2E2)];
        [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 0)];
        [button addSubview:lineView];
        [button setTitleColor:[UIColor colorWithRed:229.0/255.0 green:231.0/255.0 blue:233.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button setEnabled:NO];
        [self addSubview:button];
    }
    
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays > 0){
        for (NSInteger i=remainingDays; i<columns; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)((i+1)-remainingDays)];
//            [button setTitle:[NSString stringWithFormat:@"%ld",(long)((i+1)-remainingDays)] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [button setFrame:CGRectMake(originX/2+offsetX, originY+25+offsetY, width, width)];
            [button.layer setBorderWidth:0.7];
            [button.layer setBorderColor:[WXColorWithInteger(0xE2E2E2) CGColor]];
            UIView *columnView = [[UIView alloc]init];
            [columnView setBackgroundColor:WXColorWithInteger(0xE2E2E2)];
            if(i==columns - 1){
                [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 0, button.frame.size.width)];
                [button addSubview:columnView];
            }
            UIView *lineView = [[UIView alloc]init];
            [lineView setBackgroundColor:WXColorWithInteger(0xE2E2E2)];
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 0)];
            [button addSubview:lineView];
//            [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [button setEnabled:NO];
            [self addSubview:button];
        }
    }
}
-(IBAction)tappedDate:(UIButton *)sender{
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year])){
        if(_selectedDate != -1){
            UIButton *previousSelected =(UIButton *) [self viewWithTag:_selectedDate];
            [previousSelected setBackgroundColor:[UIColor clearColor]];
            [previousSelected setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        }
        
        [sender setBackgroundColor:[UIColor brownColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedDate = sender.tag;
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        NSDate *clickedDate = [gregorian dateFromComponents:components];
        [self.delegate tappedOnDate:clickedDate];
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay];
                    }
                    completion:nil];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay];
                    }
                    completion:nil];
}

-(void)setCalendarParameters{
    if(gregorian == nil){
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}

-(BOOL)showSignIconWithYear:(NSInteger)year withMonth:(NSInteger)month withDay:(NSInteger)day{
    BOOL show = NO;
    if(year>=2015 && month>=1 && day>=1){
        show = YES;
    }
    return show;
}

-(NSString*)changeMonth:(NSInteger)month{
    NSString *str = nil;
    if(month>0 && month<10){
        str = [NSString stringWithFormat:@"0%ld",(long)month];
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)month];
    }
    return str;
}

-(NSString*)changechangeDay:(NSInteger)day{
    NSString *str = nil;
    if(day>0 && day<10){
        str = [NSString stringWithFormat:@"0%ld",(long)day];
    }else{
        str = [NSString stringWithFormat:@"%ld",(long)day];
    }
    return str;
}

+(NSString*)englishChangeToChineseWithStr:(NSString*)oldStr{
    NSString *chineseStr = nil;
    NSString *str1 = [oldStr substringWithRange:NSMakeRange(0, 4)];
    NSString *str = [oldStr substringFromIndex:5];
    if([str isEqualToString:@"一月"]){
        chineseStr = @"01";
    }
    if([str isEqualToString:@"二月"]){
        chineseStr = @"02";
    }
    if([str isEqualToString:@"三月"]){
        chineseStr = @"03";
    }
    if([str isEqualToString:@"四月"]){
        chineseStr = @"04";
    }
    if([str isEqualToString:@"五月"]){
        chineseStr = @"05";
    }
    if([str isEqualToString:@"六月"]){
        chineseStr = @"06";
    }
    if([str isEqualToString:@"七月"]){
        chineseStr = @"07";
    }
    if([str isEqualToString:@"八月"]){
        chineseStr = @"08";
    }
    if([str isEqualToString:@"九月"]){
        chineseStr = @"09";
    }
    if([str isEqualToString:@"十月"]){
        chineseStr = @"10";
    }
    if([str isEqualToString:@"十一月"]){
        chineseStr = @"11";
    }
    if([str isEqualToString:@"十二月"]){
        chineseStr = @"12";
    }
    NSString *newStr = [NSString stringWithFormat:@"%@-%@",str1,chineseStr];
    return newStr;
}

@end
