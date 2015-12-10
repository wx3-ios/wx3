//
//  ClassifySearchVC.m
//  RKWXT
//
//  Created by SHB on 15/10/20.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifySearchVC.h"
#import "WXDropListView.h"
#import "WXUITextField.h"
#import "ClassifySrarchListCell.h"
#import "ClassifyHistoryCell.h"

#import "ClassifyHistoryModel.h"
#import "ClassifyInsertData.h"
#import "ClassifySqlEntity.h"

#import "CLassifySearchModel.h"
#import "SearchResultEntity.h"

#import "NewGoodsInfoVC.h"
#import "CLassifySearchListVC.h"

#define Size self.bounds.size
enum{
    CLassify_Search_Goods = 0,
    CLassify_Search_Store,
    
    CLassify_Search_Invalid,
};

@interface ClassifySearchVC()<UIAlertViewDelegate,WXDropListViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLassifySearchModelDelegate>{
    WXUIButton *dropListBtn;
    WXDropListView *_dropListView;
    WXUITextField *_textField;
    
    UITableView *_tableView;
    BOOL showHistory;
    
    NSArray *searchListArr;
    NSArray *historyListArr;
    
    ClassifyHistoryModel *_historyModel;
    CLassifySearchModel *_searchModel;
}
@end

@implementation ClassifySearchVC
static NSString* g_dropItemList[CLassify_Search_Invalid] ={
    @"商品",
    @"店铺",
};

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(_historyModel){
        [self addOBS];
        [_historyModel loadClassifyHistoryList];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self createNavigationBar];
    showHistory = YES;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 66, Size.width, Size.height-66);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [self addOBS];
    _historyModel = [[ClassifyHistoryModel alloc] init];
    [_historyModel loadClassifyHistoryList];
    
    _searchModel = [[CLassifySearchModel alloc] init];
    [_searchModel setDelegate:self];
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loadClassifyHistoryListSucceed) name:D_Notification_Name_ClassifyHistoryLoadSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(delClassifyHistoryOneRecordSucceed) name:D_Notification_Name_ClassifyHistoryDelOnRecordSucceed object:nil];
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
    
    [self createDropListViewBtn:xOffset+img.size.width with:yOffset];
}

-(void)createDropListViewBtn:(CGFloat)xGap with:(CGFloat)yGap{
    CGFloat xOffset = xGap+20;
    CGFloat yOffset = yGap;
    CGFloat btnHeight = 20;
    WXUILabel *leftLine = [[WXUILabel alloc] init];
    leftLine.frame = CGRectMake(xOffset, yOffset+btnHeight/2-2, 0.5, 6);
    [leftLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:leftLine];
    
    CGFloat rightBtnWidth = 40;
    WXUILabel *downLine = [[WXUILabel alloc] init];
    downLine.frame = CGRectMake(xOffset, leftLine.frame.origin.y+leftLine.frame.size.height+1, Size.width-2*10-rightBtnWidth-xOffset, 0.5);
    [downLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:downLine];
    
    CGFloat dropListBtnWidth = 50;
    xOffset += 1;
    dropListBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    dropListBtn.frame = CGRectMake(xOffset, yOffset, dropListBtnWidth, btnHeight);
    [dropListBtn setBackgroundColor:[UIColor clearColor]];
    [dropListBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [dropListBtn.titleLabel setFont:WXFont(13.0)];
    [dropListBtn setTitle:@"商品" forState:UIControlStateNormal];
    [dropListBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 10)];
    [dropListBtn setImage:[UIImage imageNamed:@"ClassifySearchBtnImg.png"] forState:UIControlStateNormal];
    [dropListBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [self addSubview:dropListBtn];
    
    _dropListView = [self createDropListViewWith:dropListBtn];
    [_dropListView unshow:NO];
//    [self.view addSubview:_dropListView];
    
    xOffset += dropListBtnWidth+8;
    _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset-3, Size.width-xOffset-rightBtnWidth-2*10, btnHeight)];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(changeInputTextfield) forControlEvents:UIControlEventEditingChanged];
    [_textField setFont:WXFont(13.0)];
    [_textField becomeFirstResponder];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setTintColor:[UIColor whiteColor]];
    [_textField setPlaceHolder:@"搜索" color:WXColorWithInteger(0xffffff)];
    [self addSubview:_textField];
    
    WXUILabel *rightLine = [[WXUILabel alloc] init];
    rightLine.frame = CGRectMake(_textField.frame.origin.x+_textField.frame.size.width-0.5, yOffset+btnHeight/2-2, 0.5, 6);
    [rightLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:rightLine];
}

//下拉菜单
- (WXDropListView*)createDropListViewWith:(WXUIButton*)btn{
    NSInteger row = CLassify_Search_Invalid;
    CGFloat width = 100;
    CGFloat height = 40;
    CGRect rect = CGRectMake(90, 60, width, row*height);
    WXDropListView *dropListView = [[WXDropListView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height+100) menuButton:btn dropListFrame:rect];
    [dropListView setDelegate:self];
    [dropListView setFont:[UIFont systemFontOfSize:15.0]];
    [dropListView setDropDirection:E_DropDirection_Right];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < CLassify_Search_Invalid; i++) {
        WXDropListItem *item = [[WXDropListItem alloc] init];
        [item setTitle:g_dropItemList[i]];
        [itemArray addObject:item];
    }
    [dropListView setDataList:itemArray];
    return dropListView;
}

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showHistory){
        return ([historyListArr count]>0?[historyListArr count]+1:1);
    }else{
        return [searchListArr count]+1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

//search
-(WXUITableViewCell *)tableViewForSearchListCellAt:(NSInteger)row{
    static NSString *identifier = @"searchListCell";
    ClassifySrarchListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifySrarchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == 0){
        [cell setCellInfo:AlertName];
        [cell setCount:[searchListArr count]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        SearchResultEntity *entity = searchListArr[row-1];
        [cell setCellInfo:entity];
    }
    [cell load];
    return cell;
}

//history
-(WXUITableViewCell *)tableViewForHistoryListCellAt:(NSInteger)row{
    static NSString *identifier = @"historyListCell";
    ClassifyHistoryCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifyHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == 0){
        [cell setCellInfo:AlertRecordName];
        [cell setCount:[historyListArr count]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else{
        ClassifySqlEntity *entity = historyListArr[row-1];
        [cell setCellInfo:entity];
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    if(showHistory){
        cell = [self tableViewForHistoryListCellAt:row];
    }else{
        cell = [self tableViewForSearchListCellAt:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        return;
    }
    NSInteger goodsID = 0;
    NSString *name = nil;
    if(!showHistory){
        SearchResultEntity *entity = [searchListArr objectAtIndex:indexPath.row-1];
        goodsID = entity.goodsID;
        name = entity.goodsName;
    }else{
        ClassifySqlEntity *entity = historyListArr[indexPath.row-1];
        goodsID = [entity.recordID integerValue];
        name = entity.recordName;
    }
    [self insertHistoryData:name andRecordID:goodsID];  //加入本地数据库
    
    //去详情页面
    NewGoodsInfoVC *goodsInfoVC = [[NewGoodsInfoVC alloc] init];
    [goodsInfoVC setGoodsId:goodsID];
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

#pragma mark delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(showHistory){
        if(indexPath.row == 0){
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
    ClassifySqlEntity *entity = [historyListArr objectAtIndex:row-1];
    [_historyModel deleteClassifyRecordWith:entity.recordName];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark dropListDelegate
-(void)menuClickAtIndex:(NSInteger)index{
    if(index == 0){
        [dropListBtn setTitle:@"商品" forState:UIControlStateNormal];
    }else{
        [dropListBtn setTitle:@"店铺" forState:UIControlStateNormal];
    }
}

-(void)changeInputTextfield{
    if(_textField.text.length == 0){
        showHistory = YES;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        showHistory = NO;
        _searchModel.searchType = Search_Type_Goods;
        [_searchModel classifySearchWith:_textField.text];
    }
}

-(void)classifySearchResultSucceed{
    searchListArr = _searchModel.searchResultArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark sql
-(void)loadClassifyHistoryListSucceed{
    historyListArr = _historyModel.listArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)delClassifyHistoryOneRecordSucceed{
}

//插入数据
-(void)textFieldDone:(id)sender{
    WXUITextField *textField = sender;
    [textField resignFirstResponder];
    
    if([searchListArr count] > 0){
        CLassifySearchListVC *searchListVC = [[CLassifySearchListVC alloc] init];
        searchListVC.searchList = searchListArr;
        [self.wxNavigationController pushViewController:searchListVC];
    }
}

-(void)insertHistoryData:(NSString*)recordName andRecordID:(NSInteger)recordID{
    if(recordName.length == 0){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(ClassifySqlEntity *entity in historyListArr){
            if([entity.recordName isEqualToString:recordName]){
                [_historyModel deleteClassifyRecordWith:entity.recordName];
                break;
            }
        }
        ClassifyInsertData *insertData = [[ClassifyInsertData alloc] init];
        [insertData insertData:recordName withRecordID:[NSString stringWithFormat:@"%ld",(long)recordID] with:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_historyModel loadClassifyHistoryList];
        });
    });
}

#pragma mark clearHistory 暂时不用
-(void)clearSearchHistoryList{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除所有搜索记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_historyModel deleteAll];
            showHistory = NO;
            historyListArr = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        });
    }
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
