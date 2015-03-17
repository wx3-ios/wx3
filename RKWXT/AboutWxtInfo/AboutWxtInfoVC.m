//
//  AboutWxtInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/16.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutWxtInfoVC.h"
#import "UIView+Render.h"
#import "WXTVersion.h"

#define Size self.view.bounds.size
#define EveryCellHeight (36)

enum{
    WXT_About_Qq = 0,
    WXT_About_Phone,
    WXT_About_Web,
    WXT_About_PWeb,
    
    WXT_About_Invalid,
};

@interface AboutWxtInfoVC()<UIScrollViewDelegate>{
    UIScrollView *_scrollerView;
    
    NSArray *baseNameArr;
    NSArray *infoArr;
}
@end

@implementation AboutWxtInfoVC

-(id)init{
    self = [super init];
    if(self){
        baseNameArr = @[@"我信通客服QQ: 2898621164",@"客服电话: 0755-61665888",@"官方网站: www.67call.com",@"手机网站: www.67call.com"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"关于我们";
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height+10)];
    [self.view addSubview:_scrollerView];
    
    [self createBaseView];
    [self showBaseInfo];
    [self createDownView];
}


-(void)createBaseView{
    CGFloat yOffset = 22;
    UIImage *img = [UIImage imageNamed:@"AboutUsLogo.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [_scrollerView addSubview:imgView];
    
    yOffset += img.size.height;
    CGFloat labelWidth = 100;
    CGFloat labelHeight = 25;
    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setText:@"我信通"];
    [textlabel setFont:WXTFont(20.0)];
    [textlabel setTextColor:WXColorWithInteger(0x0c8bdf)];
    [textlabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:textlabel];
    
    WXTVersion *version = [WXTVersion sharedVersion];
    NSString *currentVersion = [version showCurrentVersion];
#ifdef Test
    currentVersion = [version currentVersion];
#endif
    yOffset += labelHeight;
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelHeight-10);
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setText:[NSString stringWithFormat:@"版本号:V%@",currentVersion]];
//    [versionLabel setTextColor:WXColorWithInteger(0x000000)];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setFont:WXTFont(14.0)];
    [_scrollerView addSubview:versionLabel];
    
    yOffset += labelHeight;
    CGFloat btnWidth = 190;
    CGFloat btnHeight = 30;
    WXTUIButton *checkBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [checkBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    [checkBtn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateSelected];
    [checkBtn setBorderRadian:10.0 width:0.5 color:WXColorWithInteger(0x969696)];
    [checkBtn setTitle:@"检测新版本" forState:UIControlStateNormal];
    [checkBtn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
    [checkBtn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkLastestVersion) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:checkBtn];
}

-(void)showBaseInfo{
    CGFloat xOffset = 20;
    CGFloat yOffset = 210;
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, EveryCellHeight*WXT_About_Invalid);
    [baseView setBorderRadian:5.0 width:0.5 color:WXColorWithInteger(0xCCCCCC)];
    [baseView setBackgroundColor:WXColorWithInteger(0xFFFFFF)];
    
    xOffset = 8;
    yOffset = 8;
    CGFloat lineyGap = 0;
    CGFloat nameLabelWidth = 250;
    CGFloat namelabelHeight = 20;
    
    for(int i = 0; i < WXT_About_Invalid; i++){
        yOffset += (i>0?(16+namelabelHeight):0);
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameLabelWidth, namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x828282)];
        [nameLabel setFont:WXTFont(11.0)];
        [nameLabel setText:baseNameArr[i]];
        [baseView addSubview:nameLabel];
        
        if(i != WXT_About_Invalid-1){
            lineyGap += EveryCellHeight;
            UILabel *line = [[UILabel alloc] init];
            line.frame = CGRectMake(0, lineyGap, Size.width-2*xOffset, 0.5);
            [line setBackgroundColor:WXColorWithInteger(0xEEEEEE)];
            [baseView addSubview:line];
        }
    }
    [_scrollerView addSubview:baseView];
}

-(void)createDownView{
    CGFloat yOffset = 100;
    CGFloat textlabelWidth = 180;
    CGFloat textLabelHeight = 18;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-textlabelWidth)/2, IPHONE_SCREEN_HEIGHT-yOffset-10, textlabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"Copyright © 2014 woxintong.net"];
    [textLabel setFont:WXTFont(11.0)];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:textLabel];
    
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.frame = CGRectMake((Size.width-textlabelWidth)/2, IPHONE_SCREEN_HEIGHT-yOffset-10+textLabelHeight, textlabelWidth, textLabelHeight);
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    [textLabel1 setText:@"版权所有"];
    [textLabel1 setFont:WXTFont(11.0)];
    [textLabel1 setTextColor:WXColorWithInteger(0x000000)];
    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:textLabel1];
}

-(void)checkLastestVersion{
    WXTVersion *version = [WXTVersion sharedVersion];
    [version setCheckType:Version_CheckType_User];
    [version checkVersion];
}

@end
