//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"

#define Url @"http://gz.67call.com/sq/index.php"

#define Size self.view.bounds.size

@interface WXTFindVC()<UIWebViewDelegate>{
    UIWebView *_webView;
}
@end

@implementation WXTFindVC

- (void)viewDidLoad{
    [super viewDidLoad];
    

    _webView = [[WXUIWebView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height-50)];
    [_webView setDelegate:self];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
    if (request){
        [_webView loadRequest:request];
    }
    [self.view addSubview:_webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWaitView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self unShowWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self unShowWaitView];
    [UtilTool showAlertView:@"加载失败"];
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
