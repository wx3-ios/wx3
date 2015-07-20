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

enum{
    Find_Section_ShopUnion = 0,
    Find_Section_Weather,
    
    Find_Section_Invalid,
};

@interface WXTFindVC()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    UIView *shellView;
    UITableView *_tableView;
    
    NSArray *imgArr;
    NSArray *nameArr;
    NSArray *webUrl;
}
@end

@implementation WXTFindVC

-(id)init{
    self = [super init];
    if(self){
        imgArr = @[@"Icon.png", @"Icon.png"];
        nameArr = @[@"商家联盟", @"天气"];
        webUrl = @[@"www.baidu.com", @"www.taobao.com"];
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
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Find_Section_Invalid;
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
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setImg:[imgArr objectAtIndex:section]];
    [cell setName:[nameArr objectAtIndex:section]];
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
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    FindCommonVC *commonVC = [[FindCommonVC alloc] init];
    commonVC.webURl = [webUrl objectAtIndex:section];
    commonVC.titleName = [nameArr objectAtIndex:section];
    [self.wxNavigationController pushViewController:commonVC];
}

@end
