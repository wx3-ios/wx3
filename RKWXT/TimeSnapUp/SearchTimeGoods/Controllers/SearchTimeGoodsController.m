//
//  SearchTimeGoodsController.m
//  RKWXT
//
//  Created by app on 15/11/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "SearchTimeGoodsController.h"


@interface SearchTimeGoodsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *searchGoodsA;
@end

@implementation SearchTimeGoodsController

- (NSArray*)searchGoodsA{
    if (!_searchGoodsA) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"time.plist" ofType:nil];
        _searchGoodsA = [NSMutableArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arraym = [NSMutableArray array];
        for (NSDictionary *Dict in _searchGoodsA) {
            
        }
        _searchGoodsA = arraym;
    }
    return _searchGoodsA;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self setCSTTitleView:view];
    
    UIImage *image = [UIImage imageNamed:@"003.png"];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    [self setLeftNavigationItem:imageview];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchGoodsA.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    return cell;
}

- (void)clackBtn{
    NSLog(@"22");
}


@end
