//
//  IncomingCallViewController.m
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//



#import "ContactsCallViewController.h"
#import "CallViewController.h"
#import "WXContacterVC.h"

@interface ContactsCallViewController (){
    CallViewController * _recentCall;
    WXContacterVC * _contacterVC;
}

@end

@implementation ContactsCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _recentCall = [[CallViewController alloc]init];
    _contacterVC = [[WXContacterVC alloc] init];
    [self.view addSubview:_recentCall.view];
    [self loadSegmentControl];
    [self addNotification];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loadInputTextField{
    inputText = [[UITextField alloc]initWithFrame:CGRectMake(20, 25, ScreenWidth - 40, 30)];
    [self.navigationController.navigationBar addSubview:inputText];
}

-(void)loadSegmentControl{
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl
    = [[UISegmentedControl alloc] initWithItems:nameArr];
    _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT - 12, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
#endif
    [_segmentControl setBorderRadian:1.0 width:0.2 color:[UIColor grayColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:_segmentControl];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case kCallSegmentIndex:
            [self.view addSubview:_recentCall.view];
            break;
        case kContactsSegmentIndex:
            [self.view addSubview:_contacterVC.view];
            break;
        default:
            break;
    }
}

-(void)addNotification{
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(inputChange) name:kInputChange object:nil];
}

-(void)inputChange{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
}

@end


