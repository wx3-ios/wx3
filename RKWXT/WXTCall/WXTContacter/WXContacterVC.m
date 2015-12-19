//
//  WXContacterVC.m
//  Woxin2.0
//
//  Created by le ting on 7/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "WXContacterVC.h"
#import "WXContacterModel.h"
#import "WXContacterCell.h"
#import "AddressBook.h"
#import "ContactDetailVC.h"
#define kSectionHeadViewHeight (20.0)

@interface WXContacterVC ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    WXUITableView *_tableView;
    WXUISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    WXContacterModel *_model;
}
@end

@implementation WXContacterVC

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setBackNavigationBarItem];
    [self addOBS];
    _model = [[WXContacterModel alloc] init];
    [_model loadSystemContacters];
    CGSize size = self.view.bounds.size;
    _tableView = [[WXUITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-66-KTabBarHeight-44)];
//    _tableView = [[WXUITableView alloc] initWithFrame:self.bounds];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:WXColorWithInteger(0xd4d4d4)];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
//    if (![AddressBook sharedAddressBook].accessGranted) {
//        _accessGrantedTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, ScreenWidth - 2*20, 50)];
//        _accessGrantedTip.numberOfLines = 2;
//        _accessGrantedTip.text = @"设置路径: 设置 - 隐私 - 通讯录 - 我信通";
////        [self.view addSubview:_accessGrantedTip];
//    }
    
    _searchBar = [[WXUISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, kSearchBarHeight)];
    if ([AddressBook sharedAddressBook].count == 0) {
        [_searchBar setPlaceholder:@"搜索"];
    }else{
        [_searchBar setPlaceholder:[NSString stringWithFormat:@"搜索%li个联系人",(long)[AddressBook sharedAddressBook].count]];
    }
    [_searchBar sizeToFit];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];

    _searchDisplayController = [[UISearchDisplayController alloc]
                                initWithSearchBar:_searchBar contentsController:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(sysContacterChanged)
           name:D_Notification_Name_AddressBookHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(wxContactersChanged) name:D_Notification_Name_WXAddressBookHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(singleContacterChanged:) name:D_Notification_Name_WXContacterHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(singleContacterAdded:) name:D_Notification_Name_WXContacterAdded object:nil];
    [notificationCenter addObserver:self selector:@selector(searchContactResult) name:SearchContactResult object:nil];
}

- (void)sysContacterChanged{
    [_model loadSystemContacters];
    [_tableView reloadData];
}

-(void)getAllPeopleContact{
    [[AddressBook sharedAddressBook] loadContact];
}

- (void)wxContactersChanged{
    [_tableView reloadData];
}

- (NSArray*)sysContactersISWX:(WXContacterEntity*)entity{
    if(!entity){
        return nil;
    }
    NSString *phone = entity.bindID;
    if(!phone){
        return nil;
    }
    NSMutableArray *matchArray = [NSMutableArray array];
    NSInteger sections = [self numberOfSectionsInTableView:_tableView];
    for(NSInteger section = 1; section < sections; section++){
        NSInteger rows = [self tableView:_tableView numberOfRowsInSection:section];
        for(NSInteger row=0; row<rows; row++){
            ContacterEntity*entity = [[self contactersAtSection:section] objectAtIndex:row];
            if([entity.phoneNumbers indexOfObject:phone] != NSNotFound){
                [matchArray addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        }
    }
    if([matchArray count] == 0){
        return nil;
    }
    return matchArray;
}

- (void)singleContacterChanged:(NSNotification*)notification{
    WXContacterEntity *entity = notification.object;
    NSArray *indexPathArray = [self sysContactersISWX:entity];
    if(indexPathArray){
        [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)singleContacterAdded:(NSNotification*)notification{
    WXContacterEntity *entity = notification.object;
    NSArray *indexPathArray = [self sysContactersISWX:entity];
    if(indexPathArray){
        [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)removeOBS{
     NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 1;
    if(_tableView == tableView){
         //+1为通讯录的其他操作~
        section = [[_model allKeys] count];
    }
    return section;
}

- (NSArray*)contactersAtSection:(NSInteger)section{
    if(section == 0){
        return _model.contactOptArray;
    }else{
        NSString *key = [[_model allKeys] objectAtIndex:section];
        NSMutableArray *contacters = [_model.sysContacterDic objectForKey:key];
        return contacters;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if(tableView != _tableView){
        row = [_model.filterArray count];
    }else{
        row = [self contactersAtSection:section].count;
    }
    return row;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *sectionTitles = nil;
    if(_tableView == tableView){
        sectionTitles = [_model allKeys];
    }
    return sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger section = 0;
    if(_tableView == tableView){
        section = [[_model allKeys] indexOfObject:title];
    }
    return section;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    WXContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[WXContacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    id cellInfo = nil;
    if(tableView != _tableView){
        cellInfo = [_model.filterArray objectAtIndex:indexPath.row];
    }else{
        cellInfo = [[self contactersAtSection:indexPath.section] objectAtIndex:indexPath.row];
    }
    [cell setCellInfo:cellInfo];
    [cell load];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
//
    if(tableView == _tableView){
        if(section == 0){
//            switch (row) {
////            case E_ContactOPTType_Merchant:
////                break;
////            case E_ContactOPTType_WXTeam:
////                break;
////            case E_ContactOPTType_MultiChat:
////                break;
//            case E_ContactOPTType_WXContacter:
//                [[CoordinateController sharedCoordinateController] toAllWXContacters:self animated:YES];
//                break;
//            }
        }else{
            ContacterEntity *entity = [[self contactersAtSection:section] objectAtIndex:row];
            if(_detailDelegate && [_detailDelegate respondsToSelector:@selector(toContailDetailVC:)]){
                [_detailDelegate toContailDetailVC:entity];
            }
        }
    }else{
        
        ContacterEntity *entity = [_model.filterArray objectAtIndex:row];
        if(_detailDelegate && [_detailDelegate respondsToSelector:@selector(toContailDetailVC:)]){
            [_detailDelegate toContailDetailVC:entity];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if(section > 0 && _tableView == tableView){
        height = kSectionHeadViewHeight;
    }
    return height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = nil;
    if(section > 0 && tableView == _tableView){
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kSectionHeadViewHeight)] ;
        [headView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        WXUILabel *label = [[WXUILabel alloc] initWithFrame:CGRectMake(5, 0, 200, kSectionHeadViewHeight)] ;
        [label setTextColor:WXColorWithInteger(0xa0a0a0)];
        [label setText:[[_model allKeys] objectAtIndex:section]];
        [label setFont:WXFont(12.0)];
        [headView addSubview:label];
        return headView;
    }
    return headView;
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
//    for(UIView *subView in searchBar.subviews){
//        if([subView isKindOfClass:[UIButton class]]){
//            [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
//        }
//    }
    return YES;
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [_model removeMatchingContact];
    UIView *topView = controller.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];  //@"取消"
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [_model removeMatchingContact];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [_model removeMatchingContact];
    [_model matchSearchStringList:searchString];
//    [controller.searchResultsTableView reloadData];
//    [self showWaitView:self.view];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    return YES;
}

-(void)searchContactResult{
    [self unShowWaitView];
    [_searchDisplayController.searchResultsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_searchDisplayController.searchResultsTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self unShowWaitView];
}

@end
