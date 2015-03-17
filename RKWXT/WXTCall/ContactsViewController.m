//
//  ContactsViewController.m
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-3.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactUitl.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsCell.h"
//#import "AreaHelper.h"
#import <KVOController/FBKVOController.h>
#import "Tools.h"
#import "UIViewController+Helper.h"

@interface ContactsViewController ()<UISearchBarDelegate>
{
    //本地联系人列表
    NSMutableDictionary *_contactDictionary;
    NSMutableArray *_contactArray;
    NSArray *_contactKeys;
    
    //搜索后的列表
    NSMutableArray	*_filteredListContent;	// The content filtered as a result of a search.
    
    NSMutableDictionary *_sectionIndexDictionary;
    UISearchDisplayController *_displayController;
    
    BOOL _inSearching;
    BOOL _hasKefu;
}
@property (nonatomic, strong) FBKVOController *kvoController;
@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [NOTIFY_CENTER addObserver:self selector:@selector(areaNotification:) name:AreaDataLoadingFinishNotification object:nil];
    
    //    _titleView.backgroundColor = THEME_COLOR;
    //    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //去掉searchbar背景
    //    for (UIView *view in _searchBar.subviews) {
    //        for (UIView *v in view.subviews) {
    //            if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
    //                [v removeFromSuperview];
    //            }
    //        }
    //    }
    
    //
    UINavigationBar * navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    [self initUI];
    [_tableView registerNib:[UINib nibWithNibName:@"ContactsCell" bundle:nil] forCellReuseIdentifier:@"ContactsCell"];
    
    //add bottom line
    UIView *bottomLineImageView = nil;
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            for (UIView *lineImageView in view.subviews) {
                if ([lineImageView isKindOfClass:[UIImageView class]]) {
                    bottomLineImageView = lineImageView;
                }
            }
        }
    }
    if (bottomLineImageView) {
        [_titleView addSubview:bottomLineImageView];
        bottomLineImageView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 0.5);
    }
    
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
     forState:UIControlStateNormal];
    
    //如果已经授权..不显示提示框
    if ([ContactUitl isAuthorized]) {
        self.tableView.tableFooterView = nil;
    }
    
    //    self.kvoController = [FBKVOController controllerWithObserver:self];
    //    [_kvoController observe:_tableView keyPath:@"visibleCells" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
    //        NSLog(@"visibleCells = %@", _tableView.visibleCells);
    //    }];
}

-(void)initUI{
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    
    
    searchDisplayController = [[UISearchDisplayController alloc]
                               initWithSearchBar:_searchBar contentsController:self];
    [searchDisplayController setSearchResultsDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setDelegate:self];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 46)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_contactArray || !_hasKefu) {
        [self initLocalContacts];
    }
}


- (void)hideSearchbar:(id)sender
{
    _inSearching = NO;
    _filteredListContent = nil;
    [self.tableView reloadData];
    [self.view endEditing:YES];
    _searchWidthLayoutConstraint.constant = 44;
    [UIView animateWithDuration:0.3 delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [_titleView layoutIfNeeded];
                            [_searchBar setShowsCancelButton:NO];
                        } completion:^(BOOL finished) {
                            _searchBar.hidden = YES;
                            _searchBar.text = @"";
                            _searchButton.hidden = NO;
                            
                        }];
}

- (IBAction)showSearchbar:(id)sender
{
    
    if (_contactArray.count == 0) {
        //        [self makeToast:@"暂无联系人搜索"];
        return;
    }
    
    _inSearching = YES;
    [self.tableView reloadData];
    _searchBar.hidden = NO;
    _searchButton.hidden = YES;
    _searchWidthLayoutConstraint.constant = CGRectGetWidth(self.view.bounds);
    [_searchBar becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            [_titleView layoutIfNeeded];
                            [_searchBar setShowsCancelButton:YES];
                        } completion:^(BOOL finished) {
                            
                        }];
}

-(IBAction)segmentSwitch:(id)sender{
    
}


- (void)insertKefuInArray:(NSMutableArray *)array
{
    NSDictionary *about = [[USER_AGENT config] objectForKey:@"about"];
    NSString *kefuPhone = [Tools newPhoneWithString:about[@"phone"]];
    if (!_hasKefu && kefuPhone) {
        _hasKefu = YES;
        ContactData *contact = [[ContactData alloc]init];
        contact.name = @"客服热线";
        PhoneData *pd = [PhoneData dataWithPhone:kefuPhone];
        contact.phoneArray = @[pd];
        contact.defaultPhoneData = pd;
        [[ContactUitl shareInstance] fitIndexsForContact:contact];
        contact.alpha = CONTACT_ALPHA_START;
        [array addObject:contact];
    }
}


//初始化本地联系人
- (void)initLocalContacts
{
    
    NSArray *allContacts = [[ContactUitl shareInstance] allContacts];
    NSMutableArray *contacts = [NSMutableArray arrayWithArray:allContacts];
    [self insertKefuInArray:contacts];
    //按名字排序每个表中的数据
    //self.searchDisplayController.searchBar.placeholder = [NSString stringWithFormat:@"共有%d个联系人", _contactArray.count];
    _contactArray = contacts;
    NSLog(@"contactArray count = %lu", contacts.count);
    
    /*
     将所有的联系人,按首字母分组
     */
    _contactDictionary = [[NSMutableDictionary alloc]init];
    for (ContactData *qc in contacts) {
        NSString *key = qc.alpha;
        NSMutableArray *sectionArray = [_contactDictionary objectForKey:key];
        if (sectionArray == nil) {
            sectionArray = [[NSMutableArray alloc]init ];
            [_contactDictionary setValue:sectionArray forKey:key];
        }
        [sectionArray addObject:qc];
    }
    
    _contactKeys = [[_contactDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2){
        
        if ([obj1 isEqual: CONTACT_ALPHA_START]) {
            return NSOrderedAscending;
        }
        else if([obj2 isEqual: CONTACT_ALPHA_START])
        {
            return NSOrderedDescending;
        }
        if([obj1 isEqual: CONTACT_ALPHA_POUND])
        {
            return NSOrderedDescending;
        }
        if ([obj2 isEqual: CONTACT_ALPHA_POUND]) {
            return NSOrderedAscending;
        }
        return [obj1 compare:obj2];
    }];
    
    _sectionIndexDictionary = [[NSMutableDictionary alloc]init];
    int prevIndex = 0;
    for (NSString *key in _contactKeys) {
        [_sectionIndexDictionary setObject:[NSNumber numberWithInt:prevIndex] forKey:key];
        NSArray *array = [_contactDictionary objectForKey:key];
        prevIndex += [array count];
    }
    
    [self.tableView reloadData];
    
    //    [self updateArea];
}
/*
 //更新联系人归属地
 - (void)updateArea
 {
 AreaHelper *helper = [AreaHelper sharedAreaHelper];
 if (![helper isLoaded]) {
 return;
 }
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
 
 for (ContactData *contact in _contactArray)
 {
 for (PhoneData *phone in contact.phoneArray) {
 if (phone.area) {
 continue;
 }
 phone.area = [helper queryByPhone:phone.phone];
 }
 }
 dispatch_sync(dispatch_get_main_queue(), ^{
 [_tableView reloadData];
 });
 });
 }
 
 - (void)areaNotification:(NSNotification *)notify
 {
 [self updateArea];
 }*/


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_inSearching)
    {
        ContactData *cd = _filteredListContent[indexPath.row];
        [self callPhone:cd.searchPhoneData.phone];
    }
    else{
        ContactData *cd = [self selectedContactAtIndexPath:indexPath];
        if (cd.phoneArray.count == 1) {
            [self callPhone:cd.defaultPhoneData.phone];
        }
        else{
            
        }
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_inSearching) {
        return 1;
    }
    return _contactKeys.count;
}

- (ContactData *)selectedContactAtIndexPath:(NSIndexPath *)indexPath
{
    ContactData *contact;
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    
    NSString *key = [_contactKeys objectAtIndex:section];
    NSArray *array = [_contactDictionary objectForKey:key];
    contact = [array objectAtIndex:row];
    
    return contact;
}

- (NSArray *)arrayAtSection:(int)section
{
    NSString *key = [_contactKeys objectAtIndex:section];
    NSArray *array = [_contactDictionary objectForKey:key];
    return array;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_inSearching) {
        return [_filteredListContent count];
    }
    else
    {
        
        NSString *key = [_contactKeys objectAtIndex:section];
        NSArray *array = [_contactDictionary objectForKey:key];
        return [array count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactData *contact = nil;
    BOOL searchMode = NO;
    int rowsplit = 0;
    NSString *alpha = @"";
    
    if (_inSearching) {
        contact = [_filteredListContent objectAtIndex:indexPath.row];
        searchMode = YES;
        rowsplit = indexPath.row;
    }
    else
    {
        NSArray *array = [self arrayAtSection:indexPath.section];
        contact =  [array objectAtIndex:indexPath.row];
        
        NSString *key = [_contactKeys objectAtIndex:indexPath.section];
        //        NSNumber *indexs = _sectionIndexDictionary[key];
        //        rowsplit = indexs.integerValue + indexPath.row;
        alpha = indexPath.row == 0 ? key : @"";//只是第一行显示ALPHA
    }
    ContactsCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ContactsCell"];
    if (cell == nil) {
        cell = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactsCell"];
    }
    cell.searchMode = searchMode;
    cell.contact = contact;
    cell.alphaLabel.text = alpha;
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneArray[0];
    
    return cell;
}

//索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_inSearching) {
        return nil;
    }
    NSMutableArray *keys = [[NSMutableArray alloc]initWithArray:_contactKeys];
    
    if (keys.count > 0) {
        [keys insertObject:UITableViewIndexSearch atIndex:0];//添加一个搜索的索引
    }
    return keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //添加此方法。。用于修改添加了搜索KEY后面索引修正
    if (index == 0) {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    return index - 1;//正常的KEY减去搜索那边的偏移
}

#pragma mark - Content Filtering Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideSearchbar:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (!_filteredListContent) {
        _filteredListContent = [[NSMutableArray alloc]init];
    }
    
    
    /*
     Update the filtered array based on the search text and scope.
     */
    
    [_filteredListContent removeAllObjects]; // First clear the filtered array.
    
    if (searchText == nil || searchText.length == 0) {
        [self.tableView reloadData];
        return;
    }
    
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (ContactData *qc in _contactArray)
    {
        if ([qc compareKeywords:searchText]) {
            [_filteredListContent addObject:qc];
        }
        
    }
    [self.tableView reloadData];
}



#pragma mark - fix  _UISearchDisplayControllerDimmingView 64

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    if (sysVersion >= 7.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixSearchControllerPositionOnKeyboardAppear)
    //                                                     name:UIKeyboardWillShowNotification object:nil];
    //
    //        if (_displayController.isActive) {
    //            // the following is needed if you are return to this controller after dismissing the child controller displayed after selecting one of the search results
    //            [self performSelector:@selector(fixSearchControllerPositionForiOS7) withObject:nil afterDelay:0];
    //        }
    //    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)fixSearchControllerPositionForiOS7 {
    UIView *view = _displayController.searchResultsTableView.superview;
    // only perform hack if the searchResultsTableView has been added to the view hierarchy
    if (view) {
        
        // The searchDisplayController's container view is already at 0,0, but the table view if shifted down 64px due to
        // bugs with the subviews in iOS 7, so shift the container back up by that negative offset.
        // This also fixes the position of the dimmed overlay view that appears before results are returned.
        CGFloat yOffset = 64.0;
        CGRect viewFrame = view.frame;
        if (CGRectGetMinY(viewFrame) == 0) {
            viewFrame.origin.y = -yOffset;
            viewFrame.size.height += yOffset;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                view.frame = viewFrame;
            } completion:nil];
        }
        
        // we also need to adjust dimmed overlay view, so iterate through the search view controller's container
        // view and make sure all subviews have their vertical origin set to 0
        UIView *searchContainerView = view.superview;
        for (NSInteger i = 0; i < [searchContainerView.subviews count]; i++) {
            UIView *subview = searchContainerView.subviews[i];
            if (CGRectGetMinY(subview.frame) > 0) {
                CGRect subviewFrame = subview.frame;
                CGFloat offset = CGRectGetMinY(subviewFrame);
                subviewFrame.origin.y = 0;
                
                if (offset == 20.0) {
                    // this subview is partially responsible for the table offset and overlays the top table rows, so set it's height to 0
                    subviewFrame.size.height = 0;
                }
                else {
                    // this subview is the dimmed overlay view, so increase it's height by it's original origin.y so it fills the view
                    subviewFrame.size.height += offset;
                }
                subview.frame = subviewFrame;
            }
        }
    }
}

- (void)fixSearchControllerPositionOnKeyboardAppear {
    // call hack to reset position after a slight delay to avoid UISearchDisplayController from overriding our layout fixes
    [self performSelector:@selector(fixSearchControllerPositionForiOS7) withObject:nil afterDelay:0.1];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    if (sysVersion >= 7.0) {
        [self fixSearchControllerPositionForiOS7];
    }
}


#pragma mark - scrollview
/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 NSArray *array = [_tableView indexPathsForVisibleRows];
 NSLog(@"-----------");
 for (NSIndexPath *index in array) {
 NSLog(@"indexpath (%d,%d)", index.section, index.row);
 }
 }
 */



@end
