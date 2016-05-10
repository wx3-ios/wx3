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

#define DownLoadUrl @"http://wx3.67call.com/wx_html/index.php/Public/app_download/sid/"

#define UserBgImageViewHeight (180)
#define Size self.bounds.size

@interface ContactDetailVC()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
    UITableView *_tableView;
    UIImageView *bgImgView;
    UIImageView *headImgView;
    UIButton *backBtn;
    UILabel *nameLabel;
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
    bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [bgImgView setImage:bgImg];
    [headView addSubview:bgImgView];
    if(_model.icon){
        [bgImgView setImage:_model.icon];
    }

    CGFloat xOffset = 15;
    CGFloat yOffset = 35;
    UIImage *img = [UIImage imageNamed:@"ContactInfoBack.png"];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setBackgroundImage:img forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    yOffset += 20;
    // 图像参数不管
    CGFloat imgWidth = 70;
    UIImage * headImg = nil;
    if (_model.icon == nil) {
        headImg = [UIImage imageNamed:@"ContactInfoHeadImg.png"];
    }else{
        headImg = _model.icon;
    }
    headImgView = [[UIImageView alloc] init];
    headImgView.frame = CGRectMake((Size.width-imgWidth)/2, yOffset, imgWidth, imgWidth);
    [headImgView setBorderRadian:imgWidth/2 width:1.0 color:[UIColor clearColor]];
    [headImgView setImage:headImg];
    [headView addSubview:headImgView];
    
    yOffset += imgWidth;
    CGFloat nameLabelWidth = 100;
    CGFloat nameheight = 25;
    nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake((Size.width-nameLabelWidth)/2, yOffset, nameLabelWidth, nameheight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:_model.fullName];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:WXTFont(14.0)];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [headView addSubview:nameLabel];
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [headView setFrame:rect];
    return headView;
}

-(UIView*)tableForFootView{
    UIView *footView = [[UIView alloc] init];
    
    CGFloat yOffset = 52;
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 30;
    WXTUIButton *invateBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    invateBtn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [invateBtn setBorderRadian:10.0 width:0.5 color:WXColorWithInteger(0xdd2726)];
    [invateBtn setBackgroundImageOfColor:WXColorWithInteger(0xdd2726) controlState:UIControlStateNormal];
    [invateBtn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    NSString *str = [NSString stringWithFormat:@"邀请Ta加入%@",kMerchantName];
    [invateBtn setTitle:str forState:UIControlStateNormal];
    [invateBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [invateBtn addTarget:self action:@selector(invateFriend) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:invateBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, 200);
    [footView setFrame:rect];
    return footView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = 0;
    if (yOffset < 0) {
        CGRect f = bgImgView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset+UserBgImageViewHeight;
        f.origin.x = xOffset;
        f.size.width = 320 + fabsf(xOffset)*2;
        bgImgView.frame = f;
    }
    if(yOffset == 0){
        [headImgView setHidden:NO];
        [backBtn setHidden:NO];
        [nameLabel setHidden:NO];
    }else{
        [backBtn setHidden:YES];
        [nameLabel setHidden:YES];
        [headImgView setHidden:YES];
    }
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
    if([_model.phoneNumbers count] == 1){
        [self sendmessage:[_model.phoneNumbers objectAtIndex:0]];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择手机号" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int i = 0; i < [_model.phoneNumbers count]; i++) {
        NSString *title = [_model.phoneNumbers objectAtIndex:i];
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex < [_model.phoneNumbers count]){
        [self sendmessage:[_model.phoneNumbers objectAtIndex:buttonIndex]];
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
    if(kMerchantID == 10233 || kMerchantID == 10248 || kMerchantID  == 10249 || kMerchantID == 10264){
        msg = [NSString stringWithFormat:@"这个世界上肯定有一个人能帮到你，你也会帮到另一个人。分享到朋友圈去帮助更多的人。下载地址:%@%d",DownLoadUrl,(int)kMerchantID];
    }
    if (kMerchantID == 10192) {
        msg = [NSString  stringWithFormat:@"下载进口特惠商城，手机话费充100送378，8分钱／分钟打遍全国。下载地址:%@%d",DownLoadUrl,(int)kMerchantID];
    }
    if(kMerchantID == 10198){
        msg = [NSString stringWithFormat:@"这年头没好事哪敢骚扰您，了解世纪医微通，您会感激我一辈子……下载地址:%@%d",DownLoadUrl,(int)kMerchantID];
    }
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
