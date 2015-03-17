//
//  WXUISearchDisplayController.m
//  CallTesting
//
//  Created by le ting on 5/20/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXUISearchDisplayController.h"

@implementation WXUISearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated{
    [super setActive:visible animated:animated];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if(isIOS7){
        UITableView *tableView = self.searchResultsTableView;
        [tableView setFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH+IPHONE_STATUS_BAR_HEIGHT, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT -(NAVIGATION_BAR_HEGITH+IPHONE_STATUS_BAR_HEIGHT))];
        WXUIViewController *searchContentsController = (WXUIViewController*)self.searchContentsController;
        if([searchContentsController isKindOfClass:[WXUIViewController class]]){
            [searchContentsController.view bringSubviewToFront:searchContentsController.cstNavigationView];
        }
    }
#endif
}

@end
