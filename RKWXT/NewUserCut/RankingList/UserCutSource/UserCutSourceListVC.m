//
//  UserCutSourceListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/7.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceListVC.h"
#import "UserCutSourceListCell.h"
#import "WXRemotionImgBtn.h"
#import "UserHeaderModel.h"
#import "UserCutSourceModel.h"
#import "UserCutSourceEntity.h"

#define Size self.bounds.size

@interface UserCutSourceListVC ()<UITableViewDataSource,UITableViewDelegate,UserCutSourceModelDelegate>{
    UITableView *_tableView;
    NSArray *listArr;
    UserCutSourceModel *_model;
}

@end

@implementation UserCutSourceListVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[UserCutSourceModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的收益"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableViewForHeaderView]];
    
    [_model loadUserCutSource];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(WXUIView*)tableViewForHeaderView{
    WXUIView *headerView = [[WXUIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat xOffset = 10;
    CGFloat imgViewWidth = 65;
    CGFloat imgViewHeight = imgViewWidth;
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    WXRemotionImgBtn *iconImageView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (92-imgViewHeight)/2, imgViewWidth, imgViewHeight)];
    [iconImageView setImage:iconImg];
    [iconImageView setUserInteractionEnabled:NO];
    [iconImageView setBorderRadian:imgViewWidth/2 width:1.0 color:[UIColor clearColor]];
    [headerView addSubview:iconImageView];
    if([UserHeaderModel shareUserHeaderModel].userHeaderImg){
        [iconImageView setCpxViewInfo:[UserHeaderModel shareUserHeaderModel].userHeaderImg];
        [iconImageView load];
    }
    
    xOffset += imgViewWidth+5;
    CGFloat yOffset = 25;
    CGFloat labelWidth = 200;
    CGFloat labelHeight = 20;
    WXUILabel *nickName = [[WXUILabel alloc] init];
    nickName.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [nickName setBackgroundColor:[UIColor clearColor]];
    [nickName setTextAlignment:NSTextAlignmentLeft];
    [nickName setTextColor:WXColorWithInteger(0x000000)];
    [nickName setFont:WXFont(16.0)];
    [headerView addSubview:nickName];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *nickNameStr = nil;
    if(userDefault.nickname){
        nickNameStr = [NSString stringWithFormat:@"%@",userDefault.nickname];
    }
    nickNameStr = [NSString stringWithFormat:@"(%@)",userDefault.wxtID];
    [nickName setText:nickNameStr];
    
    yOffset += labelHeight+14;
    WXUILabel *moneyLabel = [[WXUILabel alloc] init];
    moneyLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [moneyLabel setBackgroundColor:[UIColor clearColor]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [moneyLabel setTextColor:WXColorWithInteger(0xdd2726)];
    [moneyLabel setFont:WXFont(18.0)];
    [moneyLabel setText:[NSString stringWithFormat:@"￥%.2f",_money]];
    [headerView addSubview:moneyLabel];
    
    yOffset = iconImageView.frame.origin.y+iconImageView.frame.size.height+11;
    CGFloat arrowImgWidth = 20;
    CGFloat arrowImgHeight = 7;
    WXUILabel *leftLine = [[WXUILabel alloc] init];
    leftLine.frame = CGRectMake(0, yOffset, Size.width/3-arrowImgWidth/2+17, 0.5);
    [leftLine setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:leftLine];
    
    WXUILabel *rightLine = [[WXUILabel alloc] init];
    rightLine.frame = CGRectMake(Size.width/3+arrowImgWidth/2+17-1, yOffset, Size.width-Size.width/3-arrowImgWidth, 0.5);
    [rightLine setBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:rightLine];
    
    yOffset += 0.5;
    WXUIImageView *arrowImgView = [[WXUIImageView alloc] init];
    arrowImgView.frame = CGRectMake(Size.width/3-arrowImgWidth/2+17, yOffset, arrowImgWidth, arrowImgHeight);
    [arrowImgView setImage:[UIImage imageNamed:@"UserCutSourceArrowImg.png"]];
    [headerView addSubview:arrowImgView];
    
    yOffset += arrowImgHeight;
    
    [headerView setFrame:CGRectMake(0, 0, Size.width, yOffset)];
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UserCutSourceListCellHeight;
}

-(WXUITableViewCell*)userCutSourceListCell:(NSInteger)row{
    static NSString *identifier = @"listCell";
    UserCutSourceListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCutSourceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([listArr count] > 0){
        [cell setCellInfo:[listArr objectAtIndex:row]];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self userCutSourceListCell:row];
    return cell;
}

#pragma mark userCutSourceDelegate
-(void)loadUserCutSourceSucceed{
    [self unShowWaitView];
    listArr = [self goodsPriceDownSort];
    [_tableView reloadData];
}

-(NSArray*)goodsPriceDownSort{
    NSArray *sortArray = [_model.sourceArr sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        UserCutSourceEntity *entity_0 = obj1;
        UserCutSourceEntity *entity_1 = obj2;
        
        if (entity_0.money < entity_1.money){
            return NSOrderedDescending;
        }else if (entity_0.money > entity_1.money){
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return sortArray;
}

-(void)loadUserCutSourceFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
