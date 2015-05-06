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
#import "CallBackVC.h"

#define Size self.bounds.size
#define EveryCellHeight (36)

enum{
    WXT_About_Qq = 0,
    WXT_About_Phone,
    WXT_About_Web,
    WXT_About_PWeb,
    
    WXT_About_Invalid,
};

@interface AboutWxtInfoVC()<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UIScrollView *_scrollerView;
    
    NSArray *baseNameArr;
    NSArray *baseDataArr;
    NSArray *infoArr;
    
    BOOL copy;
}
@end

@implementation AboutWxtInfoVC

-(id)init{
    self = [super init];
    if(self){
//        baseNameArr = @[@"我信通客服QQ: 2898621164",@"客服电话: 0755-61665888",@"官方网站: www.67call.com",@"手机网站: www.67call.com"];
        baseNameArr = @[@"我信通客服QQ:",@"客服电话:",@"官方网站:",@"手机网站:"];
        baseDataArr = @[@"2898621164",@"0755-61665888",@"www.67call.com",@"www.67call.com"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"关于我们"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height+10)];
    [self addSubview:_scrollerView];
    
    [self createBaseView];
    [self showBaseInfo];
    [self createDownView];
    
    copy = NO;
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
    CGFloat nameLabelWidth = 50;
    CGFloat namelabelHeight = 20;
    
    for(int i = 0; i < WXT_About_Invalid; i++){
        yOffset += (i>0?(16+namelabelHeight):0);
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, (i==0?nameLabelWidth+30:nameLabelWidth), namelabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x828282)];
        [nameLabel setFont:WXTFont(11.0)];
        [nameLabel setText:baseNameArr[i]];
        [baseView addSubview:nameLabel];
        
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xOffset+nameLabelWidth+(i==0?30:0), yOffset, Size.width-xOffset-nameLabelWidth-100, namelabelHeight);
        btn.tag = i;
        [btn.titleLabel setFont:WXFont(14.0)];
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:baseDataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:WXColorWithInteger(0x0c8bdf) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:btn];
        if(i == WXT_About_Qq){
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copy:)];
            [longPressGesture setDelegate:self];
            longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
            [btn addGestureRecognizer:longPressGesture];
        }
        
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
    CGFloat textlabelWidth = 200;
    CGFloat textLabelHeight = 18;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-textlabelWidth)/2, IPHONE_SCREEN_HEIGHT-yOffset-10, textlabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"Copyright © 2014 www.woxinyun.com"];
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
    if(version.checkStatus == CheckUpdata_Status_Starting){
        return;
    }
    version.checkStatus = CheckUpdata_Status_Starting;
    [version setCheckType:Version_CheckType_User];
    [version checkVersion];
}

-(void)btnClicked:(id)sender{
    WXUIButton *btn = (WXUIButton*)sender;
    switch (btn.tag) {
        case WXT_About_Qq:
            [UtilTool showAlertView:@"长按复制qq号码"];
            break;
        case WXT_About_Phone:
        {
            NSString *phoneStr = [self phoneWithoutNumber:[baseDataArr objectAtIndex:WXT_About_Phone]];
            CallBackVC *backVC = [[CallBackVC alloc] init];
            backVC.phoneName = phoneStr;
            if([backVC callPhone:phoneStr]){
                [self presentViewController:backVC animated:YES completion:^{
                }];
            }
        }
            break;
        case WXT_About_Web:
        {
            NSString *wbUrl = [baseDataArr objectAtIndex:WXT_About_Web];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",wbUrl]]];
        }
            break;
        case WXT_About_PWeb:
        {
            NSString *wbUrl = [baseDataArr objectAtIndex:WXT_About_PWeb];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",wbUrl]]];
        }
            break;
        default:
            break;
    }
}

- (void)copy:(id)sender{
    if(copy){
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[baseDataArr objectAtIndex:WXT_About_Qq]];
    [UtilTool showTipView:@"复制完成"];
    copy = YES;
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    copy = NO;
}

@end
