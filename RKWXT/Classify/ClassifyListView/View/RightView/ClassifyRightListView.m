//
//  ClassifyRightListView.m
//  RKWXT
//
//  Created by SHB on 15/10/19.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyRightListView.h"
#import "ClassifyRightCell.h"
#import "ClassifyRightDef.h"

#define size self.bounds.size

@interface ClassifyRightListView ()<UITableViewDataSource,UITableViewDelegate,ClassifyRightCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    NSArray *arr;
    NSInteger selectRow;
}

@end

@implementation ClassifyRightListView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
}

-(id)init{
    self = [super init];
    if(self){
        arr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAllowsSelection:NO];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    listArr = @[
                   @{@"title":@"000",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"001",
                     @"list":@[@"aaa",@"aaa1"]
                     },
                   @{@"title":@"002",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"003",
                     @"list":@[@"aaa"]
                     },
                   @{@"title":@"004",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"005",
                     @"list":@[@"aaa"]
                     },
                   @{@"title":@"006",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]
                     },
                   @{@"title":@"007",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"008",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa"]
                     },
                   @{@"title":@"009",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]
                     },
                   @{@"title":@"010",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]
                     },
                   @{@"title":@"011",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]
                     },
                   @{@"title":@"012",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]
                     },
                   @{@"title":@"013",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"014",
                     @"list":@[@"aaa",@"aaa1",@"aaa"]
                     },
                   @{@"title":@"015",
                     @"list":@[@"aaa",@"aaa1",@"aaa",@"aaa",@"aaa",@"aaa"]
                     }
                   ];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGoodsList:) name:@"userSelectRow" object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arr count]/showNumber+([arr count]%showNumber>0?1:0);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return EveryCellHeight;
}

-(WXUITableViewCell *)tableViewForGoodsListAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    ClassifyRightCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:WXColorWithInteger(0xefeff4)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*showNumber;
    NSInteger count = [arr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*showNumber; i < max; i++){
        [rowArray addObject:[arr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForGoodsListAtRow:row];
    return cell;
}

-(void)reloadGoodsList:(NSNotification*)notification{
    selectRow = [notification.object integerValue];
    arr = [[listArr objectAtIndex:selectRow] objectForKey:@"list"];
    [_tableView reloadData];
}

-(void)goodsListCellClicked:(id)entity{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
