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
#import "WXCityListLocationCell.h"
#import "WXUserCurrentCityCell.h"

#define Size self.bounds.size
#define NavViewHeight (64)
#define kSearchBarHeight (44)

#define UserCurrentSearchCity @"UserCurrentSearchCity"

enum{
    CityList_Section_Location = 0,
    CityList_Section_Current,
    
    CityList_Section_Invalid,
};

@interface WXShopCityListVC()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,WXCityListLocationCellDelegate,WXUserCurrentCityCellDelegate>{
    UITableView *_tableView;
    WXUISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    
    NSArray *currentCity;
}
@end

@implementation WXShopCityListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self createNavView];
    
    NSUserDefaults *userDrfault = [NSUserDefaults standardUserDefaults];
    currentCity = [userDrfault arrayForKey:UserCurrentSearchCity];

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
    
    CGFloat labelWidth = 200;
    CGFloat labelHeight = 25;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((Size.width-labelWidth)/2, 30, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [titleLabel setText:[NSString stringWithFormat:@"当前城市-%@",(userObj.userCurrentCity?userObj.userCurrentCity:userObj.userLocationCity)]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:WXFont(14.0)];
    [self.view addSubview:titleLabel];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 1;
    if(tableView == _tableView){
        section = [[[LocalAreaModel shareLocalArea] allKeys] count] + CityList_Section_Invalid;
    }
    return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tableView){
        if(section < CityList_Section_Invalid){
            return 1;
        }else{
            NSString *c = [[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section-CityList_Section_Invalid];
            NSArray *cityListArr = [[LocalAreaModel shareLocalArea].cityDic objectForKey:c];
            return [cityListArr count];
        }
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

-(WXUITableViewCell*)tableViewForLocationCityCell{
    static NSString *identifier = @"locationCell";
    WXCityListLocationCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXCityListLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForUserCurrentCityCell{
    static NSString *identifier = @"currentCell";
    WXUserCurrentCityCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUserCurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([currentCity count] > 0){
        [cell setCellInfo:currentCity];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForCityListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identifier = @"cityListCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *c = [[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section-CityList_Section_Invalid];
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
        if(section < CityList_Section_Invalid){
            if(section == CityList_Section_Location){
                cell = [self tableViewForLocationCityCell];
            }
            if(section == CityList_Section_Current){
                cell = [self tableViewForUserCurrentCityCell];
            }
        }else{
            cell = [self tableViewForCityListCell:section atRow:row];
        }
    }else{
        cell = [self tableViewForSearchCityCell:row];
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = nil;
    if(section >= CityList_Section_Invalid && tableView == _tableView){
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        [headView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        WXUILabel *label = [[WXUILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        [label setTextColor:WXColorWithInteger(0xa0a0a0)];
        [label setText:[[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section-CityList_Section_Invalid]];
        [label setFont:WXFont(12.0)];
        [headView addSubview:label];
        return headView;
    }
    if(section == CityList_Section_Location){
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        [headView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        WXUILabel *label = [[WXUILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        [label setTextColor:WXColorWithInteger(0xa0a0a0)];
        [label setText:@"定位城市"];
        [label setFont:WXFont(12.0)];
        [headView addSubview:label];
        return headView;
    }
    if(section == CityList_Section_Current){
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        [headView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        WXUILabel *label = [[WXUILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        [label setTextColor:WXColorWithInteger(0xa0a0a0)];
        [label setText:@"最近访问城市"];
        [label setFont:WXFont(12.0)];
        [headView addSubview:label];
        return headView;
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cityName = nil;
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    if(_tableView == tableView){
        if(section >= CityList_Section_Invalid){
            NSString *c = [[[LocalAreaModel shareLocalArea] allKeys] objectAtIndex:section-CityList_Section_Invalid];
            NSArray *cityList = [[LocalAreaModel shareLocalArea].cityDic objectForKey:c];
            AreaEntity *ent = [cityList objectAtIndex:row];
            [self storageCurrentCity:ent.areaName];
            cityName = ent.areaName;
            [userObj setUserSelectedAreaID:ent.areaID];
        }
    }else{
        AreaEntity *ent = [[LocalAreaModel shareLocalArea].searchCity objectAtIndex:row];
        [self storageCurrentCity:ent.areaName];
        cityName = ent.areaName;
        [userObj setUserSelectedAreaID:ent.areaID];
    }
    [self storeUserCurrentCity:cityName];
}

#pragma mark 最近访问城市存储
-(void)userCurrentCityCellBtnClicked:(NSInteger)number{
    NSString *cityName = [currentCity objectAtIndex:number-1];
    [self storageCurrentCity:cityName];
}

-(void)storageCurrentCity:(NSString*)cityName{
    if(cityName.length == 0){
        return;
    }
    NSMutableArray *cityArr = [[NSMutableArray alloc] init];
    [cityArr addObject:cityName];
    for(NSString *name in currentCity){
        if(![cityName isEqualToString:name]){
            [cityArr addObject:name];
            if([cityArr count] == 3){
                break;
            }
        }
    }
    NSUserDefaults *userDrfault = [NSUserDefaults standardUserDefaults];
    [userDrfault setObject:cityArr forKey:UserCurrentSearchCity];
    
    [self storeUserCurrentCity:cityName];
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

#pragma mark locationBtnClicked
-(void)wxCityListLocationCellBtnCLicked{
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [self storageCurrentCity:userObj.userLocationCity];
}

#pragma mark changeCurrentCity
-(void)storeUserCurrentCity:(NSString*)cityName{
    //选择城市后重新保存城市，并将区域置为空
    WXUserOBJ *userObj = [WXUserOBJ sharedUserOBJ];
    [userObj setUserCurrentCity:cityName];
    [userObj setUserLocationArea:@""];
    
    //回到上一页面
    [self closeCityListVC];
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
