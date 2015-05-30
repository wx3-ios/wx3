//
//  SysMsgVC.m
//  Woxin2.0
//
//  Created by le ting on 8/14/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "SysMsgVC.h"
#import "SysMsgDef.h"
#import "SysMsgModel.h"
#import "SysMsgCell.h"
#import "SysMsgTimeCell.h"
#import "WXUnreadSysMsgOBJ.h"

enum{
    E_SysMsgRow_Time = 0,
    E_SysMsgRow_Body,
    
    E_SysMsgRow_Invalid,
};

@interface SysMsgVC()<SysMsgModelDelegate,UITableViewDataSource,UITableViewDelegate>
{
    WXUITableView *_tableView;
    SysMsgModel   *_model;
}
@end

@implementation SysMsgVC

- (void)dealloc{
    [_model setDelegate:nil];
//    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _model = [[SysMsgModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"消息推送"];
    
    CGSize size = self.bounds.size;
    UIColor *bgColor = WXColorWithInteger(0xf0f0f0);
    CGFloat tableViewWidth = size.width - kSysMessageBorderXGap*2;
    _tableView = [[WXUITableView alloc] initWithFrame:CGRectMake(kSysMessageBorderXGap, 0, tableViewWidth, size.height) style:UITableViewStylePlain];
	[_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, -kSysMessageBorderXGap)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_tableView];
    [self setBackgroundColor:bgColor];
	
    [[WXUnreadSysMsgOBJ sharedUnreadSysMsgOBJ] clearUnreadNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_NotificationName_UnreadSysMessageNumberChanged object:nil userInfo:nil];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_model.sysMsgList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return E_SysMsgRow_Invalid;
}

- (SysMsgTimeCell*)systemMessageTimeCell:(SysMsgItem*)sysMsgItem{
    static NSString *identifier = @"systemMessageTimeCell";
    SysMsgTimeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SysMsgTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:sysMsgItem];
    [cell load];
    return cell;
}

- (SysMsgCell*)sysMsgCell:(SysMsgItem*)sysMsgItem{
    static NSString *sysMsgCellIdentifier = @"sysMsgCellIdentifier";
    SysMsgCell *cell = [_tableView dequeueReusableCellWithIdentifier:sysMsgCellIdentifier];
    if(!cell){
        cell = [[SysMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sysMsgCellIdentifier];
    }
    [cell setCellInfo:sysMsgItem];
    [cell load];
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    WXUITableViewCell *cell = nil;
    SysMsgItem *item = [_model.sysMsgList objectAtIndex:section];
    if(row == E_SysMsgRow_Time){
        cell = [self systemMessageTimeCell:item];
    }else{
        cell = [self sysMsgCell:item];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMsgItem *item = [_model.sysMsgList objectAtIndex:indexPath.section];
    CGFloat height = kSysMsgTimeCellHeight;
    if(indexPath.row == E_SysMsgRow_Body){
        height = [SysMsgCell cellHeightFor:item];
    }
    return height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL ret = NO;
    if(indexPath.row == E_SysMsgRow_Body){
        ret = YES;
    }
    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SysMsgItem *item = [_model.sysMsgList objectAtIndex:indexPath.section];
    [[CoordinateController sharedCoordinateController] toSystemMessageDetail:self messageInfo:item animated:YES];
}

#pragma mark SysMsgModelDelegate
- (void)incomePushList:(NSArray*)sysMsgArray{
    NSMutableIndexSet *mutIndexSet = [NSMutableIndexSet indexSet];
    for(id sysMsgItem in sysMsgArray){
        NSInteger index = [_model.sysMsgList indexOfObject:sysMsgItem];
        if(index != NSNotFound){
            [mutIndexSet addIndex:index];
        }
    }
    if([mutIndexSet count] > 0){
        [_tableView insertSections:mutIndexSet withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end