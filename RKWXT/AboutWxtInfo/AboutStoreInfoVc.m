//
//  AboutStoreInfoVc.m
//  RKWXT
//
//  Created by app on 15/12/1.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AboutStoreInfoVc.h"
#import "UIViewAdditions.h"
#import "UIColor+XBCategory.h"
#import "AboutWxtInfoVC.h"
#import "UIView+Render.h"
#import "CallBackVC.h"
#import "WXTVersion.h"
#import "VersionModel.h"
#import "VersionEntity.h"

#define Size self.bounds.size
#define EveryCellHeight (36)

enum{
    WXT_About_Phone = 0,
    WXT_About_Qq,
    WXT_About_Web,
    
    WXT_About_Invalid,
};

@interface AboutStoreInfoVc()<UIScrollViewDelegate,UIGestureRecognizerDelegate,CheckVersionDelegate>{
    UIScrollView *_scrollerView;
    NSArray *baseStoreName;
    NSArray *baseNameArr;
    VersionModel *_model;
    VersionEntity *entity;
    BOOL copy;
}
@end

@implementation AboutStoreInfoVc

-(id)init{
    self = [super init];
    if(self){
        _model = [[VersionModel alloc] init];
        [_model setDelegate:self];
         baseNameArr = @[@"技术电话: 4007889388",@"官方QQ: 2898621164",@"官方网站: www.67call.com"];
         baseStoreName = @[@"QQ: 4007889388",@"商家热线: 2898621164",@"公司网址: www.67call.com"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"关于我们"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_scrollerView setDelegate:self];
    [_scrollerView setScrollEnabled:YES];
    [_scrollerView setShowsVerticalScrollIndicator:NO];
    [_scrollerView setContentSize:CGSizeMake(Size.width, Size.height+10)];
    [self addSubview:_scrollerView];
    
    
    [self createBaseStoewInfo];
    [self createBaseView];
    [self showBaseInfo];
    [self createDownView];
    
    copy = NO;
}





-(void)createBaseView{
    CGFloat yOffset = 29;
    UIImage *img = [UIImage imageNamed:@"Icon@2x.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [_scrollerView addSubview:imgView];
    
    yOffset += img.size.height+12;
    CGFloat labelWidth = 240;
    CGFloat labelHeight = 25;
    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelHeight);
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setText:@"我信云科技有限公司"];
    [textlabel setFont:WXTFont(16.0)];
    [textlabel setTextColor:WXColorWithInteger(0x7c7c7c)];
    [textlabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:textlabel];
    
    WXTVersion *version = [WXTVersion sharedVersion];
    NSString *currentVersion = [version showCurrentVersion];
#ifdef Test
    currentVersion = [version currentVersion];
#endif
    yOffset += labelHeight+5;
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelHeight-10);
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setText:[NSString stringWithFormat:@"v%@",currentVersion]];
    //    [versionLabel setTextColor:WXColorWithInteger(0x000000)];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setFont:WXTFont(14.0)];
    [_scrollerView addSubview:versionLabel];
    
    yOffset += labelHeight;
    CGFloat btnWidth = Size.width-2*30;
    CGFloat btnHeight = 40;
    WXTUIButton *checkBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(30, yOffset, btnWidth, btnHeight);
    //    [checkBtn setBackgroundImageOfColor:[UIColor clearColor] controlState:UIControlStateNormal];
    //    [checkBtn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateSelected];
    [checkBtn setBackgroundColor:WXColorWithInteger(0xdc2826)];
    [checkBtn setBorderRadian:6.0 width:0.5 color:WXColorWithInteger(0x969696)];
    [checkBtn setTitle:@"检测版本" forState:UIControlStateNormal];
    [checkBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [checkBtn.titleLabel setFont:WXFont(14.0)];
    [checkBtn addTarget:self action:@selector(checkLastestVersion) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:checkBtn];
}

- (void)createBaseStoewInfo{
    CGFloat xOffset = 0;
    CGFloat yOffset = 190;
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, EveryCellHeight*WXT_About_Invalid);
    [baseView setBackgroundColor:[UIColor whiteColor]];
    baseView.userInteractionEnabled = YES;
    
    
    xOffset = 8;
    yOffset = 8;
    CGFloat nameLabelWidth = (self.view.width - 2 * 30);
    CGFloat namelabelHeight = 28;
    
    for(int i = 0; i < WXT_About_Invalid; i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, yOffset, nameLabelWidth, namelabelHeight)];
        button.tag  = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:baseStoreName[i] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button setTitleColor:[UIColor colorWithHexString:@"0X8a8a8a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        if(i == WXT_About_Qq){
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copy:)];
            [longPressGesture setDelegate:self];
            longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
            [button addGestureRecognizer:longPressGesture];
        }
        
        yOffset += namelabelHeight+10;
        
        UILabel *line = [[UILabel alloc] init];
        line.frame = CGRectMake(0, yOffset-7, Size.width, 0.5);
        [line setBackgroundColor:WXColorWithInteger(0xEEEEEE)];
        [baseView addSubview:line];
    }
    [_scrollerView addSubview:baseView];
}

-(void)showBaseInfo{
    CGFloat xOffset = 0;
    CGFloat yOffset = 320;
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(xOffset, yOffset, Size.width-2*xOffset, EveryCellHeight*WXT_About_Invalid);
    [baseView setBackgroundColor:[UIColor yellowColor]];
    
    xOffset = 8;
    yOffset = 8;
    CGFloat nameLabelWidth = (self.view.width - 2 * 30);
    CGFloat namelabelHeight = 28;
    
    for(int i = 0; i < WXT_About_Invalid; i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, yOffset, nameLabelWidth, namelabelHeight)];
        button.tag  = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:baseNameArr[i] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button setTitleColor:[UIColor colorWithHexString:@"0X8a8a8a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        if(i == WXT_About_Qq){
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copy:)];
            [longPressGesture setDelegate:self];
            longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
            [button addGestureRecognizer:longPressGesture];
        }

        
        
//        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(0, yOffset, nameLabelWidth, namelabelHeight);
//        btn.tag = i;
//        [btn.titleLabel setFont:WXFont(14.0)];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn setTitle:baseNameArr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:WXColorWithInteger(0x8a8a8a) forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [baseView addSubview:btn];
//        if(i == WXT_About_Qq){
//            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copy:)];
//            [longPressGesture setDelegate:self];
//            longPressGesture.minimumPressDuration = 0.5;//默认0.5秒
//            [btn addGestureRecognizer:longPressGesture];
//        }
        yOffset += namelabelHeight+10;
        
        UILabel *line = [[UILabel alloc] init];
        line.frame = CGRectMake(0, yOffset-7, Size.width, 0.5);
        [line setBackgroundColor:WXColorWithInteger(0xEEEEEE)];
        [baseView addSubview:line];
    }
    [_scrollerView addSubview:baseView];
}

-(void)createDownView{
    CGFloat yOffset = 100;
    CGFloat textLabelHeight = 18;
    
    UILabel *textLabel1 = [[UILabel alloc] init];
    textLabel1.frame = CGRectMake(0, IPHONE_SCREEN_HEIGHT-yOffset, Size.width, textLabelHeight);
    [textLabel1 setBackgroundColor:[UIColor clearColor]];
    [textLabel1 setText:@"我信云科技有限公司 版权所有"];
    [textLabel1 setFont:WXTFont(12.0)];
    [textLabel1 setTextColor:WXColorWithInteger(0x8a8a8a)];
    [textLabel1 setTextAlignment:NSTextAlignmentCenter];
    [_scrollerView addSubview:textLabel1];
}

-(void)checkLastestVersion{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model checkVersion:[UtilTool currentVersion]];
}

-(void)checkVersionSucceed{
    [self unShowWaitView];
    if([_model.updateArr count] > 0){
        entity = [_model.updateArr objectAtIndex:0];
        NSString *message = entity.updateMsg;
        if(entity.updateType == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"马上升级", nil];
            [alert show];
        }
        if(entity.updateType == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上升级", nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(entity.updateType == 0){
        if(buttonIndex == 1){
            //itms-services://?action=download-manifest&url=https://gz.67call.com/Ios/2.plist
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entity.appUrl]];
        }
    }
    if(entity.updateType == 1){
        if(buttonIndex == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entity.appUrl]];
        }
    }
}

-(void)checkVersionFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"查询失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark other
-(void)btnClicked:(id)sender{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case WXT_About_Qq:
            [UtilTool showAlertView:@"长按复制qq号码"];
            break;
        case WXT_About_Phone:
        {
            NSString *phoneStr = [self phoneWithoutNumber:@"4007889388"];
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
            NSString *wbUrl = @"www.67call.com";
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
    [pasteboard setString:@"2898621164"];
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
