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
#import "LMOrderListEntity.h"
#import "LMOrderEvaluateModel.h"

#define Size self.bounds.size
#define DownViewHeight (45)

@interface LMOrderEvaluteVC()<UITableViewDataSource,UITableViewDelegate,LMEvaluteGoodsCellDelegate,LMOrderEvaluateModelDelegate,LMEvaluteUserHandleCellDelegate>{
    UITableView *_tableView;
    LMOrderListEntity *entity;
    LMOrderEvaluateModel *_model;
    
    NSMutableDictionary *userMsgDic;
    NSMutableDictionary *goodsScoreDic;
}
@end

@implementation LMOrderEvaluteVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[LMOrderEvaluateModel alloc] init];
        [_model setDelegate:self];
        
        userMsgDic = [[NSMutableDictionary alloc] init];
        goodsScoreDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"发表评论"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    entity = _orderEntity;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self createDownView];
    
    [self userMsgDic];
}

//初始化评价
-(void)userMsgDic{
    for(LMOrderListEntity *ent in entity.goodsListArr){
        NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)ent.goodsID];
        [userMsgDic setObject:@"好评" forKey:goodsIDStr];
        [goodsScoreDic setObject:@"5" forKey:goodsIDStr];
    }
}

-(void)createDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    downView.frame = CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight);
    [downView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:downView];
    
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 0, Size.width, 0.5);
    [lineLabel setBackgroundColor:WXColorWithInteger(0x9b9b9b)];
    [downView addSubview:lineLabel];
    
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 25;
    WXUIButton *submitEvaluteBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitEvaluteBtn.frame = CGRectMake((Size.width-btnWidth)/2, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [submitEvaluteBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [submitEvaluteBtn setTitleColor:WXColorWithInteger(0xdd2726) forState:UIControlStateNormal];
    [submitEvaluteBtn addTarget:self action:@selector(submitEvalute) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:submitEvaluteBtn];
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [entity.goodsListArr count];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 10.0;
}

-(WXUITableViewCell*)evaluteGoodsCell:(NSInteger)section{
    static NSString *identfier = @"goodsCell";
    LMEvaluteGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[LMEvaluteGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([entity.goodsListArr count] > 0){
        [cell setCellInfo:[entity.goodsListArr objectAtIndex:section]];
    }
    [cell setDelegate:self];
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
    if([entity.goodsListArr count] > 0){
        [cell setCellInfo:[entity.goodsListArr objectAtIndex:section]];
    }
    [cell setDelegate:self];
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

//评语
-(void)userEvaluteTextFieldChanged:(LMEvaluteGoodsCell*)cell goodsID:(NSInteger)goods_id{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath){
        NSInteger row = indexPath.row;
        if(row == 0){
            [userMsgDic setObject:cell.textField.text forKey:[NSString stringWithFormat:@"%ld",(long)goods_id]];
        }
    }
}

//评星
-(void)userEvaluateGoods:(NSInteger)score goodsID:(NSInteger)goodsID{
    NSString *scoreStr = [NSString stringWithFormat:@"%ld",(long)score];
    NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)goodsID];
    [goodsScoreDic setObject:scoreStr forKey:goodsIDStr];
}

-(void)submitEvalute{
    NSString *evaluateStr = [[NSString alloc] init];
    NSInteger number = 0 ;
    for(LMOrderListEntity *ent in entity.goodsListArr){
        NSString *goodsIDStr = [NSString stringWithFormat:@"%ld",(long)ent.goodsID];
        NSInteger scord = [[goodsScoreDic objectForKey:goodsIDStr] integerValue];
        NSString *message = [userMsgDic objectForKey:goodsIDStr];
        NSString *comStr = [NSString stringWithFormat:@"%ld^%ld^%@",(long)ent.goodsID,(long)scord,message];
        
        number++;
        evaluateStr = [evaluateStr stringByAppendingString:comStr];
        if(number < [ent.goodsListArr count]){
            evaluateStr = [evaluateStr stringByAppendingString:@"^^"];
        }
    }
    
    [_model userEvaluateOrder:entity.orderId andInfo:evaluateStr type:OrderEvaluate_Type_Add];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)lmOrderEvaluateSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"谢谢您的评价"];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserEvaluateOrderSucceed object:entity];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)lmOrderEvaluateFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"评价失败，请重试";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
