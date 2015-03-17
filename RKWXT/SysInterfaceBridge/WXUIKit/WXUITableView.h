//
//  WXUITableView.h
//  WoXin
//
//  Created by le ting on 4/21/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXUITableView : UITableView


- (void)setBackgroundImage:(UIImage*)image;
- (void)reloadRowsAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
@end
