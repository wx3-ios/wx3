//
//  LMGoodsCollectionVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMGoodsCollectionVC.h"
#import "LMGoodsCollectionCell.h"

#define Size self.bounds.size

@interface LMGoodsCollectionVC()<UITableViewDataSource,UITableViewDelegate,LMGoodsCollectionCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
}
@end

@implementation LMGoodsCollectionVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count]/2+[listArr count]%2>0?1:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

-(WXUITableViewCell *)lmGoodsCollectionCell:(NSInteger)row{
    static NSString *identfier = @"goodsCell";
    LMGoodsCollectionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMGoodsCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = row*2;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = (row-1)*2; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self lmGoodsCollectionCell:row];
    return cell;
}

#pragma mark
-(void)lmGoodsCollectionCellBtnClicked:(id)sender{
    
}

@end
