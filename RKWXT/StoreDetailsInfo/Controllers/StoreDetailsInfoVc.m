//
//  StoreDetailsInfoVc.m
//  RKWXT
//
//  Created by app on 15/12/3.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "StoreDetailsInfoVc.h"
#import "StoreHeardView.h"
#import "UIViewAdditions.h"
#import "StoreListInfoCell.h"
#import "StoreListData.h"
#import "PhotoView.h"

@interface StoreDetailsInfoVc ()<UITableViewDelegate,UITableViewDataSource,StoreHeardViewDelegate,PhotoViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *array;
@end

@implementation StoreDetailsInfoVc

- (NSArray*)array{
    if (!_array) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"StoreList.plist" ofType:nil];
        _array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *moderArr = [NSMutableArray array];
        for (NSDictionary *dict in _array) {
            StoreListData *Data = [[StoreListData alloc]initWithDict:dict];
            [moderArr addObject:Data];
        }
        _array = moderArr;
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"商家详情"];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableHeaderView = [self setHeardView];
    self.tableview = tableview;
    

    
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(20, 6, 60, 40);
    [rightBtn addTarget:self action:@selector(clickLove) forControlEvents:UIControlEventTouchDown];
    [rightBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setRightNavigationItem:rightBtn];
    
}

- (void)clickLove{
    NSLog(@"发送一次网络请求");
}

- (void)clickShare{
    NSLog(@"发送一次网络请求发送一次网络请求发送一次网络请求发送一次网络请求发送一次网络请求");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    StoreListInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[StoreListInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.height = [StoreListInfoCell cellHeightForRow];
    }
    cell.data = self.array[indexPath.row];
    cell.photoView.delegate = self;
    return cell;
}

- (UIView*)setHeardView{
    StoreHeardView *heardView = [[StoreHeardView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    heardView.delegate = self;
    heardView.backgroundColor = [UIColor whiteColor];
    return heardView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 220;
}

#pragma mark  ---------  代理方法
- (void)storeHeardViewWihthPhone:(StoreHeardView *)heardView{
    NSLog(@"在拨打电话");
}

- (void)storeHeardView:(StoreHeardView *)heardView index:(int)index{
    switch (index) {
        case 0:
            NSLog(@"00000");
            break;
        case 1:
            NSLog(@"111111");
            break;
        case 2:
            NSLog(@"222222");
            break;
            
        default:
            break;
    }

}

- (void)photoCheckStoreInfoWithIndex:(PhotoView *)photo index:(int)Index{
    switch (Index) {
        case 0:
            NSLog(@"00000");
            break;
        case 1:
            NSLog(@"111111");
            break;
        case 2:
            NSLog(@"222222");
            break;
            
        default:
            break;
    }
}

@end
