//
//  ContactDetailVC.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ContactDetailVC.h"
#import "ContactDetailCell.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "UIView+Render.h"
#import "CallBackVC.h"

#define DownLoadUrl @"http://wxa.67call.com/shop/index.php/index/app_down/id/"

#define Size self.bounds.size

@interface ContactDetailVC()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
    UITableView *_tableView;
}
@end

@implementation ContactDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableForHeadView]];
    [_tableView setTableFooterView:[self tableForFootView]];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swip];
}

-(UIView*)tableForHeadView{
    UIView *headView = [[UIView alloc] init];
    
    UIImage *bgImg = [UIImage imageNamed:@"ContactInfoBgImg.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 180);
    [imgView setImage:bgImg];
    [headView addSubview:imgView];

    CGFloat xOffset = 15;
    CGFloat yOffset = 35;
    UIImage *img = [UIImage imageNamed:@"ContactInfoBack.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    yOffset += 20;
    // 图像参数不管
    UIImage * headImg = nil;
//    if (_model.icon == nil) {
        headImg = [UIImage imageNamed:@"ContactInfoHeadImg.png"];
//    }else{
//        headImg = _model.icon;
//    }
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.frame = CGRectMake((Size.width-headImg.size.width)/2, yOffset, headImg.size.width, headImg.size.height);
    [headImgView setImage:headImg];
    [headView addSubview:headImgView];
    
    yOffset += headImg.size.height;
    CGFloat nameLabelWidth = 100;
    CGFloat nameheight = 25;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake((Size.width-nameLabelWidth)/2, yOffset, nameLabelWidth, nameheight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:_model.fullName];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:WXTFont(14.0)];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [headView addSubview:nameLabel];
    
    CGRect rect = CGRectMake(0, 0, Size.width, 180);
    [headView setFrame:rect];
    return headView;
}

-(UIView*)tableForFootView{
    UIView *footView = [[UIView alloc] init];
    
    CGFloat yOffset = 52;
    CGFloat btnWidth = 160;
    CGFloat btnHeight = 30;
    WXTUIButton *invateBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    invateBtn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [invateBtn setBorderRadian:10.0 width:0.5 color:WXColorWithInteger(0xdd2726)];
    [invateBtn setBackgroundImageOfColor:WXColorWithInteger(0xdd2726) controlState:UIControlStateNormal];
    [invateBtn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [invateBtn setTitle:@"邀请Ta加入我信通" forState:UIControlStateNormal];
    [invateBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [invateBtn addTarget:self action:@selector(invateFriend) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:invateBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, 200);
    [footView setFrame:rect];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_model.phoneNumbers count];
}

-(UITableViewCell*)tableForContactDetailCell:(NSInteger)row{
    static NSString *identifier = @"detailCell";
    ContactDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ContactDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    [cell setDelegate:self];
    [cell setCellInfo:[_model.phoneNumbers objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableForContactDetailCell:row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {
        [UIPasteboard generalPasteboard].string = [_model.phoneNumbers objectAtIndex:indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    [self callContactWithPhone:[_model.phoneNumbers objectAtIndex:row]];
}

-(void)invateFriend{
    NSString *phoneStr1 = [_model.phoneNumbers objectAtIndex:0];
    if(_model.phoneNumbers.count > 1){
        NSString *phoneStr2 = [_model.phoneNumbers objectAtIndex:1];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择好友手机号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:phoneStr1,phoneStr2, nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else{
        [self sendmessage:phoneStr1];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self sendmessage:[_model.phoneNumbers objectAtIndex:0]];
    }
    if(buttonIndex == 1){
        [self sendmessage:[_model.phoneNumbers objectAtIndex:1]];
    }
}

#pragma mark sendMessage
-(void)sendmessage:(NSString *)msgstring{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet:msgstring];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)displaySMSComposerSheet:(NSString *)stringNum{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    NSString *msg = [NSString stringWithFormat:@"这年头没好事哪敢骚扰你，用我信通打国内电话低至3分。下载地址:%@%d",DownLoadUrl,(int)kMerchantID];
    picker.body = [[NSString alloc] initWithString:msg];
    
    NSArray *array = [NSArray arrayWithObjects:stringNum,nil];
    picker.recipients = array;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        };
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        };
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark contactDetailDelegate
-(void)callContactWithPhone:(NSString *)phoneNumber{
    if(!phoneNumber){
        return;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:phoneNumber];
    CallBackVC *backVC = [[CallBackVC alloc] init];
    backVC.phoneName = phoneStr;
    if(_model.fullName){
        backVC.phoneName = _model.fullName;
    }
    if([backVC callPhone:phoneStr]){
        [self presentViewController:backVC animated:YES completion:^{
        }];
    }
}

-(void)back{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

@end
