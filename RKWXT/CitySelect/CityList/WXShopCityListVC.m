//
//  WXShopCityListVC.m
//  RKWXT
//
//  Created by SHB on 15/11/17.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXShopCityListVC.h"
#import "LocalAreaModel.h"
#import "AreaEntity.h"

#define Size self.bounds.size
#define NavViewHeight (64)
#define kSearchBarHeight (44)

@interface WXShopCityListVC()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    UITableView *_tableView;
    WXUISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
}
@end

@implementation WXShopCityListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self createNavView];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, kSearchBarHeight+NavViewHeight, Size.width, Size.height-kSearchBarHeight-NavViewHeight);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorColor:WXColorWithInteger(0xd4d4d4)];
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _searchBar = [[WXUISearchBar alloc] initWithFrame:CGRectMake(0, NavViewHeight, Size.width, kSearchBarHeight)];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar sizeToFit];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addOBS];
}

-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchCityResult) name:CityListSearchResultNoti object:nil];
}

-(void)createNavView{
    WXUIImageView *navImgView = [[WXUIImageView alloc] init];
    navImgView.frame = CGRectMake(0, 0, Size.width, NavViewHeight);
    [navImgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self.view addSubview:navImgView];
    
    WXUIButton *closeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(15, 30, 25, 25);
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeCityListVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 1;
    if(tableView == _tableView){
        section = [[[LocalAreaModel shareLocalArea] allKeys] count];
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tableView){
        NSString *c = [[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section];
        NSArray *cityListArr = [[LocalAreaModel shareLocalArea].cityDic objectForKey:c];
        return [cityListArr count];
    }else{
        return [[LocalAreaModel shareLocalArea].searchCity count];
    }
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *sectionTitles = nil;
    if(_tableView == tableView){
        sectionTitles = [[LocalAreaModel shareLocalArea] allKeys];
    }
    return sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger section = 0;
    if(_tableView == tableView){
        section = [[[LocalAreaModel shareLocalArea] allKeys] indexOfObject:title];
    }
    return section;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == _tableView){
        return 20;
    }
    return 0;
}

-(WXUITableViewCell*)tableViewForCityListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identifier = @"cityListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *c = [[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section];
    NSArray *cityList = [[LocalAreaModel shareLocalArea].cityDic objectForKey:c];
    AreaEntity *ent = [cityList objectAtIndex:row];
    [cell.textLabel setText:ent.areaName];
    return cell;
}

-(WXUITableViewCell*)tableViewForSearchCityCell:(NSInteger)row{
    static NSString *identifier = @"searchCityCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    AreaEntity *ent = [[LocalAreaModel shareLocalArea].searchCity objectAtIndex:row];
    [cell.textLabel setText:ent.areaName];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(_tableView == tableView){
        cell = [self tableViewForCityListCell:section atRow:row];
    }else{
        cell = [self tableViewForSearchCityCell:row];
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = nil;
    if(section >= 0 && tableView == _tableView){
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] ;
        [headView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        WXUILabel *label = [[WXUILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)] ;
        [label setTextColor:WXColorWithInteger(0xa0a0a0)];
        [label setText:[[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section]];
        [label setFont:WXFont(12.0)];
        [headView addSubview:label];
        return headView;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark search
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [[LocalAreaModel shareLocalArea] removeMatchingCity];
    UIView *topView = controller.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];  //@"取消"
        }
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [[LocalAreaModel shareLocalArea] removeMatchingCity];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [[LocalAreaModel shareLocalArea] removeMatchingCity];
    [[LocalAreaModel shareLocalArea] searchCityArrayWithKeyword:searchString];
    return YES;
}

-(void)searchCityResult{
    [_searchDisplayController.searchResultsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark closeBtn
-(void)closeCityListVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
