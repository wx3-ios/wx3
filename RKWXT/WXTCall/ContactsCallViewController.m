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

#define Size self.view.bounds.size

@interface ContactsCallViewController ()<ToContactDetailVCDelegate,UITableViewDataSource,UITableViewDelegate,CallPhoneDelegate>{
    CallViewController * _recentCall;
    WXContacterVC * _contacterVC;
    UILabel *numberLabel;
    NSString *numberStr;
    
    UITableView *_tableView;
    WXContacterModel *contactModel;
}

@end

@implementation ContactsCallViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _recentCall = [[CallViewController alloc]init];
    [_recentCall.view setFrame:CGRectMake(0, yGap, Size.width, Size.height-yGap-50)];
    [_recentCall setKeyPad_type:E_KeyPad_Show];
    [_recentCall setCallDelegate:self];
    
    _contacterVC = [[WXContacterVC alloc] init];
    [_contacterVC.view setFrame:CGRectMake(0, yGap, Size.width, Size.height-yGap-50)];
    [_contacterVC setDetailDelegate:self];
    
    [self.view addSubview:_recentCall.view];
    [self loadSegmentControl];
    
    contactModel = [[WXContacterModel alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yGap, Size.width, Size.height - yGap - 50 - 4*NumberBtnHeight-InputTextHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//    [_tableView reloadData];
}

-(void)loadSegmentControl{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
//    [imgView setImage:[UIImage imageNamed:@"TopBgImg.png"]];
    [imgView setBackgroundColor:WXColorWithInteger(0x0c8bdf)];
    [self.view addSubview:imgView];
    
    CGFloat segWidth = 180;
    CGFloat segHeight = 30;
    NSArray *nameArr = @[@"通话",@"通讯录"];
    _segmentControl
    = [[UISegmentedControl alloc] initWithItems:nameArr];
    _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, IPHONE_STATUS_BAR_HEIGHT + 10, segWidth, segHeight);
    if(isIOS6){
        _segmentControl.frame = CGRectMake((Size.width-segWidth)/2, NAVIGATION_BAR_HEGITH-segHeight-5, segWidth, segHeight);
    }
    [_segmentControl setSelectedSegmentIndex:kCallSegmentIndex];
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    _segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
#endif
    [_segmentControl setBorderRadian:5.0 width:1 color:[UIColor whiteColor]];
    [_segmentControl setBackgroundColor:[UIColor whiteColor]];
    [_segmentControl addTarget:self action:@selector(segmentControlChange:) forControlEvents:UIControlEventValueChanged];
//    [self.navigationController.navigationBar addSubview:_segmentControl];
    [self.view addSubview:_segmentControl];
}

-(void)segmentControlChange:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
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

-(void)addNotification{
//    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(callPhoneNumber) name:CallPhone object:nil];
//    [defaultCenter addObserver:self selector:@selector(delBtnClick) name:DelNumber object:nil];
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
    numberStr = [UtilTool callPhoneNumberRemovePreWith:phoneStr];
    CallBackVC *callBackVC = [[CallBackVC alloc] init];
    [callBackVC setPhoneName:numberStr];
    [callBackVC callPhone:numberStr];
    [self.navigationController pushViewController:callBackVC animated:YES];
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

-(void)viewWillDisappear:(BOOL)animated{
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


