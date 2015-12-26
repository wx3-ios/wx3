//
//  LMSearchGoodsResultVC.m
//  RKWXT
//
//  Created by SHB on 15/12/16.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchGoodsResultVC.h"
#import "LMSearchGoodsResultCell.h"
#import "LMSearchGoodsEntity.h"

#define Size self.bounds.size

@interface LMSearchGoodsResultVC()<UITableViewDataSource,UITableViewDelegate,LMSearchGoodsResultCellDelegate>{
    UITableView *_tabelView;
    NSArray *listArr;
}
@end

@implementation LMSearchGoodsResultVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:_titleName];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    listArr = _searchList;
    
    _tabelView = [[UITableView alloc] init];
    _tabelView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tabelView setBackgroundColor:[UIColor whiteColor]];
    [_tabelView setDelegate:self];
    [_tabelView setDataSource:self];
    [_tabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tabelView];
    [_tabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count]/2+([listArr count]%2>0?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LMSearchGoodsResultCellHeight;
}

-(WXUITableViewCell *)searchGoodsResultCell:(NSInteger)row{
    static NSString *identifier = @"goodsCell";
    LMSearchGoodsResultCell *cell = [_tabelView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMSearchGoodsResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*2;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*2; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self searchGoodsResultCell:row];
    return cell;
}

-(void)lmSearchGoodsBtnClicked:(id)sender{
    LMSearchGoodsEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self  goodsID:entity.goodsID animated:YES];
}

@end
