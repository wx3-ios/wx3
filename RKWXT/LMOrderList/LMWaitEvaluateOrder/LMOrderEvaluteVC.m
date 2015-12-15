//
//  LMOrderEvaluteVC.m
//  RKWXT
//
//  Created by SHB on 15/12/15.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMOrderEvaluteVC.h"
#import "LMEvaluteGoodsCell.h"
#import "LMEvaluteUserHandleCell.h"

#define Size self.bounds.size
#define DownViewHeight (45)

@interface LMOrderEvaluteVC()<UITableViewDataSource,UITableViewDelegate,LMEvaluteGoodsCellDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
}
@end

@implementation LMOrderEvaluteVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"发表评论"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
}

-(void)createDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight);
    [downView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:downView];
    
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 25;
    WXUIButton *submitEvaluteBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitEvaluteBtn.frame = CGRectMake((Size.width-btnWidth)/2, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [submitEvaluteBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [submitEvaluteBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [submitEvaluteBtn addTarget:self action:@selector(submitEvalute) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:submitEvaluteBtn];
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
        height = LMEvaluteGoodsCellHeight;
    }
    if(indexPath.row == 1){
        height = LMEvaluteUserHandleCellHeight;
    }
    return height;
}

-(WXUITableViewCell*)evaluteGoodsCell:(NSInteger)section{
    static NSString *identfier = @"goodsCell";
    LMEvaluteGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMEvaluteGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)userHandleCell:(NSInteger)section{
    static NSString *identfier = @"handleCell";
    LMEvaluteUserHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMEvaluteUserHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == 0){
        cell = [self evaluteGoodsCell:section];
    }
    if(row == 1){
        cell = [self userHandleCell:section];
    }
    return cell;
}

-(void)userEvaluteTextFieldChanged:(id)sender{
    
}

-(void)submitEvalute{
    
}

@end
