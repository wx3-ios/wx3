//
//  LMShopCollectionVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopCollectionVC.h"
#import "LMShopCollectionCell.h"
#import "LMShopCollectionTitleCell.h"

#define Size self.bounds.size

@interface LMShopCollectionVC()<UITableViewDataSource,UITableViewDelegate,LMShopCollectionCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
}
@end

@implementation LMShopCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}
     
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if(indexPath.row == 0){
        height = LMShopCollectionTitleCellHeight;
    }else{
        height = LMGoodsCollectionCellheight;
    }
    return height;
}

-(WXUITableViewCell*)shopCollectionTitleCell:(NSInteger)section{
    static NSString *identfier = @"shopTitleCell";
    LMShopCollectionTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMShopCollectionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell *)lmShopCollectionCell:(NSInteger)row{
    static NSString *identfier = @"shopCell";
    LMShopCollectionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMShopCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = row*3;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = (row-1)*3; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == 0){
        cell = [self shopCollectionTitleCell:section];
    }
    return cell;
}

-(void)lmShopCollectionCellBtnClicked:(id)sender{
    
}

@end
