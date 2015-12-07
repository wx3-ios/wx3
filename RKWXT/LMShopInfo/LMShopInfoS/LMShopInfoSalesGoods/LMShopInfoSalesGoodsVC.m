//
//  LMShopInfoSalesGoodsVC.m
//  RKWXT
//
//  Created by SHB on 15/12/3.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMShopInfoSalesGoodsVC.h"
#import "LMShopInfoSalesCell.h"

#define Size self.bounds.size

@interface LMShopInfoSalesGoodsVC()<UITableViewDataSource,UITableViewDelegate,LMShopInfoSalesCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
}
@end

@implementation LMShopInfoSalesGoodsVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"促销"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count]/2+([listArr count]%2>0?1:0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

-(WXUITableViewCell*)shopInfoSalesCell:(NSInteger)row{
    static NSString *identifier = @"salesCell";
    LMShopInfoSalesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMShopInfoSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = row*2;
    NSInteger count = [listArr count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = (row-1)*3; i < max; i++){
        [rowArray addObject:[listArr objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self shopInfoSalesCell:row];
    return cell;
}


#pragma mark goodsBtnDelegate
-(void)lmShopInfoSaleGoodsBtnClicked:(id)sender{
    
}

@end
