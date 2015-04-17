//
//  WXTMessageCenterVC.h
//  RKWXT
//
//  Created by app on 4/17/15.
//  Copyright (c) 2015 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTMessageCenterVC : BaseVC<UITableViewDataSource,UITableViewDelegate>{
    UITableView * msgTableView;
}

@end
