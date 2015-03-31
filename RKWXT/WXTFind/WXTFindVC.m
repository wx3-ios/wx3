//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "WXTFindModel.h"
#import "FindEntity.h"

#define Url @"http://gz.67call.com/sq/index.php"

#define Size self.view.bounds.size

@interface WXTFindVC()<UIWebViewDelegate,wxtFindDelegate,UIAlertViewDelegate>{
    UIWebView *_webView;
    WXTFindModel *_model;
    
    UIView *shellView;
}
@end

@implementation WXTFindVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = WXColorWithInteger(0xefeff4);
    
    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height-50)];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    _model = [[WXTFindModel alloc] init];
    [_model setFindDelegate:self];
    [_model loadFindData];
    [self showWaitView:self.view];
    
    shellView = [[UIView alloc] init];
    shellView.frame = CGRectMake(0, 0, Size.width, Size.height-50);
    [shellView setBackgroundColor:[UIColor clearColor]];
    [shellView setHidden:YES];
    [self.view addSubview:shellView];
    
    [self showReloadBaseView];
}

#pragma mark showBaseView
-(void)showReloadBaseView{
    CGFloat yOffset = 150;
    UIImage *wifiImg = [UIImage imageNamed:@"NoWifi.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((Size.width-wifiImg.size.width)/2, yOffset, wifiImg.size.width, wifiImg.size.height);
    [imgView setImage:wifiImg];
    [shellView addSubview:imgView];
    
    yOffset += wifiImg.size.height+10;
    CGFloat labelWidth = 200;
    CGFloat labelheight = 30;
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:WXTFont(14.0)];
    [label1 setText:@"世界上最遥远的距离就是"];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label1];
    
    yOffset += labelheight;
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake((Size.width-labelWidth)/2, yOffset, labelWidth, labelheight);
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:WXTFont(14.0)];
    [label2 setText:@"没有网络连接"];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:[UIColor grayColor]];
    [shellView addSubview:label2];
    
    yOffset += labelheight+20;
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 35;
    WXTUIButton *btn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [btn setBorderRadian:10.0 width:0.5 color:[UIColor clearColor]];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x0c8bdf) controlState:UIControlStateNormal];
    [btn setBackgroundImageOfColor:WXColorWithInteger(0x96e1fd) controlState:UIControlStateSelected];
    [btn setTitle:@"刷新重试" forState:UIControlStateNormal];
    [btn setTitleColor:WXColorWithInteger(0xFFFFFF) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [shellView addSubview:btn];
}

-(void)reloadData{
    [self showWaitView:self.view];
    [_model loadFindData];
}

#pragma mark delegate
-(void)initFinddataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [shellView setHidden:NO];
    if(!errorMsg){
        errorMsg = @"数据加载失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)initFinddataSucceed{
    [shellView setHidden:YES];
    [self unShowWaitView];
    [self loadFindData];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

-(void)loadFindData{
    if([_model.findDataArr count] > 0){
        FindEntity *entity = [_model.findDataArr objectAtIndex:0];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:entity.webUrl]];
        if (request){
            [_webView loadRequest:request];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_model setFindDelegate:nil];
}

@end


//#import "WXTWebViewController.h"
//@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate>{
//    UITableView * _tableView;
//    NSArray * array;
//    NSArray * urlArr;
//}
//@end
//@implementation WXTFindVC
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self createTopView:@"发现"];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    array = [NSArray arrayWithObjects:@"商家联盟",@"天气", nil];
//    urlArr = [NSArray arrayWithObjects:@"http://sjlm1.67call.com/shop/index.php/Union/index/seller_id/10017",@"http://weather.html5.qq.com", nil];
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 50 - 64) style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 1;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kFindCellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFindCellIdentifier];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    switch (indexPath.section) {
//        case 0:
//            cell.imageView.image = [UIImage imageNamed:@"商家联盟图标@2x.png"];
//            cell.textLabel.text = @"商家联盟";
//            break;
//        case 1:
//            cell.imageView.image = [UIImage imageNamed:@"天气图标@2x.png"];
//            cell.textLabel.text = @"天气";
//            break;
//        default:
//            break;
//    }
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    switch (indexPath.section) {
//        case 0:
//            [self.navigationController pushViewController:[[WXTWebViewController alloc] initWithURL:@"http://sjlm1.67call.com/shop/index.php/Union/index/seller_id/10017" title:@"商家联盟"] animated:YES];
//            break;
//        case 1:
//            [self.navigationController pushViewController:[[WXTWebViewController alloc] initWithURL:@"http://weather.html5.qq.com" title:@"天气"] animated:YES];
//            break;
//        default:
//            break;
//    }
//    
//}
