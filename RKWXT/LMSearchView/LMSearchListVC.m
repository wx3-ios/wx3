//
//  LMSearchListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/9.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchListVC.h"
#import "LMHotSearchListCell.h"

//搜索
#import "LMSearchInsertData.h"
#include "LMSearchHistoryEntity.h"
#import "LMSearchHistoryModel.h"

#define Size self.bounds.size

@interface LMSearchListVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    WXUITextField *_textField;
    UITableView *_tableView;
    
    BOOL showHistory;
    LMSearchHistoryModel *_historyModel;
    
    NSArray *hotSearchArr;  //热门搜索
    NSArray *searchHistoryArr; //搜索历史
    NSArray *searchListArr;  //搜索记录
}

@end

@implementation LMSearchListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(_historyModel){
        [self addOBS];
        [_historyModel loadLMSearchHistoryList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xffffff)];
    showHistory = YES;
    
    [self createNavigationBar];
    [self createSearchView];
    
    hotSearchArr = @[@"你好", @"啊啊", @"不知道", @"可以", @"是的", @"放假", @"休息"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 66, Size.width, Size.height-66);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
    _historyModel = [[LMSearchHistoryModel alloc] init];
    [_historyModel loadLMSearchHistoryList];
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loadLMSearchHistoryListSucceed) name:D_Notification_Name_LMSearchHistoryLoadSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(delLMSearchHistoryOneRecordSucceed) name:D_Notification_Name_LMSearchHistoryDelOnRecordSucceed object:nil];
}

-(void)createNavigationBar{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:imgView];
    
    CGFloat xOffset = 15;
    CGFloat yOffset = 40;
    UIImage *img = [UIImage imageNamed:@"T_BackWhite.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
}

-(void)createSearchView{
    CGFloat width = 3*Size.width/4;
    CGFloat height = 25;
    _textField = [[WXUITextField alloc] initWithFrame:CGRectMake((Size.width-width)/2, 66-height-10, width, height)];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(changeInput) forControlEvents:UIControlEventEditingChanged];
    [_textField setBackgroundColor:[UIColor yellowColor]];
    [_textField setBorderRadian:9.0 width:1.0 color:[UIColor clearColor]];
    [_textField setFont:WXFont(13.0)];
    [_textField becomeFirstResponder];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setTintColor:[UIColor whiteColor]];
    [_textField setPlaceHolder:@"搜索商家、商品" color:WXColorWithInteger(0xffffff)];
    [self addSubview:_textField];
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
    NSInteger section = 0;
    if(showHistory){
        section = 2;
    }else{
        section = 1;
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showHistory){
        if(section == 0){
            return [hotSearchArr count]>0?1:0;
        }else{
            return [searchHistoryArr count];
        }
    }else{
        return [searchListArr count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    if(showHistory){
        if(section == 0){
            height = [LMHotSearchListCell cellHeightOfInfo:hotSearchArr];
        }else{
            height = 44;
        }
    }else{
        height = 44;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height = 20;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, Size.width, height);
    [view setBackgroundColor:[UIColor whiteColor]];
    
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(12, 0, 100, 20);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setTextColor:WXColorWithInteger(0x000000)];
    [textLabel setFont:WXFont(13.0)];
    [view addSubview:textLabel];
    
    NSString *text = nil;
    if(showHistory){
        if(section == 0){
            text = @"热门搜索";
        }
        if(section == 1){
            text = @"搜索历史";
        }
    }else{
        text = @"搜索结果";
    }
    [textLabel setText:text];
    return view;
}

-(WXUITableViewCell*)hotSearchListCell{
    static NSString *identifier = @"hotSearchListCell";
    LMHotSearchListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LMHotSearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:hotSearchArr];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)searchHistoryListCell:(NSInteger)row{
    static NSString *identifier = @"historyListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([searchHistoryArr count] > 0){
        LMSearchHistoryEntity *entity = [searchHistoryArr objectAtIndex:row];
        [cell.textLabel setText:entity.recordName];
    }
    return cell;
}

//搜索记录
-(WXUITableViewCell*)searchResultListCell:(NSInteger)row{
    static NSString *identifier = @"resultListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row > 0){
        
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(showHistory){
        if(section == 0){
            cell = [self hotSearchListCell];
        }else{
            cell = [self searchHistoryListCell:row];
        }
    }else{
        cell = [self searchResultListCell:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(showHistory){
        if(indexPath.section == 0){
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    LMSearchHistoryEntity *entity = [searchHistoryArr objectAtIndex:row];
    [_historyModel deleteLMSearchRecordWith:entity.recordName];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark textfield Deleagte
-(void)changeInput{
    if(_textField.text.length == 0){
        showHistory = YES;
        [_tableView reloadData];
    }else{
        showHistory = NO;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)textFieldDone:(id)sender{
    [_textField resignFirstResponder];
    [self insertHistoryData:_textField.text andRecordID:1];
}

#pragma mark 搜索
-(void)insertHistoryData:(NSString*)recordName andRecordID:(NSInteger)recordID{
    if(recordName.length == 0){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(LMSearchHistoryEntity *entity in searchHistoryArr){
            if([entity.recordName isEqualToString:recordName]){
                [_historyModel deleteLMSearchRecordWith:entity.recordName];
                break;
            }
        }
        LMSearchInsertData *insertData = [[LMSearchInsertData alloc] init];
        [insertData insertData:recordName withRecordID:[NSString stringWithFormat:@"%ld",(long)recordID] with:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_historyModel loadLMSearchHistoryList];
        });
    });
}

-(void)loadLMSearchHistoryListSucceed{
    searchHistoryArr = _historyModel.listArr;
    [_tableView reloadData];
}

-(void)delLMSearchHistoryOneRecordSucceed{
    
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
