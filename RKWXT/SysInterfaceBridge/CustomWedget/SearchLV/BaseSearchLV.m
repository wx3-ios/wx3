//
//  BaseSearchLV.m
//  WXServer
//
//  Created by le ting on 6/12/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "BaseSearchLV.h"
#import "BaseSearchEntity.h"

@interface BaseSearchLV()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    NSMutableArray *_filterArray;
    WXUISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
}
@end

@implementation BaseSearchLV
@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize dataList = _dataList;
@synthesize delegate = _delegate;

- (void)dealloc{
    _delegate = nil;
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame searchContentsVC:(WXUIViewController*)contentsController
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat searchBarHeight = 44;
        CGSize size = frame.size;
//        _tableView = [[WXUITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView = [[WXUITableView alloc] initWithFrame:CGRectMake(0, searchBarHeight, size.width, size.height-searchBarHeight) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self addSubview:_tableView];
        
        if(contentsController){
//            CGFloat searchBarHeight = 44;
            _searchBar = [[WXUISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, searchBarHeight)];
            [_searchBar setPlaceholder:@"搜索"];
            [_searchBar sizeToFit];
//            [_tableView setTableHeaderView:_searchBar];
            if(isIOS7){
                [_searchBar setBarTintColor:WXColorWithInteger(0xCDCDCD)];
            }
            [self addSubview:_searchBar];
            _searchDisplayController = [[UISearchDisplayController alloc]
                        initWithSearchBar:_searchBar contentsController:contentsController];
            [_searchDisplayController setSearchResultsDelegate:self];
            [_searchDisplayController setSearchResultsDataSource:self];
            [_searchDisplayController setDelegate:self];
            _filterArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

#pragma mark UITableViewDatasource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = _dataList.count;
    if(_tableView != tableView){
        row = [_filterArray count];
    }
    return row;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    WXUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [self createSearchCellOfIdentifier:identifier];
    }
    BaseSearchEntity *entity = nil;
    if(_tableView == tableView){
        entity = [_dataList objectAtIndex:indexPath.row];
    }else{
        entity = [_filterArray objectAtIndex:indexPath.row];
    }
    [cell setCellInfo:entity];
    [cell load];
    return cell;
}

- (WXUITableViewCell*)createSearchCellOfIdentifier:(NSString*)identifier{
    return nil;
}

- (CGFloat)cellHeightOfEntity:(BaseSearchEntity*)entity{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseSearchEntity *entity = nil;
    if(_tableView == tableView){
        entity = [_dataList objectAtIndex:indexPath.row];
    }else{
        entity = [_filterArray objectAtIndex:indexPath.row];
    }
    CGFloat height = [self cellHeightOfEntity:entity];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseSearchEntity *entity  = nil;
    if(_tableView != tableView){
        entity = [_filterArray objectAtIndex:indexPath.row];
    }else{
        entity = [_dataList objectAtIndex:indexPath.row];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectCellInfo:)]){
        [_delegate didSelectCellInfo:entity];
    }
}

#pragma mark UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [_filterArray removeAllObjects];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [_filterArray removeAllObjects];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [_filterArray removeAllObjects];
    for(BaseSearchEntity *entity in _dataList){
        if([entity matchingString:searchString]){
            [_filterArray addObject:entity];
        }
    }
    [controller.searchResultsTableView reloadData];
    return YES;
}

@end
