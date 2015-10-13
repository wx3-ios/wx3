//
//  WXTFindVC.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.


#import "WXTFindVC.h"
#import "WXTFindCommmonCell.h"
#import "FindCommonVC.h"

#define Size self.bounds.size

@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    UIView *shellView;
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
        nameArr = @[@"去哪儿网", @"墨迹天气"];
        webUrl = @[@"http://flight.qunar.com", @"http://weather.html5.qq.com"];
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
    
    UIImage *commonImg = [UIImage imageNamed:@"FindShop.png"];
    for(NSInteger i = 0; i < 3; i++){
//        CGSize size1 = [self sizeOfString:commonImgName[i] font:WXFont(12.0)];
        WXUIButton *bgImgBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        [bgImgBtn setBackgroundColor:[UIColor whiteColor]];
        bgImgBtn.frame = CGRectMake(i*(Size.width/4)+Size.width/4, 0, Size.width/4, FindCommonCellHeight);
        [bgImgBtn setBorderRadian:0 width:0.3 color:[UIColor grayColor]];
        
        [bgImgBtn setImage:[UIImage imageNamed:commonImgArr[i]] forState:UIControlStateNormal];
        [bgImgBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (Size.width/4-commonImg.size.width)/2, FindCommonCellHeight/2, 0)];
        
        [bgImgBtn setTitle:commonImgName[i] forState:UIControlStateNormal];
        [bgImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(FindCommonCellHeight/2, 1, 0, 10)];
        [bgImgBtn setTitleColor:WXColorWithInteger(0x646464) forState:UIControlStateNormal];
        [bgImgBtn.titleLabel setFont:WXFont(12.0)];
        
        bgImgBtn.tag = i;
        [bgImgBtn addTarget:self action:@selector(gotoShopMertan:) forControlEvents:UIControlEventTouchUpInside];
        [commonView addSubview:bgImgBtn];
        
        if(i == 0){
            bgImgBtn.frame = CGRectMake(0, 0, Size.width/2, FindCommonCellHeight);
            [bgImgBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (Size.width/2-commonImg.size.width)/2, FindCommonCellHeight/2, 0)];
            [bgImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(FindCommonCellHeight/2, 5, 0, 17)];
        }
        if(i == 1){
            [bgImgBtn setTitleEdgeInsets:UIEdgeInsetsMake(FindCommonCellHeight/2, -6, 0, 17)];
        }
    }
    
    CGFloat yoffset = FindCommonCellHeight;
    
    for(NSInteger j = 0; j < 2; j++){
//        CGSize size2 = [self sizeOfString:@"1" font:WXFont(12.0)];
        WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        [commonBtn setBackgroundColor:[UIColor whiteColor]];
        commonBtn.frame = CGRectMake(j*(Size.width/4), yoffset, Size.width/4, FindCommonCellHeight);
        [commonBtn setBorderRadian:0 width:0.2 color:[UIColor grayColor]];
        
        [commonBtn setImage:[UIImage imageNamed:imgArr[j]] forState:UIControlStateNormal];
        [commonBtn setImageEdgeInsets:UIEdgeInsetsMake(15, (Size.width/4-commonImg.size.width)/2-8, FindCommonCellHeight/2, 0)];
        
        [commonBtn setTitle:nameArr[j] forState:UIControlStateNormal];
        [commonBtn setTitleEdgeInsets:UIEdgeInsetsMake(FindCommonCellHeight/2-10, -19, 0, 0)];
        [commonBtn setTitleColor:WXColorWithInteger(0x646464) forState:UIControlStateNormal];
        [commonBtn.titleLabel setFont:WXFont(12.0)];
        
        commonBtn.tag = j;
        [commonBtn addTarget:self action:@selector(gotoCommonWeb:) forControlEvents:UIControlEventTouchUpInside];
        [commonView addSubview:commonBtn];
    }
    
    yoffset += FindCommonCellHeight;
    commonView.frame = CGRectMake(0, 0, Size.width, yoffset);
    return commonView;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(WXUITableViewCell*)findCommonCellAtSection:(NSInteger)section{
    static NSString *identifier = @"findCommonCell";
    WXTFindCommmonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTFindCommmonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    cell = [self findCommonCellAtSection:section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
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
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = [webUrl objectAtIndex:btn.tag];
    commonVC.titleName = [nameArr objectAtIndex:btn.tag];
    [self.wxNavigationController pushViewController:commonVC];
}

@end
