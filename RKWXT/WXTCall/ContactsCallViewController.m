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
#import "CallModel.h"
#import "CallBackVC.h"
#import "ContactDetailVC.h"
#import "ContacterEntity.h"
#import "WXContacterModel.h"

#define Size self.view.bounds.size

@interface ContactsCallViewController ()<MakeCallDelegate,ToContactDetailVCDelegate,UITableViewDataSource,UITableViewDelegate,CallPhoneDelegate>{
    CallViewController * _recentCall;
    WXContacterVC * _contacterVC;
    UILabel *numberLabel;
    NSString *numberStr;
    
    CallModel *_callModel;
    UITableView *_tableView;
    WXContacterModel *contactModel;
}

@end

@implementation ContactsCallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _callModel = [[CallModel alloc] init];
    [_callModel setCallDelegate:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _recentCall = [[CallViewController alloc]init];
    [_recentCall.view setFrame:CGRectMake(0, 72, Size.width, Size.height-72-50)];
    [_recentCall setKeyPad_type:E_KeyPad_Show];
    [_recentCall setCallDelegate:self];
    
    _contacterVC = [[WXContacterVC alloc] init];
    [_contacterVC.view setFrame:CGRectMake(0, 72, Size.width, Size.height-72-50)];
    [_contacterVC setDetailDelegate:self];
    
    [self.view addSubview:_recentCall.view];
    [self loadSegmentControl];
    [self addNotification];
    
    contactModel = [[WXContacterModel alloc] init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Size.width, Size.height - 64 - 50 - 4*NumberBtnHeight-InputTextHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
}

-(void)loadSegmentControl{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setImage:[UIImage imageNamed:@"TopBgImg.png"]];
    [self.view addSubview:imgView];
    
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl
    = [[UISegmentedControl alloc] initWithItems:nameArr];
    [_segmentControl setBackgroundColor:[UIColor whiteColor]];
    _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT + 12, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
#endif
    [_segmentControl setBorderRadian:1.0 width:0.2 color:[UIColor grayColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
//    [self.navigationController.navigationBar addSubview:_segmentControl];
    [self.view addSubview:_segmentControl];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case kCallSegmentIndex:
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

-(void)addNotification{
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(inputChange) name:kInputChange object:nil];
//    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
//    [defaultCenter addObserver:self selector:@selector(delBtnClick) name:DelNumber object:nil];
}

-(void)inputChange{
    
}

//-(void)inputNumber:(id)sender{
//    WXUIButton *btn = sender;
//    NSInteger number = (btn.tag+1==11?0:btn.tag+1);
//    if(number <= 9 && number >= 0){
//        [_segmentControl setHidden:YES];
//        [numberLabel setHidden:NO];
//        
//        NSString *str = [NSString stringWithFormat:@"%ld",(long)number];
//        numberStr = [numberStr stringByAppendingString:str];
//        [numberLabel setText:numberStr];
//    }
//    
//    if(numberStr.length > 0){
//        [[NSNotificationCenter defaultCenter] postNotificationName:InputNumber object:nil];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:DownKeyBoard object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kInputChange object:nil];
//    }
//    
//    [contactModel removeMatchingContact];
//    [contactModel matchSearchStringList:numberStr];
//    [_tableView reloadData];
//}

-(void)callPhoneWith:(NSString *)phoneStr{
    if(phoneStr.length < 7 || phoneStr.length != 11){
        [UtilTool showAlertView:@"您所拨打的电话格式不正确"];
        return;
    }
    numberStr = phoneStr;
    [_callModel makeCallPhone:phoneStr];
}

-(void)toContailDetailVC:(id)sender{
    ContactDetailVC * detailVC = [[ContactDetailVC alloc] init];
    ContacterEntity *entity = sender;
    detailVC.model = entity;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma tableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contactModel.filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kContactsCallIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContactsCallIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.imageView.image = [UIImage imageNamed:@""];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = ((ContacterEntity*)contactModel.filterArray[indexPath.row]).name;
    cell.detailTextLabel.text = @"1234";
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[ContactDetailVC alloc] init] animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma callDelegate
-(void)makeCallPhoneFailed:(NSString *)failedMsg{
    if(!failedMsg){
        failedMsg = @"呼叫失败";
    }
    [UtilTool showAlertView:failedMsg];
}

-(void)makeCallPhoneSucceed{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    CallBackVC *callBackVC = [[CallBackVC alloc] init];
    [callBackVC setPhoneName:numberStr];
    [callBackVC setUserPhone:userObj.user];
    [self.navigationController pushViewController:callBackVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_callModel setCallDelegate:nil];
    [NOTIFY_CENTER postNotificationName:kTableViewHidden object:nil];
}

-(void)tableViewHidden{
    if(numberStr.length > 0){
        _tableView.hidden = NO;
    }else{
        _tableView.hidden = YES;
    }
}

@end


