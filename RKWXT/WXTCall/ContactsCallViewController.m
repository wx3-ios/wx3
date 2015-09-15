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
#import "CallBackVC.h"
#import "ContactDetailVC.h"
#import "ContacterEntity.h"
#import "WXContacterModel.h"
#import "UIImage+Render.h"
#import "RFSegmentView.h"

#define Size self.view.bounds.size

@interface ContactsCallViewController ()<ToContactDetailVCDelegate,CallPhoneDelegate,RFSegmentViewDelegate>{
    CallViewController * _recentCall;
    WXContacterVC * _contacterVC;
    UILabel *numberLabel;
    NSString *numberStr;
    
    WXContacterModel *contactModel;
}

@end

@implementation ContactsCallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addNotification];
    [_recentCall addNotification];   //在此为通话界面添加通知可确保不重复
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _contacterVC = [[WXContacterVC alloc] init];
    [_contacterVC.view setFrame:CGRectMake(0, yGap, Size.width, Size.height-yGap)];
    [_contacterVC setDetailDelegate:self];
    
    _recentCall = [[CallViewController alloc]init];
    [_recentCall.view setFrame:CGRectMake(0, yGap, Size.width, Size.height-yGap)];
    [_recentCall setKeyPad_type:E_KeyPad_Show];
    [_recentCall setCallDelegate:self];
    
    [self.view addSubview:_recentCall.view];
    [self loadSegmentControl];
    
    contactModel = [[WXContacterModel alloc] init];
}

-(void)selectSegmentToIndexOne{
//    if(_segmentControl.selectedSegmentIndex == 1){
//        [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
//        [self segmentControlChange:_segmentControl];
//    }
}

-(void)loadSegmentControl{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:imgView];
    
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    
    for (int i=0; i<1; i++) {
        self.segmentControl = [[RFSegmentView alloc] initWithFrame:CGRectMake((Size.width-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT+10, segWidth, segHeight) items:@[@"通话",@"通讯录"]];
        self.segmentControl.tintColor = [UIColor redColor];
        self.segmentControl.delegate = self;
        [self.view addSubview:self.segmentControl];
    }
    
//    NSArray *nameArr = @[@"通话",@"通讯录"];
//    _segmentControl
//    = [[UISegmentedControl alloc] initWithItems:nameArr];
//    _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT + 10, segWidth, segHeight);
//    if(isIOS6){
//        _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
//    }
//    [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
//    _segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
//#endif
//    [_segmentControl setBorderRadian:5.0 width:1 color:[UIColor whiteColor]];  //0x2c97df
//    [_segmentControl setBackgroundColor:[UIColor whiteColor]];
//    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:_segmentControl];
}

-(void)segmentViewSelectIndex:(NSInteger)index{
    switch (index) {
        case kCallSegmentIndex:
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            _recentCall.keyPad_type = E_KeyPad_Down;
            [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
            [self.view addSubview:_recentCall.view];
            break;
        case kContactsSegmentIndex:
            [[NSNotificationCenter defaultCenter] postNotificationName:HideDownView object:nil];
            [self.view addSubview:_contacterVC.view];
            break;
        default:
            break;
    }
}

//-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
//    switch (segmentControl.selectedSegmentIndex) {
//        case kCallSegmentIndex:
//            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//            _recentCall.keyPad_type = E_KeyPad_Down;
//            [[NSNotificationCenter defaultCenter] postNotificationName:ShowKeyBoard object:nil];
//            [self.view addSubview:_recentCall.view];
//            break;
//        case kContactsSegmentIndex:
//            [[NSNotificationCenter defaultCenter] postNotificationName:HideDownView object:nil];
//            [self.view addSubview:_contacterVC.view];
//            break;
//        default:
//            break;
//    }
//}

-(void)addNotification{
    [NOTIFY_CENTER removeObserver:self];
    [NOTIFY_CENTER addObserver:self selector:@selector(selectSegmentToIndexOne) name:ClickedKeyboardBtn object:nil];
}

-(void)callPhoneWith:(NSString *)phoneStr andPhoneName:(NSString *)phoneName{
    numberStr = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
    CallBackVC *callBackVC = [[CallBackVC alloc] init];
    [callBackVC setPhoneName:phoneName];
    if([callBackVC callPhone:numberStr]){
        [self presentViewController:callBackVC animated:YES completion:^{
        }];
    }
}

-(void)toContailDetailVC:(id)sender{
    ContactDetailVC * detailVC = [[ContactDetailVC alloc] init];
    ContacterEntity *entity = sender;
    detailVC.model = entity;
    [self.wxNavigationController pushViewController:detailVC];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NOTIFY_CENTER postNotificationName:kTableViewHidden object:nil];
    [NOTIFY_CENTER removeObserver:self];
    [_recentCall reloadData];
    [_recentCall setEmptyText];
    [_recentCall setKeyPad_type:E_KeyPad_Down];
}

@end


