//
//  BonusWaitReceiveVC.m
//  RKWXT
//
//  Created by SHB on 15/6/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BonusWaitReceiveVC.h"
#import "WaitReceiveCell.h"

@interface BonusWaitReceiveVC()<UITableViewDataSource,UITableViewDelegate,ReceiveBonusDelegate>{
    UITableView *_tableView;
}
@end

@implementation BonusWaitReceiveVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self]; 
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WaitReceiveCell cellHeightOfInfo:nil];
}

-(WXUITableViewCell *)tableViewForReceiveCell:(NSInteger)row{
    static NSString *identifier = @"receiveCell";
    WaitReceiveCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitReceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForReceiveCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)receiveBonus{
    NSLog(@"领取红包");
}

@end
