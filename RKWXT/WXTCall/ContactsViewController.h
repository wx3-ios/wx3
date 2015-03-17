//
//  ContactsViewController.h
//  GjtCall
//
//  Created by jjyo.kwan on 14-6-3.
//  Copyright (c) 2014年 jjyo.kwan. All rights reserved.
//

#import "BaseViewController.h"
#import "UserAgent.h"
@interface ContactsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate>{
    
    UISearchDisplayController * searchDisplayController;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeightLayoutConstraint;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIView *authorizedView;//是否授权

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchWidthLayoutConstraint;
@end
