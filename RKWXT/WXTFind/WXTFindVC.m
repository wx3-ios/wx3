//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "FindCommonVC.h"
#import "WXWebViewShareVC.h"

#define FindCommonCellHeight (85)
#define Size self.bounds.size

@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    
    NSArray *commonImgArr;
    NSArray *commonImgName;
    NSArray *commonUrl;
    
    NSArray *imgArr;
    NSArray *nameArr;
    NSArray *webUrl;
}
@end

@implementation WXTFindVC

-(id)init{
    self = [super init];
    if(self){
        commonImgArr = @[@"FindShop.png", @"FindJingdong.png", @"FindTaobao.png"];
        commonImgName = @[@"商家联盟", @"京东", @"淘宝网"];
        commonUrl = @[@"http://wx3.67call.com/wx_html/index.php/Public/alliance_merchant", @"http://re.jd.com", @"http://www.taobao.com"];
        
        imgArr = @[@"FIndLvyou.png", @"FindWeather.png"];
        nameArr = @[@"去哪儿网", @"天气"];
        webUrl = @[@"http://flight.qunar.com", @"http://weather.html5.qq.com"];
        
        if(kMerchantID == 10248){
            imgArr = @[@"FIndLvyou.png", @"FindWeather.png", @"FindZhiwoyun.png"];
            nameArr = @[@"去哪儿网", @"天气", @"微名片"];
            webUrl = @[@"http://flight.qunar.com", @"http://weather.html5.qq.com", @"http://wx.1wili.com/livehouse.html"];
        }
        if(kMerchantID == 10233 || kMerchantID == 10249){
            imgArr = @[@"FIndLvyou.png", @"FindWeather.png", @"FindHusheng.png"];
            nameArr = @[@"去哪儿网", @"天气", @"OO直播"];
            webUrl = @[@"http://flight.qunar.com", @"http://weather.html5.qq.com", @"http://wx.1wili.com/livehouse.html"];
        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"发现"];
    self.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableHeaderView:[self commonFootView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}

-(UIView *)commonFootView{
    UIView *commonView = [[UIView alloc] init];
    [commonView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    for(NSInteger i = 0; i < [commonImgArr count]; i++){
        WXUIButton *bgImgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        [bgImgBtn setBackgroundColor:[UIColor whiteColor]];
        bgImgBtn.frame = CGRectMake(i*(Size.width/4)+Size.width/4, 0, Size.width/4-1, FindCommonCellHeight);
        
        [bgImgBtn setImage:[UIImage imageNamed:commonImgArr[i]] forState:UIControlStateNormal];
        [bgImgBtn setTitle:commonImgName[i] forState:UIControlStateNormal];
        [bgImgBtn setTitleColor:WXColorWithInteger(0x646464) forState:UIControlStateNormal];
        [bgImgBtn.titleLabel setFont:WXFont(12.0)];
        
        bgImgBtn.tag = i;
        [bgImgBtn addTarget:self action:@selector(gotoShopMertan:) forControlEvents:UIControlEventTouchUpInside];
        [commonView addSubview:bgImgBtn];
        
        if(i == 0){
            bgImgBtn.frame = CGRectMake(0, 0, Size.width/2-1, FindCommonCellHeight);
        }
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(bgImgBtn.bounds), CGRectGetMidY(bgImgBtn.bounds));
        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(bgImgBtn.imageView.bounds));
        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(bgImgBtn.bounds)-CGRectGetMidY(bgImgBtn.titleLabel.bounds));
        CGPoint startImageViewCenter = bgImgBtn.imageView.center;
        CGPoint startTitleLabelCenter = bgImgBtn.titleLabel.center;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        bgImgBtn.imageEdgeInsets = UIEdgeInsetsMake(20, imageEdgeInsetsLeft, FindCommonCellHeight/2, imageEdgeInsetsRight);
        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
        bgImgBtn.titleEdgeInsets = UIEdgeInsetsMake(FindCommonCellHeight/2-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
    }
    
    CGFloat yoffset = FindCommonCellHeight+1;
    
    for(NSInteger k = 0; k < [imgArr count]/4+([imgArr count]%4>0?1:0); k++){
        for(NSInteger j = 0; j < 4; j++){
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [commonBtn setBackgroundColor:[UIColor whiteColor]];
            commonBtn.frame = CGRectMake(j*(Size.width/4), yoffset, Size.width/4-1, FindCommonCellHeight);
            [commonBtn setBorderRadian:0 width:1 color:[UIColor clearColor]];
            
            [commonBtn setImage:[UIImage imageNamed:imgArr[j]] forState:UIControlStateNormal];
            [commonBtn setTitle:nameArr[j] forState:UIControlStateNormal];
            [commonBtn setTitleColor:WXColorWithInteger(0x646464) forState:UIControlStateNormal];
            [commonBtn.titleLabel setFont:WXFont(12.0)];
            
            commonBtn.tag = j;
            [commonBtn addTarget:self action:@selector(gotoCommonWeb:) forControlEvents:UIControlEventTouchUpInside];
            [commonView addSubview:commonBtn];
            
            
            CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
            CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
            CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
            CGPoint startImageViewCenter = commonBtn.imageView.center;
            CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
            CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
            CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            commonBtn.imageEdgeInsets = UIEdgeInsetsMake(20, imageEdgeInsetsLeft, FindCommonCellHeight/2, imageEdgeInsetsRight);
            CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
            CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
            commonBtn.titleEdgeInsets = UIEdgeInsetsMake(FindCommonCellHeight/2-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
            
            if(j == ([imgArr count]-4*k)-1){
                break;
            }
        }
        yoffset += FindCommonCellHeight+1;
    }
    
    commonView.frame = CGRectMake(0, 0, Size.width, yoffset);
    return commonView;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

#pragma mark
-(void)gotoShopMertan:(id)sender{
    WXUIButton *btn = sender;
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = [commonUrl objectAtIndex:btn.tag];
    commonVC.titleName = [commonImgName objectAtIndex:btn.tag];
    [self.wxNavigationController pushViewController:commonVC];
}

-(void)gotoCommonWeb:(id)sender{
    WXUIButton *btn = sender;
    if(btn.tag == 2 && kMerchantID == 10248){
        WXWebViewShareVC *webVC = [[WXWebViewShareVC alloc] init];
        [self.wxNavigationController pushViewController:webVC];
        return;
    }
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = [webUrl objectAtIndex:btn.tag];
    commonVC.titleName = [nameArr objectAtIndex:btn.tag];
    [self.wxNavigationController pushViewController:commonVC];
}

@end
