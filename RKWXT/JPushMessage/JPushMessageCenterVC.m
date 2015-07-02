//
//  JPushMessageCenterVC.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMessageCenterVC.h"
#import "JPushMessageModel.h"
#import "JPushMessageCenterCell.h"

@interface JPushMessageCenterVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *messageArr;
}

@end

@implementation JPushMessageCenterVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"消息"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
    [[JPushMessageModel shareJPushModel] loadJPushData];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadJpushMessageSucceed) name:K_Notification_JPushMessage_LoadSucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messageArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JPushMessageCenterCellHeight;
}

-(WXUITableViewCell*)tableViewForCommonCellAtRow:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    JPushMessageCenterCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[JPushMessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[messageArr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForCommonCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)loadJpushMessageSucceed{
    messageArr = [JPushMessageModel shareJPushModel].jpushMsgArr;
    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
