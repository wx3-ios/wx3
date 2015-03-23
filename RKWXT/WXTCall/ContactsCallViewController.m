//
//  IncomingCallViewController.m
//  WjtCall
//
//  Created by jjyo.kwan on 14-2-25.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//



#import "ContactsCallViewController.h"
#import "WXTMallVC.h"
#import "WXContacterVC.h"

@interface ContactsCallViewController (){
    
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
    [self loadSegmentControl];
    [NOTIFY_CENTER postNotificationName:@"SegmentControlChange" object:_segmentControl];
    [NOTIFY_CENTER addObserver:self selector:@selector(segmentControlChange:) name:@"SegmentControlChange" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loadSegmentControl{
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:nameArr];
    _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT - 12, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((IPHONE_SCREEN_WIDTH-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:0];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
#endif
    [_segmentControl setBorderRadian:1.0 width:0.2 color:[UIColor grayColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:_segmentControl];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    WXTMallVC * mallVC = [[WXTMallVC alloc] init];
    WXContacterVC * contacterVC = [[WXContacterVC alloc] init];
    selectedSegmentIndex = segmentControl.selectedSegmentIndex;
    switch (selectedSegmentIndex) {
        case kCallSegmentIndex:
            [self.view addSubview:mallVC.view];
            break;
        case kContactsSegmentIndex:
            [self.view addSubview:contacterVC.view];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


