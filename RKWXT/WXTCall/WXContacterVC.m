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

#define kSectionHeadViewHeight (20.0)

@interface WXContacterVC ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>{
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
    self.view.backgroundColor = [UtilTool colorWithHexString:@"#efeff4"];
    [self setCSTTitle:@"通讯录"];
    [self setBackNavigationBarItem];
    [self addOBS];
    _model = [[WXContacterModel alloc] init];
    CGSize size = self.bounds.size;
    _tableView = [[WXUITableView alloc] initWithFrame:CGRectMake(0, 50, size.width, size.height-46)];
//    _tableView = [[WXUITableView alloc] initWithFrame:self.bounds];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:WXColorWithInteger(0xd4d4d4)];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    
    CGFloat searchBarHeight = 44;
    _searchBar = [[WXUISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, searchBarHeight)];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar sizeToFit];
//    [_tableView setTableHeaderView:_searchBar];

    [self addSubview:_searchBar];
    _searchDisplayController = [[UISearchDisplayController alloc]
                                initWithSearchBar:_searchBar contentsController:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setDelegate:self];
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(sysContacterChanged)
           name:D_Notification_Name_AddressBookHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(wxContactersChanged) name:D_Notification_Name_WXAddressBookHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(singleContacterChanged:) name:D_Notification_Name_WXContacterHasChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(singleContacterAdded:) name:D_Notification_Name_WXContacterAdded object:nil];
}

- (void)sysContacterChanged{
    [_model loadSystemContacters];
    [_tableView reloadData];
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
    
//    if(tableView == _tableView){
//        if(section == 0){
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
//        }else{
//            ContacterEntity *entity = [[self contactersAtSection:section] objectAtIndex:row];
//            [[CoordinateController sharedCoordinateController] toContactDetail:self contactInfo:entity contactType:E_ContacterType_System animated:YES];
//        }
//    }else{
//        ContacterEntity *entity = [_model.filterArray objectAtIndex:row];
//        [[CoordinateController sharedCoordinateController] toContactDetail:self contactInfo:entity contactType:E_ContacterType_System animated:YES];
//    }
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
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [_model removeMatchingContact];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [_model removeMatchingContact];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [_model removeMatchingContact];
    [_model matchSearchStringList:searchString];
    [controller.searchResultsTableView reloadData];
    return YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%s",__FUNCTION__);
}
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items{
        NSLog(@"%s",__FUNCTION__);
}
@end
