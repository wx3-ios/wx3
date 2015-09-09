//
//  NewUserCutVC.m
//  RKWXT
//
//  Created by SHB on 15/9/8.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "NewUserCutVC.h"
#import "NewGoodsInfoBDCell.h"
#import "UserRefereeCell.h"

#define Size self.bounds.size

enum{
    NewCut_Section_team = 0,
    NewCut_Section_Referee,
    
    NewCut_Section_invalid,
};

@interface NewUserCutVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    WXUILabel *_bigMoney;
    WXUILabel *_smallMoney;
    
    BOOL _isOpen;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation NewUserCutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"我的提成"];
    [self setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    _isOpen = NO;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableHeaderView:[self tableviewForHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(UIView*)tableviewForHeadView{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 27;
    CGFloat bigHeight = 40;
    _bigMoney = [[WXUILabel alloc] init];
    _bigMoney.frame = CGRectMake(0, yOffset, Size.width, bigHeight);
    [_bigMoney setBackgroundColor:[UIColor clearColor]];
    [_bigMoney setFont:WXFont(41.0)];
    [_bigMoney setText:@"0.00"];
    [_bigMoney setTextAlignment:NSTextAlignmentCenter];
    [_bigMoney setTextColor:WXColorWithInteger(0xf36f25)];
    [headView addSubview:_bigMoney];
    
    yOffset += bigHeight+10;
    CGFloat btnWidth = 140;
    CGFloat btnHeight = 20;
    WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((Size.width-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:[UIImage imageNamed:@"UserCut.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitle:@"账户安全保障中" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
    [button setTitleColor:WXColorWithInteger(0x59b904) forState:UIControlStateNormal];
    [button setEnabled:NO];
    [button.titleLabel setFont:WXFont(12.0)];
    [headView addSubview:button];
    
    yOffset = 130;
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [line setBackgroundColor:WXColorWithInteger(0xcfcfcf)];
    [headView addSubview:line];
    
    yOffset += 15;
    CGFloat smallWidth = 80;
    CGFloat smallHeight = 20;
    _smallMoney = [[WXUILabel alloc] init];
    _smallMoney.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [_smallMoney setBackgroundColor:[UIColor clearColor]];
    [_smallMoney setText:@"0.00"];
    [_smallMoney setTextAlignment:NSTextAlignmentCenter];
    [_smallMoney setFont:WXFont(15.0)];
    [_smallMoney setTextColor:WXColorWithInteger(0x000000)];
    [headView addSubview:_smallMoney];
    
    yOffset += smallHeight;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake((Size.width-smallWidth)/2, yOffset, smallWidth, smallHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"余额"];
    [textLabel setTextColor:WXColorWithInteger(0x828282)];
    [textLabel setFont:WXFont(11.0)];
    [headView addSubview:textLabel];
    
    headView.frame = CGRectMake(0, 0, Size.width, 196);
    return headView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NewCut_Section_invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case NewCut_Section_team:
            row = 1;
            break;
        case NewCut_Section_Referee:
        {
            if(_isOpen){
                if(_selectedIndexPath.section == section){
                    if(1 > 0){
                        return 2;
                    }else{
                        return 1;
                    }
                }
            }else{
                return 1;
            }
        }
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case NewCut_Section_team:
            height = 44;
            break;
        case NewCut_Section_Referee:
        {
            if(indexPath.row == 0){
                height = 44;
            }else{
                height = 125;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    [headView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    headView.frame = CGRectMake(0, 0, Size.width, 9);
    return headView;
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

//我的团队
-(WXUITableViewCell*)tableViewForUserCutCell{
    static NSString *identifier = @"cutCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@""]];
    [cell.textLabel setText:@"我的团队"];
    [cell load];
    return cell;
}

//我的推荐人
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@""]];
    [cell.textLabel setText:@"我的推荐者"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isOpen && indexPath.section == NewCut_Section_Referee){
        static NSString *identifier = @"showRefereeCell";
        NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row > 0){
//            cell = (NewGoodsInfoBDCell*)[self tabelViewForDownCellAtRow:indexPath.row];
        }
        if(indexPath.row == 0){
            [cell changeArrowWithDown:_isOpen];
            [cell.imageView setImage:[UIImage imageNamed:@""]];
            [cell.textLabel setText:@"我的推荐者"];
            [cell.textLabel setFont:WXFont(13.0)];
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        switch (section) {
            case NewCut_Section_team:
                cell = [self tableViewForUserCutCell];
                break;
            case NewCut_Section_Referee:
                cell = [self tableViewForBaseDataCell:indexPath];
                break;
            default:
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
