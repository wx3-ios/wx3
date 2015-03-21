//
//  CallBackVC.m
//  RKWXT
//
//  Created by SHB on 15/3/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "CallBackVC.h"

#define Size self.view.bounds.size
#define NormalTimer (15.0)

@interface CallBackVC(){
    NSTimer *_timer;
    UIImageView *_lightImg;
    
    NSInteger count;
}
@end

@implementation CallBackVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
 
    UIImage *img = [UIImage imageNamed:@"CallBackBgImg.jpg"];
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [bgImgView setImage:img];
    [self.view addSubview:bgImgView];
    
    [self createBackBtn];
    [self createUserNameView];
    [self createBaseView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startActivityImg) userInfo:nil repeats:YES];
}

-(void)createBackBtn{
    CGFloat yOffset = 50;
    CGFloat xOffset = 15;
    UIImage *backImg = [UIImage imageNamed:@"CallBackBtn.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, backImg.size.width, backImg.size.height);
    [backBtn setImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)createUserNameView{
    CGFloat yOffset = 90;
    CGFloat nameWidth = 100;
    CGFloat nameHeight = 30;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake((Size.width-nameWidth)/2, yOffset, nameWidth, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:_phoneName];
    [nameLabel setFont:WXTFont(23.0)];
    [nameLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    
    CGFloat xOffset = 40;
    CGFloat xGap = 9;
    yOffset += 60+nameHeight;
    UIImage *smallIconImg = [UIImage imageNamed:@"CallBackIconImgNor.png"];
    for(int i = 0;i < 7; i++){
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(xOffset+i*(smallIconImg.size.width+xGap), yOffset, smallIconImg.size.width, smallIconImg.size.height);
        [iconImgView setImage:smallIconImg];
        [self.view addSubview:iconImgView];
    }
    
    _lightImg = [[UIImageView alloc] init];
    _lightImg.frame = CGRectMake(xOffset, yOffset, smallIconImg.size.width, smallIconImg.size.height);
    [_lightImg setImage:[UIImage imageNamed:@"CallBackIconImgSel.png"]];
    [self.view addSubview:_lightImg];
}

-(void)createBaseView{
    CGFloat yOffset = 330;
    CGFloat textWidth = 200;
    CGFloat textHeight = 20;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:WXFont(16.0)];
    [textLabel setText:@"我信正在回拨到你的手机"];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:textLabel];
    
    yOffset += textHeight;
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setFont:WXTFont(16.0)];
    [phoneLabel setText:_userPhone];
    [phoneLabel setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:phoneLabel];
    
    yOffset += textHeight;
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.frame = CGRectMake((Size.width-textWidth)/2, yOffset, textWidth, textHeight);
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    [textLabel1 setFont:WXTFont(16.0)];
    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
    [textLabel1 setText:@"请注意接听稍后来电"];
    [textLabel1 setTextColor:WXColorWithInteger(0xFFFFFF)];
    [self.view addSubview:textLabel1];
}

-(void)startActivityImg{
    UIImage *smallIconImg = [UIImage imageNamed:@"CallBackIconImgNor.png"];
    count ++;
    if(count>6){
        count = 0;
    }
    _lightImg.frame = CGRectMake(40+count*(smallIconImg.size.width+9), 180, smallIconImg.size.width, smallIconImg.size.height);
}

-(void)back{
    [_timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
