//
//  LMShopInfoNewGoodsVC.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoNewGoodsVC.h"
#import "LMShopInfoNewGoodsTitleCell.h"
#import "LMShopInfoNewGoodsCell.h"

#define Size self.bounds.size

@interface LMShopInfoNewGoodsVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
}
@end

@implementation LMShopInfoNewGoodsVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"上新"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([listArr count] == 0){
        return 0;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    return cell;
}

@end
