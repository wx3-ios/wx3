//
//  LMSearchListVC.m
//  RKWXT
//
//  Created by SHB on 15/12/9.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "LMSearchListVC.h"
#import "LMHotSearchListCell.h"

//搜索历史
#import "LMSearchInsertData.h"
#include "LMSearchHistoryEntity.h"
#import "LMSearchHistoryModel.h"

//搜索
#import "LMSearchDataModel.h"
#import "LMSearchGoodsEntity.h"
#import "LMSearchSellerEntity.h"
#import "WXDropListView.h"

//跳转
#import "LMSearchGoodsResultVC.h"
#import "LMSearchSellerResultVC.h"

#define Size self.bounds.size

typedef enum{
    LMSearch_Goods = 1,
//    LMSearch_Shop = 2,
    LMSearch_Seller = 3,
}LMSearch;

@interface LMSearchListVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,LMSearchDataModelDelegate,WXDropListViewDelegate>{
    WXUITextField *_textField;
    WXUIButton *changeBtn;
    LMSearch searchType;
    WXDropListView *_dropListView;
    
    UITableView *_tableView;
    
    BOOL showHistory;
    LMSearchHistoryModel *_historyModel;  //搜索历史
    LMSearchDataModel *_searchModel; //搜索
    
    NSArray *hotSearchArr;  //热门搜索
    NSArray *searchHistoryArr; //搜索历史
    NSArray *searchListArr;  //搜索记录
}

@end

@implementation LMSearchListVC
static NSString* g_dropItemList[2] ={
    @"商品",
    @"商家",
};

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(_historyModel){
        [self addOBS];
        [_historyModel loadLMSearchHistoryList];
    }
}

-(id)init{
    self = [super init];
    if(self){
        _searchModel = [[LMSearchDataModel alloc] init];
        [_searchModel setDelegate:self];
    }
    return self;
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
    searchType = LMSearch_Goods;  //默认搜索商品
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
    CGFloat btnWidth = 50;
    CGFloat btnHeight = 25;
    CGFloat xOffset = 40;
    changeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(xOffset, 66-btnHeight-5, btnWidth, btnHeight);
    [changeBtn setBackgroundColor:WXColorWithInteger(0xb01716)];
    [changeBtn setBorderRadian:1.0 width:1.0 color:[UIColor clearColor]];
    [changeBtn setTitleColor:WXColorWithInteger(0xc9c9c9) forState:UIControlStateNormal];
    [changeBtn.titleLabel setFont:WXFont(13.0)];
    [changeBtn setTitle:@"商品" forState:UIControlStateNormal];
    [changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [changeBtn setImage:[UIImage imageNamed:@"LMSearchDropUp.png"] forState:UIControlStateNormal];
    [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    //    [changeBtn addTarget:self action:@selector(changeSearchTerm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeBtn];
    
    CGFloat width = Size.width-xOffset-btnWidth-40;
    CGFloat height = 25;
    _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset+btnWidth-1, 66-height-5, width, height)];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(changeInput) forControlEvents:UIControlEventEditingChanged];
    [_textField setBackgroundColor:WXColorWithInteger(0xb01716)];
    [_textField setBorderRadian:1.0 width:1.0 color:[UIColor clearColor]];
    [_textField setFont:WXFont(13.0)];
    [_textField becomeFirstResponder];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setTintColor:[UIColor whiteColor]];
    [_textField setPlaceHolder:@"搜索商品" color:WXColorWithInteger(0xffffff)];
    [self addSubview:_textField];
    
    _dropListView = [self createDropListViewWith:changeBtn];
    [_dropListView unshow:NO];
    [self.view addSubview:_dropListView];
}

//下拉菜单
- (WXDropListView*)createDropListViewWith:(WXUIButton*)btn{
    NSInteger row = LMSearch_Seller;
    CGFloat width = 100;
    CGFloat height = 40;
    CGRect rect = CGRectMake(90, 60, width, row*height);
    WXDropListView *dropListView = [[WXDropListView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height+100) menuButton:btn dropListFrame:rect];
    [dropListView setDelegate:self];
    [dropListView setFont:[UIFont systemFontOfSize:15.0]];
    [dropListView setDropDirection:E_DropDirection_Right];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        WXDropListItem *item = [[WXDropListItem alloc] init];
        [item setTitle:g_dropItemList[i]];
        [itemArray addObject:item];
    }
    [dropListView setDataList:itemArray];
    return dropListView;
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
    [textLabel setTextColor:WXColorWithInteger(0x969696)];
    [textLabel setFont:WXFont(12.0)];
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

//搜索记录
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
//商品
-(WXUITableViewCell*)searchGoodsResultListCell:(NSInteger)row{
    static NSString *identifier = @"goodsResultListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([searchListArr count] > 0){
        LMSearchGoodsEntity *entity = [searchListArr objectAtIndex:row];
        [cell.textLabel setText:entity.goodsName];
    }
    return cell;
}

//商家
-(WXUITableViewCell*)searchSellerResultListCell:(NSInteger)row{
    static NSString *identifier = @"sellerResultListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([searchListArr count] > 0){
        LMSearchSellerEntity *entity = [searchListArr objectAtIndex:row];
        [cell.textLabel setText:entity.sellerName];
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
        if(searchType == LMSearch_Goods){
            cell = [self searchGoodsResultListCell:row];
        }
        if(searchType == LMSearch_Seller){
            cell = [self searchSellerResultListCell:row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(showHistory){
        if(section == 1){
            LMSearchHistoryEntity *entity = [searchHistoryArr objectAtIndex:row];
            [self insertHistoryData:entity.recordName andRecordID:[entity.recordID integerValue] searchType:[entity.other integerValue]];
            if([entity.other integerValue] == LMSearch_Goods){
                [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:[entity.recordID integerValue] animated:YES];
            }
            if([entity.other integerValue] == LMSearch_Seller){
                [[CoordinateController sharedCoordinateController] toLMSellerInfopVC:self sellerID:[entity.recordID integerValue] animated:YES];
            }
        }
    }else{
        if(searchType == LMSearch_Goods){
            LMSearchGoodsEntity *entity = [searchListArr objectAtIndex:row];
            [self insertHistoryData:entity.goodsName andRecordID:entity.goodsID searchType:LMSearch_Goods];
            [[CoordinateController sharedCoordinateController] toLMGoodsInfoVC:self goodsID:entity.goodsID animated:YES];
        }
        if(searchType == LMSearch_Seller){
            LMSearchSellerEntity *entity = [searchListArr objectAtIndex:row];
            [self insertHistoryData:entity.sellerName andRecordID:entity.sellerID searchType:LMSearch_Seller];
            [[CoordinateController sharedCoordinateController] toLMSellerInfopVC:self sellerID:entity.sellerID animated:YES];
        }
    }
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
        if(searchType == LMSearch_Goods){
            [_searchModel lmSearchInputKeyword:_textField.text searchType:LMSearch_Type_Goods];
        }
        if(searchType == LMSearch_Seller){
            [_searchModel lmSearchInputKeyword:_textField.text searchType:LMSearch_Type_Seller];
        }
    }
}

-(void)lmSearchDataSucceed{
    searchListArr = _searchModel.searchListArr;
    [_tableView reloadData];
}

-(void)lmSearchDataFailed:(NSString *)errorMsg{
}

-(void)textFieldDone:(id)sender{
    [_textField resignFirstResponder];
    
    if([searchListArr count] > 0){
        if(searchType == LMSearch_Goods){
            LMSearchGoodsResultVC *searchListVC = [[LMSearchGoodsResultVC alloc] init];
            searchListVC.searchList = searchListArr;
            searchListVC.titleName = _textField.text;
            [self.wxNavigationController pushViewController:searchListVC];
        }
        if(searchType == LMSearch_Seller){
            LMSearchSellerResultVC *sellerVC = [[LMSearchSellerResultVC alloc] init];
            sellerVC.listArr = searchListArr;
            [self.wxNavigationController pushViewController:sellerVC];
        }
    }
}

#pragma mark 搜索
-(void)insertHistoryData:(NSString*)recordName andRecordID:(NSInteger)recordID searchType:(LMSearch)search{
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
        [insertData insertData:recordName withRecordID:[NSString stringWithFormat:@"%ld",(long)recordID] with:[NSString stringWithFormat:@"%ld",(long)search]];
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

//更改搜索方式
-(void)menuClickAtIndex:(NSInteger)index{
    if(index+1 == LMSearch_Goods){
        searchType = LMSearch_Goods;
        [changeBtn setTitle:@"商品" forState:UIControlStateNormal];
        [_textField setPlaceHolder:@"搜索商品" color:WXColorWithInteger(0xffffff)];
    }
    //暂时屏蔽掉店铺
    if(index+2 == LMSearch_Seller){
        searchType = LMSearch_Seller;
        [changeBtn setTitle:@"商家" forState:UIControlStateNormal];
        [_textField setPlaceHolder:@"搜索商家" color:WXColorWithInteger(0xffffff)];
    }
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
